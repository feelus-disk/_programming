************************************************************************
* sanc_cc_v1.40 package.
************************************************************************
* File (cc_br_1314_1112.f) is created on Tue Aug  9 22:36:56 MSD 2011.
************************************************************************
* This is the FORTRAN module (cc_bo_1314_1112) to calculate EW
* integrated Born cross section for the anti-up + dn -> en + el^- process.
*
* It is produced by s2n package of SANC (v1.10) Project.
* Copyright (C), SANC Project Team, 2002-2011.
*
* http://sanc.jinr.ru/
* http://pcphsanc.cern.ch/
* E-mail: <sanc@jinr.ru>
************************************************************************
      subroutine cc_bo_1314_1112 (s,born)
      implicit none!
      include 's2n_declare.h'

      real*8 kappaw
      complex*16 chiws,chiwsc

      cmw2 = mw2

      kappaw = gf*rwm2/(sqrt(2d0)*4d0*pi)/alpha
      if (irun.eq.0) then
         chiws = 4d0*kappaw*s/(s-cmw2)
      else
         chiws = 4d0*kappaw*s/(s-dcmplx(mw**2,-s*ww/mw))
      endif
      chiwsc = dconjg(chiws)

      born=
     & 1d0/9*chiws*chiwsc*pi*alpha**2/s

      born = born*conhc

      return
      end
************************************************************************
* This is the FORTRAN module (cc_br_1314_1112) to calculate EW Born
* cross section and soft photon Bremsstrahlung
* for the anti-up + dn -> en + el^- process.
*
* It is produced by s2n package of SANC (v1.10) Project.
* Copyright (C), SANC Project Team, 2002-2011.
*
* http://sanc.jinr.ru/
* http://pcphsanc.cern.ch/
* E-mail: <sanc@jinr.ru>
************************************************************************
      subroutine cc_br_1314_1112 (qs,ts,us,born,soft,hard)
      implicit none!
      include 's2n_declare.h'

      real*8 softvirtisr,softvirtfsr,softvirtifi
      real*8 ln1sup,ln1sdn,ln1sel

      real*8 cpl,cmi
      real*8 kappaw,qw
      complex*16 chiws,chiwsc

      cmw2 = mw2
      qw   = 1d0

      s = -qs
      t = -ts
      u = -us

      cosf = (u-t)/s
      sinf = dsqrt(1d0-cosf**2)

      cpl = 1d0+cosf
      cmi = 1d0-cosf

      kappaw = gf*rwm2/(sqrt(2d0)*4d0*pi)/alpha
      if (irun.eq.0) then
         chiws = 4d0*kappaw*s/(s-cmw2)
      else
         chiws = 4d0*kappaw*s/(s-dcmplx(mw**2,-s*ww/mw))
      endif
      chiwsc = dconjg(chiws)

      born=
     & 1d0/24*chiws*chiwsc*pi*alpha**2/s*cmi**2

      born = born*conhc
      virt = 0d0
      soft = 0d0
      hard = 0d0

      if (iborn.eq.1) return

      ln1sup = log(s/mup**2)-1d0
      ln1sdn = log(s/mdn**2)-1d0
      ln1sel = log(s/mel**2)-1d0

      softvirtisr=
     & +born/pi*alpha*qdn**2*(3d0/2+3d0/4*ln1sdn-3d0/4*log(s/thmu2))
     & +born/pi*alpha*qup**2*(3d0/2+3d0/4*ln1sup-3d0/4*log(s/thmu2))
     & +born*pi*alpha*qup*qdn*(1d0/3)
     & +log(4*omega**2/s)*born/pi*alpha*qdn**2*(1d0/2*ln1sdn)
     & +log(4*omega**2/s)*born/pi*alpha*qup**2*(1d0/2*ln1sup)
     & +log(4*omega**2/s)*born/pi*alpha*qw**2*(-1d0/2)

      softvirtfsr=
     & +born/pi*alpha*qel**2*(3d0/2+3d0/4*ln1sel-3d0/4*log(s/thmu2))
     & +log(4*omega**2/s)*born/pi*alpha*qel**2*(1d0/2*ln1sel)
     & +log(4*omega**2/s)*born/pi*alpha*qw**2*(-1d0/2)

      softvirtifi=
     & +log(1d0/2*cpl)*log(4*omega**2/s)*born/pi*alpha*qel*qdn*(1)
     & +log(1d0/2*cmi)*log(1d0/2*cpl)*born/pi*alpha*qel*qdn*(-1)
     & +log(1d0/2*cmi)*log(1d0/2*cpl)*born/pi*alpha*qel*qup*(1)
     & +log(1d0/2*cmi)*log(4*omega**2/s)*born/pi*alpha*qel*qup*(-1)
     & +log(4*omega**2/s)*born/pi*alpha*qw**2*(1)
     & +ddilog(1d0/2*cpl)*born/pi*alpha*qel*qdn*(-1)
     & +ddilog(1d0/2*cmi)*born/pi*alpha*qel*qup*(1)

      if (iqed.eq.1) then
         soft = softvirtisr+softvirtifi+softvirtfsr
      elseif(iqed.eq.2) then
         soft = softvirtisr
      elseif(iqed.eq.3) then
         soft = softvirtifi
      elseif(iqed.eq.4) then
         soft = softvirtfsr
      elseif(iqed.eq.5) then
         soft = softvirtifi+softvirtfsr
      elseif(iqed.eq.6) then
         soft = softvirtisr+softvirtifi
      endif

      soft = soft*cfprime

      return
      end
