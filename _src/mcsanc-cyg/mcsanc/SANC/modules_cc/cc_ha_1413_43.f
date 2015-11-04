************************************************************************
* sanc_cc_v1.51 package.
************************************************************************
* File (cc_ha_1413_43.f) is created on Fri Mar 23 13:04:46 MSK 2012.
************************************************************************
* This is the FORTRAN module (cc_ha_1413_43) to calculate differential
* hard photon Bremsstrahlung for the anti-dn + up -> H   + W^+ process.
*
* It is produced by s2n package of SANC (v1.10) Project.
* Copyright (C), SANC Project Team, 2002-2012.
*
* http://sanc.jinr.ru/
* http://pcphsanc.cern.ch/
* E-mail: <sanc@jinr.ru>
************************************************************************
      subroutine cc_ha_1413_43 (s,spr,ph3,costh3,costh5,hard)
      implicit none!
      include 's2n_declare.h'

      real*8 sq,sqspr,qw
      real*8 p1p2,p1p3,p1p4,p1p5,p2p3,p2p4,p2p5,p3p4,p3p5,p4p5
      real*8 ph3,cosph3,sinph3,costh3,sinth3,costh5,sinth5
      real*8 sqrtlsprwh,isqrtlsprwh,sqrtlssprc,isqrtlssprc,sqrtlsdnup,i
     & sqrtlsdnup
      complex*16 propwspr,propiwspr,propwsprc,propws,propiws,propwsc
      real*8 iz1dn,iz2up,iz3w

      cmw2 = mw2
      qw = 1d0

      sq = dsqrt(s)
      sqspr = dsqrt(spr)

      cosph3 = dcos(ph3)
      sinph3 = dsin(ph3)
      sinth3 = dsqrt(1d0-costh3**2)
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

      sqrtlsprwh = sqrt(spr**2-2d0*spr*(rwm2+rhm2)+(rwm2-rhm2)**2)
      isqrtlsprwh = 1d0/sqrtlsprwh
      sqrtlssprc = dabs(s-spr)
      isqrtlssprc = 1d0/sqrtlssprc
      sqrtlsdnup = sqrt(s**2-2d0*s*(rdnm2+rupm2)+(rdnm2-rupm2)**2)
      isqrtlsdnup = 1d0/sqrtlsdnup

      p1p2=
     & -1d0/2*s

      p1p3=
     & +sinph3*sinth3*sinth5*sqrtlsprwh*(-1d0/4/sq/sqspr*s)
     & +costh3*costh5*sqrtlsprwh*(1d0/8+1d0/8*s/spr)
     & +costh3*sqrtlsprwh*(-1d0/8+1d0/8*s/spr)
     & +costh5*(1d0/8*spr-1d0/8*s-1d0/8*mh**2+1d0/8*mh**2*s/spr+1d0/8*mw
     & **2-1d0/8*mw**2*s/spr)
     & -1d0/8*spr-1d0/8*s+1d0/8*mh**2+1d0/8*mh**2*s/spr-1d0/8*mw**2-1d0/
     & 8*mw**2*s/spr

      p1p4=
     & +sinph3*sinth3*sinth5*sqrtlsprwh*(1d0/4/sq/sqspr*s)
     & +costh3*costh5*sqrtlsprwh*(-1d0/8-1d0/8*s/spr)
     & +costh3*sqrtlsprwh*(1d0/8-1d0/8*s/spr)
     & +costh5*(1d0/8*spr-1d0/8*s+1d0/8*mh**2-1d0/8*mh**2*s/spr-1d0/8*mw
     & **2+1d0/8*mw**2*s/spr)
     & -1d0/8*spr-1d0/8*s-1d0/8*mh**2-1d0/8*mh**2*s/spr+1d0/8*mw**2+1d0/
     & 8*mw**2*s/spr

      p1p5=
     & +costh5*sqrtlssprc*(1d0/4)
     & +sqrtlssprc*(-1d0/4)

      p2p3=
     & +sinph3*sinth3*sinth5*sqrtlsprwh*(1d0/4/sq/sqspr*s)
     & +costh3*costh5*sqrtlsprwh*(-1d0/8-1d0/8*s/spr)
     & +costh3*sqrtlsprwh*(-1d0/8+1d0/8*s/spr)
     & +costh5*(-1d0/8*spr+1d0/8*s+1d0/8*mh**2-1d0/8*mh**2*s/spr-1d0/8*m
     & w**2+1d0/8*mw**2*s/spr)
     & -1d0/8*spr-1d0/8*s+1d0/8*mh**2+1d0/8*mh**2*s/spr-1d0/8*mw**2-1d0/
     & 8*mw**2*s/spr

      p2p4=
     & +sinph3*sinth3*sinth5*sqrtlsprwh*(-1d0/4/sq/sqspr*s)
     & +costh3*costh5*sqrtlsprwh*(1d0/8+1d0/8*s/spr)
     & +costh3*sqrtlsprwh*(1d0/8-1d0/8*s/spr)
     & +costh5*(-1d0/8*spr+1d0/8*s-1d0/8*mh**2+1d0/8*mh**2*s/spr+1d0/8*m
     & w**2-1d0/8*mw**2*s/spr)
     & -1d0/8*spr-1d0/8*s-1d0/8*mh**2-1d0/8*mh**2*s/spr+1d0/8*mw**2+1d0/
     & 8*mw**2*s/spr

      p2p5=
     & +costh5*sqrtlssprc*(-1d0/4)
     & +sqrtlssprc*(-1d0/4)

      p3p4=
     & -1d0/2*spr+1d0/2*mh**2+1d0/2*mw**2

      p3p5=
     & +costh3*sqrtlssprc*sqrtlsprwh*(1d0/4/spr)
     & +sqrtlssprc*(-1d0/4+1d0/8*mh**2/spr-1d0/8*mw**2/spr)
     & -1d0/8*mh**2+1d0/8*mh**2*s/spr+1d0/8*mw**2-1d0/8*mw**2*s/spr

      p4p5=
     & +costh3*sqrtlssprc*sqrtlsprwh*(-1d0/4/spr)
     & +sqrtlssprc*(-1d0/4-1d0/8*mh**2/spr+1d0/8*mw**2/spr)
     & +1d0/8*mh**2-1d0/8*mh**2*s/spr-1d0/8*mw**2+1d0/8*mw**2*s/spr

      iz1dn=
     & +1d0/(mdn**2/s+1d0/4*sinth5**2*sqrtlsdnup**2/s**2)/(s-spr)*(1d0/2
     & +1d0/2*mdn**2/s-1d0/2*mup**2/s+1d0/2*costh5*sqrtlsdnup/s)

      iz2up=
     & +1d0/(mup**2/s+1d0/4*sinth5**2*sqrtlsdnup**2/s**2)/(s-spr)*(1d0/2
     & -1d0/2*mdn**2/s+1d0/2*mup**2/s-1d0/2*costh5*sqrtlsdnup/s)

      iz3w=
     & +1d0/(1d0/4-1d0/2*mh**2/spr+1d0/4*mh**4/spr**2+1d0/2*mw**2/spr-1d
     & 0/2*mw**2*mh**2/spr**2+1d0/4*mw**4/spr**2+1d0/4*sinth3**2*sqrtlsp
     & rwh**2/spr**2-1d0/4*sqrtlsprwh**2/spr**2)/(s-spr)*(1d0/2-1d0/2*mh
     & **2/spr+1d0/2*mw**2/spr+1d0/2*costh3*sqrtlsprwh/spr)

      hard=
     & +iz1dn**2*theta_hard(s,spr,omega)*propwspr*propwsprc*sqrtlssprc*s
     & qrtlsprwh/pi**3*alpha*g**4*qdn**2*mdn**2/s**2/spr*(1d0/1536*p1p2*
     & mw**2-1d0/768*p1p3*p2p3+1d0/768*p2p3*p3p5-1d0/1536*p2p5*mw**2)
     & +iz1dn*iz2up*theta_hard(s,spr,omega)*propwspr*propwsprc*sqrtlsspr
     & c*sqrtlsprwh/pi**3*alpha*g**4*qup*qdn/s**2/spr*(-1d0/384*p1p2*p1p
     & 3*p2p3+1d0/768*p1p2*p1p3*p3p5+1d0/768*p1p2*p2p3*p3p5+1d0/768*p1p2
     & **2*mw**2)
     & +iz1dn*iz3w*theta_hard(s,spr,omega)*propwspr*propwsc*sqrtlssprc*s
     & qrtlsprwh/pi**3*alpha*g**4*qdn/s**2/spr*(-1d0/1536*p1p2*p1p3*mw**
     & 2+1d0/3072*p1p3*p2p5*mw**2+1d0/768*p1p3**2*p2p3+1d0/1536*p1p3**2*
     & p2p5)
     & +iz1dn*iz3w*theta_hard(s,spr,omega)*propws*propwsprc*sqrtlssprc*s
     & qrtlsprwh/pi**3*alpha*g**4*qdn/s**2/spr*(-1d0/1536*p1p2*p1p3*mw**
     & 2+1d0/3072*p1p3*p2p5*mw**2+1d0/768*p1p3**2*p2p3+1d0/1536*p1p3**2*
     & p2p5)
     & +iz1dn*propwspr*propwsprc*sqrtlssprc*sqrtlsprwh/pi**3*alpha*g**4*
     & qdn/s**2/spr*(1d0/1536*p1p2*p1p3*p3p5/mw**2+1d0/1536*p1p2*p2p3*p3
     & p5/mw**2-1d0/1536*p1p2*p3p5**2/mw**2-1d0/1536*p1p3*p2p3*p2p5/mw**
     & 2+1d0/1536*p1p3*p2p5*p3p5/mw**2-1d0/1536*p1p3**2*p2p5/mw**2)
     & +iz1dn*propwspr*propwsprc*sqrtlssprc*sqrtlsprwh/pi**3*alpha*g**4*
     & qdn**2/s**2/spr*(1d0/1536*p1p2*p1p3*p3p5/mw**2+1d0/1536*p1p2*p2p3
     & *p3p5/mw**2-1d0/1536*p1p2*p3p5**2/mw**2-1d0/1536*p1p3*p2p3*p2p5/m
     & w**2+1d0/1536*p1p3*p2p5*p3p5/mw**2-1d0/1536*p1p3**2*p2p5/mw**2+1d
     & 0/1536*p2p3*p3p5-1d0/3072*p2p5*mw**2)
     & +iz1dn*propwspr*propwsprc*sqrtlssprc*sqrtlsprwh/pi**3*alpha*g**4*
     & qup*qdn/s**2/spr*(-1d0/1536*p1p2*p1p3*p3p5/mw**2-1d0/1536*p1p2*p2
     & p3*p3p5/mw**2+1d0/1536*p1p2*p3p5**2/mw**2+1d0/1536*p1p2*mw**2+1d0
     & /1536*p1p3*p2p3*p2p5/mw**2-1d0/1536*p1p3*p2p3-1d0/1536*p1p3*p2p5*
     & p3p5/mw**2+1d0/1536*p1p3**2*p2p5/mw**2+1d0/1536*p1p3**2)
     & +iz1dn*propwspr*propwsc*propwsprc*sqrtlssprc*sqrtlsprwh/pi**3*alp
     & ha*g**4*qdn/s**2/spr*(-1d0/768*p1p2*p1p3*p2p3+1d0/1536*p1p2*p1p3*
     & p3p5+1d0/1536*p1p2*p2p3*p3p5-1d0/1536*p1p2*p2p5*mw**2+1d0/1536*p1
     & p2**2*mw**2+1d0/1536*p1p3*p2p3*p2p5-1d0/1536*p1p3**2*p2p5)
     & +iz1dn*propwspr*propwsc*sqrtlssprc*sqrtlsprwh/pi**3*alpha*g**4*qd
     & n/s**2/spr*(1d0/3072*p1p2*p1p3-1d0/6144*p1p2*mw**2+1d0/1536*p1p3*
     & p2p3)
     & +iz1dn*propws*propwspr*propwsprc*sqrtlssprc*sqrtlsprwh/pi**3*alph
     & a*g**4*qdn/s**2/spr*(-1d0/768*p1p2*p1p3*p2p3+1d0/1536*p1p2*p1p3*p
     & 3p5+1d0/1536*p1p2*p2p3*p3p5-1d0/1536*p1p2*p2p5*mw**2+1d0/1536*p1p
     & 2**2*mw**2+1d0/1536*p1p3*p2p3*p2p5-1d0/1536*p1p3**2*p2p5)
     & +iz1dn*propws*propwsprc*sqrtlssprc*sqrtlsprwh/pi**3*alpha*g**4*qd
     & n/s**2/spr*(1d0/3072*p1p2*p1p3-1d0/6144*p1p2*mw**2+1d0/1536*p1p3*
     & p2p3)
     & +iz2up**2*theta_hard(s,spr,omega)*propwspr*propwsprc*sqrtlssprc*s
     & qrtlsprwh/pi**3*alpha*g**4*qup**2*mup**2/s**2/spr*(1d0/1536*p1p2*
     & mw**2-1d0/768*p1p3*p2p3+1d0/768*p1p3*p3p5-1d0/1536*p1p5*mw**2)
     & +iz2up*iz3w*theta_hard(s,spr,omega)*propwspr*propwsc*sqrtlssprc*s
     & qrtlsprwh/pi**3*alpha*g**4*qup/s**2/spr*(1d0/1536*p1p2*p2p3*mw**2
     & -1d0/768*p1p3*p2p3**2-1d0/3072*p1p5*p2p3*mw**2-1d0/1536*p1p5*p2p3
     & **2)
     & +iz2up*iz3w*theta_hard(s,spr,omega)*propws*propwsprc*sqrtlssprc*s
     & qrtlsprwh/pi**3*alpha*g**4*qup/s**2/spr*(1d0/1536*p1p2*p2p3*mw**2
     & -1d0/768*p1p3*p2p3**2-1d0/3072*p1p5*p2p3*mw**2-1d0/1536*p1p5*p2p3
     & **2)
     & +iz2up*propwspr*propwsprc*sqrtlssprc*sqrtlsprwh/pi**3*alpha*g**4*
     & qup/s**2/spr*(-1d0/1536*p1p2*p1p3*p3p5/mw**2-1d0/1536*p1p2*p2p3*p
     & 3p5/mw**2+1d0/1536*p1p2*p3p5**2/mw**2+1d0/1536*p1p3*p1p5*p2p3/mw*
     & *2-1d0/1536*p1p5*p2p3*p3p5/mw**2+1d0/1536*p1p5*p2p3**2/mw**2)
     & +iz2up*propwspr*propwsprc*sqrtlssprc*sqrtlsprwh/pi**3*alpha*g**4*
     & qup*qdn/s**2/spr*(-1d0/1536*p1p2*p1p3*p3p5/mw**2-1d0/1536*p1p2*p2
     & p3*p3p5/mw**2+1d0/1536*p1p2*p3p5**2/mw**2+1d0/1536*p1p2*mw**2+1d0
     & /1536*p1p3*p1p5*p2p3/mw**2-1d0/1536*p1p3*p2p3-1d0/1536*p1p5*p2p3*
     & p3p5/mw**2+1d0/1536*p1p5*p2p3**2/mw**2+1d0/1536*p2p3**2)
     & +iz2up*propwspr*propwsprc*sqrtlssprc*sqrtlsprwh/pi**3*alpha*g**4*
     & qup**2/s**2/spr*(1d0/1536*p1p2*p1p3*p3p5/mw**2+1d0/1536*p1p2*p2p3
     & *p3p5/mw**2-1d0/1536*p1p2*p3p5**2/mw**2-1d0/1536*p1p3*p1p5*p2p3/m
     & w**2+1d0/1536*p1p3*p3p5+1d0/1536*p1p5*p2p3*p3p5/mw**2-1d0/1536*p1
     & p5*p2p3**2/mw**2-1d0/3072*p1p5*mw**2)
     & +iz2up*propwspr*propwsc*propwsprc*sqrtlssprc*sqrtlsprwh/pi**3*alp
     & ha*g**4*qup/s**2/spr*(1d0/768*p1p2*p1p3*p2p3-1d0/1536*p1p2*p1p3*p
     & 3p5+1d0/1536*p1p2*p1p5*mw**2-1d0/1536*p1p2*p2p3*p3p5-1d0/1536*p1p
     & 2**2*mw**2-1d0/1536*p1p3*p1p5*p2p3+1d0/1536*p1p5*p2p3**2)
     & +iz2up*propwspr*propwsc*sqrtlssprc*sqrtlsprwh/pi**3*alpha*g**4*qu
     & p/s**2/spr*(-1d0/3072*p1p2*p2p3+1d0/6144*p1p2*mw**2-1d0/1536*p1p3
     & *p2p3)
     & +iz2up*propws*propwspr*propwsprc*sqrtlssprc*sqrtlsprwh/pi**3*alph
     & a*g**4*qup/s**2/spr*(1d0/768*p1p2*p1p3*p2p3-1d0/1536*p1p2*p1p3*p3
     & p5+1d0/1536*p1p2*p1p5*mw**2-1d0/1536*p1p2*p2p3*p3p5-1d0/1536*p1p2
     & **2*mw**2-1d0/1536*p1p3*p1p5*p2p3+1d0/1536*p1p5*p2p3**2)
     & +iz2up*propws*propwsprc*sqrtlssprc*sqrtlsprwh/pi**3*alpha*g**4*qu
     & p/s**2/spr*(-1d0/3072*p1p2*p2p3+1d0/6144*p1p2*mw**2-1d0/1536*p1p3
     & *p2p3)
     & +iz3w**2*theta_hard(s,spr,omega)*propws*propwsc*sqrtlssprc*sqrtls
     & prwh/pi**3*alpha*g**4/s**2/spr*(1d0/1536*p1p2*mw**4-1d0/768*p1p3*
     & p2p3*mw**2-1d0/768*p1p3*p2p5*mw**2-1d0/768*p1p5*p2p3*mw**2+1d0/76
     & 8*p1p5*p2p5*mw**2)
     & +iz3w*propwspr*propwsc*sqrtlssprc*sqrtlsprwh/pi**3*alpha*g**4/s**
     & 2/spr*(1d0/3072*p1p2*p1p3+1d0/1536*p1p2*p1p5+1d0/3072*p1p2*p2p3+1
     & d0/1536*p1p2*p2p5+1d0/3072*p1p3*p1p5*p2p3/mw**2+1d0/3072*p1p3*p2p
     & 3*p2p5/mw**2+1d0/1536*p1p3*p2p3**2/mw**2-1d0/3072*p1p3*p2p5+1d0/1
     & 536*p1p3**2*p2p3/mw**2+1d0/3072*p1p3**2*p2p5/mw**2-1d0/3072*p1p5*
     & p2p3+1d0/3072*p1p5*p2p3**2/mw**2-1d0/1536*p1p5*p2p5)
     & +iz3w*propwspr*propwsc*sqrtlssprc*sqrtlsprwh/pi**3*alpha*g**4*qdn
     & /s**2/spr*(1d0/3072*p1p2*p1p3+1d0/1536*p1p2*p1p5+1d0/3072*p1p2*p2
     & p3+1d0/1536*p1p2*p2p5+1d0/3072*p1p3*p1p5*p2p3/mw**2+1d0/3072*p1p3
     & *p2p3*p2p5/mw**2-1d0/3072*p1p3*p2p3+1d0/1536*p1p3*p2p3**2/mw**2-1
     & d0/3072*p1p3*p2p5+1d0/1536*p1p3**2*p2p3/mw**2+1d0/3072*p1p3**2*p2
     & p5/mw**2-1d0/3072*p1p5*p2p3+1d0/3072*p1p5*p2p3**2/mw**2-1d0/1536*
     & p1p5*p2p5+1d0/2048*p2p3*mw**2-1d0/3072*p2p5*mw**2)
     & +iz3w*propwspr*propwsc*sqrtlssprc*sqrtlsprwh/pi**3*alpha*g**4*qup
     & /s**2/spr*(-1d0/3072*p1p2*p1p3-1d0/1536*p1p2*p1p5-1d0/3072*p1p2*p
     & 2p3-1d0/1536*p1p2*p2p5-1d0/3072*p1p3*p1p5*p2p3/mw**2-1d0/3072*p1p
     & 3*p2p3*p2p5/mw**2+1d0/3072*p1p3*p2p3-1d0/1536*p1p3*p2p3**2/mw**2+
     & 1d0/3072*p1p3*p2p5-1d0/2048*p1p3*mw**2-1d0/1536*p1p3**2*p2p3/mw**
     & 2-1d0/3072*p1p3**2*p2p5/mw**2+1d0/3072*p1p5*p2p3-1d0/3072*p1p5*p2
     & p3**2/mw**2+1d0/1536*p1p5*p2p5+1d0/3072*p1p5*mw**2)
     & +iz3w*propws*propwspr*propwsc*sqrtlssprc*sqrtlsprwh/pi**3*alpha*g
     & **4/s**2/spr*(1d0/1536*p1p2*p1p3*mw**2+1d0/1536*p1p2*p2p3*mw**2-1
     & d0/1536*p1p3*p1p5*p2p3-1d0/1536*p1p3*p2p3*p2p5-1d0/768*p1p3*p2p3*
     & *2+1d0/1536*p1p3*p2p5*mw**2-1d0/768*p1p3**2*p2p3-1d0/1536*p1p3**2
     & *p2p5+1d0/1536*p1p5*p2p3*mw**2-1d0/1536*p1p5*p2p3**2-1d0/768*p1p5
     & *p2p5*mw**2)
     & +iz3w*propws*propwsprc*sqrtlssprc*sqrtlsprwh/pi**3*alpha*g**4/s**
     & 2/spr*(1d0/3072*p1p2*p1p3+1d0/1536*p1p2*p1p5+1d0/3072*p1p2*p2p3+1
     & d0/1536*p1p2*p2p5+1d0/3072*p1p3*p1p5*p2p3/mw**2+1d0/3072*p1p3*p2p
     & 3*p2p5/mw**2+1d0/1536*p1p3*p2p3**2/mw**2-1d0/3072*p1p3*p2p5+1d0/1
     & 536*p1p3**2*p2p3/mw**2+1d0/3072*p1p3**2*p2p5/mw**2-1d0/3072*p1p5*
     & p2p3+1d0/3072*p1p5*p2p3**2/mw**2-1d0/1536*p1p5*p2p5)
     & +iz3w*propws*propwsprc*sqrtlssprc*sqrtlsprwh/pi**3*alpha*g**4*qdn
     & /s**2/spr*(1d0/3072*p1p2*p1p3+1d0/1536*p1p2*p1p5+1d0/3072*p1p2*p2
     & p3+1d0/1536*p1p2*p2p5+1d0/3072*p1p3*p1p5*p2p3/mw**2+1d0/3072*p1p3
     & *p2p3*p2p5/mw**2-1d0/3072*p1p3*p2p3+1d0/1536*p1p3*p2p3**2/mw**2-1
     & d0/3072*p1p3*p2p5+1d0/1536*p1p3**2*p2p3/mw**2+1d0/3072*p1p3**2*p2
     & p5/mw**2-1d0/3072*p1p5*p2p3+1d0/3072*p1p5*p2p3**2/mw**2-1d0/1536*
     & p1p5*p2p5+1d0/2048*p2p3*mw**2-1d0/3072*p2p5*mw**2)
     & +iz3w*propws*propwsprc*sqrtlssprc*sqrtlsprwh/pi**3*alpha*g**4*qup
     & /s**2/spr*(-1d0/3072*p1p2*p1p3-1d0/1536*p1p2*p1p5-1d0/3072*p1p2*p
     & 2p3-1d0/1536*p1p2*p2p5-1d0/3072*p1p3*p1p5*p2p3/mw**2-1d0/3072*p1p
     & 3*p2p3*p2p5/mw**2+1d0/3072*p1p3*p2p3-1d0/1536*p1p3*p2p3**2/mw**2+
     & 1d0/3072*p1p3*p2p5-1d0/2048*p1p3*mw**2-1d0/1536*p1p3**2*p2p3/mw**
     & 2-1d0/3072*p1p3**2*p2p5/mw**2+1d0/3072*p1p5*p2p3-1d0/3072*p1p5*p2
     & p3**2/mw**2+1d0/1536*p1p5*p2p5+1d0/3072*p1p5*mw**2)
     & +iz3w*propws*propwsc*propwsprc*sqrtlssprc*sqrtlsprwh/pi**3*alpha*
     & g**4/s**2/spr*(1d0/1536*p1p2*p1p3*mw**2+1d0/1536*p1p2*p2p3*mw**2-
     & 1d0/1536*p1p3*p1p5*p2p3-1d0/1536*p1p3*p2p3*p2p5-1d0/768*p1p3*p2p3
     & **2+1d0/1536*p1p3*p2p5*mw**2-1d0/768*p1p3**2*p2p3-1d0/1536*p1p3**
     & 2*p2p5+1d0/1536*p1p5*p2p3*mw**2-1d0/1536*p1p5*p2p3**2-1d0/768*p1p
     & 5*p2p5*mw**2)
     & +iz3w*propws*propwsc*sqrtlssprc*sqrtlsprwh/pi**3*alpha*g**4/s**2/
     & spr*(1d0/768*p1p3*p2p3+1d0/1536*p1p3*p2p5+1d0/1536*p1p5*p2p3)
     & +propwspr*propwsprc*sqrtlssprc*sqrtlsprwh/pi**3*alpha*g**4/s**2/s
     & pr*(-1d0/1536*p1p2*p1p3*p2p3/mw**4+1d0/1536*p1p2*p1p3*p3p5/mw**4-
     & 1d0/3072*p1p2*p1p3**2/mw**4+1d0/1536*p1p2*p1p5/mw**2+1d0/1536*p1p
     & 2*p2p3*p3p5/mw**4-1d0/3072*p1p2*p2p3**2/mw**4+1d0/1536*p1p2*p2p5/
     & mw**2-1d0/3072*p1p2*p3p5**2/mw**4-1d0/1536*p1p2**2/mw**2)
     & +propwspr*propwsprc*sqrtlssprc*sqrtlsprwh/pi**3*alpha*g**4*qdn/s*
     & *2/spr*(-1d0/768*p1p2*p1p3*p2p3/mw**4+1d0/768*p1p2*p1p3*p3p5/mw**
     & 4-1d0/1536*p1p2*p1p3**2/mw**4+1d0/768*p1p2*p1p5/mw**2+1d0/768*p1p
     & 2*p2p3*p3p5/mw**4-1d0/1536*p1p2*p2p3**2/mw**4+1d0/768*p1p2*p2p5/m
     & w**2-1d0/1536*p1p2*p3p5**2/mw**4-1d0/1536*p1p2-1d0/768*p1p2**2/mw
     & **2-1d0/3072*p1p3*p2p3/mw**2+1d0/3072*p2p3*p3p5/mw**2-1d0/3072*p2
     & p3**2/mw**2)
     & +propwspr*propwsprc*sqrtlssprc*sqrtlsprwh/pi**3*alpha*g**4*qdn**2
     & /s**2/spr*(-1d0/1536*p1p2*p1p3*p2p3/mw**4+1d0/1536*p1p2*p1p3*p3p5
     & /mw**4-1d0/3072*p1p2*p1p3**2/mw**4+1d0/1536*p1p2*p1p5/mw**2+1d0/1
     & 536*p1p2*p2p3*p3p5/mw**4-1d0/3072*p1p2*p2p3**2/mw**4+1d0/1536*p1p
     & 2*p2p5/mw**2-1d0/3072*p1p2*p3p5**2/mw**4-1d0/1536*p1p2-1d0/1536*p
     & 1p2**2/mw**2-1d0/3072*p1p3*p2p3/mw**2+1d0/3072*p2p3*p3p5/mw**2-1d
     & 0/3072*p2p3**2/mw**2)
     & +propwspr*propwsprc*sqrtlssprc*sqrtlsprwh/pi**3*alpha*g**4*qup/s*
     & *2/spr*(1d0/768*p1p2*p1p3*p2p3/mw**4-1d0/768*p1p2*p1p3*p3p5/mw**4
     & +1d0/1536*p1p2*p1p3**2/mw**4-1d0/768*p1p2*p1p5/mw**2-1d0/768*p1p2
     & *p2p3*p3p5/mw**4+1d0/1536*p1p2*p2p3**2/mw**4-1d0/768*p1p2*p2p5/mw
     & **2+1d0/1536*p1p2*p3p5**2/mw**4+1d0/1536*p1p2+1d0/768*p1p2**2/mw*
     & *2+1d0/3072*p1p3*p2p3/mw**2-1d0/3072*p1p3*p3p5/mw**2+1d0/3072*p1p
     & 3**2/mw**2)
     & +propwspr*propwsprc*sqrtlssprc*sqrtlsprwh/pi**3*alpha*g**4*qup*qd
     & n/s**2/spr*(1d0/768*p1p2*p1p3*p2p3/mw**4-1d0/768*p1p2*p1p3*p3p5/m
     & w**4+1d0/1536*p1p2*p1p3**2/mw**4-1d0/768*p1p2*p1p5/mw**2-1d0/768*
     & p1p2*p2p3*p3p5/mw**4+1d0/1536*p1p2*p2p3**2/mw**4-1d0/768*p1p2*p2p
     & 5/mw**2+1d0/1536*p1p2*p3p5**2/mw**4+1d0/768*p1p2+1d0/768*p1p2**2/
     & mw**2+1d0/1536*p1p3*p2p3/mw**2-1d0/3072*p1p3*p3p5/mw**2+1d0/3072*
     & p1p3**2/mw**2-1d0/3072*p2p3*p3p5/mw**2+1d0/3072*p2p3**2/mw**2)
     & +propwspr*propwsprc*sqrtlssprc*sqrtlsprwh/pi**3*alpha*g**4*qup**2
     & /s**2/spr*(-1d0/1536*p1p2*p1p3*p2p3/mw**4+1d0/1536*p1p2*p1p3*p3p5
     & /mw**4-1d0/3072*p1p2*p1p3**2/mw**4+1d0/1536*p1p2*p1p5/mw**2+1d0/1
     & 536*p1p2*p2p3*p3p5/mw**4-1d0/3072*p1p2*p2p3**2/mw**4+1d0/1536*p1p
     & 2*p2p5/mw**2-1d0/3072*p1p2*p3p5**2/mw**4-1d0/1536*p1p2-1d0/1536*p
     & 1p2**2/mw**2-1d0/3072*p1p3*p2p3/mw**2+1d0/3072*p1p3*p3p5/mw**2-1d
     & 0/3072*p1p3**2/mw**2)
     & +propwspr*propwsc*propwsprc*sqrtlssprc*sqrtlsprwh/pi**3*alpha*g**
     & 4/s**2/spr*(-1d0/3072*p1p2*p1p3*p3p5/mw**2-1d0/1536*p1p2*p1p5-1d0
     & /3072*p1p2*p2p3*p3p5/mw**2-1d0/1536*p1p2*p2p5+1d0/3072*p1p2*p3p5*
     & *2/mw**2-1d0/3072*p1p3*p1p5*p2p3/mw**2-1d0/3072*p1p3*p2p3*p2p5/mw
     & **2+1d0/3072*p1p3*p2p5*p3p5/mw**2-1d0/3072*p1p3**2*p2p5/mw**2+1d0
     & /3072*p1p5*p2p3*p3p5/mw**2-1d0/3072*p1p5*p2p3**2/mw**2+1d0/1536*p
     & 1p5*p2p5)
     & +propwspr*propwsc*propwsprc*sqrtlssprc*sqrtlsprwh/pi**3*alpha*g**
     & 4*qdn/s**2/spr*(-1d0/3072*p1p2*p1p3*p3p5/mw**2-1d0/1536*p1p2*p1p5
     & -1d0/3072*p1p2*p2p3*p3p5/mw**2-1d0/1536*p1p2*p2p5+1d0/3072*p1p2*p
     & 3p5**2/mw**2-1d0/3072*p1p3*p1p5*p2p3/mw**2-1d0/3072*p1p3*p2p3*p2p
     & 5/mw**2+1d0/3072*p1p3*p2p3+1d0/3072*p1p3*p2p5*p3p5/mw**2-1d0/3072
     & *p1p3**2*p2p5/mw**2+1d0/3072*p1p5*p2p3*p3p5/mw**2-1d0/3072*p1p5*p
     & 2p3**2/mw**2+1d0/1536*p1p5*p2p5-1d0/1536*p2p3*p3p5+1d0/3072*p2p3*
     & *2+1d0/3072*p2p5*mw**2)
     & +propwspr*propwsc*propwsprc*sqrtlssprc*sqrtlsprwh/pi**3*alpha*g**
     & 4*qup/s**2/spr*(1d0/3072*p1p2*p1p3*p3p5/mw**2+1d0/1536*p1p2*p1p5+
     & 1d0/3072*p1p2*p2p3*p3p5/mw**2+1d0/1536*p1p2*p2p5-1d0/3072*p1p2*p3
     & p5**2/mw**2+1d0/3072*p1p3*p1p5*p2p3/mw**2+1d0/3072*p1p3*p2p3*p2p5
     & /mw**2-1d0/3072*p1p3*p2p3-1d0/3072*p1p3*p2p5*p3p5/mw**2+1d0/1536*
     & p1p3*p3p5+1d0/3072*p1p3**2*p2p5/mw**2-1d0/3072*p1p3**2-1d0/3072*p
     & 1p5*p2p3*p3p5/mw**2+1d0/3072*p1p5*p2p3**2/mw**2-1d0/1536*p1p5*p2p
     & 5-1d0/3072*p1p5*mw**2)
     & +propwspr*propwsc*sqrtlssprc*sqrtlsprwh/pi**3*alpha*g**4/s**2/spr
     & *(-1d0/6144*p1p2*p1p3/mw**2-1d0/6144*p1p2*p2p3/mw**2+1d0/6144*p1p
     & 2*p3p5/mw**2+1d0/3072*p1p3*p2p3/mw**2+1d0/6144*p1p3*p2p5/mw**2+1d
     & 0/6144*p1p5*p2p3/mw**2)
     & +propwspr*propwsc*sqrtlssprc*sqrtlsprwh/pi**3*alpha*g**4*qdn/s**2
     & /spr*(-1d0/6144*p1p2*p1p3/mw**2-1d0/6144*p1p2*p2p3/mw**2+1d0/6144
     & *p1p2*p3p5/mw**2+1d0/3072*p1p3*p2p3/mw**2+1d0/6144*p1p3*p2p5/mw**
     & 2+1d0/6144*p1p5*p2p3/mw**2-1d0/3072*p2p3)
     & +propwspr*propwsc*sqrtlssprc*sqrtlsprwh/pi**3*alpha*g**4*qup/s**2
     & /spr*(1d0/6144*p1p2*p1p3/mw**2+1d0/6144*p1p2*p2p3/mw**2-1d0/6144*
     & p1p2*p3p5/mw**2-1d0/3072*p1p3*p2p3/mw**2-1d0/6144*p1p3*p2p5/mw**2
     & +1d0/3072*p1p3-1d0/6144*p1p5*p2p3/mw**2)
     & +propws*propwspr*propwsprc*sqrtlssprc*sqrtlsprwh/pi**3*alpha*g**4
     & /s**2/spr*(-1d0/3072*p1p2*p1p3*p3p5/mw**2-1d0/1536*p1p2*p1p5-1d0/
     & 3072*p1p2*p2p3*p3p5/mw**2-1d0/1536*p1p2*p2p5+1d0/3072*p1p2*p3p5**
     & 2/mw**2-1d0/3072*p1p3*p1p5*p2p3/mw**2-1d0/3072*p1p3*p2p3*p2p5/mw*
     & *2+1d0/3072*p1p3*p2p5*p3p5/mw**2-1d0/3072*p1p3**2*p2p5/mw**2+1d0/
     & 3072*p1p5*p2p3*p3p5/mw**2-1d0/3072*p1p5*p2p3**2/mw**2+1d0/1536*p1
     & p5*p2p5)
     & +propws*propwspr*propwsprc*sqrtlssprc*sqrtlsprwh/pi**3*alpha*g**4
     & *qdn/s**2/spr*(-1d0/3072*p1p2*p1p3*p3p5/mw**2-1d0/1536*p1p2*p1p5-
     & 1d0/3072*p1p2*p2p3*p3p5/mw**2-1d0/1536*p1p2*p2p5+1d0/3072*p1p2*p3
     & p5**2/mw**2-1d0/3072*p1p3*p1p5*p2p3/mw**2-1d0/3072*p1p3*p2p3*p2p5
     & /mw**2+1d0/3072*p1p3*p2p3+1d0/3072*p1p3*p2p5*p3p5/mw**2-1d0/3072*
     & p1p3**2*p2p5/mw**2+1d0/3072*p1p5*p2p3*p3p5/mw**2-1d0/3072*p1p5*p2
     & p3**2/mw**2+1d0/1536*p1p5*p2p5-1d0/1536*p2p3*p3p5+1d0/3072*p2p3**
     & 2+1d0/3072*p2p5*mw**2)
     & +propws*propwspr*propwsprc*sqrtlssprc*sqrtlsprwh/pi**3*alpha*g**4
     & *qup/s**2/spr*(1d0/3072*p1p2*p1p3*p3p5/mw**2+1d0/1536*p1p2*p1p5+1
     & d0/3072*p1p2*p2p3*p3p5/mw**2+1d0/1536*p1p2*p2p5-1d0/3072*p1p2*p3p
     & 5**2/mw**2+1d0/3072*p1p3*p1p5*p2p3/mw**2+1d0/3072*p1p3*p2p3*p2p5/
     & mw**2-1d0/3072*p1p3*p2p3-1d0/3072*p1p3*p2p5*p3p5/mw**2+1d0/1536*p
     & 1p3*p3p5+1d0/3072*p1p3**2*p2p5/mw**2-1d0/3072*p1p3**2-1d0/3072*p1
     & p5*p2p3*p3p5/mw**2+1d0/3072*p1p5*p2p3**2/mw**2-1d0/1536*p1p5*p2p5
     & -1d0/3072*p1p5*mw**2)
     & +propws*propwspr*propwsc*propwsprc*sqrtlssprc*sqrtlsprwh/pi**3*al
     & pha*g**4/s**2/spr*(1d0/384*p1p2*p1p3*p2p3-1d0/768*p1p2*p1p3*p3p5-
     & 1d0/768*p1p2*p2p3*p3p5-1d0/768*p1p2**2*mw**2+1d0/768*p1p3*p1p5*p2
     & p3+1d0/768*p1p3*p2p3*p2p5-1d0/768*p1p3*p2p5*p3p5+1d0/768*p1p3**2*
     & p2p5-1d0/768*p1p5*p2p3*p3p5+1d0/768*p1p5*p2p3**2+1d0/768*p1p5*p2p
     & 5*mw**2)
     & +propws*propwspr*propwsc*sqrtlssprc*sqrtlsprwh/pi**3*alpha*g**4/s
     & **2/spr*(-1d0/3072*p1p2*p1p3-1d0/3072*p1p2*p2p3-1d0/1536*p1p3*p2p
     & 3-1d0/1536*p1p3*p2p5-1d0/1536*p1p5*p2p3)
     & +propws*propwsprc*sqrtlssprc*sqrtlsprwh/pi**3*alpha*g**4/s**2/spr
     & *(-1d0/6144*p1p2*p1p3/mw**2-1d0/6144*p1p2*p2p3/mw**2+1d0/6144*p1p
     & 2*p3p5/mw**2+1d0/3072*p1p3*p2p3/mw**2+1d0/6144*p1p3*p2p5/mw**2+1d
     & 0/6144*p1p5*p2p3/mw**2)
     & +propws*propwsprc*sqrtlssprc*sqrtlsprwh/pi**3*alpha*g**4*qdn/s**2
     & /spr*(-1d0/6144*p1p2*p1p3/mw**2-1d0/6144*p1p2*p2p3/mw**2+1d0/6144
     & *p1p2*p3p5/mw**2+1d0/3072*p1p3*p2p3/mw**2+1d0/6144*p1p3*p2p5/mw**
     & 2+1d0/6144*p1p5*p2p3/mw**2-1d0/3072*p2p3)
     & +propws*propwsprc*sqrtlssprc*sqrtlsprwh/pi**3*alpha*g**4*qup/s**2
     & /spr*(1d0/6144*p1p2*p1p3/mw**2+1d0/6144*p1p2*p2p3/mw**2-1d0/6144*
     & p1p2*p3p5/mw**2-1d0/3072*p1p3*p2p3/mw**2-1d0/6144*p1p3*p2p5/mw**2
     & +1d0/3072*p1p3-1d0/6144*p1p5*p2p3/mw**2)
     & +propws*propwsc*propwsprc*sqrtlssprc*sqrtlsprwh/pi**3*alpha*g**4/
     & s**2/spr*(-1d0/3072*p1p2*p1p3-1d0/3072*p1p2*p2p3-1d0/1536*p1p3*p2
     & p3-1d0/1536*p1p3*p2p5-1d0/1536*p1p5*p2p3)

      hard = hard*conhc*cfprime

      return
      end
