************************************************************************
* sanc_cc_v1.40 package.
************************************************************************
* File (cc-qcd_ha_2214_2113.f) is created on Tue Aug  9 23:03:27 MSD 2011.
************************************************************************
* This is the FORTRAN module (cc_qcd_ha_2214_2113) to calculate differential
* hard gluon radiation for the anti-bt + dn -> anti-tp + up process.
*
* It is produced by s2n package of SANC (v1.10) Project.
* Copyright (C), SANC Project Team, 2002-2011.
*
* http://sanc.jinr.ru/
* http://pcphsanc.cern.ch/
* E-mail: <sanc@jinr.ru>
************************************************************************
      subroutine cc_qcd_ha_2214_2113 (s,spr,ph3,costh3,costh5,hard)
      implicit none!
      include 's2n_declare.h'

      real*8 sq,sqspr
      real*8 p1p2,p1p3,p1p4,p1p5,p2p3,p2p4,p2p5,p3p4,p3p5,p4p5
      real*8 ph3,cosph3,sinph3,costh3,sinth3,costh5,sinth5

      real*8 sqrtlsbtdn,isqrtlsbtdn,sqrtlspruptp,isqrtlspruptp
      complex*16 propiwp2p3,propwp2p3,propcwp2p3,propiwp1p4,propwp1p4,p
     & ropcwp1p4
      real*8 iz1bt,iz2dn,iz3up,iz4tp

      cmw2 = rwm2

      sq = dsqrt(s)
      sqspr = dsqrt(spr)

      cosph3 = dcos(ph3)
      sinph3 = dsin(ph3)
      sinth3 = dsqrt(1d0-costh3**2)
      sinth5 = dsqrt(1d0-costh5**2)

      sqrtlsbtdn = sqrt(s**2-2d0*s*(rbtm2+rdnm2)+(rbtm2-rdnm2)**2)
      isqrtlsbtdn = 1d0/sqrtlsbtdn
      sqrtlspruptp = sqrt(spr**2-2d0*spr*(rupm2+rtpm2)+(rupm2-rtpm2)**2)
      isqrtlspruptp = 1d0/sqrtlspruptp

      p1p2=
     & -1d0/2*s+1d0/2*mbt**2

      p1p3=
     & +sinph3*sinth3*sinth5*(spr-mtp**2)*(s-mbt**2)*(-1d0/4/sq/sqspr)
     & +costh3*(spr-mtp**2)*(-1d0/8+1d0/8*s/spr-1d0/8*mbt**2/s+1d0/8*mbt
     & **2/spr)
     & +costh3*costh5*(spr-mtp**2)*(s-mbt**2)*(1d0/8/s+1d0/8/spr)
     & +costh5*(s-mbt**2)*(-1d0/8+1d0/8/s*spr-1d0/8*mtp**2/s+1d0/8*mtp**
     & 2/spr)
     & -1d0/8*spr-1d0/8*s-1d0/8*mbt**2/s*spr-1d0/8*mbt**2+1d0/8*mtp**2+1
     & d0/8*mtp**2*s/spr+1d0/8*mtp**2*mbt**2/s+1d0/8*mtp**2*mbt**2/spr

      p1p4=
     & +sinph3*sinth3*sinth5*(spr-mtp**2)*(s-mbt**2)*(1d0/4/sq/sqspr)
     & +costh3*(spr-mtp**2)*(1d0/8-1d0/8*s/spr+1d0/8*mbt**2/s-1d0/8*mbt*
     & *2/spr)
     & +costh3*costh5*(spr-mtp**2)*(s-mbt**2)*(-1d0/8/s-1d0/8/spr)
     & +costh5*(s-mbt**2)*(-1d0/8+1d0/8/s*spr+1d0/8*mtp**2/s-1d0/8*mtp**
     & 2/spr)
     & -1d0/8*spr-1d0/8*s-1d0/8*mbt**2/s*spr-1d0/8*mbt**2-1d0/8*mtp**2-1
     & d0/8*mtp**2*s/spr-1d0/8*mtp**2*mbt**2/s-1d0/8*mtp**2*mbt**2/spr

      p1p5=
     & +costh5*(s-mbt**2)*(1d0/4-1d0/4/s*spr)
     & +1d0/4*spr-1d0/4*s+1d0/4*mbt**2/s*spr-1d0/4*mbt**2

      p2p3=
     & +sinph3*sinth3*sinth5*(spr-mtp**2)*(s-mbt**2)*(1d0/4/sq/sqspr)
     & +costh3*(spr-mtp**2)*(-1d0/8+1d0/8*s/spr+1d0/8*mbt**2/s-1d0/8*mbt
     & **2/spr)
     & +costh3*costh5*(spr-mtp**2)*(s-mbt**2)*(-1d0/8/s-1d0/8/spr)
     & +costh5*(s-mbt**2)*(1d0/8-1d0/8/s*spr+1d0/8*mtp**2/s-1d0/8*mtp**2
     & /spr)
     & -1d0/8*spr-1d0/8*s+1d0/8*mbt**2/s*spr+1d0/8*mbt**2+1d0/8*mtp**2+1
     & d0/8*mtp**2*s/spr-1d0/8*mtp**2*mbt**2/s-1d0/8*mtp**2*mbt**2/spr

      p2p4=
     & +sinph3*sinth3*sinth5*(spr-mtp**2)*(s-mbt**2)*(-1d0/4/sq/sqspr)
     & +costh3*(spr-mtp**2)*(1d0/8-1d0/8*s/spr-1d0/8*mbt**2/s+1d0/8*mbt*
     & *2/spr)
     & +costh3*costh5*(spr-mtp**2)*(s-mbt**2)*(1d0/8/s+1d0/8/spr)
     & +costh5*(s-mbt**2)*(1d0/8-1d0/8/s*spr-1d0/8*mtp**2/s+1d0/8*mtp**2
     & /spr)
     & -1d0/8*spr-1d0/8*s+1d0/8*mbt**2/s*spr+1d0/8*mbt**2-1d0/8*mtp**2-1
     & d0/8*mtp**2*s/spr+1d0/8*mtp**2*mbt**2/s+1d0/8*mtp**2*mbt**2/spr

      p2p5=
     & +costh5*(s-mbt**2)*(-1d0/4+1d0/4/s*spr)
     & +1d0/4*spr-1d0/4*s-1d0/4*mbt**2/s*spr+1d0/4*mbt**2

      p3p4=
     & -1d0/2*spr+1d0/2*mtp**2

      p3p5=
     & +costh3*(spr-mtp**2)*(-1d0/4+1d0/4*s/spr)
     & +1d0/4*spr-1d0/4*s-1d0/4*mtp**2+1d0/4*mtp**2*s/spr

      p4p5=
     & +costh3*(spr-mtp**2)*(1d0/4-1d0/4*s/spr)
     & +1d0/4*spr-1d0/4*s+1d0/4*mtp**2-1d0/4*mtp**2*s/spr

      iz1bt=
     & +1d0/(mbt**2/s+1d0/4*sqrtlsbtdn**2*sinth5**2/s**2)/(s-spr)*(1d0/2
     & +1d0/2*mbt**2/s-1d0/2*mdn**2/s+1d0/2*sqrtlsbtdn*costh5/s)

      iz2dn=
     & +1d0/(mdn**2/s+1d0/4*sqrtlsbtdn**2*sinth5**2/s**2)/(s-spr)*(1d0/2
     & -1d0/2*mbt**2/s+1d0/2*mdn**2/s-1d0/2*sqrtlsbtdn*costh5/s)

      iz3up=
     & +1d0/(mup**2/spr+1d0/4*sqrtlspruptp**2*sinth3**2/spr**2)/(s-spr)*
     & (1d0/2-1d0/2*mtp**2/spr+1d0/2*mup**2/spr+1d0/2*sqrtlspruptp*costh
     & 3/spr)

      iz4tp=
     & +1d0/(mtp**2/spr+1d0/4*sqrtlspruptp**2*sinth3**2/spr**2)/(s-spr)*
     & (1d0/2+1d0/2*mtp**2/spr-1d0/2*mup**2/spr-1d0/2*sqrtlspruptp*costh
     & 3/spr)

      propiwp2p3 = (cmw2-2*p2p3)
      propwp2p3 = 1d0/propiwp2p3
      propcwp2p3 = dconjg(propwp2p3)
      propiwp1p4 = (cmw2-mtp**2-mbt**2-2*p1p4)
      propwp1p4 = 1d0/propiwp1p4
      propcwp1p4 = dconjg(propwp1p4)


      hard=
     & +iz1bt**2*theta_hard(s,spr,omega)*propwp2p3*propcwp2p3*(spr-mtp**
     & 2)/(s-mbt**2)/pi**3*alphas*gf**2*mw**4*mbt**2/s/spr*(s-spr)*cf*(-
     & 1d0/4*p1p3*p2p4+1d0/4*p2p4*p3p5)
     & +iz1bt*iz4tp*theta_hard(s,spr,omega)*propwp2p3*propcwp2p3*(spr-mt
     & p**2)/(s-mbt**2)/pi**3*alphas*gf**2*mw**4/s/spr*(s-spr)*cf*(-1d0/
     & 2*p1p3*p1p4*p2p4-1d0/4*p1p3*p1p4*p2p5+1d0/4*p1p4*p2p4*p3p5)
     & +iz1bt*propwp2p3*propcwp2p3*(spr-mtp**2)/(s-mbt**2)/pi**3*alphas*
     & gf**2*mw**4/s/spr*(s-spr)*cf*(-1d0/8*p1p2*p1p3-1d0/8*p1p3*p2p4+1d
     & 0/8*p2p4*p3p5)
     & +iz2dn**2*theta_hard(s,spr,omega)*propwp1p4*propcwp1p4*(spr-mtp**
     & 2)/(s-mbt**2)/pi**3*alphas*gf**2*mw**4*mdn**2/s/spr*(s-spr)*cf*(-
     & 1d0/4*p1p3*p2p4+1d0/4*p1p3*p4p5)
     & +iz2dn*iz3up*theta_hard(s,spr,omega)*propwp1p4*propcwp1p4*(spr-mt
     & p**2)/(s-mbt**2)/pi**3*alphas*gf**2*mw**4/s/spr*(s-spr)*cf*(-1d0/
     & 2*p1p3*p2p3*p2p4+1d0/4*p1p3*p2p3*p4p5-1d0/4*p1p5*p2p3*p2p4)
     & +iz2dn*propwp1p4*propcwp1p4*(spr-mtp**2)/(s-mbt**2)/pi**3*alphas*
     & gf**2*mw**4/s/spr*(s-spr)*cf*(-1d0/8*p1p2*p2p4-1d0/8*p1p3*p2p4+1d
     & 0/8*p1p3*p4p5)
     & +iz3up**2*theta_hard(s,spr,omega)*propwp1p4*propcwp1p4*(spr-mtp**
     & 2)/(s-mbt**2)/pi**3*alphas*gf**2*mw**4*mup**2/s/spr*(s-spr)*cf*(-
     & 1d0/4*p1p3*p2p4-1d0/4*p1p5*p2p4)
     & +iz3up*propwp1p4*propcwp1p4*(spr-mtp**2)/(s-mbt**2)/pi**3*alphas*
     & gf**2*mw**4/s/spr*(s-spr)*cf*(1d0/8*p1p3*p2p4+1d0/8*p1p3*p3p4+1d0
     & /8*p1p5*p2p4)
     & +iz4tp**2*theta_hard(s,spr,omega)*propwp2p3*propcwp2p3*(spr-mtp**
     & 2)/(s-mbt**2)/pi**3*alphas*gf**2*mw**4/s/spr*(s-spr)*cf*(-1d0/4*p
     & 1p3*p2p4*mtp**2-1d0/4*p1p3*p2p5*mtp**2)
     & +iz4tp*propwp2p3*propcwp2p3*(spr-mtp**2)/(s-mbt**2)/pi**3*alphas*
     & gf**2*mw**4/s/spr*(s-spr)*cf*(1d0/8*p1p3*p2p4+1d0/8*p1p3*p2p5+1d0
     & /8*p2p4*p3p4)

      hard = hard*conhc

      return
      end
