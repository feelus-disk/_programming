************************************************************************
* sanc_nc_v1.30 package.
************************************************************************
* File (nc-qcd_ha_23_14__14_4_2.f) is created on Wed Apr 18 13:48:34 MSK 2012.
************************************************************************
* This is the FORTRAN module (nc_qcd_ha_23_14__14_4_2) to calculate
* differential cross-section of the gluon induced
* g + dn -> dn + H + Z process.
*
* It is produced by s2n package of SANC (v1.10) Project.
* Copyright (C), SANC Project Team, 2002-2012.
*
* http://sanc.jinr.ru/
* http://pcphsanc.cern.ch/
* E-mail: <sanc@jinr.ru>
************************************************************************
      subroutine nc_qcd_ha_23_14__14_4_2 (s,spr,ph3,costh3,costh5,hard)
      implicit none!
      include 's2n_declare.h'

      real*8 sq,sqspr
      real*8 p1p2,p1p3,p1p4,p1p5,p2p3,p2p4,p2p5,p3p4,p3p5,p4p5
      real*8 ph3,cosph3,sinph3,costh3,sinth3,costh5,sinth5
      real*8 vf,af
      real*8 sqrtlsprzh,isqrtlsprzh,sqrtlsdnspr,isqrtlsdnspr
      complex*16 propzspr,propizspr,propzsprc
      real*8 iz1dn

      cmz2 = mz2

      af = adn
      vf = vdn

      sq = dsqrt(s)
      sqspr = dsqrt(spr)

      cosph3 = dcos(ph3)
      sinph3 = dsin(ph3)
      sinth3 = dsqrt(1d0-costh3**2)
      sinth5 = dsqrt(1d0-costh5**2)

      if (irun.eq.0) then
         propizspr = (cmz2-spr)
      else
         propizspr = (dcmplx(mz**2,-spr*wz/mz)-spr)
      endif
      propzspr = 1d0/propizspr
      propzsprc = dconjg(propzspr)
      sqrtlsprzh = sqrt(spr**2-2d0*spr*(rzm2+rhm2)+(rzm2-rhm2)**2)
      isqrtlsprzh = 1d0/sqrtlsprzh
      sqrtlsdnspr = sqrt(s**2-2d0*s*(rdnm2+spr)+(rdnm2-spr)**2)
      isqrtlsdnspr = 1d0/sqrtlsdnspr

      p1p2=
     & +costh5*(s-spr)*(-1d0/4)
     & +1d0/4*spr-1d0/4*s

      p1p3=
     & +sqrtlsprzh*costh3*(s-spr)*(1d0/4/spr)
     & +1d0/4*spr-1d0/4*s-1d0/4*mh**2+1d0/4*mh**2*s/spr+1d0/4*mz**2-1d0/
     & 4*mz**2*s/spr

      p1p4=
     & +sqrtlsprzh*costh3*(s-spr)*(-1d0/4/spr)
     & +1d0/4*spr-1d0/4*s+1d0/4*mh**2-1d0/4*mh**2*s/spr-1d0/4*mz**2+1d0/
     & 4*mz**2*s/spr

      p1p5=
     & +costh5*(s-spr)*(1d0/4)
     & +1d0/4*spr-1d0/4*s

      p2p3=
     & +sqrtlsprzh*sinph3*sinth3*sinth5*(-1d0/4*sq*sqspr/spr)
     & +sqrtlsprzh*costh3*(s-spr)*(1d0/8/spr)
     & +sqrtlsprzh*costh3*costh5*(-1d0/8-1d0/8*s/spr)
     & +costh5*(s-spr)*(1d0/8-1d0/8*mh**2/spr+1d0/8*mz**2/spr)
     & -1d0/8*spr-1d0/8*s+1d0/8*mh**2+1d0/8*mh**2*s/spr-1d0/8*mz**2-1d0/
     & 8*mz**2*s/spr

      p2p4=
     & +sqrtlsprzh*sinph3*sinth3*sinth5*(1d0/4*sq*sqspr/spr)
     & +sqrtlsprzh*costh3*(s-spr)*(-1d0/8/spr)
     & +sqrtlsprzh*costh3*costh5*(1d0/8+1d0/8*s/spr)
     & +costh5*(s-spr)*(1d0/8+1d0/8*mh**2/spr-1d0/8*mz**2/spr)
     & -1d0/8*spr-1d0/8*s-1d0/8*mh**2-1d0/8*mh**2*s/spr+1d0/8*mz**2+1d0/
     & 8*mz**2*s/spr

      p2p5=
     & -1d0/2*s

      p3p4=
     & -1d0/2*spr+1d0/2*mh**2+1d0/2*mz**2

      p3p5=
     & +sqrtlsprzh*sinph3*sinth3*sinth5*(1d0/4*sq*sqspr/spr)
     & +sqrtlsprzh*costh3*(s-spr)*(1d0/8/spr)
     & +sqrtlsprzh*costh3*costh5*(1d0/8+1d0/8*s/spr)
     & +costh5*(s-spr)*(-1d0/8+1d0/8*mh**2/spr-1d0/8*mz**2/spr)
     & -1d0/8*spr-1d0/8*s+1d0/8*mh**2+1d0/8*mh**2*s/spr-1d0/8*mz**2-1d0/
     & 8*mz**2*s/spr

      p4p5=
     & +sqrtlsprzh*sinph3*sinth3*sinth5*(-1d0/4*sq*sqspr/spr)
     & +sqrtlsprzh*costh3*(s-spr)*(-1d0/8/spr)
     & +sqrtlsprzh*costh3*costh5*(-1d0/8-1d0/8*s/spr)
     & +costh5*(s-spr)*(-1d0/8-1d0/8*mh**2/spr+1d0/8*mz**2/spr)
     & -1d0/8*spr-1d0/8*s-1d0/8*mh**2-1d0/8*mh**2*s/spr+1d0/8*mz**2+1d0/
     & 8*mz**2*s/spr

      iz1dn=
     & +1d0/(1-mdn**2/s)*1d0/(mdn**2/s+1d0/4*sqrtlsdnspr**2*sinth5**2/s*
     & *2)*(-1d0/2/s**2*spr+1d0/2/s+1d0/2*mdn**2/s**2+1d0/2*sqrtlsdnspr*
     & costh5/s**2)

      hard=
     & +iz1dn**2*sqrtlsprzh*propzspr*propzsprc*(vf**2+af**2)/pi**3*alpha
     & s*g**4/ctw**4*mdn**2/spr*(s-spr)*cf*(1d0/4096*p1p2*mz**2/s**2-1d0
     & /2048*p1p3*p2p3/s**2+1d0/2048*p2p3*p3p5/s**2-1d0/4096*p2p5*mz**2/
     & s**2)
     & +iz1dn*sqrtlsprzh*propzspr*propzsprc*(vf**2+af**2)/pi**3*alphas*g
     & **4/ctw**4/spr*(s-spr)*cf*(-1d0/1024*p1p2*p1p3*p2p3/s**3-1d0/2048
     & *p1p2*p1p3*p3p5/s**3+1d0/2048*p1p2*p2p3*p3p5/s**3+1d0/4096*p1p2*m
     & z**2/s**2+1d0/2048*p1p2**2*mz**2/s**3-1d0/4096*p1p3*p2p3/s**2-1d0
     & /4096*p1p3**2/s**2+1d0/4096*p2p3*p3p5/s**2-1d0/8192*p2p5*mz**2/s*
     & *2)
     & +sqrtlsprzh*propzspr*propzsprc*(vf**2+af**2)/pi**3*alphas*g**4/ct
     & w**4/spr*(s-spr)*cf*(-1d0/4096*p1p2*mz**2/s**3+1d0/4096*p1p3*p2p3
     & /s**3+1d0/4096*p1p3*p3p5/s**3-1d0/8192*p1p5*mz**2/s**3+1d0/4096*p
     & 2p3**2/s**3)

      hard = hard*conhc

      return
      end
