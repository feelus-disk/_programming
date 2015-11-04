************************************************************************
* sanc_cc_v1.60 package.
************************************************************************
* File (cc-qcd_ha_23_14__13_21_22.f) is created on Mon Mar 26 11:57:00 MSK 2012.
************************************************************************
* This is the FORTRAN module (cc_qcd_ha_23_14__13_21_22) to calculate
* differential cross-section of the gluon induced
* g + dn -> up + anti-tp + bt process.
*
* It is produced by s2n package of SANC (v1.10) Project.
* Copyright (C), SANC Project Team, 2002-2012.
*
* http://sanc.jinr.ru/
* http://pcphsanc.cern.ch/
* E-mail: <sanc@jinr.ru>
************************************************************************
      subroutine cc_qcd_ha_23_14__13_21_22 (s,spr,ph3,costh3,costh5,hard)
      implicit none!
      include 's2n_declare.h'

      real*8 sq,sqspr
      real*8 p1p2,p1p3,p1p4,p1p5,p2p3,p2p4,p2p5,p3p4,p3p5,p4p5
      real*8 ph3,cosph3,sinph3,costh3,sinth3,costh5,sinth5
      real*8 sqrtlsprtpbt,isqrtlsprtpbt,sqrtlsupspr,isqrtlsupspr
      real*8 kappaw
      complex*16 chiwspr,chiwsprc
      real*8 iz1dn,iz2up

      cmw2 = mw2

      sq = dsqrt(s)
      sqspr = dsqrt(spr)

      cosph3 = dcos(ph3)
      sinph3 = dsin(ph3)
      sinth3 = dsqrt(1d0-costh3**2)
      sinth5 = dsqrt(1d0-costh5**2)

      sqrtlsprtpbt = sqrt(spr**2-2d0*spr*(rtpm2+rbtm2)+(rtpm2-rbtm2)**2)
      isqrtlsprtpbt = 1d0/sqrtlsprtpbt
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
     & +sqrtlsprtpbt*sinph3*sinth3*sinth5*(-1d0/4*sq*sqspr/spr)
     & +sqrtlsprtpbt*costh3*costh5*(-1d0/8-1d0/8*s/spr)
     & +sqrtlsprtpbt*costh3*(1d0/8/spr*(s-spr))
     & +costh5*(1d0/8*(s-spr)
     & -1d0/8*mbt**2/spr*(s-spr)+1d0/8*mtp**2/spr*(s-spr))
     & -1d0/8*spr-1d0/8*s+1d0/8*mbt**2+1d0/8*mbt**2*s/spr-1d0/8*mtp**2-1
     & d0/8*mtp**2*s/spr

      p1p4=
     & +sqrtlsprtpbt*sinph3*sinth3*sinth5*(1d0/4*sq*sqspr/spr)
     & +sqrtlsprtpbt*costh3*costh5*(1d0/8+1d0/8*s/spr)
     & +sqrtlsprtpbt*costh3*(-1d0/8/spr*(s-spr))
     & +costh5*(1d0/8*(s-spr)
     & +1d0/8*mbt**2/spr*(s-spr)
     & -1d0/8*mtp**2/spr*(s-spr))-1d0/8*spr-1d0/8*s-1d0/8*mbt**2-1d0/8*m
     & bt**2*s/spr+1d0/8*mtp**2+1d0/8*mtp**2*s/spr

      p1p5=
     & -1d0/2*s

      p2p3=
     & +sqrtlsprtpbt*costh3*(1d0/4/spr*(s-spr))
     & +1d0/4*spr-1d0/4*s-1d0/4*mbt**2+1d0/4*mbt**2*s/spr+1d0/4*mtp**2-1
     & d0/4*mtp**2*s/spr

      p2p4=
     & +sqrtlsprtpbt*costh3*(-1d0/4/spr*(s-spr))
     & +1d0/4*spr-1d0/4*s+1d0/4*mbt**2-1d0/4*mbt**2*s/spr-1d0/4*mtp**2+1
     & d0/4*mtp**2*s/spr

      p2p5=
     & +costh5*(1d0/4*(s-spr))
     & +1d0/4*spr-1d0/4*s

      p3p4=
     & -1d0/2*spr+1d0/2*mbt**2+1d0/2*mtp**2

      p3p5=
     & +sqrtlsprtpbt*sinph3*sinth3*sinth5*(1d0/4*sq*sqspr/spr)
     & +sqrtlsprtpbt*costh3*costh5*(1d0/8+1d0/8*s/spr)
     & +sqrtlsprtpbt*costh3*(1d0/8/spr*(s-spr))
     & +costh5*(-1d0/8*(s-spr)
     & +1d0/8*mbt**2/spr*(s-spr)
     & -1d0/8*mtp**2/spr*(s-spr))-1d0/8*spr-1d0/8*s+1d0/8*mbt**2+1d0/8*m
     & bt**2*s/spr-1d0/8*mtp**2-1d0/8*mtp**2*s/spr

      p4p5=
     & +sqrtlsprtpbt*sinph3*sinth3*sinth5*(-1d0/4*sq*sqspr/spr)
     & +sqrtlsprtpbt*costh3*costh5*(-1d0/8-1d0/8*s/spr)
     & +sqrtlsprtpbt*costh3*(-1d0/8/spr*(s-spr))
     & +costh5*(-1d0/8*(s-spr)
     & -1d0/8*mbt**2/spr*(s-spr)+1d0/8*mtp**2/spr*(s-spr))
     & -1d0/8*spr-1d0/8*s-1d0/8*mbt**2-1d0/8*mbt**2*s/spr+1d0/8*mtp**2+1
     & d0/8*mtp**2*s/spr

      iz1dn=
     & +1d0/(1-mdn**2/s)*(1d0/s)

      iz2up=
     & +1d0/(1-mdn**2/s)*1d0/(mup**2/s+1d0/4*sqrtlsupspr**2*sinth5**2/s*
     & *2)*(-1d0/2/s**2*spr+1d0/2/s+1d0/2*mup**2/s**2+1d0/2*sqrtlsupspr*
     & costh5/s**2)

      hard=
     & +iz2up**2*sqrtlsprtpbt*chiwspr*chiwsprc/pi*alpha**2*alphas*mup**2
     & /spr**3*(s-spr)*cf*(-3d0/16*p1p3*p2p4/s**2+3d0/16*p1p3*p4p5/s**2)
     & 
     & +iz2up*sqrtlsprtpbt*chiwspr*chiwsprc/pi*alpha**2*alphas/spr**3*(s
     & -spr)*cf*(-3d0/8*p1p2*p1p3*p2p4/s**3+3d0/16*p1p2*p1p3*p4p5/s**3-3
     & d0/16*p1p2*p2p4*p3p5/s**3-3d0/32*p1p3*p2p4/s**2+3d0/32*p1p3*p4p5/
     & s**2-3d0/32*p2p3*p2p4/s**2)
     & +sqrtlsprtpbt*chiwspr*chiwsprc/pi*alpha**2*alphas/spr**3*(s-spr)*
     & cf*(3d0/32*p1p3*p1p4/s**3+3d0/32*p1p3*p2p4/s**3+3d0/32*p2p4*p3p5/
     & s**3)

      hard = hard*conhc

      return
      end
