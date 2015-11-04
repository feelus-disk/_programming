!++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
!> Configures and starts vegas integration for EW hard component
!<-------------------------------------------------------------
      subroutine qq_hard

      implicit none

      include 'compounds.h'
      include 'kin_cuts.h'
      include 'process.h'
      include 's2n_declare.h'
      include 'vegas.h'

      external qq_6d
      double precision sig6d(maxncomp), sig6d_err(maxncomp), 
     $  sig6d_prob(maxncomp)

      logical vg_exists
      character*64 hist_fname

      comp_id = iewhard 
      !comp_name = repeat(' ',len(comp_name))
      comp_name = 'hard'
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

C     Vegas calls for 6d function
      ndim   = 6
      gridno = 4
      limits(1)  = min_m345
      limits(2)  = max_m345
      limits(3)  = min_y345 ! p3+p4+phot rapidity
      limits(4)  = max_y345
      limits(5)  = -50d0 ! min eta(p3+p4)
      limits(6)  =  50d0 ! max eta(p3+p4)
      limits(7)  = ome ! log(delta sqrt-s/sqrt-s) - photon energy
      limits(8)  = 1d0-((mf+mf1)/sqs0)**2
      limits(9)  = -1d0 ! costh of Z direction relative to HZ direction
      limits(10) =  1d0
      limits(11) = 0d0    ! phi, azimuthal angle for Z direction in HZ CMS
      limits(12) = 2d0*pi

      seed = seed+1

      if ( vg_exists .neqv. .true. ) then
        print *,
        print *, "vegas grid exploration for ", trim(comp_name)
        print *,
        ixplore = 1
        call llvegas(ndim, 1, qq_6d, limits,
     &    relAcc, absAcc, flags, seed,
     &    mineval, nExplore, nStart, nIncrease, nbatch,
     &    gridno, '',
     &    neval, fail, sig6d, sig6d_err, sig6d_prob)
      else
        print *,
        print *, "found vegas grid statefile, skipping exploration."
      endif

      print *, 
      print *, "integration for ", trim(comp_name)
      print *, 
      ixplore = 0
      call llvegas(ndim, 1, qq_6d, limits,
     &  relAcc, absAcc, flags, seed,
     &  mineval, maxEval, nStart, nIncrease, nbatch,
     &  gridno, statefile,
     &  neval, fail, sig6d, sig6d_err, sig6d_prob)

      call update_stats(neval, sig6d, sig6d_err)

C     Save hist from last run and clear all histograms
      !call accum_hist
      call fill_hists(0d0, 0d0, 0)
      call write_hist
      call clear_all_hist

      end

C--------------------------------------------------------------

!++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
!> EW hard component integrand
!<-------------------------------------------------------------
      integer function qq_6d(ndim, arg, ncomp, f, limits, vwgt, iter)

      implicit none

      include 's2n_declare.h'
      include 'kin_cuts.h'
c      include 'histogram.h'
      include 'vegas.h'
      include 'process.h'
      include 'compounds.h'
      include 'calo.h'

      external grnd

      integer iter, icomp, charge_id, in, i
      double precision arg(ndim), f(ncomp), vwgt
      double precision sqs, y, eta34, phe, costh3, phi3, phi3k ! integration variables
      double precision jac                              ! jacobian
      double precision sqspr, costh34, costh34k, m34, miv34c
      double precision x1, x2, apdf_conv(2), b, b1
      double precision p3(4), p4(4), p5(4)    ! lepton, nu, photon 4momenta
      double precision ahard(2), scalef, scaler, alphasPDF
      double precision p3p4
      double precision grnd, dir
      integer is_cut

      charge_id = processId/100

      do icomp = 1,ncomp
        f(icomp) = 0d0
      enddo

      do in = 1,2
         ahard(in) = 0d0
      enddo

C     SCALE ARGUMENTS
      sqs   = limits(1)+(limits(2)-limits(1))*arg(1)
      y     = limits(3)+(limits(4)-limits(3))*arg(2)
      eta34 = limits(5)+(limits(6)-limits(5))*arg(3)
      phe = limits(7)+(limits(8)-limits(7))*arg(4)
      costh3 = limits(9)+(limits(10)-limits(9))*arg(5)
      phi3 = limits(11)+(limits(12)-limits(11))*arg(6)


      !sqs = 500d0
      s      = sqs**2
      spr    = (1d0 - phe)*s
      !spr = (499d0)**2

      sqspr  = dsqrt(spr)
      costh34 = dtanh(eta34)
      if ( s   .lt. (mf+mf1)**2 ) return
      if ( spr .lt. (mf+mf1)**2 ) return

      !phi3 = -pi/4
      !costh3 = -0.6d0
      !costh34 = -0.7d0
      !y = 0.5d0

      jac   = (limits(2)-limits(1))*
     $        (limits(4)-limits(3))*
     $        (limits(6)-limits(5))*
     $        (limits(8)-limits(7))*
     $        (limits(10)-limits(9))*
     $        (limits(12)-limits(11))*
     $        2d0*sqs/sqs0**2/dcosh(eta34)**2*s

