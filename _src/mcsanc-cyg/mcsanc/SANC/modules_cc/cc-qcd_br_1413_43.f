************************************************************************
* sanc_cc_v1.51 package.
************************************************************************
* File (cc-qcd_br_1413_43.f) created on Fri Mar 23 13:04:50 MSK 2012.
************************************************************************
* This is the FORTRAN module (cc_qcd_br_1413_43) to calculate QCD soft
* gluon radiation cross section for the anti-dn + up -> H   + W^+ process.
*
* It is produced by s2n package of SANC (v1.10) Project.
* Copyright (C), SANC Project Team, 2002-2012.
*
* http://sanc.jinr.ru/
* http://pcphsanc.cern.ch/
* E-mail: <sanc@jinr.ru>
************************************************************************
      subroutine cc_qcd_br_1413_43 (qs,ts,us,born,soft,hard)
      implicit none!
      include 's2n_declare.h'

      real*8 sqrtlshw
      complex*16 propws,propiws,propwsc

      cmw2 = mw2

      s = -qs
      t = -ts
      u = -us

      sqrtlshw = dsqrt((s-mw**2-mh**2)**2-4d0*mw**2*mh**2)
      cosf = (u-t)/sqrtlshw
      sinf = dsqrt(1d0-cosf**2)

      if (irun.eq.0) then
         propiws = (cmw2-s)
      else
         propiws = (dcmplx(mw**2,-s*ww/mw)-s)
      endif
      propws = 1d0/propiws
      propwsc = dconjg(propws)

      born=
     & +sqrtlshw**3*propws*propwsc/pi*gf**2*(-1d0/96*cosf**2*mw**4/s**2)
     & +sqrtlshw*propws*propwsc/pi*gf**2*(1d0/96*mw**4-1d0/48*mw**4*mh**
     & 2/s+1d0/96*mw**4*mh**4/s**2+1d0/16*mw**6/s-1d0/48*mw**6*mh**2/s**
     & 2+1d0/96*mw**8/s**2)

      born = born*conhc
      virt = 0d0
      soft = 0d0
      hard = 0d0

      if (iborn.eq.1) return

      softvirt=
     & +born/pi*alphas*cf*(-2)
     & +log(1d0/mup**2*s)*born/pi*alphas*cf*(3d0/4)
     & +log(1d0/mdn**2*s)*born/pi*alphas*cf*(3d0/4)
     & +log(4*omega**2/s)*born/pi*alphas*cf*(-1)
     & +log(4*omega**2/s)*log(1d0/mup**2*s)*born/pi*alphas*cf*(1d0/2)
     & +log(4*omega**2/s)*log(1d0/mdn**2*s)*born/pi*alphas*cf*(1d0/2)
     & +ddilog(1d0)*born/pi*alphas*cf*(2)

      soft = softvirt

      return
      end
