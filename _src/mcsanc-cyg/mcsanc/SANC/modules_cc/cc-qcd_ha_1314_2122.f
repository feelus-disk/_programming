************************************************************************
* sanc_cc_v1.40 package.
************************************************************************
* File (cc-qcd_ha_1314_2122.f) is created on Tue Aug  9 22:49:04 MSD 2011.
************************************************************************
* This is the FORTRAN module (cc_qcd_ha_1314_2122) to calculate differential
* hard gluon radiation for the anti-up + dn -> anti-tp + bt process.
*
* It is produced by s2n package of SANC (v1.10) Project.
* Copyright (C), SANC Project Team, 2002-2011.
*
* http://sanc.jinr.ru/
* http://pcphsanc.cern.ch/
* E-mail: <sanc@jinr.ru>
************************************************************************
      subroutine cc_qcd_ha_1314_2122 (s,spr,ph4,costh4,costh5,hard)
      implicit none!
      include 's2n_declare.h'

      real*8 sq,sqspr
      real*8 p1p2,p1p3,p1p4,p1p5,p2p3,p2p4,p2p5,p3p4,p3p5,p4p5
      real*8 ph4,cosph4,sinph4,costh4,sinth4,costh5,sinth5
      real*8 sqrtlsprtpbt,isqrtlsprtpbt,sqrtlsupdn,isqrtlsupdn
      complex*16 propwspr,propiwspr,propwsprc,propws,propiws,propwsc
      real*8 iz1up,iz2dn,iz3bt,iz4tp

      cmw2 = mw2

      sq = dsqrt(s)
      sqspr = dsqrt(spr)

      cosph4 = dcos(ph4)
      sinph4 = dsin(ph4)
      sinth4 = dsqrt(1d0-costh4**2)
      sinth5 = dsqrt(1d0-costh5**2)

      if (irun.eq.0) then
         propiwspr = (cmw2-spr)
      elseif (irun.eq.1) then
         propiwspr = (dcmplx(mw**2,-spr*ww/mw)-spr)
      endif
      propwspr = 1d0/propiwspr
      propwsprc = dconjg(propwspr)

      if (irun.eq.0) then
         propiws = (cmw2-s)
      elseif (irun.eq.1) then
         propiws = (dcmplx(mw**2,-s*ww/mw)-s)
      endif
      propws = 1d0/propiws
      propwsc = dconjg(propws)

      sqrtlsprtpbt = sqrt(spr**2-2d0*spr*(rtpm2+rbtm2)+(rtpm2-rbtm2)**2)
      isqrtlsprtpbt = 1d0/sqrtlsprtpbt
      sqrtlsupdn = sqrt(s**2-2d0*s*(rupm2+rdnm2)+(rupm2-rdnm2)**2)
      isqrtlsupdn = 1d0/sqrtlsupdn

      p1p2=
     & -1d0/2*s

      p1p3=
     & +sinph4*sinth4*sinth5*sqrtlsprtpbt*(1d0/4*sq*sqspr/spr)
     & +costh4*costh5*sqrtlsprtpbt*(-1d0/8-1d0/8*s/spr)
     & +costh4*sqrtlsprtpbt*(1d0/8-1d0/8*s/spr)
     & +costh5*(1d0/8*spr-1d0/8*s+1d0/8*mbt**2-1d0/8*mbt**2*s/spr-1d0/8*
     & mtp**2+1d0/8*mtp**2*s/spr)
     & -1d0/8*spr-1d0/8*s-1d0/8*mbt**2-1d0/8*mbt**2*s/spr+1d0/8*mtp**2+1
     & d0/8*mtp**2*s/spr

      p1p4=
     & +sinph4*sinth4*sinth5*sqrtlsprtpbt*(-1d0/4*sq*sqspr/spr)
     & +costh4*costh5*sqrtlsprtpbt*(1d0/8+1d0/8*s/spr)
     & +costh4*sqrtlsprtpbt*(-1d0/8+1d0/8*s/spr)
     & +costh5*(1d0/8*spr-1d0/8*s-1d0/8*mbt**2+1d0/8*mbt**2*s/spr+1d0/8*
     & mtp**2-1d0/8*mtp**2*s/spr)
     & -1d0/8*spr-1d0/8*s+1d0/8*mbt**2+1d0/8*mbt**2*s/spr-1d0/8*mtp**2-1
     & d0/8*mtp**2*s/spr

      p1p5=
     & +costh5*(-1d0/4*spr+1d0/4*s)
     & +1d0/4*spr-1d0/4*s

      p2p3=
     & +sinph4*sinth4*sinth5*sqrtlsprtpbt*(-1d0/4*sq*sqspr/spr)
     & +costh4*costh5*sqrtlsprtpbt*(1d0/8+1d0/8*s/spr)
     & +costh4*sqrtlsprtpbt*(1d0/8-1d0/8*s/spr)
     & +costh5*(-1d0/8*spr+1d0/8*s-1d0/8*mbt**2+1d0/8*mbt**2*s/spr+1d0/8
     & *mtp**2-1d0/8*mtp**2*s/spr)
     & -1d0/8*spr-1d0/8*s-1d0/8*mbt**2-1d0/8*mbt**2*s/spr+1d0/8*mtp**2+1
     & d0/8*mtp**2*s/spr

      p2p4=
     & +sinph4*sinth4*sinth5*sqrtlsprtpbt*(1d0/4*sq*sqspr/spr)
     & +costh4*costh5*sqrtlsprtpbt*(-1d0/8-1d0/8*s/spr)
     & +costh4*sqrtlsprtpbt*(-1d0/8+1d0/8*s/spr)
     & +costh5*(-1d0/8*spr+1d0/8*s+1d0/8*mbt**2-1d0/8*mbt**2*s/spr-1d0/8
     & *mtp**2+1d0/8*mtp**2*s/spr)
     & -1d0/8*spr-1d0/8*s+1d0/8*mbt**2+1d0/8*mbt**2*s/spr-1d0/8*mtp**2-1
     & d0/8*mtp**2*s/spr

      p2p5=
     & +costh5*(1d0/4*spr-1d0/4*s)
     & +1d0/4*spr-1d0/4*s

      p3p4=
     & -1d0/2*spr+1d0/2*mbt**2+1d0/2*mtp**2

      p3p5=
     & +costh4*sqrtlsprtpbt*(1d0/4-1d0/4*s/spr)
     & +1d0/4*spr-1d0/4*s+1d0/4*mbt**2-1d0/4*mbt**2*s/spr-1d0/4*mtp**2+1
     & d0/4*mtp**2*s/spr

      p4p5=
     & +costh4*sqrtlsprtpbt*(-1d0/4+1d0/4*s/spr)
     & +1d0/4*spr-1d0/4*s-1d0/4*mbt**2+1d0/4*mbt**2*s/spr+1d0/4*mtp**2-1
     & d0/4*mtp**2*s/spr

      iz1up=
     & +1d0/(mup**2/s+1d0/4*sinth5**2*sqrtlsupdn**2/s**2)/(s-spr)*(1d0/2
     & -1d0/2*mdn**2/s+1d0/2*mup**2/s+1d0/2*costh5*sqrtlsupdn/s)

      iz2dn=
     & +1d0/(mdn**2/s+1d0/4*sinth5**2*sqrtlsupdn**2/s**2)/(s-spr)*(1d0/2
     & +1d0/2*mdn**2/s-1d0/2*mup**2/s-1d0/2*costh5*sqrtlsupdn/s)

      iz3bt=
     & +1d0/(mbt**2/spr+1d0/4*sinth4**2*sqrtlsprtpbt**2/spr**2)/(s-spr)*
     & (1d0/2+1d0/2*mbt**2/spr-1d0/2*mtp**2/spr-1d0/2*costh4*sqrtlsprtpb
     & t/spr)

      iz4tp=
     & +1d0/(mtp**2/spr+1d0/4*sinth4**2*sqrtlsprtpbt**2/spr**2)/(s-spr)*
     & (1d0/2-1d0/2*mbt**2/spr+1d0/2*mtp**2/spr+1d0/2*costh4*sqrtlsprtpb
     & t/spr)

      hardisr=
     & +iz1up**2*theta_hard(s,spr,omega)*sqrtlsprtpbt*propwspr*propwsprc
     & /pi**3*alphas*gf**2*mw**4*mup**2/s**2/spr*(s-spr)*cf*(-1d0/4*p1p3
     & *p2p4+1d0/4*p2p4*p3p5)
     & +iz1up*iz2dn*theta_hard(s,spr,omega)*sqrtlsprtpbt*propwspr*propws
     & prc/pi**3*alphas*gf**2*mw**4/s**2/spr*(s-spr)*cf*(-1d0/2*p1p2*p1p
     & 3*p2p4+1d0/4*p1p2*p1p3*p4p5+1d0/4*p1p2*p2p4*p3p5)
     & +iz1up*sqrtlsprtpbt*propwspr*propwsprc/pi**3*alphas*gf**2*mw**4/s
     & **2/spr*(s-spr)*cf*(1d0/8*p1p3*p1p4-1d0/8*p1p3*p2p4+1d0/8*p2p4*p3
     & p5)
     & +iz2dn**2*theta_hard(s,spr,omega)*sqrtlsprtpbt*propwspr*propwsprc
     & /pi**3*alphas*gf**2*mw**4*mdn**2/s**2/spr*(s-spr)*cf*(-1d0/4*p1p3
     & *p2p4+1d0/4*p1p3*p4p5)
     & +iz2dn*sqrtlsprtpbt*propwspr*propwsprc/pi**3*alphas*gf**2*mw**4/s
     & **2/spr*(s-spr)*cf*(-1d0/8*p1p3*p2p4+1d0/8*p1p3*p4p5+1d0/8*p2p3*p
     & 2p4)

      hardfsr=
     & +iz3bt**2*theta_hard(s,spr,omega)*sqrtlsprtpbt*propws*propwsc/pi*
     & *3*alphas*gf**2*mw**4/s**2/spr*(s-spr)*cf*(-1d0/4*p1p3*p2p4*mbt**
     & 2-1d0/4*p1p5*p2p4*mbt**2)
     & +iz3bt*iz4tp*theta_hard(s,spr,omega)*sqrtlsprtpbt*propws*propwsc/
     & pi**3*alphas*gf**2*mw**4/s**2/spr*(s-spr)*cf*(-1d0/2*p1p3*p2p4*p3
     & p4-1d0/4*p1p3*p2p5*p3p4-1d0/4*p1p5*p2p4*p3p4)
     & +iz3bt*sqrtlsprtpbt*propws*propwsc/pi**3*alphas*gf**2*mw**4/s**2/
     & spr*(s-spr)*cf*(-1d0/8*p1p3*p2p3+1d0/8*p1p3*p2p4+1d0/8*p1p5*p2p4)
     & 
     & +iz4tp**2*theta_hard(s,spr,omega)*sqrtlsprtpbt*propws*propwsc/pi*
     & *3*alphas*gf**2*mw**4/s**2/spr*(s-spr)*cf*(-1d0/4*p1p3*p2p4*mtp**
     & 2-1d0/4*p1p3*p2p5*mtp**2)
     & +iz4tp*sqrtlsprtpbt*propws*propwsc/pi**3*alphas*gf**2*mw**4/s**2/
     & spr*(s-spr)*cf*(1d0/8*p1p3*p2p4+1d0/8*p1p3*p2p5-1d0/8*p1p4*p2p4)

      hard = hardisr+hardfsr
      hard = hard*conhc

      return
      end
