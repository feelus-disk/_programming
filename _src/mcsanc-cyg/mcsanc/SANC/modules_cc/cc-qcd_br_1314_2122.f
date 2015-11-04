************************************************************************
* sanc_cc_v1.40 package.
************************************************************************
* File (cc-qcd_br_1314_2122.f) is created on Tue Aug  9 22:48:51 MSD 2011.
************************************************************************
* This is the FORTRAN module (cc_qcd_br_1314_2122) to calculate EW Born
* cross section and QCD virtual corrections 
* for the anti-up + dn -> anti-tp + bt process.
*
* It is produced by s2n package of SANC (v1.10) Project.
* Copyright (C), SANC Project Team, 2002-2011.
*
* http://sanc.jinr.ru/
* http://pcphsanc.cern.ch/
* E-mail: <sanc@jinr.ru>
************************************************************************
      subroutine cc_qcd_br_1314_2122 (qs,ts,us,born,soft,hard)
      implicit none!
      include 's2n_declare.h'

      real*8 softvirtisr,softvirtfsr
      real*8 jbwbttpsq,jbwtpbtsq
      real*8 sqrtlstpbt,sqrtlsbttp,isqrtlstpbt
      real*8 betasbttp,ibetasbttp,betastpbt,ibetastpbt
      real*8 betasjtpbt,ibetasjtpbt
      complex*16 propws,propiws,propwsc

      cmw2 = mw2

      s = -qs
      t = -ts
      u = -us

      sqrtlstpbt = dsqrt((s-mtp**2-mbt**2)**2-4d0*mtp**2*mbt**2)
      sqrtlsbttp = sqrtlstpbt
      isqrtlstpbt = 1d0/sqrtlstpbt

      cosf = (u-t)/sqrtlstpbt
      sinf = dsqrt(1d0-cosf**2)

      if (irun.eq.0) then
         propiws = (cmw2-s)
      elseif (irun.eq.1) then
         propiws = (dcmplx(mw**2,-s*ww/mw)-s)
      endif
      propws = 1d0/propiws
      propwsc = dconjg(propws)

      born=
     & +sqrtlstpbt**3*propws*propwsc/pi*gf**2*mw**4/s**2*(1d0/16*cosf**2
     & )
     & +sqrtlstpbt**2*propws*propwsc/pi*gf**2*mw**4/s*(-1d0/8*cosf)
     & +sqrtlstpbt*propws*propwsc/pi*gf**2*mw**4/s**2*(-1d0/16*mbt**4+1d
     & 0/8*mtp**2*mbt**2-1d0/16*mtp**4)
     & +sqrtlstpbt*propws*propwsc/pi*gf**2*mw**4*(1d0/16)

      born = born*conhc
      virt = 0d0
      soft = 0d0
      hard = 0d0

      if (iborn.eq.1) return

      born = born/conhc

      betasbttp = sqrtlstpbt/(s+mbt**2-mtp**2)
      ibetasbttp = 1d0/betasbttp

      betastpbt = sqrtlstpbt/(s+mtp**2-mbt**2)
      ibetastpbt = 1d0/betastpbt

      betasjtpbt = sqrtlstpbt/(s-mtp**2-mbt**2)
      ibetasjtpbt = 1d0/betasjtpbt

      jbwbttpsq =
     &    log((mtp**2-mbt**2+s-sqrtlstpbt)/(mtp**2-mbt**2+s+sqrtlstpbt))
      jbwtpbtsq =
     &    log((mtp**2-mbt**2-s+sqrtlstpbt)/(mtp**2-mbt**2-s-sqrtlstpbt))

      softvirtisr=
     & +born/pi*alphas*cf*(-2)
     & +log(1d0/mup**2*s)*born/pi*alphas*cf*(3d0/4)
     & +log(1d0/mdn**2*s)*born/pi*alphas*cf*(3d0/4)
     & +log(4*omega**2/s)*born/pi*alphas*cf*(-1)
     & +log(4*omega**2/s)*log(1d0/mup**2*s)*born/pi*alphas*cf*(1d0/2)
     & +log(4*omega**2/s)*log(1d0/mdn**2*s)*born/pi*alphas*cf*(1d0/2)
     & +ddilog(1d0)*born/pi*alphas*cf*(2)

      softvirtfsr=
     & +born/pi*alphas*cf*(-2)
     & +sqrtlstpbt**2*propws*propwsc*log(1d0/mtp**2*s)/pi**2*alphas*gf**
     & 2*mw**4*cf*(-1d0/32*cosf*mbt**2/s**2+1d0/32*cosf*mtp**2/s**2)
     & +sqrtlstpbt**2*propws*propwsc*log(1d0/mbt**2*s)/pi**2*alphas*gf**
     & 2*mw**4*cf*(1d0/32*cosf*mbt**2/s**2-1d0/32*cosf*mtp**2/s**2)
     & +sqrtlstpbt*propws*propwsc*log(1d0/mtp**2*s)/pi**2*alphas*gf**2*m
     & w**4*cf*(1d0/32*mbt**2/s-1d0/32*mbt**4/s**2-1d0/32*mtp**2/s+1d0/3
     & 2*mtp**4/s**2)
     & +sqrtlstpbt*propws*propwsc*log(1d0/mbt**2*s)/pi**2*alphas*gf**2*m
     & w**4*cf*(-1d0/32*mbt**2/s+1d0/32*mbt**4/s**2+1d0/32*mtp**2/s-1d0/
     & 32*mtp**4/s**2)
     & +sqrtlstpbt*propws*propwsc*jbwbttpsq/pi**2*alphas*gf**2*mw**4*cf*
     & (-1d0/32*cosf*mbt**2/s+1d0/32*cosf*mbt**4/s**2-1d0/32*cosf*mtp**2
     & /s-1d0/16*cosf*mtp**2*mbt**2/s**2+1d0/32*cosf*mtp**4/s**2)
     & +sqrtlstpbt*propws*propwsc*jbwtpbtsq/pi**2*alphas*gf**2*mw**4*cf*
     & (-1d0/32*cosf*mbt**2/s+1d0/32*cosf*mbt**4/s**2-1d0/32*cosf*mtp**2
     & /s-1d0/16*cosf*mtp**2*mbt**2/s**2+1d0/32*cosf*mtp**4/s**2)
     & +sqrtlstpbt*jbwbttpsq*born/pi*alphas*cf*(-3d0/4/s)
     & +sqrtlstpbt*jbwtpbtsq*born/pi*alphas*cf*(-3d0/4/s)
     & +isqrtlstpbt*jbwbttpsq*born/pi*alphas*cf*(-3d0/4*mbt**2+3d0/4*mbt
     & **4/s-3d0/4*mtp**2-3d0/2*mtp**2*mbt**2/s+3d0/4*mtp**4/s)
     & +isqrtlstpbt*jbwtpbtsq*born/pi*alphas*cf*(-3d0/4*mbt**2+3d0/4*mbt
     & **4/s-3d0/4*mtp**2-3d0/2*mtp**2*mbt**2/s+3d0/4*mtp**4/s)
     & +ibetasbttp*jbwtpbtsq*born/pi*alphas*cf*(-1d0/2)
     & +ibetasjtpbt*log(1d0/mtp**2*s)*jbwbttpsq*born/pi*alphas*cf*(-1d0/
     & 2)
     & +ibetasjtpbt*log(1d0/mbt**2*s)*jbwtpbtsq*born/pi*alphas*cf*(-1d0/
     & 2)
     & +ibetasjtpbt*log(4*omega**2/s)*jbwbttpsq*born/pi*alphas*cf*(-1d0/
     & 2)
     & +ibetasjtpbt*log(4*omega**2/s)*jbwtpbtsq*born/pi*alphas*cf*(-1d0/
     & 2)
     & +ibetasjtpbt*ddilog(2/(1+betasbttp)*betasbttp)*born/pi*alphas*cf*
     & (-2)
     & +ibetasjtpbt*ddilog(2/(1+betastpbt)*betastpbt)*born/pi*alphas*cf*
     & (-2)
     & +ibetasjtpbt*ddilog(1d0)*born/pi*alphas*cf*(6)
     & +ibetasjtpbt*jbwbttpsq**2*born/pi*alphas*cf*(-1d0/2)
     & +ibetasjtpbt*jbwtpbtsq**2*born/pi*alphas*cf*(-1d0/2)
     & +ibetastpbt*jbwbttpsq*born/pi*alphas*cf*(-1d0/2)
     & +propws*propwsc*jbwbttpsq/pi**2*alphas*gf**2*mw**4*cf*(1d0/32*mbt
     & **2-1d0/16*mbt**4/s+1d0/32*mbt**6/s**2+1d0/32*mtp**2+1d0/4*mtp**2
     & *mbt**2/s-1d0/32*mtp**2*mbt**4/s**2-1d0/16*mtp**4/s-1d0/32*mtp**4
     & *mbt**2/s**2+1d0/32*mtp**6/s**2)
     & +propws*propwsc*jbwtpbtsq/pi**2*alphas*gf**2*mw**4*cf*(1d0/32*mbt
     & **2-1d0/16*mbt**4/s+1d0/32*mbt**6/s**2+1d0/32*mtp**2+1d0/4*mtp**2
     & *mbt**2/s-1d0/32*mtp**2*mbt**4/s**2-1d0/16*mtp**4/s-1d0/32*mtp**4
     & *mbt**2/s**2+1d0/32*mtp**6/s**2)
     & +log(1d0/mtp**2*s)*born/pi*alphas*cf*(-1d0/2)
     & +log(1d0/mbt**2*s)*born/pi*alphas*cf*(-1d0/2)
     & +log(4*omega**2/s)*born/pi*alphas*cf*(-1)

      soft = softvirtisr+softvirtfsr
      soft = soft*conhc
      born = born*conhc

      return
      end
