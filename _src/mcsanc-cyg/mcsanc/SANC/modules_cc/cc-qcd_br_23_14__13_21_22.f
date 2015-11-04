************************************************************************
* sanc_cc_v1.60 package.
************************************************************************
* File (cc-qcd_br_23_14__13_21_22.f) is created on Mon Mar 26 11:56:54 MSK 2012.
************************************************************************
* This is the FORTRAN module (cc_qcd_ha_23_14__13_21_22_1spr) to calculate
* the gluon induced g + dn -> up + anti-tp + bt process.
*
* It is produced by s2n package of SANC (v1.10) Project.
* Copyright (C), SANC Project Team, 2002-2012.
*
* http://sanc.jinr.ru/
* http://pcphsanc.cern.ch/
* E-mail: <sanc@jinr.ru>
************************************************************************
      subroutine cc_qcd_ha_23_14__13_21_22_1spr (s,spr,hard)
      implicit none!
      include 's2n_declare.h'

      real*8 sqrtlsprtpbt,isqrtlsprtpbt
      real*8 kappaw
      complex*16 chiwspr,chiwsprc

      cmw2 = mw2

      kappaw = gf*rwm2/(sqrt(2d0)*4d0*pi)/alpha
      if (irun.eq.0) then
         chiwspr = 4d0*kappaw*spr/(spr-cmw2)
      else
         chiwspr = 4d0*kappaw*spr/(spr-dcmplx(mw**2,-spr*ww/mw))
      endif
      chiwsprc = dconjg(chiwspr)

      sqrtlsprtpbt = sqrt(spr**2-2d0*spr*(rtpm2+rbtm2)+(rtpm2-rbtm2)**2)
      isqrtlsprtpbt = 1d0/sqrtlsprtpbt


      hard=
     & +sqrtlsprtpbt*chiwspr*chiwsprc*alpha**2*alphas*cf*(-1d0/32/s**2/s
     & pr+9d0/64/s/spr**2+1d0/64*mbt**2/s**2/spr**2-9d0/128*mbt**2/s/spr
     & **3+1d0/64*mbt**4/s**2/spr**3-9d0/128*mbt**4/s/spr**4+1d0/64*mtp*
     & *2/s**2/spr**2-9d0/128*mtp**2/s/spr**3-1d0/32*mtp**2*mbt**2/s**2/
     & spr**3+9d0/64*mtp**2*mbt**2/s/spr**4+1d0/64*mtp**4/s**2/spr**3-9d
     & 0/128*mtp**4/s/spr**4)
     & +sqrtlsprtpbt*chiwspr*chiwsprc*((s-spr)**2+spr**2)*alpha**2*alpha
     & s*cf*(-7d0/64/s**3/spr**2+7d0/128*mbt**2/s**3/spr**3+7d0/128*mbt*
     & *4/s**3/spr**4+7d0/128*mtp**2/s**3/spr**3-7d0/64*mtp**2*mbt**2/s*
     & *3/spr**4+7d0/128*mtp**4/s**3/spr**4)
     & +sqrtlsprtpbt*chiwspr*chiwsprc*log(1-1d0/s*spr)*((s-spr)**2+spr**
     & 2)*alpha**2*alphas*cf*(1d0/8/s**3/spr**2-1d0/16*mbt**2/s**3/spr**
     & 3-1d0/16*mbt**4/s**3/spr**4-1d0/16*mtp**2/s**3/spr**3+1d0/8*mtp**
     & 2*mbt**2/s**3/spr**4-1d0/16*mtp**4/s**3/spr**4)
     & +sqrtlsprtpbt*chiwspr*chiwsprc*log(1d0/mdn**2*s)*((s-spr)**2+spr*
     & *2)*alpha**2*alphas*cf*(1d0/16/s**3/spr**2-1d0/32*mbt**2/s**3/spr
     & **3-1d0/32*mbt**4/s**3/spr**4-1d0/32*mtp**2/s**3/spr**3+1d0/16*mt
     & p**2*mbt**2/s**3/spr**4-1d0/32*mtp**4/s**3/spr**4)

      hard = hard*conhc

      return
      end
