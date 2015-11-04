************************************************************************
* sanc_cc_v1.40 package.
************************************************************************
* File (cc-qcd_br_1322_2114.f) is created on Tue Aug  9 23:01:13 MSD 2011.
************************************************************************
* This is the FORTRAN module (cc_qcd_br_1322_2114) to calculate EW Born
* cross section and QCD virtual corrections 
* for the anti-up + anti-bt -> anti-tp + anti-dn process.
*
* It is produced by s2n package of SANC (v1.10) Project.
* Copyright (C), SANC Project Team, 2002-2011.
*
* http://sanc.jinr.ru/
* http://pcphsanc.cern.ch/
* E-mail: <sanc@jinr.ru>
************************************************************************
      subroutine cc_qcd_br_1322_2114 (qs,ts,us,born,soft,hard)
      implicit none!
      include 's2n_declare.h'

      real*8 sqrtltpbtt,isqrtltpbtt
      real*8 betatpbtt,ibetatpbtt,betajtbttp
      real*8 ibetajtbttp,betajttpbt,ibetajttpbt
      real*8 jbwttpbt
      complex*16 propwt,propwtc

      cmw2 = rwm2

      s = -qs
      t = -ts
      u = -us

      propwt = 1d0/(t-cmw2)
      propwtc = dconjg(propwt)

      born=
     & +propwt*propwtc*(s-mtp**2)**2/pi*gf**2*mw**4*(1d0/4/s)

      born = born*conhc
      virt = 0d0
      soft = 0d0
      hard = 0d0

      if (iborn.eq.1) return

      born = born/conhc

      sqrtltpbtt = dsqrt((t-mtp**2-mbt**2)**2-4*mtp**2*mbt**2)
      isqrtltpbtt = 1d0/sqrtltpbtt
      betatpbtt = sqrtltpbtt/(mtp**2+mbt**2-t)
      ibetatpbtt = 1d0/betatpbtt
      betajtbttp = sqrtltpbtt/(-t+mbt**2-mtp**2)
      ibetajtbttp = 1d0/betajtbttp
      betajttpbt = sqrtltpbtt/(-t+mtp**2-mbt**2)
      ibetajttpbt = 1d0/betajttpbt

      jbwttpbt =
     &    log((mtp**2+mbt**2-t-sqrtltpbtt)/(mtp**2+mbt**2-t+sqrtltpbtt))

      softvirt=
     & +born/pi*alphas*cf*(-4)
     & +sqrtltpbtt*born/pi*alphas*cf*(3d0/4*jbwttpbt/t)
     & +sqrtltpbtt*propwt*propwtc*(s-mtp**2)/(s-mbt**2)/pi**2*alphas*gf*
     & *2*mw**4*cf*(-1d0/16*jbwttpbt)
     & +isqrtltpbtt*born/pi*alphas*cf*(3d0/4*jbwttpbt*mtp**2-3d0/4*jbwtt
     & pbt*mtp**4/t)
     & +isqrtltpbtt*born/pi*alphas*mbt**2*cf*(3d0/4*jbwttpbt+3d0/2*jbwtt
     & pbt*mtp**2/t)
     & +isqrtltpbtt*born/pi*alphas*mbt**4*cf*(-3d0/4*jbwttpbt/t)
     & +isqrtltpbtt**2*propwt*propwtc*log(mbt**2/s)*(s-mtp**2)/(s-mbt**2
     & )/pi**2*alphas*gf**2*mw**4*cf*(5d0/16*t**3-5d0/8*mtp**2*t**2+5d0/
     & 16*mtp**4*t)
     & +isqrtltpbtt**2*propwt*propwtc*log(mbt**2/s)*(s-mtp**2)/(s-mbt**2
     & )/pi**2*alphas*gf**2*mw**4*mbt**2*cf*(-5d0/8*t**2-5d0/8*mtp**2*t)
     & 
     & +isqrtltpbtt**2*propwt*propwtc*log(mbt**2/s)*(s-mtp**2)/(s-mbt**2
     & )/pi**2*alphas*gf**2*mw**4*mbt**4*cf*(5d0/16*t)
     & +isqrtltpbtt**2*propwt*propwtc*log(mbt**2/s)*(s-mtp**2)/pi**2*alp
     & has*gf**2*mw**4/s*cf*(-1d0/4*t**3+1d0/2*mtp**2*t**2-1d0/4*mtp**4*
     & t)
     & +isqrtltpbtt**2*propwt*propwtc*log(mbt**2/s)*(s-mtp**2)/pi**2*alp
     & has*gf**2*mw**4*mbt**2/s*cf*(1d0/2*t**2+1d0/2*mtp**2*t)
     & +isqrtltpbtt**2*propwt*propwtc*log(mbt**2/s)*(s-mtp**2)/pi**2*alp
     & has*gf**2*mw**4*mbt**4/s*cf*(-1d0/4*t)
     & +isqrtltpbtt**2*propwt*propwtc*log(mtp**2/s)*(s-mtp**2)/(s-mbt**2
     & )/pi**2*alphas*gf**2*mw**4*cf*(-5d0/16*t**3+5d0/8*mtp**2*t**2-5d0
     & /16*mtp**4*t)
     & +isqrtltpbtt**2*propwt*propwtc*log(mtp**2/s)*(s-mtp**2)/(s-mbt**2
     & )/pi**2*alphas*gf**2*mw**4*mbt**2*cf*(5d0/8*t**2+5d0/8*mtp**2*t)
     & +isqrtltpbtt**2*propwt*propwtc*log(mtp**2/s)*(s-mtp**2)/(s-mbt**2
     & )/pi**2*alphas*gf**2*mw**4*mbt**4*cf*(-5d0/16*t)
     & +isqrtltpbtt**2*propwt*propwtc*log(mtp**2/s)*(s-mtp**2)/pi**2*alp
     & has*gf**2*mw**4/s*cf*(1d0/4*t**3-1d0/2*mtp**2*t**2+1d0/4*mtp**4*t
     & )
     & +isqrtltpbtt**2*propwt*propwtc*log(mtp**2/s)*(s-mtp**2)/pi**2*alp
     & has*gf**2*mw**4*mbt**2/s*cf*(-1d0/2*t**2-1d0/2*mtp**2*t)
     & +isqrtltpbtt**2*propwt*propwtc*log(mtp**2/s)*(s-mtp**2)/pi**2*alp
     & has*gf**2*mw**4*mbt**4/s*cf*(1d0/4*t)
     & +isqrtltpbtt**2*log(mbt**2/s)*born/pi*alphas*cf*(3d0/4*mtp**2*t-3
     & d0/2*mtp**4+3d0/4*mtp**6/t)
     & +isqrtltpbtt**2*log(mbt**2/s)*born/pi*alphas*mbt**2*cf*(-3d0/4*t-
     & 9d0/4*mtp**4/t)
     & +isqrtltpbtt**2*log(mbt**2/s)*born/pi*alphas*mbt**4*cf*(3d0/2+9d0
     & /4*mtp**2/t)
     & +isqrtltpbtt**2*log(mbt**2/s)*born/pi*alphas*mbt**6*cf*(-3d0/4/t)
     & +isqrtltpbtt**2*log(mtp**2/s)*born/pi*alphas*cf*(-3d0/4*mtp**2*t+
     & 3d0/2*mtp**4-3d0/4*mtp**6/t)
     & +isqrtltpbtt**2*log(mtp**2/s)*born/pi*alphas*mbt**2*cf*(3d0/4*t+9
     & d0/4*mtp**4/t)
     & +isqrtltpbtt**2*log(mtp**2/s)*born/pi*alphas*mbt**4*cf*(-3d0/2-9d
     & 0/4*mtp**2/t)
     & +isqrtltpbtt**2*log(mtp**2/s)*born/pi*alphas*mbt**6*cf*(3d0/4/t)
     & +isqrtltpbtt*propwt*propwtc*(s-mtp**2)/(s-mbt**2)/pi**2*alphas*gf
     & **2*mw**4*cf*(1d0/16*jbwttpbt*t**2-5d0/16*jbwttpbt*mtp**2*t)
     & +isqrtltpbtt*propwt*propwtc*(s-mtp**2)/(s-mbt**2)/pi**2*alphas*gf
     & **2*mw**4*mbt**2*cf*(-1d0/16*jbwttpbt*t)
     & +isqrtltpbtt*propwt*propwtc*(s-mtp**2)/pi**2*alphas*gf**2*mw**4/s
     & *cf*(1d0/4*jbwttpbt*mtp**2*t)
     & +ibetatpbtt*log(mbt**2/s)*born/pi*alphas*cf*(1d0/4*jbwttpbt)
     & +ibetatpbtt*log(mbt**2/s)**2*born/pi*alphas*cf*(-1d0/4)
     & +ibetatpbtt*log(mtp**2/s)*born/pi*alphas*cf*(1d0/4*jbwttpbt)
     & +ibetatpbtt*log(mtp**2/s)**2*born/pi*alphas*cf*(1d0/4)
     & +ibetatpbtt*log(4*omega**2/s)*born/pi*alphas*cf*(-1d0/2*jbwttpbt)
     & +ibetatpbtt*log(-isqrtltpbtt*t)*born/pi*alphas*cf*(-1d0/4*jbwttpb
     & t)
     & +ibetatpbtt*log(isqrtltpbtt*mbt**2)*log(-1/(1+betajtbttp)
     & +1/(1+betajtbttp)*betajtbttp)*born/pi*alphas*cf*(-1d0/4)
     & +ibetatpbtt*log(isqrtltpbtt*mtp**2)*log(-1/(1+betajttpbt)
     & +1/(1+betajttpbt)*betajttpbt)*born/pi*alphas*cf*(-1d0/4)
     & +ibetatpbtt*ddilog(1d0/2-1d0/2/mtp**2*s+isqrtltpbtt*s+isqrtltpbtt
     & *mbt**2-1d0/2*ibetatpbtt-1d0/2*ibetatpbtt/mtp**2*s)*born/pi*alpha
     & s*cf*(1)
     & +ibetatpbtt*ddilog(1d0/2-1d0/2*mbt**2/s-isqrtltpbtt*mbt**2-isqrtl
     & tpbtt*mtp**2*mbt**2/s+1d0/2*ibetatpbtt+1d0/2*ibetatpbtt*mbt**2/s)
     & *born/pi*alphas*cf*(-1)
     & +ibetatpbtt*ddilog(1d0/2-1d0/2*mtp**2/s+isqrtltpbtt*mtp**2+isqrtl
     & tpbtt*mtp**2*mbt**2/s-1d0/2*ibetatpbtt-1d0/2*ibetatpbtt*mtp**2/s)
     & *born/pi*alphas*cf*(1)
     & +ibetatpbtt*ddilog(1d0/2-1d0/2*ibetajtbttp)*born/pi*alphas*cf*(-1
     & d0/2)
     & +ibetatpbtt*ddilog(1d0/2+1d0/2*ibetajtbttp)*born/pi*alphas*cf*(1d
     & 0/2)
     & +ibetatpbtt*ddilog(1d0/2-1d0/2*ibetajttpbt)*born/pi*alphas*cf*(-1
     & d0/2)
     & +ibetatpbtt*ddilog(1d0/2+1d0/2*ibetajttpbt)*born/pi*alphas*cf*(1d
     & 0/2)
     & +ibetatpbtt*ddilog(1-isqrtltpbtt*s-isqrtltpbtt*mtp**2+2/(-t+mbt**
     & 2+mtp**2+sqrtltpbtt)*isqrtltpbtt*mtp**2*s+2/(-t+mbt**2+mtp**2+sqr
     & tltpbtt)*isqrtltpbtt*mtp**2*mbt**2)*born/pi*alphas*cf*(-1)
     & +propwt*propwtc*log(mbt**2/s)*(s-mtp**2)/(s-mbt**2)/pi**2*alphas*
     & gf**2*mw**4*cf*(-5d0/16*t+1d0/16*mtp**2)
     & +propwt*propwtc*log(mbt**2/s)*(s-mtp**2)/(s-mbt**2)/pi**2*alphas*
     & gf**2*mw**4*mbt**2*cf*(-1d0/16)
     & +propwt*propwtc*log(mbt**2/s)*(s-mtp**2)/pi**2*alphas*gf**2*mw**4
     & /s*cf*(1d0/4*t)
     & +propwt*propwtc*log(mtp**2/s)*(s-mtp**2)/(s-mbt**2)/pi**2*alphas*
     & gf**2*mw**4*cf*(5d0/16*t-1d0/16*mtp**2)
     & +propwt*propwtc*log(mtp**2/s)*(s-mtp**2)/(s-mbt**2)/pi**2*alphas*
     & gf**2*mw**4*mbt**2*cf*(1d0/16)
     & +propwt*propwtc*log(mtp**2/s)*(s-mtp**2)/pi**2*alphas*gf**2*mw**4
     & /s*cf*(-1d0/4*t)
     & +log(1-mbt**2/s)*born/pi*alphas*cf*(1)
     & +log(1-mbt**2/s)**2*born/pi*alphas*cf*(-1)
     & +log(1-mtp**2/s)*born/pi*alphas*cf*(1)
     & +log(1-mtp**2/s)**2*born/pi*alphas*cf*(-1)
     & +log(-1d0/s*t)*born/pi*alphas*cf*(3d0/2)
     & +log(-1d0/s*t)**2*born/pi*alphas*cf*(-1d0/2)
     & +log(mbt**2/s)/(s-mbt**2)*born/pi*alphas*s*cf*(-1d0/2)
     & +log(mbt**2/s)/(s-mbt**2)*born/pi*alphas*mbt**2*cf*(-1d0/2)
     & +log(mbt**2/s)*born/pi*alphas*cf*(1d0/2-3d0/4*mtp**2/t)
     & +log(mbt**2/s)*born/pi*alphas*mbt**2*cf*(3d0/4/t)
     & +log(mtp**2/s)/(s-mtp**2)*born/pi*alphas*cf*(-mtp**2)
     & +log(mtp**2/s)*born/pi*alphas*cf*(3d0/4*mtp**2/t)
     & +log(mtp**2/s)*born/pi*alphas*mbt**2*cf*(-3d0/4/t)
     & +log(mdn**2/s)*born/pi*alphas*cf*(-3d0/4)
     & +log(mdn**2/s)*log(1-mtp**2/s)*born/pi*alphas*cf*(1)
     & +log(mup**2/s)*born/pi*alphas*cf*(-3d0/4)
     & +log(mup**2/s)*log(1-mbt**2/s)*born/pi*alphas*cf*(1)
     & +log(4*omega**2/s)*born/pi*alphas*cf*(-2)
     & +log(4*omega**2/s)*log(-1d0/s*t)*born/pi*alphas*cf*(1)
     & +log(4*omega**2/s)*log(mdn**2/s)*born/pi*alphas*cf*(-1d0/2)
     & +log(4*omega**2/s)*log(mup**2/s)*born/pi*alphas*cf*(-1d0/2)
     & +ddilog(1+(s-mtp**2)*(s-mbt**2)/s/t)*born/pi*alphas*cf*(-1)
     & +ddilog(1d0)*born/pi*alphas*cf*(-1)

      soft = softvirt*conhc
      born = born*conhc

      return
      end