C     Random direction switch, -1 - backward
      dir = 2d0*grnd() - 1d0
      if ( dir .le. 0 ) then 
        dir = -1d0
      else 
        dir = 1d0
      endif

C     KINEMATICS

      p3(4) = (spr-mf1**2+mf**2)/sqspr/2d0
      p3(3) = dsqrt(p3(4)**2-mf**2)
      p3(2) = 0d0
      p3(1) = 0d0
      p4(4) = sqspr - p3(4)
      p4(3) = -p3(3)
      p4(2) = 0d0
      p4(1) = 0d0
      p5(4) = (s-spr)/2d0/sqs
      p5(3) = p5(4)
      p5(2) = 0d0
      p5(1) = 0d0

      phi3k    = phi3
      costh34k = costh34
      if (charge_id .eq. 0) then
         phi3k    = -phi3
         costh34k = -costh34
      endif

      call lrotateY(p3, dacos(costh3))
      call lrotateY(p4, dacos(costh3))
      call lrotateZ(p3, phi3k)
      call lrotateZ(p4, phi3k)
      b1 = (s-spr)/(s+spr)
      call lboostZ(p3, b1)
      call lboostZ(p4, b1)
      call lrotateX(p3, pi-dacos(costh34k))
      call lrotateX(p4, pi-dacos(costh34k))
      call lrotateX(p5, pi-dacos(costh34k))
      if ( dir .lt. 0d0 ) then
         p3(3) = -p3(3)
         p4(3) = -p4(3)
         p5(3) = -p5(3)
      endif
      b = dtanh(y)
      call lboostZ(p3, b)
      call lboostZ(p4, b)
      call lboostZ(p5, b)
      !print *, "p3", p3
      !print *, "p4", p4
      !print *, "p5", p5
      !stop

      do i=1,4
         if (p3(i).ne.p3(i)) return
         if (p4(i).ne.p4(i)) return
         if (p5(i).ne.p5(i)) return
      enddo

      is_cut = 0
      call check_cuts( is_cut, p3, p4, p5 )
      if ( is_cut .eq. 1 ) return

C     alphas
      if ( fscale .gt.  0d0 ) scalef = fscale
      if ( fscale .lt.  0d0 ) scalef = sqspr*dabs(fscale)
      if ( rscale .gt.  0d0 ) scaler = rscale
      if ( rscale .lt.  0d0 ) scaler = sqspr*dabs(rscale)

      if ( rscale .lt. 0d0 .and. iqcd .ne. 0 .and. spr .lt. q2min ) return
      if ( iqcd .ne. 0 ) alphas = alphasPDF(scaler)

      if ( irecomb .eq. 1 .and. fscale .lt. 0d0 ) scalef = miv34c*dabs(fscale)

C     PDF convolution
      x1 = sqs/sqs0*dexp(dir*y)
      x2 = sqs/sqs0*dexp(-dir*y)
      if ( x1  .lt. xmin  .or. x1  .gt. xmax  ) return
      if ( x2  .lt. xmin  .or. x2  .gt. xmax  ) return

      call pdf_conv (x1,x2,scalef,apdf_conv)

C     Parton level cross sections
      omega = ome*sqs/2d0

      call sanc_ha (s,spr,phi3,costh3,costh34,ahard)
      f(1) = (ahard(1) * apdf_conv(1) + ahard(2) * apdf_conv(2)) * jac

      !print *, iborn,iqed,iew,iqcd,gfscheme,ilin,ifgg,its,irun
      !print *, "sqs,sqspr",sqs, sqspr
      !print *, "phi3,costh3,costh34",phi3, costh3, costh34
      !print *, "scale",scale
      !print *, "x1,x2",x1, x2
      !print *, "hard_12",ahard(1),ahard(2)
      !print *, "pdf",apdf_conv(1),apdf_conv(2)
      !stop

      if (f(1).ne.f(1)) then
         print *,"sqs,sqspr,phi3,cth3,cth5",sqs,sqspr,phi3,costh3,costh34
         return
      endif

      if ( iter .ne. 1 .and. ixplore .ne. 1) then
        call fill_hists(f(1), vwgt, iter, p3, p4)
      endif
      end

C--------------------------------------------------------------
