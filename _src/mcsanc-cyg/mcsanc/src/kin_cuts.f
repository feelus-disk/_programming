!++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
!> Sets kinematic cuts.
!! Called during initialization procedure
!<-------------------------------------------------------------
      subroutine set_kin_cuts

      implicit none

      include 'process.h'
      include 'kin_cuts.h'

      integer ic

C     Default values
      min_m34 = 0d0
      max_m34 = sqs0
      min_m345 = 0d0
      max_m345 = sqs0
      min_y34 = -10d0
      max_y34 = 10d0
      min_y345 = -50d0
      max_y345 = 50d0
      min_pt3 = 0.1d0
      max_pt3 = sqs0
      min_pt4 = 0.1d0
      max_pt4 = sqs0
      min_eta3 = -100d0
      max_eta3 = 100d0
      min_eta4 = -100d0
      max_eta4 = 100d0
      min_mtr = 0d0
      max_mtr = sqs0
      min_dR  = 0d0
      max_dR  = 1d-1

      nkincuts = 0
C     Set configured cuts
      do ic = 1,maxKinCuts
        if ( cutName(ic) .eq. 'm34' .and. cutFlag(ic) .eq. 1 ) then
          min_m34 = cutLow(ic)
          max_m34 = cutUp(ic)
        elseif ( cutName(ic) .eq. 'mtr' .and. cutFlag(ic) .eq. 1 ) then
          min_mtr = cutLow(ic)
          max_mtr = cutUp(ic)
        elseif ( cutName(ic) .eq. 'pt3' .and. cutFlag(ic) .eq. 1 ) then
          min_pt3 = cutLow(ic)
          max_pt3 = cutUp(ic)
        elseif ( cutName(ic) .eq. 'pt4' .and. cutFlag(ic) .eq. 1 ) then
          min_pt4 = cutLow(ic)
          max_pt4 = cutUp(ic)
        elseif ( cutName(ic) .eq. 'eta3' .and. cutFlag(ic) .eq. 1 ) then
          min_eta3 = cutLow(ic)
          max_eta3 = cutUp(ic)
        elseif ( cutName(ic) .eq. 'eta4' .and. cutFlag(ic) .eq. 1 ) then
          min_eta4 = cutLow(ic)
          max_eta4 = cutUp(ic)
        elseif ( cutName(ic) .eq. 'dR' .and. cutFlag(ic) .eq. 1 ) then
          min_dR = cutLow(ic)
          max_dR = cutUp(ic)
        elseif ( cutName(ic) .ne. '' .and. cutFlag(ic) .eq. 1 ) then
	  print *, 'Unrecognized cut ', trim(cutName(ic)), ' requested in input.cfg. Exit.'
	  stop
        elseif ( cutName(ic) .eq. '' ) then
          goto 31
        endif
        nkincuts = nkincuts+1
      enddo

31    continue

      end


C=================================================================

!++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
!> Checks if final state kinematics passes the cuts and fills
!! histogramms. 
!! Called during each integrand evaluation
!<-------------------------------------------------------------
      subroutine check_cuts(is_cut, p3, p4, p5)

      implicit none

      include 'compounds.h'
      include 'process.h'
      include 'kin_cuts.h'
      include 's2n_declare.h'
      include 'histogram.h'
      include 'constants.h'
      include 'calo.h'

      integer is_cut, ic, charge_id, fspart_id, i, is_dync
      double precision p3(4), p4(4), p5(4), p34(4)

      double precision miv34b, mtr34b
      double precision pt3b, pt4b
      double precision eta3b, eta4b, eta5b
      double precision pt34b, eta34b, ptllb2
      double precision p3p4b

      double precision miv34c, mtr34c
      double precision pt3c, pt4c
      double precision eta3c, eta4c, eta5c
      double precision pt34c, eta34c
      double precision p3p4c

      double precision cosphi34b, cosphi34c

      double precision eta5, pt5
      double precision cosphi35, cosphi45
      double precision phi35,phi45,rl35,rl45
      double precision afbb,afbc,pp33,pp34,pp43,pp44

      double precision costetstarb,costetstarc,sintetstarb,sintetstarc
      double precision phistarb,phistarc

      is_cut = 0

      charge_id = processId/100
      fspart_id = abs(mod(processId,100))

      do i=1,100
         hist_val(i) = 0d0
      enddo

      is_dync = 0
      if (charge_id.eq.0.and.fspart_id .eq. idel ) is_dync = 1
      if (charge_id.eq.0.and.fspart_id .eq. idmu ) is_dync = 1
      if (charge_id.eq.0.and.fspart_id .eq. idtau) is_dync = 1

