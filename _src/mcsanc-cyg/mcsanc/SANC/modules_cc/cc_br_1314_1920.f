************************************************************************
* sanc_cc_v1.40 package.
************************************************************************
* File (cc_br_1314_1920.f) is created on Tue Aug  9 22:37:10 MSD 2011.
************************************************************************
* This is the FORTRAN module (cc_bo_1314_1920) to calculate EW
* integrated Born cross section for the anti-up + dn -> tn + ta^- process.
*
* It is produced by s2n package of SANC (v1.10) Project.
* Copyright (C), SANC Project Team, 2002-2011.
*
* http://sanc.jinr.ru/
* http://pcphsanc.cern.ch/
* E-mail: <sanc@jinr.ru>
************************************************************************
      subroutine cc_bo_1314_1920 (s,born)
      implicit none!
      include 's2n_declare.h'

      real*8 kappaw
      complex*16 chiws,chiwsc
      real*8 sqrtlstac

      cmw2 = mw2

      sqrtlstac = s-mta**2

      kappaw = gf*rwm2/(sqrt(2d0)*4d0*pi)/alpha
      if (irun.eq.0) then
         chiws = 4d0*kappaw*s/(s-cmw2)
      else
         chiws = 4d0*kappaw*s/(s-dcmplx(mw**2,-s*ww/mw))
      endif
      chiwsc = dconjg(chiws)

      born=
     & 1d0/9*sqrtlstac**2*chiws*chiwsc*pi*alpha**2/s**3+1d0/18*sqrtlstac
     & **2*chiws*chiwsc*pi*alpha**2*mta**2/s**4

      born = born*conhc

      return
      end
