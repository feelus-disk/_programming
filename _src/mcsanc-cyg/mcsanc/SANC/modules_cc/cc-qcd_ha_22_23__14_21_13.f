************************************************************************
* sanc_cc_v1.60 package.
************************************************************************
* File (cc-qcd_ha_22_23__14_21_13.f) is created on Mon Mar 26 11:57:10 MSK 2012.
************************************************************************
* This is the FORTRAN module (cc_qcd_ha_22_23__14_21_13) to calculate
* differential cross-section of the gluon induced
* anti-bt + g -> anti-dn + anti-tp + up process.
*
* It is produced by s2n package of SANC (v1.10) Project.
* Copyright (C), SANC Project Team, 2002-2012.
*
* http://sanc.jinr.ru/
* http://pcphsanc.cern.ch/
* E-mail: <sanc@jinr.ru>
************************************************************************
      subroutine cc_qcd_ha_22_23__14_21_13 (s,spr,ph3,costh3,costh5,hard)
      implicit none!
      include 's2n_declare.h'

      real*8 sq,sqspr
      real*8 p1p2,p1p3,p1p4,p1p5,p2p3,p2p4,p2p5,p3p4,p3p5,p4p5
      real*8 ph3,cosph3,sinph3,costh3,sinth3,costh5,sinth5
      real*8 sqrtlsupspr,isqrtlsupspr,sqrtlsprdntp,isqrtlsprdntp
      complex*16 propiwp1p4,propwp1p4,propcwp1p4
      real*8 iz2up,iz3dn

      sq = dsqrt(s)
      sqspr = dsqrt(spr)

      cosph3 = dcos(ph3)
      sinph3 = dsin(ph3)
      sinth3 = dsqrt(1d0-costh3**2)
      sinth5 = dsqrt(1d0-costh5**2)

      sqrtlsupspr = sqrt(s**2-2d0*s*(rupm2+spr)+(rupm2-spr)**2)
      isqrtlsupspr = 1d0/sqrtlsupspr
      sqrtlsprdntp = sqrt(spr**2-2d0*spr*(rdnm2+rtpm2)+(rdnm2-rtpm2)**2)
      isqrtlsprdntp = 1d0/sqrtlsprdntp

      p1p2=
     & +(s-mbt**2)*(1d0/4/s*(s-spr)
     & +1d0/4*mup**2/s)
     & +sqrtlsupspr*costh5*(s-mbt**2)*(-1d0/4/s)
     & -1d0/2*(s-spr)-1d0/2*mup**2

      p1p3=
     & +(s-mbt**2)*(1d0/4-1d0/8/s*(s-spr)
     & -1d0/8*mtp**2/s-1d0/8*mtp**2/spr+1d0/8*mdn**2/s+1d0/8*mdn**2/spr-
     & 1d0/8*mup**2/s+1d0/8*mup**2*mtp**2/s/spr-1d0/8*mup**2*mdn**2/s/sp
     & r)
     & +sqrtlsupspr*sqrtlsprdntp*costh3*(s-mbt**2)*(-1d0/8/s/spr)
     & +sqrtlsupspr*sqrtlsprdntp*costh3*(1d0/4/spr)
     & +sqrtlsupspr*costh5*(s-mbt**2)*(1d0/8/s-1d0/8*mtp**2/s/spr+1d0/8*
     & mdn**2/s/spr)
     & +sqrtlsprdntp*sinph3*sinth3*sinth5*(s-mbt**2)*(-1d0/4*sq*sqspr/s/
     & spr)
     & +sqrtlsprdntp*costh3*costh5*(s-mbt**2)*(-1d0/8/s-1d0/8/spr+1d0/8*
     & mup**2/s/spr)
     & +1d0/4*(s-spr)
     & -1d0/2*s+1d0/4*mtp**2+1d0/4*mtp**2*s/spr-1d0/4*mdn**2-1d0/4*mdn**
     & 2*s/spr+1d0/4*mup**2-1d0/4*mup**2*mtp**2/spr+1d0/4*mup**2*mdn**2/
     & spr

      p1p4=
     & +(s-mbt**2)*(1d0/4-1d0/8/s*(s-spr)
     & +1d0/8*mtp**2/s+1d0/8*mtp**2/spr-1d0/8*mdn**2/s-1d0/8*mdn**2/spr-
     & 1d0/8*mup**2/s-1d0/8*mup**2*mtp**2/s/spr+1d0/8*mup**2*mdn**2/s/sp
     & r)
     & +sqrtlsupspr*sqrtlsprdntp*costh3*(s-mbt**2)*(1d0/8/s/spr)
     & +sqrtlsupspr*sqrtlsprdntp*costh3*(-1d0/4/spr)
     & +sqrtlsupspr*costh5*(s-mbt**2)*(1d0/8/s+1d0/8*mtp**2/s/spr-1d0/8*
     & mdn**2/s/spr)
     & +sqrtlsprdntp*sinph3*sinth3*sinth5*(s-mbt**2)*(1d0/4*sq*sqspr/s/s
     & pr)
     & +sqrtlsprdntp*costh3*costh5*(s-mbt**2)*(1d0/8/s+1d0/8/spr-1d0/8*m
     & up**2/s/spr)
     & +1d0/4*(s-spr)
     & -1d0/2*s-1d0/4*mtp**2-1d0/4*mtp**2*s/spr+1d0/4*mdn**2+1d0/4*mdn**
     & 2*s/spr+1d0/4*mup**2+1d0/4*mup**2*mtp**2/spr-1d0/4*mup**2*mdn**2/
     & spr

      p1p5=
     & +(s-mbt**2)*(-1d0/2)

      p2p3=
     & +sqrtlsupspr**2*(-1d0/8/s+1d0/8*mtp**2/s/spr-1d0/8*mdn**2/s/spr)
     & +sqrtlsupspr*sqrtlsprdntp*costh3*(1d0/4/spr)
     & +1d0/8/s*(s-spr)**2-1d0/4*(s-spr)
     & +1d0/8*mtp**2/s*(s-spr)
     & -1d0/8*mtp**2+1d0/8*mtp**2*s/spr-1d0/8*mdn**2/s*(s-spr)
     & +1d0/8*mdn**2-1d0/8*mdn**2*s/spr+1d0/4*mup**2/s*(s-spr)
     & -1d0/4*mup**2+1d0/4*mup**2*mtp**2/s-1d0/4*mup**2*mdn**2/s+1d0/8*m
     & up**4/s-1d0/8*mup**4*mtp**2/s/spr+1d0/8*mup**4*mdn**2/s/spr

      p2p4=
     & +sqrtlsupspr**2*(-1d0/8/s-1d0/8*mtp**2/s/spr+1d0/8*mdn**2/s/spr)
     & +sqrtlsupspr*sqrtlsprdntp*costh3*(-1d0/4/spr)
     & +1d0/8/s*(s-spr)**2-1d0/4*(s-spr)
     & -1d0/8*mtp**2/s*(s-spr)+1d0/8*mtp**2-1d0/8*mtp**2*s/spr+1d0/8*mdn
     & **2/s*(s-spr)
     & -1d0/8*mdn**2+1d0/8*mdn**2*s/spr+1d0/4*mup**2/s*(s-spr)
     & -1d0/4*mup**2-1d0/4*mup**2*mtp**2/s+1d0/4*mup**2*mdn**2/s+1d0/8*m
     & up**4/s+1d0/8*mup**4*mtp**2/s/spr-1d0/8*mup**4*mdn**2/s/spr

      p2p5=
     & +(s-mbt**2)*(-1d0/4/s*(s-spr)
     & -1d0/4*mup**2/s)+sqrtlsupspr*costh5*(s-mbt**2)*(1d0/4/s)

      p3p4=
     & +1d0/2*(s-spr)
     & -1d0/2*s+1d0/2*mtp**2+1d0/2*mdn**2

      p3p5=
     & +(s-mbt**2)*(-1d0/4+1d0/8/s*(s-spr)
     & +1d0/8*mtp**2/s+1d0/8*mtp**2/spr-1d0/8*mdn**2/s-1d0/8*mdn**2/spr+
     & 1d0/8*mup**2/s-1d0/8*mup**2*mtp**2/s/spr+1d0/8*mup**2*mdn**2/s/sp
     & r)
     & +sqrtlsupspr*sqrtlsprdntp*costh3*(s-mbt**2)*(1d0/8/s/spr)
     & +sqrtlsupspr*costh5*(s-mbt**2)*(-1d0/8/s+1d0/8*mtp**2/s/spr-1d0/8
     & *mdn**2/s/spr)
     & +sqrtlsprdntp*sinph3*sinth3*sinth5*(s-mbt**2)*(1d0/4*sq*sqspr/s/s
     & pr)
     & +sqrtlsprdntp*costh3*costh5*(s-mbt**2)*(1d0/8/s+1d0/8/spr-1d0/8*m
     & up**2/s/spr)

      p4p5=
     & +(s-mbt**2)*(-1d0/4+1d0/8/s*(s-spr)
     & -1d0/8*mtp**2/s-1d0/8*mtp**2/spr+1d0/8*mdn**2/s+1d0/8*mdn**2/spr+
     & 1d0/8*mup**2/s+1d0/8*mup**2*mtp**2/s/spr-1d0/8*mup**2*mdn**2/s/sp
     & r)
     & +sqrtlsupspr*sqrtlsprdntp*costh3*(s-mbt**2)*(-1d0/8/s/spr)
     & +sqrtlsupspr*costh5*(s-mbt**2)*(-1d0/8/s-1d0/8*mtp**2/s/spr+1d0/8
     & *mdn**2/s/spr)
     & +sqrtlsprdntp*sinph3*sinth3*sinth5*(s-mbt**2)*(-1d0/4*sq*sqspr/s/
     & spr)
     & +sqrtlsprdntp*costh3*costh5*(s-mbt**2)*(-1d0/8/s-1d0/8/spr+1d0/8*
     & mup**2/s/spr)

      iz2up=
     & +1d0/(mup**2/s+1d0/4*sqrtlsupspr**2*sinth5**2/s**2)/(s-mbt**2)*(1
     & d0/2-1d0/2/s*spr+1d0/2*mup**2/s+1d0/2*sqrtlsupspr*costh5/s)

      iz3dn=
     & +1d0/(-spr*(s-spr)
     & +2*s*spr-mtp**2*spr-mtp**2*s+mdn**2*spr+mdn**2*s-mup**2*spr+mup**
     & 2*mtp**2-mup**2*mdn**2-sqrtlsupspr*sqrtlsprdntp*costh3+sqrtlsupsp
     & r*costh5*spr-sqrtlsupspr*costh5*mtp**2+sqrtlsupspr*costh5*mdn**2-
     & 2*sqrtlsprdntp*sinph3*sinth3*sinth5*sq*sqspr-sqrtlsprdntp*costh3*
     & costh5*spr-sqrtlsprdntp*costh3*costh5*s+sqrtlsprdntp*costh3*costh
     & 5*mup**2)/(s-mbt**2)*(4*s*spr)

      propiwp1p4 = (rwm2-mtp**2-mbt**2-2*p1p4)
      propwp1p4 = 1d0/propiwp1p4
      propcwp1p4 = dconjg(propwp1p4)

      hard=
     & +iz2up**2*sqrtlsprdntp*propwp1p4*propcwp1p4/(s-mbt**2)/pi**3*alph
     & as*gf**2*mup**2*mdn**2/s/spr*(s-spr)*cf*(-3d0/128*p1p4*p2p3*mbt**
     & 2-3d0/128*p1p4*p2p3*mtp**2+3d0/128*p1p4*p3p5*mbt**2+3d0/128*p1p4*
     & p3p5*mtp**2-3d0/64*p2p3*mtp**2*mbt**2+3d0/64*p3p5*mtp**2*mbt**2)
     & +iz2up**2*sqrtlsprdntp*propwp1p4*propcwp1p4/(s-mbt**2)/pi**3*alph
     & as*gf**2*mup**4/s/spr*(s-spr)*cf*(-3d0/128*p1p4*p2p3*mbt**2-3d0/1
     & 28*p1p4*p2p3*mtp**2+3d0/128*p1p4*p3p5*mbt**2+3d0/128*p1p4*p3p5*mt
     & p**2-3d0/64*p2p3*mtp**2*mbt**2+3d0/64*p3p5*mtp**2*mbt**2)
     & +iz2up**2*sqrtlsprdntp*propwp1p4*propcwp1p4/(s-mbt**2)/pi**3*alph
     & as*gf**2*mup**4*mdn**2/s/spr*(s-spr)*cf*(3d0/32*mtp**2*mbt**2+3d0
     & /64*p1p4*mbt**2+3d0/64*p1p4*mtp**2)
     & +iz2up**2*sqrtlsprdntp*propwp1p4*propcwp1p4/(s-mbt**2)/pi**3*alph
     & as*gf**2*mw**2*mup**2*mdn**2/s/spr*(s-spr)*cf*(3d0/64*p1p2*mtp**2
     & -3d0/64*p1p5*mtp**2-3d0/64*p2p4*mbt**2+3d0/64*p4p5*mbt**2)
     & +iz2up**2*sqrtlsprdntp*propwp1p4*propcwp1p4/(s-mbt**2)/pi**3*alph
     & as*gf**2*mw**2*mup**4/s/spr*(s-spr)*cf*(3d0/64*p1p3*mtp**2-3d0/64
     & *p3p4*mbt**2)
     & +iz2up**2*sqrtlsprdntp*propwp1p4*propcwp1p4/(s-mbt**2)/pi**3*alph
     & as*gf**2*mw**4*mup**2/s/spr*(s-spr)*cf*(-3d0/32*p1p2*p3p4+3d0/32*
     & p1p5*p3p4)
     & +iz2up*iz3dn*sqrtlsprdntp*propwp1p4*propcwp1p4/(s-mbt**2)/pi**3*a
     & lphas*gf**2*mdn**2/s/spr*(s-spr)*cf*(-3d0/64*p1p4*p2p3**2*mbt**2-
     & 3d0/64*p1p4*p2p3**2*mtp**2-3d0/32*p2p3**2*mtp**2*mbt**2)
     & +iz2up*iz3dn*sqrtlsprdntp*propwp1p4*propcwp1p4/(s-mbt**2)/pi**3*a
     & lphas*gf**2*mup**2/s/spr*(s-spr)*cf*(-3d0/64*p1p4*p2p3**2*mbt**2-
     & 3d0/64*p1p4*p2p3**2*mtp**2-3d0/32*p2p3**2*mtp**2*mbt**2)
     & +iz2up*iz3dn*sqrtlsprdntp*propwp1p4*propcwp1p4/(s-mbt**2)/pi**3*a
     & lphas*gf**2*mup**2*mdn**2/s/spr*(s-spr)*cf*(3d0/32*p1p4*p2p3*mbt*
     & *2+3d0/32*p1p4*p2p3*mtp**2+3d0/16*p2p3*mtp**2*mbt**2)
     & +iz2up*iz3dn*sqrtlsprdntp*propwp1p4*propcwp1p4/(s-mbt**2)/pi**3*a
     & lphas*gf**2*mw**2*mdn**2/s/spr*(s-spr)*cf*(3d0/32*p1p2*p2p3*mtp**
     & 2-3d0/64*p1p5*p2p3*mtp**2-3d0/32*p2p3*p2p4*mbt**2+3d0/64*p2p3*p4p
     & 5*mbt**2)
     & +iz2up*iz3dn*sqrtlsprdntp*propwp1p4*propcwp1p4/(s-mbt**2)/pi**3*a
     & lphas*gf**2*mw**2*mup**2/s/spr*(s-spr)*cf*(3d0/32*p1p3*p2p3*mtp**
     & 2-3d0/64*p1p5*p2p3*mtp**2-3d0/32*p2p3*p3p4*mbt**2+3d0/64*p2p3*p4p
     & 5*mbt**2)
     & +iz2up*iz3dn*sqrtlsprdntp*propwp1p4*propcwp1p4/(s-mbt**2)/pi**3*a
     & lphas*gf**2*mw**4/s/spr*(s-spr)*cf*(-3d0/16*p1p2*p2p3*p3p4+3d0/32
     & *p1p2*p2p3*p4p5+3d0/32*p1p5*p2p3*p3p4)
     & +iz2up*sqrtlsprdntp*propwp1p4*propcwp1p4/(s-mbt**2)/pi**3*alphas*
     & gf**2*mdn**2/s/spr*(s-spr)*cf*(-3d0/128*p1p4*p2p3*mbt**2-3d0/128*
     & p1p4*p2p3*mtp**2+3d0/256*p1p4*p3p5*mbt**2+3d0/256*p1p4*p3p5*mtp**
     & 2-3d0/64*p2p3*mtp**2*mbt**2+3d0/128*p3p5*mtp**2*mbt**2)
     & +iz2up*sqrtlsprdntp*propwp1p4*propcwp1p4/(s-mbt**2)/pi**3*alphas*
     & gf**2*mup**2/s/spr*(s-spr)*cf*(-3d0/128*p1p4*p2p3*mbt**2-3d0/128*
     & p1p4*p2p3*mtp**2+3d0/256*p1p4*p3p5*mbt**2+3d0/256*p1p4*p3p5*mtp**
     & 2-3d0/64*p2p3*mtp**2*mbt**2+3d0/128*p3p5*mtp**2*mbt**2)
     & +iz2up*sqrtlsprdntp*propwp1p4*propcwp1p4/(s-mbt**2)/pi**3*alphas*
     & gf**2*mup**2*mdn**2/s/spr*(s-spr)*cf*(-3d0/128*mtp**2*mbt**2-3d0/
     & 256*p1p4*mbt**2-3d0/256*p1p4*mtp**2)
     & +iz2up*sqrtlsprdntp*propwp1p4*propcwp1p4/(s-mbt**2)/pi**3*alphas*
     & gf**2*mup**4/s/spr*(s-spr)*cf*(-3d0/128*mtp**2*mbt**2-3d0/256*p1p
     & 4*mbt**2-3d0/256*p1p4*mtp**2)
     & +iz2up*sqrtlsprdntp*propwp1p4*propcwp1p4/(s-mbt**2)/pi**3*alphas*
     & gf**2*mw**2*mdn**2/s/spr*(s-spr)*cf*(3d0/128*p1p2*mtp**2-3d0/128*
     & p1p5*mtp**2-3d0/128*p2p4*mbt**2+3d0/128*p4p5*mbt**2)
     & +iz2up*sqrtlsprdntp*propwp1p4*propcwp1p4/(s-mbt**2)/pi**3*alphas*
     & gf**2*mw**2*mup**2/s/spr*(s-spr)*cf*(-3d0/128*p1p2*mtp**2-3d0/128
     & *p1p5*mtp**2+3d0/128*p2p4*mbt**2+3d0/128*p4p5*mbt**2)
     & +iz2up*sqrtlsprdntp*propwp1p4*propcwp1p4/(s-mbt**2)/pi**3*alphas*
     & gf**2*mw**4/s/spr*(s-spr)*cf*(3d0/64*p1p2*p2p4-3d0/64*p1p2*p3p4+3
     & d0/64*p1p5*p3p4)
     & +iz3dn**2*sqrtlsprdntp*propwp1p4*propcwp1p4/(s-mbt**2)/pi**3*alph
     & as*gf**2*mdn**4/s/spr*(s-spr)*cf*(-3d0/128*p1p4*p2p3*mbt**2-3d0/1
     & 28*p1p4*p2p3*mtp**2+3d0/128*p1p4*p2p5*mbt**2+3d0/128*p1p4*p2p5*mt
     & p**2-3d0/64*p2p3*mtp**2*mbt**2+3d0/64*p2p5*mtp**2*mbt**2)
     & +iz3dn**2*sqrtlsprdntp*propwp1p4*propcwp1p4/(s-mbt**2)/pi**3*alph
     & as*gf**2*mup**2*mdn**2/s/spr*(s-spr)*cf*(-3d0/128*p1p4*p2p3*mbt**
     & 2-3d0/128*p1p4*p2p3*mtp**2+3d0/128*p1p4*p2p5*mbt**2+3d0/128*p1p4*
     & p2p5*mtp**2-3d0/64*p2p3*mtp**2*mbt**2+3d0/64*p2p5*mtp**2*mbt**2)
     & +iz3dn**2*sqrtlsprdntp*propwp1p4*propcwp1p4/(s-mbt**2)/pi**3*alph
     & as*gf**2*mup**2*mdn**4/s/spr*(s-spr)*cf*(3d0/32*mtp**2*mbt**2+3d0
     & /64*p1p4*mbt**2+3d0/64*p1p4*mtp**2)
     & +iz3dn**2*sqrtlsprdntp*propwp1p4*propcwp1p4/(s-mbt**2)/pi**3*alph
     & as*gf**2*mw**2*mdn**4/s/spr*(s-spr)*cf*(3d0/64*p1p2*mtp**2-3d0/64
     & *p2p4*mbt**2)
     & +iz3dn**2*sqrtlsprdntp*propwp1p4*propcwp1p4/(s-mbt**2)/pi**3*alph
     & as*gf**2*mw**2*mup**2*mdn**2/s/spr*(s-spr)*cf*(3d0/64*p1p3*mtp**2
     & -3d0/64*p1p5*mtp**2-3d0/64*p3p4*mbt**2+3d0/64*p4p5*mbt**2)
     & +iz3dn**2*sqrtlsprdntp*propwp1p4*propcwp1p4/(s-mbt**2)/pi**3*alph
     & as*gf**2*mw**4*mdn**2/s/spr*(s-spr)*cf*(-3d0/32*p1p2*p3p4+3d0/32*
     & p1p2*p4p5)
     & +iz3dn*sqrtlsprdntp*propwp1p4*propcwp1p4/(s-mbt**2)/pi**3*alphas*
     & gf**2*mdn**2/s/spr*(s-spr)*cf*(-3d0/128*p1p4*p2p3*mbt**2-3d0/128*
     & p1p4*p2p3*mtp**2+3d0/256*p1p4*p2p5*mbt**2+3d0/256*p1p4*p2p5*mtp**
     & 2-3d0/64*p2p3*mtp**2*mbt**2+3d0/128*p2p5*mtp**2*mbt**2)
     & +iz3dn*sqrtlsprdntp*propwp1p4*propcwp1p4/(s-mbt**2)/pi**3*alphas*
     & gf**2*mdn**4/s/spr*(s-spr)*cf*(-3d0/128*mtp**2*mbt**2-3d0/256*p1p
     & 4*mbt**2-3d0/256*p1p4*mtp**2)
     & +iz3dn*sqrtlsprdntp*propwp1p4*propcwp1p4/(s-mbt**2)/pi**3*alphas*
     & gf**2*mup**2/s/spr*(s-spr)*cf*(-3d0/128*p1p4*p2p3*mbt**2-3d0/128*
     & p1p4*p2p3*mtp**2+3d0/256*p1p4*p2p5*mbt**2+3d0/256*p1p4*p2p5*mtp**
     & 2-3d0/64*p2p3*mtp**2*mbt**2+3d0/128*p2p5*mtp**2*mbt**2)
     & +iz3dn*sqrtlsprdntp*propwp1p4*propcwp1p4/(s-mbt**2)/pi**3*alphas*
     & gf**2*mup**2*mdn**2/s/spr*(s-spr)*cf*(-3d0/128*mtp**2*mbt**2-3d0/
     & 256*p1p4*mbt**2-3d0/256*p1p4*mtp**2)
     & +iz3dn*sqrtlsprdntp*propwp1p4*propcwp1p4/(s-mbt**2)/pi**3*alphas*
     & gf**2*mw**2*mdn**2/s/spr*(s-spr)*cf*(-3d0/128*p1p3*mtp**2-3d0/128
     & *p1p5*mtp**2+3d0/128*p3p4*mbt**2+3d0/128*p4p5*mbt**2)
     & +iz3dn*sqrtlsprdntp*propwp1p4*propcwp1p4/(s-mbt**2)/pi**3*alphas*
     & gf**2*mw**2*mup**2/s/spr*(s-spr)*cf*(3d0/128*p1p3*mtp**2-3d0/128*
     & p1p5*mtp**2-3d0/128*p3p4*mbt**2+3d0/128*p4p5*mbt**2)
     & +iz3dn*sqrtlsprdntp*propwp1p4*propcwp1p4/(s-mbt**2)/pi**3*alphas*
     & gf**2*mw**4/s/spr*(s-spr)*cf*(-3d0/64*p1p2*p3p4+3d0/64*p1p2*p4p5+
     & 3d0/64*p1p3*p3p4)
     & +sqrtlsprdntp*propwp1p4*propcwp1p4/(s-mbt**2)/pi**3*alphas*gf**2*
     & mdn**2/s/spr*(s-spr)*cf*(-3d0/128*mtp**2*mbt**2-3d0/256*p1p4*mbt*
     & *2-3d0/256*p1p4*mtp**2)
     & +sqrtlsprdntp*propwp1p4*propcwp1p4/(s-mbt**2)/pi**3*alphas*gf**2*
     & mup**2/s/spr*(s-spr)*cf*(-3d0/128*mtp**2*mbt**2-3d0/256*p1p4*mbt*
     & *2-3d0/256*p1p4*mtp**2)

      hard = hard*conhc

      return
      end
