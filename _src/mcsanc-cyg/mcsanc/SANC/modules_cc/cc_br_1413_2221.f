************************************************************************
* sanc_cc_v1.40 package.
************************************************************************
* File (cc_br_1413_2221.f) is created on Tue Aug  9 22:48:00 MSD 2011.
************************************************************************
* This is the FORTRAN module (cc_bo_1413_2221) to calculate EW
* integrated Born cross section for the anti-dn + up -> anti-bt + tp process.
*
* It is produced by s2n package of SANC (v1.10) Project.
* Copyright (C), SANC Project Team, 2002-2011.
*
* http://sanc.jinr.ru/
* http://pcphsanc.cern.ch/
* E-mail: <sanc@jinr.ru>
************************************************************************
      subroutine cc_bo_1413_2221 (s,born)
      implicit none!
      include 's2n_declare.h'

      real*8 kappaw
      complex*16 chiws,chiwsc
      real*8 sqrtlstpbt,sqrtlsbttp

      cmw2 = mw2

      sqrtlstpbt = dsqrt((s-mtp**2-mbt**2)**2-4d0*mtp**2*mbt**2)
      sqrtlsbttp = sqrtlstpbt

      kappaw = gf*rwm2/(sqrt(2d0)*4d0*pi)/alpha
      if (irun.eq.0) then
         chiws = 4d0*kappaw*s/(s-cmw2)
      else
         chiws = 4d0*kappaw*s/(s-dcmplx(mw**2,-s*ww/mw))
      endif
      chiwsc = dconjg(chiws)

      born=
     & +sqrtlsbttp*chiws*chiwsc*pi*alpha**2*(1d0/3/s**2-1d0/6*mbt**2/s**
     & 3-1d0/6*mbt**4/s**4-1d0/6*mtp**2/s**3+1d0/3*mtp**2*mbt**2/s**4-1d
     & 0/6*mtp**4/s**4)

      born = born*conhc

      return
      end
