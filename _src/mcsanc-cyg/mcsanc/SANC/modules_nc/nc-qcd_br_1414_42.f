************************************************************************
* sanc_nc_v1.30 package.
************************************************************************
* File (nc-qcd_br_1414_42.f) created on Wed Apr 18 13:48:22 MSK 2012.
************************************************************************
* This is the FORTRAN module (nc_qcd_br_1414_42) to calculate QCD soft
* gluon radiation cross section for the anti-dn + dn -> H + Z process.
*
* It is produced by s2n package of SANC (v1.10) Project.
* Copyright (C), SANC Project Team, 2002-2012.
*
* http://sanc.jinr.ru/
* http://pcphsanc.cern.ch/
* E-mail: <sanc@jinr.ru>
************************************************************************
      subroutine nc_qcd_br_1414_42 (qs,ts,us,born,soft,hard)
      implicit none!
      include 's2n_declare.h'

      real*8 sqrtlshz,vf,af
      complex*16 propzs,propizs,propzsc

      cmz2 = mz2

      vf = vdn
      af = adn

      s = -qs
      t = -ts
      u = -us

      sqrtlshz = dsqrt((s-mh**2-mz**2)**2-4d0*mh**2*mz**2)
      cosf = (t-u)/sqrtlshz
      sinf = dsqrt(1d0-cosf**2)

      if (irun.eq.0) then
         propizs = (cmz2-s)
      else
         propizs = (dcmplx(mz**2,-s*wz/mz)-s)
      endif
      propzs = 1d0/propizs
      propzsc = dconjg(propzs)


      born=
     & +sqrtlshz**3*propzs*propzsc*(vf**2+af**2)/pi*gf**2*(-1d0/96*cosf*
     & *2*mz**4/s**2)
     & +sqrtlshz*propzs*propzsc*(vf**2+af**2)/pi*gf**2*(1d0/96*mz**4-1d0
     & /48*mz**4*mh**2/s+1d0/96*mz**4*mh**4/s**2+1d0/16*mz**6/s-1d0/48*m
     & z**6*mh**2/s**2+1d0/96*mz**8/s**2)

      born = born*conhc
      virt = 0d0
      soft = 0d0
      hard = 0d0

      if (iborn.eq.1) return

      softvirt=
     & +born/pi*alphas*cf*(-2)
     & +log(1d0/mdn**2*s)*born/pi*alphas*cf*(3d0/2)
     & +log(4*omega**2/s)*born/pi*alphas*cf*(-1)
     & +log(4*omega**2/s)*log(1d0/mdn**2*s)*born/pi*alphas*cf*(1)
     & +ddilog(1d0)*born/pi*alphas*cf*(2)

      soft = softvirt

      return
      end
