************************************************************************
* sanc_nc_v1.30 package.
************************************************************************
* File (nc-qcd_ha_1313_1616.f) is created on Wed Apr 18 13:36:04 MSK 2012.
************************************************************************
* This is the FORTRAN module (nc_qcd_ha_1313_1616) to calculate differential
* hard gluon radiation for the anti-up + up -> mo^+ + mo^- process.
*
* It is produced by s2n package of SANC (v1.10) Project.
* Copyright (C), SANC Project Team, 2002-2012.
*
* http://sanc.jinr.ru/
* http://pcphsanc.cern.ch/
* E-mail: <sanc@jinr.ru>
************************************************************************
      subroutine nc_qcd_ha_1313_1616 (s,spr,ph4,costh4,costh5,hard)
      implicit none!
      include 's2n_declare.h'

      real*8 kappaz,sq,sqspr
      real*8 a1z,a2z,v1z,v2z,vaz
      real*8 p1p2,p1p3,p1p4,p1p5,p2p3,p2p4,p2p5,p3p4,p3p5,p4p5
      real*8 ph4,cosph4,sinph4,costh4,costh5,sinth4,sinth5
      complex*16 chizs,chizsc,chizspr,chizsprc

      real*8 betasprmomo,ibetasprmomo,betasupup,ibetasupup
      real*8 iz1up,iz2up
      real*8 v0spr,a0spr,vaspr

      cmz2 = mz2

      sq = dsqrt(s)
      sqspr = dsqrt(spr)

      cosph4 = dcos(ph4)
      sinph4 = dsin(ph4)
      sinth4 = dsqrt(1d0-costh4**2)
      sinth5 = dsqrt(1d0-costh5**2)

      kappaz   = gf*rzm2/(dsqrt(2d0)*8d0*pi)/alpha
      if (irun.eq.0) then
         chizs   = 4d0*kappaz*s/(s-cmz2)
         chizspr = 4d0*kappaz*spr/(spr-cmz2)
      else
         chizs   = 4d0*kappaz*s/(s-dcmplx(mz**2,-s*wz/mz))
         chizspr = 4d0*kappaz*spr/(spr-dcmplx(mz**2,-spr*wz/mz))
      endif
      chizsc   = dconjg(chizs)
      chizsprc = dconjg(chizspr)

      a1z = aup*amo
      a2z = 4d0*vup*aup*vmo*amo
      v1z = vup*vmo
      v2z = (vup**2+aup**2)*(vmo**2+amo**2)
      vaz = (vup**2+aup**2)*(vmo**2-amo**2)

      betasprmomo = sqrt(1d0-4d0*rmom2/spr)
      ibetasprmomo = 1d0/betasprmomo
      betasupup = sqrt(1d0-4d0*rupm2/s)
      ibetasupup = 1d0/betasupup
      
      v0spr =
     & +qup**2*qmo**2
     & +qup*qmo*(chizspr+chizsprc)*v1z
     & +chizspr*chizsprc*v2z
      
      a0spr =
     & +qup*qmo*(chizspr+chizsprc)*a1z
     & +chizspr*chizsprc*a2z
      
      vaspr =
     & +qup**2*qmo**2
     & +qup*qmo*(chizspr+chizsprc)*v1z
     & +chizspr*chizsprc*vaz

      p1p2=
     & -1d0/2*s

      p1p3=
     & +sinph4*sinth4*sinth5*(-1d0/4*betasprmomo*sq*sqspr)
     & +costh4*costh5*(1d0/8*betasprmomo*spr+1d0/8*betasprmomo*s)
     & +costh4*(1d0/8*betasprmomo*spr-1d0/8*betasprmomo*s)
     & +costh5*(-1d0/8*spr+1d0/8*s)
     & -1d0/8*spr-1d0/8*s

      p1p4=
     & +sinph4*sinth4*sinth5*(1d0/4*betasprmomo*sq*sqspr)
     & +costh4*costh5*(-1d0/8*betasprmomo*spr-1d0/8*betasprmomo*s)
     & +costh4*(-1d0/8*betasprmomo*spr+1d0/8*betasprmomo*s)
     & +costh5*(-1d0/8*spr+1d0/8*s)
     & -1d0/8*spr-1d0/8*s

      p1p5=
     & +costh5*(1d0/4*spr-1d0/4*s)
     & +1d0/4*spr-1d0/4*s

      p2p3=
     & +sinph4*sinth4*sinth5*(1d0/4*betasprmomo*sq*sqspr)
     & +costh4*costh5*(-1d0/8*betasprmomo*spr-1d0/8*betasprmomo*s)
     & +costh4*(1d0/8*betasprmomo*spr-1d0/8*betasprmomo*s)
     & +costh5*(1d0/8*spr-1d0/8*s)
     & -1d0/8*spr-1d0/8*s

      p2p4=
     & +sinph4*sinth4*sinth5*(-1d0/4*betasprmomo*sq*sqspr)
     & +costh4*costh5*(1d0/8*betasprmomo*spr+1d0/8*betasprmomo*s)
     & +costh4*(-1d0/8*betasprmomo*spr+1d0/8*betasprmomo*s)
     & +costh5*(1d0/8*spr-1d0/8*s)
     & -1d0/8*spr-1d0/8*s

      p2p5=
     & +costh5*(-1d0/4*spr+1d0/4*s)
     & +1d0/4*spr-1d0/4*s

      p3p4=
     & -1d0/2*spr+mmo**2

      p3p5=
     & +costh4*(1d0/4*betasprmomo*spr-1d0/4*betasprmomo*s)
     & +1d0/4*spr-1d0/4*s

      p4p5=
     & +costh4*(-1d0/4*betasprmomo*spr+1d0/4*betasprmomo*s)
     & +1d0/4*spr-1d0/4*s

      iz1up=
     & +1d0/(mup**2/s+1d0/4*betasupup**2*sinth5**2)/(s-spr)*(1d0/2-1d0/2
     & *betasupup*costh5)

      iz2up=
     & +1d0/(mup**2/s+1d0/4*betasupup**2*sinth5**2)/(s-spr)*(1d0/2+1d0/2
     & *betasupup*costh5)

      hard=
     & +v0spr*iz1up**2*theta_hard(s,spr,omega)*betasprmomo/pi*alpha**2*a
     & lphas*(s-spr)*cf*(-1d0/3*p1p3*p2p4*mup**2/s**2/spr**2-1d0/3*p1p4*
     & p2p3*mup**2/s**2/spr**2+1d0/3*p2p3*p4p5*mup**2/s**2/spr**2+1d0/3*
     & p2p4*p3p5*mup**2/s**2/spr**2)
     & +v0spr*iz1up*iz2up*theta_hard(s,spr,omega)*betasprmomo/pi*alpha**
     & 2*alphas*(s-spr)*cf*(1d0/3*p1p3*p2p4/s/spr**2-1d0/6*p1p3*p4p5/s/s
     & pr**2+1d0/3*p1p4*p2p3/s/spr**2-1d0/6*p1p4*p3p5/s/spr**2-1d0/6*p2p
     & 3*p4p5/s/spr**2-1d0/6*p2p4*p3p5/s/spr**2)
     & +v0spr*iz1up*betasprmomo/pi*alpha**2*alphas*(s-spr)*cf*(1d0/3*p1p
     & 3*p1p4/s**2/spr**2-1d0/6*p1p3*p2p4/s**2/spr**2-1d0/6*p1p4*p2p3/s*
     & *2/spr**2+1d0/6*p2p3*p4p5/s**2/spr**2+1d0/6*p2p4*p3p5/s**2/spr**2
     & )
     & +v0spr*iz2up**2*theta_hard(s,spr,omega)*betasprmomo/pi*alpha**2*a
     & lphas*(s-spr)*cf*(-1d0/3*p1p3*p2p4*mup**2/s**2/spr**2+1d0/3*p1p3*
     & p4p5*mup**2/s**2/spr**2-1d0/3*p1p4*p2p3*mup**2/s**2/spr**2+1d0/3*
     & p1p4*p3p5*mup**2/s**2/spr**2)
     & +v0spr*iz2up*betasprmomo/pi*alpha**2*alphas*(s-spr)*cf*(-1d0/6*p1
     & p3*p2p4/s**2/spr**2+1d0/6*p1p3*p4p5/s**2/spr**2-1d0/6*p1p4*p2p3/s
     & **2/spr**2+1d0/6*p1p4*p3p5/s**2/spr**2+1d0/3*p2p3*p2p4/s**2/spr**
     & 2)
     & +a0spr*iz1up**2*theta_hard(s,spr,omega)*betasprmomo/pi*alpha**2*a
     & lphas*(s-spr)*cf*(-1d0/3*p1p3*p2p4*mup**2/s**2/spr**2+1d0/3*p1p4*
     & p2p3*mup**2/s**2/spr**2-1d0/3*p2p3*p4p5*mup**2/s**2/spr**2+1d0/3*
     & p2p4*p3p5*mup**2/s**2/spr**2)
     & +a0spr*iz1up*iz2up*theta_hard(s,spr,omega)*betasprmomo/pi*alpha**
     & 2*alphas*(s-spr)*cf*(1d0/3*p1p3*p2p4/s/spr**2-1d0/6*p1p3*p4p5/s/s
     & pr**2-1d0/3*p1p4*p2p3/s/spr**2+1d0/6*p1p4*p3p5/s/spr**2+1d0/6*p2p
     & 3*p4p5/s/spr**2-1d0/6*p2p4*p3p5/s/spr**2)
     & +a0spr*iz1up*betasprmomo/pi*alpha**2*alphas*(s-spr)*cf*(-1d0/6*p1
     & p3*p2p4/s**2/spr**2+1d0/6*p1p4*p2p3/s**2/spr**2-1d0/6*p2p3*p4p5/s
     & **2/spr**2+1d0/6*p2p4*p3p5/s**2/spr**2)
     & +a0spr*iz2up**2*theta_hard(s,spr,omega)*betasprmomo/pi*alpha**2*a
     & lphas*(s-spr)*cf*(-1d0/3*p1p3*p2p4*mup**2/s**2/spr**2+1d0/3*p1p3*
     & p4p5*mup**2/s**2/spr**2+1d0/3*p1p4*p2p3*mup**2/s**2/spr**2-1d0/3*
     & p1p4*p3p5*mup**2/s**2/spr**2)
     & +a0spr*iz2up*betasprmomo/pi*alpha**2*alphas*(s-spr)*cf*(-1d0/6*p1
     & p3*p2p4/s**2/spr**2+1d0/6*p1p3*p4p5/s**2/spr**2+1d0/6*p1p4*p2p3/s
     & **2/spr**2-1d0/6*p1p4*p3p5/s**2/spr**2)
     & +vaspr*iz1up**2*theta_hard(s,spr,omega)*betasprmomo/pi*alpha**2*a
     & lphas*(s-spr)*cf*(-1d0/6*mup**2*mmo**2/s**2/spr)
     & +vaspr*iz1up*iz2up*theta_hard(s,spr,omega)*betasprmomo/pi*alpha**
     & 2*alphas*(s-spr)*cf*(1d0/6*mmo**2/spr**2)
     & +vaspr*iz1up*betasprmomo/pi*alpha**2*alphas*(s-spr)*cf*(-1d0/12*m
     & mo**2/s**2/spr-1d0/12*mmo**2/s/spr**2)
     & +vaspr*iz2up**2*theta_hard(s,spr,omega)*betasprmomo/pi*alpha**2*a
     & lphas*(s-spr)*cf*(-1d0/6*mup**2*mmo**2/s**2/spr)
     & +vaspr*iz2up*betasprmomo/pi*alpha**2*alphas*(s-spr)*cf*(-1d0/12*m
     & mo**2/s**2/spr-1d0/12*mmo**2/s/spr**2)
     & +vaspr*betasprmomo/pi*alpha**2*alphas*(s-spr)*cf*(-1d0/6*mmo**2/s
     & **2/spr**2)

      hard = hard*conhc

      return
      end
