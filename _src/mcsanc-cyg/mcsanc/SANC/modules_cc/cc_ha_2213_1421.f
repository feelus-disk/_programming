************************************************************************
* sanc_cc_v1.40 package.
************************************************************************
* File (cc_ha_2213_1421.f) is created on Tue Aug  9 22:59:58 MSD 2011.
************************************************************************
* This is the FORTRAN module (cc_ha_2213_1421) to calculate differential
* hard photon Bremsstrahlung for the bt + up -> dn + tp process.
*
* It is produced by s2n package of SANC (v1.10) Project.
* Copyright (C), SANC Project Team, 2002-2011.
*
* http://sanc.jinr.ru/
* http://pcphsanc.cern.ch/
* E-mail: <sanc@jinr.ru>
************************************************************************
      subroutine cc_ha_2213_1421 (s,spr,ph3,costh3,costh5,hard)
      implicit none!
      include 's2n_declare.h'

      real*8 sq,sqspr,qw
      real*8 p1p2,p1p3,p1p4,p1p5,p2p3,p2p4,p2p5,p3p4,p3p5,p4p5
      real*8 ph3,cosph3,sinph3,costh3,sinth3,costh5,sinth5
      real*8 sqrtlsupbt,isqrtlsupbt,sqrtlsprdntp,isqrtlsprdntp
      complex*16 propiwp2p3,propwp2p3,propcwp2p3,propiwp1p4,propwp1p4,p
     & ropcwp1p4
      real*8 iz1bt,iz2up,iz3dn,iz4tp

      cmw2 = rwm2
      qw = 1d0

      sq = dsqrt(s)
      sqspr = dsqrt(spr)

      cosph3 = dcos(ph3)
      sinph3 = dsin(ph3)
      sinth3 = dsqrt(1d0-costh3**2)
      sinth5 = dsqrt(1d0-costh5**2)

      sqrtlsupbt = sqrt(s**2-2d0*s*(rupm2+rbtm2)+(rupm2-rbtm2)**2)
      isqrtlsupbt = 1d0/sqrtlsupbt
      sqrtlsprdntp = sqrt(spr**2-2d0*spr*(rdnm2+rtpm2)+(rdnm2-rtpm2)**2)
      isqrtlsprdntp = 1d0/sqrtlsprdntp

      p1p2=
     & -1d0/2*s+1d0/2*mbt**2

      p1p4=
     & +sinph3*sinth3*sinth5*(spr-mtp**2)*(-1d0/4/sq/sqspr*sqrtlsupbt)
     & +costh3*(spr-mtp**2)*(1d0/8-1d0/8*s/spr+1d0/8*mbt**2/s-1d0/8*mbt*
     & *2/spr)
     & +costh3*costh5*(spr-mtp**2)*(1d0/8*sqrtlsupbt/s+1d0/8*sqrtlsupbt/
     & spr)
     & +costh5*(1d0/8*sqrtlsupbt-1d0/8*sqrtlsupbt/s*spr-1d0/8*sqrtlsupbt
     & *mtp**2/s+1d0/8*sqrtlsupbt*mtp**2/spr)
     & -1d0/8*spr-1d0/8*s-1d0/8*mbt**2/s*spr-1d0/8*mbt**2-1d0/8*mtp**2-1
     & d0/8*mtp**2*s/spr-1d0/8*mtp**2*mbt**2/s-1d0/8*mtp**2*mbt**2/spr

      p2p4=
     & +sinph3*sinth3*sinth5*(spr-mtp**2)*(1d0/4/sq/sqspr*sqrtlsupbt)
     & +costh3*(spr-mtp**2)*(1d0/8-1d0/8*s/spr-1d0/8*mbt**2/s+1d0/8*mbt*
     & *2/spr)
     & +costh3*costh5*(spr-mtp**2)*(-1d0/8*sqrtlsupbt/s-1d0/8*sqrtlsupbt
     & /spr)
     & +costh5*(-1d0/8*sqrtlsupbt+1d0/8*sqrtlsupbt/s*spr+1d0/8*sqrtlsupb
     & t*mtp**2/s-1d0/8*sqrtlsupbt*mtp**2/spr)
     & -1d0/8*spr-1d0/8*s+1d0/8*mbt**2/s*spr+1d0/8*mbt**2-1d0/8*mtp**2-1
     & d0/8*mtp**2*s/spr+1d0/8*mtp**2*mbt**2/s+1d0/8*mtp**2*mbt**2/spr

      p3p4=
     & -1d0/2*spr+1d0/2*mtp**2

      p1p3=
     & +sinph3*sinth3*sinth5*(spr-mtp**2)*(1d0/4/sq/sqspr*sqrtlsupbt)
     & +costh3*(spr-mtp**2)*(-1d0/8+1d0/8*s/spr-1d0/8*mbt**2/s+1d0/8*mbt
     & **2/spr)
     & +costh3*costh5*(spr-mtp**2)*(-1d0/8*sqrtlsupbt/s-1d0/8*sqrtlsupbt
     & /spr)
     & +costh5*(1d0/8*sqrtlsupbt-1d0/8*sqrtlsupbt/s*spr+1d0/8*sqrtlsupbt
     & *mtp**2/s-1d0/8*sqrtlsupbt*mtp**2/spr)
     & -1d0/8*spr-1d0/8*s-1d0/8*mbt**2/s*spr-1d0/8*mbt**2+1d0/8*mtp**2+1
     & d0/8*mtp**2*s/spr+1d0/8*mtp**2*mbt**2/s+1d0/8*mtp**2*mbt**2/spr

      p2p3=
     & +sinph3*sinth3*sinth5*(spr-mtp**2)*(-1d0/4/sq/sqspr*sqrtlsupbt)
     & +costh3*(spr-mtp**2)*(-1d0/8+1d0/8*s/spr+1d0/8*mbt**2/s-1d0/8*mbt
     & **2/spr)
     & +costh3*costh5*(spr-mtp**2)*(1d0/8*sqrtlsupbt/s+1d0/8*sqrtlsupbt/
     & spr)
     & +costh5*(-1d0/8*sqrtlsupbt+1d0/8*sqrtlsupbt/s*spr-1d0/8*sqrtlsupb
     & t*mtp**2/s+1d0/8*sqrtlsupbt*mtp**2/spr)
     & -1d0/8*spr-1d0/8*s+1d0/8*mbt**2/s*spr+1d0/8*mbt**2+1d0/8*mtp**2+1
     & d0/8*mtp**2*s/spr-1d0/8*mtp**2*mbt**2/s-1d0/8*mtp**2*mbt**2/spr

      p1p5=
     & +costh5*(-1d0/4*sqrtlsupbt+1d0/4*sqrtlsupbt/s*spr)
     & +1d0/4*spr-1d0/4*s+1d0/4*mbt**2/s*spr-1d0/4*mbt**2

      p2p5=
     & +costh5*(1d0/4*sqrtlsupbt-1d0/4*sqrtlsupbt/s*spr)
     & +1d0/4*spr-1d0/4*s-1d0/4*mbt**2/s*spr+1d0/4*mbt**2

      p3p5=
     & +costh3*(spr-mtp**2)*(-1d0/4+1d0/4*s/spr)
     & +1d0/4*spr-1d0/4*s-1d0/4*mtp**2+1d0/4*mtp**2*s/spr

      p4p5=
     & +costh3*(spr-mtp**2)*(1d0/4-1d0/4*s/spr)
     & +1d0/4*spr-1d0/4*s+1d0/4*mtp**2-1d0/4*mtp**2*s/spr

      iz1bt=
     & +1d0/(1d0/4+1d0/2*mbt**2/s+1d0/4*mbt**4/s**2-1d0/2*mup**2/s-1d0/2
     & *mup**2*mbt**2/s**2+1d0/4*mup**4/s**2+1d0/4*sinth5**2*sqrtlsupbt*
     & *2/s**2-1d0/4*sqrtlsupbt**2/s**2)/(s-spr)*(1d0/2+1d0/2*mbt**2/s-1
     & d0/2*mup**2/s-1d0/2*costh5*sqrtlsupbt/s)

      iz2up=
     & +1d0/(1d0/4-1d0/2*mbt**2/s+1d0/4*mbt**4/s**2+1d0/2*mup**2/s-1d0/2
     & *mup**2*mbt**2/s**2+1d0/4*mup**4/s**2+1d0/4*sinth5**2*sqrtlsupbt*
     & *2/s**2-1d0/4*sqrtlsupbt**2/s**2)/(s-spr)*(1d0/2-1d0/2*mbt**2/s+1
     & d0/2*mup**2/s+1d0/2*costh5*sqrtlsupbt/s)

      iz3dn=
     & +1d0/(mdn**2/spr+1d0/4*sqrtlsprdntp**2*sinth3**2/spr**2)/(s-spr)*
     & (1d0/2-1d0/2*mtp**2/spr+1d0/2*mdn**2/spr+1d0/2*sqrtlsprdntp*costh
     & 3/spr)

      iz4tp=
     & +1d0/(mtp**2/spr+1d0/4*sqrtlsprdntp**2*sinth3**2/spr**2)/(s-spr)*
     & (1d0/2+1d0/2*mtp**2/spr-1d0/2*mdn**2/spr-1d0/2*sqrtlsprdntp*costh
     & 3/spr)

      propiwp2p3 = (cmw2-2*p2p3)
      propwp2p3 = 1d0/propiwp2p3
      propcwp2p3 = dconjg(propwp2p3)
      propiwp1p4 = (cmw2-mtp**2-mbt**2-2*p1p4)
      propwp1p4 = 1d0/propiwp1p4
      propcwp1p4 = dconjg(propwp1p4)


      hardisr=
     & +iz1bt**2*theta_hard(s,spr,omega)*propwp2p3*propcwp2p3*(spr-mtp**
     & 2)/(s-mbt**2)/pi**3*alpha*gf**2*qbt**2*mw**4*mbt**2/s/spr*(s-spr)
     & *(-1d0/4*p1p2*p3p4+1d0/4*p2p5*p3p4)
     & +iz1bt*iz2up*theta_hard(s,spr,omega)*propwp1p4*propcwp2p3*(spr-mt
     & p**2)/(s-mbt**2)/pi**3*alpha*gf**2*qup*qbt*mw**4/s/spr*(s-spr)*(1
     & d0/4*p1p2**2*p3p4)
     & +iz1bt*iz2up*theta_hard(s,spr,omega)*propwp2p3*propcwp1p4*(spr-mt
     & p**2)/(s-mbt**2)/pi**3*alpha*gf**2*qup*qbt*mw**4/s/spr*(s-spr)*(1
     & d0/4*p1p2**2*p3p4)
     & +iz1bt*propwp1p4*propcwp2p3*(spr-mtp**2)/(s-mbt**2)/pi**3*alpha*g
     & f**2*qup*qbt*mw**4/s/spr*(s-spr)*(1d0/8*p1p2*p3p4)
     & +iz1bt*propwp1p4*propcwp2p3*(spr-mtp**2)/(s-mbt**2)/pi**3*alpha*g
     & f**2*qup*qbt*mw**4*mbt**2/s/spr*(s-spr)*(1d0/16*p3p4)
     & +iz1bt*propwp2p3*propcwp1p4*(spr-mtp**2)/(s-mbt**2)/pi**3*alpha*g
     & f**2*qup*qbt*mw**4/s/spr*(s-spr)*(1d0/8*p1p2*p3p4)
     & +iz1bt*propwp2p3*propcwp1p4*(spr-mtp**2)/(s-mbt**2)/pi**3*alpha*g
     & f**2*qup*qbt*mw**4*mbt**2/s/spr*(s-spr)*(1d0/16*p3p4)
     & +iz1bt*propwp2p3*propcwp2p3*(spr-mtp**2)/(s-mbt**2)/pi**3*alpha*g
     & f**2*qbt**2*mw**4/s/spr*(s-spr)*(1d0/8*p2p5*p3p4)
     & +iz2up**2*theta_hard(s,spr,omega)*propwp1p4*propcwp1p4*(spr-mtp**
     & 2)/(s-mbt**2)/pi**3*alpha*gf**2*qup**2*mw**4*mup**2/s/spr*(s-spr)
     & *(-1d0/4*p1p2*p3p4+1d0/4*p1p5*p3p4)
     & +iz2up*propwp1p4*propcwp1p4*(spr-mtp**2)/(s-mbt**2)/pi**3*alpha*g
     & f**2*qup**2*mw**4/s/spr*(s-spr)*(1d0/8*p1p5*p3p4)
     & +iz2up*propwp1p4*propcwp2p3*(spr-mtp**2)/(s-mbt**2)/pi**3*alpha*g
     & f**2*qup*qbt*mw**4/s/spr*(s-spr)*(1d0/8*p1p2*p3p4)
     & +iz2up*propwp2p3*propcwp1p4*(spr-mtp**2)/(s-mbt**2)/pi**3*alpha*g
     & f**2*qup*qbt*mw**4/s/spr*(s-spr)*(1d0/8*p1p2*p3p4)
     & +propwp1p4*propcwp2p3*(spr-mtp**2)/(s-mbt**2)/pi**3*alpha*gf**2*q
     & up*qbt*mw**4/s/spr*(s-spr)*(1d0/16*p3p4)
     & +propwp2p3*propcwp1p4*(spr-mtp**2)/(s-mbt**2)/pi**3*alpha*gf**2*q
     & up*qbt*mw**4/s/spr*(s-spr)*(1d0/16*p3p4)

      hardfsr=
     & +iz3dn**2*theta_hard(s,spr,omega)*propwp1p4*propcwp1p4*(spr-mtp**
     & 2)/(s-mbt**2)/pi**3*alpha*gf**2*qdn**2*mw**4*mdn**2/s/spr*(s-spr)
     & *(-1d0/4*p1p2*p3p4-1d0/4*p1p2*p4p5)
     & +iz3dn*iz4tp*theta_hard(s,spr,omega)*propwp1p4*propcwp2p3*(spr-mt
     & p**2)/(s-mbt**2)/pi**3*alpha*gf**2*qdn*qtp*mw**4/s/spr*(s-spr)*(1
     & d0/4*p1p2*p3p4**2)
     & +iz3dn*iz4tp*theta_hard(s,spr,omega)*propwp2p3*propcwp1p4*(spr-mt
     & p**2)/(s-mbt**2)/pi**3*alpha*gf**2*qdn*qtp*mw**4/s/spr*(s-spr)*(1
     & d0/4*p1p2*p3p4**2)
     & +iz3dn*propwp1p4*propcwp1p4*(spr-mtp**2)/(s-mbt**2)/pi**3*alpha*g
     & f**2*qdn**2*mw**4/s/spr*(s-spr)*(1d0/8*p1p2*p4p5)
     & +iz3dn*propwp1p4*propcwp2p3*(spr-mtp**2)/(s-mbt**2)/pi**3*alpha*g
     & f**2*qdn*qtp*mw**4/s/spr*(s-spr)*(-1d0/8*p1p2*p3p4)
     & +iz3dn*propwp2p3*propcwp1p4*(spr-mtp**2)/(s-mbt**2)/pi**3*alpha*g
     & f**2*qdn*qtp*mw**4/s/spr*(s-spr)*(-1d0/8*p1p2*p3p4)
     & +iz4tp**2*theta_hard(s,spr,omega)*propwp2p3*propcwp2p3*(spr-mtp**
     & 2)/(s-mbt**2)/pi**3*alpha*gf**2*qtp**2*mw**4/s/spr*(s-spr)*(-1d0/
     & 4*p1p2*p3p4*mtp**2-1d0/4*p1p2*p3p5*mtp**2)
     & +iz4tp*propwp1p4*propcwp2p3*(spr-mtp**2)/(s-mbt**2)/pi**3*alpha*g
     & f**2*qdn*qtp*mw**4/s/spr*(s-spr)*(-1d0/8*p1p2*p3p4-1d0/16*p1p2*mt
     & p**2)
     & +iz4tp*propwp2p3*propcwp1p4*(spr-mtp**2)/(s-mbt**2)/pi**3*alpha*g
     & f**2*qdn*qtp*mw**4/s/spr*(s-spr)*(-1d0/8*p1p2*p3p4-1d0/16*p1p2*mt
     & p**2)
     & +iz4tp*propwp2p3*propcwp2p3*(spr-mtp**2)/(s-mbt**2)/pi**3*alpha*g
     & f**2*qtp**2*mw**4/s/spr*(s-spr)*(1d0/8*p1p2*p3p5)
     & +propwp1p4*propcwp2p3*(spr-mtp**2)/(s-mbt**2)/pi**3*alpha*gf**2*q
     & dn*qtp*mw**4/s/spr*(s-spr)*(1d0/16*p1p2)
     & +propwp2p3*propcwp1p4*(spr-mtp**2)/(s-mbt**2)/pi**3*alpha*gf**2*q
     & dn*qtp*mw**4/s/spr*(s-spr)*(1d0/16*p1p2)

      hardifi=
     & +iz1bt*iz3dn*theta_hard(s,spr,omega)*propwp1p4*propcwp2p3*(spr-mt
     & p**2)/(s-mbt**2)/pi**3*alpha*gf**2*qdn*qbt*mw**4/s/spr*(s-spr)*(-
     & 1d0/4*p1p2*p1p3*p3p4-1d0/8*p1p2*p1p3*p4p5+1d0/8*p1p3*p2p5*p3p4)
     & +iz1bt*iz3dn*theta_hard(s,spr,omega)*propwp2p3*propcwp1p4*(spr-mt
     & p**2)/(s-mbt**2)/pi**3*alpha*gf**2*qdn*qbt*mw**4/s/spr*(s-spr)*(-
     & 1d0/4*p1p2*p1p3*p3p4-1d0/8*p1p2*p1p3*p4p5+1d0/8*p1p3*p2p5*p3p4)
     & +iz1bt*iz4tp*theta_hard(s,spr,omega)*propwp2p3*propcwp2p3*(spr-mt
     & p**2)/(s-mbt**2)/pi**3*alpha*gf**2*qtp*qbt*mw**4/s/spr*(s-spr)*(-
     & 1d0/2*p1p2*p1p4*p3p4-1d0/4*p1p2*p1p4*p3p5+1d0/4*p1p4*p2p5*p3p4)
     & +iz1bt*propwp1p4*propcwp2p3*(spr-mtp**2)/(s-mbt**2)/pi**3*alpha*g
     & f**2*qdn*qbt*mw**4/s/spr*(s-spr)*(-1d0/16*p1p2*p1p4-1d0/16*p1p2*p
     & 3p4)
     & +iz1bt*propwp2p3*propwp1p4*propcwp2p3*(spr-mtp**2)/(s-mbt**2)/pi*
     & *3*alpha*gf**2*qw*qbt*mw**4/s/spr*(s-spr)*(-1d0/8*p1p2*p1p3*p4p5+
     & 1d0/4*p1p2*p1p4*p3p4+1d0/8*p1p2*p1p4*p3p5-1d0/8*p1p2*p3p4*p4p5-1d
     & 0/8*p1p4*p2p5*p3p4)
     & +iz1bt*propwp2p3*propwp1p4*propcwp2p3*(spr-mtp**2)/(s-mbt**2)/pi*
     & *3*alpha*gf**2*qw*qbt*mw**4*mbt**2/s/spr*(s-spr)*(1d0/4*p1p2*p3p4
     & -1d0/4*p2p5*p3p4)
     & +iz1bt*propwp2p3*propcwp1p4*(spr-mtp**2)/(s-mbt**2)/pi**3*alpha*g
     & f**2*qdn*qbt*mw**4/s/spr*(s-spr)*(-1d0/16*p1p2*p1p4-1d0/16*p1p2*p
     & 3p4)
     & +iz1bt*propwp2p3*propcwp2p3*(spr-mtp**2)/(s-mbt**2)/pi**3*alpha*g
     & f**2*qtp*qbt*mw**4/s/spr*(s-spr)*(-1d0/8*p1p2*p1p3-1d0/8*p1p2*p3p
     & 4)
     & +iz1bt*propwp2p3*propcwp2p3*propcwp1p4*(spr-mtp**2)/(s-mbt**2)/pi
     & **3*alpha*gf**2*qw*qbt*mw**4/s/spr*(s-spr)*(-1d0/8*p1p2*p1p3*p4p5
     & +1d0/4*p1p2*p1p4*p3p4+1d0/8*p1p2*p1p4*p3p5-1d0/8*p1p2*p3p4*p4p5-1
     & d0/8*p1p4*p2p5*p3p4)
     & +iz1bt*propwp2p3*propcwp2p3*propcwp1p4*(spr-mtp**2)/(s-mbt**2)/pi
     & **3*alpha*gf**2*qw*qbt*mw**4*mbt**2/s/spr*(s-spr)*(1d0/4*p1p2*p3p
     & 4-1d0/4*p2p5*p3p4)
     & +iz2up*iz3dn*theta_hard(s,spr,omega)*propwp1p4*propcwp1p4*(spr-mt
     & p**2)/(s-mbt**2)/pi**3*alpha*gf**2*qup*qdn*mw**4/s/spr*(s-spr)*(-
     & 1d0/2*p1p2*p2p3*p3p4-1d0/4*p1p2*p2p3*p4p5+1d0/4*p1p5*p2p3*p3p4)
     & +iz2up*iz4tp*theta_hard(s,spr,omega)*propwp1p4*propcwp2p3*(spr-mt
     & p**2)/(s-mbt**2)/pi**3*alpha*gf**2*qup*qtp*mw**4/s/spr*(s-spr)*(-
     & 1d0/4*p1p2*p2p4*p3p4-1d0/8*p1p2*p2p4*p3p5+1d0/8*p1p5*p2p4*p3p4)
     & +iz2up*iz4tp*theta_hard(s,spr,omega)*propwp2p3*propcwp1p4*(spr-mt
     & p**2)/(s-mbt**2)/pi**3*alpha*gf**2*qup*qtp*mw**4/s/spr*(s-spr)*(-
     & 1d0/4*p1p2*p2p4*p3p4-1d0/8*p1p2*p2p4*p3p5+1d0/8*p1p5*p2p4*p3p4)
     & +iz2up*propwp1p4*propcwp1p4*(spr-mtp**2)/(s-mbt**2)/pi**3*alpha*g
     & f**2*qup*qdn*mw**4/s/spr*(s-spr)*(-1d0/8*p1p2*p2p4-1d0/8*p1p2*p3p
     & 4)
     & +iz2up*propwp1p4*propcwp2p3*(spr-mtp**2)/(s-mbt**2)/pi**3*alpha*g
     & f**2*qup*qtp*mw**4/s/spr*(s-spr)*(-1d0/16*p1p2*p2p3-1d0/16*p1p2*p
     & 3p4)
     & +iz2up*propwp1p4*propcwp2p3*propcwp1p4*(spr-mtp**2)/(s-mbt**2)/pi
     & **3*alpha*gf**2*qw*qup*mw**4/s/spr*(s-spr)*(1d0/4*p1p2*p1p5*p3p4-
     & 1d0/8*p1p2*p2p3*p4p5+1d0/4*p1p2*p2p4*p3p4+1d0/8*p1p2*p2p4*p3p5-1d
     & 0/8*p1p2*p3p4*p4p5-1d0/4*p1p2**2*p3p4-1d0/8*p1p5*p2p4*p3p4)
     & +iz2up*propwp2p3*propwp1p4*propcwp1p4*(spr-mtp**2)/(s-mbt**2)/pi*
     & *3*alpha*gf**2*qw*qup*mw**4/s/spr*(s-spr)*(1d0/4*p1p2*p1p5*p3p4-1
     & d0/8*p1p2*p2p3*p4p5+1d0/4*p1p2*p2p4*p3p4+1d0/8*p1p2*p2p4*p3p5-1d0
     & /8*p1p2*p3p4*p4p5-1d0/4*p1p2**2*p3p4-1d0/8*p1p5*p2p4*p3p4)
     & +iz2up*propwp2p3*propcwp1p4*(spr-mtp**2)/(s-mbt**2)/pi**3*alpha*g
     & f**2*qup*qtp*mw**4/s/spr*(s-spr)*(-1d0/16*p1p2*p2p3-1d0/16*p1p2*p
     & 3p4)
     & +iz3dn*propwp1p4*propcwp1p4*(spr-mtp**2)/(s-mbt**2)/pi**3*alpha*g
     & f**2*qup*qdn*mw**4/s/spr*(s-spr)*(1d0/8*p1p2*p3p4+1d0/8*p1p3*p3p4
     & )
     & +iz3dn*propwp1p4*propcwp2p3*(spr-mtp**2)/(s-mbt**2)/pi**3*alpha*g
     & f**2*qdn*qbt*mw**4/s/spr*(s-spr)*(1d0/16*p1p2*p3p4+1d0/16*p2p3*p3
     & p4)
     & +iz3dn*propwp1p4*propcwp2p3*propcwp1p4*(spr-mtp**2)/(s-mbt**2)/pi
     & **3*alpha*gf**2*qw*qdn*mw**4/s/spr*(s-spr)*(1d0/4*p1p2*p1p3*p3p4+
     & 1d0/8*p1p2*p1p3*p4p5+1d0/8*p1p2*p1p5*p3p4-1d0/4*p1p2*p3p4*p4p5-1d
     & 0/4*p1p2*p3p4**2-1d0/8*p1p3*p2p5*p3p4+1d0/8*p1p5*p2p3*p3p4)
     & +iz3dn*propwp2p3*propwp1p4*propcwp1p4*(spr-mtp**2)/(s-mbt**2)/pi*
     & *3*alpha*gf**2*qw*qdn*mw**4/s/spr*(s-spr)*(1d0/4*p1p2*p1p3*p3p4+1
     & d0/8*p1p2*p1p3*p4p5+1d0/8*p1p2*p1p5*p3p4-1d0/4*p1p2*p3p4*p4p5-1d0
     & /4*p1p2*p3p4**2-1d0/8*p1p3*p2p5*p3p4+1d0/8*p1p5*p2p3*p3p4)
     & +iz3dn*propwp2p3*propcwp1p4*(spr-mtp**2)/(s-mbt**2)/pi**3*alpha*g
     & f**2*qdn*qbt*mw**4/s/spr*(s-spr)*(1d0/16*p1p2*p3p4+1d0/16*p2p3*p3
     & p4)
     & +iz4tp*propwp1p4*propcwp2p3*(spr-mtp**2)/(s-mbt**2)/pi**3*alpha*g
     & f**2*qup*qtp*mw**4/s/spr*(s-spr)*(1d0/16*p1p2*p3p4+1d0/16*p1p4*p3
     & p4)
     & +iz4tp*propwp2p3*propwp1p4*propcwp2p3*(spr-mtp**2)/(s-mbt**2)/pi*
     & *3*alpha*gf**2*qw*qtp*mw**4/s/spr*(s-spr)*(1d0/4*p1p2*p1p4*p3p4+1
     & d0/8*p1p2*p1p4*p3p5+1d0/8*p1p2*p1p5*p3p4+1d0/4*p1p2*p3p4*mtp**2+1
     & d0/4*p1p2*p3p5*mtp**2-1d0/8*p1p4*p2p5*p3p4+1d0/8*p1p5*p2p4*p3p4)
     & +iz4tp*propwp2p3*propcwp1p4*(spr-mtp**2)/(s-mbt**2)/pi**3*alpha*g
     & f**2*qup*qtp*mw**4/s/spr*(s-spr)*(1d0/16*p1p2*p3p4+1d0/16*p1p4*p3
     & p4)
     & +iz4tp*propwp2p3*propcwp2p3*(spr-mtp**2)/(s-mbt**2)/pi**3*alpha*g
     & f**2*qtp*qbt*mw**4/s/spr*(s-spr)*(1d0/8*p1p2*p3p4+1d0/8*p2p4*p3p4
     & )
     & +iz4tp*propwp2p3*propcwp2p3*propcwp1p4*(spr-mtp**2)/(s-mbt**2)/pi
     & **3*alpha*gf**2*qw*qtp*mw**4/s/spr*(s-spr)*(1d0/4*p1p2*p1p4*p3p4+
     & 1d0/8*p1p2*p1p4*p3p5+1d0/8*p1p2*p1p5*p3p4+1d0/4*p1p2*p3p4*mtp**2+
     & 1d0/4*p1p2*p3p5*mtp**2-1d0/8*p1p4*p2p5*p3p4+1d0/8*p1p5*p2p4*p3p4)
     & 
     & +propwp1p4*propcwp2p3*propcwp1p4*(spr-mtp**2)/(s-mbt**2)/pi**3*al
     & pha*gf**2*qw*qdn*mw**4/s/spr*(s-spr)*(1d0/16*p1p2*p1p4+1d0/8*p1p2
     & *p3p4+1d0/8*p1p2*p4p5+1d0/16*p1p2*mtp**2)
     & +propwp1p4*propcwp2p3*propcwp1p4*(spr-mtp**2)/(s-mbt**2)/pi**3*al
     & pha*gf**2*qw*qup*mw**4/s/spr*(s-spr)*(-1d0/8*p1p2*p3p4-1d0/16*p1p
     & 4*p3p4+1d0/8*p1p5*p3p4)
     & +propwp1p4*propcwp2p3*propcwp1p4*(spr-mtp**2)/(s-mbt**2)/pi**3*al
     & pha*gf**2*qw*qup*mw**4*mbt**2/s/spr*(s-spr)*(-1d0/16*p3p4)
     & +propwp2p3*propwp1p4*propcwp1p4*(spr-mtp**2)/(s-mbt**2)/pi**3*alp
     & ha*gf**2*qw*qdn*mw**4/s/spr*(s-spr)*(1d0/16*p1p2*p1p4+1d0/8*p1p2*
     & p3p4+1d0/8*p1p2*p4p5+1d0/16*p1p2*mtp**2)
     & +propwp2p3*propwp1p4*propcwp1p4*(spr-mtp**2)/(s-mbt**2)/pi**3*alp
     & ha*gf**2*qw*qup*mw**4/s/spr*(s-spr)*(-1d0/8*p1p2*p3p4-1d0/16*p1p4
     & *p3p4+1d0/8*p1p5*p3p4)
     & +propwp2p3*propwp1p4*propcwp1p4*(spr-mtp**2)/(s-mbt**2)/pi**3*alp
     & ha*gf**2*qw*qup*mw**4*mbt**2/s/spr*(s-spr)*(-1d0/16*p3p4)
     & +propwp2p3*propwp1p4*propcwp2p3*(spr-mtp**2)/(s-mbt**2)/pi**3*alp
     & ha*gf**2*qw*qbt*mw**4/s/spr*(s-spr)*(-1d0/16*p2p4*p3p4-1d0/8*p2p5
     & *p3p4)
     & +propwp2p3*propwp1p4*propcwp2p3*(spr-mtp**2)/(s-mbt**2)/pi**3*alp
     & ha*gf**2*qw*qtp*mw**4/s/spr*(s-spr)*(1d0/16*p1p2*p1p3-1d0/8*p1p2*
     & p3p5)
     & +propwp2p3*propwp1p4*propcwp2p3*propcwp1p4*(spr-mtp**2)/(s-mbt**2
     & )/pi**3*alpha*gf**2*qw**2*mw**4/s/spr*(s-spr)*(1d0/4*p1p2*p1p3*p4
     & p5-1d0/2*p1p2*p1p4*p3p4-1d0/4*p1p2*p1p4*p3p5-1d0/4*p1p2*p3p4*mtp*
     & *2-1d0/4*p1p2*p3p5*p4p5-1d0/4*p1p2*p3p5*mtp**2+1d0/4*p1p4*p2p5*p3
     & p4-1d0/4*p1p5*p2p4*p3p4-1d0/4*p1p5*p2p5*p3p4)
     & +propwp2p3*propwp1p4*propcwp2p3*propcwp1p4*(spr-mtp**2)/(s-mbt**2
     & )/pi**3*alpha*gf**2*qw**2*mw**4*mbt**2/s/spr*(s-spr)*(-1d0/4*p1p2
     & *p3p4+1d0/4*p2p5*p3p4)
     & +propwp2p3*propcwp2p3*propcwp1p4*(spr-mtp**2)/(s-mbt**2)/pi**3*al
     & pha*gf**2*qw*qbt*mw**4/s/spr*(s-spr)*(-1d0/16*p2p4*p3p4-1d0/8*p2p
     & 5*p3p4)
     & +propwp2p3*propcwp2p3*propcwp1p4*(spr-mtp**2)/(s-mbt**2)/pi**3*al
     & pha*gf**2*qw*qtp*mw**4/s/spr*(s-spr)*(1d0/16*p1p2*p1p3-1d0/8*p1p2
     & *p3p5)

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
