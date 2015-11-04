************************************************************************
* sanc_cc_v1.50 package.
************************************************************************
* File (cc_br_1413_43.f) created on Thu Jan 19 01:32:29 MSK 2012.
************************************************************************
* This is the FORTRAN module (cc_bo_1413_43) to calculate EW
* integrated Born cross section for the anti-dn + up -> H   + W^+ process.
*
* It is produced by s2n package of SANC (v1.10) Project.
* Copyright (C), SANC Project Team, 2002-2012.
*
* http://sanc.jinr.ru/
* http://pcphsanc.cern.ch/
* E-mail: <sanc@jinr.ru>
************************************************************************
      subroutine cc_bo_1413_43 (s,born)
      implicit none!
      include 's2n_declare.h'

      real*8 kappaw
      real*8 sqrtlswh
      complex*16 propws,propiws,propwsc

      cmw2 = mw2

      sqrtlswh = dsqrt((s-mw**2-mh**2)**2-4d0*mw**2*mh**2)

      if (irun.eq.0) then
         propiws = (cmw2-s)
      elseif (irun.eq.1) then
         propiws = (dcmplx(mw**2,-s*ww/mw)-s)
      endif
      propws = 1d0/propiws
      propwsc = dconjg(propws)

      born=
     & +propws*propwsc*sqrtlswh/pi*g**4*(1d0/2304-1d0/1152*mh**2/s+1d0/2
     & 304*mh**4/s**2+5d0/1152*mw**2/s-1d0/1152*mw**2*mh**2/s**2+1d0/230
     & 4*mw**4/s**2)

      born = born*conhc

      return
      end
