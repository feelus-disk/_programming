************************************************************************
* sanc_cc_v1.40 package.
************************************************************************
* File (cc_si_2213_1421.f) is created on Tue Aug  9 22:51:19 MSD 2011.
************************************************************************
* This is the FORTRAN module (cc_si_2213_1421) to calculate EW
* cross-section (width) by using the helicity amplitudes
* for the bt + up -> dn + tp process.
*
* It is produced by s2n package of SANC (v1.10) Project.
* Copyright (C), SANC Project Team, 2002-2011.
*
* http://sanc.jinr.ru/
* http://pcphsanc.cern.ch/
* E-mail: <sanc@jinr.ru>
************************************************************************
      subroutine cc_si_2213_1421 (s,t,u,sigma)
      implicit none!
      include 's2n_declare.h'

      integer iz,i,j,k,l,is,jj,izi
      real*8 sum,tw(2),sig(2)
      real*8 deltar,dr_bos,dr_fer
      real*8 kappa,cof,nsig,twcoeff,twl,coeff,slams
      complex*16 zoro
      real*8 sqrtlsctp
      real*8 nuu14,nmuu23
      complex*16 ff_ll,ff_rl,ff_ld,ff_rd,ffll,ffrl,ffld,ffrd

      complex*16 amp(2,2,2,2)
      real*8 costhdn,sinthdn
      real*8 kappaw
      complex*16 chiwspr,chiwsprc

      izi = 0
      if (ilin.eq.0) then
         twl = 0d0
      elseif (ilin.eq.1) then
         twl = 1d0
      endif

      cmw2 = rwm2
      spr = t


      cosf = (t-u)/(s-mtp**2)
      sinf = dsqrt(1d0-cosf**2)

      costhdn = cosf
      sinthdn = sinf
      chiwspr = 2d0/(spr-cmw2)*gf*mw**2
      chiwsprc = dconjg(chiwspr)


      nuu14 = sqrt(2d0*s/(s**2*(1-cosf) + s*mtp**2*(1+cosf)))
      nmuu23 = sqrt((s-mtp**2)/2d0)

      sqrtlsctp = s-mtp**2
      nsig = 1d0/4*1d0/2/s*(1d0/8/pi*sqrtlsctp/s)*conhc

      if ((iborn.eq.1).or.(iew.eq.0)) then
         ff_ll  = dcmplx(0d0,0d0)
         ff_rl  = dcmplx(0d0,0d0)
         ff_ld  = dcmplx(0d0,0d0)
         ff_rd  = dcmplx(0d0,0d0)
      else
         coeff = cfprime*alpha/4d0/pi/stw2
         call delr(deltar,dr_bos,dr_fer)
         call UniBosConsts_Bos ()
         call UniBosConsts_Fer ()
         call UniProConsts_fer (-s)
         call cc_ff_2213_1421 (-t,-u,-s)
         ff_ll  = coeff*ffarray(1,1)
         ff_rl  = coeff*ffarray(1,2)
         ff_ld  = coeff*ffarray(1,3)
         ff_rd  = coeff*ffarray(1,4)

         if (gfscheme.ge.1) then
            ff_ll = ff_ll-coeff*deltar
         endif
      endif

      do iz = izi,1
         zoro = dcmplx(iz,0d0)

         ffll = zoro + ff_ll
         ffrl =        ff_rl
         ffld =        ff_ld
         ffrd =        ff_rd

         if (iz.eq.1) then
            ffarray(2,1) = ff_ll 
            ffarray(2,2) = ff_rl 
            ffarray(2,3) = ff_ld
            ffarray(2,3) = ff_rd
	 endif

      amp(2,2,2,2) =
     & +chiwspr*sinthdn**2*sqrt(s)*nuu14**2*nmuu23*ffrl*s*(2/sr2)
     & +chiwspr*sinthdn**2*sqrt(s)*nuu14**2*nmuu23*ffld*s*(2/sr2*mtp)
     & +chiwspr*sinthdn**2*sqrt(s)*nuu14**2*nmuu23*ffrd*s*(-2/sr2*mtp)
     & +chiwspr*costhdn*sqrt(s)*nuu14**2*nmuu23*ffll*s*(4/sr2)
     & +chiwspr*costhdn*sqrt(s)*nuu14**2*nmuu23*ffrl*s*(4/sr2)
     & +chiwspr*costhdn*sqrt(s)*nmuu23*ffrl*(-4/sr2)
     & +chiwspr*costhdn*sqrt(s)*nmuu23*ffld*(-2/sr2*mtp)
     & +chiwspr*sqrt(s)*nuu14**2*nmuu23*ffll*s*(-4/sr2)
     & +chiwspr*sqrt(s)*nuu14**2*nmuu23*ffrl*s*(-4/sr2)
     & +chiwspr*sqrt(s)*nmuu23*ffll*(4/sr2)
     & +chiwspr*sqrt(s)*nmuu23*ffrl*(4/sr2)
     & +chiwspr*sqrt(s)*nmuu23*ffld*(-2/sr2*mtp)

      amp(2,2,2,1) =
     & +chiwspr*sinthdn*costhdn*nuu14**2*nmuu23*ffrl*s*(2/sr2*mtp)
     & +chiwspr*sinthdn*costhdn*nuu14**2*nmuu23*ffld*s**2*(2/sr2)
     & +chiwspr*sinthdn*costhdn*nuu14**2*nmuu23*ffrd*s**2*(-2/sr2)
     & +chiwspr*sinthdn*nuu14**2*nmuu23*ffrl*s*(2/sr2*mtp)
     & +chiwspr*sinthdn*nuu14**2*nmuu23*ffld*s**2*(-2/sr2)
     & +chiwspr*sinthdn*nuu14**2*nmuu23*ffrd*s**2*(2/sr2)
     & +chiwspr*sinthdn*nmuu23*ffld*s*(2/sr2)
     & +chiwspr*sinthdn*nmuu23*ffrd*s*(-4/sr2)

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
     & +chiwspr*sinthdn*costhdn*nuu14**2*nmuu23*ffrl*s*(2/sr2*mtp)
     & +chiwspr*sinthdn*costhdn*nuu14**2*nmuu23*ffld*s**2*(2/sr2)
     & +chiwspr*sinthdn*costhdn*nuu14**2*nmuu23*ffrd*s**2*(-2/sr2)
     & +chiwspr*sinthdn*nuu14**2*nmuu23*ffll*s*(-4/sr2*mtp)
     & +chiwspr*sinthdn*nuu14**2*nmuu23*ffrl*s*(-2/sr2*mtp)
     & +chiwspr*sinthdn*nuu14**2*nmuu23*ffld*s**2*(-2/sr2)
     & +chiwspr*sinthdn*nuu14**2*nmuu23*ffrd*s**2*(2/sr2)
     & +chiwspr*sinthdn*nmuu23*ffrl*(2/sr2*mtp)
     & +chiwspr*sinthdn*nmuu23*ffld*s*(4/sr2)
     & +chiwspr*sinthdn*nmuu23*ffrd*s*(-2/sr2)

      amp(1,2,2,1) =
     & +chiwspr*sinthdn**2*sqrt(s)*nuu14**2*nmuu23*ffrl*s*(-2/sr2)
     & +chiwspr*sinthdn**2*sqrt(s)*nuu14**2*nmuu23*ffld*s*(-2/sr2*mtp)
     & +chiwspr*sinthdn**2*sqrt(s)*nuu14**2*nmuu23*ffrd*s*(2/sr2*mtp)
     & +chiwspr*costhdn*sqrt(s)*nmuu23*ffrl*(2/sr2)
     & +chiwspr*costhdn*sqrt(s)*nmuu23*ffrd*(-2/sr2*mtp)
     & +chiwspr*sqrt(s)*nmuu23*ffrl*(2/sr2)
     & +chiwspr*sqrt(s)*nmuu23*ffrd*(-2/sr2*mtp)

      amp(1,2,1,2) =
     & 0d0

      amp(1,2,1,1) =
     & 0d0

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
