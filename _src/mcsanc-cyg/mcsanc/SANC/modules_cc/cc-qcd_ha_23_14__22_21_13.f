************************************************************************
* sanc_cc_v1.60 package.
************************************************************************
* File (cc-qcd_ha_23_14__22_21_13.f) is created on Mon Mar 26 11:57:07 MSK 2012.
************************************************************************
* This is the FORTRAN module (cc_qcd_ha_23_14__22_21_13) to calculate
* differential cross-section of the gluon induced
* g + dn -> bt + anti-tp +      up process.
*
* It is produced by s2n package of SANC (v1.10) Project.
* Copyright (C), SANC Project Team, 2002-2012.
*
* http://sanc.jinr.ru/
* http://pcphsanc.cern.ch/
* E-mail: <sanc@jinr.ru>
************************************************************************
      subroutine cc_qcd_ha_23_14__22_21_13 (s,spr,ph3,costh3,costh5,hard)
      implicit none!
      include 's2n_declare.h'

      real*8 sq,sqspr
      real*8 p1p2,p1p3,p1p4,p1p5,p2p3,p2p4,p2p5,p3p4,p3p5,p4p5
      real*8 ph3,cosph3,sinph3,costh3,sinth3,costh5,sinth5
      real*8 sqrtlsbtspr,isqrtlsbtspr
      complex*16 propiwp2p3,propwp2p3,propcwp2p3
      real*8 iz1bt,iz4tp

      sq = dsqrt(s)
      sqspr = dsqrt(spr)

      cosph3 = dcos(ph3)
      sinph3 = dsin(ph3)
      sinth3 = dsqrt(1d0-costh3**2)
      sinth5 = dsqrt(1d0-costh5**2)

      sqrtlsbtspr = sqrt(s**2-2d0*s*(rbtm2+spr)+(rbtm2-spr)**2)
      isqrtlsbtspr = 1d0/sqrtlsbtspr

      p1p2=
     & +sqrtlsbtspr*costh5*(-1d0/4)
     & +1d0/4*spr-1d0/4*s-1d0/4*mbt**2

      p1p3=
     & +sqrtlsbtspr**2*(-1d0/8/s+1d0/8*mtp**2/s/spr)
     & +sqrtlsbtspr*costh3*(1d0/4*(spr-mtp**2)/spr)
     & +1d0/8/s*spr**2-1d0/8*s-1d0/4*mbt**2/s*spr+1d0/8*mbt**4/s-1d0/8*m
     & tp**2/s*spr+1d0/8*mtp**2*s/spr+1d0/4*mtp**2*mbt**2/s-1d0/8*mtp**2
     & *mbt**4/s/spr

      p1p4=
     & +sqrtlsbtspr**2*(-1d0/8/s-1d0/8*mtp**2/s/spr)
     & +sqrtlsbtspr*costh3*(-1d0/4*(spr-mtp**2)/spr)
     & +1d0/8/s*spr**2-1d0/8*s-1d0/4*mbt**2/s*spr+1d0/8*mbt**4/s+1d0/8*m
     & tp**2/s*spr-1d0/8*mtp**2*s/spr-1d0/4*mtp**2*mbt**2/s+1d0/8*mtp**2
     & *mbt**4/s/spr

      p1p5=
     & +sqrtlsbtspr*costh5*(1d0/4)
     & +1d0/4*spr-1d0/4*s-1d0/4*mbt**2

      p2p3=
     & +sqrtlsbtspr*costh3*(1d0/8*(spr-mtp**2)/spr)
     & +sqrtlsbtspr*costh5*(1d0/8-1d0/8*mtp**2/spr)
     & +sinph3*sinth3*sinth5*(-1d0/4*sq*sqspr*(spr-mtp**2)/spr)
     & +costh3*costh5*(-1d0/8*(spr-mtp**2)
     & -1d0/8*(spr-mtp**2)*s/spr+1d0/8*(spr-mtp**2)*mbt**2/spr)
     & -1d0/8*spr-1d0/8*s+1d0/8*mbt**2+1d0/8*mtp**2+1d0/8*mtp**2*s/spr-1
     & d0/8*mtp**2*mbt**2/spr

      p2p4=
     & +sqrtlsbtspr*costh3*(-1d0/8*(spr-mtp**2)/spr)
     & +sqrtlsbtspr*costh5*(1d0/8+1d0/8*mtp**2/spr)
     & +sinph3*sinth3*sinth5*(1d0/4*sq*sqspr*(spr-mtp**2)/spr)
     & +costh3*costh5*(1d0/8*(spr-mtp**2)
     & +1d0/8*(spr-mtp**2)*s/spr-1d0/8*(spr-mtp**2)*mbt**2/spr)
     & -1d0/8*spr-1d0/8*s+1d0/8*mbt**2-1d0/8*mtp**2-1d0/8*mtp**2*s/spr+1
     & d0/8*mtp**2*mbt**2/spr

      p2p5=
     & -1d0/2*s

      p3p4=
     & -1d0/2*spr+1d0/2*mtp**2

      p3p5=
     & +sqrtlsbtspr*costh3*(1d0/8*(spr-mtp**2)/spr)
     & +sqrtlsbtspr*costh5*(-1d0/8+1d0/8*mtp**2/spr)
     & +sinph3*sinth3*sinth5*(1d0/4*sq*sqspr*(spr-mtp**2)/spr)
     & +costh3*costh5*(1d0/8*(spr-mtp**2)
     & +1d0/8*(spr-mtp**2)*s/spr-1d0/8*(spr-mtp**2)*mbt**2/spr)
     & -1d0/8*spr-1d0/8*s+1d0/8*mbt**2+1d0/8*mtp**2+1d0/8*mtp**2*s/spr-1
     & d0/8*mtp**2*mbt**2/spr

      p4p5=
     & +sqrtlsbtspr*costh3*(-1d0/8*(spr-mtp**2)/spr)
     & +sqrtlsbtspr*costh5*(-1d0/8-1d0/8*mtp**2/spr)
     & +sinph3*sinth3*sinth5*(-1d0/4*sq*sqspr*(spr-mtp**2)/spr)
     & +costh3*costh5*(-1d0/8*(spr-mtp**2)
     & -1d0/8*(spr-mtp**2)*s/spr+1d0/8*(spr-mtp**2)*mbt**2/spr)
     & -1d0/8*spr-1d0/8*s+1d0/8*mbt**2-1d0/8*mtp**2-1d0/8*mtp**2*s/spr+1
     & d0/8*mtp**2*mbt**2/spr

      iz1bt=
     & +1d0/(1-mdn**2/s)**2*1d0/(1d0/4*sqrtlsbtspr**2*1d0/(1-mdn**2/s)**
     & 2*sinth5**2-1d0/2*sqrtlsbtspr**2*1d0/(1-mdn**2/s)**2*sinth5**2*md
     & n**2/s+1d0/4*sqrtlsbtspr**2*1d0/(1-mdn**2/s)**2*sinth5**2*mdn**4/
     & s**2+1d0/(1-mdn**2/s)**2*mbt**2*s-2*1d0/(1-mdn**2/s)**2*mdn**2*mb
     & t**2+1d0/(1-mdn**2/s)**2*mdn**4*mbt**2/s)*(-1d0/2*spr+1d0/2*s+1d0
     & /2*mbt**2+1d0/2*mdn**2/s*spr-1d0/2*mdn**2-1d0/2*mdn**2*mbt**2/s+1
     & d0/2*sqrtlsbtspr*costh5-1d0/2*sqrtlsbtspr*costh5*mdn**2/s)

      iz4tp=
     & +1d0/(1d0/4*spr+1d0/4*s-1d0/4*mbt**2+1d0/4*mtp**2+1d0/4*mtp**2*s/
     & spr-1d0/4*mtp**2*mbt**2/spr+1d0/4*sqrtlsbtspr*costh3*(spr-mtp**2)
     & /spr+1d0/4*sqrtlsbtspr*costh5+1d0/4*sqrtlsbtspr*costh5*mtp**2/spr
     & +1d0/2*sinph3*sinth3*sinth5*sq*sqspr*(spr-mtp**2)/spr+1d0/4*costh
     & 3*costh5*(spr-mtp**2)
     & +1d0/4*costh3*costh5*(spr-mtp**2)*s/spr-1d0/4*costh3*costh5*(spr-
     & mtp**2)*mbt**2/spr)*(1)

      propiwp2p3 = (rwm2-2*p2p3)
      propwp2p3 = 1d0/propiwp2p3
      propcwp2p3 = dconjg(propwp2p3)

      hard=
     & +iz1bt**2*sqrtlsbtspr*propwp2p3*propcwp2p3*(spr-mtp**2)/pi**3*alp
     & has*gf**2*mw**4*mbt**2/s**2/spr*cf*(-3d0/32*p1p3*p2p4+3d0/32*p2p4
     & *p3p5)
     & +iz1bt*iz4tp*sqrtlsbtspr*propwp2p3*propcwp2p3*(spr-mtp**2)/pi**3*
     & alphas*gf**2*mw**4/s**2/spr*cf*(-3d0/16*p1p3*p1p4*p2p4+3d0/32*p1p
     & 3*p1p4*p2p5+3d0/32*p1p4*p2p4*p3p5)
     & +iz1bt*sqrtlsbtspr*propwp2p3*propcwp2p3*(spr-mtp**2)/pi**3*alphas
     & *gf**2*mw**4/s**2/spr*cf*(3d0/64*p1p2*p1p3-3d0/64*p1p3*p2p4+3d0/6
     & 4*p2p4*p3p5)
     & +iz4tp**2*sqrtlsbtspr*propwp2p3*propcwp2p3*(spr-mtp**2)/pi**3*alp
     & has*gf**2*mw**4*mtp**2/s**2/spr*cf*(-3d0/32*p1p3*p2p4+3d0/32*p1p3
     & *p2p5)
     & +iz4tp*sqrtlsbtspr*propwp2p3*propcwp2p3*(spr-mtp**2)/pi**3*alphas
     & *gf**2*mw**4/s**2/spr*cf*(-3d0/64*p1p3*p2p4+3d0/64*p1p3*p2p5+3d0/
     & 64*p2p4*p3p4)

      hard = hard*conhc

      return
      end
