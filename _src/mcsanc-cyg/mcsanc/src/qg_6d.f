!++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
!> Configures and starts vegas integration for QCD hard component
!<-------------------------------------------------------------
      subroutine qg_hard

      implicit none

      include 'compounds.h'
      include 'kin_cuts.h'
      include 'process.h'
      include 's2n_declare.h'
      include 'vegas.h'
      include 'constants.h'

      external qg_6d

      integer fspart_id

      double precision sig6d(maxncomp), sig6d_err(maxncomp), 
     $  sig6d_prob(maxncomp)

      double precision mdn_,mup_,mbt_

      logical vg_exists
      character*64 hist_fname

      fspart_id = abs(mod(processId,100))

      comp_id = iqcdinvg
      comp_name = 'invg'
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

      if (iqcd.eq.1) then
c     save initial quark masses
         mdn_ = mdn
         mup_ = mup
         mbt_ = mbt
c     factor to initial quark masses
         mdn = mdn_/10
         mup = mup_/10
         if ( fspart_id .eq. idtopt ) mbt = mbt_/10
         rdnm2 = mdn**2
         rupm2 = mup**2
         rbtm2 = mbt**2
      endif

C     Vegas calls for 6d function
      ndim   = 6
      gridno = 6
      limits(1)  = min_m345 ! m345 integration
      limits(2)  = max_m345
      limits(3)  = min_y345 ! p3+p4+phot rapidity
      limits(4)  = max_y345
      limits(5)  = -50d0 ! min eta(p3+p4)
      limits(6)  =  50d0 ! max eta(p3+p4)
      limits(7)  = min_m34  ! m34 integration
      limits(8)  = max_m34 
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
        call llvegas(ndim, 1, qg_6d, limits,
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
      call llvegas(ndim, 1, qg_6d, limits,
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

c     revert initial quark masses
      if (iqcd.eq.1) then
         mdn = mdn_
         mup = mup_
         mbt = mbt_

         rdnm2 = mdn_**2
         rupm2 = mup_**2
         rbtm2 = mbt_**2
      endif

      end

C--------------------------------------------------------------

!++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
!> QED(QCD) hard component integrand
!<-------------------------------------------------------------
      integer function qg_6d(ndim, arg, ncomp, f, limits, vwgt, iter)

      implicit none

      include 's2n_declare.h'
      include 'kin_cuts.h'
c      include 'histogram.h'
      include 'vegas.h'
      include 'process.h'
      include 'compounds.h'
      include 'constants.h'

      external grnd

      integer iter, icomp, charge_id, fspart_id, in
      integer is_cut
      double precision arg(ndim), f(ncomp), vwgt
      double precision sqs, y, eta34, phe
      double precision costh3, phi3 ! integration variables
      double precision jac                              ! jacobian
      double precision sqspr, costh34, m34
      double precision x1, x2, apdf_conv(4), b, b1
      double precision p3(4), p4(4), p5(4) ! lepton, nu, photon 4 momenta
      double precision ahard(4), qhard(4), scalef, scaler, alphasPDF
      double precision grnd, dir

      charge_id = processId/100
      fspart_id = abs(mod(processId,100))

      do icomp = 1,ncomp
        f(icomp) = 0d0
      enddo

      do in = 1,4
         ahard(in) = 0d0
      enddo

C     SCALE ARGUMENTS
      sqs   = limits(1)+(limits(2)-limits(1))*arg(1)
      y     = limits(3)+(limits(4)-limits(3))*arg(2)
      eta34 = limits(5)+(limits(6)-limits(5))*arg(3)
      sqspr = limits(7)+(limits(8)-limits(7))*arg(4)
      costh3 = limits(9)+(limits(10)-limits(9))*arg(5)
      phi3 = limits(11)+(limits(12)-limits(11))*arg(6)

c      sqs = 500d0
c      sqspr = 499d0
c      y = 0.5d0
c      eta34 = 0.5d0
c      costh3 = 0.5d0
c      phi3 = pi/4d0

      s      = sqs**2
      spr    = sqspr**2

      costh34 = dtanh(eta34)

      if ( sqs   .lt. (mf+mf1) ) return
      if ( sqspr .lt. (mf+mf1) ) return
      if ( sqspr .ge. (sqs-mup)) return
      if ( sqspr .ge. (sqs-mdn)) return

      if ( fspart_id .eq. idtopt ) then
         if ( sqspr .ge. (sqs-mbt) ) return
      endif

      jac   = (limits(2)-limits(1))*
     $        (limits(4)-limits(3))*
     $        (limits(6)-limits(5))*
     $        (limits(8)-limits(7))*
     $        (limits(10)-limits(9))*
     $        (limits(12)-limits(11))*
     $        2d0*sqs/sqs0**2/dcosh(eta34)**2*2d0*sqspr

C     Random direction switch, -1 - backward
      dir = 2d0*grnd() - 1d0
      if ( dir .le. 0 ) then 
        dir = -1d0
      else 
        dir = 1d0
      endif
c      dir = 1

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

c     different kinematics for inverse gluons
      call lrotateY(p3, dacos(-costh3))
      if ( fspart_id .eq. idtopt ) then
         call lrotateY(p4, -dacos(-costh3))
      else
         call lrotateY(p4, dacos(-costh3))
      endif
      call lrotateZ(p3, pi-phi3)
      call lrotateZ(p4, pi-phi3)
      b1 = (s-spr)/(s+spr)
      call lboostZ(p3, b1)
      call lboostZ(p4, b1)

      call lrotateX(p3, -dacos(costh34))
      call lrotateX(p4, -dacos(costh34))
      if ( dir .lt. 0d0 ) then
         p3(3) = -p3(3)
         p4(3) = -p4(3)
      endif
      b = -dtanh(y)
      call lboostZ(p3, b)
      call lboostZ(p4, b)

      is_cut = 0
      call check_cuts( is_cut, p3, p4 )
      if ( is_cut .eq. 1 ) return

C     alphas
      if ( fscale .gt.  0d0 ) scalef = fscale
      if ( fscale .lt.  0d0 ) scalef = sqspr*dabs(fscale)
      if ( rscale .gt.  0d0 ) scaler = rscale
      if ( rscale .lt.  0d0 ) scaler = sqspr*dabs(rscale)

      if ( rscale .lt. 0d0 .and. iqcd .ne. 0 .and. spr .lt. q2min ) return
      if ( iqcd .ne. 0 ) alphas = alphasPDF(scaler)

C     PDF convolution
      x1 = sqs/sqs0*dexp(dir*y)
      x2 = sqs/sqs0*dexp(-dir*y)
      if ( x1  .lt. xmin  .or. x1  .gt. xmax  ) return
      if ( x2  .lt. xmin  .or. x2  .gt. xmax  ) return

      if (iqed.ge.1) call pdf_conv_ph (x1,x2,scalef,apdf_conv)
      if (iqcd.ge.1) call pdf_conv_gl (x1,x2,scalef,apdf_conv)

      call sanc_gl (s,spr,phi3,costh3,costh34,ahard)
      do in=1,4
         f(1) = f(1) + ahard(in) * apdf_conv(in) * jac
      enddo

c      print *, x1,x2
c      print *, sqs, sqspr, phi3, costh3, costh34
c      print *, scalef,scaler
c      print *, ahard
c      print *, apdf_conv/2
c      print *, ahard(1) * apdf_conv(1) + ahard(2) * apdf_conv(2)
c      print *, f(1)
c      stop
c      write (11,*) "123"

      !print *, "func",ahard,apdf_conv
      !print *, "min_m34",min_m34
      !stop
      
      !print *, spr,s,y,wy,x1,x2
      !print *, jac,ahard,apdf_conv
      !print *, f(1)

      !print *, iborn,iqed,iew,iqcd,gfscheme,ilin,ifgg,its,irun
      !print *, "x1,x2",x1, x2
      !print *, "hard",ahard
      !print *, "pdf",apdf_conv
      !print *, "jac",jac
      !print *, "func",f(1)
      !stop

      if ( iter .ne. 1 .and. ixplore .ne. 1) then
        call fill_hists(f(1), vwgt, iter, p3, p4)
      endif
      end

C--------------------------------------------------------------
