************************************************************************
* sanc_cc_v1.40 package.
************************************************************************
* File (cc-qcd_br_23_14__13_15_16.f) is created on Tue Aug  9 23:04:44 MSD 2011.
************************************************************************
* This is the FORTRAN module (cc_qcd_ha_23_14__13_15_16_1spr) to calculate
* the gluon induced g + dn -> up + mn + mo^- process.
*
* It is produced by s2n package of SANC (v1.10) Project.
* Copyright (C), SANC Project Team, 2002-2011.
*
* http://sanc.jinr.ru/
* http://pcphsanc.cern.ch/
* E-mail: <sanc@jinr.ru>
************************************************************************
      subroutine cc_qcd_ha_23_14__13_15_16_1spr (s,spr,hard)
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
     & 2+1d0/96/s/spr+7d0/64*mmo**2/s**3-3d0/32*mmo**2/s**2/spr-1d0/64*m
     & mo**2/s/spr**2-7d0/192*mmo**6/s**3/spr**2+1d0/32*mmo**6/s**2/spr*
     & *3+1d0/192*mmo**6/s/spr**4)
     & +chiwspr*chiwsprc*log(1-1d0/s*spr)*((s-spr)**2+spr**2)*alpha**2*a
     & lphas*cf*(1d0/24/s**3/spr-1d0/16*mmo**2/s**3/spr**2+1d0/48*mmo**6
     & /s**3/spr**4)
     & +chiwspr*chiwsprc*log(1d0/mup**2*s)*((s-spr)**2+spr**2)*alpha**2*
     & alphas*cf*(1d0/48/s**3/spr-1d0/32*mmo**2/s**3/spr**2+1d0/96*mmo**
     & 6/s**3/spr**4)

      hard = hard*conhc

      return
      end
