************************************************************************
* sanc_nc_v1.30 package.
************************************************************************
* File (nc-qcd_br_14_23__14_12_12.f) is created on Wed Apr 18 13:38:22 MSK 2012.
*****************************************************************************
* This is the FORTRAN module (nc_qcd_ha_14_23__14_12_12_1spr) to calculate
* differential cross-section for the gluon induced anti-dn + g -> anti-dn + el^+ + el^- process.
*
* It is produced by s2n package of SANC (v1.10) Project.
* Copyright (C), SANC Project Team, 2002-2012.
*
* http://sanc.jinr.ru/
* http://pcphsanc.cern.ch/
* E-mail: <sanc@jinr.ru>
*****************************************************************************
      subroutine nc_qcd_ha_14_23__14_12_12_1spr (s,spr,hard)
      implicit none!
      include 's2n_declare.h'

      real*8 kappaz
      real*8 v1z,v2z,vaz
      real*8 v0spr,vaspr
      complex*16 chizspr,chizsprc

      cmz2 = mz2

      kappaz   = gf*rzm2/(dsqrt(2d0)*8d0*pi)/alpha
      if (irun.eq.0) then
         chizspr = 4d0*kappaz*spr/(spr-cmz2)
      else
         chizspr = 4d0*kappaz*spr/(spr-dcmplx(mz**2,-spr*wz/mz))
      endif
      chizsprc = dconjg(chizspr)

      v1z = vdn*vel
      v2z = (vdn**2+adn**2)*(vel**2+ael**2)

      v0spr =
     & +qdn**2*qel**2
     & +qdn*qel*(chizspr+chizsprc)*v1z
     & +chizspr*chizsprc*v2z

      hard=
     & +v0spr*alpha**2*alphas*cf*(-7d0/24/s**3*spr+1d0/4/s**2+1d0/24/s/s
     & pr)
     & +v0spr*log(1-1d0/s*spr)*((s-spr)**2+spr**2)*alpha**2*alphas*cf*(1
     & d0/6/s**3/spr)
     & +v0spr*log(1d0/mdn**2*s)*((s-spr)**2+spr**2)*alpha**2*alphas*cf*(
     & 1d0/12/s**3/spr)

      hard = hard*conhc

      return
      end
