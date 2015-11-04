************************************************************************
* sanc_nc_v1.30 package.
************************************************************************
* File (nc-qcd_br_1313_1212.f) is created on Wed Apr 18 13:34:55 MSK 2012.
************************************************************************
* This is the FORTRAN module (nc_qcd_br_1313_1212) to calculate EW Born
* cross section and QCD virtual corrections
* for the anti-up + up -> el^+ + el^- process.
*
* It is produced by s2n package of SANC (v1.10) Project.
* Copyright (C), SANC Project Team, 2002-2012.
*
* http://sanc.jinr.ru/
* http://pcphsanc.cern.ch/
* E-mail: <sanc@jinr.ru>
************************************************************************
      subroutine nc_qcd_br_1313_1212 (qs,ts,us,born,soft,hard)
      implicit none!
      include 's2n_declare.h'

      real*8 a0s,v0s,vaz
      real*8 a1z,a2z,v1z,v2z,vas
      real*8 kappaz
      real*8 betasupup
      real*8 ln1sup,jintsupup
      complex*16 chizs,chizsc

      cmz2 = mz2

      s = -qs
      t = -ts
      u = -us

      cosf = (t-u)/s
      sinf = dsqrt(1d0-cosf**2)

      kappaz   = gf*rzm2/(dsqrt(2d0)*8d0*pi)/alpha
      if (irun.eq.0) then
         chizs = 4d0*kappaz*s/(s-cmz2)
      else
         chizs = 4d0*kappaz*s/(s-dcmplx(mz**2,-s*wz/mz))
      endif
      chizsc   = dconjg(chizs)

      a1z = aup*ael
      a2z = 4d0*vup*aup*vel*ael
      v1z = vup*vel
      v2z = (vup**2+aup**2)*(vel**2+ael**2)

      v0s =
     & +qup**2*qel**2
     & +qup*qel*(chizs+chizsc)*v1z
     & +chizs*chizsc*v2z
      a0s =
     & +qup*qel*(chizs+chizsc)*a1z
     & +chizs*chizsc*a2z

      born=
     & +v0s*pi*alpha**2*(1d0/6/s+1d0/6*cosf**2/s)
     & +a0s*pi*alpha**2*(-1d0/3*cosf/s)

      born = born*conhc
      virt = 0d0
      soft = 0d0
      hard = 0d0

      if (iborn.eq.1) return

      betasupup = dsqrt(1d0-4d0*rupm2/s)
      jintsupup = dlog((1d0-betasupup)/(1d0+betasupup))
      ln1sup    = -jintsupup-1d0

      softvirt=
     & +born/pi*alphas*cf*(-1d0/2)
     & +ln1sup*born/pi*alphas*cf*(3d0/2+log(4*omega**2/s))
     & +ddilog(1d0)*born/pi*alphas*cf*(2)

      soft = softvirt

      return
      end
************************************************************************
* This is the FORTRAN module (nc_qcd_ha_1313_1212_1spr) to calculate hard
* gluon radiation for the anti-up + up -> el^+ + el^- process.
*
* It is produced by s2n package of SANC (v1.10) Project.
* Copyright (C), SANC Project Team, 2002-2012.
*
* http://sanc.jinr.ru/
* http://pcphsanc.cern.ch/
* E-mail: <sanc@jinr.ru>
************************************************************************
      subroutine nc_qcd_ha_1313_1212_1spr (s,spr,hard)
      implicit none!
      include 's2n_declare.h'

      real*8 kappaz,coef,sqs
      real*8 betasupup
      real*8 jintsupup,ln1sup
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

      v1z = vup*vel
      v2z = (vup**2+aup**2)*(vel**2+ael**2)
      vaz = (vup**2+aup**2)*(vel**2-ael**2)

      v0spr =
     & +qup**2*qel**2
     & +qup*qel*(chizspr+chizsprc)*v1z
     & +chizspr*chizsprc*v2z
      vaspr =
     & +qup**2*qel**2
     & +qup*qel*(chizspr+chizsprc)*v1z
     & +chizspr*chizsprc*vaz

      betasupup = dsqrt(1d0-4d0*rupm2/s)
      jintsupup = dlog((1d0-betasupup)/(1d0+betasupup))
      ln1sup    = -jintsupup-1d0

      hard=
     & +ln1sup*v0spr*(s**2+spr**2)*alpha**2*alphas*cf*(4d0/9/s**2/spr/(s
     & -spr)*theta_hard(s,spr,omega))

      hard = hard*conhc

      return
      end