************************************************************************
* This is the FORTRAN module (cc_br_1413_2221) to calculate EW Born
* cross section and soft photon Bremsstrahlung
* for the anti-dn + up -> anti-bt + tp process.
*
* It is produced by s2n package of SANC (v1.10) Project.
* Copyright (C), SANC Project Team, 2002-2011.
*
* http://sanc.jinr.ru/
* http://pcphsanc.cern.ch/
* E-mail: <sanc@jinr.ru>
************************************************************************
      subroutine cc_br_1413_2221 (qs,ts,us,born,soft,hard)
      implicit none!
      include 's2n_declare.h'

      real*8 qw
      real*8 softvirtisr,softvirtfsr,softvirtifi
      real*8 ln1sdn,ln1sup,jbwbttpsq,jbwtpbtsq
      real*8 sqrtlstpbt,sqrtlsbttp
      real*8 betasbttp,ibetasbttp,betastpbt,ibetastpbt
      real*8 betasjtpbt,ibetasjtpbt
      real*8 pxxstpjbt,ipxxstpjbt,pxxsbtjtp,ipxxsbtjtp
      real*8 kappaw
      complex*16 chiws,chiwsc

      cmw2 = mw2
      qw = 1d0

      s = -qs
      t = -ts
      u = -us

      sqrtlstpbt = dsqrt((s-mtp**2-mbt**2)**2-4d0*mtp**2*mbt**2)
      sqrtlsbttp = sqrtlstpbt

      cosf = (u-t)/sqrtlstpbt
      sinf = dsqrt(1d0-cosf**2)

      kappaw = gf*rwm2/(sqrt(2d0)*4d0*pi)/alpha
      if (irun.eq.0) then
         chiws = 4d0*kappaw*s/(s-cmw2)
      else
         chiws = 4d0*kappaw*s/(s-dcmplx(mw**2,-s*ww/mw))
      endif
      chiwsc = dconjg(chiws)

      born=
     & +sqrtlsbttp*chiws*chiwsc*pi*alpha**2*(1d0/8/s**2-1d0/8*mbt**4/s**
     & 4+1d0/4*mtp**2*mbt**2/s**4-1d0/8*mtp**4/s**4)
     & +sqrtlsbttp*chiws*chiwsc*cosf**2*pi*alpha**2*(1d0/8/s**2-1d0/4*mb
     & t**2/s**3+1d0/8*mbt**4/s**4-1d0/4*mtp**2/s**3-1d0/4*mtp**2*mbt**2
     & /s**4+1d0/8*mtp**4/s**4)
     & +chiws*chiwsc*cosf*pi*alpha**2*(-1d0/4/s+1d0/2*mbt**2/s**2-1d0/4*
     & mbt**4/s**3+1d0/2*mtp**2/s**2+1d0/2*mtp**2*mbt**2/s**3-1d0/4*mtp*
     & *4/s**3)

      born = born*conhc
      virt = 0d0
      soft = 0d0
      hard = 0d0

      if (iborn.eq.1) return

      betasbttp = sqrtlstpbt/(s+mbt**2-mtp**2)
      ibetasbttp = 1d0/betasbttp

      betastpbt = sqrtlstpbt/(s+mtp**2-mbt**2)
      ibetastpbt = 1d0/betastpbt

      betasjtpbt = sqrtlstpbt/(s-mtp**2-mbt**2)
      ibetasjtpbt = 1d0/betasjtpbt

      pxxstpjbt = (s+mtp**2-mbt**2)
      ipxxstpjbt = 1d0/pxxstpjbt

      pxxsbtjtp = (s+mbt**2-mtp**2)
      ipxxsbtjtp = 1d0/pxxsbtjtp

      ln1sup = log(s/mup**2)-1d0
      ln1sdn = log(s/mdn**2)-1d0

      jbwbttpsq =
     &    log((mtp**2-mbt**2+s-sqrtlstpbt)/(mtp**2-mbt**2+s+sqrtlstpbt))
      jbwtpbtsq =
     &    log((mtp**2-mbt**2-s+sqrtlstpbt)/(mtp**2-mbt**2-s-sqrtlstpbt))

      softvirtisr=
     & +born/pi*alpha*qdn**2*(3d0/4-3d0/4*log(s/thmu2))
     & +born/pi*alpha*qup**2*(3d0/4-3d0/4*log(s/thmu2))
     & +ln1sdn*log(4*omega**2/s)*born/pi*alpha*qdn**2*(1d0/2)
     & +ln1sup*log(4*omega**2/s)*born/pi*alpha*qup**2*(1d0/2)
     & +log(1d0/mup**2*s)*born/pi*alpha*qup**2*(3d0/4)
     & +log(1d0/mdn**2*s)*born/pi*alpha*qdn**2*(3d0/4)
     & +log(4*omega**2/s)*born/pi*alpha*qw**2*(-1d0/2)
     & +ddilog(1d0)*born/pi*alpha*qup*qdn*(2)

      softvirtfsr=
     & +born/pi*alpha*qbt**2*(3d0/4-3d0/4*log(s/thmu2))
     & +born/pi*alpha*qtp**2*(3d0/4-3d0/4*log(s/thmu2))
     & +born/pi*alpha*qw**2*(1)
     & +ibetasbttp*log(4*omega**2/s)*jbwtpbtsq*born/pi*alpha*qw*qbt*(1d0
     & /2)
     & +ibetasbttp*ddilog(2/(1+betasbttp)*betasbttp)*born/pi*alpha*qw*qb
     & t*(1)
     & +ibetasbttp*jbwtpbtsq*born/pi*alpha*qbt**2*(-1d0/2)
     & +ibetasbttp*jbwtpbtsq**2*born/pi*alpha*qw*qbt*(1d0/4)
     & +ibetasjtpbt*log(1d0/2+1d0/2*ibetasbttp)*log(sqrtlstpbt/s)*born/p
     & i*alpha*qtp*qbt*(-1)
     & +ibetasjtpbt*log(1d0/2+1d0/2*ibetastpbt)*log(sqrtlstpbt/s)*born/p
     & i*alpha*qtp*qbt*(-1)
     & +ibetasjtpbt*log(1d0/mtp**2*s)*log(1d0/2+1d0/2*ibetastpbt)*born/p
     & i*alpha*qtp*qbt*(-1d0/2)
     & +ibetasjtpbt*log(1d0/mtp**2*s)**2*born/pi*alpha*qtp*qbt*(-1d0/4)
     & +ibetasjtpbt*log(1d0/mtp**2*s)*log(sqrtlstpbt/s)*born/pi*alpha*qt
     & p*qbt*(-1)
     & +ibetasjtpbt*log(1d0/mtp**2*s)*jbwbttpsq*born/pi*alpha*qtp*qbt*(-
     & 1d0/2)
     & +ibetasjtpbt*log(4*omega**2/s)*jbwbttpsq*born/pi*alpha*qtp*qbt*(-
     & 1d0/2)
     & +ibetasjtpbt*log(4*omega**2/s)*jbwtpbtsq*born/pi*alpha*qtp*qbt*(-
     & 1d0/2)
     & +ibetasjtpbt*log(sqrtlstpbt/s)**2*born/pi*alpha*qtp*qbt*(-2)
     & +ibetasjtpbt*ddilog(1d0/2-1d0/2*ibetasbttp)*born/pi*alpha*qtp*qbt
     & *(-1)
     & +ibetasjtpbt*ddilog(1d0/2+1d0/2*ibetasbttp)*born/pi*alpha*qtp*qbt
     & *(1d0/2)
     & +ibetasjtpbt*ddilog(1d0/2-1d0/2*ibetastpbt)*born/pi*alpha*qtp*qbt
     & *(-1)
     & +ibetasjtpbt*ddilog(1d0/2+1d0/2*ibetastpbt)*born/pi*alpha*qtp*qbt
     & *(1d0/2)
     & +ibetasjtpbt*ddilog(2/(1+betasbttp)*betasbttp)*born/pi*alpha*qtp*
     & qbt*(-1d0/2)
     & +ibetasjtpbt*ddilog(2/(1+betastpbt)*betastpbt)*born/pi*alpha*qtp*
     & qbt*(-1d0/2)
     & +ibetasjtpbt*ddilog(1d0)*born/pi*alpha*qtp*qbt*(2)
     & +ibetastpbt*log(4*omega**2/s)*jbwbttpsq*born/pi*alpha*qw*qtp*(-1d
     & 0/2)
     & +ibetastpbt*ddilog(2/(1+betastpbt)*betastpbt)*born/pi*alpha*qw*qt
     & p*(-1)
     & +ibetastpbt*jbwbttpsq*born/pi*alpha*qtp**2*(-1d0/2)
     & +ibetastpbt*jbwbttpsq**2*born/pi*alpha*qw*qtp*(-1d0/4)
     & +log(1d0/mtp**2*s)*born/pi*alpha*qtp**2*(1d0/4)
     & +log(1d0/mbt**2*s)*born/pi*alpha*qbt**2*(1d0/4)
     & +log(4*omega**2/s)*born/pi*alpha*qbt**2*(-1d0/2)
     & +log(4*omega**2/s)*born/pi*alpha*qtp**2*(-1d0/2)
     & +log(4*omega**2/s)*born/pi*alpha*qw**2*(-1d0/2)

      softvirtifi=
     & +born/pi*alpha*qw**2*(-1)
     & +ibetasbttp*log(4*omega**2/s)*jbwtpbtsq*born/pi*alpha*qw*qbt*(-1d
     & 0/2)
     & +ibetasbttp*ddilog(2/(1+betasbttp)*betasbttp)*born/pi*alpha*qw*qb
     & t*(-1)
     & +ibetasbttp*jbwtpbtsq**2*born/pi*alpha*qw*qbt*(-1d0/4)
     & +ibetasjtpbt*log(1d0/mbt**2*s)*log(1d0/2+1d0/2*ibetasbttp)*born/p
     & i*alpha*qtp*qbt*(-1d0/2)
     & +ibetasjtpbt*log(1d0/mbt**2*s)**2*born/pi*alpha*qtp*qbt*(-1d0/4)
     & +ibetasjtpbt*log(1d0/mbt**2*s)*log(sqrtlstpbt/s)*born/pi*alpha*qt
     & p*qbt*(-1)
     & +ibetasjtpbt*log(1d0/mbt**2*s)*jbwtpbtsq*born/pi*alpha*qtp*qbt*(-
     & 1d0/2)
     & +ibetasjtpbt*(log(-1d0/2+1d0/2*ibetasbttp)**2)*born/pi*alpha*qtp*
     & qbt*(-1d0/4)
     & +ibetasjtpbt*(log(-1d0/2+1d0/2*ibetastpbt)**2)*born/pi*alpha*qtp*
     & qbt*(-1d0/4)
     & +ibetastpbt*log(4*omega**2/s)*jbwbttpsq*born/pi*alpha*qw*qtp*(1d0
     & /2)
     & +ibetastpbt*ddilog(2/(1+betastpbt)*betastpbt)*born/pi*alpha*qw*qt
     & p*(1)
     & +ibetastpbt*jbwbttpsq**2*born/pi*alpha*qw*qtp*(1d0/4)
     & +log(1+1d0/2/(mbt**2+us)*betasbttp*pxxsbtjtp-1d0/2/(mbt**2+us)*px
     & xsbtjtp)**2*born/pi*alpha*qup*qbt*(1d0/2)
     & +log(1+1d0/2/(mbt**2+ts)*betasbttp*pxxsbtjtp-1d0/2/(mbt**2+ts)*px
     & xsbtjtp)**2*born/pi*alpha*qdn*qbt*(-1d0/2)
     & +log(1+1d0/2/(mtp**2+us)*betastpbt*pxxstpjbt-1d0/2/(mtp**2+us)*px
     & xstpjbt)**2*born/pi*alpha*qdn*qtp*(1d0/2)
     & +log(1+1d0/2/(mtp**2+ts)*betastpbt*pxxstpjbt-1d0/2/(mtp**2+ts)*px
     & xstpjbt)**2*born/pi*alpha*qup*qtp*(-1d0/2)
     & +log(1d0/mtp**2*s)*log(1+1d0/2/(mtp**2+us)*betastpbt*pxxstpjbt-1d
     & 0/2/(mtp**2+us)*pxxstpjbt)*born/pi*alpha*qdn*qtp*(1)
     & +log(1d0/mtp**2*s)*log(1+1d0/2/(mtp**2+ts)*betastpbt*pxxstpjbt-1d
     & 0/2/(mtp**2+ts)*pxxstpjbt)*born/pi*alpha*qup*qtp*(-1)
     & +log(1d0/mtp**2*s)**2*born/pi*alpha*qdn*qtp*(1d0/4)
     & +log(1d0/mtp**2*s)**2*born/pi*alpha*qup*qtp*(-1d0/4)
     & +log(1d0/mtp**2*s)*log(mtp**2/s+us/s)*born/pi*alpha*qdn*qtp*(1)
     & +log(1d0/mtp**2*s)*log(mtp**2/s+ts/s)*born/pi*alpha*qup*qtp*(-1)
     & +log(1d0/mtp**2*s)*log(1d0/2*betastpbt*pxxstpjbt/s+1d0/2*pxxstpjb
     & t/s)*born/pi*alpha*qdn*qtp*(2)
     & +log(1d0/mtp**2*s)*log(1d0/2*betastpbt*pxxstpjbt/s+1d0/2*pxxstpjb
     & t/s)*born/pi*alpha*qup*qtp*(-2)
     & +log(1d0/mbt**2*s)*log(1+1d0/2/(mbt**2+us)*betasbttp*pxxsbtjtp-1d
     & 0/2/(mbt**2+us)*pxxsbtjtp)*born/pi*alpha*qup*qbt*(1)
     & +log(1d0/mbt**2*s)*log(1+1d0/2/(mbt**2+ts)*betasbttp*pxxsbtjtp-1d
     & 0/2/(mbt**2+ts)*pxxsbtjtp)*born/pi*alpha*qdn*qbt*(-1)
     & +log(1d0/mbt**2*s)**2*born/pi*alpha*qdn*qbt*(-1d0/4)
     & +log(1d0/mbt**2*s)**2*born/pi*alpha*qup*qbt*(1d0/4)
     & +log(1d0/mbt**2*s)*log(mbt**2/s+us/s)*born/pi*alpha*qup*qbt*(1)
     & +log(1d0/mbt**2*s)*log(mbt**2/s+ts/s)*born/pi*alpha*qdn*qbt*(-1)
     & +log(1d0/mbt**2*s)*log(1d0/2*betasbttp*pxxsbtjtp/s+1d0/2*pxxsbtjt
     & p/s)*born/pi*alpha*qdn*qbt*(-2)
     & +log(1d0/mbt**2*s)*log(1d0/2*betasbttp*pxxsbtjtp/s+1d0/2*pxxsbtjt
     & p/s)*born/pi*alpha*qup*qbt*(2)
     & +log(mbt**2/s+us/s)**2*born/pi*alpha*qup*qbt*(3d0/2)
     & +log(mbt**2/s+ts/s)**2*born/pi*alpha*qdn*qbt*(-3d0/2)
     & +log(mtp**2/s+us/s)**2*born/pi*alpha*qdn*qtp*(3d0/2)
     & +log(mtp**2/s+ts/s)**2*born/pi*alpha*qup*qtp*(-3d0/2)
     & +log(us/s)*log(1d0/mtp**2*s)*born/pi*alpha*qdn*qtp*(-1)
     & +log(us/s)*log(1d0/mbt**2*s)*born/pi*alpha*qup*qbt*(-1)
     & +log(us/s)*log(mbt**2/s+us/s)*born/pi*alpha*qup*qbt*(-1)
     & +log(us/s)*log(mtp**2/s+us/s)*born/pi*alpha*qdn*qtp*(-1)
     & +log(ts/s)*log(1d0/mtp**2*s)*born/pi*alpha*qup*qtp*(1)
     & +log(ts/s)*log(1d0/mbt**2*s)*born/pi*alpha*qdn*qbt*(1)
     & +log(ts/s)*log(mbt**2/s+ts/s)*born/pi*alpha*qdn*qbt*(1)
     & +log(ts/s)*log(mtp**2/s+ts/s)*born/pi*alpha*qup*qtp*(1)
     & +log(4*omega**2/s)*born/pi*alpha*qw**2*(1)
     & +log(4*omega**2/s)*log(1d0/mtp**2*s)*born/pi*alpha*qdn*qtp*(-1d0/
     & 2)
     & +log(4*omega**2/s)*log(1d0/mtp**2*s)*born/pi*alpha*qup*qtp*(1d0/2
     & )
     & +log(4*omega**2/s)*log(1d0/mbt**2*s)*born/pi*alpha*qdn*qbt*(1d0/2
     & )
     & +log(4*omega**2/s)*log(1d0/mbt**2*s)*born/pi*alpha*qup*qbt*(-1d0/
     & 2)
     & +log(4*omega**2/s)*log(mbt**2/s+us/s)*born/pi*alpha*qup*qbt*(-1)
     & +log(4*omega**2/s)*log(mbt**2/s+ts/s)*born/pi*alpha*qdn*qbt*(1)
     & +log(4*omega**2/s)*log(mtp**2/s+us/s)*born/pi*alpha*qdn*qtp*(-1)
     & +log(4*omega**2/s)*log(mtp**2/s+ts/s)*born/pi*alpha*qup*qtp*(1)
     & +log(1d0/2*betasbttp*pxxsbtjtp/s+1d0/2*pxxsbtjtp/s)*log(1+1d0/2/(
     & mbt**2+us)*betasbttp*pxxsbtjtp-1d0/2/(mbt**2+us)*pxxsbtjtp)*born/
     & pi*alpha*qup*qbt*(2)
     & +log(1d0/2*betasbttp*pxxsbtjtp/s+1d0/2*pxxsbtjtp/s)*log(1+1d0/2/(
     & mbt**2+ts)*betasbttp*pxxsbtjtp-1d0/2/(mbt**2+ts)*pxxsbtjtp)*born/
     & pi*alpha*qdn*qbt*(-2)
     & +log(1d0/2*betasbttp*pxxsbtjtp/s+1d0/2*pxxsbtjtp/s)**2*born/pi*al
     & pha*qdn*qbt*(-2)
     & +log(1d0/2*betasbttp*pxxsbtjtp/s+1d0/2*pxxsbtjtp/s)**2*born/pi*al
     & pha*qup*qbt*(2)
     & +log(1d0/2*betastpbt*pxxstpjbt/s+1d0/2*pxxstpjbt/s)*log(1+1d0/2/(
     & mtp**2+us)*betastpbt*pxxstpjbt-1d0/2/(mtp**2+us)*pxxstpjbt)*born/
     & pi*alpha*qdn*qtp*(2)
     & +log(1d0/2*betastpbt*pxxstpjbt/s+1d0/2*pxxstpjbt/s)*log(1+1d0/2/(
     & mtp**2+ts)*betastpbt*pxxstpjbt-1d0/2/(mtp**2+ts)*pxxstpjbt)*born/
     & pi*alpha*qup*qtp*(-2)
     & +log(1d0/2*betastpbt*pxxstpjbt/s+1d0/2*pxxstpjbt/s)**2*born/pi*al
     & pha*qdn*qtp*(2)
     & +log(1d0/2*betastpbt*pxxstpjbt/s+1d0/2*pxxstpjbt/s)**2*born/pi*al
     & pha*qup*qtp*(-2)
     & +ddilog(1-2/(1+betasbttp)
     & +2/(1+betasbttp)/(mbt**2+us)*ipxxsbtjtp*mbt**2*s)*born/pi*alpha*q
     & up*qbt*(-1)
     & +ddilog(1-2/(1+betasbttp)
     & +2/(1+betasbttp)/(mbt**2+ts)*ipxxsbtjtp*mbt**2*s)*born/pi*alpha*q
     & dn*qbt*(1)
     & +ddilog(1-2/(1+betastpbt)
     & +2/(1+betastpbt)/(mtp**2+us)*ipxxstpjbt*mtp**2*s)*born/pi*alpha*q
     & dn*qtp*(-1)
     & +ddilog(1-2/(1+betastpbt)
     & +2/(1+betastpbt)/(mtp**2+ts)*ipxxstpjbt*mtp**2*s)*born/pi*alpha*q
     & up*qtp*(1)
     & +ddilog(1-1/(mbt**2+us)*pxxsbtjtp+1/(mbt**2+us)/(mbt**2+us)*mbt**
     & 2*s)*born/pi*alpha*qup*qbt*(1)
     & +ddilog(1-1/(mbt**2+ts)*pxxsbtjtp+1/(mbt**2+ts)/(mbt**2+ts)*mbt**
     & 2*s)*born/pi*alpha*qdn*qbt*(-1)
     & +ddilog(1-1/(mtp**2+us)*pxxstpjbt+1/(mtp**2+us)/(mtp**2+us)*mtp**
     & 2*s)*born/pi*alpha*qdn*qtp*(1)
     & +ddilog(1-1/(mtp**2+ts)*pxxstpjbt+1/(mtp**2+ts)/(mtp**2+ts)*mtp**
     & 2*s)*born/pi*alpha*qup*qtp*(-1)
     & +ddilog(1/(mbt**2+us)*mbt**2)*born/pi*alpha*qup*qbt*(1)
     & +ddilog(1/(mbt**2+ts)*mbt**2)*born/pi*alpha*qdn*qbt*(-1)
     & +ddilog(2/(2*mbt**2-betasbttp*pxxsbtjtp**2/s-pxxsbtjtp**2/s+1/(mb
     & t**2+us)*betasbttp*pxxsbtjtp*mbt**2+1/(mbt**2+us)*pxxsbtjtp*mbt**
     & 2)*mbt**2)*born/pi*alpha*qup*qbt*(1)
     & +ddilog(2/(2*mbt**2-betasbttp*pxxsbtjtp**2/s-pxxsbtjtp**2/s+1/(mb
     & t**2+ts)*betasbttp*pxxsbtjtp*mbt**2+1/(mbt**2+ts)*pxxsbtjtp*mbt**
     & 2)*mbt**2)*born/pi*alpha*qdn*qbt*(-1)
     & +ddilog(1/(mtp**2+us)*mtp**2)*born/pi*alpha*qdn*qtp*(1)
     & +ddilog(1/(mtp**2+ts)*mtp**2)*born/pi*alpha*qup*qtp*(-1)
     & +ddilog(2/(2*mtp**2-betastpbt*pxxstpjbt**2/s-pxxstpjbt**2/s+1/(mt
     & p**2+us)*betastpbt*pxxstpjbt*mtp**2+1/(mtp**2+us)*pxxstpjbt*mtp**
     & 2)*mtp**2)*born/pi*alpha*qdn*qtp*(1)
     & +ddilog(2/(2*mtp**2-betastpbt*pxxstpjbt**2/s-pxxstpjbt**2/s+1/(mt
     & p**2+ts)*betastpbt*pxxstpjbt*mtp**2+1/(mtp**2+ts)*pxxstpjbt*mtp**
     & 2)*mtp**2)*born/pi*alpha*qup*qtp*(-1)
     & +ddilog(1d0)*born/pi*alpha*qdn**2*(-1)
     & +ddilog(1d0)*born/pi*alpha*qup*qdn*(2)
     & +ddilog(1d0)*born/pi*alpha*qup**2*(-1)
     & +jbwbttpsq**2*born/pi*alpha*qdn*qtp*(-1d0/4)
     & +jbwbttpsq**2*born/pi*alpha*qup*qtp*(1d0/4)
     & +jbwtpbtsq**2*born/pi*alpha*qdn*qbt*(1d0/4)
     & +jbwtpbtsq**2*born/pi*alpha*qup*qbt*(-1d0/4)

      if (iqed.eq.1) then
         soft = softvirtisr+softvirtifi+softvirtfsr
      elseif(iqed.eq.2) then
         soft = softvirtisr
      elseif(iqed.eq.3) then
         soft = softvirtifi
      elseif(iqed.eq.4) then
         soft = softvirtfsr
      elseif(iqed.eq.5) then
         soft = softvirtifi+softvirtfsr
      endif

      soft = soft*cfprime

      return
      end
