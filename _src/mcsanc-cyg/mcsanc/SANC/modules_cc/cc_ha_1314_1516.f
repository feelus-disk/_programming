************************************************************************
* sanc_cc_v1.40 package.
************************************************************************
* File (cc_ha_1314_1516.f) is created on Tue Aug  9 22:37:43 MSD 2011.
************************************************************************
* This is the FORTRAN module (cc_ha_1314_1516) to calculate differential
* hard photon Bremsstrahlung for the anti-up + dn -> mn + mo^- process.
*
* It is produced by s2n package of SANC (v1.10) Project.
* Copyright (C), SANC Project Team, 2002-2011.
*
* http://sanc.jinr.ru/
* http://pcphsanc.cern.ch/
* E-mail: <sanc@jinr.ru>
************************************************************************
      subroutine cc_ha_1314_1516 (s,spr,ph3,costh3,costh5,hard)
      implicit none!
      include 's2n_declare.h'

      real*8 sq,sqspr,qw
      real*8 p1p2,p1p3,p1p4,p1p5,p2p3,p2p4,p2p5,p3p4,p3p5,p4p5
      real*8 ph3,cosph3,sinph3,costh3,sinth3,costh5,sinth5
      real*8 sqrtlsupdn,isqrtlsupdn
      real*8 kappaw
      complex*16 chiwspr,chiwsprc,chiws,chiwsc
      real*8 chichicwswspr
      real*8 iz1up,iz2dn,iz3mo,iz4mn

      cmw2 = mw2
      qw = 1d0

      sq = dsqrt(s)
      sqspr = dsqrt(spr)

      cosph3 = dcos(ph3)
      sinph3 = dsin(ph3)
      sinth3 = dsqrt(1d0-costh3**2)
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

      if (irun.eq.0) then
         chiws = 4d0*kappaw*s/(s-cmw2)
      else
         chiws = 4d0*kappaw*s/(s-dcmplx(mw**2,-s*ww/mw))
      endif
      chiwsc = dconjg(chiws)

      chichicwswspr = chiws*chiwsprc+chiwsc*chiwspr

      p1p2=
     & -1d0/2*s

      p1p3=
     & +sinph3*sinth3*sinth5*(-1d0/4*sq*sqspr+1d0/4*sq*sqspr*mmo**2/spr)
     & +costh3*costh5*(1d0/8*spr+1d0/8*s-1d0/8*mmo**2-1d0/8*mmo**2*s/spr
     & )
     & +costh3*(-1d0/8*spr+1d0/8*s+1d0/8*mmo**2-1d0/8*mmo**2*s/spr)
     & +costh5*(1d0/8*spr-1d0/8*s+1d0/8*mmo**2-1d0/8*mmo**2*s/spr)
     & -1d0/8*spr-1d0/8*s-1d0/8*mmo**2-1d0/8*mmo**2*s/spr

      p1p4=
     & +sinph3*sinth3*sinth5*(1d0/4*sq*sqspr-1d0/4*sq*sqspr*mmo**2/spr)
     & +costh3*costh5*(-1d0/8*spr-1d0/8*s+1d0/8*mmo**2+1d0/8*mmo**2*s/sp
     & r)
     & +costh3*(1d0/8*spr-1d0/8*s-1d0/8*mmo**2+1d0/8*mmo**2*s/spr)
     & +costh5*(1d0/8*spr-1d0/8*s-1d0/8*mmo**2+1d0/8*mmo**2*s/spr)
     & -1d0/8*spr-1d0/8*s+1d0/8*mmo**2+1d0/8*mmo**2*s/spr

      p1p5=
     & +costh5*(-1d0/4*spr+1d0/4*s)
     & +1d0/4*spr-1d0/4*s

      p2p3=
     & +sinph3*sinth3*sinth5*(1d0/4*sq*sqspr-1d0/4*sq*sqspr*mmo**2/spr)
     & +costh3*costh5*(-1d0/8*spr-1d0/8*s+1d0/8*mmo**2+1d0/8*mmo**2*s/sp
     & r)
     & +costh3*(-1d0/8*spr+1d0/8*s+1d0/8*mmo**2-1d0/8*mmo**2*s/spr)
     & +costh5*(-1d0/8*spr+1d0/8*s-1d0/8*mmo**2+1d0/8*mmo**2*s/spr)
     & -1d0/8*spr-1d0/8*s-1d0/8*mmo**2-1d0/8*mmo**2*s/spr

      p2p4=
     & +sinph3*sinth3*sinth5*(-1d0/4*sq*sqspr+1d0/4*sq*sqspr*mmo**2/spr)
     & +costh3*costh5*(1d0/8*spr+1d0/8*s-1d0/8*mmo**2-1d0/8*mmo**2*s/spr
     & )
     & +costh3*(1d0/8*spr-1d0/8*s-1d0/8*mmo**2+1d0/8*mmo**2*s/spr)
     & +costh5*(-1d0/8*spr+1d0/8*s+1d0/8*mmo**2-1d0/8*mmo**2*s/spr)
     & -1d0/8*spr-1d0/8*s+1d0/8*mmo**2+1d0/8*mmo**2*s/spr

      p2p5=
     & +costh5*(1d0/4*spr-1d0/4*s)
     & +1d0/4*spr-1d0/4*s

      p3p4=
     & -1d0/2*spr+1d0/2*mmo**2

      p3p5=
     & +costh3*(-1d0/4*spr+1d0/4*s+1d0/4*mmo**2-1d0/4*mmo**2*s/spr)
     & +1d0/4*spr-1d0/4*s+1d0/4*mmo**2-1d0/4*mmo**2*s/spr

      p4p5=
     & +costh3*(1d0/4*spr-1d0/4*s-1d0/4*mmo**2+1d0/4*mmo**2*s/spr)
     & +1d0/4*spr-1d0/4*s-1d0/4*mmo**2+1d0/4*mmo**2*s/spr

      iz1up=
     & +1d0/(mup**2/s+1d0/4*sinth5**2*sqrtlsupdn**2/s**2)/(s-spr)*(1d0/2
     & -1d0/2*mdn**2/s+1d0/2*mup**2/s+1d0/2*costh5*sqrtlsupdn/s)

      iz2dn=
     & +1d0/(mdn**2/s+1d0/4*sinth5**2*sqrtlsupdn**2/s**2)/(s-spr)*(1d0/2
     & +1d0/2*mdn**2/s-1d0/2*mup**2/s-1d0/2*costh5*sqrtlsupdn/s)

      iz3mo=
     & +1d0/(mmo**2/spr+1d0/4*sinth3**2-1d0/2*sinth3**2*mmo**2/spr+1d0/4
     & *sinth3**2*mmo**4/spr**2)/(s-spr)*(1d0/2+1d0/2*mmo**2/spr+1d0/2*c
     & osth3-1d0/2*costh3*mmo**2/spr)

      hardisr=
     & +iz1up**2*theta_hard(s,spr,omega)*chiwspr*chiwsprc/pi*alpha**3*qu
     & p**2*mup**2*(s-spr)*(-1d0/6*p1p3*p2p4/s**2/spr**2+1d0/6*p2p4*p3p5
     & /s**2/spr**2)
     & +iz1up**2*theta_hard(s,spr,omega)*chiwspr*chiwsprc/pi*alpha**3*qu
     & p**2*mup**2*mmo**2*(s-spr)*(1d0/6*p1p3*p2p4/s**2/spr**3-1d0/6*p2p
     & 4*p3p5/s**2/spr**3)
     & +iz1up*iz2dn*theta_hard(s,spr,omega)*chiwspr*chiwsprc/pi*alpha**3
     & *qup*(s-spr)*(-1d0/6*p1p3*p2p4/s/spr**2+1d0/12*p1p3*p4p5/s/spr**2
     & +1d0/12*p2p4*p3p5/s/spr**2)
     & +iz1up*iz2dn*theta_hard(s,spr,omega)*chiwspr*chiwsprc/pi*alpha**3
     & *qup*mmo**2*(s-spr)*(1d0/6*p1p3*p2p4/s/spr**3-1d0/12*p1p3*p4p5/s/
     & spr**3-1d0/12*p2p4*p3p5/s/spr**3)
     & +iz1up*iz2dn*theta_hard(s,spr,omega)*chiwspr*chiwsprc/pi*alpha**3
     & *qup**2*(s-spr)*(1d0/6*p1p3*p2p4/s/spr**2-1d0/12*p1p3*p4p5/s/spr*
     & *2-1d0/12*p2p4*p3p5/s/spr**2)
     & +iz1up*iz2dn*theta_hard(s,spr,omega)*chiwspr*chiwsprc/pi*alpha**3
     & *qup**2*mmo**2*(s-spr)*(-1d0/6*p1p3*p2p4/s/spr**3+1d0/12*p1p3*p4p
     & 5/s/spr**3+1d0/12*p2p4*p3p5/s/spr**3)
     & +iz1up*chiwspr*chiwsprc/pi*alpha**3*qup*(1d0/6*p1p3*p2p4/s/spr**2
     & -1d0/12*p1p3*p4p5/s/spr**2-1d0/12*p2p4*p3p5/s/spr**2)
     & +iz1up*chiwspr*chiwsprc/pi*alpha**3*qup*mmo**2*(-1d0/6*p1p3*p2p4/
     & s/spr**3+1d0/12*p1p3*p4p5/s/spr**3+1d0/12*p2p4*p3p5/s/spr**3)
     & +iz1up*chiwspr*chiwsprc/pi*alpha**3*qup**2*(s-spr)*(1d0/12*p1p3*p
     & 1p4/s**2/spr**2-1d0/12*p1p3*p2p4/s**2/spr**2+1d0/12*p2p4*p3p5/s**
     & 2/spr**2)
     & +iz1up*chiwspr*chiwsprc/pi*alpha**3*qup**2*mmo**2*(s-spr)*(-1d0/1
     & 2*p1p3*p1p4/s**2/spr**3+1d0/12*p1p3*p2p4/s**2/spr**3-1d0/12*p2p4*
     & p3p5/s**2/spr**3)
     & +iz2dn**2*theta_hard(s,spr,omega)*chiwspr*chiwsprc/pi*alpha**3*qd
     & n**2*mdn**2*(s-spr)*(-1d0/6*p1p3*p2p4/s**2/spr**2+1d0/6*p1p3*p4p5
     & /s**2/spr**2)
     & +iz2dn**2*theta_hard(s,spr,omega)*chiwspr*chiwsprc/pi*alpha**3*qd
     & n**2*mdn**2*mmo**2*(s-spr)*(1d0/6*p1p3*p2p4/s**2/spr**3-1d0/6*p1p
     & 3*p4p5/s**2/spr**3)
     & +iz2dn*chiwspr*chiwsprc/pi*alpha**3*qdn*(-1d0/6*p1p3*p2p4/s/spr**
     & 2+1d0/12*p1p3*p4p5/s/spr**2+1d0/12*p2p4*p3p5/s/spr**2)
     & +iz2dn*chiwspr*chiwsprc/pi*alpha**3*qdn*mmo**2*(1d0/6*p1p3*p2p4/s
     & /spr**3-1d0/12*p1p3*p4p5/s/spr**3-1d0/12*p2p4*p3p5/s/spr**3)
     & +iz2dn*chiwspr*chiwsprc/pi*alpha**3*qdn**2*(s-spr)*(-1d0/12*p1p3*
     & p2p4/s**2/spr**2+1d0/12*p1p3*p4p5/s**2/spr**2+1d0/12*p2p3*p2p4/s*
     & *2/spr**2)
     & +iz2dn*chiwspr*chiwsprc/pi*alpha**3*qdn**2*mmo**2*(s-spr)*(1d0/12
     & *p1p3*p2p4/s**2/spr**3-1d0/12*p1p3*p4p5/s**2/spr**3-1d0/12*p2p3*p
     & 2p4/s**2/spr**3)
     & +chiwspr*chiwsprc/pi*alpha**3/(s-spr)*(-1d0/6*p1p3*p2p4/s/spr**2-
     & 1d0/12*p1p3*p2p5/s**2/spr+1d0/12*p1p3*p4p5/s/spr**2-1d0/12*p1p5*p
     & 2p4/s**2/spr+1d0/12*p2p4*p3p5/s/spr**2)
     & +chiwspr*chiwsprc/pi*alpha**3*mmo**2/(s-spr)*(1d0/6*p1p3*p2p4/s/s
     & pr**3+1d0/6*p1p3*p2p5/s**2/spr**2-1d0/12*p1p3*p4p5/s/spr**3-1d0/1
     & 2*p2p4*p3p5/s/spr**3)
     & +chiwspr*chiwsprc/pi*alpha**3*mmo**4/(s-spr)*(-1d0/12*p1p3*p2p5/s
     & **2/spr**3+1d0/12*p1p5*p2p4/s**2/spr**3)
     & +chiwspr*chiwsprc/pi*alpha**3*qdn*(-1d0/12*p1p3*p2p4/s**2/spr**2+
     & 1d0/12*p1p3*p4p5/s**2/spr**2+1d0/24*p1p3/s**2/spr+1d0/12*p2p3*p2p
     & 4/s**2/spr**2)
     & +chiwspr*chiwsprc/pi*alpha**3*qdn*mmo**2*(1d0/12*p1p3*p2p4/s**2/s
     & pr**3-1d0/12*p1p3*p4p5/s**2/spr**3-1d0/12*p1p3/s**2/spr**2-1d0/12
     & *p2p3*p2p4/s**2/spr**3)
     & +chiwspr*chiwsprc/pi*alpha**3*qdn*mmo**4*(1d0/24*p1p3/s**2/spr**3
     & )
     & +chiwspr*chiwsprc/pi*alpha**3*qup*(-1d0/12*p1p3*p1p4/s**2/spr**2+
     & 1d0/12*p1p3*p2p4/s**2/spr**2-1d0/12*p2p4*p3p5/s**2/spr**2-1d0/24*
     & p2p4/s**2/spr)
     & +chiwspr*chiwsprc/pi*alpha**3*qup*mmo**2*(1d0/12*p1p3*p1p4/s**2/s
     & pr**3-1d0/12*p1p3*p2p4/s**2/spr**3+1d0/12*p2p4*p3p5/s**2/spr**3)
     & +chiwspr*chiwsprc/pi*alpha**3*qup*mmo**4*(1d0/24*p2p4/s**2/spr**3
     & )

      hardfsr=
     & +iz3mo**2*theta_hard(s,spr,omega)*chiws*chiwsc/pi*alpha**3*qmo*mm
     & o**2*(s-spr)*(1d0/6*p1p3*p2p4/s**4+1d0/6*p1p5*p2p4/s**4)
     & +iz3mo**2*theta_hard(s,spr,omega)*chiws*chiwsc/pi*alpha**3*qmo*mm
     & o**4*(s-spr)*(-1d0/6*p1p3*p2p4/s**4/spr-1d0/6*p1p5*p2p4/s**4/spr)
     & 
     & +iz3mo*chiws*chiwsc/pi*alpha**3*qmo*(-1d0/6*p1p3*p2p4/s**4*spr-1d
     & 0/12*p1p3*p2p5/s**4*spr-1d0/12*p1p5*p2p4/s**4*spr)
     & +iz3mo*chiws*chiwsc/pi*alpha**3*qmo*(s-spr)*(1d0/12*p1p3*p2p3/s**
     & 4-1d0/12*p1p3*p2p4/s**4-1d0/12*p1p5*p2p4/s**4)
     & +iz3mo*chiws*chiwsc/pi*alpha**3*qmo*mmo**2*(1d0/6*p1p3*p2p5/s**4-
     & 1d0/6*p1p5*p2p4/s**4)
     & +iz3mo*chiws*chiwsc/pi*alpha**3*qmo*mmo**2*(s-spr)*(-1d0/12*p1p3*
     & p2p3/s**4/spr+1d0/12*p1p3*p2p4/s**4/spr+1d0/12*p1p5*p2p4/s**4/spr
     & )
     & +iz3mo*chiws*chiwsc/pi*alpha**3*qmo*mmo**4*(1d0/6*p1p3*p2p4/s**4/
     & spr-1d0/12*p1p3*p2p5/s**4/spr+1d0/4*p1p5*p2p4/s**4/spr)
     & +chiws*chiwsc/pi*alpha**3/(s-spr)*(-1d0/6*p1p3*p2p4/s**3-1d0/12*p
     & 1p3*p2p5/s**4*spr+1d0/12*p1p3*p4p5/s**3-1d0/12*p1p5*p2p4/s**4*spr
     & +1d0/12*p2p4*p3p5/s**3)
     & +chiws*chiwsc/pi*alpha**3*mmo**2/(s-spr)*(1d0/6*p1p3*p2p4/s**3/sp
     & r+1d0/6*p1p3*p2p5/s**4-1d0/12*p1p3*p4p5/s**3/spr-1d0/12*p2p4*p3p5
     & /s**3/spr)
     & +chiws*chiwsc/pi*alpha**3*mmo**4/(s-spr)*(-1d0/12*p1p3*p2p5/s**4/
     & spr+1d0/12*p1p5*p2p4/s**4/spr)
     & +chiws*chiwsc/pi*alpha**3*qmo*(-1d0/12*p1p3*p2p3/s**4-1d0/12*p1p3
     & *p2p4/s**4+1d0/12*p1p5*p2p4/s**4-1d0/24*p2p4/s**3)
     & +chiws*chiwsc/pi*alpha**3*qmo*mmo**2*(1d0/12*p1p3*p2p3/s**4/spr+1
     & d0/12*p1p3*p2p4/s**4/spr-1d0/12*p1p5*p2p4/s**4/spr+1d0/24*p2p4/s*
     & *3/spr)

      hardifi=
     & +chichicwswspr/pi*alpha**3/(s-spr)*(1d0/6*p1p3*p2p4/s**2/spr+1d0/
     & 12*p1p3*p2p5/s**3-1d0/12*p1p3*p4p5/s**2/spr+1d0/12*p1p5*p2p4/s**3
     & -1d0/12*p2p4*p3p5/s**2/spr)
     & +chichicwswspr/pi*alpha**3*mmo**2/(s-spr)*(-1d0/6*p1p3*p2p4/s**2/
     & spr**2-1d0/6*p1p3*p2p5/s**3/spr+1d0/12*p1p3*p4p5/s**2/spr**2+1d0/
     & 12*p2p4*p3p5/s**2/spr**2)
     & +chichicwswspr/pi*alpha**3*mmo**4/(s-spr)*(1d0/12*p1p3*p2p5/s**3/
     & spr**2-1d0/12*p1p5*p2p4/s**3/spr**2)
     & +chichicwswspr/pi*alpha**3*qmo*(1d0/24*p1p3*p2p3/s**3/spr+1d0/24*
     & p1p3*p2p4/s**3/spr-1d0/24*p1p5*p2p4/s**3/spr+1d0/48*p2p4/s**2/spr
     & )
     & +chichicwswspr/pi*alpha**3*qmo*mmo**2*(-1d0/24*p1p3*p2p3/s**3/spr
     & **2-1d0/24*p1p3*p2p4/s**3/spr**2+1d0/24*p1p5*p2p4/s**3/spr**2-1d0
     & /48*p2p4/s**2/spr**2)
     & +chichicwswspr/pi*alpha**3*qdn*(1d0/24*p1p3*p2p4/s**3/spr-1d0/24*
     & p1p3*p4p5/s**3/spr-1d0/48*p1p3/s**3-1d0/24*p2p3*p2p4/s**3/spr)
     & +chichicwswspr/pi*alpha**3*qdn*mmo**2*(-1d0/24*p1p3*p2p4/s**3/spr
     & **2+1d0/24*p1p3*p4p5/s**3/spr**2+1d0/24*p1p3/s**3/spr+1d0/24*p2p3
     & *p2p4/s**3/spr**2)
     & +chichicwswspr/pi*alpha**3*qdn*mmo**4*(-1d0/48*p1p3/s**3/spr**2)
     & +chichicwswspr/pi*alpha**3*qup*(1d0/24*p1p3*p1p4/s**3/spr-1d0/24*
     & p1p3*p2p4/s**3/spr+1d0/24*p2p4*p3p5/s**3/spr+1d0/48*p2p4/s**3)
     & +chichicwswspr/pi*alpha**3*qup*mmo**2*(-1d0/24*p1p3*p1p4/s**3/spr
     & **2+1d0/24*p1p3*p2p4/s**3/spr**2-1d0/24*p2p4*p3p5/s**3/spr**2)
     & +chichicwswspr/pi*alpha**3*qup*mmo**4*(-1d0/48*p2p4/s**3/spr**2)
     & +chichicwswspr/pi*alpha**3*qup*qmo*(s-spr)*(-1d0/24*p2p4/s**3/spr
     & )
     & +chichicwswspr/pi*alpha**3*qup*qmo*mmo**2*(s-spr)*(1d0/24*p2p4/s*
     & *3/spr**2)
     & +chichicwswspr*iz1up/pi*alpha**3*qup*(-1d0/12*p1p3*p2p4/s**2/spr+
     & 1d0/24*p1p3*p4p5/s**2/spr+1d0/24*p2p4*p3p5/s**2/spr)
     & +chichicwswspr*iz1up/pi*alpha**3*qup*(s-spr)*(-1d0/24*p1p3*p1p4/s
     & **3/spr+1d0/24*p1p3*p2p4/s**3/spr)
     & +chichicwswspr*iz1up/pi*alpha**3*qup*mmo**2*(1d0/12*p1p3*p2p4/s**
     & 2/spr**2-1d0/24*p1p3*p4p5/s**2/spr**2-1d0/24*p2p4*p3p5/s**2/spr**
     & 2)
     & +chichicwswspr*iz1up/pi*alpha**3*qup*mmo**2*(s-spr)*(1d0/24*p1p3*
     & p1p4/s**3/spr**2-1d0/24*p1p3*p2p4/s**3/spr**2)
     & +chichicwswspr*iz1up/pi*alpha**3*qup*qmo*(s-spr)*(1d0/12*p1p3*p2p
     & 4/s**3/spr)
     & +chichicwswspr*iz1up/pi*alpha**3*qup*qmo*mmo**2*(s-spr)*(-1d0/12*
     & p1p3*p2p4/s**3/spr**2)
     & +chichicwswspr*iz1up*iz3mo*theta_hard(s,spr,omega)/pi*alpha**3*qu
     & p*qmo*(s-spr)*(1d0/6*p1p3**2*p2p4/s**3/spr)
     & +chichicwswspr*iz1up*iz3mo*theta_hard(s,spr,omega)/pi*alpha**3*qu
     & p*qmo*mmo**2*(s-spr)*(-1d0/6*p1p3**2*p2p4/s**3/spr**2)
     & +chichicwswspr*iz2dn/pi*alpha**3*qdn*(1d0/12*p1p3*p2p4/s**2/spr-1
     & d0/24*p1p3*p4p5/s**2/spr-1d0/24*p2p4*p3p5/s**2/spr)
     & +chichicwswspr*iz2dn/pi*alpha**3*qdn*(s-spr)*(-1d0/24*p1p3*p2p4/s
     & **3/spr+1d0/24*p2p3*p2p4/s**3/spr)
     & +chichicwswspr*iz2dn/pi*alpha**3*qdn*mmo**2*(-1d0/12*p1p3*p2p4/s*
     & *2/spr**2+1d0/24*p1p3*p4p5/s**2/spr**2+1d0/24*p2p4*p3p5/s**2/spr*
     & *2)
     & +chichicwswspr*iz2dn/pi*alpha**3*qdn*mmo**2*(s-spr)*(1d0/24*p1p3*
     & p2p4/s**3/spr**2-1d0/24*p2p3*p2p4/s**3/spr**2)
     & +chichicwswspr*iz2dn/pi*alpha**3*qdn*qmo*(s-spr)*(1d0/24*p1p3*p2p
     & 3/s**3/spr-1d0/24*p1p3*p2p4/s**3/spr+1d0/48*p2p4/s**2/spr)
     & +chichicwswspr*iz2dn/pi*alpha**3*qdn*qmo*mmo**2*(s-spr)*(-1d0/24*
     & p1p3*p2p3/s**3/spr**2+1d0/24*p1p3*p2p4/s**3/spr**2-1d0/48*p2p4/s*
     & *2/spr**2)
     & +chichicwswspr*iz2dn*iz3mo*theta_hard(s,spr,omega)/pi*alpha**3*qd
     & n*qmo*(s-spr)*(-1d0/6*p1p3*p2p3*p2p4/s**3/spr)
     & +chichicwswspr*iz2dn*iz3mo*theta_hard(s,spr,omega)/pi*alpha**3*qd
     & n*qmo*(s-spr)**2*(-1d0/24*p1p3*p2p3/s**3/spr+1d0/24*p2p3*p2p4/s**
     & 3/spr)
     & +chichicwswspr*iz2dn*iz3mo*theta_hard(s,spr,omega)/pi*alpha**3*qd
     & n*qmo*mmo**2*(s-spr)*(1d0/6*p1p3*p2p3*p2p4/s**3/spr**2)
     & +chichicwswspr*iz2dn*iz3mo*theta_hard(s,spr,omega)/pi*alpha**3*qd
     & n*qmo*mmo**2*(s-spr)**2*(1d0/24*p1p3*p2p3/s**3/spr**2-1d0/24*p2p3
     & *p2p4/s**3/spr**2)
     & +chichicwswspr*iz3mo/pi*alpha**3*qmo*(1d0/12*p1p3*p2p4/s**3+1d0/2
     & 4*p1p3*p2p5/s**3+1d0/24*p1p5*p2p4/s**3)
     & +chichicwswspr*iz3mo/pi*alpha**3*qmo*(s-spr)*(-1d0/24*p1p3*p2p3/s
     & **3/spr+1d0/24*p1p3*p2p4/s**3/spr)
     & +chichicwswspr*iz3mo/pi*alpha**3*qmo*mmo**2*(-1d0/12*p1p3*p2p5/s*
     & *3/spr+1d0/12*p1p5*p2p4/s**3/spr)
     & +chichicwswspr*iz3mo/pi*alpha**3*qmo*mmo**2*(s-spr)*(1d0/24*p1p3*
     & p2p3/s**3/spr**2-1d0/24*p1p3*p2p4/s**3/spr**2)
     & +chichicwswspr*iz3mo/pi*alpha**3*qmo*mmo**4*(-1d0/12*p1p3*p2p4/s*
     & *3/spr**2+1d0/24*p1p3*p2p5/s**3/spr**2-1d0/8*p1p5*p2p4/s**3/spr**
     & 2)
     & +chichicwswspr*iz3mo/pi*alpha**3*qdn*qmo*(s-spr)*(1d0/24*p1p3*p2p
     & 4/s**3/spr-1d0/48*p1p3/s**3-1d0/24*p2p3*p2p4/s**3/spr)
     & +chichicwswspr*iz3mo/pi*alpha**3*qdn*qmo*mmo**2*(s-spr)*(-1d0/24*
     & p1p3*p2p4/s**3/spr**2+1d0/24*p1p3/s**3/spr+1d0/24*p2p3*p2p4/s**3/
     & spr**2)
     & +chichicwswspr*iz3mo/pi*alpha**3*qdn*qmo*mmo**4*(s-spr)*(-1d0/48*
     & p1p3/s**3/spr**2)
     & +chichicwswspr*iz3mo/pi*alpha**3*qup*qmo*(s-spr)*(-1d0/12*p1p3*p2
     & p4/s**3/spr)
     & +chichicwswspr*iz3mo/pi*alpha**3*qup*qmo*mmo**2*(s-spr)*(1d0/12*p
     & 1p3*p2p4/s**3/spr**2+1d0/24*p2p4/s**3/spr)
     & +chichicwswspr*iz3mo/pi*alpha**3*qup*qmo*mmo**4*(s-spr)*(-1d0/24*
     & p2p4/s**3/spr**2)

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
      elseif(iqed.eq.6) then
         hard = hardisr+hardifi
      endif

      hard = hard*conhc*cfprime

      return
      end
