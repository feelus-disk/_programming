************************************************************************
* sanc_nc_v1.30 package.
************************************************************************
* File (nc-qcd_br_1414_1212.f) is created on Wed Apr 18 13:35:25 MSK 2012.
************************************************************************
* This is the FORTRAN module (nc_qcd_br_1414_1212) to calculate EW Born
* cross section and QCD virtual corrections
* for the anti-dn + dn -> el^+ + el^- process.
*
* It is produced by s2n package of SANC (v1.10) Project.
* Copyright (C), SANC Project Team, 2002-2012.
*
* http://sanc.jinr.ru/
* http://pcphsanc.cern.ch/
* E-mail: <sanc@jinr.ru>
************************************************************************
      subroutine nc_qcd_br_1414_1212 (qs,ts,us,born,soft,hard)
      implicit none!
      include 's2n_declare.h'

      real*8 a0s,v0s,vaz
      real*8 a1z,a2z,v1z,v2z,vas
      real*8 kappaz
      real*8 betasdndn
      real*8 ln1sdn,jintsdndn
      complex*16 chizs,chizsc

      cmz2 = mz2

      s = -qs
      t = -ts
      u = -us

      cosf = (t-u)/s
      sinf = dsqrt(1d0-cosf**2)

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

      v0s =
     & +qdn**2*qel**2
     & +qdn*qel*(chizs+chizsc)*v1z
     & +chizs*chizsc*v2z
      a0s =
     & +qdn*qel*(chizs+chizsc)*a1z
     & +chizs*chizsc*a2z

      born=
     & +v0s*pi*alpha**2*(1d0/6/s+1d0/6*cosf**2/s)
     & +a0s*pi*alpha**2*(-1d0/3*cosf/s)

      born = born*conhc
      virt = 0d0
      soft = 0d0
      hard = 0d0

      if (iborn.eq.1) return

      betasdndn = dsqrt(1d0-4d0*rdnm2/s)
      jintsdndn = dlog((1d0-betasdndn)/(1d0+betasdndn))
      ln1sdn    = -jintsdndn-1d0

      softvirt=
     & +born/pi*alphas*cf*(-1d0/2)
     & +ln1sdn*born/pi*alphas*cf*(3d0/2+log(4*omega**2/s))
     & +ddilog(1d0)*born/pi*alphas*cf*(2)

      soft = softvirt

      return
      end
************************************************************************
* This is the FORTRAN module (nc_qcd_ha_1414_1212_1spr) to calculate hard
* gluon radiation for the anti-dn + dn -> el^+ + el^- process.
*
* It is produced by s2n package of SANC (v1.10) Project.
* Copyright (C), SANC Project Team, 2002-2012.
*
* http://sanc.jinr.ru/
* http://pcphsanc.cern.ch/
* E-mail: <sanc@jinr.ru>
************************************************************************
      subroutine nc_qcd_ha_1414_1212_1spr (s,spr,hard)
      implicit none!
      include 's2n_declare.h'

      real*8 kappaz,coef,sqs
      real*8 betasdndn
      real*8 jintsdndn,ln1sdn
      real*8 v1z,v2z,vaz
      real*8 v0spr,vaspr
      complex*16 chizspr,chizsprc

      cmz2 = mz2

      kappaz   = gf*rzm2/(dsqrt(2d0)*8d0*pi)/alpha
      if (irun.eq.0) then
         chizspr = 4d0*kappaz*spr/(spr-cmz2)
      else
         chizspr = 4d0*kappaz*spr/(spr-dcmplx(mz**2,-spr*wz/mz))
      endif
      chizsprc = dconjg(chizspr)

      v1z = vdn*vel
      v2z = (vdn**2+adn**2)*(vel**2+ael**2)
      vaz = (vdn**2+adn**2)*(vel**2-ael**2)

      v0spr =
     & +qdn**2*qel**2
     & +qdn*qel*(chizspr+chizsprc)*v1z
     & +chizspr*chizsprc*v2z
      vaspr =
     & +qdn**2*qel**2
     & +qdn*qel*(chizspr+chizsprc)*v1z
     & +chizspr*chizsprc*vaz

      betasdndn = dsqrt(1d0-4d0*rdnm2/s)
      jintsdndn = dlog((1d0-betasdndn)/(1d0+betasdndn))
      ln1sdn    = -jintsdndn-1d0

      hard=
     & +ln1sdn*v0spr*(s**2+spr**2)*alpha**2*alphas*cf*(4d0/9/s**2/spr/(s
     & -spr)*theta_hard(s,spr,omega))

      hard = hard*conhc

      return
      end
