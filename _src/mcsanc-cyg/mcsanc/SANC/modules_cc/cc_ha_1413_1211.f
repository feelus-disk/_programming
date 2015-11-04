************************************************************************
* sanc_cc_v1.40 package.
************************************************************************
* File (cc_ha_1413_1211.f) is created on Tue Aug  9 22:37:52 MSD 2011.
************************************************************************
* This is the FORTRAN module (cc_ha_1413_1211) to calculate differential
* hard photon Bremsstrahlung for the anti-dn + up -> el^+ + en process.
*
* It is produced by s2n package of SANC (v1.10) Project.
* Copyright (C), SANC Project Team, 2002-2011.
*
* http://sanc.jinr.ru/
* http://pcphsanc.cern.ch/
* E-mail: <sanc@jinr.ru>
************************************************************************
      subroutine cc_ha_1413_1211 (s,spr,ph4,costh4,costh5,hard)
      implicit none!
      include 's2n_declare.h'

      real*8 sq,sqspr,qw
      real*8 p1p2,p1p3,p1p4,p1p5,p2p3,p2p4,p2p5,p3p4,p3p5,p4p5
      real*8 ph4,cosph4,sinph4,costh4,sinth4,costh5,sinth5
      real*8 sqrtlsupdn,isqrtlsupdn
      real*8 kappaw
      complex*16 chiwspr,chiwsprc,chiws,chiwsc
      real*8 chichicwswspr
      real*8 iz1dn,iz2up,iz3en,iz4el

      cmw2 = mw2
      qw = 1d0

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

      iz4el=
     & +1d0/(mel**2/spr+1d0/4*sinth4**2-1d0/2*sinth4**2*mel**2/spr+1d0/4
     & *sinth4**2*mel**4/spr**2)/(s-spr)*(1d0/2+1d0/2*mel**2/spr+1d0/2*c
     & osth4-1d0/2*costh4*mel**2/spr)

      hardisr=
     & +iz1dn**2*theta_hard(s,spr,omega)*chiwspr*chiwsprc/pi*alpha**3*qd
     & n**2*mdn**2*(s-spr)*(-1d0/6*p1p3*p2p4/s**2/spr**2+1d0/6*p2p4*p3p5
     & /s**2/spr**2)
     & +iz1dn*iz2up*theta_hard(s,spr,omega)*chiwspr*chiwsprc/pi*alpha**3
     & *qdn*(s-spr)*(1d0/6*p1p3*p2p4/s/spr**2-1d0/12*p1p3*p4p5/s/spr**2-
     & 1d0/12*p2p4*p3p5/s/spr**2)
     & +iz1dn*iz2up*theta_hard(s,spr,omega)*chiwspr*chiwsprc/pi*alpha**3
     & *qdn**2*(s-spr)*(1d0/6*p1p3*p2p4/s/spr**2-1d0/12*p1p3*p4p5/s/spr*
     & *2-1d0/12*p2p4*p3p5/s/spr**2)
     & +iz1dn*chiwspr*chiwsprc/pi*alpha**3*qdn*(-1d0/6*p1p3*p2p4/s/spr**
     & 2+1d0/12*p1p3*p4p5/s/spr**2+1d0/12*p2p4*p3p5/s/spr**2)
     & +iz1dn*chiwspr*chiwsprc/pi*alpha**3*qdn**2*(s-spr)*(1d0/12*p1p3*p
     & 1p4/s**2/spr**2-1d0/12*p1p3*p2p4/s**2/spr**2+1d0/12*p2p4*p3p5/s**
     & 2/spr**2)
     & +iz2up**2*theta_hard(s,spr,omega)*chiwspr*chiwsprc/pi*alpha**3*qu
     & p**2*mup**2*(s-spr)*(-1d0/6*p1p3*p2p4/s**2/spr**2+1d0/6*p1p3*p4p5
     & /s**2/spr**2)
     & +iz2up*chiwspr*chiwsprc/pi*alpha**3*qup*(1d0/6*p1p3*p2p4/s/spr**2
     & -1d0/12*p1p3*p4p5/s/spr**2-1d0/12*p2p4*p3p5/s/spr**2)
     & +iz2up*chiwspr*chiwsprc/pi*alpha**3*qup**2*(s-spr)*(-1d0/12*p1p3*
     & p2p4/s**2/spr**2+1d0/12*p1p3*p4p5/s**2/spr**2+1d0/12*p2p3*p2p4/s*
     & *2/spr**2)
     & +chiwspr*chiwsprc/pi*alpha**3/(s-spr)*(-1d0/6*p1p3*p2p4/s/spr**2-
     & 1d0/12*p1p3*p2p5/s**2/spr+1d0/12*p1p3*p4p5/s/spr**2-1d0/12*p1p5*p
     & 2p4/s**2/spr+1d0/12*p2p4*p3p5/s/spr**2)
     & +chiwspr*chiwsprc/pi*alpha**3*qdn*(1d0/12*p1p3*p1p4/s**2/spr**2-1
     & d0/12*p1p3*p2p4/s**2/spr**2+1d0/12*p2p4*p3p5/s**2/spr**2+1d0/24*p
     & 2p4/s**2/spr)
     & +chiwspr*chiwsprc/pi*alpha**3*qup*(1d0/12*p1p3*p2p4/s**2/spr**2-1
     & d0/12*p1p3*p4p5/s**2/spr**2-1d0/24*p1p3/s**2/spr-1d0/12*p2p3*p2p4
     & /s**2/spr**2)

      hardfsr=
     & +iz4el**2*theta_hard(s,spr,omega)*chiws*chiwsc/pi*alpha**3*qel*me
     & l**2*(s-spr)*(1d0/6*p1p3*p2p4/s**4+1d0/6*p1p3*p2p5/s**4)
     & +iz4el*chiws*chiwsc/pi*alpha**3*qel*(-1d0/6*p1p3*p2p4/s**4*spr-1d
     & 0/12*p1p3*p2p5/s**4*spr-1d0/12*p1p5*p2p4/s**4*spr)
     & +iz4el*chiws*chiwsc/pi*alpha**3*qel*(s-spr)*(-1d0/12*p1p3*p2p4/s*
     & *4-1d0/12*p1p3*p2p5/s**4+1d0/12*p1p4*p2p4/s**4)
     & +chiws*chiwsc/pi*alpha**3/(s-spr)*(-1d0/6*p1p3*p2p4/s**3-1d0/12*p
     & 1p3*p2p5/s**4*spr+1d0/12*p1p3*p4p5/s**3-1d0/12*p1p5*p2p4/s**4*spr
     & +1d0/12*p2p4*p3p5/s**3)
     & +chiws*chiwsc/pi*alpha**3*qel*(-1d0/12*p1p3*p2p4/s**4+1d0/12*p1p3
     & *p2p5/s**4-1d0/24*p1p3/s**3-1d0/12*p1p4*p2p4/s**4)

      hardifi=
     & +chichicwswspr/pi*alpha**3/(s-spr)*(1d0/6*p1p3*p2p4/s**2/spr+1d0/
     & 12*p1p3*p2p5/s**3-1d0/12*p1p3*p4p5/s**2/spr+1d0/12*p1p5*p2p4/s**3
     & -1d0/12*p2p4*p3p5/s**2/spr)
     & +chichicwswspr/pi*alpha**3*qdn*(-1d0/24*p1p3*p1p4/s**3/spr+1d0/24
     & *p1p3*p2p4/s**3/spr-1d0/24*p2p4*p3p5/s**3/spr-1d0/48*p2p4/s**3)
     & +chichicwswspr/pi*alpha**3*qup*(-1d0/24*p1p3*p2p4/s**3/spr+1d0/24
     & *p1p3*p4p5/s**3/spr+1d0/48*p1p3/s**3+1d0/24*p2p3*p2p4/s**3/spr)
     & +chichicwswspr/pi*alpha**3*qel*(1d0/24*p1p3*p2p4/s**3/spr-1d0/24*
     & p1p3*p2p5/s**3/spr+1d0/48*p1p3/s**2/spr+1d0/24*p1p4*p2p4/s**3/spr
     & )
     & +chichicwswspr/pi*alpha**3*qel*qup*(s-spr)*(-1d0/24*p1p3/s**3/spr
     & )
     & +chichicwswspr*iz1dn/pi*alpha**3*qdn*(1d0/12*p1p3*p2p4/s**2/spr-1
     & d0/24*p1p3*p4p5/s**2/spr-1d0/24*p2p4*p3p5/s**2/spr)
     & +chichicwswspr*iz1dn/pi*alpha**3*qdn*(s-spr)*(1d0/24*p1p3*p1p4/s*
     & *3/spr-1d0/24*p1p3*p2p4/s**3/spr)
     & +chichicwswspr*iz1dn/pi*alpha**3*qel*qdn*(s-spr)*(-1d0/24*p1p3*p2
     & p4/s**3/spr+1d0/48*p1p3/s**2/spr+1d0/24*p1p4*p2p4/s**3/spr)
     & +chichicwswspr*iz1dn*iz4el*theta_hard(s,spr,omega)/pi*alpha**3*qe
     & l*qdn*(s-spr)*(-1d0/6*p1p3*p1p4*p2p4/s**3/spr)
     & +chichicwswspr*iz1dn*iz4el*theta_hard(s,spr,omega)/pi*alpha**3*qe
     & l*qdn*(s-spr)**2*(1d0/24*p1p3*p1p4/s**3/spr-1d0/24*p1p4*p2p4/s**3
     & /spr)
     & +chichicwswspr*iz2up/pi*alpha**3*qup*(-1d0/12*p1p3*p2p4/s**2/spr+
     & 1d0/24*p1p3*p4p5/s**2/spr+1d0/24*p2p4*p3p5/s**2/spr)
     & +chichicwswspr*iz2up/pi*alpha**3*qup*(s-spr)*(1d0/24*p1p3*p2p4/s*
     & *3/spr-1d0/24*p2p3*p2p4/s**3/spr)
     & +chichicwswspr*iz2up/pi*alpha**3*qel*qup*(s-spr)*(1d0/12*p1p3*p2p
     & 4/s**3/spr)
     & +chichicwswspr*iz2up*iz4el*theta_hard(s,spr,omega)/pi*alpha**3*qe
     & l*qup*(s-spr)*(1d0/6*p1p3*p2p4**2/s**3/spr)
     & +chichicwswspr*iz4el/pi*alpha**3*qel*(1d0/12*p1p3*p2p4/s**3+1d0/2
     & 4*p1p3*p2p5/s**3+1d0/24*p1p5*p2p4/s**3)
     & +chichicwswspr*iz4el/pi*alpha**3*qel*(s-spr)*(1d0/24*p1p3*p2p4/s*
     & *3/spr-1d0/24*p1p4*p2p4/s**3/spr)
     & +chichicwswspr*iz4el/pi*alpha**3*qel*qdn*(s-spr)*(-1d0/24*p1p3*p1
     & p4/s**3/spr+1d0/24*p1p3*p2p4/s**3/spr-1d0/48*p2p4/s**3)
     & +chichicwswspr*iz4el/pi*alpha**3*qel*qup*(s-spr)*(-1d0/12*p1p3*p2
     & p4/s**3/spr)

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
