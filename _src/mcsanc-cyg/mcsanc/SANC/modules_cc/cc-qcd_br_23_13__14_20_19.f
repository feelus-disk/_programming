************************************************************************
* sanc_cc_v1.40 package.
************************************************************************
* File (cc-qcd_br_23_13__14_20_19.f) is created on Tue Aug  9 23:04:48 MSD 2011.
************************************************************************
* This is the FORTRAN module (cc_qcd_ha_23_13__14_20_19_1spr) to calculate
* the gluon induced g + up -> dn + ta^+ + tn process.
*
* It is produced by s2n package of SANC (v1.10) Project.
* Copyright (C), SANC Project Team, 2002-2011.
*
* http://sanc.jinr.ru/
* http://pcphsanc.cern.ch/
* E-mail: <sanc@jinr.ru>
************************************************************************
      subroutine cc_qcd_ha_23_13__14_20_19_1spr (s,spr,hard)
      implicit none!
      include 's2n_declare.h'

      real*8 kappaw
      real*8 ln1sdn,ln1sup
      complex*16 chiwspr,chiwsprc

      cmw2 = mw2

      kappaw = gf*rwm2/(sqrt(2d0)*4d0*pi)/alpha
      if (irun.eq.0) then
         chiwspr = 4d0*kappaw*spr/(spr-cmw2)
      else
         chiwspr = 4d0*kappaw*spr/(spr-dcmplx(mw**2,-spr*ww/mw))
      endif
      chiwsprc = dconjg(chiwspr)

      ln1sdn = log(s/mdn**2)-1d0
      ln1sup = log(s/mup**2)-1d0

      hard=
     & +chiwspr*chiwsprc*alpha**2*alphas*cf*(-7d0/96/s**3*spr+1d0/16/s**
     & 2+1d0/96/s/spr+7d0/64*mta**2/s**3-3d0/32*mta**2/s**2/spr-1d0/64*m
     & ta**2/s/spr**2-7d0/192*mta**6/s**3/spr**2+1d0/32*mta**6/s**2/spr*
     & *3+1d0/192*mta**6/s/spr**4)
     & +chiwspr*chiwsprc*log(1-1d0/s*spr)*((s-spr)**2+spr**2)*alpha**2*a
     & lphas*cf*(1d0/24/s**3/spr-1d0/16*mta**2/s**3/spr**2+1d0/48*mta**6
     & /s**3/spr**4)
     & +chiwspr*chiwsprc*log(1d0/mdn**2*s)*((s-spr)**2+spr**2)*alpha**2*
     & alphas*cf*(1d0/48/s**3/spr-1d0/32*mta**2/s**3/spr**2+1d0/96*mta**
     & 6/s**3/spr**4)

      hard = hard*conhc

      return
      end
