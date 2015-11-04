************************************************************************
* sanc_cc_v1.40 package.
************************************************************************
* File (cc-qcd_ha_23_14__13_15_16.f) is created on Tue Aug  9 23:04:52 MSD 2011.
************************************************************************
* This is the FORTRAN module (cc_qcd_ha_23_14__13_15_16) to calculate
* differential cross-section of the gluon induced
* g + dn -> up + mn + mo^- process.
*
* It is produced by s2n package of SANC (v1.10) Project.
* Copyright (C), SANC Project Team, 2002-2011.
*
* http://sanc.jinr.ru/
* http://pcphsanc.cern.ch/
* E-mail: <sanc@jinr.ru>
************************************************************************
      subroutine cc_qcd_ha_23_14__13_15_16 (s,spr,ph4,costh4,costh5,hard)
      implicit none!
      include 's2n_declare.h'

      real*8 sq,sqspr
      real*8 p1p2,p1p3,p1p4,p1p5,p2p3,p2p4,p2p5,p3p4,p3p5,p4p5
      real*8 ph4,cosph4,sinph4,costh4,sinth4,costh5,sinth5
      real*8 sqrtlsupspr,isqrtlsupspr
      real*8 kappaw
      complex*16 chiwspr,chiwsprc
      real*8 iz1up,iz2dn

      cmw2 = mw2

      sq = dsqrt(s)
      sqspr = dsqrt(spr)

      cosph4 = dcos(ph4)
      sinph4 = dsin(ph4)
      sinth4 = dsqrt(1d0-costh4**2)
      sinth5 = dsqrt(1d0-costh5**2)

      sqrtlsupspr = sqrt(s**2-2d0*s*(rupm2+spr)+(rupm2-spr)**2)
      isqrtlsupspr = 1d0/sqrtlsupspr
      
      kappaw = gf*rwm2/(sqrt(2d0)*4d0*pi)/alpha
      if (irun.eq.0) then
         chiwspr = 4d0*kappaw*spr/(spr-cmw2)
      else
         chiwspr = 4d0*kappaw*spr/(spr-dcmplx(mw**2,-spr*ww/mw))
      endif
      chiwsprc = dconjg(chiwspr)


      p1p2=
     & +costh5*(-1d0/4*(s-spr))
     & +1d0/4*spr-1d0/4*s

      p1p3=
     & +costh4*(-1d0/4*(s-spr)
     & +1d0/4*mmo**2/spr*(s-spr))
     & -1d0/8*(s-spr)+1d0/8*spr-1d0/8*s+1d0/8*mmo**2/s*(s-spr)
     & +1d0/8*mmo**2/s*spr-1d0/8*mmo**2/spr*(s-spr)
     & -1d0/8*mmo**2*s/spr

      p1p4=
     & +costh4*(1d0/4*(s-spr)
     & -1d0/4*mmo**2/spr*(s-spr))-1d0/8*(s-spr)+1d0/8*spr-1d0/8*s-1d0/8*
     & mmo**2/s*(s-spr)
     & -1d0/8*mmo**2/s*spr+1d0/8*mmo**2/spr*(s-spr)
     & +1d0/8*mmo**2*s/spr

      p1p5=
     & +costh5*(1d0/4*(s-spr))
     & +1d0/4*spr-1d0/4*s

      p2p3=
     & +sinph4*sinth4*sinth5*(1d0/4*sq*sqspr-1d0/4*sq*sqspr*mmo**2/spr)
     & +costh4*costh5*(1d0/8*spr+1d0/8*s-1d0/8*mmo**2-1d0/8*mmo**2*s/spr
     & )
     & +costh4*(-1d0/8*(s-spr)
     & +1d0/8*mmo**2/spr*(s-spr))
     & +costh5*(1d0/8*(s-spr)
     & +1d0/8*mmo**2/spr*(s-spr))
     & -1d0/8*spr-1d0/8*s-1d0/8*mmo**2-1d0/8*mmo**2*s/spr

      p2p4=
     & +sinph4*sinth4*sinth5*(-1d0/4*sq*sqspr+1d0/4*sq*sqspr*mmo**2/spr)
     & +costh4*costh5*(-1d0/8*spr-1d0/8*s+1d0/8*mmo**2+1d0/8*mmo**2*s/sp
     & r)
     & +costh4*(1d0/8*(s-spr)
     & -1d0/8*mmo**2/spr*(s-spr))+costh5*(1d0/8*(s-spr)
     & -1d0/8*mmo**2/spr*(s-spr))-1d0/8*spr-1d0/8*s+1d0/8*mmo**2+1d0/8*m
     & mo**2*s/spr

      p2p5=
     & -1d0/2*s

      p3p4=
     & -1d0/2*spr+1d0/2*mmo**2

      p3p5=
     & +sinph4*sinth4*sinth5*(-1d0/4*sq*sqspr+1d0/4*sq*sqspr*mmo**2/spr)
     & +costh4*costh5*(-1d0/8*spr-1d0/8*s+1d0/8*mmo**2+1d0/8*mmo**2*s/sp
     & r)
     & +costh4*(-1d0/8*(s-spr)
     & +1d0/8*mmo**2/spr*(s-spr))
     & +costh5*(-1d0/8*(s-spr)
     & -1d0/8*mmo**2/spr*(s-spr))-1d0/8*spr-1d0/8*s-1d0/8*mmo**2-1d0/8*m
     & mo**2*s/spr

      p4p5=
     & +sinph4*sinth4*sinth5*(1d0/4*sq*sqspr-1d0/4*sq*sqspr*mmo**2/spr)
     & +costh4*costh5*(1d0/8*spr+1d0/8*s-1d0/8*mmo**2-1d0/8*mmo**2*s/spr
     & )
     & +costh4*(1d0/8*(s-spr)
     & -1d0/8*mmo**2/spr*(s-spr))+costh5*(-1d0/8*(s-spr)
     & +1d0/8*mmo**2/spr*(s-spr))
     & -1d0/8*spr-1d0/8*s+1d0/8*mmo**2+1d0/8*mmo**2*s/spr

      iz2dn=
     & +1d0/(1-mdn**2/s)*(1d0/s)

      iz1up=
     & +1d0/(1-mdn**2/s)*1d0/(mup**2/s+1d0/4*sqrtlsupspr**2*sinth5**2/s*
     & *2)*(-1d0/2/s**2*spr+1d0/2/s+1d0/2*mup**2/s**2+1d0/2*sqrtlsupspr*
     & costh5/s**2)

      hard=
     & +iz1up**2*chiwspr*chiwsprc/pi*alpha**2*alphas/spr**3*(s-spr)*cf*(
     & 1d0/16*p1p3*p2p4*mup**2*mmo**2/s**2-1d0/16*p2p4*p3p5*mup**2*mmo**
     & 2/s**2)
     & +iz1up**2*chiwspr*chiwsprc/pi*alpha**2*alphas/spr**2*(s-spr)*cf*(
     & -1d0/16*p1p3*p2p4*mup**2/s**2+1d0/16*p2p4*p3p5*mup**2/s**2)
     & +iz1up*chiwspr*chiwsprc/pi*alpha**2*alphas/spr**3*(s-spr)*cf*(1d0
     & /8*p1p2*p1p3*p2p4*mmo**2/s**3+1d0/16*p1p2*p1p3*p4p5*mmo**2/s**3-1
     & d0/16*p1p2*p2p4*p3p5*mmo**2/s**3+1d0/32*p1p3*p1p4*mmo**2/s**2+1d0
     & /32*p1p3*p2p4*mmo**2/s**2-1d0/32*p2p4*p3p5*mmo**2/s**2)
     & +iz1up*chiwspr*chiwsprc/pi*alpha**2*alphas/spr**2*(s-spr)*cf*(-1d
     & 0/8*p1p2*p1p3*p2p4/s**3-1d0/16*p1p2*p1p3*p4p5/s**3+1d0/16*p1p2*p2
     & p4*p3p5/s**3-1d0/32*p1p3*p1p4/s**2-1d0/32*p1p3*p2p4/s**2+1d0/32*p
     & 2p4*p3p5/s**2)
     & +chiwspr*chiwsprc/pi*alpha**2*alphas/spr**3*(s-spr)*cf*(-1d0/32*p
     & 1p3*p2p4*mmo**2/s**3-1d0/32*p1p3*p4p5*mmo**2/s**3-1d0/32*p2p3*p2p
     & 4*mmo**2/s**3)
     & +chiwspr*chiwsprc/pi*alpha**2*alphas/spr**2*(s-spr)*cf*(1d0/32*p1
     & p3*p2p4/s**3+1d0/32*p1p3*p4p5/s**3+1d0/32*p2p3*p2p4/s**3)

      hard = hard*conhc

      return
      end
