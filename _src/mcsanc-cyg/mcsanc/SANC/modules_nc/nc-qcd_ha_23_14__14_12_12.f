************************************************************************
* sanc_nc_v1.30 package.
************************************************************************
* File (nc-qcd_ha_23_14__14_12_12.f) is created on Wed Apr 18 13:40:54 MSK 2012.
************************************************************************
* This is the FORTRAN module (nc_qcd_ha_23_14__14_12_12) to calculate
* differential cross-section of the gluon induced
* g + dn -> dn + el^+ + el^- process.
*
* It is produced by s2n package of SANC (v1.10) Project.
* Copyright (C), SANC Project Team, 2002-2012.
*
* http://sanc.jinr.ru/
* http://pcphsanc.cern.ch/
* E-mail: <sanc@jinr.ru>
************************************************************************
      subroutine nc_qcd_ha_23_14__14_12_12 (s,spr,ph3,costh3,costh5,hard)
      implicit none!
      include 's2n_declare.h'

      real*8 kappaz,sq,sqspr
      real*8 a1z,a2z,v1z,v2z,vaz
      real*8 p1p2,p1p3,p1p4,p1p5,p2p3,p2p4,p2p5,p3p4,p3p5,p4p5
      real*8 ph3,cosph3,sinph3,costh3,costh5,sinth3,sinth5
      complex*16 chizspr,chizsprc
      real*8 sqrtlsdnspr,isqrtlsdnspr
      real*8 iz1dn,iz2dn
      real*8 v0spr,a0spr

      cmz2 = mz2

      sq = dsqrt(s)
      sqspr = dsqrt(spr)

      cosph3 = dcos(ph3)
      sinph3 = dsin(ph3)
      sinth3 = dsqrt(1d0-costh3**2)
      sinth5 = dsqrt(1d0-costh5**2)

      kappaz   = gf*rzm2/(dsqrt(2d0)*8d0*pi)/alpha
      if (irun.eq.0) then
         chizspr = 4d0*kappaz*spr/(spr-cmz2)
      else
         chizspr = 4d0*kappaz*spr/(spr-dcmplx(mz**2,-spr*wz/mz))
      endif
      chizsprc = dconjg(chizspr)

      a1z = adn*ael
      a2z = 4d0*vdn*adn*vel*ael
      v1z = vdn*vel
      v2z = (vdn**2+adn**2)*(vel**2+ael**2)
      vaz = (vdn**2+adn**2)*(vel**2-ael**2)

      sqrtlsdnspr = sqrt(s**2-2d0*s*(rdnm2+spr)+(rdnm2-spr)**2)
      isqrtlsdnspr = 1d0/sqrtlsdnspr
      
      v0spr =
     & +qdn**2*qel**2
     & +qdn*qel*(chizspr+chizsprc)*v1z
     & +chizspr*chizsprc*v2z
      
      a0spr =
     & +qdn*qel*(chizspr+chizsprc)*a1z
     & +chizspr*chizsprc*a2z

      p1p2=
     & +costh5*(-1d0/4*(s-spr))
     & +1d0/4*spr-1d0/4*s

      p1p3=
     & +costh3*(1d0/4*(s-spr))
     & -1d0/8*(s-spr)+1d0/8*spr-1d0/8*s

      p1p4=
     & +costh3*(-1d0/4*(s-spr))
     & -1d0/8*(s-spr)+1d0/8*spr-1d0/8*s

      p1p5=
     & +costh5*(1d0/4*(s-spr))
     & +1d0/4*spr-1d0/4*s

      p2p3=
     & +sinph3*sinth3*sinth5*(-1d0/4*sq*sqspr)
     & +costh3*costh5*(-1d0/8*spr-1d0/8*s)
     & +costh3*(1d0/8*(s-spr))
     & +costh5*(1d0/8*(s-spr))
     & -1d0/8*spr-1d0/8*s

      p2p4=
     & +sinph3*sinth3*sinth5*(1d0/4*sq*sqspr)
     & +costh3*costh5*(1d0/8*spr+1d0/8*s)
     & +costh3*(-1d0/8*(s-spr))
     & +costh5*(1d0/8*(s-spr))
     & -1d0/8*spr-1d0/8*s

      p2p5=
     & -1d0/2*s

      p3p4=
     & -1d0/2*spr

      p3p5=
     & +sinph3*sinth3*sinth5*(1d0/4*sq*sqspr)
     & +costh3*costh5*(1d0/8*spr+1d0/8*s)
     & +costh3*(1d0/8*(s-spr))
     & +costh5*(-1d0/8*(s-spr))
     & -1d0/8*spr-1d0/8*s

      p4p5=
     & +sinph3*sinth3*sinth5*(-1d0/4*sq*sqspr)
     & +costh3*costh5*(-1d0/8*spr-1d0/8*s)
     & +costh3*(-1d0/8*(s-spr))
     & +costh5*(-1d0/8*(s-spr))
     & -1d0/8*spr-1d0/8*s

      iz2dn=
     & +1d0/(1-mdn**2/s)*(1d0/s)

      iz1dn=
     & +1d0/(1-mdn**2/s)*1d0/(mdn**2/s+1d0/4*sqrtlsdnspr**2*sinth5**2/s*
     & *2)*(-1d0/2/s**2*spr+1d0/2/s+1d0/2*mdn**2/s**2+1d0/2*sqrtlsdnspr*
     & costh5/s**2)

      hard=
     & +v0spr/pi*alpha**2*alphas/spr**2*(s-spr)*cf*(1d0/16*p1p3*p2p4/s**
     & 3+1d0/16*p1p3*p4p5/s**3+1d0/16*p1p4*p2p3/s**3+1d0/16*p1p4*p3p5/s*
     & *3+1d0/8*p2p3*p2p4/s**3)
     & +v0spr*iz1dn/pi*alpha**2*alphas/spr**2*(s-spr)*cf*(-1d0/4*p1p2*p1
     & p3*p2p4/s**3-1d0/8*p1p2*p1p3*p4p5/s**3-1d0/4*p1p2*p1p4*p2p3/s**3-
     & 1d0/8*p1p2*p1p4*p3p5/s**3+1d0/8*p1p2*p2p3*p4p5/s**3+1d0/8*p1p2*p2
     & p4*p3p5/s**3-1d0/8*p1p3*p1p4/s**2-1d0/16*p1p3*p2p4/s**2-1d0/16*p1
     & p4*p2p3/s**2+1d0/16*p2p3*p4p5/s**2+1d0/16*p2p4*p3p5/s**2)
     & +v0spr*iz1dn**2/pi*alpha**2*alphas/spr**2*(s-spr)*cf*(-1d0/8*p1p3
     & *p2p4*mdn**2/s**2-1d0/8*p1p4*p2p3*mdn**2/s**2+1d0/8*p2p3*p4p5*mdn
     & **2/s**2+1d0/8*p2p4*p3p5*mdn**2/s**2)
     & +a0spr/pi*alpha**2*alphas/spr**2*(s-spr)*cf*(1d0/16*p1p3*p2p4/s**
     & 3+1d0/16*p1p3*p4p5/s**3-1d0/16*p1p4*p2p3/s**3-1d0/16*p1p4*p3p5/s*
     & *3)
     & +a0spr*iz1dn/pi*alpha**2*alphas/spr**2*(s-spr)*cf*(-1d0/4*p1p2*p1
     & p3*p2p4/s**3-1d0/8*p1p2*p1p3*p4p5/s**3+1d0/4*p1p2*p1p4*p2p3/s**3+
     & 1d0/8*p1p2*p1p4*p3p5/s**3-1d0/8*p1p2*p2p3*p4p5/s**3+1d0/8*p1p2*p2
     & p4*p3p5/s**3-1d0/16*p1p3*p2p4/s**2+1d0/16*p1p4*p2p3/s**2-1d0/16*p
     & 2p3*p4p5/s**2+1d0/16*p2p4*p3p5/s**2)
     & +a0spr*iz1dn**2/pi*alpha**2*alphas/spr**2*(s-spr)*cf*(-1d0/8*p1p3
     & *p2p4*mdn**2/s**2+1d0/8*p1p4*p2p3*mdn**2/s**2-1d0/8*p2p3*p4p5*mdn
     & **2/s**2+1d0/8*p2p4*p3p5*mdn**2/s**2)

      hard = hard*conhc

      return
      end
