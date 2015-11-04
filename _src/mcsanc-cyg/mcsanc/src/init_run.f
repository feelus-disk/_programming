!++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
!> Initializes MCSANC run
!<-------------------------------------------------------------

      subroutine init_run

C--------------------------------------------------------------
      implicit none

      external game_over

      include 'process.h'
      include 'kin_cuts.h'
      include 'stats.h'
      include 'vegas.h'
c      include 's2n_declare.h'

c     start clock
      call start_clock

c     Set kinematic cuts
      call set_kin_cuts

c     Initialize LoopTools
      call ffini

c     Initialize s2n variables
      call s2n_init

c     Initialize PDFS
      call InitPDFsetByName(PDFSet)
      call InitPDF(PDFMember)
      call GetMinMax(PDFMember,xmin,xmax,q2min,q2max)
      call SetLHAPARM('EXTRAPOLATE')

      call print_ewpars(6)
      call print_active_cuts(6)

      call set_sfbase

      nsig = 0
      call set_fsmass

      call init_shmhist
      call init_semaphores

      call signal( 2, game_over) ! catch sigint
      call signal(13, game_over) ! catch sigpipe
      call signal(15, game_over) ! catch sigterm

      call clear_all_hist

      call sgrnd(seed)

      end

!++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
!> Selects final states masses
!<-------------------------------------------------------------
      subroutine set_fsmass

C--------------------------------------------------------------
      implicit none

      include 'process.h'
      include 'constants.h'
      include 's2n_declare.h'

      integer fspart_id
      integer charge_id

      charge_id = processId/100
      fspart_id = abs(mod(processId,100))

      if (charge_id .ne. 0) then
         if ( fspart_id .eq. idel ) then
            mf  = 0d0
            mf1 = 0d0
         elseif ( fspart_id .eq. idmu ) then
            mf  = mmo
            mf1 = 0d0
         elseif ( fspart_id .eq. idtau ) then
            mf  = mta
            mf1 = 0d0
         elseif ( fspart_id .eq. idhiggs ) then
            mf  = mw
            mf1 = mh
         elseif ( fspart_id .eq. idtops ) then
            mf  = mtp
            mf1 = mbt
         elseif ( fspart_id .eq. idtopt ) then
            mf  = mtp
            mf1 = mdn
         else 
            print *, 'set_fsmass: unknown process choice. stop.'
            stop
         endif
      else
         if ( fspart_id .eq. idel ) then
            mf  = 0d0
            mf1 = 0d0
         elseif ( fspart_id .eq. idmu ) then
            mf  = mmo
            mf1 = mmo
         elseif ( fspart_id .eq. idtau ) then
            mf  = mta
            mf1 = mta
         elseif ( fspart_id .eq. idhiggs ) then
            mf  = mz
            mf1 = mh
         elseif ( fspart_id .eq. idtops ) then
            print *, 'set_fsmass: top production not implemented. stop.'
            stop
         else 
            print *, 'set_fsmass: unknown process choice. stop.'
            stop
         endif
      endif

      end


!++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
!> Sets statefile base for vegas grid storage
!<-------------------------------------------------------------
      subroutine set_sfbase

      implicit none

      include 'process.h'
      include 'vegas.h'

      character*16 intformat
      character*32 str

      !sfbase = repeat(' ', len(sfbase))
      if ( processId .lt. 0 ) then
        intformat = '(A3,I0.3)'
      elseif ( processId/100 .eq. 0 ) then
        intformat = '(A3,I0.3)'
      else
        intformat = '(A3,I0.3)'
      endif

      write (str,intformat) 'pid', processid
      sfbase=trim(str)//'_'//trim(run_tag)

      end


!++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
!> Calls memory releasing functions
!<-------------------------------------------------------------
      subroutine game_over

      implicit none

      call release_shmem_abnormal

      end
