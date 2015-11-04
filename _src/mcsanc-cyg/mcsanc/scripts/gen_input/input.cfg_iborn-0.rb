#!/usr/bin/ruby
module Input_BinByBin_def
  def self.extended(base) 
    base.add {
      @processId= "-102"
      @run_tag= 'DY_CC_INPH_mm_HO_PDF1_m34_dyn_all'
      @sqs0= 8000e0
      @beams= [1,1]

      #PDFSet	= 'MSTW2008nlo90cl.LHgrid'
      @pdfSet= 'MRST2004qed.LHgrid'
      #PDFSet	= 'MRST2004qed2p.LHgrid_test'
      #PDFSet	= 'NNPDF23_nlo_as_0117_qed.LHgrid'
      @pdfMember= 0

      # electroweak flags
      #               iqed, iew, iborn, ifgg, irun, iph
      @iflew= [   1,   1,    0,    1,    0,   1 ]
      # qcd flags
      @iflqcd=    0
      # subtraction scheme 0/1/2 : none/MSbar/DIS
      @imsb= 2
      # collinear particle recombination in calorimeter
      @irecomb= 0

      #VegasPar
      @relAcc= 1e-8
      @absAcc= 2e-1
      @nStart= 10000000
      @nIncrease= 5000000
      @nExplore= 300000000
      @maxEval= 2100000000000
      @seed= 42
      @flags= 26

      #KinCuts
      @cutName= [ 'm34', 'mtr',	'pt3',	'pt4',	'eta3',	'eta4',	'dR'  ]
      @cutFlag= [ 1,     0,     1,      1,       1,      0,   0 ]
      @cutLow= [ 66e0,	 2355e0,35e0,	25e0,  -2.5e0, -2.5e0, 	0e0 ]
      @cutUp= [ 5000e0,2843e0,8e3,	8e3,	2.5e0,	2.5e0, 	1e-1 ]


      # particle numbering 1+2 -> 3+4+5+... ( FIXME )
      #FixedBinHist
      @fbh_name= [ 'm34','mtr','pt34',	'pt3',	'pt4', 'et34', 'et3', 'et4', 'phis','incl','forw','back' ]
      @fbh_flag= [ 0,	0,     0,       0,      0,     0,      0,      0,     0,     0, 0, 0 ]
      @fbh_low= [ 50e0, 20e0,  0e0,	25e0,	25e0, -2.5e0, -2.5e0, -2.5e0, 0.0e0, 50e0, 50e0, 50e0 ]
      @fbh_up= [ 200e0,70e0,  25e0,	65e0,	65e0,  2.5e0,  2.5e0,  2.5e0, 0.4e0, 8e3, 200e0, 200e0 ]
      @fbh_step= [ 1e0,	1e0,   0.25e0,	0.25e0,	0.25e0, 0.1e0,  0.1e0,  0.1e0, 0.01e0,7.55e3, 1e0, 1e0 ]

      #VarBinHist
      @nvbh= 12

      @vbh_name[1]	= 'm34'
      @vbh_flag[1]	= 3
      @vbh_bins[1] = [ 66e0, 116e0, 140e0, 169e0, 204e0, 246e0, 297e0, 359e0, 433e0, 522e0, 631e0, 761e0, 919e0, 1110e0, 1339e0, 1617e0, 1951e0, 2355e0, 2843e0, 3432e0, 4142e0, 5000e0 ]

      @vbh_name[2]	= 'mtr'
      @vbh_flag[2]	= 0
      @vbh_bins[2] = [ 2355e0, 2843e0 ]

      @vbh_name[3]	= 'pt34'
      @vbh_flag[3]	= 0
      @vbh_bins[3] = [ 0.00e0, 0.25e0 ]

      @vbh_name[4]	= 'pt3'
      @vbh_flag[4]	= 0
      @vbh_bins[4] = [ 0e0, 0.2e0, 0.4e0, 0.6e0, 0.8e0, 1e0, 1.2e0, 1.4e0, 1.6e0, 1.8e0, 2.0e0, 2.5e0 ]

      @vbh_name[5]	= 'pt4'
      @vbh_flag[5]	= 0
      @vbh_bins[5] = [ 0e0, 0.2e0, 0.4e0, 0.6e0, 0.8e0, 1e0, 1.2e0, 1.4e0, 1.6e0, 1.8e0, 2.0e0, 2.5e0, 2.6e0 ]

      @vbh_name[6]	= 'et34'
      @vbh_flag[6]	= 0
      @vbh_bins[6] = [ 0.00e0, 0.25e0 ]

      @vbh_name[7]	= 'et3'
      @vbh_flag[7]	= 0
      @vbh_bins[7] = [ 0e0, 0.21e0, 0.42e0, 0.63e0, 0.84e0, 1.05e0, 1.37e0, 1.52e0, 1.74e0, 1.95e0, 2.18e0, 2.50e0 ]

      @vbh_name[8]	= 'et4'
      @vbh_flag[8]	= 0
      @vbh_bins[8] = [ 0e0, 0.21e0, 0.42e0, 0.63e0, 0.84e0, 1.05e0, 1.37e0, 1.52e0, 1.74e0, 1.95e0, 2.18e0, 2.50e0, 2.60e0 ]

      @vbh_name[9]	= 'phis'
      @vbh_flag[9]	= 0
      @vbh_bins[9] = [ 0.00e0, 0.25e0 ]

      @vbh_name[10]	= 'incl'
      @vbh_flag[10]	= 0
      @vbh_bins[10] = [ 50e0, 8e3 ]

      @vbh_name[11]	= 'forw'
      @vbh_flag[11]	= 0
      @vbh_bins[11] = [ 20e0,30e0,50e0,70e0,90e0,110e0,130e0,150e0,200e0,300e0,400e0,500e0,1000e0,1500e0 ]

      @vbh_name[12]	= 'back'
      @vbh_flag[12]	= 0
      @vbh_bins[12] = [ 20e0, 30e0, 50e0, 70e0, 90e0, 110e0, 130e0, 150e0, 200e0, 300e0, 400e0, 500e0, 1000e0, 1500e0]
    }
  end
end
