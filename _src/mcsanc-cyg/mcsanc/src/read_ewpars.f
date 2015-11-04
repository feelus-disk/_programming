!++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
!> Reads ewparam.cfg and sets flags and parameters
!<-------------------------------------------------------------
      subroutine read_ewpars

      implicit none


      include 'constants.h'
      include 'process.h'
      include 's2n_declare.h'
      include 'ckm.h'
C      include 'scales.h'
      include 'iph.h'

      integer ifl1, ifl2, charge_id, fspart_id
      double precision Vud, Vus, Vub, Vcd, Vcs, Vcb
      double precision mfact
C=================================================================

C Define namelists

C Namelist for EW parameters:
      namelist/EWpars/gfscheme, fscale, rscale, ome,
     $ alpha, gf, alphas, conhc, 
     $ mz, mw, mh, ma, mv, wz, ww, wh, wtp,
     $ Vud, Vus, Vub, Vcd, Vcs, Vcb, 
     $ men, mel, mmn, mmo, mtn, mta, mup, mdn,
     $ mch, mst, mtp, mbt,
     $ rmf1

C----------------------------------------------------------------

      charge_id = processId/100
      fspart_id = abs(mod(processId,100))

C  ***
C  
C  Initialize the parameters
C
C  ***

      do ifl1=-nf,nf
        do ifl2=-nf,nf
          Vsq(ifl1,ifl2) = 0d0
        enddo
      enddo


C-----------------------------------------------------------------

C Read the namelists
      open (51, file='ewparam.cfg', status='old')
      read (51, NML=EWpars, END=41, ERR=42)
 49   continue

      alphai = 1d0/alpha
      cf = 4d0/3d0

      if (rmf1( 1) .eq. 0d0 ) rmf1( 1) = men
      if (rmf1( 2) .eq. 0d0 ) rmf1( 2) = mel
      if (rmf1( 7) .eq. 0d0 ) rmf1( 7) = mup
      if (rmf1( 8) .eq. 0d0 ) rmf1( 8) = mdn
      if (rmf1( 3) .eq. 0d0 ) rmf1( 3) = mmn
      if (rmf1( 4) .eq. 0d0 ) rmf1( 4) = mmo
      if (rmf1( 9) .eq. 0d0 ) rmf1( 9) = mch
      if (rmf1(10) .eq. 0d0 ) rmf1(10) = mst
      if (rmf1( 5) .eq. 0d0 ) rmf1( 5) = mtn
      if (rmf1( 6) .eq. 0d0 ) rmf1( 6) = mta
      if (rmf1(11) .eq. 0d0 ) rmf1(11) = mtp
      if (rmf1(12) .eq. 0d0 ) rmf1(12) = mbt

      mfact = 1d0

      mdn = mfact*mdn 
      mup = mfact*mup 
      mst = mfact*mst 
      mch = mfact*mch 
      mbt = mfact*mbt 
      mtp = mfact*mtp 

      Vsq(2,-1) = Vud**2
      Vsq(-2,1) = Vud**2
      Vsq(4,-3) = Vcs**2
      Vsq(-4,3) = Vcs**2
      Vsq(2,-3) = Vus**2
      Vsq(-2,3) = Vus**2
      Vsq(4,-1) = Vcd**2
      Vsq(-4,1) = Vcd**2
      Vsq(2,-5) = Vub**2
      Vsq(-2,5) = Vub**2
      Vsq(4,-5) = Vcb**2
      Vsq(-4,5) = Vcb**2

      tlmu2 = 1d0
      thmu = (mw*exp(-11d0/12))
      thmu2 = thmu**2

C     Set up electroweak flags
      iqed = iflew(1)
      iew = iflew(2)
      iborn = iflew(3)
      ifgg = iflew(4)
      irun = iflew(5)
      iph = iflew(6)
      iqcd = iflqcd

      if (irecomb .ne. 0 .and. iqcd .eq. 1 .and. iqed .eq. 0) then
        print *, 'Disabling recombination for QCD. Set irecomb = 0'
	irecomb = 0
      endif

      if ((irecomb.ne.0).and.((fspart_id.ne.idel).and.(fspart_id.ne.idmu))) then
        print *, 'Recombination is implemented for electron or muon only. Set irecomb = 0'
	irecomb = 0
      endif

      if ( gfscheme .eq. 4 ) then
         if (.not.((charge_id.eq.0).and.((fspart_id.eq.idel).or.(fspart_id.eq.idmu).or.(fspart_id.eq.idtau)))) then
            print *, 'Alpha(mz) scheme is implemented for pid=001,002,003 processes only. Exit.'
            call exit
         endif
      endif

      if ( iqed .eq. 6 ) then
         if (fspart_id.gt.3) then
            print *, 'iqed=6 option is implemented for pid=001,002,003,+/-(101,102,102) processes only. Exit.'
            call exit
         endif
      endif

      if ((iborn.lt.-1).or.(iborn.gt.2)) then
         print *, "iborn must be -1/0/1. Exit"
         call exit
      endif

      if ((iqed.lt.0).or.(iqed.gt.6)) then
         print *, "iqed must be 0/1/2/3/4/5/6. Exit"
         call exit
      endif

      if ((iew.lt.0).or.(iew.gt.1)) then
         print *, "iew must be 0/1. Exit"
         call exit
      endif

      if ((ifgg.lt.0).or.(ifgg.gt.2)) then
         print *, "ifgg must be 0/1/2. Exit"
         call exit
      endif

      if ((ifgg.eq.2).and.(gfscheme.gt.1)) then
         print *, "ifgg=2 valid only for gfscheme=0,1. Exit"
         call exit
      endif

      if ((irun.lt.0).or.(irun.gt.1)) then
         print *, "irun must be 0/1. Exit"
         call exit
      endif

      if ((iqcd.lt.0).or.(iqcd.gt.1)) then
         print *, "iqcd must be 0/1. Exit"
         call exit
      endif

      if ((irecomb.lt.0).or.(irecomb.gt.1)) then
         print *, "irecomb must be 0/1. Exit"
         call exit
      endif

      if ((imsb.lt.0).or.(imsb.gt.2)) then
         print *, "imsb must be 0/1/2. Exit"
         call exit
      endif

      if ((iph.ne.0).and.(iqcd.gt.0)) then
         print *, "iph must be 0 for iqcd=1. Exit"
         call exit
      endif

      if (dabs(iph).gt.2) then
         print *, "iph must be -2/-1/0/1/2. Exit"
         call exit
      endif

      ilin = 1

      goto 73

 41   continue
      print '(''Namelist &EWpars NOT found, STOP.'')'
      stop
 42   continue
      print '(''ERROR reading &EWpars namelist. STOP.'')'
      stop

 73   continue

      close(51)

      end