************************************************************************
* This is the FORTRAN module (cc_br_1413_43) to calculate EW Born
* cross section and soft photon Bremsstrahlung
* for the anti-dn + up -> H   + W^+ process.
*
* It is produced by s2n package of SANC (v1.10) Project.
* Copyright (C), SANC Project Team, 2002-2012.
*
* http://sanc.jinr.ru/
* http://pcphsanc.cern.ch/
* E-mail: <sanc@jinr.ru>
************************************************************************
      subroutine cc_br_1413_43 (qs,ts,us,born,soft,hard)
      implicit none!
      include 's2n_declare.h'

      real*8 qw
      real*8 jbwhwsq
      real*8 sqrtlswh
      real*8 betaswh,ibetaswh
      real*8 pxxswjh,ipxxswjh
      complex*16 propws,propiws,propwsc

      cmw2 = mw2
      qw = 1d0

      s = -qs
      t = -ts
      u = -us

      sqrtlswh = dsqrt((s-mw**2-mh**2)**2-4d0*mw**2*mh**2)
      cosf = (u-t)/sqrtlswh
      sinf = dsqrt(1d0-cosf**2)

      if (irun.eq.0) then
         propiws = (cmw2-s)
      elseif (irun.eq.1) then
         propiws = (dcmplx(mw**2,-s*ww/mw)-s)
      endif
      propws = 1d0/propiws
      propwsc = dconjg(propws)

      born=
     & +propws*propwsc*sqrtlswh/pi*g**4*(1d0/3072-1d0/1536*mh**2/s+1d0/3
     & 072*mh**4/s**2+1d0/512*mw**2/s-1d0/1536*mw**2*mh**2/s**2+1d0/3072
     & *mw**4/s**2)
     & +propws*propwsc*sqrtlswh*cosf**2/pi*g**4*(-1d0/3072+1d0/1536*mh**
     & 2/s-1d0/3072*mh**4/s**2+1d0/1536*mw**2/s+1d0/1536*mw**2*mh**2/s**
     & 2-1d0/3072*mw**4/s**2)

      born = born*conhc
      virt = 0d0
      soft = 0d0
      hard = 0d0

      if (iborn.eq.1) return

      betaswh = sqrtlswh/(s+mw**2-mh**2)
      ibetaswh = 1d0/betaswh

      pxxswjh = (s+mw**2-mh**2)
      ipxxswjh = 1d0/pxxswjh

      jbwhwsq =
     &    log((mw**2-mh**2+s-sqrtlswh)/(mw**2-mh**2+s+sqrtlswh))

      softvirt=
     & +born/pi*alpha*(3d0/4-1d0/2*ibetaswh*jbwhwsq-3d0/4*log(s/thmu2))
     & +born/pi*alpha*qdn*(-1d0/4*jbwhwsq**2)
     & +born/pi*alpha*qdn**2*(3d0/4-3d0/4*log(s/thmu2))
     & +born/pi*alpha*qup*(1d0/4*jbwhwsq**2)
     & +born/pi*alpha*qup**2*(3d0/4-3d0/4*log(s/thmu2))
     & +log(1+1d0/2/(mw**2+us)*betaswh*pxxswjh-1d0/2/(mw**2+us)*pxxswjh)
     & **2*born/pi*alpha*qdn*(1d0/2)
     & +log(1+1d0/2/(mw**2+ts)*betaswh*pxxswjh-1d0/2/(mw**2+ts)*pxxswjh)
     & **2*born/pi*alpha*qup*(-1d0/2)
     & +log(1d0/mw**2*s)*born/pi*alpha*(1d0/4)
     & +log(1d0/mw**2*s)*log(1+1d0/2/(mw**2+us)*betaswh*pxxswjh-1d0/2/(m
     & w**2+us)*pxxswjh)*born/pi*alpha*qdn*(1)
     & +log(1d0/mw**2*s)*log(1+1d0/2/(mw**2+ts)*betaswh*pxxswjh-1d0/2/(m
     & w**2+ts)*pxxswjh)*born/pi*alpha*qup*(-1)
     & +log(1d0/mw**2*s)**2*born/pi*alpha*qdn*(1d0/4)
     & +log(1d0/mw**2*s)**2*born/pi*alpha*qup*(-1d0/4)
     & +log(1d0/mw**2*s)*log(mw**2/s+us/s)*born/pi*alpha*qdn*(1d0/2)
     & +log(1d0/mw**2*s)*log(mw**2/s+ts/s)*born/pi*alpha*qup*(-1d0/2)
     & +log(1d0/mw**2*s)*log(1d0/2*betaswh*pxxswjh/s+1d0/2*pxxswjh/s)*bo
     & rn/pi*alpha*qdn*(2)
     & +log(1d0/mw**2*s)*log(1d0/2*betaswh*pxxswjh/s+1d0/2*pxxswjh/s)*bo
     & rn/pi*alpha*qup*(-2)
     & +log(1d0/mup**2*s)*born/pi*alpha*qup**2*(3d0/4)
     & +log(1d0/mdn**2*s)*born/pi*alpha*qdn**2*(3d0/4)
     & +log(mw**2/s+us/s)**2*born/pi*alpha*qdn*(5d0/4)
     & +log(mw**2/s+ts/s)**2*born/pi*alpha*qup*(-5d0/4)
     & +log(us/s)*log(1d0/mw**2*s)*born/pi*alpha*qdn*(-1d0/2)
     & +log(us/s)*log(mw**2/s+us/s)*born/pi*alpha*qdn*(-1)
     & +log(us/s)**2*born/pi*alpha*qdn*(1d0/4)
     & +log(ts/s)*log(1d0/mw**2*s)*born/pi*alpha*qup*(1d0/2)
     & +log(ts/s)*log(mw**2/s+ts/s)*born/pi*alpha*qup*(1)
     & +log(ts/s)**2*born/pi*alpha*qup*(-1d0/4)
     & +log(4*omega**2/s)*born/pi*alpha*(-1d0/2)
     & +log(4*omega**2/s)*born/pi*alpha*qdn**2*(-1d0/2)
     & +log(4*omega**2/s)*born/pi*alpha*qup**2*(-1d0/2)
     & +log(4*omega**2/s)*log(1d0/mw**2*s)*born/pi*alpha*qdn*(-1d0/2)
     & +log(4*omega**2/s)*log(1d0/mw**2*s)*born/pi*alpha*qup*(1d0/2)
     & +log(4*omega**2/s)*log(1d0/mup**2*s)*born/pi*alpha*qup*(1d0/2)
     & +log(4*omega**2/s)*log(1d0/mup**2*s)*born/pi*alpha*qup*qdn*(1d0/2
     & )
     & +log(4*omega**2/s)*log(1d0/mdn**2*s)*born/pi*alpha*qdn*(-1d0/2)
     & +log(4*omega**2/s)*log(1d0/mdn**2*s)*born/pi*alpha*qup*qdn*(1d0/2
     & )
     & +log(4*omega**2/s)*log(mw**2/s+us/s)*born/pi*alpha*qdn*(-1)
     & +log(4*omega**2/s)*log(mw**2/s+ts/s)*born/pi*alpha*qup*(1)
     & +log(1d0/2*betaswh*pxxswjh/s+1d0/2*pxxswjh/s)*log(1+1d0/2/(mw**2+
     & us)*betaswh*pxxswjh-1d0/2/(mw**2+us)*pxxswjh)*born/pi*alpha*qdn*(
     & 2)
     & +log(1d0/2*betaswh*pxxswjh/s+1d0/2*pxxswjh/s)*log(1+1d0/2/(mw**2+
     & ts)*betaswh*pxxswjh-1d0/2/(mw**2+ts)*pxxswjh)*born/pi*alpha*qup*(
     & -2)
     & +log(1d0/2*betaswh*pxxswjh/s+1d0/2*pxxswjh/s)**2*born/pi*alpha*qd
     & n*(2)
     & +log(1d0/2*betaswh*pxxswjh/s+1d0/2*pxxswjh/s)**2*born/pi*alpha*qu
     & p*(-2)
     & +log(1/(mw**2+us)*us)**2*born/pi*alpha*qdn*(-1d0/4)
     & +log(1/(mw**2+ts)*ts)**2*born/pi*alpha*qup*(1d0/4)
     & +ddilog(1-2/(1+betaswh)
     & +2/(1+betaswh)/(mw**2+us)*ipxxswjh*mw**2*s)*born/pi*alpha*qdn*(-1
     & )
     & +ddilog(1-2/(1+betaswh)
     & +2/(1+betaswh)/(mw**2+ts)*ipxxswjh*mw**2*s)*born/pi*alpha*qup*(1)
     & +ddilog(1-1/(mw**2+us)*us)*born/pi*alpha*qdn*(1d0/2)
     & +ddilog(1-1/(mw**2+us)*pxxswjh+1/(mw**2+us)/(mw**2+us)*mw**2*s)*b
     & orn/pi*alpha*qdn*(1)
     & +ddilog(1-1/(mw**2+ts)*ts)*born/pi*alpha*qup*(-1d0/2)
     & +ddilog(1-1/(mw**2+ts)*pxxswjh+1/(mw**2+ts)/(mw**2+ts)*mw**2*s)*b
     & orn/pi*alpha*qup*(-1)
     & +ddilog(1/(mw**2+us)*us)*born/pi*alpha*qdn*(-1d0/2)
     & +ddilog(1/(mw**2+ts)*ts)*born/pi*alpha*qup*(1d0/2)
     & +ddilog(2/(2*mw**2-betaswh*pxxswjh**2/s-pxxswjh**2/s+1/(mw**2+us)
     & *betaswh*pxxswjh*mw**2+1/(mw**2+us)*pxxswjh*mw**2)*mw**2)*born/pi
     & *alpha*qdn*(1)
     & +ddilog(2/(2*mw**2-betaswh*pxxswjh**2/s-pxxswjh**2/s+1/(mw**2+ts)
     & *betaswh*pxxswjh*mw**2+1/(mw**2+ts)*pxxswjh*mw**2)*mw**2)*born/pi
     & *alpha*qup*(-1)
     & +ddilog(1d0)*born/pi*alpha*qdn*(3d0/2)
     & +ddilog(1d0)*born/pi*alpha*qup*(-3d0/2)
     & +ddilog(1d0)*born/pi*alpha*qup*qdn*(2)

      soft = softvirt*cfprime

      return
      end
