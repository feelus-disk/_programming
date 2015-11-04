************************************************************************
* sanc_nc_v1.30 package.
************************************************************************
* File (nc_si_1313_42.f) is created on Wed Apr 18 13:47:50 MSK 2012.
************************************************************************
* This is the FORTRAN module (nc_si_1313_42) to calculate EW
* cross-section (width) by using the helicity amplitudes
* for the anti-up + up -> H + Z process.
*
* It is produced by s2n package of SANC (v1.10) Project.
* Copyright (C), SANC Project Team, 2002-2012.
*
* http://sanc.jinr.ru/
* http://pcphsanc.cern.ch/
* E-mail: <sanc@jinr.ru>
************************************************************************
      subroutine nc_si_1313_42 (s,t,u,sigma)
      implicit none!
      include 's2n_declare.h'

      integer iz,i,j,k,l,is,jj,izi
      real*8 sum,tw(2),sig(2)
      real*8 deltaa,deltar,dr_bos,dr_fer
      real*8 kappa,cof,nsig,twcoeff,twl,coeff,slams
      complex*16 zoro
      complex*16 ffgp0,ffgp1,ffgp2,ffgm0,ffgm1,ffgm2
      complex*16 ff_gp0,ff_gp1,ff_gp2,ff_gm0,ff_gm1,ff_gm2	  

      real*8 sqrtlszh

      complex*16 amp(2,2,3)
      real*8 costhz,sinthz
      complex*16 propzs,propizs,propzsc

      izi = 0
      if (ilin.eq.0) then
         twl = 0d0
      elseif (ilin.eq.1) then
         twl = 1d0
      endif

      cmz2 = mz2
      spr = s
      qs = -s
      ts = -t
      us = -u

      sqrtlszh = sqrt(s**2-2d0*s*(rzm2+rhm2)+(rzm2-rhm2)**2)
      cosf = (t-u)/sqrtlszh
      sinf = dsqrt(1d0-cosf**2)

      if (irun.eq.0) then
         propizs = (cmz2-s)
      else
         propizs = (dcmplx(mz**2,-s*wz/mz)-s)
      endif
      propzs = 1d0/propizs
      propzsc = dconjg(propzs)
      costhz = cosf
      sinthz = sinf
      nsig=1d0/4*1d0/2/s*(1d0/8/pi*sqrtlszh/s)*1d0/2*conhc/3
      if ((iborn.eq.1).or.(iew.eq.0)) then
         ff_gp0 = dcmplx(0d0,0d0)
         ff_gp1 = dcmplx(0d0,0d0)
         ff_gp2 = dcmplx(0d0,0d0)
         ff_gm0 = dcmplx(0d0,0d0)
         ff_gm1 = dcmplx(0d0,0d0)
         ff_gm2 = dcmplx(0d0,0d0)
      else
         coeff = cfprime*alpha/4d0/pi/stw2
         deltaa = (1-cfprime)
         call delr(deltar,dr_bos,dr_fer)
         deltar = coeff*deltar
         call UniBosConsts_Bos ()
         call UniBosConsts_Fer ()
         call UniProConsts_Fer (-s)
         call nc_ff_1313_42 (-s,-t,-u)

         ff_gp0 = coeff*ffarray(1,1)
         ff_gp1 = coeff*ffarray(1,2)
         ff_gp2 = coeff*ffarray(1,3)
         ff_gm0 = coeff*ffarray(1,4)
         ff_gm1 = coeff*ffarray(1,5)
         ff_gm2 = coeff*ffarray(1,6)

         if (iew.eq.1) then
            if ((gfscheme.ge.1).and.(gfscheme.le.3)) then
               ff_gp0 = ff_gp0-deltar
               ff_gm0 = ff_gm0-deltar
            endif
            if (gfscheme.eq.4) then
               ff_gp0 = ff_gp0-deltaa
               ff_gm0 = ff_gm0-deltaa
            endif
         endif
      endif

      do iz = izi,1
         zoro = dcmplx(iz,0d0)
         ffgp0 = zoro + ff_gp0
         ffgp1 =        ff_gp1
         ffgp2 =        ff_gp2
         ffgm0 = zoro + ff_gm0
         ffgm1 =        ff_gm1
         ffgm2 =        ff_gm2
         if (iz.eq.1) then
            ffarray(2,1) = ffgp0
            ffarray(2,2) = ffgp1
            ffarray(2,3) = ffgp2
            ffarray(2,4) = ffgm0
            ffarray(2,5) = ffgm1
            ffarray(2,6) = ffgm2
         endif

      amp(1,1,1) =
     & 0d0

      amp(1,1,3) =
     & 0d0

      amp(1,1,2) =
     & 0d0

      amp(1,2,1) =
     & +propzs*ffgp0*i_*g**2/sr2*(+1d0/2*costhz*sqrt(s)/ctw**2*vpaup*mz+
     & 1d0/2*sqrt(s)/ctw**2*vpaup*mz)
     & +propzs*ffgp1*i_*g**2/sr2*(+1d0/8*costhz**2*sqrt(s)*sqrtlszh/ctw*
     & *2*mz-1d0/8*sqrt(s)*sqrtlszh/ctw**2*mz)
     & +propzs*ffgp2*i_*g**2/sr2*(-1d0/8*costhz**2*sqrt(s)*sqrtlszh/ctw*
     & *2*mz+1d0/8*sqrt(s)*sqrtlszh/ctw**2*mz)

      amp(1,2,3) =
     & +propzs*ffgp0*i_*g**2*(-1d0/4*sinf/ctw**2*vpaup*s+1d0/4*sinf/ctw*
     & *2*vpaup*mh**2-1d0/4*sinf/ctw**2*vpaup*mz**2)
     & +propzs*ffgp1*i_*g**2*(-1d0/16*sinf/ctw**2*s**2+1d0/8*sinf/ctw**2
     & *mh**2*s-1d0/16*sinf/ctw**2*mh**4+1d0/8*sinf/ctw**2*mz**2*s+1d0/8
     & *sinf/ctw**2*mz**2*mh**2-1d0/16*sinf/ctw**2*mz**4-1d0/16*sinf*cos
     & thz*sqrtlszh/ctw**2*s+1d0/16*sinf*costhz*sqrtlszh/ctw**2*mh**2-1d
     & 0/16*sinf*costhz*sqrtlszh/ctw**2*mz**2)
     & +propzs*ffgp2*i_*g**2*(-1d0/16*sinf/ctw**2*s**2+1d0/8*sinf/ctw**2
     & *mh**2*s-1d0/16*sinf/ctw**2*mh**4+1d0/8*sinf/ctw**2*mz**2*s+1d0/8
     & *sinf/ctw**2*mz**2*mh**2-1d0/16*sinf/ctw**2*mz**4+1d0/16*sinf*cos
     & thz*sqrtlszh/ctw**2*s-1d0/16*sinf*costhz*sqrtlszh/ctw**2*mh**2+1d
     & 0/16*sinf*costhz*sqrtlszh/ctw**2*mz**2)

      amp(1,2,2) =
     & +propzs*ffgp0*i_*g**2/sr2*(-1d0/2*costhz*sqrt(s)/ctw**2*vpaup*mz+
     & 1d0/2*sqrt(s)/ctw**2*vpaup*mz)
     & +propzs*ffgp1*i_*g**2/sr2*(-1d0/8*costhz**2*sqrt(s)*sqrtlszh/ctw*
     & *2*mz+1d0/8*sqrt(s)*sqrtlszh/ctw**2*mz)
     & +propzs*ffgp2*i_*g**2/sr2*(+1d0/8*costhz**2*sqrt(s)*sqrtlszh/ctw*
     & *2*mz-1d0/8*sqrt(s)*sqrtlszh/ctw**2*mz)

      amp(2,1,1) =
     & +propzs*ffgm0*i_*g**2/sr2*(-1d0/2*costhz*sqrt(s)/ctw**2*vmaup*mz+
     & 1d0/2*sqrt(s)/ctw**2*vmaup*mz)
     & +propzs*ffgm1*i_*g**2/sr2*(-1d0/8*costhz**2*sqrt(s)*sqrtlszh/ctw*
     & *2*mz+1d0/8*sqrt(s)*sqrtlszh/ctw**2*mz)
     & +propzs*ffgm2*i_*g**2/sr2*(+1d0/8*costhz**2*sqrt(s)*sqrtlszh/ctw*
     & *2*mz-1d0/8*sqrt(s)*sqrtlszh/ctw**2*mz)

      amp(2,1,3) =
     & +propzs*ffgm0*i_*g**2*(+1d0/4*sinf/ctw**2*vmaup*s-1d0/4*sinf/ctw*
     & *2*vmaup*mh**2+1d0/4*sinf/ctw**2*vmaup*mz**2)
     & +propzs*ffgm1*i_*g**2*(+1d0/16*sinf/ctw**2*s**2-1d0/8*sinf/ctw**2
     & *mh**2*s+1d0/16*sinf/ctw**2*mh**4-1d0/8*sinf/ctw**2*mz**2*s-1d0/8
     & *sinf/ctw**2*mz**2*mh**2+1d0/16*sinf/ctw**2*mz**4+1d0/16*sinf*cos
     & thz*sqrtlszh/ctw**2*s-1d0/16*sinf*costhz*sqrtlszh/ctw**2*mh**2+1d
     & 0/16*sinf*costhz*sqrtlszh/ctw**2*mz**2)
     & +propzs*ffgm2*i_*g**2*(+1d0/16*sinf/ctw**2*s**2-1d0/8*sinf/ctw**2
     & *mh**2*s+1d0/16*sinf/ctw**2*mh**4-1d0/8*sinf/ctw**2*mz**2*s-1d0/8
     & *sinf/ctw**2*mz**2*mh**2+1d0/16*sinf/ctw**2*mz**4-1d0/16*sinf*cos
     & thz*sqrtlszh/ctw**2*s+1d0/16*sinf*costhz*sqrtlszh/ctw**2*mh**2-1d
     & 0/16*sinf*costhz*sqrtlszh/ctw**2*mz**2)

      amp(2,1,2) =
     & +propzs*ffgm0*i_*g**2/sr2*(+1d0/2*costhz*sqrt(s)/ctw**2*vmaup*mz+
     & 1d0/2*sqrt(s)/ctw**2*vmaup*mz)
     & +propzs*ffgm1*i_*g**2/sr2*(+1d0/8*costhz**2*sqrt(s)*sqrtlszh/ctw*
     & *2*mz-1d0/8*sqrt(s)*sqrtlszh/ctw**2*mz)
     & +propzs*ffgm2*i_*g**2/sr2*(-1d0/8*costhz**2*sqrt(s)*sqrtlszh/ctw*
     & *2*mz+1d0/8*sqrt(s)*sqrtlszh/ctw**2*mz)

      amp(2,2,1) =
     & 0d0

      amp(2,2,3) =
     & 0d0

      amp(2,2,2) =
     & 0d0

         sum = 0d0
         do i=1,2
            do j=1,2
               do k=1,3
                  sum = sum+amp(i,j,k)*dconjg(amp(i,j,k))
               enddo
            enddo
         enddo
         sig(iz+1) = nsig*sum
      enddo

      sigma = sig(2)-twl*sig(1)

      return
      end
