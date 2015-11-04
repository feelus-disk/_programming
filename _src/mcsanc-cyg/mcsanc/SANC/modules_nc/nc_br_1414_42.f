************************************************************************
* sanc_nc_v1.30 package.
************************************************************************
* File (nc_br_1414_42.f) created on Wed Apr 18 13:48:15 MSK 2012.
************************************************************************
* This is the FORTRAN module (nc_bo_1414_42) to calculate EW
* integrated Born cross section for the anti-dn + dn -> H + Z process.
*
* It is produced by s2n package of SANC (v1.10) Project.
* Copyright (C), SANC Project Team, 2002-2012.
*
* http://sanc.jinr.ru/
* http://pcphsanc.cern.ch/
* E-mail: <sanc@jinr.ru>
************************************************************************
      subroutine nc_bo_1414_42 (s,born)
      implicit none!
      include 's2n_declare.h'

      real*8 af,vf,sqrtlszh
      complex*16 propzs,propizs,propzsc

      cmz2 = mz2

      af = adn
      vf = vdn

      if (irun.eq.0) then
         propizs = (cmz2-s)
      else
         propizs = (dcmplx(mz**2,-s*wz/mz)-s)
      endif
      propzs  = 1d0/propizs
      propzsc = dconjg(propzs)

      sqrtlszh = sqrt(s**2-2d0*s*(rzm2+rhm2)+(rzm2-rhm2)**2)

      born=
     & +propzs*propzsc*sqrtlszh*(vf**2+af**2)/pi*g**4/ctw**4*(1d0/2304-1
     & d0/1152*mh**2/s+1d0/2304*mh**4/s**2+5d0/1152*mz**2/s-1d0/1152*mz*
     & *2*mh**2/s**2+1d0/2304*mz**4/s**2)

      born = born*conhc

      return
      end
************************************************************************
* This is the FORTRAN module (nc_br_1414_42) to calculate EW Born
* cross section and soft photon Bremsstrahlung
* for the anti-dn + dn -> H + Z process.
*
* It is produced by s2n package of SANC (v1.10) Project.
* Copyright (C), SANC Project Team, 2002-2012.
*
* http://sanc.jinr.ru/
* http://pcphsanc.cern.ch/
* E-mail: <sanc@jinr.ru>
************************************************************************
      subroutine nc_br_1414_42 (qs,ts,us,born,soft,hard)
      implicit none!
      include 's2n_declare.h'

      real*8 sq,af,vf,sqrtlszh,l2
      complex*16 propzs,propizs,propzsc

      cmz2 = mz2

      s = -qs
      t = -ts
      u = -us
      sq = dsqrt(s)

      sqrtlszh = sqrt(s**2-2d0*s*(rzm2+rhm2)+(rzm2-rhm2)**2)
      cosf = (t-u)/sqrtlszh
      sinf = dsqrt(1d0-cosf**2)

      af = adn
      vf = vdn

      if (irun.eq.0) then
         propizs = (cmz2-s)
      else
         propizs = (dcmplx(mz**2,-s*wz/mz)-s)
      endif
      propzs  = 1d0/propizs
      propzsc = dconjg(propzs)


      born=
     & +propzs*propzsc*cosf**2*sqrtlszh*(vf**2+af**2)/pi*g**4/ctw**4*(-1
     & d0/3072+1d0/1536*mh**2/s-1d0/3072*mh**4/s**2+1d0/1536*mz**2/s+1d0
     & /1536*mz**2*mh**2/s**2-1d0/3072*mz**4/s**2)
     & +propzs*propzsc*sqrtlszh*(vf**2+af**2)/pi*g**4/ctw**4*(1d0/3072-1
     & d0/1536*mh**2/s+1d0/3072*mh**4/s**2+1d0/512*mz**2/s-1d0/1536*mz**
     & 2*mh**2/s**2+1d0/3072*mz**4/s**2)

      born = born*conhc
      virt = 0d0
      soft = 0d0
      hard = 0d0

      if (iborn.eq.1) return

      l2 = log(s/mdn**2)

      softvirt=
     & +born/pi*alpha*qdn**2*(-1d0/2)
     & +born/pi*alpha*qdn**2*(l2-1)*(3d0/2)
     & +log(2*omega/sq)*born/pi*alpha*qdn**2*(l2-1)*(2)
     & +ddilog(1d0)*born/pi*alpha*qdn**2*(2)

      soft = softvirt*cfprime

      return
      end
************************************************************************
* This is the FORTRAN module (nc_ha_1414_42_1spr) to calculate hard
* photon Bremsstrahlung for the anti-dn + dn -> H + Z process.
*
* It is produced by s2n package of SANC (v1.10) Project.
* Copyright (C), SANC Project Team, 2002-2012.
*
* http://sanc.jinr.ru/
* http://pcphsanc.cern.ch/
* E-mail: <sanc@jinr.ru>
************************************************************************
      subroutine nc_ha_1414_42_1spr (s,spr,hard)
      implicit none!
      include 's2n_declare.h'

      real*8 af,vf,sqrtlsprzh,l2
      complex*16 propzspr,propizspr,propzsprc

      cmz2 = mz2

      af = adn
      vf = vdn

      if (irun.eq.0) then
         propizspr = (cmz2-spr)
      else
         propizspr = (dcmplx(mz**2,-spr*wz/mz)-spr)
      endif
      propzspr  = 1d0/propizspr
      propzsprc = dconjg(propzspr)

      sqrtlsprzh = sqrt(spr**2-2d0*spr*(rzm2+rhm2)+(rzm2-rhm2)**2)

      l2 = log(s/mdn**2)

      hard=
     & +propzspr*propzsprc*sqrtlsprzh*(s**2+spr**2)*(vf**2+af**2)/pi**3*
     & g**6*stw**2/ctw**4*qdn**2/s**2/(s-spr)*theta_hard(s,spr,omega)*(l
     & 2-1)*(1d0/9216-1d0/4608*mh**2/spr+1d0/9216*mh**4/spr**2+5d0/4608*
     & mz**2/spr-1d0/4608*mz**2*mh**2/spr**2+1d0/9216*mz**4/spr**2)

      hard = hard*conhc*cfprime

      return
      end
