************************************************************************
* sanc_cc_v1.50 package.
************************************************************************
* File (cc_si_1413_43.f) is created on Thu Jan 19 01:32:23 MSK 2012.
************************************************************************
* This is the FORTRAN module (cc_si_1413_43) to calculate EW
* cross-section (width) by using the helicity amplitudes
* for the anti-dn + up -> H   + W^+ process.
*
* It is produced by s2n package of SANC (v1.10) Project.
* Copyright (C), SANC Project Team, 2002-2012.
*
* http://sanc.jinr.ru/
* http://pcphsanc.cern.ch/
* E-mail: <sanc@jinr.ru>
************************************************************************
      subroutine cc_si_1413_43 (s,t,u,sigma)
      implicit none!
      include 's2n_declare.h'

      integer iz,i,j,k,l,is,jj,izi
      real*8 sum,tw(2),sig(2)
      real*8 deltar,dr_bos,dr_fer
      real*8 kappa,cof,nsig,twcoeff,twl,coeff,slams
      complex*16 zoro
      complex*16 ffgp0,ffgp1,ffgp2,ff_gp0,ff_gp1,ff_gp2

      complex*16 amp(2,2,3)
      real*8 sqrtlswh,isqrtlswh
      real*8 costhw,sinthw
      complex*16 propws,propiws

      izi = 0
      if (ilin.eq.0) then
         twl = 0d0
      elseif (ilin.eq.1) then
         twl = 1d0
      endif

      cmw2 = mw2
      spr = s
      qs = -s
      ts = -t
      us = -u

      sqrtlswh = dsqrt((s-mw**2-mh**2)**2-4d0*mw**2*mh**2)
      cosf = (u-t)/sqrtlswh
      sinf = dsqrt(1d0-cosf**2)

      if (irun.eq.0) then
         propiws = (cmw2-s)
      elseif (irun.eq.1) then
         propiws = (dcmplx(mw**2,-s*ww/mw)-s)
      endif
      propws = 1d0/propiws

      sqrtlswh = sqrt(s**2-2d0*s*(rwm2+rhm2)+(rwm2-rhm2)**2)
      isqrtlswh = 1d0/sqrtlswh
      costhw = cosf
      sinthw = sinf

      nsig = 1d0/4/2/s*(1d0/8/pi*sqrtlswh/s)/2*conhc/3

      if ((iborn.eq.1).or.(iew.eq.0)) then
         ff_gp0 = dcmplx(0d0,0d0) 
         ff_gp1 = dcmplx(0d0,0d0)
         ff_gp2 = dcmplx(0d0,0d0)
      else
         coeff = cfprime*alpha/4d0/pi/stw2
         call delr(deltar,dr_bos,dr_fer)
         call UniBosConsts_Bos ()
         call UniBosConsts_Fer ()
         call UniProConsts_fer (-s)
         call cc_ff_1413_43 (-s,-t,-u)

         ff_gp0 = coeff*ffarray(1,1)
         ff_gp1 = coeff*ffarray(1,2)
         ff_gp2 = coeff*ffarray(1,3)

         if (gfscheme.ge.1) then
            ff_gp0 = ff_gp0-coeff*deltar
         endif
      endif

      do iz = izi,1
         zoro = dcmplx(iz,0d0)

         ffgp0 = zoro + ff_gp0
         ffgp1 =        ff_gp1
         ffgp2 =        ff_gp2

         if (iz.eq.1) then
            ffarray(2,1) = ff_gp0
            ffarray(2,2) = ff_gp1
            ffarray(2,3) = ff_gp2
	 endif

      amp(1,1,1) =
     & 0d0

      amp(1,1,3) =
     & 0d0

      amp(1,1,2) =
     & 0d0

      amp(1,2,1) =
     & +propws*sqrt(s)*sqrtlswh*ffgp1*i_*g**2*mw*(-1d0/8+1d0/8*costhw**2
     & )
     & +propws*sqrt(s)*sqrtlswh*ffgp2*i_*g**2*mw*(1d0/8-1d0/8*costhw**2)
     & +propws*sqrt(s)*ffgp0*i_*g**2*mw*(1d0/2+1d0/2*costhw)

      amp(1,2,3) =
     & +propws*sqrtlswh*ffgp1*i_*g**2/sr2*(-1d0/8*sinf*costhw*s)
     & +propws*sqrtlswh*ffgp1*i_*g**2/sr2*mh**2*(1d0/8*sinf*costhw)
     & +propws*sqrtlswh*ffgp1*i_*g**2/sr2*mw**2*(-1d0/8*sinf*costhw)
     & +propws*sqrtlswh*ffgp2*i_*g**2/sr2*(1d0/8*sinf*costhw*s)
     & +propws*sqrtlswh*ffgp2*i_*g**2/sr2*mh**2*(-1d0/8*sinf*costhw)
     & +propws*sqrtlswh*ffgp2*i_*g**2/sr2*mw**2*(1d0/8*sinf*costhw)
     & +propws*ffgp0*i_*g**2/sr2*(-1d0/2*sinf*s)
     & +propws*ffgp0*i_*g**2/sr2*mh**2*(1d0/2*sinf)
     & +propws*ffgp0*i_*g**2/sr2*mw**2*(-1d0/2*sinf)
     & +propws*ffgp1*i_*g**2/sr2*(-1d0/8*sinf*s**2)
     & +propws*ffgp1*i_*g**2/sr2*mh**2*(1d0/4*sinf*s)
     & +propws*ffgp1*i_*g**2/sr2*mh**4*(-1d0/8*sinf)
     & +propws*ffgp1*i_*g**2/sr2*mw**2*(1d0/4*sinf*s)
     & +propws*ffgp1*i_*g**2/sr2*mw**2*mh**2*(1d0/4*sinf)
     & +propws*ffgp1*i_*g**2/sr2*mw**4*(-1d0/8*sinf)
     & +propws*ffgp2*i_*g**2/sr2*(-1d0/8*sinf*s**2)
     & +propws*ffgp2*i_*g**2/sr2*mh**2*(1d0/4*sinf*s)
     & +propws*ffgp2*i_*g**2/sr2*mh**4*(-1d0/8*sinf)
     & +propws*ffgp2*i_*g**2/sr2*mw**2*(1d0/4*sinf*s)
     & +propws*ffgp2*i_*g**2/sr2*mw**2*mh**2*(1d0/4*sinf)
     & +propws*ffgp2*i_*g**2/sr2*mw**4*(-1d0/8*sinf)

      amp(1,2,2) =
     & +propws*sqrt(s)*sqrtlswh*ffgp1*i_*g**2*mw*(1d0/8-1d0/8*costhw**2)
     & +propws*sqrt(s)*sqrtlswh*ffgp2*i_*g**2*mw*(-1d0/8+1d0/8*costhw**2
     & )
     & +propws*sqrt(s)*ffgp0*i_*g**2*mw*(1d0/2-1d0/2*costhw)

      amp(2,1,1) =
     & 0d0

      amp(2,1,3) =
     & 0d0

      amp(2,1,2) =
     & 0d0

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
