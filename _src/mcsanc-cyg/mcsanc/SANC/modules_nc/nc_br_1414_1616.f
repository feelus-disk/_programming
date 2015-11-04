************************************************************************
* sanc_nc_v1.30 package.
************************************************************************
* File (nc_br_1414_1616.f) is created on Wed Apr 18 13:20:22 MSK 2012.
************************************************************************
* This is the FORTRAN module (nc_bo_1414_1616) to calculate EW
* integrated Born cross section for the anti-dn + dn -> mo^+ + mo^- process.
*
* It is produced by s2n package of SANC (v1.10) Project.
* Copyright (C), SANC Project Team, 2002-2012.
*
* http://sanc.jinr.ru/
* http://pcphsanc.cern.ch/
* E-mail: <sanc@jinr.ru>
************************************************************************
      subroutine nc_bo_1414_1616 (s,born)
      implicit none!
      include 's2n_declare.h'

      real*8 v1z,v2z,vaz
      real*8 v0s,vas
      real*8 kappaz
      complex*16 chizs,chizsc
      real*8 betasmomo,ibetasmomo

      cmz2 = mz2

      kappaz   = gf*rzm2/(dsqrt(2d0)*8d0*pi)/alpha
      if (irun.eq.0) then
         chizs = 4d0*kappaz*s/(s-cmz2)
      else
         chizs = 4d0*kappaz*s/(s-dcmplx(mz**2,-s*wz/mz))
      endif
      chizsc   = dconjg(chizs)

      v1z = vdn*vmo
      v2z = (vdn**2+adn**2)*(vmo**2+amo**2)
      vaz = (vdn**2+adn**2)*(vmo**2-amo**2)

      v0s =
     & +qdn**2*qmo**2
     & +qdn*qmo*(chizs+chizsc)*v1z
     & +chizs*chizsc*v2z
      vas =
     & +qdn**2*qmo**2
     & +qdn*qmo*(chizs+chizsc)*v1z
     & +chizs*chizsc*vaz

      betasmomo = sqrt(1d0-4d0*mmo**2/s)
      ibetasmomo = 1d0/betasmomo

      born=
     & +v0s*betasmomo*pi*alpha**2*(4d0/3*mmo**2/s**2)
     & +v0s*betasmomo**3*pi*alpha**2*(4d0/9/s)
     & +vas*betasmomo*pi*alpha**2*(4d0/3*mmo**2/s**2)

      born = born*conhc

      return
      end