************************************************************************
* This is the FORTRAN module (cc_br_1314_1920) to calculate EW Born
* cross section and soft photon Bremsstrahlung
* for the anti-up + dn -> tn + ta^- process.
*
* It is produced by s2n package of SANC (v1.10) Project.
* Copyright (C), SANC Project Team, 2002-2011.
*
* http://sanc.jinr.ru/
* http://pcphsanc.cern.ch/
* E-mail: <sanc@jinr.ru>
************************************************************************
      subroutine cc_br_1314_1920 (qs,ts,us,born,soft,hard)
      implicit none!
      include 's2n_declare.h'

      real*8 softvirtisr,softvirtfsr,softvirtifi
      real*8 ln1sup,ln1sdn,ln1sta

      real*8 betastac,ibetastac,sqrtlstac
      real*8 cpl,cmi
      real*8 kappaw,qw
      complex*16 chiws,chiwsc

      cmw2 = mw2
      qw   = 1d0

      s = -qs
      t = -ts
      u = -us

      cosf = (u-t)/(s-mta**2)
      sinf = dsqrt(1d0-cosf**2)

      cpl = 1d0+cosf
      cmi = 1d0-cosf

      sqrtlstac = dabs(s-mta**2)
      betastac = (s-mta**2)/(s+mta**2)
      ibetastac = 1d0/betastac

      kappaw = gf*rwm2/(sqrt(2d0)*4d0*pi)/alpha
      if (irun.eq.0) then
         chiws = 4d0*kappaw*s/(s-cmw2)
      else
         chiws = 4d0*kappaw*s/(s-dcmplx(mw**2,-s*ww/mw))
      endif
      chiwsc = dconjg(chiws)

      born=
     & 1d0/24*sqrtlstac**2*chiws*chiwsc*pi*alpha**2/s**3*cmi**2+1d0/12*s
     & qrtlstac**2*chiws*chiwsc*pi*alpha**2*mta**2/s**4*cmi-1d0/24*sqrtl
     & stac**2*chiws*chiwsc*pi*alpha**2*mta**2/s**4*cmi**2

      born = born*conhc
      virt = 0d0
      soft = 0d0
      hard = 0d0

      if (iborn.eq.1) return

      ln1sup = log(s/mup**2)-1d0
      ln1sdn = log(s/mdn**2)-1d0
      ln1sta = log(s/mta**2)-1d0

      softvirtisr=
     & +born/pi*alpha*qdn**2*(3d0/2+3d0/4*ln1sdn-3d0/4*log(s/thmu2))
     & +born/pi*alpha*qup**2*(3d0/2+3d0/4*ln1sup-3d0/4*log(s/thmu2))
     & +log(4*omega**2/s)*born/pi*alpha*qdn**2*(1d0/2*ln1sdn)
     & +log(4*omega**2/s)*born/pi*alpha*qup**2*(1d0/2*ln1sup)
     & +log(4*omega**2/s)*born/pi*alpha*qw**2*(-1d0/2)
     & +ddilog(1d0)*born/pi*alpha*qup*qdn*(2)

      softvirtfsr=
     & +born/pi*alpha*(qta**2+1d0/4*ln1sta*qta**2+1d0/2*ln1sta*ibetastac
     & *qta**2+1d0/2*ibetastac*qta**2-3d0/4*log(s/thmu2)*qta**2)
     & +log(4*omega**2/s)*born/pi*alpha*(1d0/2*ln1sta*qta**2)
     & +log(4*omega**2/s)*born/pi*alpha*qw**2*(-1d0/2)

      softvirtifi=
     & +log(mta**2/s+us/s)**2*born/pi*alpha*qup*(2*qta)
     & +log(mta**2/s+ts/s)**2*born/pi*alpha*qdn*(-2*qta)
     & +log(us/s)*log(mta**2/s+us/s)*born/pi*alpha*qup*(-2*qta)
     & +log(us/s)**2*born/pi*alpha*qup*(1d0/2*qta)
     & +log(ts/s)*log(mta**2/s+ts/s)*born/pi*alpha*qdn*(2*qta)
     & +log(ts/s)**2*born/pi*alpha*qdn*(-1d0/2*qta)
     & +log(4*omega**2/s)*born/pi*alpha*qw**2*(1)
     & +log(4*omega**2/s)*log(mta**2/s+us/s)*born/pi*alpha*qup*(-qta)
     & +log(4*omega**2/s)*log(mta**2/s+ts/s)*born/pi*alpha*qdn*(qta)
     & +ddilog(-1d0/ts*mta**4/s-mta**2/s)*born/pi*alpha*qdn*(-qta)
     & +ddilog(-1d0/us*mta**4/s-mta**2/s)*born/pi*alpha*qup*(qta)
     & +ddilog(-mta**2/s+1/(mta**2+us)*mta**2)*born/pi*alpha*qup*(-qta)
     & +ddilog(-mta**2/s+1/(mta**2+ts)*mta**2)*born/pi*alpha*qdn*(qta)
     & +ddilog(1/(mta**2+us)*mta**2)*born/pi*alpha*qup*(qta)
     & +ddilog(1/(mta**2+ts)*mta**2)*born/pi*alpha*qdn*(-qta)
     & +ddilog(-1/(mta**4+2*us*mta**2+us**2)*ts*us)*born/pi*alpha*qup*(q
     & ta)
     & +ddilog(-1/(mta**4+2*ts*mta**2+ts**2)*ts*us)*born/pi*alpha*qdn*(-
     & qta)
     & +ddilog(1d0)*born/pi*alpha*qdn*(-qta)
     & +ddilog(1d0)*born/pi*alpha*qup*(qta)

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
* This is the FORTRAN module (cc_ha_1314_1920_1spr) to calculate hard
* photon Bremsstrahlung for the anti-up + dn -> tn + ta^- process.
*
* It is produced by s2n package of SANC (v1.10) Project.
* Copyright (C), SANC Project Team, 2002-2011.
*
* http://sanc.jinr.ru/
* http://pcphsanc.cern.ch/
* E-mail: <sanc@jinr.ru>
************************************************************************
      subroutine cc_ha_1314_1920_1spr (s,spr,hard)
      implicit none!
      include 's2n_declare.h'

      real*8 ln1sprta,ln1sup,ln1sdn
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

      ln1sprta = log(spr/mta**2)-1d0
      ln1sup   = log(s/mup**2)-1d0
      ln1sdn   = log(s/mdn**2)-1d0

      hardisr=
     & +mdwspr/pi**2*alpha*g**4*qdn**2/(s-spr)*theta_hard(s,spr,omega)*(
     & 1d0/1152*ln1sdn/s**2*spr*(s**2+spr**2)
     & -1d0/768*ln1sdn*mta**2/s**2*(s**2+spr**2)
     & +1d0/2304*ln1sdn*mta**6/s**2/spr**2*(s**2+spr**2))
     & +mdwspr/pi**2*alpha*g**4*qup**2/(s-spr)*theta_hard(s,spr,omega)*(
     & 1d0/1152*ln1sup/s**2*spr*(s**2+spr**2)
     & -1d0/768*ln1sup*mta**2/s**2*(s**2+spr**2)
     & +1d0/2304*ln1sup*mta**6/s**2/spr**2*(s**2+spr**2))
     & +mdwspr/pi**2*alpha*g**4*qw**2/(s-spr)*theta_hard(s,spr,omega)*(-
     & 1d0/1728/s**2*spr*(s**2+s*spr+spr**2)
     & +1d0/1152*mta**2/s**2*(s**2+s*spr+spr**2)
     & -1d0/3456*mta**6/s**2/spr**2*(s**2+s*spr+spr**2))

      hardfsr=
     & +mdws/pi**2*alpha*g**4/(s-spr)*theta_hard(s,spr,omega)*(-1d0/1728
     & *qta**2/s*(s**2+s*spr+spr**2)
     & +1d0/384*qta**2*mta**2/s/spr*(s**2+spr**2)
     & +1d0/1152*qta**2*mta**2/s*spr-1d0/576*qta**2*mta**4/s-1d0/384*qta
     & **2*mta**6/s**2+1d0/1152*ln1sprta*qta**2/s*(s**2+spr**2)
     & +1d0/2304*ln1sprta*qta**2*mta**2/s**2*(s**2+spr**2)
     & -1d0/576*ln1sprta*qta**2*mta**4/s-1d0/1152*ln1sprta*qta**2*mta**6
     & /s**2)+mdws/pi**2*alpha*g**4*(-1d0/768*qta**2*mta**4/s**2+1d0/230
     & 4*qta**2*mta**4/s/spr+1d0/576*ln1sprta*qta**2*mta**2/s+1d0/1152*l
     & n1sprta*qta**2*mta**4/s**2)
     & +mdws/pi**2*alpha*g**4*(s-spr)*(-1d0/576*qta**2*mta**4/s/spr**2+1
     & d0/1728*qta**2*mta**6/s/spr**3)

      hardifi=
     & +mdws2spr/pi**2*alpha*g**4*qdn/(s-spr)*theta_hard(s,spr,omega)*(-
     & 5d0/6912*qta/s*spr*(s+spr)
     & +1d0/1152*qta*mta**2/s**2*(s+spr)**2-1d0/768*qta*mta**2+1d0/288*q
     & ta*mta**4/s+1d0/1152*ln1sprta*qta*mta**2/s**2*(s+spr)**2)
     & +mdws2spr/pi**2*alpha*g**4*qdn*(5d0/4608*qta*mta**2/s**2*spr+1d0/
     & 512*qta*mta**2/s-1d0/768*qta*mta**4/s**2)
     & +mdws2spr/pi**2*alpha*g**4*qup/(s-spr)*theta_hard(s,spr,omega)*(-
     & 1d0/1728*qta/s*spr*(s+spr)
     & +1d0/2304*qta*mta**2/s**2*(s+spr)**2+1d0/768*qta*mta**2-1d0/1152*
     & qta*mta**4/s+1d0/2304*ln1sprta*qta*mta**2/s**2*(s+spr)**2)
     & +mdws2spr/pi**2*alpha*g**4*qup*(1d0/4608*qta*mta**2/s**2*spr-1d0/
     & 1536*qta*mta**2/s)
     & +mdws2spr/pi**2*alpha*g**4*qw/(s-spr)*theta_hard(s,spr,omega)*(-1
     & d0/6912*qta*mta**6/s**2-1d0/2304*ln1sprta*qta*mta**4/s**2*(s+spr)
     & )
     & +mdws2spr/pi**2*alpha*g**4*qw*(s-spr)*(-1d0/13824*qta*mta**6/s**2
     & /spr**2)

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
