************************************************************************
* sanc_nc_v1.30 package.
************************************************************************
* File (nc_br_1414_1212.f) is created on Wed Apr 18 13:18:56 MSK 2012.
************************************************************************
* This is the FORTRAN module (nc_bo_1414_1212) to calculate EW
* integrated Born cross section for the anti-dn + dn -> el^+ + el^- process.
*
* It is produced by s2n package of SANC (v1.10) Project.
* Copyright (C), SANC Project Team, 2002-2012.
*
* http://sanc.jinr.ru/
* http://pcphsanc.cern.ch/
* E-mail: <sanc@jinr.ru>
************************************************************************
      subroutine nc_bo_1414_1212 (s,born)
      implicit none!
      include 's2n_declare.h'

      real*8 v1z,v2z,vaz
      real*8 v0s,vas
      real*8 kappaz
      complex*16 chizs,chizsc
      real*8 betaselel,ibetaselel

      cmz2 = mz2

      kappaz   = gf*rzm2/(dsqrt(2d0)*8d0*pi)/alpha
      if (irun.eq.0) then
         chizs = 4d0*kappaz*s/(s-cmz2)
      else
         chizs = 4d0*kappaz*s/(s-dcmplx(mz**2,-s*wz/mz))
      endif
      chizsc   = dconjg(chizs)

      v1z = vdn*vel
      v2z = (vdn**2+adn**2)*(vel**2+ael**2)
      vaz = (vdn**2+adn**2)*(vel**2-ael**2)

      v0s =
     & +qdn**2*qel**2
     & +qdn*qel*(chizs+chizsc)*v1z
     & +chizs*chizsc*v2z
      vas =
     & +qdn**2*qel**2
     & +qdn*qel*(chizs+chizsc)*v1z
     & +chizs*chizsc*vaz

      betaselel = sqrt(1d0-4d0*mel**2/s)
      ibetaselel = 1d0/betaselel

      born=
     & +v0s*pi*alpha**2*(4d0/9/s)

      born = born*conhc

      return
      end
************************************************************************
* This is the FORTRAN module (nc_br_1414_1212) to calculate EW Born
* cross section and soft photon Bremsstrahlung
* for the anti-dn + dn -> el^+ + el^- process.
*
* It is produced by s2n package of SANC (v1.10) Project.
* Copyright (C), SANC Project Team, 2002-2012.
*
* http://sanc.jinr.ru/
* http://pcphsanc.cern.ch/
* E-mail: <sanc@jinr.ru>
************************************************************************
      subroutine nc_br_1414_1212 (qs,ts,us,born,soft,hard)
      implicit none!
      include 's2n_declare.h'

      real*8 lnlaom,cpl,cmi
      real*8 a0s,v0s,vaz
      real*8 a1z,a2z,v1z,v2z,vas
      real*8 softisr,softfsr,softifi
      real*8 kappaz
      complex*16 chizs,chizsc,chizspr,chizsprc
      real*8 betaselel,ibetaselel
      real*8 jintqselel

      cmz2 = mz2
      s = -qs
      t = -ts
      u = -us

      betaselel = sqrt(1d0-4d0*mel**2/s)
      ibetaselel = 1d0/betaselel
      cosf = (t-u)/s
      sinf = dsqrt(1d0-cosf**2)

      cpl = (1+cosf)/2d0
      cmi = (1-cosf)/2d0

      kappaz   = gf*rzm2/(dsqrt(2d0)*8d0*pi)/alpha
      if (irun.eq.0) then
         chizs = 4d0*kappaz*s/(s-cmz2)
      else
         chizs = 4d0*kappaz*s/(s-dcmplx(mz**2,-s*wz/mz))
      endif
      chizsc   = dconjg(chizs)

      a1z = adn*ael
      a2z = 4d0*vdn*adn*vel*ael
      v1z = vdn*vel
      v2z = (vdn**2+adn**2)*(vel**2+ael**2)
      vaz = (vdn**2+adn**2)*(vel**2-ael**2)

      v0s =
     & +qdn**2*qel**2
     & +qdn*qel*(chizs+chizsc)*v1z
     & +chizs*chizsc*v2z
      a0s =
     & +qdn*qel*(chizs+chizsc)*a1z
     & +chizs*chizsc*a2z
      vas =
     & +qdn**2*qel**2
     & +qdn*qel*(chizs+chizsc)*v1z
     & +chizs*chizsc*vaz


      born=
     & +a0s*pi*alpha**2*(1d0/3*cosf/s)
     & +v0s*pi*alpha**2*(1d0/6*(1+cosf**2)/s)

      born = born*conhc
      virt = 0d0
      soft = 0d0
      hard = 0d0

      if (iborn.eq.1) return

      lnlaom = log(4d0*omega**2/tlmu2)
      jintqselel = log((1d0-betaselel)/(1d0+betaselel))

      softisr=
     & +born*pi*alpha*qdn**2*(-1d0/3)
     & +lnlaom*born/pi*alpha*qdn**2*(-1)
     & +lnlaom*log(mdn**2/s)*born/pi*alpha*qdn**2*(-1)
     & +log(mdn**2/s)*born/pi*alpha*qdn**2*(-1)
     & +log(mdn**2/s)**2*born/pi*alpha*qdn**2*(-1d0/2)

      softfsr=
     & +born*pi*alpha*qel**2*(-1d0/3)
     & +lnlaom*born/pi*alpha*qel**2*(-1)
     & +lnlaom*log(mel**2/s)*born/pi*alpha*qel**2*(-1)
     & +log(mel**2/s)*born/pi*alpha*qel**2*(-1)
     & +log(mel**2/s)**2*born/pi*alpha*qel**2*(-1d0/2)

      softifi=
     & +lnlaom*log(cmi/cpl)*born/pi*alpha*qel*qdn*(2)
     & +log(cmi)**2*born/pi*alpha*qel*qdn*(1)
     & +log(cpl)**2*born/pi*alpha*qel*qdn*(-1)
     & +ddilog(cmi)*born/pi*alpha*qel*qdn*(-2)
     & +ddilog(cpl)*born/pi*alpha*qel*qdn*(2)

      if (iqed.eq.1) then
         soft = softisr+softfsr+softifi
      elseif(iqed.eq.2) then
         soft = softisr
      elseif(iqed.eq.3) then
         soft = softifi
      elseif(iqed.eq.4) then
         soft = softfsr
      elseif(iqed.eq.5) then
         soft = softifi+softfsr
      elseif(iqed.eq.6) then
         soft = softisr+softifi
      endif
      soft = soft*cfprime

      return
      end