c     bare block
      do i=1,4
         p34(i) = p3(i)+p4(i)
      enddo
c     pt3,pt4
      pt3b = dsqrt(p3(1)**2+p3(2)**2)
      pt4b = dsqrt(p4(1)**2+p4(2)**2)
c     p3,p4 rapidity
      if ((-p3(3)+p3(4))/(p3(3)+p3(4)).le.0d0) goto 101
      if ((-p4(3)+p4(4))/(p4(3)+p4(4)).le.0d0) goto 101
      eta3b = 0.5d0*dlog((p3(3)+p3(4))/(-p3(3)+p3(4)))
      eta4b = 0.5d0*dlog((p4(3)+p4(4))/(-p4(3)+p4(4)))
c     34 transverse mass
      cosphi34b = (p3(1)*p4(1)+p3(2)*p4(2))/pt3b/pt4b
      mtr34b = dsqrt(2d0*pt3b*pt4b*(1d0-cosphi34b))
c     34 invariant mass
c      call scalar (p3,p4,p3p4b)
c      miv34b = mf1**2 + mf**2 + 2*p3p4b
      miv34b = p34(4)**2-p34(1)**2-p34(2)**2-p34(3)**2
      if (miv34b.le.0d0) goto 101
      miv34b = dsqrt(miv34b)
c     34 pt
c      pt34b = dsqrt((p3(1)+p4(1))**2+(p3(2)+p4(2))**2)
      pt34b = dsqrt(p34(1)**2+p34(2)**2)
c     34 eta
      eta34b = 0.5d0*dlog((p34(3)+p34(4))/(-p34(3)+p34(4)))
c     phistarb
      if (dabs(cosphi34b).gt.1d0) then
         phistarb = 0d0
      else
         costetstarb = tanh((eta3b-eta4b)/2)
         sintetstarb = dsqrt(1d0-costetstarb**2)
         phistarb = tan((pi-acos(cosphi34b))/2)*sintetstarb
      endif
c     forward-backward asymmetry:
c     pl -> 3, mi -> 4
      pp33 = (p3(4)+p3(3))/dsqrt(2d0)
      pp43 = (p3(4)-p3(3))/dsqrt(2d0)
      pp34 = (p4(4)+p4(3))/dsqrt(2d0)
      pp44 = (p4(4)-p4(3))/dsqrt(2d0)

      ptllb2 = (p3(1)+p4(1))**2+(p3(2)+p4(2))**2

      afbb  = dabs(p34(3))/p34(3)*2d0/miv34b/dsqrt(miv34b**2+pt34b**2)*(pp34*pp43-pp44*pp33)

      if (irecomb .ne. 0 .and. comp_id .eq. iewhard) then
c     recombination
        pt5 = dsqrt(p5(1)**2+p5(2)**2)
        if ((-p5(3)+p5(4))/(p5(3)+p5(4)).le.0d0) goto 101
        eta5 = 0.5d0*dlog((p5(3)+p5(4))/(-p5(3)+p5(4)))
        cosphi35 = (p3(1)*p5(1)+p3(2)*p5(2))/pt3b/pt5
        cosphi45 = (p4(1)*p5(1)+p4(2)*p5(2))/pt4b/pt5
c        if (dabs(cosphi35).gt.1d0) is_cut = 1
c        if (dabs(cosphi45).gt.1d0) is_cut = 1
        phi35 = dacos(cosphi35)
        phi45 = dacos(cosphi45)
        rl35  = dsqrt((eta3b-eta5)**2+phi35**2)
        rl45  = dsqrt((eta4b-eta5)**2+phi45**2)

        if ((fspart_id .eq. idel) .or. (fspart_id .eq. idmu)) then

           if (rl35.le.max_dR) then
              do i=1,4
                 p3(i) = p3(i) + p5(i)
              enddo
           endif

           if (charge_id.eq.0) then
              if (rl45.le.max_dR) then
                 do i=1,4
                    p4(i) = p4(i) + p5(i)
                 enddo
              endif
           endif

        endif

      endif

      if (irecomb .ne. 0) then
c     calo block
         do i=1,4
            p34(i) = p3(i)+p4(i)
         enddo
c     pt3,pt4
         pt3c = dsqrt(p3(1)**2+p3(2)**2)
         pt4c = dsqrt(p4(1)**2+p4(2)**2)
