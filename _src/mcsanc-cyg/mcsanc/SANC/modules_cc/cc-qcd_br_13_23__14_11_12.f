************************************************************************
* sanc_cc_v1.40 package.
************************************************************************
* File (cc-qcd_br_13_23__14_11_12.f) is created on Tue Aug  9 23:04:41 MSD 2011.
************************************************************************
* This is the FORTRAN module (cc_qcd_ha_13_23__14_11_12_1spr) to calculate
* the gluon induced anti-up + g -> anti-dn + en + el^- process.
*
* It is produced by s2n package of SANC (v1.10) Project.
* Copyright (C), SANC Project Team, 2002-2011.
*
* http://sanc.jinr.ru/
* http://pcphsanc.cern.ch/
* E-mail: <sanc@jinr.ru>
************************************************************************
      subroutine cc_qcd_ha_13_23__14_11_12_1spr (s,spr,hard)
      implicit none!
      include 's2n_declare.h'

      real*8 kappaw
      real*8 ln1sup,ln1sdn
      complex*16 chiwspr,chiwsprc

      cmw2 = mw2

      kappaw = gf*rwm2/(sqrt(2d0)*4d0*pi)/alpha
      if (irun.eq.0) then
         chiwspr = 4d0*kappaw*spr/(spr-cmw2)
      else
         chiwspr = 4d0*kappaw*spr/(spr-dcmplx(mw**2,-spr*ww/mw))
      endif
      chiwsprc = dconjg(chiwspr)

      ln1sup = log(s/mup**2)-1d0
      ln1sdn = log(s/mdn**2)-1d0

      hard=
     & +chiwspr*chiwsprc*alpha**2*alphas*cf*(-7d0/96/s**3*spr+1d0/16/s**
     & 2+1d0/96/s/spr)
     & +chiwspr*chiwsprc*log(1-1d0/s*spr)*((s-spr)**2+spr**2)*alpha**2*a
     & lphas*cf*(1d0/24/s**3/spr)
     & +chiwspr*chiwsprc*log(1d0/mdn**2*s)*((s-spr)**2+spr**2)*alpha**2*
     & alphas*cf*(1d0/48/s**3/spr)

      hard = hard*conhc

      return
      end
