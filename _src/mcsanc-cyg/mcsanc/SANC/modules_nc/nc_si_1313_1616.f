************************************************************************
* sanc_nc_v1.30 package.
************************************************************************
* File (nc_si_1313_1616.f) is created on Wed Apr 18 13:09:52 MSK 2012.
************************************************************************
* This is the FORTRAN module (nc_si_1313_1616) to calculate EW
* cross-section (width) by using the helicity amplitudes
* for the anti-up + up -> mo^+ + mo^- process.
*
* It is produced by s2n package of SANC (v1.10) Project.
* Copyright (C), SANC Project Team, 2002-2012.
*
* http://sanc.jinr.ru/
* http://pcphsanc.cern.ch/
* E-mail: <sanc@jinr.ru>
************************************************************************
      subroutine nc_si_1313_1616 (s,t,u,sigma)
      implicit none!
      include 's2n_declare.h'

      integer iz,i,j,k,l,is,jj,izi
      real*8 sum,tw(2),sig(2)
      real*8 deltaa,deltar,dr_bos,dr_fer
      real*8 kappa,cof,nsig,twcoeff,twl,coeff,slams
      complex*16 zoro
      complex*16 ff_qed_ll,ff_qed_lq,ff_qed_ql,ff_qed_qq,ff_qed_ld
      complex*16 ff_qed_qd,ff_ew_ll,ff_ew_lq,ff_ew_ql,ff_ew_qq
      complex*16 ff_ew_ld,ff_qed_gg
      complex*16 ff_ll,ff_lq,ff_ql,ff_qq,ff_ld,ff_qd,ff_gg
      complex*16 ffll,fflq,ffql,ffqq,ffld,ffqd,ffgg


      real*8 betasmomo

      complex*16 amp(2,2,2,2)
      real*8 sqrtpxsmomo,isqrtpxsmomo,pxsmomo
      real*8 costhmo,sinthmo
      real*8 kappaz
      complex*16 chizs,chizsc

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

      if (dabs(s-mz**2).le.1d-4) s = (mz**2-1d-4)

      betasmomo = sqrt(1d0-4d0*mmo**2/s)
      cosf = (t-u)/s/betasmomo
      sinf = dsqrt(1d0-cosf**2)

      sqrtpxsmomo = sqrt(abs(s-(mmo+mmo)**2))
      isqrtpxsmomo = 1d0/sqrtpxsmomo
      pxsmomo = (sqrtpxsmomo)**2
      costhmo = cosf
      sinthmo = sinf
      
      kappaz = gf*rzm2/(sqrt(2d0)*8d0*pi)/alpha
      if (irun.eq.0) then
         chizs = 4d0*kappaz*s/(s-cmz2)
      else
         chizs = 4d0*kappaz*s/(s-dcmplx(mz**2,-s*wz/mz))
      endif
      chizsc = dconjg(chizs)

      nsig = pi*alpha**2*conhc/s*betasmomo/3

      if (iborn.eq.0) then
         coeff = cfprime*alpha/4d0/pi/stw2
 
         igzm2 = 1
         deltaa = (1-cfprime)
         call delr(deltar,dr_bos,dr_fer)
         deltar = coeff*deltar
         call UniBosConsts_Bos ()
         call UniBosConsts_Fer ()
         call UniProConsts_fer (-s)
         call nc_ff_1313_1616 (-s,-t,-u)

         if ((iew.eq.0).and.(iqed.ge.1)) then
            ff_ll = coeff*ffarray(1,1)
            ff_lq = coeff*ffarray(1,3)
            ff_ql = coeff*ffarray(1,5)
            ff_qq = coeff*ffarray(1,7)
            ff_ld = coeff*ffarray(1,9)
            ff_qd = coeff*ffarray(1,11)
            ff_gg = dcmplx(0d0,0d0)
            deltaa = 0d0
            deltar = 0d0
         elseif ((iew.eq.1).and.(iqed.eq.0)) then
            ff_ll = coeff*ffarray(1,2)
            ff_lq = coeff*ffarray(1,4)
            ff_ql = coeff*ffarray(1,6)
            ff_qq = coeff*ffarray(1,8)
            ff_ld = coeff*ffarray(1,10)
            ff_qd = coeff*ffarray(1,12)
            ff_gg = coeff*ffarray(1,13)
         elseif ((iew.eq.1).and.(iqed.ge.1)) then
            ff_ll = coeff*(ffarray(1,1)  + ffarray(1,2))
            ff_lq = coeff*(ffarray(1,3)  + ffarray(1,4))
            ff_ql = coeff*(ffarray(1,5)  + ffarray(1,6))
            ff_qq = coeff*(ffarray(1,7)  + ffarray(1,8))
            ff_ld = coeff*(ffarray(1,9)  + ffarray(1,10))
            ff_qd = coeff*(ffarray(1,11) + ffarray(1,12))
            ff_gg = coeff*ffarray(1,13)
         elseif ((iew.eq.0).and.(iqed.eq.0)) then
            ff_ll = dcmplx(0d0,0d0)
            ff_lq = dcmplx(0d0,0d0)
            ff_ql = dcmplx(0d0,0d0)
            ff_qq = dcmplx(0d0,0d0)
            ff_ld = dcmplx(0d0,0d0)
            ff_qd = dcmplx(0d0,0d0)
            ff_gg = coeff*ffarray(1,13)
            deltar = 0d0
         endif

         if (iew.eq.1) then
            if ((gfscheme.ge.1).and.(gfscheme.le.3)) then
               ff_ll = ff_ll-deltar
               ff_ql = ff_ql-deltar
               ff_lq = ff_lq-deltar
               ff_qq = ff_qq-deltar
            endif
            if (gfscheme.eq.4) then
               ff_ll = ff_ll-deltaa
               ff_ql = ff_ql-deltaa
               ff_lq = ff_lq-deltaa
               ff_qq = ff_qq-deltaa
            endif
         endif

         if ((gfscheme.eq.2).or.(gfscheme.eq.3)) ff_gg = ff_gg-deltar
         if (gfscheme.eq.4) ff_gg = ff_gg-deltaa

      elseif (iborn.eq.1) then
         ff_ll = dcmplx(0d0,0d0)
         ff_ql = dcmplx(0d0,0d0)
         ff_lq = dcmplx(0d0,0d0)
         ff_qq = dcmplx(0d0,0d0)
         ff_ld = dcmplx(0d0,0d0)
         ff_qd = dcmplx(0d0,0d0)
         ff_gg = dcmplx(0d0,0d0)
      endif

      do iz = izi,1
         zoro = dcmplx(iz,0d0)

         ffll = zoro + ff_ll
         ffql = zoro + ff_ql
         fflq = zoro + ff_lq
         ffqq = zoro + ff_qq
         ffld =        ff_ld
         ffqd =        ff_qd

         if (ifgg.eq.0) then
            ffgg = zoro
         elseif (ifgg.eq.1) then
            ffgg = zoro + ff_gg
         elseif ((ifgg.eq.2).and.(gfscheme.le.1)) then
            ffgg = zoro/(1d0 - ff_gg)
         endif

         if (iz.eq.1) then
            ffarray(2,1) = ffll
            ffarray(2,2) = ffql
            ffarray(2,3) = fflq
            ffarray(2,4) = ffqq
            ffarray(2,5) = ffld
            ffarray(2,6) = ffqd
            ffarray(2,7) = ffgg
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
     & +ffgg*(-2*sinthmo*1d0/sqrt(s)*qup*qmo*mmo)
     & +ffqq*(-2*chizs*sinthmo*1d0/sqrt(s)*vmaup*vmamo*mmo)
     & +ffll*(-4*chizs*sinthmo*1d0/sqrt(s)*aup*amo*mmo)
     & +fflq*(-4*chizs*sinthmo*1d0/sqrt(s)*aup*vmamo*mmo)
     & +ffql*(-2*chizs*sinthmo*1d0/sqrt(s)*vmaup*amo*mmo)
     & +ffld*(-2*chizs*sinthmo*1d0/sqrt(s)*pxsmomo*aup*amo*mmo)
     & +ffqd*(-chizs*sinthmo*1d0/sqrt(s)*pxsmomo*vmaup*amo*mmo)

      amp(1,2,1,2) =
     & +ffgg*(-qup*qmo+costhmo*qup*qmo)
     & +ffqq*(-chizs*vmaup*vmamo+chizs*costhmo*vmaup*vmamo)
     & +ffll*(-2*chizs*aup*amo+2*chizs*costhmo*aup*amo-2*chizs*costhmo*1
     & d0/sqrt(s)*sqrtpxsmomo*aup*amo+2*chizs*1d0/sqrt(s)*sqrtpxsmomo*au
     & p*amo)
     & +fflq*(-2*chizs*aup*vmamo+2*chizs*costhmo*aup*vmamo)
     & +ffql*(-chizs*vmaup*amo+chizs*costhmo*vmaup*amo-chizs*costhmo*1d0
     & /sqrt(s)*sqrtpxsmomo*vmaup*amo+chizs*1d0/sqrt(s)*sqrtpxsmomo*vmau
     & p*amo)

      amp(1,2,2,1) =
     & +ffgg*(-qup*qmo-costhmo*qup*qmo)
     & +ffqq*(-chizs*vmaup*vmamo-chizs*costhmo*vmaup*vmamo)
     & +ffll*(-2*chizs*aup*amo-2*chizs*costhmo*aup*amo-2*chizs*costhmo*1
     & d0/sqrt(s)*sqrtpxsmomo*aup*amo-2*chizs*1d0/sqrt(s)*sqrtpxsmomo*au
     & p*amo)
     & +fflq*(-2*chizs*aup*vmamo-2*chizs*costhmo*aup*vmamo)
     & +ffql*(-chizs*vmaup*amo-chizs*costhmo*vmaup*amo-chizs*costhmo*1d0
     & /sqrt(s)*sqrtpxsmomo*vmaup*amo-chizs*1d0/sqrt(s)*sqrtpxsmomo*vmau
     & p*amo)

      amp(1,2,2,2) =
     & +ffgg*(-2*sinthmo*1d0/sqrt(s)*qup*qmo*mmo)
     & +ffqq*(-2*chizs*sinthmo*1d0/sqrt(s)*vmaup*vmamo*mmo)
     & +ffll*(-4*chizs*sinthmo*1d0/sqrt(s)*aup*amo*mmo)
     & +fflq*(-4*chizs*sinthmo*1d0/sqrt(s)*aup*vmamo*mmo)
     & +ffql*(-2*chizs*sinthmo*1d0/sqrt(s)*vmaup*amo*mmo)
     & +ffld*(-2*chizs*sinthmo*1d0/sqrt(s)*pxsmomo*aup*amo*mmo)
     & +ffqd*(-chizs*sinthmo*1d0/sqrt(s)*pxsmomo*vmaup*amo*mmo)

      amp(2,1,1,1) =
     & +ffgg*(+2*sinthmo*1d0/sqrt(s)*qup*qmo*mmo)
     & +ffqq*(+2*chizs*sinthmo*1d0/sqrt(s)*vmaup*vmamo*mmo)
     & +ffql*(+2*chizs*sinthmo*1d0/sqrt(s)*vmaup*amo*mmo)
     & +ffqd*(+chizs*sinthmo*1d0/sqrt(s)*pxsmomo*vmaup*amo*mmo)

      amp(2,1,1,2) =
     & +ffgg*(-qup*qmo-costhmo*qup*qmo)
     & +ffqq*(-chizs*vmaup*vmamo-chizs*costhmo*vmaup*vmamo)
     & +ffql*(-chizs*vmaup*amo-chizs*costhmo*vmaup*amo+chizs*costhmo*1d0
     & /sqrt(s)*sqrtpxsmomo*vmaup*amo+chizs*1d0/sqrt(s)*sqrtpxsmomo*vmau
     & p*amo)

      amp(2,1,2,1) =
     & +ffgg*(-qup*qmo+costhmo*qup*qmo)
     & +ffqq*(-chizs*vmaup*vmamo+chizs*costhmo*vmaup*vmamo)
     & +ffql*(-chizs*vmaup*amo+chizs*costhmo*vmaup*amo+chizs*costhmo*1d0
     & /sqrt(s)*sqrtpxsmomo*vmaup*amo-chizs*1d0/sqrt(s)*sqrtpxsmomo*vmau
     & p*amo)

      amp(2,1,2,2) =
     & +ffgg*(+2*sinthmo*1d0/sqrt(s)*qup*qmo*mmo)
     & +ffqq*(+2*chizs*sinthmo*1d0/sqrt(s)*vmaup*vmamo*mmo)
     & +ffql*(+2*chizs*sinthmo*1d0/sqrt(s)*vmaup*amo*mmo)
     & +ffqd*(+chizs*sinthmo*1d0/sqrt(s)*pxsmomo*vmaup*amo*mmo)

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
