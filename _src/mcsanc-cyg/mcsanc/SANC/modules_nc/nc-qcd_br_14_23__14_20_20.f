************************************************************************
* sanc_nc_v1.30 package.
************************************************************************
* File (nc-qcd_br_14_23__14_20_20.f) is created on Wed Apr 18 13:39:17 MSK 2012.
*****************************************************************************
* This is the FORTRAN module (nc_qcd_ha_14_23__14_20_20_1spr) to calculate
* differential cross-section for the gluon induced anti-dn + g -> anti-dn + ta^+ + ta^- process.
*
* It is produced by s2n package of SANC (v1.10) Project.
* Copyright (C), SANC Project Team, 2002-2012.
*
* http://sanc.jinr.ru/
* http://pcphsanc.cern.ch/
* E-mail: <sanc@jinr.ru>
*****************************************************************************
      subroutine nc_qcd_ha_14_23__14_20_20_1spr (s,spr,hard)
      implicit none!
      include 's2n_declare.h'

      real*8 kappaz
      real*8 v1z,v2z,vaz
      real*8 v0spr,vaspr
      real*8 betasprtata
      complex*16 chizspr,chizsprc

      cmz2 = mz2

      kappaz   = gf*rzm2/(dsqrt(2d0)*8d0*pi)/alpha
      if (irun.eq.0) then
         chizspr = 4d0*kappaz*spr/(spr-cmz2)
      else
         chizspr = 4d0*kappaz*spr/(spr-dcmplx(mz**2,-spr*wz/mz))
      endif
      chizsprc = dconjg(chizspr)

      v1z = vdn*vta
      v2z = (vdn**2+adn**2)*(vta**2+ata**2)
      vaz = (vdn**2+adn**2)*(vta**2-ata**2)

      v0spr =
     & +qdn**2*qta**2
     & +qdn*qta*(chizspr+chizsprc)*v1z
     & +chizspr*chizsprc*v2z
      vaspr =
     & +qdn**2*qta**2
     & +qdn*qta*(chizspr+chizsprc)*v1z
     & +chizspr*chizsprc*vaz

      betasprtata = sqrt(1d0-4d0*mta**2/spr)

      hard=
     & +v0spr*betasprtata*alpha**2*alphas*cf*(-7d0/32/s**3*spr+3d0/16/s*
     & *2+1d0/32/s/spr)
     & +v0spr*betasprtata**3*alpha**2*alphas*cf*(-7d0/96/s**3*spr+1d0/16
     & /s**2+1d0/96/s/spr)
     & +v0spr*betasprtata**3*log(1-1d0/s*spr)*((s-spr)**2+spr**2)*alpha*
     & *2*alphas*cf*(1d0/24/s**3/spr)
     & +v0spr*betasprtata**3*log(1d0/mdn**2*s)*((s-spr)**2+spr**2)*alpha
     & **2*alphas*cf*(1d0/48/s**3/spr)
     & +v0spr*betasprtata*log(1-1d0/s*spr)*((s-spr)**2+spr**2)*alpha**2*
     & alphas*cf*(1d0/8/s**3/spr)
     & +v0spr*betasprtata*log(1d0/mdn**2*s)*((s-spr)**2+spr**2)*alpha**2
     & *alphas*cf*(1d0/16/s**3/spr)
     & +vaspr*betasprtata*alpha**2*alphas*cf*(-7d0/8*mta**2/s**3+3d0/4*m
     & ta**2/s**2/spr+1d0/8*mta**2/s/spr**2)
     & +vaspr*betasprtata*log(1-1d0/s*spr)*((s-spr)**2+spr**2)*alpha**2*
     & alphas*cf*(1d0/2*mta**2/s**3/spr**2)
     & +vaspr*betasprtata*log(1d0/mdn**2*s)*((s-spr)**2+spr**2)*alpha**2
     & *alphas*cf*(1d0/4*mta**2/s**3/spr**2)

      hard = hard*conhc

      return
      end
