#!/usr/bin/ruby
# Loading main library
require "./mcsanc"
# Loading files with specific configs
require "./input.cfg_iborn-0"
require "./ewparam.cfg_all"

# Next turn-on the MCSANCinput::Helper module 
include MCSANCinput::Helper

#Create default configs 
input=MCSANCinput.new
ewparam=MCSANCewparam.new

#Override them with specific configs from loaded files. 
#ruby can extend objects with constants and methods saved in Module structure, 
#here we extend our configs using Modules described in *input.cfg_iborn-0.rb* and *ewparam.cfg_all.rb*

input.extend Input_BinByBin_def
ewparam.extend EW_BinByBin_def
#The idea is that these loaded configs describe a general setup for the task: constants, bins and other stuff.
#Finaly we need to fine tune the configs for our current job 
input.add {
  @iflew[IBORN]=1
  @relAcc= 1e-3
  @absAcc= 1e-8
}

#Now we want to make bin_by_bin setup
bins_input=input.bin_by_bin('m34')
#bins_input here is an array of inputs

#Here is an example of center bin scale.
#For each input we make a copy of +ewparam+ and modify its scales.
#Then in the end of block we create a session( MCSANC_Session.new ).
#We use map method for bins_inputs array - it returns an array of 
#elements returned by the block - in this case an array of sessions.
sessions=bins_input.map{|bin_input|
  session_path=MCSANC_Session.share+"bin_#{bin_input.vbh_bins[1]*'_'}"
  bin_ewparam=ewparam.copy
  bin_ewparam.fscale= (bin_input.vbh_bins[1][1]+bin_input.vbh_bins[1][0])/2.0
  bin_ewparam.rscale= (bin_input.vbh_bins[1][1]+bin_input.vbh_bins[1][0])/2.0
  MCSANC_Session.new(bin_input,bin_ewparam,session_path)
}

#Run all sessions together with cubacores=1 
MCSANC_Session.bunch_run(sessions,sessions.size,1)

# To make a test run we can use run_onscreen 
#sessions[0].run_onscreen

#After the jobs are done we want to set born absolute precision for other parts in all sessions.
#For each session we parse output and change input using parsed value.
sessions.each { |s|
		s.read_output
		s.input.add {
		  @iflew[IBORN]= 0
		  @absAcc= s.output.result.sigma.born.error/10.0
		  @relAcc= 1e-8
	}
}

# Finaly we run modified sessions again
MCSANC_Session.bunch_run(sessions,sessions.size,1) # all procs in bunch with CUBACORES=1

