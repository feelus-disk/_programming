************************************************************************
* sanc_nc_v1.30 package.
************************************************************************
* File (nc_ha_1414_42.f) is created on Wed Apr 18 13:48:20 MSK 2012.
************************************************************************
* This is the FORTRAN module (nc_ha_1414_42) to calculate differential
* hard photon Bremsstrahlung for the anti-dn + dn -> H + Z process.
*
* It is produced by s2n package of SANC (v1.10) Project.
* Copyright (C), SANC Project Team, 2002-2012.
*
* http://sanc.jinr.ru/
* http://pcphsanc.cern.ch/
* E-mail: <sanc@jinr.ru>
************************************************************************
      subroutine nc_ha_1414_42 (s,spr,ph3,costh3,costh5,hard)
      implicit none!
      include 's2n_declare.h'

      real*8 af,vf,sq,sqspr
      real*8 p1p2,p1p3,p1p4,p1p5,p2p3,p2p4,p2p5,p3p4,p3p5,p4p5
      real*8 ph3,sinph3,cosph3,costh3,sinth3,costh5,sinth5

      real*8 sqrtlsdndn,isqrtlsdndn,sqrtlsprzh,isqrtlsprzh
      complex*16 propzspr,propizspr,propzsprc
      real*8 iz1dn,iz2dn,iz3h,iz4z

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
      sqrtlsdndn = sqrt(s**2-2d0*s*(rdnm2+rdnm2)+(rdnm2-rdnm2)**2)
      isqrtlsdndn = 1d0/sqrtlsdndn
      sqrtlsprzh = sqrt(spr**2-2d0*spr*(rzm2+rhm2)+(rzm2-rhm2)**2)
      isqrtlsprzh = 1d0/sqrtlsprzh

      iz1dn=
     & +1d0/(mdn**2/s+1d0/4*sinth5**2-sinth5**2*mdn**2/s)/(s-spr)*(1d0/2
     & +1d0/2*costh5*sqrtlsdndn/s)

      iz2dn=
     & +1d0/(mdn**2/s+1d0/4*sinth5**2-sinth5**2*mdn**2/s)/(s-spr)*(1d0/2
     & -1d0/2*costh5*sqrtlsdndn/s)

      p1p2=
     & -1d0/2*s

      p1p3=
     & +(s-spr)*(1d0/8+1d0/8*mh**2/spr-1d0/8*mz**2/spr)
     & +sinph3*sinth3*sinth5*sqrtlsprzh*(-1d0/4*sq/sqspr)
     & +costh3*costh5*sqrtlsprzh*(s-spr)*(1d0/8/spr)
     & +costh3*costh5*sqrtlsprzh*(1d0/4)
     & +costh3*sqrtlsprzh*(s-spr)*(1d0/8/spr)
     & +costh5*(s-spr)*(-1d0/8+1d0/8*mh**2/spr-1d0/8*mz**2/spr)
     & -1d0/4*s+1d0/4*mh**2-1d0/4*mz**2

      p1p4=
     & +(s-spr)*(1d0/8-1d0/8*mh**2/spr+1d0/8*mz**2/spr)
     & +sinph3*sinth3*sinth5*sqrtlsprzh*(1d0/4*sq/sqspr)
     & +costh3*costh5*sqrtlsprzh*(s-spr)*(-1d0/8/spr)
     & +costh3*costh5*sqrtlsprzh*(-1d0/4)
     & +costh3*sqrtlsprzh*(s-spr)*(-1d0/8/spr)
     & +costh5*(s-spr)*(-1d0/8-1d0/8*mh**2/spr+1d0/8*mz**2/spr)
     & -1d0/4*s-1d0/4*mh**2+1d0/4*mz**2

      p2p3=
     & +(s-spr)*(1d0/8+1d0/8*mh**2/spr-1d0/8*mz**2/spr)
     & +sinph3*sinth3*sinth5*sqrtlsprzh*(1d0/4*sq/sqspr)
     & +costh3*costh5*sqrtlsprzh*(s-spr)*(-1d0/8/spr)
     & +costh3*costh5*sqrtlsprzh*(-1d0/4)
     & +costh3*sqrtlsprzh*(s-spr)*(1d0/8/spr)
     & +costh5*(s-spr)*(1d0/8-1d0/8*mh**2/spr+1d0/8*mz**2/spr)
     & -1d0/4*s+1d0/4*mh**2-1d0/4*mz**2

      p2p4=
     & +(s-spr)*(1d0/8-1d0/8*mh**2/spr+1d0/8*mz**2/spr)
     & +sinph3*sinth3*sinth5*sqrtlsprzh*(-1d0/4*sq/sqspr)
     & +costh3*costh5*sqrtlsprzh*(s-spr)*(1d0/8/spr)
     & +costh3*costh5*sqrtlsprzh*(1d0/4)
     & +costh3*sqrtlsprzh*(s-spr)*(-1d0/8/spr)
     & +costh5*(s-spr)*(1d0/8+1d0/8*mh**2/spr-1d0/8*mz**2/spr)
     & -1d0/4*s-1d0/4*mh**2+1d0/4*mz**2

      p3p4=
     & +(s-spr)*(1d0/2)
     & -1d0/2*s+1d0/2*mh**2+1d0/2*mz**2

      p1p5=
     & +(s-spr)*(-1d0/4)
     & +costh5*(s-spr)*(1d0/4)

      p2p5=
     & +(s-spr)*(-1d0/4)
     & +costh5*(s-spr)*(-1d0/4)

      p3p5=
     & +(s-spr)*(-1d0/4+1d0/4*mh**2/spr-1d0/4*mz**2/spr)
     & +costh3*sqrtlsprzh*(s-spr)*(1d0/4/spr)

      p4p5=
     & +(s-spr)*(-1d0/4-1d0/4*mh**2/spr+1d0/4*mz**2/spr)
     & +costh3*sqrtlsprzh*(s-spr)*(-1d0/4/spr)

      hard=
     & +iz1dn**2*theta_hard(s,spr,omega)*propzspr*propzsprc*sqrtlsprzh*(
     & vf**2+af**2)/pi**3*alpha*g**4/ctw**6*qdn**2*mw**2*mdn**2/s**2/spr
     & *(s-spr)*(1d0/1536*p1p2-1d0/768*p1p3*p2p3/mz**2+1d0/768*p2p3*p3p5
     & /mz**2)
     & +iz1dn**2*theta_hard(s,spr,omega)*propzspr*propzsprc*sqrtlsprzh*(
     & vf**2+af**2)/pi**3*alpha*g**4/ctw**6*qdn**2*mw**2*mdn**2/s**2/spr
     & *(s-spr)**2*(1d0/3072)
     & +iz1dn*iz2dn*theta_hard(s,spr,omega)*propzspr*propzsprc*sqrtlsprz
     & h*(vf**2+af**2)/pi**3*alpha*g**4/ctw**6*qdn**2*mw**2/s**2/spr*(s-
     & spr)*(-1d0/384*p1p2*p1p3*p2p3/mz**2+1d0/768*p1p2*p1p3*p3p5/mz**2+
     & 1d0/768*p1p2*p2p3*p3p5/mz**2+1d0/768*p1p2**2)
     & +iz1dn*propzspr*propzsprc*sqrtlsprzh*(vf**2+af**2)/pi**3*alpha*g*
     & *4/ctw**6*qdn**2*mw**2/s**2/spr*(s-spr)*(1d0/1536*p1p2-1d0/1536*p
     & 1p3*p2p3/mz**2+1d0/1536*p1p3**2/mz**2+1d0/1536*p2p3*p3p5/mz**2)
     & +iz1dn*propzspr*propzsprc*sqrtlsprzh*(vf**2+af**2)/pi**3*alpha*g*
     & *4/ctw**6*qdn**2*mw**2/s**2/spr*(s-spr)**2*(1d0/6144)
     & +iz2dn**2*theta_hard(s,spr,omega)*propzspr*propzsprc*sqrtlsprzh*(
     & vf**2+af**2)/pi**3*alpha*g**4/ctw**6*qdn**2*mw**2*mdn**2/s**2/spr
     & *(s-spr)*(1d0/1536*p1p2-1d0/768*p1p3*p2p3/mz**2+1d0/768*p1p3*p3p5
     & /mz**2)
     & +iz2dn**2*theta_hard(s,spr,omega)*propzspr*propzsprc*sqrtlsprzh*(
     & vf**2+af**2)/pi**3*alpha*g**4/ctw**6*qdn**2*mw**2*mdn**2/s**2/spr
     & *(s-spr)**2*(1d0/3072)
     & +iz2dn*propzspr*propzsprc*sqrtlsprzh*(vf**2+af**2)/pi**3*alpha*g*
     & *4/ctw**6*qdn**2*mw**2/s**2/spr*(s-spr)*(1d0/1536*p1p2-1d0/1536*p
     & 1p3*p2p3/mz**2+1d0/1536*p1p3*p3p5/mz**2+1d0/1536*p2p3**2/mz**2)
     & +iz2dn*propzspr*propzsprc*sqrtlsprzh*(vf**2+af**2)/pi**3*alpha*g*
     & *4/ctw**6*qdn**2*mw**2/s**2/spr*(s-spr)**2*(1d0/6144)
     & +propzspr*propzsprc*sqrtlsprzh*(vf**2+af**2)/pi**3*alpha*g**4/ctw
     & **6*qdn**2*mw**2/s**2/spr*(s-spr)*(-1d0/3072)

      hard = hard*conhc*cfprime

      return
      end
