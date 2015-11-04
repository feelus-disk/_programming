require "lib/config_gen"
# Class for generation of MCSANC *input.cfg* file using *input.cfg.erb* template. 
# It inherits methods from +Config_gen+ class.
# By default the standard *input.cfg* is generated, use #add method to override it.
# One can also wrap config in Module and later extend config with it. 
# See *bins.rb* example and 
# *input.cfg_iborn-0.rb* for details.
#
# All config variables have corresponding get/set methods, for example
#   input=MCSANCinput.new
#   input.run_tag= "my_tag" # set run_tag
#   input.vbh_bins[1]=[ 66e0, 116e0] # set bins for the first histogram
#   puts input.relAcc # print relative precision
#
# Also some helpers are provided to make configuration process easier.

class MCSANCinput < Config_gen
  # config variable
  attr_accessor :processId, :run_tag, :sqs0, :beams, :pdfSet, :pdfMember, :iflew, :iflqcd, \
    :imsb, :irecomb, :relAcc, :absAcc, :nStart, :nIncrease, :nExplore, :maxEval, :seed, \
    :flags, :cutName, :cutFlag, :cutLow, :cutUp, :fbh_name, :fbh_flag, :fbh_low, :fbh_up, \
    :fbh_step, :nvbh, :vbh_name, :vbh_flag, :vbh_bins

  #Besides the precision set by absAcc and relAcc one can set +timeout+ for the job. This parameter does not
  #propagate to input.cfg itself, but it is used in +run+ (and consequently in +bunch_run+) 
  #method to terminate the job at time. +timeout+ is a String with a floating point number followed by an optional unit:
  #*    's' for seconds (the default)
  #*    'm' for minutes
  #*    'h' for hours
  #*    'd' for days
  #
  #for example 
  #
  #  input=MCSANCinput.new
  #  input.add {
  #    @timeout="1.5h"
  #  }
  #  # or
  #  input.timeout="1d"
  #
  #If the job is terminated due the timeout new mcsanc run is initiated to finish the job correctly 
  #with precision achieved.
  attr_accessor :timeout

  # comment header in config
  #  input=MCSANCinput.new
  #  input.comment= "This is the head of input.cfg, 
  #  it can be used to describe your job"
  attr_accessor :comment

# helper module with constants for flags
#    include MCSANCinput::Helper
#    input=MCSANCinput.new {
#       @iflew[IBORN]=TOTAL #override default iflew[2]
#       @iflew[IQED]=FULL_QED
#       @imsb=DIS
#    }
# compare with example for MCSANCinput.new
  module Helper

    #   MCSANCinput.new {
    #     @iflew[IBORN]=TOTAL
    #   }
    #
    #:section: @iflew index flags.

    IQED=0
    IEW=1
    IBORN=2
    IFGG=3
    IRUN=4
    IPH=5

    # :section: @iflew[IBORN] flags.
    BORN=0
    TOTAL=1
    CORRECTION=-1

    # :section: @iflew[IQED] flags.
    NO_QED=0
    FULL_QED=1
    ISR=2
    IFI=3
    FSR=4
    IFI_FSR=5
    ISR_IFI=6

    # :section: @imsb flags.
    NONE=0
    MSBAR=1
    DIS=2
    # :section:
  end

