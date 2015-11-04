************************************************************************
* sanc_cc_v1.40 package.
************************************************************************
* File (cc_si_1314_2122.f) is created on Tue Aug  9 22:46:44 MSD 2011.
************************************************************************
* This is the FORTRAN module (cc_si_1314_2122) to calculate EW
* cross-section (width) by using the helicity amplitudes
* for the anti-up + dn -> anti-tp + bt process.
*
* It is produced by s2n package of SANC (v1.10) Project.
* Copyright (C), SANC Project Team, 2002-2011.
*
* http://sanc.jinr.ru/
* http://pcphsanc.cern.ch/
* E-mail: <sanc@jinr.ru>
************************************************************************
      subroutine cc_si_1314_2122 (s,t,u,sigma)
      implicit none!
      include 's2n_declare.h'

      integer iz,i,j,k,l,is,jj,izi
      real*8 sum,tw(2),sig(2)
      real*8 deltar,dr_bos,dr_fer
      real*8 kappa,cof,nsig,twcoeff,twl,coeff,slams
      complex*16 zoro
      complex*16 ff_ll,ff_lr,ff_ld,ff_rd,ffll,fflr,ffld,ffrd

      complex*16 amp(2,2,2,2)
      real*8 sqrtpxsctp,isqrtpxsctp,pxsctp
      real*8 costhbt,sinthbt
      real*8 kappaw
      complex*16 chiwspr,chiwsprc

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


      cosf = (t-u)/(s-mtp**2)
      sinf = dsqrt(1d0-cosf**2)

      sqrtpxsctp = sqrt(abs(s-mtp**2))
      isqrtpxsctp = 1d0/sqrtpxsctp
      pxsctp = (sqrtpxsctp)**2
      costhbt = cosf
      sinthbt = sinf
      
      kappaw = gf*rwm2/(sqrt(2d0)*4d0*pi)/alpha
      if (irun.eq.0) then
         chiwspr = 4d0*kappaw*spr/(spr-cmw2)
      else
         chiwspr = 4d0*kappaw*spr/(spr-dcmplx(mw**2,-spr*ww/mw))
      endif
      chiwsprc = dconjg(chiwspr)

      nsig = conhc/4/pi*(s-mtp**2)/s**2*e**4/4/s**2/8

      if ((iborn.eq.1).or.(iew.eq.0)) then
         ff_ll = dcmplx(0d0,0d0) 
         ff_lr = dcmplx(0d0,0d0)
         ff_ld = dcmplx(0d0,0d0)
         ff_rd = dcmplx(0d0,0d0)
      else
         coeff = cfprime*alpha/4d0/pi/stw2
         call delr(deltar,dr_bos,dr_fer)
         call UniBosConsts_Bos ()
         call UniBosConsts_Fer ()
         call UniProConsts_fer (-s)
         call cc_ff_1314_2122 (-s,-t,-u)

         ff_ll = coeff*ffarray(1,1)
         ff_lr = coeff*ffarray(1,2)
         ff_ld = coeff*ffarray(1,3)
         ff_rd = coeff*ffarray(1,4)

         if (gfscheme.ge.1) then
            ff_ll = ff_ll-coeff*deltar
         endif
      endif

      do iz = izi,1
         zoro = dcmplx(iz,0d0)

         ffll = zoro + ff_ll
         fflr =        ff_lr
         ffld =        ff_ld
         ffrd =        ff_rd

         if (iz.eq.1) then
            ffarray(2,1) = ff_ll 
            ffarray(2,2) = ff_lr 
            ffarray(2,3) = ff_ld
            ffarray(2,3) = ff_rd
	 endif

      amp(2,2,2,2) =
     & 0d0

      amp(2,2,2,1) =
     & 0d0

      amp(2,2,1,2) =
     & 0d0

      amp(2,2,1,1) =
     & 0d0

      amp(2,1,2,2) =
     & 0d0

      amp(2,1,2,1) =
     & 0d0

      amp(2,1,1,2) =
     & 0d0

      amp(2,1,1,1) =
     & 0d0

      amp(1,2,2,2) =
     & +chiwspr*sinthbt*isqrtpxsctp*ffll*(-1d0/2*mtp*s+1d0/2*mtp**3)
     & +chiwspr*sinthbt*isqrtpxsctp*fflr*(-1d0/2*mtp*s+1d0/2*mtp**3)
     & +chiwspr*sinthbt*sqrtpxsctp*ffll*(-1d0/2*mtp)
     & +chiwspr*sinthbt*sqrtpxsctp*ffrd*(-s+mtp**2)
     & +chiwspr*sinthbt*sqrtpxsctp*fflr*(1d0/2*mtp)

      amp(1,2,2,1) =
     & +chiwspr*sqrt(s)*sqrtpxsctp*ffll*(-1d0/2-1d0/2*costhbt)
     & +chiwspr*sqrt(s)*sqrtpxsctp*fflr*(1d0/2+1d0/2*costhbt)
     & +chiwspr*1d0/sqrt(s)*isqrtpxsctp*ffll*(-1d0/2*mtp**2*s+1d0/2*mtp*
     & *4-1d0/2*costhbt*mtp**2*s+1d0/2*costhbt*mtp**4)
     & +chiwspr*1d0/sqrt(s)*isqrtpxsctp*fflr*(-1d0/2*mtp**2*s+1d0/2*mtp*
     & *4-1d0/2*costhbt*mtp**2*s+1d0/2*costhbt*mtp**4)
     & +chiwspr*1d0/sqrt(s)*sqrtpxsctp*ffll*(-1d0/2*s+1d0/2*mtp**2-1d0/2
     & *costhbt*s+1d0/2*costhbt*mtp**2)
     & +chiwspr*1d0/sqrt(s)*sqrtpxsctp*fflr*(-1d0/2*s+1d0/2*mtp**2-1d0/2
     & *costhbt*s+1d0/2*costhbt*mtp**2)

      amp(1,2,1,2) =
     & +chiwspr*sqrt(s)*sqrtpxsctp*ffll*(1d0/2-1d0/2*costhbt)
     & +chiwspr*sqrt(s)*sqrtpxsctp*fflr*(-1d0/2+1d0/2*costhbt)
     & +chiwspr*1d0/sqrt(s)*isqrtpxsctp*ffll*(-1d0/2*mtp**2*s+1d0/2*mtp*
     & *4+1d0/2*costhbt*mtp**2*s-1d0/2*costhbt*mtp**4)
     & +chiwspr*1d0/sqrt(s)*isqrtpxsctp*fflr*(-1d0/2*mtp**2*s+1d0/2*mtp*
     & *4+1d0/2*costhbt*mtp**2*s-1d0/2*costhbt*mtp**4)
     & +chiwspr*1d0/sqrt(s)*sqrtpxsctp*ffll*(-1d0/2*s+1d0/2*mtp**2+1d0/2
     & *costhbt*s-1d0/2*costhbt*mtp**2)
     & +chiwspr*1d0/sqrt(s)*sqrtpxsctp*fflr*(-1d0/2*s+1d0/2*mtp**2+1d0/2
     & *costhbt*s-1d0/2*costhbt*mtp**2)

      amp(1,2,1,1) =
     & +chiwspr*sinthbt*isqrtpxsctp*ffll*(-1d0/2*mtp*s+1d0/2*mtp**3)
     & +chiwspr*sinthbt*isqrtpxsctp*fflr*(-1d0/2*mtp*s+1d0/2*mtp**3)
     & +chiwspr*sinthbt*sqrtpxsctp*ffll*(1d0/2*mtp)
     & +chiwspr*sinthbt*sqrtpxsctp*ffld*(-s+mtp**2)
     & +chiwspr*sinthbt*sqrtpxsctp*fflr*(-1d0/2*mtp)

      amp(1,1,2,2) =
     & 0d0

      amp(1,1,2,1) =
     & 0d0

      amp(1,1,1,2) =
     & 0d0

      amp(1,1,1,1) =
     & 0d0

         sum = 0d0
         do i=1,2
            do j=1,2
               do k=1,2
                  do l=1,2
                     sum = sum+amp(i,j,k,l)*dconjg(amp(i,j,k,l))
                  enddo
               enddo
            enddo
         enddo
         sig(iz+1) = nsig*sum
      enddo

      sigma = sig(2)-twl*sig(1)

      return
      end
