!++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
!> Configures and starts vegas integration for born component
!<-------------------------------------------------------------
      subroutine gg_born

      implicit none

      include 'compounds.h'
      include 'kin_cuts.h'
      include 'process.h'
      include 's2n_declare.h'
      include 'vegas.h'

      external gg_3d

      double precision sig3d(maxncomp), sig3d_err(maxncomp), 
     $  sig3d_prob(maxncomp)

      logical vg_exists
      character*64 hist_fname

      comp_id = iewbogg
      comp_name = 'bogg'
      statefile=trim(sfbase)//'_'//trim(comp_name)//'.vgrid'

C     Read the histograms from file
      inquire(file=statefile, exist=vg_exists)
      hist_fname = repeat(' ', len(hist_fname))
      hist_fname = trim(sfbase)//'_'//trim(comp_name)//'.hist'
      call set_hfname(trim(hist_fname)//CHAR(0))
      if ( vg_exists .neqv. .true. ) then 
        call unlink(hist_fname)
      else 
        call read_hist(1)
      endif

C     Vegas calls for 3d function
      ndim   = 3
      gridno = 1
      limits(1) = min_m34
      limits(2) = max_m34
      limits(3) = min_y34
      limits(4) = max_y34
      limits(5) = -1d0 ! min_costh
      limits(6) =  1d0 ! max_costh

      if ( vg_exists .neqv. .true. ) then
        print *,
        print *, "vegas grid exploration for ", trim(comp_name)
        print *,
        ixplore = 1
        call llvegas(ndim, 1, gg_3d, limits,
     &    relAcc, absAcc, flags, seed,
     &    mineval, nExplore, nStart, nIncrease, nbatch,
     &    gridno, '',
     &    neval, fail, sig3d, sig3d_err, sig3d_prob)
      else
        print *,
        print *, "found vegas grid statefile, skipping exploration."
      endif

      print *, 
      print *, "integration for ", trim(comp_name)
      print *, 
      ixplore = 0
      call llvegas(ndim, 1, gg_3d, limits,
     &  relAcc, absAcc, flags, seed,
     &  mineval, maxEval, nStart, nIncrease, nbatch,
     &  gridno, statefile,
     &  neval, fail, sig3d, sig3d_err, sig3d_prob)

      call update_stats(neval, sig3d, sig3d_err)

C     Save hist from last run and clear all histograms
      !call accum_hist
      call write_hist
      call clear_all_hist

      end

C--------------------------------------------------------------

!++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
!> born gamma-gamma component integrand
!<-------------------------------------------------------------
      integer function gg_3d(ndim, arg, ncomp, f, limits, vwgt, iter)

      implicit none

      include 'compounds.h'
      include 's2n_declare.h'
      include 'kin_cuts.h'
c      include 'histogram.h'
      include 'vegas.h'
      include 'process.h'
      !include 'scales.h'

      external grnd

      integer iter, icomp, iborn_
      double precision arg(ndim), f(ncomp), vwgt
      double precision sqs, y, costh  ! integration variables
      double precision jac            ! jacobian
      double precision p3(4), p4(4), b
      double precision x1, x2, apdf_conv(1)
      double precision aborn(1), asoft(1), scalef, scaler, alphasPDF
      double precision grnd, dir
      integer is_cut
      integer in,charge_id

      charge_id = processId/100

      do icomp = 1,ncomp
        f(icomp) = 0d0
      enddo

      do in = 1,2
        aborn(in) = 0d0
        asoft(in) = 0d0
      enddo

C     SCALE ARGUMENTS
      sqs   = limits(1)+(limits(2)-limits(1))*arg(1)
      y     = limits(3)+(limits(4)-limits(3))*arg(2)
      costh = limits(5)+(limits(6)-limits(5))*arg(3)
      jac   = (limits(2)-limits(1))*
     $        (limits(4)-limits(3))*
     $        (limits(6)-limits(5))*2d0*sqs/sqs0**2

c      sqs = 2000d0
c      costh = 0.9999999d0
c      x1 = 0.2d0
c      x2 = 0.3d0

      s    = sqs**2
      if (s .lt. (mf+mf1)**2) return

C     Random direction switch, -1 - backward
      dir = 2d0*grnd() - 1d0
      if ( dir .le. 0 ) then 
        dir = -1d0
      else 
        dir = 1d0
      endif
      !dir = 1

C     KINEMATICS

      p3(4) = (s+mf**2-mf1**2)/sqs/2d0
      p3(3) = dsqrt(p3(4)**2-mf**2)
      p3(2) = 0d0
      p3(1) = 0d0
      p4(4) = sqs - p3(4)
      p4(3) = -p3(3)
      p4(2) = 0d0
      p4(1) = 0d0

      call lrotateX(p3, dacos(dir*costh))
      call lrotateX(p4, dacos(dir*costh))
      b = -dtanh(y) ! as in function_3d.f (CC)
      call lboostZ(p3, b)
      call lboostZ(p4, b)
c      print *, "p3=",p3
c      print *, "p4=",p4
c      stop

      is_cut = 0
      call check_cuts( is_cut, p3, p4)
      if ( is_cut .eq. 1 ) return

C     alphas
      if ( fscale .gt.  0d0 ) scalef = fscale
      if ( fscale .lt.  0d0 ) scalef = sqs*dabs(fscale)
      if ( rscale .gt.  0d0 ) scaler = rscale
      if ( rscale .lt.  0d0 ) scaler = sqs*dabs(rscale)

      if ( rscale .lt. 0d0 .and. iqcd .ne. 0 .and. s .lt. q2min ) return

C     PDF convolution
      x1 = sqs/sqs0*dexp(dir*y)
      x2 = sqs/sqs0*dexp(-dir*y)
      if ( x1 .lt. xmin  .or. x1 .gt. xmax  ) return
      if ( x2 .lt. xmin  .or. x2 .gt. xmax  ) return

      call pdf_conv_gg(x1,x2,scalef,apdf_conv)

      call set_betaftu(costh, s, t, u)
      call sanc_br_gg (-s,-u,-t,aborn,asoft)

      f(1) = aborn(1) * apdf_conv(1) * jac /2

c      print *, apdf_conv/2
c      print *, born
c      stop

      if ( iter .ne. 1 .and. ixplore .ne. 1) then
        call fill_hists(f(1), vwgt, iter, p3, p4)
      endif

      end

C--------------------------------------------------------------