************************************************************************
* This is the FORTRAN module (nc_ha_1414_1212_1spr) to calculate hard
* photon Bremsstrahlung for the anti-dn + dn -> el^+ + el^- process.
*
* It is produced by s2n package of SANC (v1.10) Project.
* Copyright (C), SANC Project Team, 2002-2012.
*
* http://sanc.jinr.ru/
* http://pcphsanc.cern.ch/
* E-mail: <sanc@jinr.ru>
************************************************************************
      subroutine nc_ha_1414_1212_1spr (s,spr,hard)
      implicit none!
      include 's2n_declare.h'

      real*8 kappaz,coef,sqs
      real*8 betasdndn,betasprelel
      real*8 jintsdndn,jintsprelel,ln1sdn,ln1bsprel
      real*8 a1z,a2z,v1z,v2z,vaz
      real*8 v0s,vas,v0spr,vaspr,a1sspr,a2sspr
      complex*16 chizs,chizsc,chizspr,chizsprc

      cmz2 = mz2

      kappaz   = gf*rzm2/(dsqrt(2d0)*8d0*pi)/alpha
      if (irun.eq.0) then
         chizs = 4d0*kappaz*s/(s-cmz2)
         chizspr = 4d0*kappaz*spr/(spr-cmz2)
      else
         chizs = 4d0*kappaz*s/(s-dcmplx(mz**2,-s*wz/mz))
         chizspr = 4d0*kappaz*spr/(spr-dcmplx(mz**2,-spr*wz/mz))
      endif
      chizsc   = dconjg(chizs)
      chizsprc = dconjg(chizspr)

      a1z = adn*ael
      a2z = 4d0*vdn*adn*vel*ael
      v1z = vdn*vel
      v2z = (vdn**2+adn**2)*(vel**2+ael**2)
      vaz = (vdn**2+adn**2)*(vel**2-ael**2)

      v0s =
     & +qdn**2*qel**2
     & +qdn*qel*(chizs+chizsc)*v1z
     & +chizs*chizsc*v2z
      vas =
     & +qdn**2*qel**2
     & +qdn*qel*(chizs+chizsc)*v1z
     & +chizs*chizsc*vaz
      v0spr =
     & +qdn**2*qel**2
     & +qdn*qel*(chizspr+chizsprc)*v1z
     & +chizspr*chizsprc*v2z
      vaspr =
     & +qdn**2*qel**2
     & +qdn*qel*(chizspr+chizsprc)*v1z
     & +chizspr*chizsprc*vaz
      a1sspr =
     & -(chizs+chizsc-chizspr-chizsprc)*a1z
      a2sspr =
     & +qdn*qel*(chizs+chizsc+chizspr+chizsprc)*a1z
     & +(chizs*chizsprc+chizsc*chizspr)*a2z

      betasdndn = dsqrt(1d0-4d0*rdnm2/s)
      jintsdndn = dlog((1d0-betasdndn)/(1d0+betasdndn))
      ln1sdn    = -jintsdndn-1d0
      betasprelel = dsqrt(1d0-4d0*relm2/spr)
      jintsprelel = dlog((1d0-betasprelel)/(1d0+betasprelel))
      ln1bsprel   = -jintsprelel-betasprelel

      hard=
     & +v0s*(s**2+spr**2)*alpha**3*qel**2/(s-spr)*theta_hard(s,spr,omega
     & )*(4d0/9*ln1bsprel/s**3)
     & +v0spr*(s**2+spr**2)*alpha**3*qdn**2/spr/(s-spr)*theta_hard(s,spr
     & ,omega)*(4d0/9*ln1sdn/s**2)
     & +a2sspr*(s+spr)*alpha**3*qel*qdn/(s-spr)*theta_hard(s,spr,omega)*
     & (-2d0/3/s**2)

      hard = hard*conhc*cfprime

      return
      end
