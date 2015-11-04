#!/usr/bin/ruby
$LOAD_PATH.unshift(File.expand_path(File.dirname(__FILE__))) unless $LOAD_PATH.include?(File.expand_path(File.dirname(__FILE__)))
require "lib/input_gen"
require "lib/ewparam_gen"
require "lib/output"

  #This class is responsible for running the mcsanc 
  #with given MCSANCinput and MCSANCewparam objects in different ways.
class MCSANC_Session

  # This constant keep the path to MCSANC root dir
  HOME=File::expand_path(File::dirname(__FILE__)+"/../..")+"/"

  @@share= HOME+"share/"
  #It keeps the deafault path for saving and running sessions *mcsanc/share*. 
  #You can overwrite it with your specific job directory path.
  def MCSANC_Session::share
    @@share
  end

  def MCSANC_Session::share=(arg)
    @@share=arg
  end



  attr_accessor :path, :input, :ewparam, :cubacores

  #It corresponds to MCSANC_Output
  #See usage of MCSANC_Session.read_output
  attr_reader :output

  # initialize new MCSANC_Session. 
  #
  # arguments:
  #
  # * input - MCSANCinput object, default is MCSANCinput.new
  # * ewparam - MCSANCewparam object, default is MCSANCewparam.new
  # * path - path for saving configs and running mcsanc. path is default mcsanc/share if skiped.
  # * cubacores - CUBACORES environment variable during run, undefined if skiped (CUBA uses all cores in this case)
  #    input=MCSANCinput.new
  #    ewparam=MCSANCewparam.new
  #    path="/home/user/working_dir"
  #    cubacores=4
  #    MCSANC_Session.new(input,ewparam,path,cubacores)
  def initialize(input=MCSANCinput.new,ewparam=MCSANCewparam.new,path=@@share,cubacores=nil) #{{{
    @path=path
    @input=input
    @ewparam=ewparam
    @cubacores=cubacores
  end
  #}}}
  
  # save all configs to given dir, or to path set in MCSANC_Session.new
  #
  #    input=MCSANCinput.new
  #    ewparam=MCSANCewparam.new
  #    session=MCSANC_Session.new(input,ewparam)
  #    session.save # save to mcsanc/share as default for MCSANC_Session.new
  #    session.save("/tmp") # save to /tmp
  def save(path=@path) #{{{
    @input.save(@path)
    @ewparam.save(@path)
    @path
  end
  #}}}

  # save configs to @path, start mcsanc for this session and detach it (script continues the execution)
  # You can override cubacores set in MCSANC_Session.new
  #
  #    input=MCSANCinput.new
  #    ewparam=MCSANCewparam.new
  #    session=MCSANC_Session.new(input,ewparam)
  #    session.run # start session, configs are in mcsanc/share, cubacores undefined(use all cores)
  #    session.run(1) # start session, configs are in mcsanc/share, use 1 core
  def run(cubacores=@cubacores) #{{{
    save
    pid= fork do
      ENV['CUBACORES']=cubacores.to_s if not cubacores.nil?
      mcsanc=HOME+"src/mcsanc"
      Dir.chdir @path
      exec "#{mcsanc} > /dev/null 2>&1" if @input.timeout.nil?
      system "timeout --foreground -s 9 #{@input.timeout} #{mcsanc} > /dev/null 2>&1" 
      if $?.exitstatus==137 or $?.exitstatus==124 then # timeout
        puts "Job with PID=#{$?.pid} is terminated due the timeout. Completing the job."
        self.input.relAcc=1.0
        self.input.timeout=nil
        self.input.comment=
