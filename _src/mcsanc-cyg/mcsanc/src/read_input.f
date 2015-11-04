!++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
!> Reads input.cfg and sets flags and parameters, initializes histograms
!<-------------------------------------------------------------
      subroutine read_input

      implicit none

      include 'compounds.h'
      include 'process.h'
      include 'kin_cuts.h'
!      include 'histogram.h'
      include 'vegas.h'
!      include 'calo.h'
      
C=================================================================

C Define namelists

C Process description name list
      namelist/Process/ processId, run_tag, sqs0, beams,
     $    PDFSet, PDFMember, iflew, iflqcd, imsb, irecomb

C Vegas algorithm parameters
      namelist/VegasPar/ relAcc, absAcc, nStart, nIncrease, 
     $    maxEval, seed, flags, nExplore

C Kinematic cuts
      namelist/KinCuts/ cutName, cutFlag, cutLow, cutUp 

C Fixed bin histogramms
      integer maxbins, maxfbh, maxvbh
      parameter (maxbins = 200)
      parameter (maxfbh = 100)
      parameter (maxvbh = 100)
      character*32 fbh_name(maxfbh)
      integer fbh_flag(maxfbh)
      double precision fbh_low(maxfbh), fbh_up(maxfbh), fbh_step(maxfbh)
      namelist/FixedBinHist/ fbh_name, fbh_flag, fbh_low, fbh_up, fbh_step

C Variable bin histograms
      character*32 vbh_name(maxvbh)
      integer nvbh, vbh_nbins(maxvbh), vbh_flag(maxvbh)
      double precision vbh_bins(maxvbh, maxbins+1)
      namelist/VarBinHist/ nvbh, vbh_name, vbh_flag, vbh_nbins, vbh_bins

C Inner variables
      integer ic, ih
      character*256 input_file_cfg
      character*4 bc_tag ! ='bare'/'calo' tag

C----------------------------------------------------------------



C  ***
C  
C  Initialize the parameters
C
C  ***


C  Process
      processId		= 1
      run_tag		= ''
      sqs0        	= 7000d0
      beams(1)		= 1
      beams(2)		= 1
      iflew(1)		= 1
      iflew(2)		= 1
      iflew(3)		= 0
      iflew(4)		= 1
      iflew(5)		= 1
      iflqcd		= 0
      imsb 		= 1
      irecomb             = 0
      PDFSet		= 'cteq6ll.LHpdf'
      PDFMember		= 1

C  Vegas 
      relAcc		= 1d0
      absAcc		= 0.1d0
      nStart		= 1000
      nIncrease		= 1000
      nExplore		= 10*nStart
      maxEval		= 100000
      seed		= 42
      flags		= 26

      do ic = 1,maxKinCuts
        cutName(ic) = repeat(' ', len(cutName(ic)))
        cutName(ic) = ''
	cutFlag(ic) = 0
        cutLow(ic) = 0d0
        cutUp(ic) = 0d0
      enddo

      do ih=1,maxfbh
        fbh_name(ih) = repeat(' ', len(fbh_name(ih)))
        fbh_name(ih) ='' 
      enddo

      do ih=1,maxvbh
        vbh_name(ih) = repeat(' ', len(vbh_name(ih)))
        vbh_name(ih) ='' 
      enddo

C-----------------------------------------------------------------

C Get input filename
      call get_command_argument(1,input_file_cfg)
      if (LEN_TRIM(input_file_cfg) .eq. 0) input_file_cfg='input.cfg'

      PDFSet = ''
C Read the namelists
      open (51, file=trim(input_file_cfg), status='old')
      read (51, NML=Process, END=41, ERR=42)
      read (51, NML=VegasPar, END=43, ERR=44)
      read (51, NML=KinCuts, END=45, ERR=46)
 45   continue
      read (51, NML=FixedBinHist, END=47, ERR=48)
 47   continue
      read (51, NML=VarBinHist, END=49, ERR=50)
 49   continue

      call check_pid()

      if (beams(1) .ne. 1 .or. beams(2) .ne. 1) then
        print *, 'No collisions other than pp are supported yet. Exit.'
	call exit
      endif


C Init the histograms
C     fixed bin size
      bc_tag = 'bare'
      if (irecomb .eq. 1 ) bc_tag = 'calo'
      do ih=1,maxfbh
        if ( fbh_name(ih) .eq. '') goto 52
        call set_fbh(trim(fbh_name(ih))//'-'//bc_tag//'-fix'//CHAR(0), 
     &    fbh_flag(ih), fbh_low(ih), fbh_up(ih), fbh_step(ih))
      enddo

 52   continue
C     calo histograms for fbh
      if (irecomb .eq. 2 ) then
        do ih=1,maxfbh
          if ( fbh_name(ih) .eq. '') goto 53
          call set_fbh(trim(fbh_name(ih))//'-calo-fix'//CHAR(0), 
     &    fbh_flag(ih), fbh_low(ih), fbh_up(ih), fbh_step(ih))
        enddo
       
 53     continue
      endif
      
C     variable bin size
      do ih = 1,nvbh
        call set_vbh(trim(vbh_name(ih))//'-'//bc_tag//'-var'//CHAR(0), 
     &               vbh_flag(ih), vbh_nbins(ih), vbh_bins(ih,:))
      enddo

C     cal histograms for vbh
      if (irecomb .eq. 2 ) then
        do ih = 1,nvbh
          call set_vbh(trim(vbh_name(ih))//'-calo-var'//CHAR(0), 
     &                 vbh_flag(ih), vbh_nbins(ih), vbh_bins(ih,:))
        enddo
      endif

      PDFSet = trim(PDFSet)

      call read_ewpars

C     set vegas mineval so that we have at least two iterations
C     to fill the histogramms, which are not filled during first one
      minEval = nStart+1

      goto 83

 41   continue
      print '(''Namelist &Process NOT found'')'
      goto 81
 42   continue
      print '(''ERROR reading &Process namelist'')'
      goto 81
 43   continue
      print '(''Namelist &VegasPar NOT found'')'
      goto 81
 44   continue
      print '(''ERROR reading &VegasPar namelist'')'
      goto 81
 46   continue
      print '(''ERROR reading &KinCuts namelist'')'
      goto 81
 48   continue
      print '(''ERROR reading &FixedBinHist namelist'')'
      goto 81
 50   continue
      print '(''ERROR reading &VarBinHist namelist'')'

 81   call exit

 83   continue

      end


!++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
!> Cheks if requested proces id's are implemented
!<-------------------------------------------------------------
      subroutine check_pid()

      implicit none

      include 'process.h'

      integer ipid

      do ipid = 1,npid
        if( processId .eq. pid_array(ipid) )  goto 101
      enddo

      print *, 'Process ', processId, 'not implemented. Exit.'
      call exit
      
101   continue

      print *, ''
      print *, repeat('#', len(trim(pnames(ipid)))+12)
      print *, '#     ',repeat(' ',len(trim(pnames(ipid)))), '     #'
      print *, '#     ',trim(pnames(ipid)), '     #'
      print *, '#     ',repeat(' ',len(trim(pnames(ipid)))), '     #'
      print *, repeat('#', len(trim(pnames(ipid)))+12)
      print *, ''

      end