c     p3,p4 rapidity
         if ((-p3(3)+p3(4))/(p3(3)+p3(4)).le.0d0) goto 101
         if ((-p4(3)+p4(4))/(p4(3)+p4(4)).le.0d0) goto 101
         eta3c = 0.5d0*dlog((p3(3)+p3(4))/(-p3(3)+p3(4)))
         eta4c = 0.5d0*dlog((p4(3)+p4(4))/(-p4(3)+p4(4)))
c     34 transverse mass
         cosphi34c = (p3(1)*p4(1)+p3(2)*p4(2))/pt3c/pt4c
         mtr34c = dsqrt(2d0*pt3c*pt4c*(1d0-cosphi34c))
c     34 invariant mass
c         call scalar (p3,p4,p3p4c)
c         miv34c = mf1**2 + mf**2 + 2*p3p4c
         miv34c = p34(4)**2-p34(1)**2-p34(2)**2-p34(3)**2
         if (miv34c.le.0d0) goto 101
         miv34c = dsqrt(miv34c)
c     34 pt
c         pt34c = dsqrt((p3(1)+p4(1))**2+(p3(2)+p4(2))**2)
         pt34c = dsqrt(p34(1)**2+p34(2)**2)
c     34 eta
         eta34c = 0.5d0*dlog((p34(3)+p34(4))/(-p34(3)+p34(4)))
c     phistarc
         if (dabs(cosphi34c).gt.1d0) then
            phistarc = 0d0
         else
            costetstarc = tanh((eta3c-eta4c)/2)
            sintetstarc = dsqrt(1d0-costetstarc**2)
            phistarc = tan((pi-acos(cosphi34c))/2)*sintetstarc
         endif
      endif
c     forward-backward asymmetry:
      pp33 = (p3(4)+p3(3))/dsqrt(2d0)
      pp43 = (p3(4)-p3(3))/dsqrt(2d0)
      pp34 = (p4(4)+p4(3))/dsqrt(2d0)
      pp44 = (p4(4)-p4(3))/dsqrt(2d0)
      afbc  = dabs(p34(3))/p34(3)*2d0/miv34c/dsqrt(miv34c**2+pt34c**2)*(pp34*pp43-pp44*pp33)

      if (irecomb .eq. 0) then
c     apply bare cuts

         if (is_dync .eq. 1) then

            if (( pt3b .lt. min_pt3 .or. pt4b .lt. min_pt4 ) .and.
     .          ( pt3b .lt. min_pt4 .or. pt4b .lt. min_pt3 )) goto 101

            if (( pt3b .gt. max_pt3 .or. pt4b .gt. max_pt4 ) .and.
     .          ( pt3b .gt. max_pt4 .or. pt4b .gt. max_pt3 )) goto 101

            if (( eta3b .lt. min_eta3 .or. eta4b .lt. min_eta4 ) .and.
     .          ( eta3b .lt. min_eta4 .or. eta4b .lt. min_eta3 )) goto 101

            if (( eta3b .gt. max_eta3 .or. eta4b .gt. max_eta4 ) .and.
     .          ( eta3b .gt. max_eta4 .or. eta4b .gt. max_eta3 )) goto 101

         else

            if ( pt3b .lt. min_pt3 .or. pt4b .lt. min_pt4 ) goto 101
         
            if ( pt3b .gt. max_pt3 .or. pt4b .gt. max_pt4 ) goto 101

            if ( eta3b .lt. min_eta3 .or. eta4b .lt. min_eta4 ) goto 101

            if ( eta3b .gt. max_eta3 .or. eta4b .gt. max_eta4 ) goto 101

         endif

         if ( miv34b .lt. min_m34  ) goto 101

         if ( mtr34b .lt. min_mtr  ) goto 101

         if ( miv34b .gt. max_m34  ) goto 101

         if ( mtr34b .gt. max_mtr  ) goto 101

         nhist = 24
         hist_val( 1) = miv34b
         hist_val( 2) = mtr34b
         hist_val( 3) = pt34b
         hist_val( 4) = pt3b
         hist_val( 5) = pt4b
         hist_val( 6) = eta34b
         hist_val( 7) = eta3b
         hist_val( 8) = eta4b
         hist_val( 9) = phistarb
         hist_val(10) = miv34b
