************************************************************************
* sanc_cc_v1.51 package.
************************************************************************
* File (cc-qcd_ha_1314_34.f) is created on Fri Mar 23 13:04:50 MSK 2012.
************************************************************************
* This is the FORTRAN module (cc_qcd_ha_1314_34) to calculate differential
* hard gluon radiation for the anti-up + dn -> W^- + H   process.
*
* It is produced by s2n package of SANC (v1.10) Project.
* Copyright (C), SANC Project Team, 2002-2012.
*
* http://sanc.jinr.ru/
* http://pcphsanc.cern.ch/
* E-mail: <sanc@jinr.ru>
************************************************************************
      subroutine cc_qcd_ha_1314_34 (s,spr,ph3,costh3,costh5,hard)
      implicit none!
      include 's2n_declare.h'

      real*8 sq,sqspr
      real*8 p1p2,p1p3,p1p4,p1p5,p2p3,p2p4,p2p5,p3p4,p3p5,p4p5
      real*8 ph3,cosph3,sinph3,costh3,sinth3,costh5,sinth5
      real*8 sqrtlsprwh,isqrtlsprwh,sqrtlssprc,isqrtlssprc,sqrtlsdnup,i
     & sqrtlsdnup
      complex*16 propwspr,propiwspr,propwsprc
      real*8 iz1dn,iz2up

      cmw2 = mw2

      sq = dsqrt(s)
      sqspr = dsqrt(spr)

      cosph3 = dcos(ph3)
      sinph3 = dsin(ph3)
      sinth3 = dsqrt(1d0-costh3**2)
      sinth5 = dsqrt(1d0-costh5**2)

      if (irun.eq.0) then
         propiwspr = (cmw2-spr)
      elseif (irun.eq.1) then
         propiwspr = (dcmplx(mw**2,-spr*ww/mw)-spr)
      endif
      propwspr = 1d0/propiwspr
      propwsprc = dconjg(propwspr)

      sqrtlsprwh = sqrt(spr**2-2d0*spr*(rwm2+rhm2)+(rwm2-rhm2)**2)
      isqrtlsprwh = 1d0/sqrtlsprwh
      sqrtlssprc = dabs(s-spr)
      isqrtlssprc = 1d0/sqrtlssprc
      sqrtlsdnup = sqrt(s**2-2d0*s*(rdnm2+rupm2)+(rdnm2-rupm2)**2)
      isqrtlsdnup = 1d0/sqrtlsdnup

      p1p2=
     & -1d0/2*s

      p1p3=
     & +sinph3*sinth3*sinth5*sqrtlsprwh*(-1d0/4/sq/sqspr*s)
     & +costh3*costh5*sqrtlsprwh*(1d0/8+1d0/8*s/spr)
     & +costh3*sqrtlsprwh*(-1d0/8+1d0/8*s/spr)
     & +costh5*(1d0/8*spr-1d0/8*s-1d0/8*mh**2+1d0/8*mh**2*s/spr+1d0/8*mw
     & **2-1d0/8*mw**2*s/spr)
     & -1d0/8*spr-1d0/8*s+1d0/8*mh**2+1d0/8*mh**2*s/spr-1d0/8*mw**2-1d0/
     & 8*mw**2*s/spr

      p1p4=
     & +sinph3*sinth3*sinth5*sqrtlsprwh*(1d0/4/sq/sqspr*s)
     & +costh3*costh5*sqrtlsprwh*(-1d0/8-1d0/8*s/spr)
     & +costh3*sqrtlsprwh*(1d0/8-1d0/8*s/spr)
     & +costh5*(1d0/8*spr-1d0/8*s+1d0/8*mh**2-1d0/8*mh**2*s/spr-1d0/8*mw
     & **2+1d0/8*mw**2*s/spr)
     & -1d0/8*spr-1d0/8*s-1d0/8*mh**2-1d0/8*mh**2*s/spr+1d0/8*mw**2+1d0/
     & 8*mw**2*s/spr

      p1p5=
     & +costh5*sqrtlssprc*(1d0/4)
     & +sqrtlssprc*(-1d0/4)

      p2p3=
     & +sinph3*sinth3*sinth5*sqrtlsprwh*(1d0/4/sq/sqspr*s)
     & +costh3*costh5*sqrtlsprwh*(-1d0/8-1d0/8*s/spr)
     & +costh3*sqrtlsprwh*(-1d0/8+1d0/8*s/spr)
     & +costh5*(-1d0/8*spr+1d0/8*s+1d0/8*mh**2-1d0/8*mh**2*s/spr-1d0/8*m
     & w**2+1d0/8*mw**2*s/spr)
     & -1d0/8*spr-1d0/8*s+1d0/8*mh**2+1d0/8*mh**2*s/spr-1d0/8*mw**2-1d0/
     & 8*mw**2*s/spr

      p2p4=
     & +sinph3*sinth3*sinth5*sqrtlsprwh*(-1d0/4/sq/sqspr*s)
     & +costh3*costh5*sqrtlsprwh*(1d0/8+1d0/8*s/spr)
     & +costh3*sqrtlsprwh*(1d0/8-1d0/8*s/spr)
     & +costh5*(-1d0/8*spr+1d0/8*s-1d0/8*mh**2+1d0/8*mh**2*s/spr+1d0/8*m
     & w**2-1d0/8*mw**2*s/spr)
     & -1d0/8*spr-1d0/8*s-1d0/8*mh**2-1d0/8*mh**2*s/spr+1d0/8*mw**2+1d0/
     & 8*mw**2*s/spr

      p2p5=
     & +costh5*sqrtlssprc*(-1d0/4)
     & +sqrtlssprc*(-1d0/4)

      p3p4=
     & -1d0/2*spr+1d0/2*mh**2+1d0/2*mw**2

      p3p5=
     & +costh3*sqrtlssprc*sqrtlsprwh*(1d0/4/spr)
     & +sqrtlssprc*(-1d0/4+1d0/8*mh**2/spr-1d0/8*mw**2/spr)
     & -1d0/8*mh**2+1d0/8*mh**2*s/spr+1d0/8*mw**2-1d0/8*mw**2*s/spr

      p4p5=
     & +costh3*sqrtlssprc*sqrtlsprwh*(-1d0/4/spr)
     & +sqrtlssprc*(-1d0/4-1d0/8*mh**2/spr+1d0/8*mw**2/spr)
     & +1d0/8*mh**2-1d0/8*mh**2*s/spr-1d0/8*mw**2+1d0/8*mw**2*s/spr

      iz1dn=
     & +1d0/(mdn**2/s+1d0/4*sinth5**2*sqrtlsdnup**2/s**2)/(s-spr)*(1d0/2
     & +1d0/2*mdn**2/s-1d0/2*mup**2/s+1d0/2*costh5*sqrtlsdnup/s)

      iz2up=
     & +1d0/(mup**2/s+1d0/4*sinth5**2*sqrtlsdnup**2/s**2)/(s-spr)*(1d0/2
     & -1d0/2*mdn**2/s+1d0/2*mup**2/s-1d0/2*costh5*sqrtlsdnup/s)

      hard=
     & +iz1dn**2*theta_hard(s,spr,omega)*propwspr*propwsprc*sqrtlssprc*s
     & qrtlsprwh/pi**3*alphas*g**4*mdn**2/s**2/spr*cf*(1d0/1536*p1p2*mw*
     & *2-1d0/768*p1p3*p2p3+1d0/768*p2p3*p3p5-1d0/1536*p2p5*mw**2)
     & +iz1dn*iz2up*theta_hard(s,spr,omega)*propwspr*propwsprc*sqrtlsspr
     & c*sqrtlsprwh/pi**3*alphas*g**4/s**2/spr*cf*(-1d0/384*p1p2*p1p3*p2
     & p3+1d0/768*p1p2*p1p3*p3p5+1d0/768*p1p2*p2p3*p3p5+1d0/768*p1p2**2*
     & mw**2)
     & +iz1dn*propwspr*propwsprc*sqrtlssprc*sqrtlsprwh/pi**3*alphas*g**4
     & /s**2/spr*cf*(1d0/1536*p1p2*mw**2-1d0/1536*p1p3*p2p3+1d0/1536*p1p
     & 3**2+1d0/1536*p2p3*p3p5-1d0/3072*p2p5*mw**2)
     & +iz2up**2*theta_hard(s,spr,omega)*propwspr*propwsprc*sqrtlssprc*s
     & qrtlsprwh/pi**3*alphas*g**4*mup**2/s**2/spr*cf*(1d0/1536*p1p2*mw*
     & *2-1d0/768*p1p3*p2p3+1d0/768*p1p3*p3p5-1d0/1536*p1p5*mw**2)
     & +iz2up*propwspr*propwsprc*sqrtlssprc*sqrtlsprwh/pi**3*alphas*g**4
     & /s**2/spr*cf*(1d0/1536*p1p2*mw**2-1d0/1536*p1p3*p2p3+1d0/1536*p1p
     & 3*p3p5-1d0/3072*p1p5*mw**2+1d0/1536*p2p3**2)

      hard = hard*conhc

      return
      end