************************************************************************
* This is the FORTRAN module (nc_br_1414_1616) to calculate EW Born
* cross section and soft photon Bremsstrahlung
* for the anti-dn + dn -> mo^+ + mo^- process.
*
* It is produced by s2n package of SANC (v1.10) Project.
* Copyright (C), SANC Project Team, 2002-2012.
*
* http://sanc.jinr.ru/
* http://pcphsanc.cern.ch/
* E-mail: <sanc@jinr.ru>
************************************************************************
      subroutine nc_br_1414_1616 (qs,ts,us,born,soft,hard)
      implicit none!
      include 's2n_declare.h'

      real*8 lnlaom,cpl,cmi
      real*8 a0s,v0s,vaz
      real*8 a1z,a2z,v1z,v2z,vas
      real*8 softisr,softfsr,softifi
      real*8 kappaz
      complex*16 chizs,chizsc,chizspr,chizsprc
      real*8 betasmomo,ibetasmomo
      real*8 jintqsmomo

      cmz2 = mz2
      s = -qs
      t = -ts
      u = -us

      betasmomo = sqrt(1d0-4d0*mmo**2/s)
      ibetasmomo = 1d0/betasmomo
      cosf = (t-u)/s/betasmomo
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

      a1z = adn*amo
      a2z = 4d0*vdn*adn*vmo*amo
      v1z = vdn*vmo
      v2z = (vdn**2+adn**2)*(vmo**2+amo**2)
      vaz = (vdn**2+adn**2)*(vmo**2-amo**2)

      v0s =
     & +qdn**2*qmo**2
     & +qdn*qmo*(chizs+chizsc)*v1z
     & +chizs*chizsc*v2z
      a0s =
     & +qdn*qmo*(chizs+chizsc)*a1z
     & +chizs*chizsc*a2z
      vas =
     & +qdn**2*qmo**2
     & +qdn*qmo*(chizs+chizsc)*v1z
     & +chizs*chizsc*vaz


      born=
     & +a0s*betasmomo**2*pi*alpha**2*(1d0/3*cosf/s)
     & +v0s*betasmomo*pi*alpha**2*(2d0/3*mmo**2/s**2)
     & +v0s*betasmomo**3*pi*alpha**2*(1d0/6*(1+cosf**2)/s)
     & +vas*betasmomo*pi*alpha**2*(2d0/3*mmo**2/s**2)

      born = born*conhc
      virt = 0d0
      soft = 0d0
      hard = 0d0

      if (iborn.eq.1) return

      lnlaom = log(4d0*omega**2/tlmu2)
      jintqsmomo = log((1d0-betasmomo)/(1d0+betasmomo))

      softisr=
     & +born*pi*alpha*qdn**2*(-1d0/3)
     & +lnlaom*born/pi*alpha*qdn**2*(-1)
     & +lnlaom*log(mdn**2/s)*born/pi*alpha*qdn**2*(-1)
     & +log(mdn**2/s)*born/pi*alpha*qdn**2*(-1)
     & +log(mdn**2/s)**2*born/pi*alpha*qdn**2*(-1d0/2)

      softfsr=
     & +ibetasmomo*born/pi*alpha*qmo**2*(-jintqsmomo-1d0/2*jintqsmomo**2
     & +jintqsmomo**2*mmo**2/s)
     & +ibetasmomo*born*pi*alpha*qmo**2*(-1d0/3+2d0/3*mmo**2/s)
     & +ibetasmomo*lnlaom*born/pi*alpha*qmo**2*(-jintqsmomo+2*jintqsmomo
     & *mmo**2/s)
     & +ibetasmomo*log(2-2/(1+betasmomo))*born/pi*alpha*qmo**2*(2*jintqs
     & momo-4*jintqsmomo*mmo**2/s)
     & +ibetasmomo*ddilog(-1+2/(1+betasmomo))*born/pi*alpha*qmo**2*(2-4*
     & mmo**2/s)
     & +lnlaom*born/pi*alpha*qmo**2*(-1)

      softifi=
     & +lnlaom*log(1/(mmo**2+us)*mmo**2+1/(mmo**2+us)*ts)*born/pi*alpha*
     & qdn*qmo*(2)
     & +log(1+1d0/qs/ts*mmo**4+2/qs*mmo**2+1d0/qs*ts)*log(-1/(mmo**4+2*t
     & s*mmo**2+ts**2)*qs*ts)*born/pi*alpha*qdn*qmo*(2)
     & +log(1+1d0/qs/us*mmo**4+2/qs*mmo**2+1d0/qs*us)*log(-1/(mmo**4+2*u
     & s*mmo**2+us**2)*qs*us)*born/pi*alpha*qdn*qmo*(-2)
     & +log(1-2/(1+betasmomo)/(mmo**2+us)*mmo**2)*born/pi*alpha*qdn*qmo*
     & (-2*jintqsmomo)
     & +log(1-2/(1+betasmomo)/(mmo**2+us)*mmo**2)**2*born/pi*alpha*qdn*q
     & mo*(1)
     & +log(1-2/(1+betasmomo)/(mmo**2+ts)*mmo**2)*born/pi*alpha*qdn*qmo*
     & (2*jintqsmomo)
     & +log(1-2/(1+betasmomo)/(mmo**2+ts)*mmo**2)**2*born/pi*alpha*qdn*q
     & mo*(-1)
     & +log(-1/(mmo**4+2*us*mmo**2+us**2)*qs*us)**2*born/pi*alpha*qdn*qm
     & o*(-1)
     & +log(-1/(mmo**4+2*ts*mmo**2+ts**2)*qs*ts)**2*born/pi*alpha*qdn*qm
     & o*(1)
     & +ddilog(1-2/(1+betasmomo)/(mmo**2+us)*us)*born/pi*alpha*qdn*qmo*(
     & -2)
     & +ddilog(1-2/(1+betasmomo)/(mmo**2+ts)*ts)*born/pi*alpha*qdn*qmo*(
     & 2)
     & +ddilog(-1d0/qs/ts*mmo**4-2/qs*mmo**2-1d0/qs*ts)*born/pi*alpha*qd
     & n*qmo*(-2)
     & +ddilog(-1d0/qs/us*mmo**4-2/qs*mmo**2-1d0/qs*us)*born/pi*alpha*qd
     & n*qmo*(2)
     & +ddilog(-1/(-mmo**2+us+betasmomo*mmo**2+betasmomo*us)*mmo**2-1/(-
     & mmo**2+us+betasmomo*mmo**2+betasmomo*us)*us+1/(-mmo**2+us+betasmo
     & mo*mmo**2+betasmomo*us)*betasmomo*mmo**2+1/(-mmo**2+us+betasmomo*
     & mmo**2+betasmomo*us)*betasmomo*us)*born/pi*alpha*qdn*qmo*(2)
     & +ddilog(-1/(-mmo**2+ts+betasmomo*mmo**2+betasmomo*ts)*mmo**2-1/(-
     & mmo**2+ts+betasmomo*mmo**2+betasmomo*ts)*ts+1/(-mmo**2+ts+betasmo
     & mo*mmo**2+betasmomo*ts)*betasmomo*mmo**2+1/(-mmo**2+ts+betasmomo*
     & mmo**2+betasmomo*ts)*betasmomo*ts)*born/pi*alpha*qdn*qmo*(-2)

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
* This is the FORTRAN module (nc_ha_1414_1616_1spr) to calculate hard
* photon Bremsstrahlung for the anti-dn + dn -> mo^+ + mo^- process.
*
* It is produced by s2n package of SANC (v1.10) Project.
* Copyright (C), SANC Project Team, 2002-2012.
*
* http://sanc.jinr.ru/
* http://pcphsanc.cern.ch/
* E-mail: <sanc@jinr.ru>
************************************************************************
      subroutine nc_ha_1414_1616_1spr (s,spr,hard)
      implicit none!
      include 's2n_declare.h'

      real*8 kappaz,coef,sqs
      real*8 betasdndn,betasprmomo
      real*8 jintsdndn,jintsprmomo,ln1sdn,ln1bsprmo
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

      a1z = adn*amo
      a2z = 4d0*vdn*adn*vmo*amo
      v1z = vdn*vmo
      v2z = (vdn**2+adn**2)*(vmo**2+amo**2)
      vaz = (vdn**2+adn**2)*(vmo**2-amo**2)

      v0s =
     & +qdn**2*qmo**2
     & +qdn*qmo*(chizs+chizsc)*v1z
     & +chizs*chizsc*v2z
      vas =
     & +qdn**2*qmo**2
     & +qdn*qmo*(chizs+chizsc)*v1z
     & +chizs*chizsc*vaz
      v0spr =
     & +qdn**2*qmo**2
     & +qdn*qmo*(chizspr+chizsprc)*v1z
     & +chizspr*chizsprc*v2z
      vaspr =
     & +qdn**2*qmo**2
     & +qdn*qmo*(chizspr+chizsprc)*v1z
     & +chizspr*chizsprc*vaz
      a1sspr =
     & -(chizs+chizsc-chizspr-chizsprc)*a1z
      a2sspr =
     & +qdn*qmo*(chizs+chizsc+chizspr+chizsprc)*a1z
     & +(chizs*chizsprc+chizsc*chizspr)*a2z

      betasdndn = dsqrt(1d0-4d0*rdnm2/s)
      jintsdndn = dlog((1d0-betasdndn)/(1d0+betasdndn))
      ln1sdn    = -jintsdndn-1d0
      betasprmomo = dsqrt(1d0-4d0*rmom2/spr)
      jintsprmomo = dlog((1d0-betasprmomo)/(1d0+betasprmomo))
      ln1bsprmo   = -jintsprmomo-betasprmomo

      hard=
     & +v0s*alpha**3*qmo**2/(s-spr)*theta_hard(s,spr,omega)*(16d0/9*jint
     & sprmomo*mmo**2/s**2-16d0/9*jintsprmomo*mmo**4/s**3)
     & +v0s*alpha**3*qmo**2*spr/(s-spr)*theta_hard(s,spr,omega)*(16d0/9*
     & jintsprmomo*mmo**2/s**3)
     & +v0s*(s**2+spr**2)*alpha**3*qmo**2/(s-spr)*theta_hard(s,spr,omega
     & )*(-4d0/9*jintsprmomo*mmo**2/s**4+4d0/9*ln1bsprmo/s**3)
     & +v0s*betasprmomo*alpha**3*qmo**2*spr/(s-spr)*theta_hard(s,spr,ome
     & ga)*(8d0/9*mmo**2/s**3)
     & +v0spr*betasprmomo*(s**2+spr**2)*alpha**3*qdn**2/spr**2/(s-spr)*t
     & heta_hard(s,spr,omega)*(-4d0/9*ln1sdn*mmo**2/s**2)
     & +v0spr*betasprmomo*(s**2+spr**2)*alpha**3*qdn**2/spr/(s-spr)*thet
     & a_hard(s,spr,omega)*(4d0/9*ln1sdn/s**2)
     & +a2sspr*(s+spr)**2*alpha**3*qdn*qmo/spr/(s-spr)*theta_hard(s,spr,
     & omega)*(-2d0/3*jintsprmomo*mmo**2/s**3)
     & +a2sspr*betasprmomo*(s+spr)*alpha**3*qdn*qmo/(s-spr)*theta_hard(s
     & ,spr,omega)*(-2d0/3/s**2)
     & +vas*alpha**3*qmo**2/(s-spr)*theta_hard(s,spr,omega)*(16d0/3*jint
     & sprmomo*mmo**4/s**3)
     & +vas*alpha**3*qmo**2*spr/(s-spr)*theta_hard(s,spr,omega)*(-32d0/9
     & *jintsprmomo*mmo**2/s**3)
     & +vas*(s**2+spr**2)*alpha**3*qmo**2/(s-spr)*theta_hard(s,spr,omega
     & )*(4d0/9*jintsprmomo*mmo**2/s**4)
     & +vas*betasprmomo*alpha**3*qmo**2*spr/(s-spr)*theta_hard(s,spr,ome
     & ga)*(-8d0/3*mmo**2/s**3)
     & +vaspr*betasprmomo*(s**2+spr**2)*alpha**3*qdn**2/spr**2/(s-spr)*t
     & heta_hard(s,spr,omega)*(4d0/3*ln1sdn*mmo**2/s**2)
     & +a1sspr*(s+spr)*alpha**3*qdn**2*qmo**2/spr*(-2d0/3*jintsprmomo*mm
     & o**2/s**3)

      hard = hard*conhc*cfprime

      return
      end
