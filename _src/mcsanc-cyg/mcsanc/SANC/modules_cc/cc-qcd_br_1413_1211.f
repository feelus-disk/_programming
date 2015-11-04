************************************************************************
* sanc_cc_v1.40 package.
************************************************************************
* File (cc-qcd_br_1413_1211.f) is created on Tue Aug  9 22:38:10 MSD 2011.
************************************************************************
* This is the FORTRAN module (cc_qcd_br_1413_1211) to calculate EW Born
* cross section and QCD virtual corrections 
* for the anti-dn + up -> el^+ + en process.
*
* It is produced by s2n package of SANC (v1.10) Project.
* Copyright (C), SANC Project Team, 2002-2011.
*
* http://sanc.jinr.ru/
* http://pcphsanc.cern.ch/
* E-mail: <sanc@jinr.ru>
************************************************************************
      subroutine cc_qcd_br_1413_1211 (qs,ts,us,born,soft,hard)
      implicit none!
      include 's2n_declare.h'

      real*8 costh
      real*8 ln1sdn,ln1sup

      real*8 kappaw
      complex*16 chiws,chiwsc

      cmw2 = mw2
      s = -qs
      t = -ts
      u = -us

      cosf = (u-t)/s
      sinf = dsqrt(1d0-cosf**2)

      kappaw = gf*rwm2/(sqrt(2d0)*4d0*pi)/alpha
      if (irun.eq.0) then
         chiws = 4d0*kappaw*s/(s-cmw2)
      else
         chiws = 4d0*kappaw*s/(s-dcmplx(mw**2,-s*ww/mw))
      endif
      chiwsc = dconjg(chiws)

      born=
     & +chiws*chiwsc*pi*alpha**2*(1d0/24/s)
     & +chiws*chiwsc*cosf*pi*alpha**2*(-1d0/12/s)
     & +chiws*chiwsc*cosf**2*pi*alpha**2*(1d0/24/s)

      born = born*conhc
      virt = 0d0
      soft = 0d0
      hard = 0d0

      if (iborn.eq.1) return

      ln1sdn  = log(s/mdn**2)-1d0
      ln1sup  = log(s/mup**2)-1d0

      softvirt=
     & +born/pi*alphas*cf*(-1d0/2)
     & +ln1sdn*born/pi*alphas*cf*(3d0/4)
     & +ln1sdn*log(4*omega**2/s)*born/pi*alphas*cf*(1d0/2)
     & +ln1sup*born/pi*alphas*cf*(3d0/4)
     & +ln1sup*log(4*omega**2/s)*born/pi*alphas*cf*(1d0/2)
     & +ddilog(1d0)*born/pi*alphas*cf*(2)

      soft = softvirt

      return
      end
************************************************************************
* This is the FORTRAN module (cc_qcd_ha_1413_1211_1spr) to calculate hard
* gluon radiation for the anti-dn + up -> el^+ + en process.
*
* It is produced by s2n package of SANC (v1.10) Project.
* Copyright (C), SANC Project Team, 2002-2011.
*
* http://sanc.jinr.ru/
* http://pcphsanc.cern.ch/
* E-mail: <sanc@jinr.ru>
************************************************************************
      subroutine cc_qcd_ha_1413_1211_1spr (s,spr,hard)
      implicit none!
      include 's2n_declare.h'

      real*8 kappaw
      real*8 ln1sdn,ln1sup
      complex*16 chiwspr,chiwsprc

      cmw2 = mw2

      kappaw = gf*rwm2/(sqrt(2d0)*4d0*pi)/alpha
      if (irun.eq.0) then
         chiwspr = 4d0*kappaw*spr/(spr-cmw2)
      else
         chiwspr = 4d0*kappaw*spr/(spr-dcmplx(mw**2,-spr*ww/mw))
      endif
      chiwsprc = dconjg(chiwspr)

      ln1sdn = log(s/mdn**2)-1d0
      ln1sup = log(s/mup**2)-1d0

      hard=
     & +ln1sdn*chiwspr*chiwsprc*alpha**2*alphas*cf*(-1d0/18/s**2+1d0/18/
     & s/spr+1d0/9/s/(s-spr)*theta_hard(s,spr,omega))
     & +ln1sup*chiwspr*chiwsprc*alpha**2*alphas*cf*(-1d0/18/s**2+1d0/18/
     & s/spr+1d0/9/s/(s-spr)*theta_hard(s,spr,omega))

      hard = hard*conhc

      return
      end
