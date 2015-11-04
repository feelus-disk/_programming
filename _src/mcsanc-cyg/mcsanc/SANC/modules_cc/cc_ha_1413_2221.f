************************************************************************
* sanc_cc_v1.40 package.
************************************************************************
* File (cc_ha_1413_2221.f) is created on Tue Aug  9 22:48:20 MSD 2011.
************************************************************************
* This is the FORTRAN module (cc_ha_1413_2221) to calculate differential
* hard photon Bremsstrahlung for the anti-dn + up -> anti-bt + tp process.
*
* It is produced by s2n package of SANC (v1.10) Project.
* Copyright (C), SANC Project Team, 2002-2011.
*
* http://sanc.jinr.ru/
* http://pcphsanc.cern.ch/
* E-mail: <sanc@jinr.ru>
************************************************************************
      subroutine cc_ha_1413_2221 (s,spr,ph4,costh4,costh5,hard)
      implicit none!
      include 's2n_declare.h'

      real*8 sq,sqspr,qw
      real*8 p1p2,p1p3,p1p4,p1p5,p2p3,p2p4,p2p5,p3p4,p3p5,p4p5
      real*8 ph4,cosph4,sinph4,costh4,sinth4,costh5,sinth5
      real*8 sqrtlsupdn,isqrtlsupdn,sqrtlsprbttp,isqrtlsprbttp
      complex*16 propwspr,propiwspr,propwsprc,propws,propiws,propwsc
      real*8 iz1dn,iz2up,iz3tp,iz4bt

      cmw2 = mw2
      qw = 1d0

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

      sqrtlsupdn = sqrt(s**2-2d0*s*(rupm2+rdnm2)+(rupm2-rdnm2)**2)
      isqrtlsupdn = 1d0/sqrtlsupdn
      sqrtlsprbttp = sqrt(spr**2-2d0*spr*(rbtm2+rtpm2)+(rbtm2-rtpm2)**2)
      isqrtlsprbttp = 1d0/sqrtlsprbttp

      p1p2=
     & -1d0/2*s

      p1p3=
     & +sinph4*sinth4*sinth5*(-1d0/4/sq/sqspr*sqrtlsupdn*sqrtlsprbttp)
     & +costh4*costh5*(1d0/8*sqrtlsupdn*sqrtlsprbttp/s+1d0/8*sqrtlsupdn*
     & sqrtlsprbttp/spr)
     & +costh4*(1d0/8*sqrtlsprbttp-1d0/8*sqrtlsprbttp*s/spr)
     & +costh5*(1d0/8*sqrtlsupdn-1d0/8*sqrtlsupdn/s*spr+1d0/8*sqrtlsupdn
     & *mbt**2/s-1d0/8*sqrtlsupdn*mbt**2/spr-1d0/8*sqrtlsupdn*mtp**2/s+1
     & d0/8*sqrtlsupdn*mtp**2/spr)
     & -1d0/8*spr-1d0/8*s+1d0/8*mbt**2+1d0/8*mbt**2*s/spr-1d0/8*mtp**2-1
     & d0/8*mtp**2*s/spr

      p1p4=
     & +sinph4*sinth4*sinth5*(1d0/4/sq/sqspr*sqrtlsupdn*sqrtlsprbttp)
     & +costh4*costh5*(-1d0/8*sqrtlsupdn*sqrtlsprbttp/s-1d0/8*sqrtlsupdn
     & *sqrtlsprbttp/spr)
     & +costh4*(-1d0/8*sqrtlsprbttp+1d0/8*sqrtlsprbttp*s/spr)
     & +costh5*(1d0/8*sqrtlsupdn-1d0/8*sqrtlsupdn/s*spr-1d0/8*sqrtlsupdn
     & *mbt**2/s+1d0/8*sqrtlsupdn*mbt**2/spr+1d0/8*sqrtlsupdn*mtp**2/s-1
     & d0/8*sqrtlsupdn*mtp**2/spr)
     & -1d0/8*spr-1d0/8*s-1d0/8*mbt**2-1d0/8*mbt**2*s/spr+1d0/8*mtp**2+1
     & d0/8*mtp**2*s/spr

      p1p5=
     & +costh5*(-1d0/4*sqrtlsupdn+1d0/4*sqrtlsupdn/s*spr)
     & +1d0/4*spr-1d0/4*s

      p2p3=
     & +sinph4*sinth4*sinth5*(1d0/4/sq/sqspr*sqrtlsupdn*sqrtlsprbttp)
     & +costh4*costh5*(-1d0/8*sqrtlsupdn*sqrtlsprbttp/s-1d0/8*sqrtlsupdn
     & *sqrtlsprbttp/spr)
     & +costh4*(1d0/8*sqrtlsprbttp-1d0/8*sqrtlsprbttp*s/spr)
     & +costh5*(-1d0/8*sqrtlsupdn+1d0/8*sqrtlsupdn/s*spr-1d0/8*sqrtlsupd
     & n*mbt**2/s+1d0/8*sqrtlsupdn*mbt**2/spr+1d0/8*sqrtlsupdn*mtp**2/s-
     & 1d0/8*sqrtlsupdn*mtp**2/spr)
     & -1d0/8*spr-1d0/8*s+1d0/8*mbt**2+1d0/8*mbt**2*s/spr-1d0/8*mtp**2-1
     & d0/8*mtp**2*s/spr

      p2p4=
     & +sinph4*sinth4*sinth5*(-1d0/4/sq/sqspr*sqrtlsupdn*sqrtlsprbttp)
     & +costh4*costh5*(1d0/8*sqrtlsupdn*sqrtlsprbttp/s+1d0/8*sqrtlsupdn*
     & sqrtlsprbttp/spr)
     & +costh4*(-1d0/8*sqrtlsprbttp+1d0/8*sqrtlsprbttp*s/spr)
     & +costh5*(-1d0/8*sqrtlsupdn+1d0/8*sqrtlsupdn/s*spr+1d0/8*sqrtlsupd
     & n*mbt**2/s-1d0/8*sqrtlsupdn*mbt**2/spr-1d0/8*sqrtlsupdn*mtp**2/s+
     & 1d0/8*sqrtlsupdn*mtp**2/spr)
     & -1d0/8*spr-1d0/8*s-1d0/8*mbt**2-1d0/8*mbt**2*s/spr+1d0/8*mtp**2+1
     & d0/8*mtp**2*s/spr

      p2p5=
     & +costh5*(1d0/4*sqrtlsupdn-1d0/4*sqrtlsupdn/s*spr)
     & +1d0/4*spr-1d0/4*s

      p3p4=
     & -1d0/2*spr+1d0/2*mbt**2+1d0/2*mtp**2

      p3p5=
     & +costh4*(1d0/4*sqrtlsprbttp-1d0/4*sqrtlsprbttp*s/spr)
     & +1d0/4*spr-1d0/4*s-1d0/4*mbt**2+1d0/4*mbt**2*s/spr+1d0/4*mtp**2-1
     & d0/4*mtp**2*s/spr

      p4p5=
     & +costh4*(-1d0/4*sqrtlsprbttp+1d0/4*sqrtlsprbttp*s/spr)
     & +1d0/4*spr-1d0/4*s+1d0/4*mbt**2-1d0/4*mbt**2*s/spr-1d0/4*mtp**2+1
     & d0/4*mtp**2*s/spr

      iz1dn=
     & +1d0/(mdn**2/s+1d0/4*sinth5**2*sqrtlsupdn**2/s**2)/(s-spr)*(1d0/2
     & +1d0/2*mdn**2/s-1d0/2*mup**2/s-1d0/2*costh5*sqrtlsupdn/s)

      iz2up=
     & +1d0/(mup**2/s+1d0/4*sinth5**2*sqrtlsupdn**2/s**2)/(s-spr)*(1d0/2
     & -1d0/2*mdn**2/s+1d0/2*mup**2/s+1d0/2*costh5*sqrtlsupdn/s)

      iz3tp=
     & +1d0/(mtp**2/spr+1d0/4*sinth4**2*sqrtlsprbttp**2/spr**2)/(s-spr)*
     & (1d0/2-1d0/2*mbt**2/spr+1d0/2*mtp**2/spr-1d0/2*costh4*sqrtlsprbtt
     & p/spr)

      iz4bt=
     & +1d0/(mbt**2/spr+1d0/4*sinth4**2*sqrtlsprbttp**2/spr**2)/(s-spr)*
     & (1d0/2+1d0/2*mbt**2/spr-1d0/2*mtp**2/spr+1d0/2*costh4*sqrtlsprbtt
     & p/spr)

      hardisr=
     & +iz1dn**2*theta_hard(s,spr,omega)*propwspr*propwsprc*sqrtlsprbttp
     & /pi**3*alpha*gf**2*qdn**2*mw**4*mdn**2/s**2/spr*(s-spr)*(-1d0/4*p
     & 1p3*p2p4+1d0/4*p2p4*p3p5)
     & +iz1dn*iz2up*theta_hard(s,spr,omega)*propwspr*propwsprc*sqrtlsprb
     & ttp/pi**3*alpha*gf**2*qup*qdn*mw**4/s/spr*(s-spr)*(1d0/4*p1p3*p2p
     & 4-1d0/8*p1p3*p4p5-1d0/8*p2p4*p3p5)
     & +iz1dn*propwspr*propwsprc*sqrtlsprbttp/pi**3*alpha*gf**2*qdn**2*m
     & w**4/s**2/spr*(s-spr)*(1d0/8*p2p4*p3p5)
     & +iz1dn*propwspr*propwsprc*sqrtlsprbttp/pi**3*alpha*gf**2*qup*qdn*
     & mw**4/s**2/spr*(s-spr)*(1d0/8*p1p3*p1p4-1d0/8*p1p3*p2p4)
     & +iz1dn*propwspr*propwsprc*sqrtlsprbttp/pi**3*alpha*gf**2*qw*qdn*m
     & w**4/s**2/spr*(1d0/4*p1p3*p1p4*p2p5)
     & +iz1dn*propwspr*propwsprc*sqrtlsprbttp/pi**3*alpha*gf**2*qw*qdn*m
     & w**4/s**2/spr*(s-spr)*(1d0/8*p1p3*p2p4)
     & +iz1dn*propwspr*propwsprc*sqrtlsprbttp/pi**3*alpha*gf**2*qw*qdn*m
     & w**4/s/spr*(-1d0/4*p1p3*p2p4+1d0/8*p1p3*p4p5+1d0/8*p2p4*p3p5)
     & +iz2up**2*theta_hard(s,spr,omega)*propwspr*propwsprc*sqrtlsprbttp
     & /pi**3*alpha*gf**2*qup**2*mw**4*mup**2/s**2/spr*(s-spr)*(-1d0/4*p
     & 1p3*p2p4+1d0/4*p1p3*p4p5)
     & +iz2up*propwspr*propwsprc*sqrtlsprbttp/pi**3*alpha*gf**2*qup*qdn*
     & mw**4/s**2/spr*(s-spr)*(-1d0/8*p1p3*p2p4+1d0/8*p2p3*p2p4)
     & +iz2up*propwspr*propwsprc*sqrtlsprbttp/pi**3*alpha*gf**2*qup**2*m
     & w**4/s**2/spr*(s-spr)*(1d0/8*p1p3*p4p5)
     & +iz2up*propwspr*propwsprc*sqrtlsprbttp/pi**3*alpha*gf**2*qw*qup*m
     & w**4/s**2/spr*(-1d0/4*p1p5*p2p3*p2p4)
     & +iz2up*propwspr*propwsprc*sqrtlsprbttp/pi**3*alpha*gf**2*qw*qup*m
     & w**4/s**2/spr*(s-spr)*(-1d0/8*p1p3*p2p4)
     & +iz2up*propwspr*propwsprc*sqrtlsprbttp/pi**3*alpha*gf**2*qw*qup*m
     & w**4/s/spr*(1d0/4*p1p3*p2p4-1d0/8*p1p3*p4p5-1d0/8*p2p4*p3p5)
     & +propwspr*propwsprc*sqrtlsprbttp/pi**3*alpha*gf**2*qw*qdn*mw**4/s
     & **2/spr*(-1d0/8*p1p3*p2p4+1d0/8*p2p4*p3p5-1d0/16*p2p4*mbt**2+1d0/
     & 16*p2p4*mtp**2)
     & +propwspr*propwsprc*sqrtlsprbttp/pi**3*alpha*gf**2*qw*qdn*mw**4/s
     & **2*(1d0/16*p2p4)
     & +propwspr*propwsprc*sqrtlsprbttp/pi**3*alpha*gf**2*qw*qup*mw**4/s
     & **2/spr*(1d0/8*p1p3*p2p4-1d0/8*p1p3*p4p5-1d0/16*p1p3*mbt**2+1d0/1
     & 6*p1p3*mtp**2)
     & +propwspr*propwsprc*sqrtlsprbttp/pi**3*alpha*gf**2*qw*qup*mw**4/s
     & **2*(-1d0/16*p1p3)
     & +propwspr*propwsprc*sqrtlsprbttp/pi**3*alpha*gf**2*qw**2*mw**4/s*
     & *2/spr/(s-spr)*(-1d0/8*p1p3*p2p5*mbt**2+1d0/8*p1p3*p2p5*mtp**2+1d
     & 0/8*p1p5*p2p4*mbt**2-1d0/8*p1p5*p2p4*mtp**2)
     & +propwspr*propwsprc*sqrtlsprbttp/pi**3*alpha*gf**2*qw**2*mw**4/s*
     & *2/(s-spr)*(-1d0/8*p1p3*p2p5-1d0/8*p1p5*p2p4)
     & +propwspr*propwsprc*sqrtlsprbttp/pi**3*alpha*gf**2*qw**2*mw**4/s/
     & spr/(s-spr)*(-1d0/4*p1p3*p2p4+1d0/8*p1p3*p4p5+1d0/8*p2p4*p3p5)

      hardfsr=
     & +iz3tp**2*theta_hard(s,spr,omega)*propws*propwsc*sqrtlsprbttp/pi*
     & *3*alpha*gf**2*qtp**2*mw**4/s**2/spr*(s-spr)*(-1d0/4*p1p3*p2p4*mt
     & p**2-1d0/4*p1p5*p2p4*mtp**2)
     & +iz3tp*iz4bt*theta_hard(s,spr,omega)*propws*propwsc*sqrtlsprbttp/
     & pi**3*alpha*gf**2*qtp*qbt*mw**4/s**2/spr*(s-spr)*(-1d0/4*p1p3*p2p
     & 4*mbt**2-1d0/4*p1p3*p2p4*mtp**2-1d0/8*p1p3*p2p5*mbt**2-1d0/8*p1p3
     & *p2p5*mtp**2-1d0/8*p1p5*p2p4*mbt**2-1d0/8*p1p5*p2p4*mtp**2)
     & +iz3tp*iz4bt*theta_hard(s,spr,omega)*propws*propwsc*sqrtlsprbttp/
     & pi**3*alpha*gf**2*qtp*qbt*mw**4/s**2*(s-spr)*(1d0/4*p1p3*p2p4+1d0
     & /8*p1p3*p2p5+1d0/8*p1p5*p2p4)
     & +iz3tp*propws*propwsc*sqrtlsprbttp/pi**3*alpha*gf**2*qtp*qbt*mw**
     & 4/s**2/spr*(s-spr)*(-1d0/8*p1p3*p2p3+1d0/8*p1p3*p2p4)
     & +iz3tp*propws*propwsc*sqrtlsprbttp/pi**3*alpha*gf**2*qtp**2*mw**4
     & /s**2/spr*(s-spr)*(1d0/8*p1p5*p2p4)
     & +iz3tp*propws*propwsc*sqrtlsprbttp/pi**3*alpha*gf**2*qw*qtp*mw**4
     & /s**2/spr*(1d0/4*p1p3*p2p3*p4p5-1d0/4*p1p3*p2p4*mbt**2+1d0/4*p1p3
     & *p2p4*mtp**2-1d0/8*p1p3*p2p5*mbt**2-1d0/8*p1p3*p2p5*mtp**2-1d0/8*
     & p1p5*p2p4*mbt**2+3d0/8*p1p5*p2p4*mtp**2)
     & +iz3tp*propws*propwsc*sqrtlsprbttp/pi**3*alpha*gf**2*qw*qtp*mw**4
     & /s**2/spr*(s-spr)*(1d0/8*p1p3*p2p4)
     & +iz3tp*propws*propwsc*sqrtlsprbttp/pi**3*alpha*gf**2*qw*qtp*mw**4
     & /s**2*(1d0/4*p1p3*p2p4+1d0/8*p1p3*p2p5+1d0/8*p1p5*p2p4)
     & +iz4bt**2*theta_hard(s,spr,omega)*propws*propwsc*sqrtlsprbttp/pi*
     & *3*alpha*gf**2*qbt**2*mw**4/s**2/spr*(s-spr)*(-1d0/4*p1p3*p2p4*mb
     & t**2-1d0/4*p1p3*p2p5*mbt**2)
     & +iz4bt*propws*propwsc*sqrtlsprbttp/pi**3*alpha*gf**2*qbt**2*mw**4
     & /s**2/spr*(s-spr)*(1d0/8*p1p3*p2p5)
     & +iz4bt*propws*propwsc*sqrtlsprbttp/pi**3*alpha*gf**2*qtp*qbt*mw**
     & 4/s**2/spr*(s-spr)*(1d0/8*p1p3*p2p4-1d0/8*p1p4*p2p4)
     & +iz4bt*propws*propwsc*sqrtlsprbttp/pi**3*alpha*gf**2*qw*qbt*mw**4
     & /s**2/spr*(-1d0/4*p1p3*p2p4*mbt**2+1d0/4*p1p3*p2p4*mtp**2-3d0/8*p
     & 1p3*p2p5*mbt**2+1d0/8*p1p3*p2p5*mtp**2-1d0/4*p1p4*p2p4*p3p5+1d0/8
     & *p1p5*p2p4*mbt**2+1d0/8*p1p5*p2p4*mtp**2)
     & +iz4bt*propws*propwsc*sqrtlsprbttp/pi**3*alpha*gf**2*qw*qbt*mw**4
     & /s**2/spr*(s-spr)*(-1d0/8*p1p3*p2p4)
     & +iz4bt*propws*propwsc*sqrtlsprbttp/pi**3*alpha*gf**2*qw*qbt*mw**4
     & /s**2*(-1d0/4*p1p3*p2p4-1d0/8*p1p3*p2p5-1d0/8*p1p5*p2p4)
     & +propws*propwsc*sqrtlsprbttp/pi**3*alpha*gf**2*qw*qbt*mw**4/s**2/
     & spr*(-1d0/8*p1p3*p2p4+1d0/8*p1p3*p2p5)
     & +propws*propwsc*sqrtlsprbttp/pi**3*alpha*gf**2*qw*qbt*mw**4/s/spr
     & *(-1d0/16*p1p3)
     & +propws*propwsc*sqrtlsprbttp/pi**3*alpha*gf**2*qw*qtp*mw**4/s**2/
     & spr*(1d0/8*p1p3*p2p4-1d0/8*p1p5*p2p4)
     & +propws*propwsc*sqrtlsprbttp/pi**3*alpha*gf**2*qw*qtp*mw**4/s/spr
     & *(1d0/16*p2p4)
     & +propws*propwsc*sqrtlsprbttp/pi**3*alpha*gf**2*qw**2*mw**4/s**2/s
     & pr/(s-spr)*(-1d0/8*p1p3*p2p5*mbt**2+1d0/8*p1p3*p2p5*mtp**2+1d0/8*
     & p1p5*p2p4*mbt**2-1d0/8*p1p5*p2p4*mtp**2)
     & +propws*propwsc*sqrtlsprbttp/pi**3*alpha*gf**2*qw**2*mw**4/s**2/(
     & s-spr)*(-1d0/8*p1p3*p2p5-1d0/8*p1p5*p2p4)
     & +propws*propwsc*sqrtlsprbttp/pi**3*alpha*gf**2*qw**2*mw**4/s/spr/
     & (s-spr)*(-1d0/4*p1p3*p2p4+1d0/8*p1p3*p4p5+1d0/8*p2p4*p3p5)

      hardifi=
     & +iz1dn*iz3tp*theta_hard(s,spr,omega)*propwspr*propwsc*sqrtlsprbtt
     & p/pi**3*alpha*gf**2*qdn*qtp*mw**4/s**2/spr*(s-spr)*(1d0/4*p1p3**2
     & *p2p4)
     & +iz1dn*iz3tp*theta_hard(s,spr,omega)*propws*propwsprc*sqrtlsprbtt
     & p/pi**3*alpha*gf**2*qdn*qtp*mw**4/s**2/spr*(s-spr)*(1d0/4*p1p3**2
     & *p2p4)
     & +iz1dn*iz4bt*theta_hard(s,spr,omega)*propwspr*propwsc*sqrtlsprbtt
     & p/pi**3*alpha*gf**2*qdn*qbt*mw**4/s**2/spr*(s-spr)*(-1d0/4*p1p3*p
     & 1p4*p2p4-1d0/8*p1p3*p1p4*p2p5+1d0/8*p1p4*p2p4*p3p5)
     & +iz1dn*iz4bt*theta_hard(s,spr,omega)*propws*propwsprc*sqrtlsprbtt
     & p/pi**3*alpha*gf**2*qdn*qbt*mw**4/s**2/spr*(s-spr)*(-1d0/4*p1p3*p
     & 1p4*p2p4-1d0/8*p1p3*p1p4*p2p5+1d0/8*p1p4*p2p4*p3p5)
     & +iz1dn*propwspr*propwsc*sqrtlsprbttp/pi**3*alpha*gf**2*qdn*qbt*mw
     & **4/s**2/spr*(s-spr)*(-1d0/16*p1p3*p2p4)
     & +iz1dn*propwspr*propwsc*sqrtlsprbttp/pi**3*alpha*gf**2*qdn*qbt*mw
     & **4/s/spr*(s-spr)*(1d0/32*p1p3)
     & +iz1dn*propwspr*propwsc*sqrtlsprbttp/pi**3*alpha*gf**2*qdn*qtp*mw
     & **4/s**2/spr*(s-spr)*(1d0/8*p1p3*p2p4)
     & +iz1dn*propwspr*propwsc*sqrtlsprbttp/pi**3*alpha*gf**2*qw*qdn*mw*
     & *4/s**2/spr*(-1d0/8*p1p3*p1p4*p2p5)
     & +iz1dn*propwspr*propwsc*sqrtlsprbttp/pi**3*alpha*gf**2*qw*qdn*mw*
     & *4/s**2/spr*(s-spr)*(-1d0/16*p1p3*p2p4)
     & +iz1dn*propwspr*propwsc*sqrtlsprbttp/pi**3*alpha*gf**2*qw*qdn*mw*
     & *4/s/spr*(1d0/8*p1p3*p2p4-1d0/16*p1p3*p4p5-1d0/16*p2p4*p3p5)
     & +iz1dn*propws*propwsprc*sqrtlsprbttp/pi**3*alpha*gf**2*qdn*qbt*mw
     & **4/s**2/spr*(s-spr)*(-1d0/16*p1p3*p2p4)
     & +iz1dn*propws*propwsprc*sqrtlsprbttp/pi**3*alpha*gf**2*qdn*qbt*mw
     & **4/s/spr*(s-spr)*(1d0/32*p1p3)
     & +iz1dn*propws*propwsprc*sqrtlsprbttp/pi**3*alpha*gf**2*qdn*qtp*mw
     & **4/s**2/spr*(s-spr)*(1d0/8*p1p3*p2p4)
     & +iz1dn*propws*propwsprc*sqrtlsprbttp/pi**3*alpha*gf**2*qw*qdn*mw*
     & *4/s**2/spr*(-1d0/8*p1p3*p1p4*p2p5)
     & +iz1dn*propws*propwsprc*sqrtlsprbttp/pi**3*alpha*gf**2*qw*qdn*mw*
     & *4/s**2/spr*(s-spr)*(-1d0/16*p1p3*p2p4)
     & +iz1dn*propws*propwsprc*sqrtlsprbttp/pi**3*alpha*gf**2*qw*qdn*mw*
     & *4/s/spr*(1d0/8*p1p3*p2p4-1d0/16*p1p3*p4p5-1d0/16*p2p4*p3p5)
     & +iz2up*iz3tp*theta_hard(s,spr,omega)*propwspr*propwsc*sqrtlsprbtt
     & p/pi**3*alpha*gf**2*qup*qtp*mw**4/s**2/spr*(s-spr)*(-1d0/4*p1p3*p
     & 2p3*p2p4+1d0/8*p1p3*p2p3*p4p5-1d0/8*p1p5*p2p3*p2p4)
     & +iz2up*iz3tp*theta_hard(s,spr,omega)*propws*propwsprc*sqrtlsprbtt
     & p/pi**3*alpha*gf**2*qup*qtp*mw**4/s**2/spr*(s-spr)*(-1d0/4*p1p3*p
     & 2p3*p2p4+1d0/8*p1p3*p2p3*p4p5-1d0/8*p1p5*p2p3*p2p4)
     & +iz2up*iz4bt*theta_hard(s,spr,omega)*propwspr*propwsc*sqrtlsprbtt
     & p/pi**3*alpha*gf**2*qup*qbt*mw**4/s**2/spr*(s-spr)*(1d0/4*p1p3*p2
     & p4**2)
     & +iz2up*iz4bt*theta_hard(s,spr,omega)*propws*propwsprc*sqrtlsprbtt
     & p/pi**3*alpha*gf**2*qup*qbt*mw**4/s**2/spr*(s-spr)*(1d0/4*p1p3*p2
     & p4**2)
     & +iz2up*propwspr*propwsc*sqrtlsprbttp/pi**3*alpha*gf**2*qup*qbt*mw
     & **4/s**2/spr*(s-spr)*(1d0/8*p1p3*p2p4)
     & +iz2up*propwspr*propwsc*sqrtlsprbttp/pi**3*alpha*gf**2*qup*qtp*mw
     & **4/s**2/spr*(s-spr)*(-1d0/16*p1p3*p2p4)
     & +iz2up*propwspr*propwsc*sqrtlsprbttp/pi**3*alpha*gf**2*qup*qtp*mw
     & **4/s/spr*(s-spr)*(1d0/32*p2p4)
     & +iz2up*propwspr*propwsc*sqrtlsprbttp/pi**3*alpha*gf**2*qw*qup*mw*
     & *4/s**2/spr*(1d0/8*p1p5*p2p3*p2p4)
     & +iz2up*propwspr*propwsc*sqrtlsprbttp/pi**3*alpha*gf**2*qw*qup*mw*
     & *4/s**2/spr*(s-spr)*(1d0/16*p1p3*p2p4)
     & +iz2up*propwspr*propwsc*sqrtlsprbttp/pi**3*alpha*gf**2*qw*qup*mw*
     & *4/s/spr*(-1d0/8*p1p3*p2p4+1d0/16*p1p3*p4p5+1d0/16*p2p4*p3p5)
     & +iz2up*propws*propwsprc*sqrtlsprbttp/pi**3*alpha*gf**2*qup*qbt*mw
     & **4/s**2/spr*(s-spr)*(1d0/8*p1p3*p2p4)
     & +iz2up*propws*propwsprc*sqrtlsprbttp/pi**3*alpha*gf**2*qup*qtp*mw
     & **4/s**2/spr*(s-spr)*(-1d0/16*p1p3*p2p4)
     & +iz2up*propws*propwsprc*sqrtlsprbttp/pi**3*alpha*gf**2*qup*qtp*mw
     & **4/s/spr*(s-spr)*(1d0/32*p2p4)
     & +iz2up*propws*propwsprc*sqrtlsprbttp/pi**3*alpha*gf**2*qw*qup*mw*
     & *4/s**2/spr*(1d0/8*p1p5*p2p3*p2p4)
     & +iz2up*propws*propwsprc*sqrtlsprbttp/pi**3*alpha*gf**2*qw*qup*mw*
     & *4/s**2/spr*(s-spr)*(1d0/16*p1p3*p2p4)
     & +iz2up*propws*propwsprc*sqrtlsprbttp/pi**3*alpha*gf**2*qw*qup*mw*
     & *4/s/spr*(-1d0/8*p1p3*p2p4+1d0/16*p1p3*p4p5+1d0/16*p2p4*p3p5)
     & +iz3tp*propwspr*propwsc*sqrtlsprbttp/pi**3*alpha*gf**2*qdn*qtp*mw
     & **4/s**2/spr*(s-spr)*(-1d0/8*p1p3*p2p4+1d0/16*p2p4*mtp**2)
     & +iz3tp*propwspr*propwsc*sqrtlsprbttp/pi**3*alpha*gf**2*qup*qtp*mw
     & **4/s**2/spr*(s-spr)*(1d0/16*p1p3*p2p4+1d0/32*p1p3*mbt**2+1d0/32*
     & p1p3*mtp**2)
     & +iz3tp*propwspr*propwsc*sqrtlsprbttp/pi**3*alpha*gf**2*qup*qtp*mw
     & **4/s**2*(s-spr)*(-1d0/32*p1p3)
     & +iz3tp*propwspr*propwsc*sqrtlsprbttp/pi**3*alpha*gf**2*qw*qtp*mw*
     & *4/s**2/spr*(-1d0/8*p1p3*p2p3*p4p5+1d0/8*p1p3*p2p4*mbt**2-1d0/8*p
     & 1p3*p2p4*mtp**2+1d0/16*p1p3*p2p5*mbt**2+1d0/16*p1p3*p2p5*mtp**2+1
     & d0/16*p1p5*p2p4*mbt**2-3d0/16*p1p5*p2p4*mtp**2)
     & +iz3tp*propwspr*propwsc*sqrtlsprbttp/pi**3*alpha*gf**2*qw*qtp*mw*
     & *4/s**2/spr*(s-spr)*(-1d0/16*p1p3*p2p4)
     & +iz3tp*propwspr*propwsc*sqrtlsprbttp/pi**3*alpha*gf**2*qw*qtp*mw*
     & *4/s**2*(-1d0/8*p1p3*p2p4-1d0/16*p1p3*p2p5-1d0/16*p1p5*p2p4)
     & +iz3tp*propws*propwsprc*sqrtlsprbttp/pi**3*alpha*gf**2*qdn*qtp*mw
     & **4/s**2/spr*(s-spr)*(-1d0/8*p1p3*p2p4+1d0/16*p2p4*mtp**2)
     & +iz3tp*propws*propwsprc*sqrtlsprbttp/pi**3*alpha*gf**2*qup*qtp*mw
     & **4/s**2/spr*(s-spr)*(1d0/16*p1p3*p2p4+1d0/32*p1p3*mbt**2+1d0/32*
     & p1p3*mtp**2)
     & +iz3tp*propws*propwsprc*sqrtlsprbttp/pi**3*alpha*gf**2*qup*qtp*mw
     & **4/s**2*(s-spr)*(-1d0/32*p1p3)
     & +iz3tp*propws*propwsprc*sqrtlsprbttp/pi**3*alpha*gf**2*qw*qtp*mw*
     & *4/s**2/spr*(-1d0/8*p1p3*p2p3*p4p5+1d0/8*p1p3*p2p4*mbt**2-1d0/8*p
     & 1p3*p2p4*mtp**2+1d0/16*p1p3*p2p5*mbt**2+1d0/16*p1p3*p2p5*mtp**2+1
     & d0/16*p1p5*p2p4*mbt**2-3d0/16*p1p5*p2p4*mtp**2)
     & +iz3tp*propws*propwsprc*sqrtlsprbttp/pi**3*alpha*gf**2*qw*qtp*mw*
     & *4/s**2/spr*(s-spr)*(-1d0/16*p1p3*p2p4)
     & +iz3tp*propws*propwsprc*sqrtlsprbttp/pi**3*alpha*gf**2*qw*qtp*mw*
     & *4/s**2*(-1d0/8*p1p3*p2p4-1d0/16*p1p3*p2p5-1d0/16*p1p5*p2p4)
     & +iz4bt*propwspr*propwsc*sqrtlsprbttp/pi**3*alpha*gf**2*qdn*qbt*mw
     & **4/s**2/spr*(s-spr)*(1d0/16*p1p3*p2p4+1d0/32*p2p4*mbt**2+1d0/32*
     & p2p4*mtp**2)
     & +iz4bt*propwspr*propwsc*sqrtlsprbttp/pi**3*alpha*gf**2*qdn*qbt*mw
     & **4/s**2*(s-spr)*(-1d0/32*p2p4)
     & +iz4bt*propwspr*propwsc*sqrtlsprbttp/pi**3*alpha*gf**2*qup*qbt*mw
     & **4/s**2/spr*(s-spr)*(-1d0/8*p1p3*p2p4+1d0/16*p1p3*mbt**2)
     & +iz4bt*propwspr*propwsc*sqrtlsprbttp/pi**3*alpha*gf**2*qw*qbt*mw*
     & *4/s**2/spr*(1d0/8*p1p3*p2p4*mbt**2-1d0/8*p1p3*p2p4*mtp**2+3d0/16
     & *p1p3*p2p5*mbt**2-1d0/16*p1p3*p2p5*mtp**2+1d0/8*p1p4*p2p4*p3p5-1d
     & 0/16*p1p5*p2p4*mbt**2-1d0/16*p1p5*p2p4*mtp**2)
     & +iz4bt*propwspr*propwsc*sqrtlsprbttp/pi**3*alpha*gf**2*qw*qbt*mw*
     & *4/s**2/spr*(s-spr)*(1d0/16*p1p3*p2p4)
     & +iz4bt*propwspr*propwsc*sqrtlsprbttp/pi**3*alpha*gf**2*qw*qbt*mw*
     & *4/s**2*(1d0/8*p1p3*p2p4+1d0/16*p1p3*p2p5+1d0/16*p1p5*p2p4)
     & +iz4bt*propws*propwsprc*sqrtlsprbttp/pi**3*alpha*gf**2*qdn*qbt*mw
     & **4/s**2/spr*(s-spr)*(1d0/16*p1p3*p2p4+1d0/32*p2p4*mbt**2+1d0/32*
     & p2p4*mtp**2)
     & +iz4bt*propws*propwsprc*sqrtlsprbttp/pi**3*alpha*gf**2*qdn*qbt*mw
     & **4/s**2*(s-spr)*(-1d0/32*p2p4)
     & +iz4bt*propws*propwsprc*sqrtlsprbttp/pi**3*alpha*gf**2*qup*qbt*mw
     & **4/s**2/spr*(s-spr)*(-1d0/8*p1p3*p2p4+1d0/16*p1p3*mbt**2)
     & +iz4bt*propws*propwsprc*sqrtlsprbttp/pi**3*alpha*gf**2*qw*qbt*mw*
     & *4/s**2/spr*(1d0/8*p1p3*p2p4*mbt**2-1d0/8*p1p3*p2p4*mtp**2+3d0/16
     & *p1p3*p2p5*mbt**2-1d0/16*p1p3*p2p5*mtp**2+1d0/8*p1p4*p2p4*p3p5-1d
     & 0/16*p1p5*p2p4*mbt**2-1d0/16*p1p5*p2p4*mtp**2)
     & +iz4bt*propws*propwsprc*sqrtlsprbttp/pi**3*alpha*gf**2*qw*qbt*mw*
     & *4/s**2/spr*(s-spr)*(1d0/16*p1p3*p2p4)
     & +iz4bt*propws*propwsprc*sqrtlsprbttp/pi**3*alpha*gf**2*qw*qbt*mw*
     & *4/s**2*(1d0/8*p1p3*p2p4+1d0/16*p1p3*p2p5+1d0/16*p1p5*p2p4)
     & +propwspr*propwsc*sqrtlsprbttp/pi**3*alpha*gf**2*qdn*qtp*mw**4/s*
     & *2/spr*(s-spr)*(-1d0/16*p2p4)
     & +propwspr*propwsc*sqrtlsprbttp/pi**3*alpha*gf**2*qup*qbt*mw**4/s*
     & *2/spr*(s-spr)*(-1d0/16*p1p3)
     & +propwspr*propwsc*sqrtlsprbttp/pi**3*alpha*gf**2*qw*qbt*mw**4/s**
     & 2/spr*(1d0/16*p1p3*p2p4-1d0/16*p1p3*p2p5)
     & +propwspr*propwsc*sqrtlsprbttp/pi**3*alpha*gf**2*qw*qbt*mw**4/s/s
     & pr*(1d0/32*p1p3)
     & +propwspr*propwsc*sqrtlsprbttp/pi**3*alpha*gf**2*qw*qtp*mw**4/s**
     & 2/spr*(-1d0/16*p1p3*p2p4+1d0/16*p1p5*p2p4)
     & +propwspr*propwsc*sqrtlsprbttp/pi**3*alpha*gf**2*qw*qtp*mw**4/s/s
     & pr*(-1d0/32*p2p4)
     & +propwspr*propwsc*sqrtlsprbttp/pi**3*alpha*gf**2*qw*qdn*mw**4/s**
     & 2/spr*(1d0/16*p1p3*p2p4-1d0/16*p2p4*p3p5+1d0/32*p2p4*mbt**2-1d0/3
     & 2*p2p4*mtp**2)
     & +propwspr*propwsc*sqrtlsprbttp/pi**3*alpha*gf**2*qw*qdn*mw**4/s**
     & 2*(-1d0/32*p2p4)
     & +propwspr*propwsc*sqrtlsprbttp/pi**3*alpha*gf**2*qw*qup*mw**4/s**
     & 2/spr*(-1d0/16*p1p3*p2p4+1d0/16*p1p3*p4p5+1d0/32*p1p3*mbt**2-1d0/
     & 32*p1p3*mtp**2)
     & +propwspr*propwsc*sqrtlsprbttp/pi**3*alpha*gf**2*qw*qup*mw**4/s**
     & 2*(1d0/32*p1p3)
     & +propwspr*propwsc*sqrtlsprbttp/pi**3*alpha*gf**2*qw**2*mw**4/s**2
     & /spr/(s-spr)*(1d0/8*p1p3*p2p5*mbt**2-1d0/8*p1p3*p2p5*mtp**2-1d0/8
     & *p1p5*p2p4*mbt**2+1d0/8*p1p5*p2p4*mtp**2)
     & +propwspr*propwsc*sqrtlsprbttp/pi**3*alpha*gf**2*qw**2*mw**4/s**2
     & /(s-spr)*(1d0/8*p1p3*p2p5+1d0/8*p1p5*p2p4)
     & +propwspr*propwsc*sqrtlsprbttp/pi**3*alpha*gf**2*qw**2*mw**4/s/sp
     & r/(s-spr)*(1d0/4*p1p3*p2p4-1d0/8*p1p3*p4p5-1d0/8*p2p4*p3p5)
     & +propws*propwsprc*sqrtlsprbttp/pi**3*alpha*gf**2*qdn*qtp*mw**4/s*
     & *2/spr*(s-spr)*(-1d0/16*p2p4)
     & +propws*propwsprc*sqrtlsprbttp/pi**3*alpha*gf**2*qup*qbt*mw**4/s*
     & *2/spr*(s-spr)*(-1d0/16*p1p3)
     & +propws*propwsprc*sqrtlsprbttp/pi**3*alpha*gf**2*qw*qbt*mw**4/s**
     & 2/spr*(1d0/16*p1p3*p2p4-1d0/16*p1p3*p2p5)
     & +propws*propwsprc*sqrtlsprbttp/pi**3*alpha*gf**2*qw*qbt*mw**4/s/s
     & pr*(1d0/32*p1p3)
     & +propws*propwsprc*sqrtlsprbttp/pi**3*alpha*gf**2*qw*qtp*mw**4/s**
     & 2/spr*(-1d0/16*p1p3*p2p4+1d0/16*p1p5*p2p4)
     & +propws*propwsprc*sqrtlsprbttp/pi**3*alpha*gf**2*qw*qtp*mw**4/s/s
     & pr*(-1d0/32*p2p4)
     & +propws*propwsprc*sqrtlsprbttp/pi**3*alpha*gf**2*qw*qdn*mw**4/s**
     & 2/spr*(1d0/16*p1p3*p2p4-1d0/16*p2p4*p3p5+1d0/32*p2p4*mbt**2-1d0/3
     & 2*p2p4*mtp**2)
     & +propws*propwsprc*sqrtlsprbttp/pi**3*alpha*gf**2*qw*qdn*mw**4/s**
     & 2*(-1d0/32*p2p4)
     & +propws*propwsprc*sqrtlsprbttp/pi**3*alpha*gf**2*qw*qup*mw**4/s**
     & 2/spr*(-1d0/16*p1p3*p2p4+1d0/16*p1p3*p4p5+1d0/32*p1p3*mbt**2-1d0/
     & 32*p1p3*mtp**2)
     & +propws*propwsprc*sqrtlsprbttp/pi**3*alpha*gf**2*qw*qup*mw**4/s**
     & 2*(1d0/32*p1p3)
     & +propws*propwsprc*sqrtlsprbttp/pi**3*alpha*gf**2*qw**2*mw**4/s**2
     & /spr/(s-spr)*(1d0/8*p1p3*p2p5*mbt**2-1d0/8*p1p3*p2p5*mtp**2-1d0/8
     & *p1p5*p2p4*mbt**2+1d0/8*p1p5*p2p4*mtp**2)
     & +propws*propwsprc*sqrtlsprbttp/pi**3*alpha*gf**2*qw**2*mw**4/s**2
     & /(s-spr)*(1d0/8*p1p3*p2p5+1d0/8*p1p5*p2p4)
     & +propws*propwsprc*sqrtlsprbttp/pi**3*alpha*gf**2*qw**2*mw**4/s/sp
     & r/(s-spr)*(1d0/4*p1p3*p2p4-1d0/8*p1p3*p4p5-1d0/8*p2p4*p3p5)

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
      endif

      hard = hard*conhc*cfprime

      return
      end
