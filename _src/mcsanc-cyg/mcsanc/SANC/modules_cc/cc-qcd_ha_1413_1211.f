************************************************************************
* sanc_cc_v1.40 package.
************************************************************************
* File (cc-qcd_ha_1413_1211.f) is created on Tue Aug  9 22:38:17 MSD 2011.
************************************************************************
* This is the FORTRAN module (cc_qcd_ha_1413_1211) to calculate differential
* hard gluon radiation for the anti-dn + up -> el^+ + en process.
*
* It is produced by s2n package of SANC (v1.10) Project.
* Copyright (C), SANC Project Team, 2002-2011.
*
* http://sanc.jinr.ru/
* http://pcphsanc.cern.ch/
* E-mail: <sanc@jinr.ru>
************************************************************************
      subroutine cc_qcd_ha_1413_1211 (s,spr,ph4,costh4,costh5,hard)
      implicit none!
      include 's2n_declare.h'

      real*8 sq,sqspr
      real*8 p1p2,p1p3,p1p4,p1p5,p2p3,p2p4,p2p5,p3p4,p3p5,p4p5
      real*8 ph4,cosph4,sinph4,costh4,sinth4,costh5,sinth5
      real*8 sqrtlsupdn,isqrtlsupdn
      real*8 kappaw
      complex*16 chiwspr,chiwsprc
      real*8 iz1dn,iz2up

      cmw2 = mw2

      sq = dsqrt(s)
      sqspr = dsqrt(spr)

      cosph4 = dcos(ph4)
      sinph4 = dsin(ph4)
      sinth4 = dsqrt(1d0-costh4**2)
      sinth5 = dsqrt(1d0-costh5**2)

      sqrtlsupdn = sqrt(s**2-2d0*s*(rupm2+rdnm2)+(rupm2-rdnm2)**2)
      isqrtlsupdn = 1d0/sqrtlsupdn
      
      kappaw = gf*rwm2/(sqrt(2d0)*4d0*pi)/alpha
      if (irun.eq.0) then
         chiwspr = 4d0*kappaw*spr/(spr-cmw2)
      else
         chiwspr = 4d0*kappaw*spr/(spr-dcmplx(mw**2,-spr*ww/mw))
      endif
      chiwsprc = dconjg(chiwspr)


      p1p2=
     & -1d0/2*s

      p1p3=
     & +sinph4*sinth4*sinth5*(-1d0/4*sq*sqspr)
     & +costh4*costh5*(1d0/8*spr+1d0/8*s)
     & +costh4*(1d0/8*spr-1d0/8*s)
     & +costh5*(-1d0/8*spr+1d0/8*s)
     & -1d0/8*spr-1d0/8*s

      p1p4=
     & +sinph4*sinth4*sinth5*(1d0/4*sq*sqspr)
     & +costh4*costh5*(-1d0/8*spr-1d0/8*s)
     & +costh4*(-1d0/8*spr+1d0/8*s)
     & +costh5*(-1d0/8*spr+1d0/8*s)
     & -1d0/8*spr-1d0/8*s

      p1p5=
     & +costh5*(1d0/4*spr-1d0/4*s)
     & +1d0/4*spr-1d0/4*s

      p2p3=
     & +sinph4*sinth4*sinth5*(1d0/4*sq*sqspr)
     & +costh4*costh5*(-1d0/8*spr-1d0/8*s)
     & +costh4*(1d0/8*spr-1d0/8*s)
     & +costh5*(1d0/8*spr-1d0/8*s)
     & -1d0/8*spr-1d0/8*s

      p2p4=
     & +sinph4*sinth4*sinth5*(-1d0/4*sq*sqspr)
     & +costh4*costh5*(1d0/8*spr+1d0/8*s)
     & +costh4*(-1d0/8*spr+1d0/8*s)
     & +costh5*(1d0/8*spr-1d0/8*s)
     & -1d0/8*spr-1d0/8*s

      p2p5=
     & +costh5*(-1d0/4*spr+1d0/4*s)
     & +1d0/4*spr-1d0/4*s

      p3p4=
     & -1d0/2*spr

      p3p5=
     & +costh4*(1d0/4*spr-1d0/4*s)
     & +1d0/4*spr-1d0/4*s

      p4p5=
     & +costh4*(-1d0/4*spr+1d0/4*s)
     & +1d0/4*spr-1d0/4*s

      iz1dn=
     & +1d0/(mdn**2/s+1d0/4*sinth5**2*sqrtlsupdn**2/s**2)/(s-spr)*(1d0/2
     & +1d0/2*mdn**2/s-1d0/2*mup**2/s-1d0/2*costh5*sqrtlsupdn/s)

      iz2up=
     & +1d0/(mup**2/s+1d0/4*sinth5**2*sqrtlsupdn**2/s**2)/(s-spr)*(1d0/2
     & -1d0/2*mdn**2/s+1d0/2*mup**2/s+1d0/2*costh5*sqrtlsupdn/s)

      hard=
     & +iz1dn**2*theta_hard(s,spr,omega)*chiwspr*chiwsprc/pi*alpha**2*al
     & phas*(s-spr)*cf*(-1d0/6*p1p3*p2p4*mdn**2/s**2/spr**2+1d0/6*p2p4*p
     & 3p5*mdn**2/s**2/spr**2)
     & +iz1dn*iz2up*theta_hard(s,spr,omega)*chiwspr*chiwsprc/pi*alpha**2
     & *alphas*(s-spr)*cf*(-1d0/3*p1p2*p1p3*p2p4/s**2/spr**2+1d0/6*p1p2*
     & p1p3*p4p5/s**2/spr**2+1d0/6*p1p2*p2p4*p3p5/s**2/spr**2)
     & +iz1dn*chiwspr*chiwsprc/pi*alpha**2*alphas*(s-spr)*cf*(1d0/12*p1p
     & 3*p1p4/s**2/spr**2-1d0/12*p1p3*p2p4/s**2/spr**2+1d0/12*p2p4*p3p5/
     & s**2/spr**2)
     & +iz2up**2*theta_hard(s,spr,omega)*chiwspr*chiwsprc/pi*alpha**2*al
     & phas*(s-spr)*cf*(-1d0/6*p1p3*p2p4*mup**2/s**2/spr**2+1d0/6*p1p3*p
     & 4p5*mup**2/s**2/spr**2)
     & +iz2up*chiwspr*chiwsprc/pi*alpha**2*alphas*(s-spr)*cf*(-1d0/12*p1
     & p3*p2p4/s**2/spr**2+1d0/12*p1p3*p4p5/s**2/spr**2+1d0/12*p2p3*p2p4
     & /s**2/spr**2)

      hard = hard*conhc

      return
      end
