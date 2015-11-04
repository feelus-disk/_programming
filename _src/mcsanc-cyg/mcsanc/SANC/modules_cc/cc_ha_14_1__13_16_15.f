************************************************************************
* sanc_cc_v1.70 package.
************************************************************************
* File (cc_ha_14_1__13_16_15.f) is created on Mon Aug 26 16:37:46 MSK 2013.
************************************************************************
* This is the FORTRAN module (cc_ha_14_1__13_16_15) to calculate
* differential cross-section of the photon induced
* anti-dn + a -> anti-up + mo^+ + mn process.
*
* It is produced by s2n package of SANC (v1.10) Project.
* Copyright (C), SANC Project Team, 2002-2013.
*
* http://sanc.jinr.ru/
* http://pcphsanc.cern.ch/
* E-mail: <sanc@jinr.ru>
************************************************************************
      subroutine cc_ha_14_1__13_16_15 (s,spr,ph4,costh4,costh5,hard)
      implicit none!
      include 's2n_declare.h'

      real*8 sq,sqspr,qw,ps
      real*8 p1p2,p1p3,p1p4,p1p5,p2p3,p2p4,p2p5,p3p4,p3p5,p4p5
      real*8 ph4,cosph4,sinph4,costh4,sinth4,costh5,sinth5
      complex*16 propiwspr,propwspr,propwsprc,propiwps,propwps,propwpsc
      real*8 sqrtlssprup,isqrtlssprup
      real*8 iz1up,iz3mo

      cmw2 = mw2
      qw = 1d0

      sq = dsqrt(s)
      sqspr = dsqrt(spr)

      cosph4 = dcos(ph4)
      sinph4 = dsin(ph4)
      sinth4 = dsqrt(1d0-costh4**2)
      sinth5 = dsqrt(1d0-costh5**2)

      ps = (s-spr)*(1+costh5)/2

      if (irun.eq.0) then
         propiwspr = (cmw2-spr)
      else
         propiwspr = (dcmplx(mw**2,-spr*ww/mw)-spr)
      endif
      propwspr  = 1d0/propiwspr
      propwsprc = dconjg(propwspr)

      propiwps = (mw**2+ps)
      propwps  = 1d0/propiwps
      propwpsc = dconjg(propwps)

      sqrtlssprup = sqrt(s**2-2d0*s*(spr+rupm2)+(spr-rupm2)**2)
      isqrtlssprup = 1d0/sqrtlssprup

      p1p2=
     & +costh5*(1d0/4*spr-1d0/4*s)
     & +1d0/4*spr-1d0/4*s

      p1p3=
     & +costh4*(1d0/4*spr-1d0/4*s-1d0/4*mmo**2+1d0/4*mmo**2*s/spr)
     & +1d0/4*spr-1d0/4*s+1d0/4*mmo**2-1d0/4*mmo**2*s/spr

      p1p4=
     & +costh4*(-1d0/4*spr+1d0/4*s+1d0/4*mmo**2-1d0/4*mmo**2*s/spr)
     & +1d0/4*spr-1d0/4*s-1d0/4*mmo**2+1d0/4*mmo**2*s/spr

      p1p5=
     & +costh5*(-1d0/4*spr+1d0/4*s)
     & +1d0/4*spr-1d0/4*s

      p2p3=
     & +sinph4*sinth4*sinth5*(1d0/4*sq*sqspr-1d0/4*sq*sqspr*mmo**2/spr)
     & +costh4*costh5*(1d0/8*spr+1d0/8*s-1d0/8*mmo**2-1d0/8*mmo**2*s/spr
     & )
     & +costh4*(1d0/8*spr-1d0/8*s-1d0/8*mmo**2+1d0/8*mmo**2*s/spr)
     & +costh5*(-1d0/8*spr+1d0/8*s-1d0/8*mmo**2+1d0/8*mmo**2*s/spr)
     & -1d0/8*spr-1d0/8*s-1d0/8*mmo**2-1d0/8*mmo**2*s/spr

      p2p4=
     & +sinph4*sinth4*sinth5*(-1d0/4*sq*sqspr+1d0/4*sq*sqspr*mmo**2/spr)
     & +costh4*costh5*(-1d0/8*spr-1d0/8*s+1d0/8*mmo**2+1d0/8*mmo**2*s/sp
     & r)
     & +costh4*(-1d0/8*spr+1d0/8*s+1d0/8*mmo**2-1d0/8*mmo**2*s/spr)
     & +costh5*(-1d0/8*spr+1d0/8*s+1d0/8*mmo**2-1d0/8*mmo**2*s/spr)
     & -1d0/8*spr-1d0/8*s+1d0/8*mmo**2+1d0/8*mmo**2*s/spr

      p2p5=
     & -1d0/2*s

      p3p4=
     & -1d0/2*spr+1d0/2*mmo**2

      p3p5=
     & +sinph4*sinth4*sinth5*(-1d0/4*sq*sqspr+1d0/4*sq*sqspr*mmo**2/spr)
     & +costh4*costh5*(-1d0/8*spr-1d0/8*s+1d0/8*mmo**2+1d0/8*mmo**2*s/sp
     & r)
     & +costh4*(1d0/8*spr-1d0/8*s-1d0/8*mmo**2+1d0/8*mmo**2*s/spr)
     & +costh5*(1d0/8*spr-1d0/8*s+1d0/8*mmo**2-1d0/8*mmo**2*s/spr)
     & -1d0/8*spr-1d0/8*s-1d0/8*mmo**2-1d0/8*mmo**2*s/spr

      p4p5=
     & +sinph4*sinth4*sinth5*(1d0/4*sq*sqspr-1d0/4*sq*sqspr*mmo**2/spr)
     & +costh4*costh5*(1d0/8*spr+1d0/8*s-1d0/8*mmo**2-1d0/8*mmo**2*s/spr
     & )
     & +costh4*(-1d0/8*spr+1d0/8*s+1d0/8*mmo**2-1d0/8*mmo**2*s/spr)
     & +costh5*(1d0/8*spr-1d0/8*s-1d0/8*mmo**2+1d0/8*mmo**2*s/spr)
     & -1d0/8*spr-1d0/8*s+1d0/8*mmo**2+1d0/8*mmo**2*s/spr

      iz1up=
     & +1d0/(mup**2/s+1d0/4*sqrtlssprup**2*sinth5**2/s**2)/(s-mdn**2)*(1
     & d0/2-1d0/2/s*spr+1d0/2*mup**2/s+1d0/2*sqrtlssprup*costh5/s)

      iz3mo=
     & +1d0/(1d0/4*spr+1d0/4*s+1d0/4*mmo**2+1d0/4*mmo**2*s/spr+1d0/2*sin
     & ph4*sinth4*sinth5*sq*sqspr-1d0/2*sinph4*sinth4*sinth5*sq*sqspr*mm
     & o**2/spr-1d0/4*costh4*spr+1d0/4*costh4*s+1d0/4*costh4*mmo**2-1d0/
     & 4*costh4*mmo**2*s/spr+1d0/4*costh4*costh5*spr+1d0/4*costh4*costh5
     & *s-1d0/4*costh4*costh5*mmo**2-1d0/4*costh4*costh5*mmo**2*s/spr-1d
     & 0/4*costh5*spr+1d0/4*costh5*s-1d0/4*costh5*mmo**2+1d0/4*costh5*mm
     & o**2*s/spr)*(1)

      hard=
     & +iz1up**2*propwspr*propwsprc/pi**3*alpha*gf**2*qup**2*mw**4*(s-sp
     & r)*(-1d0/4*p1p3*p2p4*mup**2/s**2+1d0/4*p1p3*p2p4*mup**2*mmo**2/s*
     & *2/spr+1d0/4*p2p4*p3p5*mup**2/s**2-1d0/4*p2p4*p3p5*mup**2*mmo**2/
     & s**2/spr)
     & +iz1up*iz3mo*propwspr*propwpsc/pi**3*alpha*gf**2*qup*qmo*mw**4*(s
     & -spr)*(1d0/4*p1p3**2*p2p4/s**2-1d0/4*p1p3**2*p2p4*mmo**2/s**2/spr
     & )
     & +iz1up*iz3mo*propwps*propwsprc/pi**3*alpha*gf**2*qup*qmo*mw**4*(s
     & -spr)*(1d0/4*p1p3**2*p2p4/s**2-1d0/4*p1p3**2*p2p4*mmo**2/s**2/spr
     & )
     & +iz1up*propwspr*propwsprc/pi**3*alpha*gf**2*qup*mw**2*(s-spr)*(-1
     & d0/16*p1p2*p4p5*mmo**2/s**2+1d0/16*p1p2*p4p5*mmo**4/s**2/spr+1d0/
     & 16*p1p4*p2p5*mmo**2/s**2-1d0/16*p1p4*p2p5*mmo**4/s**2/spr)
     & +iz1up*propwspr*propwsprc/pi**3*alpha*gf**2*qup*mw**4*(s-spr)*(-1
     & d0/8*p1p3*p2p4/s**2+1d0/8*p1p3*p2p4*mmo**2/s**2/spr)
     & +iz1up*propwspr*propwsprc/pi**3*alpha*gf**2*qup*qdn*mw**2*(s-spr)
     & *(-1d0/16*p1p2*p4p5*mmo**2/s**2+1d0/16*p1p2*p4p5*mmo**4/s**2/spr+
     & 1d0/16*p1p4*p2p5*mmo**2/s**2-1d0/16*p1p4*p2p5*mmo**4/s**2/spr)
     & +iz1up*propwspr*propwsprc/pi**3*alpha*gf**2*qup*qdn*mw**4*(s-spr)
     & *(-1d0/2*p1p2*p1p3*p2p4/s**3+1d0/2*p1p2*p1p3*p2p4*mmo**2/s**3/spr
     & -1d0/4*p1p2*p1p3*p4p5/s**3+1d0/4*p1p2*p1p3*p4p5*mmo**2/s**3/spr+1
     & d0/4*p1p2*p2p4*p3p5/s**3-1d0/4*p1p2*p2p4*p3p5*mmo**2/s**3/spr-1d0
     & /8*p1p3*p1p4/s**2+1d0/8*p1p3*p1p4*mmo**2/s**2/spr-1d0/8*p1p3*p2p4
     & /s**2+1d0/8*p1p3*p2p4*mmo**2/s**2/spr)
     & +iz1up*propwspr*propwsprc/pi**3*alpha*gf**2*qup**2*mw**2*(s-spr)*
     & (1d0/16*p1p2*p4p5*mmo**2/s**2-1d0/16*p1p2*p4p5*mmo**4/s**2/spr-1d
     & 0/16*p1p4*p2p5*mmo**2/s**2+1d0/16*p1p4*p2p5*mmo**4/s**2/spr)
     & +iz1up*propwspr*propwsprc/pi**3*alpha*gf**2*qup**2*mw**4*(s-spr)*
     & (1d0/8*p2p4*p3p5/s**2-1d0/8*p2p4*p3p5*mmo**2/s**2/spr)
     & +iz1up*propwspr*propwpsc/pi**3*alpha*gf**2*qup*mw**4*(s-spr)*(1d0
     & /16*p1p3*p2p4/s**2-1d0/16*p1p3*p2p4*mmo**2/s**2/spr)
     & +iz1up*propwspr*propwpsc/pi**3*alpha*gf**2*qup*qmo*mw**4*(s-spr)*
     & (1d0/8*p1p3*p2p4/s**2-1d0/8*p1p3*p2p4*mmo**2/s**2/spr)
     & +iz1up*propwspr*propwpsc*propwsprc/pi**3*alpha*gf**2*qup*mw**4*(s
     & -spr)*(-1d0/4*p1p2*p1p3*p2p4/s**2+1d0/4*p1p2*p1p3*p2p4*mmo**2/s**
     & 2/spr-1d0/8*p1p2*p1p3*p4p5/s**2+1d0/8*p1p2*p1p3*p4p5*mmo**2/s**2/
     & spr+1d0/8*p1p2*p2p4*p3p5/s**2-1d0/8*p1p2*p2p4*p3p5*mmo**2/s**2/sp
     & r+1d0/8*p1p3*p1p4*p2p5/s**2-1d0/8*p1p3*p1p4*p2p5*mmo**2/s**2/spr)
     & 
     & +iz1up*propwps*propwspr*propwsprc/pi**3*alpha*gf**2*qup*mw**4*(s-
     & spr)*(-1d0/4*p1p2*p1p3*p2p4/s**2+1d0/4*p1p2*p1p3*p2p4*mmo**2/s**2
     & /spr-1d0/8*p1p2*p1p3*p4p5/s**2+1d0/8*p1p2*p1p3*p4p5*mmo**2/s**2/s
     & pr+1d0/8*p1p2*p2p4*p3p5/s**2-1d0/8*p1p2*p2p4*p3p5*mmo**2/s**2/spr
     & +1d0/8*p1p3*p1p4*p2p5/s**2-1d0/8*p1p3*p1p4*p2p5*mmo**2/s**2/spr)
     & +iz1up*propwps*propwsprc/pi**3*alpha*gf**2*qup*mw**4*(s-spr)*(1d0
     & /16*p1p3*p2p4/s**2-1d0/16*p1p3*p2p4*mmo**2/s**2/spr)
     & +iz1up*propwps*propwsprc/pi**3*alpha*gf**2*qup*qmo*mw**4*(s-spr)*
     & (1d0/8*p1p3*p2p4/s**2-1d0/8*p1p3*p2p4*mmo**2/s**2/spr)
     & +iz3mo**2*propwps*propwpsc/pi**3*alpha*gf**2*qmo**2*mw**4*(s-spr)
     & *(-1d0/4*p1p3*p2p4*mmo**2/s**2+1d0/4*p1p3*p2p4*mmo**4/s**2/spr+1d
     & 0/4*p1p5*p2p4*mmo**2/s**2-1d0/4*p1p5*p2p4*mmo**4/s**2/spr)
     & +iz3mo*propwspr*propwpsc/pi**3*alpha*gf**2*qmo*mw**2*(s-spr)*(1d0
     & /32*p1p2*p3p4*mmo**2/s**2-1d0/32*p1p2*p3p4*mmo**4/s**2/spr-1d0/32
     & *p1p3*p2p4*mmo**2/s**2+1d0/32*p1p3*p2p4*mmo**4/s**2/spr-1d0/32*p1
     & p4*p2p3*mmo**2/s**2+1d0/32*p1p4*p2p3*mmo**4/s**2/spr+1d0/16*p1p5*
     & p2p4*mmo**2/s**2-1d0/16*p1p5*p2p4*mmo**4/s**2/spr)
     & +iz3mo*propwspr*propwpsc/pi**3*alpha*gf**2*qmo*mw**4*(s-spr)*(-1d
     & 0/16*p1p3*p2p4/s**2+1d0/16*p1p3*p2p4*mmo**2/s**2/spr)
     & +iz3mo*propwspr*propwpsc/pi**3*alpha*gf**2*qdn*qmo*mw**2*(s-spr)*
     & (1d0/32*p1p2*p3p4*mmo**2/s**2-1d0/32*p1p2*p3p4*mmo**4/s**2/spr-1d
     & 0/32*p1p3*p2p4*mmo**2/s**2+1d0/32*p1p3*p2p4*mmo**4/s**2/spr-1d0/3
     & 2*p1p4*p2p3*mmo**2/s**2+1d0/32*p1p4*p2p3*mmo**4/s**2/spr+1d0/16*p
     & 1p5*p2p4*mmo**2/s**2-1d0/16*p1p5*p2p4*mmo**4/s**2/spr)
     & +iz3mo*propwspr*propwpsc/pi**3*alpha*gf**2*qdn*qmo*mw**4*(s-spr)*
     & (-1d0/4*p1p3*p2p3*p2p4/s**3+1d0/4*p1p3*p2p3*p2p4*mmo**2/s**3/spr-
     & 1d0/8*p1p3*p2p3*p4p5/s**3+1d0/8*p1p3*p2p3*p4p5*mmo**2/s**3/spr-1d
     & 0/16*p1p3*p2p4/s**2+1d0/16*p1p3*p2p4*mmo**2/s**2/spr-1d0/16*p1p3*
     & p3p4/s**2+1d0/16*p1p3*p3p4*mmo**2/s**2/spr+1d0/8*p1p5*p2p3*p2p4/s
     & **3-1d0/8*p1p5*p2p3*p2p4*mmo**2/s**3/spr)
     & +iz3mo*propwspr*propwpsc/pi**3*alpha*gf**2*qup*qmo*mw**2*(s-spr)*
     & (-1d0/32*p1p2*p3p4*mmo**2/s**2+1d0/32*p1p2*p3p4*mmo**4/s**2/spr+1
     & d0/32*p1p3*p2p4*mmo**2/s**2-1d0/32*p1p3*p2p4*mmo**4/s**2/spr+1d0/
     & 32*p1p4*p2p3*mmo**2/s**2-1d0/32*p1p4*p2p3*mmo**4/s**2/spr-1d0/16*
     & p1p5*p2p4*mmo**2/s**2+1d0/16*p1p5*p2p4*mmo**4/s**2/spr)
     & +iz3mo*propwspr*propwpsc/pi**3*alpha*gf**2*qup*qmo*mw**4*(s-spr)*
     & (1d0/8*p1p3*p2p4/s**2-1d0/8*p1p3*p2p4*mmo**2/s**2/spr+1d0/16*p2p4
     & *mmo**2/s**2-1d0/16*p2p4*mmo**4/s**2/spr)
     & +iz3mo*propwps*propwspr*propwpsc/pi**3*alpha*gf**2*qmo*mw**4*(s-s
     & pr)*(-1d0/8*p1p3*p1p5*p2p4/s**2+1d0/8*p1p3*p1p5*p2p4*mmo**2/s**2/
     & spr-1d0/4*p1p3*p2p3*p2p4/s**2+1d0/4*p1p3*p2p3*p2p4*mmo**2/s**2/sp
     & r-1d0/8*p1p3*p2p3*p4p5/s**2+1d0/8*p1p3*p2p3*p4p5*mmo**2/s**2/spr+
     & 1d0/8*p1p3*p2p5*p3p4/s**2-1d0/8*p1p3*p2p5*p3p4*mmo**2/s**2/spr+1d
     & 0/4*p1p3**2*p2p4/s**2-1d0/4*p1p3**2*p2p4*mmo**2/s**2/spr+1d0/8*p1
     & p5*p2p3*p2p4/s**2-1d0/8*p1p5*p2p3*p2p4*mmo**2/s**2/spr-1d0/8*p1p5
     & *p2p4*mmo**2/s**2+1d0/8*p1p5*p2p4*mmo**4/s**2/spr)
     & +iz3mo*propwps*propwsprc/pi**3*alpha*gf**2*qmo*mw**2*(s-spr)*(1d0
     & /32*p1p2*p3p4*mmo**2/s**2-1d0/32*p1p2*p3p4*mmo**4/s**2/spr-1d0/32
     & *p1p3*p2p4*mmo**2/s**2+1d0/32*p1p3*p2p4*mmo**4/s**2/spr-1d0/32*p1
     & p4*p2p3*mmo**2/s**2+1d0/32*p1p4*p2p3*mmo**4/s**2/spr+1d0/16*p1p5*
     & p2p4*mmo**2/s**2-1d0/16*p1p5*p2p4*mmo**4/s**2/spr)
     & +iz3mo*propwps*propwsprc/pi**3*alpha*gf**2*qmo*mw**4*(s-spr)*(-1d
     & 0/16*p1p3*p2p4/s**2+1d0/16*p1p3*p2p4*mmo**2/s**2/spr)
     & +iz3mo*propwps*propwsprc/pi**3*alpha*gf**2*qdn*qmo*mw**2*(s-spr)*
     & (1d0/32*p1p2*p3p4*mmo**2/s**2-1d0/32*p1p2*p3p4*mmo**4/s**2/spr-1d
     & 0/32*p1p3*p2p4*mmo**2/s**2+1d0/32*p1p3*p2p4*mmo**4/s**2/spr-1d0/3
     & 2*p1p4*p2p3*mmo**2/s**2+1d0/32*p1p4*p2p3*mmo**4/s**2/spr+1d0/16*p
     & 1p5*p2p4*mmo**2/s**2-1d0/16*p1p5*p2p4*mmo**4/s**2/spr)
     & +iz3mo*propwps*propwsprc/pi**3*alpha*gf**2*qdn*qmo*mw**4*(s-spr)*
     & (-1d0/4*p1p3*p2p3*p2p4/s**3+1d0/4*p1p3*p2p3*p2p4*mmo**2/s**3/spr-
     & 1d0/8*p1p3*p2p3*p4p5/s**3+1d0/8*p1p3*p2p3*p4p5*mmo**2/s**3/spr-1d
     & 0/16*p1p3*p2p4/s**2+1d0/16*p1p3*p2p4*mmo**2/s**2/spr-1d0/16*p1p3*
     & p3p4/s**2+1d0/16*p1p3*p3p4*mmo**2/s**2/spr+1d0/8*p1p5*p2p3*p2p4/s
     & **3-1d0/8*p1p5*p2p3*p2p4*mmo**2/s**3/spr)
     & +iz3mo*propwps*propwsprc/pi**3*alpha*gf**2*qup*qmo*mw**2*(s-spr)*
     & (-1d0/32*p1p2*p3p4*mmo**2/s**2+1d0/32*p1p2*p3p4*mmo**4/s**2/spr+1
     & d0/32*p1p3*p2p4*mmo**2/s**2-1d0/32*p1p3*p2p4*mmo**4/s**2/spr+1d0/
     & 32*p1p4*p2p3*mmo**2/s**2-1d0/32*p1p4*p2p3*mmo**4/s**2/spr-1d0/16*
     & p1p5*p2p4*mmo**2/s**2+1d0/16*p1p5*p2p4*mmo**4/s**2/spr)
     & +iz3mo*propwps*propwsprc/pi**3*alpha*gf**2*qup*qmo*mw**4*(s-spr)*
     & (1d0/8*p1p3*p2p4/s**2-1d0/8*p1p3*p2p4*mmo**2/s**2/spr+1d0/16*p2p4
     & *mmo**2/s**2-1d0/16*p2p4*mmo**4/s**2/spr)
     & +iz3mo*propwps*propwpsc/pi**3*alpha*gf**2*qmo*mw**4*(s-spr)*(1d0/
     & 8*p1p3*p2p4/s**2-1d0/8*p1p3*p2p4*mmo**2/s**2/spr)
     & +iz3mo*propwps*propwpsc/pi**3*alpha*gf**2*qmo**2*mw**4*(s-spr)*(1
     & d0/8*p1p5*p2p4/s**2-1d0/8*p1p5*p2p4*mmo**2/s**2/spr)
     & +iz3mo*propwps*propwpsc*propwsprc/pi**3*alpha*gf**2*qmo*mw**4*(s-
     & spr)*(-1d0/8*p1p3*p1p5*p2p4/s**2+1d0/8*p1p3*p1p5*p2p4*mmo**2/s**2
     & /spr-1d0/4*p1p3*p2p3*p2p4/s**2+1d0/4*p1p3*p2p3*p2p4*mmo**2/s**2/s
     & pr-1d0/8*p1p3*p2p3*p4p5/s**2+1d0/8*p1p3*p2p3*p4p5*mmo**2/s**2/spr
     & +1d0/8*p1p3*p2p5*p3p4/s**2-1d0/8*p1p3*p2p5*p3p4*mmo**2/s**2/spr+1
     & d0/4*p1p3**2*p2p4/s**2-1d0/4*p1p3**2*p2p4*mmo**2/s**2/spr+1d0/8*p
     & 1p5*p2p3*p2p4/s**2-1d0/8*p1p5*p2p3*p2p4*mmo**2/s**2/spr-1d0/8*p1p
     & 5*p2p4*mmo**2/s**2+1d0/8*p1p5*p2p4*mmo**4/s**2/spr)
     & +propwspr*propwsprc/pi**3*alpha*gf**2*(s-spr)*(1d0/32*p1p2*p3p4*m
     & mo**2/s**2-1d0/32*p1p2*p3p4*mmo**4/s**2/spr)
     & +propwspr*propwsprc/pi**3*alpha*gf**2*qdn*(s-spr)*(1d0/16*p1p2*p3
     & p4*mmo**2/s**2-1d0/16*p1p2*p3p4*mmo**4/s**2/spr)
     & +propwspr*propwsprc/pi**3*alpha*gf**2*qdn*mw**2*(s-spr)*(-1d0/16*
     & p1p2*p4p5*mmo**2/s**3+1d0/16*p1p2*p4p5*mmo**4/s**3/spr+1d0/32*p1p
     & 4*mmo**2/s**2-1d0/32*p1p4*mmo**4/s**2/spr+1d0/16*p1p5*p2p4*mmo**2
     & /s**3-1d0/16*p1p5*p2p4*mmo**4/s**3/spr)
     & +propwspr*propwsprc/pi**3*alpha*gf**2*qdn*mw**4*(s-spr)*(-1d0/8*p
     & 1p3*p2p4/s**3+1d0/8*p1p3*p2p4*mmo**2/s**3/spr)
     & +propwspr*propwsprc/pi**3*alpha*gf**2*qdn**2*(s-spr)*(1d0/32*p1p2
     & *p3p4*mmo**2/s**2-1d0/32*p1p2*p3p4*mmo**4/s**2/spr)
     & +propwspr*propwsprc/pi**3*alpha*gf**2*qdn**2*mw**2*(s-spr)*(-1d0/
     & 16*p1p2*p4p5*mmo**2/s**3+1d0/16*p1p2*p4p5*mmo**4/s**3/spr+1d0/32*
     & p1p4*mmo**2/s**2-1d0/32*p1p4*mmo**4/s**2/spr+1d0/16*p1p5*p2p4*mmo
     & **2/s**3-1d0/16*p1p5*p2p4*mmo**4/s**3/spr)
     & +propwspr*propwsprc/pi**3*alpha*gf**2*qdn**2*mw**4*(s-spr)*(1d0/8
     & *p1p3*p4p5/s**3-1d0/8*p1p3*p4p5*mmo**2/s**3/spr)
     & +propwspr*propwsprc/pi**3*alpha*gf**2*qup*(s-spr)*(-1d0/16*p1p2*p
     & 3p4*mmo**2/s**2+1d0/16*p1p2*p3p4*mmo**4/s**2/spr)
     & +propwspr*propwsprc/pi**3*alpha*gf**2*qup*mw**2*(s-spr)*(1d0/32*p
     & 2p4*mmo**2/s**2-1d0/32*p2p4*mmo**4/s**2/spr)
     & +propwspr*propwsprc/pi**3*alpha*gf**2*qup*qdn*(s-spr)*(-1d0/16*p1
     & p2*p3p4*mmo**2/s**2+1d0/16*p1p2*p3p4*mmo**4/s**2/spr)
     & +propwspr*propwsprc/pi**3*alpha*gf**2*qup*qdn*mw**2*(s-spr)*(1d0/
     & 16*p1p2*p4p5*mmo**2/s**3-1d0/16*p1p2*p4p5*mmo**4/s**3/spr-1d0/32*
     & p1p4*mmo**2/s**2+1d0/32*p1p4*mmo**4/s**2/spr-1d0/16*p1p5*p2p4*mmo
     & **2/s**3+1d0/16*p1p5*p2p4*mmo**4/s**3/spr+1d0/32*p2p4*mmo**2/s**2
     & -1d0/32*p2p4*mmo**4/s**2/spr)
     & +propwspr*propwsprc/pi**3*alpha*gf**2*qup*qdn*mw**4*(s-spr)*(1d0/
     & 8*p1p3*p2p4/s**3-1d0/8*p1p3*p2p4*mmo**2/s**3/spr+1d0/8*p2p3*p2p4/
     & s**3-1d0/8*p2p3*p2p4*mmo**2/s**3/spr)
     & +propwspr*propwsprc/pi**3*alpha*gf**2*qup**2*(s-spr)*(1d0/32*p1p2
     & *p3p4*mmo**2/s**2-1d0/32*p1p2*p3p4*mmo**4/s**2/spr)
     & +propwspr*propwsprc/pi**3*alpha*gf**2*qup**2*mw**2*(s-spr)*(-1d0/
     & 32*p2p4*mmo**2/s**2+1d0/32*p2p4*mmo**4/s**2/spr)
     & +propwspr*propwpsc/pi**3*alpha*gf**2*qdn*mw**4*(s-spr)*(1d0/16*p1
     & p3*p2p4/s**3-1d0/16*p1p3*p2p4*mmo**2/s**3/spr)
     & +propwspr*propwpsc/pi**3*alpha*gf**2*qdn*qmo*mw**4*(s-spr)*(1d0/1
     & 6*p1p2*p2p4/s**3-1d0/16*p1p2*p2p4*mmo**2/s**3/spr+1d0/16*p1p3*p2p
     & 4/s**3-1d0/16*p1p3*p2p4*mmo**2/s**3/spr)
     & +propwspr*propwpsc/pi**3*alpha*gf**2*qup*qmo*mw**4*(s-spr)*(1d0/1
     & 6*p2p4/s**2-1d0/16*p2p4*mmo**2/s**2/spr)
     & +propwspr*propwpsc*propwsprc/pi**3*alpha*gf**2*mw**2*(s-spr)*(-1d
     & 0/32*p1p2*p4p5*mmo**2/s**2+1d0/32*p1p2*p4p5*mmo**4/s**2/spr-1d0/3
     & 2*p1p4*p2p5*mmo**2/s**2+1d0/32*p1p4*p2p5*mmo**4/s**2/spr-1d0/32*p
     & 1p5*p2p4*mmo**2/s**2+1d0/32*p1p5*p2p4*mmo**4/s**2/spr)
     & +propwspr*propwpsc*propwsprc/pi**3*alpha*gf**2*qdn*mw**2*(s-spr)*
     & (-1d0/32*p1p2*p4p5*mmo**2/s**2+1d0/32*p1p2*p4p5*mmo**4/s**2/spr-1
     & d0/32*p1p4*p2p5*mmo**2/s**2+1d0/32*p1p4*p2p5*mmo**4/s**2/spr-1d0/
     & 32*p1p5*p2p4*mmo**2/s**2+1d0/32*p1p5*p2p4*mmo**4/s**2/spr)
     & +propwspr*propwpsc*propwsprc/pi**3*alpha*gf**2*qdn*mw**4*(s-spr)*
     & (-1d0/4*p1p2*p1p3*p2p4/s**3+1d0/4*p1p2*p1p3*p2p4*mmo**2/s**3/spr-
     & 1d0/8*p1p2*p1p3*p4p5/s**3+1d0/8*p1p2*p1p3*p4p5*mmo**2/s**3/spr+1d
     & 0/8*p1p2*p2p4*p3p5/s**3-1d0/8*p1p2*p2p4*p3p5*mmo**2/s**3/spr-1d0/
     & 16*p1p3*p1p4/s**2+1d0/16*p1p3*p1p4*mmo**2/s**2/spr+1d0/8*p1p3*p2p
     & 4/s**2-1d0/8*p1p3*p2p4*mmo**2/s**2/spr+1d0/8*p1p3*p4p5/s**2-1d0/8
     & *p1p3*p4p5*mmo**2/s**2/spr-1d0/8*p1p5*p2p3*p2p4/s**3+1d0/8*p1p5*p
     & 2p3*p2p4*mmo**2/s**3/spr)
     & +propwspr*propwpsc*propwsprc/pi**3*alpha*gf**2*qup*mw**2*(s-spr)*
     & (1d0/32*p1p2*p4p5*mmo**2/s**2-1d0/32*p1p2*p4p5*mmo**4/s**2/spr+1d
     & 0/32*p1p4*p2p5*mmo**2/s**2-1d0/32*p1p4*p2p5*mmo**4/s**2/spr+1d0/3
     & 2*p1p5*p2p4*mmo**2/s**2-1d0/32*p1p5*p2p4*mmo**4/s**2/spr)
     & +propwspr*propwpsc*propwsprc/pi**3*alpha*gf**2*qup*mw**4*(s-spr)*
     & (-1d0/8*p1p3*p2p4/s**2+1d0/8*p1p3*p2p4*mmo**2/s**2/spr+1d0/16*p2p
     & 3*p2p4/s**2-1d0/16*p2p3*p2p4*mmo**2/s**2/spr+1d0/8*p2p4*p3p5/s**2
     & -1d0/8*p2p4*p3p5*mmo**2/s**2/spr)
     & +propwps*propwspr*propwsprc/pi**3*alpha*gf**2*mw**2*(s-spr)*(-1d0
     & /32*p1p2*p4p5*mmo**2/s**2+1d0/32*p1p2*p4p5*mmo**4/s**2/spr-1d0/32
     & *p1p4*p2p5*mmo**2/s**2+1d0/32*p1p4*p2p5*mmo**4/s**2/spr-1d0/32*p1
     & p5*p2p4*mmo**2/s**2+1d0/32*p1p5*p2p4*mmo**4/s**2/spr)
     & +propwps*propwspr*propwsprc/pi**3*alpha*gf**2*qdn*mw**2*(s-spr)*(
     & -1d0/32*p1p2*p4p5*mmo**2/s**2+1d0/32*p1p2*p4p5*mmo**4/s**2/spr-1d
     & 0/32*p1p4*p2p5*mmo**2/s**2+1d0/32*p1p4*p2p5*mmo**4/s**2/spr-1d0/3
     & 2*p1p5*p2p4*mmo**2/s**2+1d0/32*p1p5*p2p4*mmo**4/s**2/spr)
     & +propwps*propwspr*propwsprc/pi**3*alpha*gf**2*qdn*mw**4*(s-spr)*(
     & -1d0/4*p1p2*p1p3*p2p4/s**3+1d0/4*p1p2*p1p3*p2p4*mmo**2/s**3/spr-1
     & d0/8*p1p2*p1p3*p4p5/s**3+1d0/8*p1p2*p1p3*p4p5*mmo**2/s**3/spr+1d0
     & /8*p1p2*p2p4*p3p5/s**3-1d0/8*p1p2*p2p4*p3p5*mmo**2/s**3/spr-1d0/1
     & 6*p1p3*p1p4/s**2+1d0/16*p1p3*p1p4*mmo**2/s**2/spr+1d0/8*p1p3*p2p4
     & /s**2-1d0/8*p1p3*p2p4*mmo**2/s**2/spr+1d0/8*p1p3*p4p5/s**2-1d0/8*
     & p1p3*p4p5*mmo**2/s**2/spr-1d0/8*p1p5*p2p3*p2p4/s**3+1d0/8*p1p5*p2
     & p3*p2p4*mmo**2/s**3/spr)
     & +propwps*propwspr*propwsprc/pi**3*alpha*gf**2*qup*mw**2*(s-spr)*(
     & 1d0/32*p1p2*p4p5*mmo**2/s**2-1d0/32*p1p2*p4p5*mmo**4/s**2/spr+1d0
     & /32*p1p4*p2p5*mmo**2/s**2-1d0/32*p1p4*p2p5*mmo**4/s**2/spr+1d0/32
     & *p1p5*p2p4*mmo**2/s**2-1d0/32*p1p5*p2p4*mmo**4/s**2/spr)
     & +propwps*propwspr*propwsprc/pi**3*alpha*gf**2*qup*mw**4*(s-spr)*(
     & -1d0/8*p1p3*p2p4/s**2+1d0/8*p1p3*p2p4*mmo**2/s**2/spr+1d0/16*p2p3
     & *p2p4/s**2-1d0/16*p2p3*p2p4*mmo**2/s**2/spr+1d0/8*p2p4*p3p5/s**2-
     & 1d0/8*p2p4*p3p5*mmo**2/s**2/spr)
     & +propwps*propwspr*propwpsc/pi**3*alpha*gf**2*qmo*mw**4*(s-spr)*(1
     & d0/16*p1p2*p2p4/s**2-1d0/16*p1p2*p2p4*mmo**2/s**2/spr+1d0/16*p1p3
     & *p2p4/s**2-1d0/16*p1p3*p2p4*mmo**2/s**2/spr-1d0/8*p1p5*p2p4/s**2+
     & 1d0/8*p1p5*p2p4*mmo**2/s**2/spr)
     & +propwps*propwspr*propwpsc*propwsprc/pi**3*alpha*gf**2*mw**4*(s-s
     & pr)*(-1d0/4*p1p2*p1p3*p4p5/s**2+1d0/4*p1p2*p1p3*p4p5*mmo**2/s**2/
     & spr+1d0/4*p1p2*p2p4*p3p5/s**2-1d0/4*p1p2*p2p4*p3p5*mmo**2/s**2/sp
     & r+1d0/4*p1p3*p1p4*p2p5/s**2-1d0/4*p1p3*p1p4*p2p5*mmo**2/s**2/spr+
     & 1d0/4*p1p3*p1p5*p2p4/s**2-1d0/4*p1p3*p1p5*p2p4*mmo**2/s**2/spr-1d
     & 0/4*p1p3*p2p4*p2p5/s**2+1d0/4*p1p3*p2p4*p2p5*mmo**2/s**2/spr+1d0/
     & 4*p1p3*p2p4*ps/s**2-1d0/4*p1p3*p2p4*ps*mmo**2/s**2/spr-1d0/4*p1p3
     & *p2p5*p4p5/s**2+1d0/4*p1p3*p2p5*p4p5*mmo**2/s**2/spr-1d0/4*p1p5*p
     & 2p3*p2p4/s**2+1d0/4*p1p5*p2p3*p2p4*mmo**2/s**2/spr-1d0/4*p1p5*p2p
     & 4*p3p5/s**2+1d0/4*p1p5*p2p4*p3p5*mmo**2/s**2/spr)
     & +propwps*propwsprc/pi**3*alpha*gf**2*qdn*mw**4*(s-spr)*(1d0/16*p1
     & p3*p2p4/s**3-1d0/16*p1p3*p2p4*mmo**2/s**3/spr)
     & +propwps*propwsprc/pi**3*alpha*gf**2*qdn*qmo*mw**4*(s-spr)*(1d0/1
     & 6*p1p2*p2p4/s**3-1d0/16*p1p2*p2p4*mmo**2/s**3/spr+1d0/16*p1p3*p2p
     & 4/s**3-1d0/16*p1p3*p2p4*mmo**2/s**3/spr)
     & +propwps*propwsprc/pi**3*alpha*gf**2*qup*qmo*mw**4*(s-spr)*(1d0/1
     & 6*p2p4/s**2-1d0/16*p2p4*mmo**2/s**2/spr)
     & +propwps*propwpsc*propwsprc/pi**3*alpha*gf**2*qmo*mw**4*(s-spr)*(
     & 1d0/16*p1p2*p2p4/s**2-1d0/16*p1p2*p2p4*mmo**2/s**2/spr+1d0/16*p1p
     & 3*p2p4/s**2-1d0/16*p1p3*p2p4*mmo**2/s**2/spr-1d0/8*p1p5*p2p4/s**2
     & +1d0/8*p1p5*p2p4*mmo**2/s**2/spr)

      hard = hard*conhc*cfprime

      return
      end