************************************************************************
* This is the FORTRAN module (cc_qcd_ha_1314_2122_1spr) to calculate hard
* gluon radiation for the anti-up + dn -> anti-tp + bt process.
*
* It is produced by s2n package of SANC (v1.10) Project.
* Copyright (C), SANC Project Team, 2002-2011.
*
* http://sanc.jinr.ru/
* http://pcphsanc.cern.ch/
* E-mail: <sanc@jinr.ru>
************************************************************************
      subroutine cc_qcd_ha_1314_2122_1spr (s,spr,hard)
      implicit none!
      include 's2n_declare.h'

      real*8 sq,sqspr
      real*8 bornints,bornintspr
      real*8 betasjtpbt,ibetasjtpbt
      real*8 sqrtlsprtpbt,sqrtlsprbttp,isqrtlsprtpbt
      real*8 sqrtlstpbt,sqrtlsbttp,isqrtlstpbt
      real*8 jbwbttpsqspr,jbwtpbtsqspr

      complex*16 propiws,propws,propwsc,propiwspr,propwspr,propwsprc

      external cc_bo_1314_2122

      cmw2 = mw2

      sq = dsqrt(s)
      sqspr = dsqrt(spr)

      sqrtlstpbt = dsqrt((s-mtp**2-mbt**2)**2-4d0*mtp**2*mbt**2)
      sqrtlsbttp = sqrtlstpbt
      isqrtlstpbt = 1d0/sqrtlstpbt

      sqrtlsprtpbt = dsqrt((spr-mtp**2-mbt**2)**2-4d0*mtp**2*mbt**2)
      sqrtlsprbttp = sqrtlsprtpbt
      isqrtlsprtpbt = 1d0/sqrtlsprtpbt

      betasjtpbt = sqrtlstpbt/(s-mtp**2-mbt**2)
      ibetasjtpbt = 1d0/betasjtpbt

      if (irun.eq.0) then
         propiws = (cmw2-s)
         propiwspr = (cmw2-spr)
      elseif (irun.eq.1) then
         propiws = (dcmplx(mw**2,-s*ww/mw)-s)
         propiwspr = (dcmplx(mw**2,-spr*ww/mw)-spr)
      endif
      propws = 1d0/propiws
      propwsc = dconjg(propws)
      propwspr = 1d0/propiwspr
      propwsprc = dconjg(propwspr)

      jbwbttpsqspr =
     &    log((mtp**2-mbt**2+spr-sqrtlsprtpbt)/(mtp**2-mbt**2+spr+sqrtlsprtpbt))
      jbwtpbtsqspr =
     &    log((mtp**2-mbt**2-spr+sqrtlsprtpbt)/(mtp**2-mbt**2-spr-sqrtlsprtpbt))

      call cc_bo_1314_2122 (s,bornints)
      bornints = bornints/conhc

      call cc_bo_1314_2122 (spr,bornintspr)
      bornintspr = bornintspr/conhc

      hardisr=
     & +bornintspr*(s**2+spr**2)/pi*alphas/(s-spr)*theta_hard(s,spr,omeg
     & a)*cf*(-1d0/s**2)
     & +bornintspr*log(1d0/mup**2*s)*(s**2+spr**2)/pi*alphas/(s-spr)*the
     & ta_hard(s,spr,omega)*cf*(1d0/2/s**2)
     & +bornintspr*log(1d0/mdn**2*s)*(s**2+spr**2)/pi*alphas/(s-spr)*the
     & ta_hard(s,spr,omega)*cf*(1d0/2/s**2)

      hardfsr=
     & +bornints*sqrtlsprtpbt*isqrtlstpbt/pi*alphas/(s-spr)*theta_hard(s
     & ,spr,omega)*cf*(-2)
     & +bornints*isqrtlstpbt*jbwbttpsqspr/pi*alphas/(s-spr)*theta_hard(s
     & ,spr,omega)*cf*(mbt**2+mtp**2)
     & +bornints*isqrtlstpbt*jbwtpbtsqspr/pi*alphas/(s-spr)*theta_hard(s
     & ,spr,omega)*cf*(mbt**2+mtp**2)
     & +sqrtlsprtpbt*propws*propwsc/pi**2*alphas*gf**2*mw**4*(s-spr)*cf*
     & (-1d0/6/s/spr)
     & +propws*propwsc*jbwbttpsqspr/pi**2*alphas*gf**2*mw**4/(s-spr)*the
     & ta_hard(s,spr,omega)*cf*(-1d0/6*s+1d0/12*mbt**2+1d0/12*mbt**4/s+1
     & d0/12*mtp**2-1d0/6*mtp**2*mbt**2/s+1d0/12*mtp**4/s)
     & +propws*propwsc*jbwbttpsqspr/pi**2*alphas*gf**2*mw**4*cf*(1d0/6-1
     & d0/12*mbt**2/s-1d0/12*mbt**4/s**2-1d0/12*mtp**2/s+1d0/6*mtp**2*mb
     & t**2/s**2-1d0/12*mtp**4/s**2)
     & +propws*propwsc*jbwbttpsqspr/pi**2*alphas*gf**2*mw**4*(s-spr)*cf*
     & (-1d0/12/s-1d0/24*mbt**2/s**2-1d0/24*mtp**2/s**2)
     & +propws*propwsc*jbwtpbtsqspr/pi**2*alphas*gf**2*mw**4/(s-spr)*the
     & ta_hard(s,spr,omega)*cf*(-1d0/6*s+1d0/12*mbt**2+1d0/12*mbt**4/s+1
     & d0/12*mtp**2-1d0/6*mtp**2*mbt**2/s+1d0/12*mtp**4/s)
     & +propws*propwsc*jbwtpbtsqspr/pi**2*alphas*gf**2*mw**4*cf*(1d0/6-1
     & d0/12*mbt**2/s-1d0/12*mbt**4/s**2-1d0/12*mtp**2/s+1d0/6*mtp**2*mb
     & t**2/s**2-1d0/12*mtp**4/s**2)
     & +propws*propwsc*jbwtpbtsqspr/pi**2*alphas*gf**2*mw**4*(s-spr)*cf*
     & (-1d0/12/s-1d0/24*mbt**2/s**2-1d0/24*mtp**2/s**2)

      hard = hardisr+hardfsr
      hard = hard*conhc

      return
      end