************************************************************************
* This is the FORTRAN module (cc_ha_1314_1112_1spr) to calculate hard
* photon Bremsstrahlung for the anti-up + dn -> en + el^- process.
*
* It is produced by s2n package of SANC (v1.10) Project.
* Copyright (C), SANC Project Team, 2002-2011.
*
* http://sanc.jinr.ru/
* http://pcphsanc.cern.ch/
* E-mail: <sanc@jinr.ru>
************************************************************************
      subroutine cc_ha_1314_1112_1spr (s,spr,hard)
      implicit none!
      include 's2n_declare.h'

      real*8 ln1sprel,ln1sup,ln1sdn
      complex*16 propiws,propws,propwsc,propiwspr,propwspr,propwsprc
      real*8 mdws,mdwspr,mdws2spr
      real*8 qw

      cmw2 = mw2
      qw   = 1d0

      if (irun.eq.0) then
         propiws = (cmw2-s)
         propiwspr = (cmw2-spr)
      else
         propiws = (dcmplx(mw**2,-s*ww/mw)-s)
         propiwspr = (dcmplx(mw**2,-spr*ww/mw)-spr)
      endif
      propws = 1d0/propiws
      propwsc = dconjg(propws)
      propwspr = 1d0/propiwspr
      propwsprc = dconjg(propwspr)

      mdws = propws*propwsc
      mdwspr = propwspr*propwsprc
      mdws2spr = propws*propwsprc + propwspr*propwsc

      ln1sprel = log(spr/mel**2)-1d0
      ln1sup   = log(s/mup**2)-1d0
      ln1sdn   = log(s/mdn**2)-1d0

      hardisr=
     & +mdwspr/pi**2*alpha*g**4*qdn**2/(s-spr)*theta_hard(s,spr,omega)*(
     & 1d0/1152*ln1sdn/s**2*spr*(s**2+spr**2))
     & +mdwspr/pi**2*alpha*g**4*qup**2/(s-spr)*theta_hard(s,spr,omega)*(
     & 1d0/1152*ln1sup/s**2*spr*(s**2+spr**2))
     & +mdwspr/pi**2*alpha*g**4*qw**2/(s-spr)*theta_hard(s,spr,omega)*(-
     & 1d0/1728/s**2*spr*(s**2+s*spr+spr**2))

      hardfsr=
     & +mdws/pi**2*alpha*g**4*qel**2/(s-spr)*theta_hard(s,spr,omega)*(-1
     & d0/1728/s*(s**2+s*spr+spr**2)
     & +1d0/1152*ln1sprel/s*(s**2+spr**2))

      hardifi=
     & +mdws2spr/pi**2*alpha*g**4*qel*qdn/(s-spr)*theta_hard(s,spr,omega
     & )*(-5d0/6912/s*spr*(s+spr))
     & +mdws2spr/pi**2*alpha*g**4*qel*qup/(s-spr)*theta_hard(s,spr,omega
     & )*(-1d0/1728/s*spr*(s+spr))

      if (iqed.eq.1) then
         hard = hardisr+hardifi+hardfsr
      elseif(iqed.eq.2) then
         hard = hardisr
      elseif(iqed.eq.3) then
         hard = hardifi
      elseif(iqed.eq.4) then
         hard = hardfsr
      elseif(iqed.eq.5) then
         hard = hardifi+hardfsr
      elseif(iqed.eq.6) then
         hard = hardisr+hardifi
      endif

      hard = hard*conhc*cfprime

      return
      end
