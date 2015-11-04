************************************************************************
* sanc_cc_v1.70 package.
************************************************************************
* File (cc_ha_14_1__13_12_11.f) is created on Mon Aug 26 16:37:37 MSK 2013.
************************************************************************
* This is the FORTRAN module (cc_ha_14_1__13_12_11) to calculate
* differential cross-section of the photon induced
* anti-dn + a -> anti-up + el^+ + en process.
*
* It is produced by s2n package of SANC (v1.10) Project.
* Copyright (C), SANC Project Team, 2002-2013.
*
* http://sanc.jinr.ru/
* http://pcphsanc.cern.ch/
* E-mail: <sanc@jinr.ru>
************************************************************************
      subroutine cc_ha_14_1__13_12_11 (s,spr,ph4,costh4,costh5,hard)
      implicit none!
      include 's2n_declare.h'

      real*8 sq,sqspr,qw,ps
      real*8 p1p2,p1p3,p1p4,p1p5,p2p3,p2p4,p2p5,p3p4,p3p5,p4p5
      real*8 ph4,cosph4,sinph4,costh4,sinth4,costh5,sinth5
      complex*16 propiwspr,propwspr,propwsprc,propiwps,propwps,propwpsc
      real*8 sqrtlssprup,isqrtlssprup
      real*8 iz1up,iz3el

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
     & +costh4*(1d0/4*spr-1d0/4*s)
     & +1d0/4*spr-1d0/4*s

      p1p4=
     & +costh4*(-1d0/4*spr+1d0/4*s)
     & +1d0/4*spr-1d0/4*s

      p1p5=
     & +costh5*(-1d0/4*spr+1d0/4*s)
     & +1d0/4*spr-1d0/4*s

      p2p3=
     & +sinph4*sinth4*sinth5*(1d0/4*sq*sqspr)
     & +costh4*costh5*(1d0/8*spr+1d0/8*s)
     & +costh4*(1d0/8*spr-1d0/8*s)
     & +costh5*(-1d0/8*spr+1d0/8*s)
     & -1d0/8*spr-1d0/8*s

      p2p4=
     & +sinph4*sinth4*sinth5*(-1d0/4*sq*sqspr)
     & +costh4*costh5*(-1d0/8*spr-1d0/8*s)
     & +costh4*(-1d0/8*spr+1d0/8*s)
     & +costh5*(-1d0/8*spr+1d0/8*s)
     & -1d0/8*spr-1d0/8*s

      p2p5=
     & -1d0/2*s

      p3p4=
     & -1d0/2*spr

      p3p5=
     & +sinph4*sinth4*sinth5*(-1d0/4*sq*sqspr)
     & +costh4*costh5*(-1d0/8*spr-1d0/8*s)
     & +costh4*(1d0/8*spr-1d0/8*s)
     & +costh5*(1d0/8*spr-1d0/8*s)
     & -1d0/8*spr-1d0/8*s

      p4p5=
     & +sinph4*sinth4*sinth5*(1d0/4*sq*sqspr)
     & +costh4*costh5*(1d0/8*spr+1d0/8*s)
     & +costh4*(-1d0/8*spr+1d0/8*s)
     & +costh5*(1d0/8*spr-1d0/8*s)
     & -1d0/8*spr-1d0/8*s

      iz1up=
     & +1d0/(mup**2/s+1d0/4*sqrtlssprup**2*sinth5**2/s**2)/(s-mdn**2)*(1
     & d0/2-1d0/2/s*spr+1d0/2*mup**2/s+1d0/2*sqrtlssprup*costh5/s)

      iz3el=
     & +1d0/(1d0/4*spr+1d0/4*s+1d0/2*sinph4*sinth4*sinth5*sq*sqspr-1d0/4
     & *costh4*spr+1d0/4*costh4*s+1d0/4*costh4*costh5*spr+1d0/4*costh4*c
     & osth5*s-1d0/4*costh5*spr+1d0/4*costh5*s)*(1)

      hard=
     & +iz1up**2*propwspr*propwsprc/pi**3*alpha*gf**2*qup**2*mw**4*(s-sp
     & r)*(-1d0/4*p1p3*p2p4*mup**2/s**2+1d0/4*p2p4*p3p5*mup**2/s**2)
     & +iz1up*iz3el*propwspr*propwpsc/pi**3*alpha*gf**2*qup*mw**4*(s-spr
     & )*(1d0/4*p1p3**2*p2p4*qel/s**2)
     & +iz1up*iz3el*propwps*propwsprc/pi**3*alpha*gf**2*qup*mw**4*(s-spr
     & )*(1d0/4*p1p3**2*p2p4*qel/s**2)
     & +iz1up*propwspr*propwsprc/pi**3*alpha*gf**2*qup*mw**4*(s-spr)*(-1
     & d0/8*p1p3*p2p4/s**2)
     & +iz1up*propwspr*propwsprc/pi**3*alpha*gf**2*qup*qdn*mw**4*(s-spr)
     & *(-1d0/2*p1p2*p1p3*p2p4/s**3-1d0/4*p1p2*p1p3*p4p5/s**3+1d0/4*p1p2
     & *p2p4*p3p5/s**3-1d0/8*p1p3*p1p4/s**2-1d0/8*p1p3*p2p4/s**2)
     & +iz1up*propwspr*propwsprc/pi**3*alpha*gf**2*qup**2*mw**4*(s-spr)*
     & (1d0/8*p2p4*p3p5/s**2)
     & +iz1up*propwspr*propwpsc/pi**3*alpha*gf**2*qup*mw**4*(s-spr)*(1d0
     & /16*p1p3*p2p4/s**2+1d0/8*p1p3*p2p4*qel/s**2)
     & +iz1up*propwspr*propwpsc*propwsprc/pi**3*alpha*gf**2*qup*mw**4*(s
     & -spr)*(-1d0/4*p1p2*p1p3*p2p4/s**2-1d0/8*p1p2*p1p3*p4p5/s**2+1d0/8
     & *p1p2*p2p4*p3p5/s**2+1d0/8*p1p3*p1p4*p2p5/s**2)
     & +iz1up*propwps*propwspr*propwsprc/pi**3*alpha*gf**2*qup*mw**4*(s-
     & spr)*(-1d0/4*p1p2*p1p3*p2p4/s**2-1d0/8*p1p2*p1p3*p4p5/s**2+1d0/8*
     & p1p2*p2p4*p3p5/s**2+1d0/8*p1p3*p1p4*p2p5/s**2)
     & +iz1up*propwps*propwsprc/pi**3*alpha*gf**2*qup*mw**4*(s-spr)*(1d0
     & /16*p1p3*p2p4/s**2+1d0/8*p1p3*p2p4*qel/s**2)
     & +iz3el*propwspr*propwpsc/pi**3*alpha*gf**2*mw**4*(s-spr)*(-1d0/16
     & *p1p3*p2p4*qel/s**2)
     & +iz3el*propwspr*propwpsc/pi**3*alpha*gf**2*qdn*mw**4*(s-spr)*(-1d
     & 0/4*p1p3*p2p3*p2p4*qel/s**3-1d0/8*p1p3*p2p3*p4p5*qel/s**3-1d0/16*
     & p1p3*p2p4*qel/s**2-1d0/16*p1p3*p3p4*qel/s**2+1d0/8*p1p5*p2p3*p2p4
     & *qel/s**3)
     & +iz3el*propwspr*propwpsc/pi**3*alpha*gf**2*qup*mw**4*(s-spr)*(1d0
     & /8*p1p3*p2p4*qel/s**2)
     & +iz3el*propwps*propwspr*propwpsc/pi**3*alpha*gf**2*mw**4*(s-spr)*
     & (-1d0/8*p1p3*p1p5*p2p4*qel/s**2-1d0/4*p1p3*p2p3*p2p4*qel/s**2-1d0
     & /8*p1p3*p2p3*p4p5*qel/s**2+1d0/8*p1p3*p2p5*p3p4*qel/s**2+1d0/4*p1
     & p3**2*p2p4*qel/s**2+1d0/8*p1p5*p2p3*p2p4*qel/s**2)
     & +iz3el*propwps*propwsprc/pi**3*alpha*gf**2*mw**4*(s-spr)*(-1d0/16
     & *p1p3*p2p4*qel/s**2)
     & +iz3el*propwps*propwsprc/pi**3*alpha*gf**2*qdn*mw**4*(s-spr)*(-1d
     & 0/4*p1p3*p2p3*p2p4*qel/s**3-1d0/8*p1p3*p2p3*p4p5*qel/s**3-1d0/16*
     & p1p3*p2p4*qel/s**2-1d0/16*p1p3*p3p4*qel/s**2+1d0/8*p1p5*p2p3*p2p4
     & *qel/s**3)
     & +iz3el*propwps*propwsprc/pi**3*alpha*gf**2*qup*mw**4*(s-spr)*(1d0
     & /8*p1p3*p2p4*qel/s**2)
     & +iz3el*propwps*propwpsc/pi**3*alpha*gf**2*mw**4*(s-spr)*(1d0/8*p1
     & p3*p2p4*qel/s**2+1d0/8*p1p5*p2p4*qel**2/s**2)
     & +iz3el*propwps*propwpsc*propwsprc/pi**3*alpha*gf**2*mw**4*(s-spr)
     & *(-1d0/8*p1p3*p1p5*p2p4*qel/s**2-1d0/4*p1p3*p2p3*p2p4*qel/s**2-1d
     & 0/8*p1p3*p2p3*p4p5*qel/s**2+1d0/8*p1p3*p2p5*p3p4*qel/s**2+1d0/4*p
     & 1p3**2*p2p4*qel/s**2+1d0/8*p1p5*p2p3*p2p4*qel/s**2)
     & +propwspr*propwsprc/pi**3*alpha*gf**2*qdn*mw**4*(s-spr)*(-1d0/8*p
     & 1p3*p2p4/s**3)
     & +propwspr*propwsprc/pi**3*alpha*gf**2*qdn**2*mw**4*(s-spr)*(1d0/8
     & *p1p3*p4p5/s**3)
     & +propwspr*propwsprc/pi**3*alpha*gf**2*qup*qdn*mw**4*(s-spr)*(1d0/
     & 8*p1p3*p2p4/s**3+1d0/8*p2p3*p2p4/s**3)
     & +propwspr*propwpsc/pi**3*alpha*gf**2*qdn*mw**4*(s-spr)*(1d0/16*p1
     & p2*p2p4*qel/s**3+1d0/16*p1p3*p2p4/s**3+1d0/16*p1p3*p2p4*qel/s**3)
     & 
     & +propwspr*propwpsc/pi**3*alpha*gf**2*qup*mw**4*(s-spr)*(1d0/16*p2
     & p4*qel/s**2)
     & +propwspr*propwpsc*propwsprc/pi**3*alpha*gf**2*qdn*mw**4*(s-spr)*
     & (-1d0/4*p1p2*p1p3*p2p4/s**3-1d0/8*p1p2*p1p3*p4p5/s**3+1d0/8*p1p2*
     & p2p4*p3p5/s**3-1d0/16*p1p3*p1p4/s**2+1d0/8*p1p3*p2p4/s**2+1d0/8*p
     & 1p3*p4p5/s**2-1d0/8*p1p5*p2p3*p2p4/s**3)
     & +propwspr*propwpsc*propwsprc/pi**3*alpha*gf**2*qup*mw**4*(s-spr)*
     & (-1d0/8*p1p3*p2p4/s**2+1d0/16*p2p3*p2p4/s**2+1d0/8*p2p4*p3p5/s**2
     & )
     & +propwps*propwspr*propwsprc/pi**3*alpha*gf**2*qdn*mw**4*(s-spr)*(
     & -1d0/4*p1p2*p1p3*p2p4/s**3-1d0/8*p1p2*p1p3*p4p5/s**3+1d0/8*p1p2*p
     & 2p4*p3p5/s**3-1d0/16*p1p3*p1p4/s**2+1d0/8*p1p3*p2p4/s**2+1d0/8*p1
     & p3*p4p5/s**2-1d0/8*p1p5*p2p3*p2p4/s**3)
     & +propwps*propwspr*propwsprc/pi**3*alpha*gf**2*qup*mw**4*(s-spr)*(
     & -1d0/8*p1p3*p2p4/s**2+1d0/16*p2p3*p2p4/s**2+1d0/8*p2p4*p3p5/s**2)
     & 
     & +propwps*propwspr*propwpsc/pi**3*alpha*gf**2*mw**4*(s-spr)*(1d0/1
     & 6*p1p2*p2p4*qel/s**2+1d0/16*p1p3*p2p4*qel/s**2-1d0/8*p1p5*p2p4*qe
     & l/s**2)
     & +propwps*propwspr*propwpsc*propwsprc/pi**3*alpha*gf**2*mw**4*(s-s
     & pr)*(-1d0/4*p1p2*p1p3*p4p5/s**2+1d0/4*p1p2*p2p4*p3p5/s**2+1d0/4*p
     & 1p3*p1p4*p2p5/s**2+1d0/4*p1p3*p1p5*p2p4/s**2-1d0/4*p1p3*p2p4*p2p5
     & /s**2+1d0/4*p1p3*p2p4*ps/s**2-1d0/4*p1p3*p2p5*p4p5/s**2-1d0/4*p1p
     & 5*p2p3*p2p4/s**2-1d0/4*p1p5*p2p4*p3p5/s**2)
     & +propwps*propwsprc/pi**3*alpha*gf**2*qdn*mw**4*(s-spr)*(1d0/16*p1
     & p2*p2p4*qel/s**3+1d0/16*p1p3*p2p4/s**3+1d0/16*p1p3*p2p4*qel/s**3)
     & 
     & +propwps*propwsprc/pi**3*alpha*gf**2*qup*mw**4*(s-spr)*(1d0/16*p2
     & p4*qel/s**2)
     & +propwps*propwpsc*propwsprc/pi**3*alpha*gf**2*mw**4*(s-spr)*(1d0/
     & 16*p1p2*p2p4*qel/s**2+1d0/16*p1p3*p2p4*qel/s**2-1d0/8*p1p5*p2p4*q
     & el/s**2)

      hard = hard*conhc*cfprime

      return
      end