"WARNING: the job was terminated due timeout.
The relAcc was changed"
        pid2=run(cubacores)
        Process.waitpid pid2
      end
      exit
    end
    puts "MCSANC is fired up in #{@path} with PID=#{pid}"
    pid
  end
  #}}}

  # same as run, but it doesnt detach. All mcsanc output goes on screen.
  # 
  #    input=MCSANCinput.new
  #    ewparam=MCSANCewparam.new
  #    session=MCSANC_Session.new(input,ewparam)
  #    session.run_onscreen # start session, configs are in mcsanc/share, cubacores undefined(use all cores)
  #    session.run_onscreen(1) # start session, configs are in mcsanc/share, use 1 core
  def run_onscreen(cubacores=@cubacores) #{{{
    save
      ENV['CUBACORES']=cubacores.to_s if not cubacores.nil?
      mcsanc=HOME+"src/mcsanc"
      Dir.chdir @path
      system "#{mcsanc}"
  end
  #}}}

  # This method allows you to run an array of MCSANC_Session in bunches. While the group is running, next group is waiting. Script execution is waiting for all sessions to finish. 
  #
  # arguments:
  #
  # * array of MCSANC_Session objects
  # * number of sessions in one bunch
  # * cubacores - you can override @cubacores set in MCSANC_Session.new
  #    input=MCSANCinput.new
  #    ewparam=MCSANCewparam.new
  #    inputs=input.bin_by_bin(1) # create array of inputs
  #    sessions=inputs.map { |inp|  # The map std method can be used to create a new array based on the original array
  #      MCSANC_Session.new(inp, ewparam) # the last object defined in block is the new element of sessions array, inp is corresponding element from inputs array
  #    }
  #    MCSANC_Session.bunch_run(sessions,4) # 4 runs in a bunch, default cubacores.
  #    MCSANC_Session.bunch_run(sessions,sessions.size,1) # all sessions run in one group, cubacores=1
  #
  def MCSANC_Session.bunch_run(array,nbunch,cubacores=nil) #{{{
    array=array.dup
    while not array.empty?
      bunch_array= array.shift nbunch
      pids=bunch_array.map{ |session| 
        pid= if cubacores.nil?
          session.run 
        else
          session.run cubacores
        end
      }
      pids.each{|pid| Process.waitpid pid}
    end
  end
  #}}}
  
  # the method run session to LIT cluster as a job
  #
  # arguments
  #
  # * number of cores. It is equal to @cubacores by default
  # * here one can provide a string with additional resource specification for batch system, like time, queue etc.
  def qsub(ncpu=@cubacores, qargs=nil) #{{{
    save
    cmd= %{qsub -l nodes=1:ppn=#{ncpu} #{qargs} -o "#{@path}/job_#{@input.run_tag}.out" -e "#{@path}/job_#{@input.run_tag}.err" <<EOF
#!/bin/bash
  export CUBACORES=#{ncpu}
  export MC_LIB="\\${TMPDIR}/mcsanc/lib"
  export LHAPATH="\\${MC_LIB}/PDFsets"
  export LD_LIBRARY_PATH="\\${LD_LIBRARY_PATH}:\\${MC_LIB}"
  scp -p2r $(hostname):#{HOME} "\\${TMPDIR}/mcsanc"
  mkdir "\\${MC_LIB}"
  scp -p2r $(hostname):"$(lhapdf-config --libdir)/libLHAPDF.so" "\\${MC_LIB}"
  scp -p2r $(hostname):"$(lhapdf-config --pdfsets-path)" "\\${MC_LIB}/PDFsets"
  cd "\\${TMPDIR}/mcsanc/share"
  rm -rf *
  scp -p2r $(hostname):#{@path}/input.cfg $(hostname):#{@path}/ewparam.cfg .
  ../src/mcsanc
  scp * $(hostname):#{@path}
EOF
}
    system cmd   
  end
  #}}}

  # after mcsanc job is finished, one can parse output with this method.
  # For now the only values read from output are born value and it's precision.
  # 
  # <b> Be careful with this method, you should use it only when you know, that the job is done.
  # It's safe to use it after run_onscreen or bunch_run methods as 
  # they suspend the script execution. </b>
  # 
  # Example ( find precision from Born run)
  #    input=MCSANCinput.new
  #    input.add {
  #      @iflew[IBORN]=1
  #      @absAcc=1e-8
  #      @relAcc=1e-3
  #    }
  #    ewparam=MCSANCewparam.new
  #    session=MCSANC_Session.new(input,ewparam)
  #    session.run_onscreen 
  #    session.read_output     # read output from session
  #    puts("Born: "+ session.output.result.sigma.born.value) # print parsed values
  #    puts("Precision: "+ session.output.result.sigma.born.error)
  #    session.add {
  #      @iflew[IBORN]=0
  #      @relAcc=1e-8
  #      @absAcc= session.output.result.sigma.born.error/10.0 # use precision from previous run
  #    }
  #    session.run_onscreen 
  #
  def read_output
    file="#{@path}/mcsanc-#{@input.run_tag}-output.xml"
    @output=MCSANC_Output.new(file)
  end

end