c     sgb: f <-> b
         if (afbb.lt.0d0) hist_val(11) = miv34b
         if (afbb.gt.0d0) hist_val(12) = miv34b

         hist_val(13) = miv34b
         hist_val(14) = mtr34b
         hist_val(15) = pt34b
         hist_val(16) = pt3b
         hist_val(17) = pt4b
         hist_val(18) = eta34b
         hist_val(19) = eta3b
         hist_val(20) = eta4b
         hist_val(21) = phistarb
         hist_val(22) = miv34b
c     sgb: f <-> b
         if (afbb.lt.0d0) hist_val(23) = miv34b
         if (afbb.gt.0d0) hist_val(24) = miv34b

         do i = 1,nhist
            if (hist_val(i).ne.hist_val(i)) then
c              print *, "hist_val",i,"is nan"
               goto 101
            endif
         enddo
         goto 201
      endif

      if (irecomb .eq. 1) then
c     apply calo cuts

         if (is_dync .eq. 1) then

            if (( pt3c .lt. min_pt3 .or. pt4c .lt. min_pt4 ) .and.
     .          ( pt3c .lt. min_pt4 .or. pt4c .lt. min_pt3 )) goto 101

            if (( pt3c .gt. max_pt3 .or. pt4c .gt. max_pt4 ) .and.
     .          ( pt3c .gt. max_pt4 .or. pt4c .gt. max_pt3 )) goto 101

            if (( eta3c .lt. min_eta3 .or. eta4c .lt. min_eta4 ) .and.
     .          ( eta3c .lt. min_eta4 .or. eta4c .lt. min_eta3 )) goto 101

            if (( eta3c .gt. max_eta3 .or. eta4c .gt. max_eta4 ) .and.
     .          ( eta3c .gt. max_eta4 .or. eta4c .gt. max_eta3 )) goto 101

         else

            if ( pt3c .lt. min_pt3 .or. pt4c .lt. min_pt4 ) goto 101

            if ( pt3c .gt. max_pt3 .or. pt4c .gt. max_pt4 ) goto 101

            if ( eta3c .lt. min_eta3 .or. eta4c .lt. min_eta4 ) goto 101

            if ( eta3c .gt. max_eta3 .or. eta4c .gt. max_eta4 ) goto 101

         endif

         if ( miv34c .lt. min_m34  ) goto 101

         if ( mtr34c .lt. min_mtr  ) goto 101

         if ( miv34c .gt. max_m34  ) goto 101

         if ( mtr34c .gt. max_mtr  ) goto 101

         nhist = 24
         hist_val( 1) = miv34c
         hist_val( 2) = mtr34c
         hist_val( 3) = pt34c
         hist_val( 4) = pt3c
         hist_val( 5) = pt4c
         hist_val( 6) = eta34c
         hist_val( 7) = eta3c
         hist_val( 8) = eta4c
         hist_val( 9) = phistarc
         hist_val(10) = miv34c
c     sgb: f <-> b
         if (afbb.lt.0d0) hist_val(11) = miv34c
         if (afbb.gt.0d0) hist_val(12) = miv34c

         hist_val(13) = miv34c
         hist_val(14) = mtr34c
         hist_val(15) = pt34c
         hist_val(16) = pt3c
         hist_val(17) = pt4c
         hist_val(18) = eta34c
         hist_val(19) = eta3c
         hist_val(20) = eta4c
         hist_val(21) = phistarc
         hist_val(22) = miv34c
c     sgb: f <-> b
         if (afbb.lt.0d0) hist_val(23) = miv34c
         if (afbb.gt.0d0) hist_val(24) = miv34c

         do i = 1,nhist
            if (hist_val(i).ne.hist_val(i)) then
c               print *, "hist_val",i,"is nan"
               goto 101
            endif
         enddo
         goto 201
      endif

 101  is_cut = 1
 201  continue
      return
      end

C-----------------------------------------------------------------


!++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
!> Print cuts that are turned on
!<-------------------------------------------------------------
      subroutine print_active_cuts(fd)

      implicit none

      include 'kin_cuts.h'

      integer ic, fd
      character*128 fmt1

      fmt1='(X, A, X, A7, A4, ES10.3E2, X, A, ES10.3E2, 2X, A)'

      write (fd,'(A)') ''
      write (fd,'(A41)') ' .. Kinematic cuts ...........................................'

      do ic = 1,maxKinCuts
        if ( cutFlag(ic) .eq. 1 ) then
          write (fd,fmt1) '.',cutName(ic),' = [',cutLow(ic),':', cutUp(ic), '] .'
        endif
      enddo
      write (fd,'(A41)') ' ............................................................'
      write (fd,'(A)') ''

      end
