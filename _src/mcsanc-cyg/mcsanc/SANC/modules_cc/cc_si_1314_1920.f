************************************************************************
* sanc_cc_v1.40 package.
************************************************************************
* File (cc_si_1314_1920.f) is created on Tue Aug  9 22:36:27 MSD 2011.
************************************************************************
* This is the FORTRAN module (cc_si_1314_1920) to calculate EW
* cross-section (width) by using the helicity amplitudes
* for the anti-up + dn -> tn + ta^- process.
*
* It is produced by s2n package of SANC (v1.10) Project.
* Copyright (C), SANC Project Team, 2002-2011.
*
* http://sanc.jinr.ru/
* http://pcphsanc.cern.ch/
* E-mail: <sanc@jinr.ru>
************************************************************************
      subroutine cc_si_1314_1920 (s,t,u,sigma)
      implicit none!
      include 's2n_declare.h'

      integer iz,i,j,k,l,is,jj,izi
      real*8 sum,tw(2),sig(2)
      real*8 deltar,dr_bos,dr_fer
      real*8 kappa,cof,nsig,twcoeff,twl,coeff,slams
      complex*16 zoro
      complex*16 ff_ew_ll,ff_ew_ld,ff_ew_rd
      complex*16 ff_ll,ff_ld,ff_rd,ffll,ffld,ffrd

      complex*16 amp(2,2,2,2)
      real*8 sqrtpxstac,isqrtpxstac,pxstac
      real*8 costhta,sinthta
      real*8 kappaw
      complex*16 chiws,chiwsc

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


      cosf = (u-t)/(s-mta**2)
      sinf = dsqrt(1d0-cosf**2)

      sqrtpxstac = sqrt(abs(s-mta**2))
      isqrtpxstac = 1d0/sqrtpxstac
      pxstac = (sqrtpxstac)**2
      costhta = -cosf
      sinthta = sinf
      
      kappaw = gf*rwm2/(sqrt(2d0)*4d0*pi)/alpha
      if (irun.eq.0) then
         chiws = 4d0*kappaw*s/(s-cmw2)
      else
         chiws = 4d0*kappaw*s/(s-dcmplx(mw**2,-s*ww/mw))
      endif
      chiwsc = dconjg(chiws)

      nsig = pi*alpha**2*conhc/s*(1d0-mta**2/s)/3

      if ((iborn.eq.1).or.(iew.eq.0)) then
         ff_ll = dcmplx(0d0,0d0)
         ff_ld = dcmplx(0d0,0d0)
         ff_rd = dcmplx(0d0,0d0)
      else
         coeff = cfprime*alpha/4d0/pi/stw2
         call delr(deltar,dr_bos,dr_fer)
         call UniBosConsts_Bos ()
         call UniBosConsts_Fer ()
         call UniProConsts_fer (-s)
         call cc_ff_1314_1920 (-s,-t,-u)

         ff_ll = coeff*ffarray(1,1)
         ff_ld = coeff*ffarray(1,2)
         ff_rd = coeff*ffarray(1,3)

         if (gfscheme.ge.1) then
            ff_ll = ff_ll-coeff*deltar
         endif
      endif

      do iz = izi,1
         zoro = dcmplx(iz,0d0)

         ffll = zoro + ff_ll
         ffld =        ff_ld
         ffrd =        ff_rd

         if (iz.eq.1) then
            ffarray(2,1) = ffll
            ffarray(2,2) = ffld
            ffarray(2,3) = ffrd
	 endif

      amp(1,1,1,1) =
     & 0d0

      amp(1,1,1,2) =
     & 0d0

      amp(1,1,2,1) =
     & 0d0

      amp(1,1,2,2) =
     & 0d0

      amp(1,2,1,1) =
     & +chiws*sinthta*sqrtpxstac*ffll*(-mta/s)
     & +chiws*sinthta*sqrtpxstac*ffld*(-1+mta**2/s)

      amp(1,2,1,2) =
     & 0d0

      amp(1,2,2,1) =
     & +chiws*costhta*1d0/sqrt(s)*sqrtpxstac*ffll*(-1)
     & +chiws*1d0/sqrt(s)*sqrtpxstac*ffll*(-1)

      amp(1,2,2,2) =
     & 0d0

      amp(2,1,1,1) =
     & 0d0

      amp(2,1,1,2) =
     & 0d0

      amp(2,1,2,1) =
     & 0d0

      amp(2,1,2,2) =
     & 0d0

      amp(2,2,1,1) =
     & 0d0

      amp(2,2,1,2) =
     & 0d0

      amp(2,2,2,1) =
     & 0d0

      amp(2,2,2,2) =
     & 0d0

         sum = 0d0
         do i = 1,2
            do j = 1,2
               do k = 1,2
                  do l = 1,2
                     sum = sum+amp(i,j,k,l)*dconjg(amp(i,j,k,l))
                  enddo
               enddo
            enddo
         enddo
         sig(iz+1) = nsig*sum/8d0
      enddo

      sigma = sig(2)-twl*sig(1)

      return
      end
