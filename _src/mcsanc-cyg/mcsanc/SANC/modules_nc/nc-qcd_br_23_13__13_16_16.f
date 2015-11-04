************************************************************************
* sanc_nc_v1.30 package.
************************************************************************
* File (nc-qcd_br_23_13__13_16_16.f) is created on Wed Apr 18 13:37:13 MSK 2012.
*****************************************************************************
* This is the FORTRAN module (nc_qcd_ha_23_13__13_16_16_1spr) to calculate
* differential cross-section for the gluon induced g + up -> up + mo^+ + mo^- process.
*
* It is produced by s2n package of SANC (v1.10) Project.
* Copyright (C), SANC Project Team, 2002-2012.
*
* http://sanc.jinr.ru/
* http://pcphsanc.cern.ch/
* E-mail: <sanc@jinr.ru>
*****************************************************************************
      subroutine nc_qcd_ha_23_13__13_16_16_1spr (s,spr,hard)
      implicit none!
      include 's2n_declare.h'

      real*8 kappaz
      real*8 v1z,v2z,vaz
      real*8 v0spr,vaspr
      real*8 betasprmomo
      complex*16 chizspr,chizsprc

      cmz2 = mz2

      kappaz   = gf*rzm2/(dsqrt(2d0)*8d0*pi)/alpha
      if (irun.eq.0) then
         chizspr = 4d0*kappaz*spr/(spr-cmz2)
      else
         chizspr = 4d0*kappaz*spr/(spr-dcmplx(mz**2,-spr*wz/mz))
      endif
      chizsprc = dconjg(chizspr)

      v1z = vup*vmo
      v2z = (vup**2+aup**2)*(vmo**2+amo**2)
      vaz = (vup**2+aup**2)*(vmo**2-amo**2)

      v0spr =
     & +qup**2*qmo**2
     & +qup*qmo*(chizspr+chizsprc)*v1z
     & +chizspr*chizsprc*v2z
      vaspr =
     & +qup**2*qmo**2
     & +qup*qmo*(chizspr+chizsprc)*v1z
     & +chizspr*chizsprc*vaz

      betasprmomo = sqrt(1d0-4d0*mmo**2/spr)

      hard=
     & +v0spr*betasprmomo*alpha**2*alphas*cf*(-7d0/32/s**3*spr+3d0/16/s*
     & *2+1d0/32/s/spr)
     & +v0spr*betasprmomo**3*alpha**2*alphas*cf*(-7d0/96/s**3*spr+1d0/16
     & /s**2+1d0/96/s/spr)
     & +v0spr*betasprmomo**3*log(1-1d0/s*spr)*((s-spr)**2+spr**2)*alpha*
     & *2*alphas*cf*(1d0/24/s**3/spr)
     & +v0spr*betasprmomo**3*log(1d0/mup**2*s)*((s-spr)**2+spr**2)*alpha
     & **2*alphas*cf*(1d0/48/s**3/spr)
     & +v0spr*betasprmomo*log(1-1d0/s*spr)*((s-spr)**2+spr**2)*alpha**2*
     & alphas*cf*(1d0/8/s**3/spr)
     & +v0spr*betasprmomo*log(1d0/mup**2*s)*((s-spr)**2+spr**2)*alpha**2
     & *alphas*cf*(1d0/16/s**3/spr)
     & +vaspr*betasprmomo*alpha**2*alphas*cf*(-7d0/8*mmo**2/s**3+3d0/4*m
     & mo**2/s**2/spr+1d0/8*mmo**2/s/spr**2)
     & +vaspr*betasprmomo*log(1-1d0/s*spr)*((s-spr)**2+spr**2)*alpha**2*
     & alphas*cf*(1d0/2*mmo**2/s**3/spr**2)
     & +vaspr*betasprmomo*log(1d0/mup**2*s)*((s-spr)**2+spr**2)*alpha**2
     & *alphas*cf*(1d0/4*mmo**2/s**3/spr**2)

      hard = hard*conhc

      return
      end