# Initialize new input config, takes block as argument and pass it to #add.
#   input=MCSANCinput.new
#   input=MCSANCinput.new {
#     @iflew[2]=1 #override default iflew[2]
#   }
  def initialize(&blk)
    #------------------------- default config
    processId	= "002"
    run_tag	= 'DY_NC_NLO_EW_mu'
    sqs0     	= 8000e0
    beams	        = [1,1]

    #pdfSet	= 'MSTW2008nlo90cl.LHgrid'
    pdfSet	= 'MRST2004qed.LHgrid'
    pdfMember	= 0

    #   electroweak flags
    #                 iqed, iew, iborn, ifgg, irun, iph
    iflew         =   [1,   1,    0,    1,    0,   1]
    #   qcd flags
    iflqcd        =    0
    #   subtraction scheme 0/1/2 : none/MSbar/DIS
    imsb		= 2
    #   collinear particle recombination in calorimeter
    irecomb       = 0

    # VegasPar
    relAcc	= 1e-8
    absAcc	= 5e-1
    nStart	= 1000000
    nIncrease	= 100000
    nExplore	= 1000000000
    maxEval	= 2100000000000
    seed	        = 42
    flags 	= 26

    # KinCuts
    cutName	= ['m34', 'mtr',	'pt3',	'pt4',	'eta3',	'eta4',	'dR']
    cutFlag = [   1,      0,      1,       1,       1,       1,       0 ]
    cutLow	= [50e0,	 0e0,	25e0,	25e0,	-2.5e0,	-2.5e0, 0e0]
    cutUp		= [8e3,   8e3,	8e3,	8e3,	2.5e0,	2.5e0,  1e-1]

    # particle numbering 1+2 -> 3+4+5+... ( FIXME )
    #FixedBinHist
    fbh_name	= ['m34','mtr','pt34',	'pt3',	'pt4', 'eta34', 'eta3', 'eta4', 'phis','incl', 'forw', 'back']
    fbh_flag	= [3,	0,     3,       3,      3,     3,      0,      0,     3,     1, 0,0]
    fbh_low	= [ 50e0, 20e0,  0e0,	25e0,	25e0, -2.5e0, -2.5e0, -2.5e0, 0.0e0, 50e0, 50e0,50e0]
    fbh_up	= [200e0,70e0,  25e0,	65e0,	65e0,  2.5e0,  2.5e0,  2.5e0, 0.4e0, 8e3, 200e0,200e0]
    fbh_step	= [1e0,	1e0,   0.25e0,	0.25e0,	0.25e0, 0.1e0,  0.1e0,  0.1e0, 0.01e0,7.55e3,1e0,1e0]

    #VarBinHist
    nvbh         	= 12
    vbh_name=[]
    vbh_flag=[]
    vbh_bins=[]
    vbh_name[1]	= 'm34'
    vbh_flag[1]	= 0
    vbh_bins[1] = [20e0,30e0,50e0,70e0,90e0,110e0,130e0,150e0,200e0,300e0,400e0,500e0,1000e0,1500e0]

    vbh_name[2]	= 'mtr'
    vbh_flag[2]	= 0
    vbh_bins[2] = [20e0, 30e0, 50e0, 70e0, 90e0, 110e0, 130e0, 150e0, 200e0, 300e0, 400e0, 500e0, 1000e0, 1500e0]

    vbh_name[3]	= 'pt34'
    vbh_flag[3]	= 0
    vbh_bins[3] = [0.00e0,0.25e0]

    vbh_name[4]	= 'pt3'
    vbh_flag[4]	= 0
    vbh_bins[4] = [0e0, 0.2e0, 0.4e0, 0.6e0, 0.8e0, 1e0, 1.2e0, 1.4e0, 1.6e0, 1.8e0, 2.0e0, 2.5e0]

    vbh_name[5]	= 'pt4'
    vbh_flag[5]	= 0
    vbh_bins[5] = [0e0, 0.2e0, 0.4e0, 0.6e0, 0.8e0, 1e0, 1.2e0, 1.4e0, 1.6e0, 1.8e0, 2.0e0, 2.5e0, 2.6e0]

    vbh_name[6]	= 'eta34'
    vbh_flag[6]	= 0
    vbh_bins[6] = [0.00e0, 0.25e0]

    vbh_name[7]	= 'eta3'
    vbh_flag[7]	= 0
    vbh_bins[7] = [0e0, 0.21e0, 0.42e0, 0.63e0, 0.84e0, 1.05e0, 1.37e0, 1.52e0, 1.74e0, 1.95e0, 2.18e0, 2.50e0]

    vbh_name[8]	= 'eta4'
    vbh_flag[8]	= 0
    vbh_bins[8] = [0e0, 0.21e0, 0.42e0, 0.63e0, 0.84e0, 1.05e0, 1.37e0, 1.52e0, 1.74e0, 1.95e0, 2.18e0, 2.50e0, 2.60e0]

    vbh_name[9]	= 'phis'
    vbh_flag[9]	= 0
    vbh_bins[9] = [0.00e0, 0.25e0]

    vbh_name[10]	= 'incl'
    vbh_flag[10]	= 0
    vbh_bins[10] =  [50e0, 8e3]

    vbh_name[11]	= 'forw'
    vbh_flag[11]	= 0
    vbh_bins[11] = [ 20e0,30e0,50e0,70e0,90e0,110e0,130e0,150e0,200e0,300e0,400e0,500e0,1000e0,1500e0 ]

    vbh_name[12]	= 'back'
    vbh_flag[12]	= 0
    vbh_bins[12] = [ 20e0, 30e0, 50e0, 70e0, 90e0, 110e0, 130e0, 150e0, 200e0, 300e0, 400e0, 500e0, 1000e0, 1500e0]

    #-------------------------------- end of default config
    
    @processId	=processId	
    @run_tag	=run_tag	
    @sqs0     	=sqs0     	
    @beams	        =beams	        
    @pdfSet	=pdfSet	
    @pdfMember	=pdfMember	
    @iflew         =iflew         
    @iflqcd        =iflqcd        
    @imsb		=imsb		
    @irecomb       =irecomb       
    @relAcc	=relAcc	
    @absAcc	=absAcc	
    @nStart	=nStart	
    @nIncrease	=nIncrease	
    @nExplore	=nExplore	
    @maxEval	=maxEval	
    @seed	        =seed	        
    @flags 	=flags 	
    @cutName	=cutName	
    @cutFlag =cutFlag 
    @cutLow	=cutLow	
    @cutUp		=cutUp		
    @fbh_name	=fbh_name	
    @fbh_flag	=fbh_flag	
    @fbh_low	=fbh_low	
    @fbh_up	=fbh_up	
    @fbh_step	=fbh_step	
    @nvbh         	=nvbh         	
    @vbh_name=vbh_name
    @vbh_flag=vbh_flag
    @vbh_bins=vbh_bins
    @comment=""
    super
    @template="#{File::dirname __FILE__}/input.cfg.erb"
    @filename="input.cfg"
  end

  # \Helper method to create bin by bin distributions
  #
  # arguments: 
  #
  # * distribution by index in vbh_* arrays or name as given in vbh_name
  #
  # * run_tag for bins distributions, skip it to leave the same tag as in original input config
  #
  # Return the array of input configs with corresponding bins
  #
  #  input=MCSANCinput.new
  #  inputs=input.bin_by_bin(1)
  #  inputs=input.bin_by_bin('m34') # the same, but select distribution by name
  #  inputs=input.bin_by_bin('m34', input.run_tag+"m34") # the same, but we modify run_tag also
  #
  def bin_by_bin(distr,tag=@run_tag)
    if distr.class==Fixnum then
      vbh_index=distr
      dist_name=@vbh_name[distr]
    else
      vbh_index=@vbh_name.find_index(distr.to_s) if not distr.class==Fixnum
      dist_name=distr
    end
    (start_bins=@vbh_bins[vbh_index].dup).pop
    (end_bins=@vbh_bins[vbh_index].dup).shift
    bins=start_bins.zip(end_bins)
    bins.map!{|bin| 
      c=copy
      c.run_tag=tag
      c.vbh_bins[vbh_index]=bin
      c.cut dist_name, bin[0], bin[1]
      c
    }
  end

  # \Helper method to ease the cuts settings
  #
  # arguments: 
  #
  # * name of distribution as given in vbh_name
  # 
  # * lowCut
  #
  # * upCut
  #
  # Return the array [@cutLow, @cutUp]
  #
  #   input=MCSANCinput.new
  #   input.cut('m34',66e0,5000e0) 
  #   input.add {  # or in add() method
  #     cut('m34',66e0,5000e0)
  #   }
  def cut(name,low,up)
    cut_index=@cutName.find_index(name)
    @cutUp[cut_index]=up
    @cutLow[cut_index]=low
    [low,up]
  end

end
