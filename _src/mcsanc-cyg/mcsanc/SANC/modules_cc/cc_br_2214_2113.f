************************************************************************
* sanc_cc_v1.40 package.
************************************************************************
* File (cc_br_2214_2113.f) is created on Tue Aug  9 22:59:54 MSD 2011.
************************************************************************
* This is the FORTRAN module (cc_bo_2214_2113) to calculate EW
* integrated Born cross section for the anti-bt + dn -> anti-tp + up process.
*
* It is produced by s2n package of SANC (v1.10) Project.
* Copyright (C), SANC Project Team, 2002-2011.
*
* http://sanc.jinr.ru/
* http://pcphsanc.cern.ch/
* E-mail: <sanc@jinr.ru>
************************************************************************
      subroutine cc_bo_2214_2113 (s,born)
      implicit none!
      include 's2n_declare.h'

      born=
     & +1d0/(s*mw**2+(s-mtp**2)*(s-mbt**2))/pi*gf**2*mw**2*(1d0/2*(s-mtp
     & **2)**2)
     & +1d0/(s*mw**2+(s-mtp**2)*(s-mbt**2))/pi*gf**2*mw**4*(1d0/2*(s-mtp
     & **2)
     & +1d0/2*(s-mtp**2)**2/(s-mbt**2))
     & +1d0/(s*mw**2+(s-mtp**2)*(s-mbt**2))/pi*gf**2*mw**6*(1d0/2*(s-mtp
     & **2)/(s-mbt**2))
     & +1d0/pi*gf**2*mw**4*(1d0/2*(s-mtp**2)/(s-mbt**2)/s)
     & +log((s*mw**2+(s-mtp**2)*(s-mbt**2))/mw**2/s)/pi*gf**2*mw**4*(-1d
     & 0/2/(s-mbt**2)
     & -1d0/2*(s-mtp**2)/(s-mbt**2)**2)+log((s*mw**2+(s-mtp**2)*(s-mbt**
     & 2))/mw**2/s)/pi*gf**2*mw**6*(-1d0/(s-mbt**2)**2)

      born = born*conhc

      return
      end
************************************************************************
* This is the FORTRAN module (cc_br_2214_2113) to calculate Born
* cross section and EW virtual corrections 
* for the anti-bt + dn -> anti-tp + up process.
*
* It is produced by s2n package of SANC (v1.10) Project.
* Copyright (C), SANC Project Team, 2002-2011.
*
* http://sanc.jinr.ru/
* http://pcphsanc.cern.ch/
* E-mail: <sanc@jinr.ru>
************************************************************************
      subroutine cc_br_2214_2113 (qs,ts,us,born,soft,hard)
      implicit none!
      include 's2n_declare.h'

      real*8 qw
      real*8 softvirtisr,softvirtfsr,softvirtifi
      real*8 sqrtltpbtt,isqrtltpbtt
      real*8 betatpbtt,ibetatpbtt,betajtbttp
      real*8 ibetajtbttp,betajttpbt,ibetajttpbt
      real*8 jbwttpbt
      complex*16 propwt,propwtc

      cmw2 = rwm2
      qw = 1d0

      s = -qs
      t = -ts
      u = -us

      propwt = 1d0/(t-cmw2)
      propwtc = dconjg(propwt)

      born=
     & +propwt*propwtc/pi*gf**2*mw**4*(1d0/4*(s-mtp**2)**2/s)
     & +propwt*propwtc/pi*gf**2*mw**4*t*(1d0/4*(s-mtp**2)/s+1d0/4*(s-mtp
     & **2)**2/(s-mbt**2)/s)
     & +propwt*propwtc/pi*gf**2*mw**4*t**2*(1d0/4*(s-mtp**2)/(s-mbt**2)/
     & s)

      born = born*conhc
      virt = 0d0
      soft = 0d0
      hard = 0d0

      if (iborn.eq.1) return

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

      softvirtisr=
     & +born/pi*alpha*qbt**2*(3d0/4-3d0/4*log(s/thmu2))
     & +born/pi*alpha*qdn**2*(3d0/4-3d0/4*log(s/thmu2))
     & +log(1-mbt**2/s)*born/pi*alpha*qdn**2*(1)
     & +log(1-mbt**2/s)**2*born/pi*alpha*qdn*qbt*(-7d0/4)
     & +log(1d0/mdn**2*s)*born/pi*alpha*qdn**2*(3d0/4)
     & +log(1d0/mdn**2*s)*log(1-mbt**2/s)*born/pi*alpha*qdn*qbt*(-1)
     & +log(1d0/mbt**2*s)*born/pi*alpha*qbt**2*(3d0/4)
     & +log(1d0/mbt**2*s)*born/pi*alpha*qbt**2*mbt**2*(1d0/(s-mbt**2))
     & +log(1d0/mbt**2*s)*log(1-mbt**2/s)*born/pi*alpha*qdn*qbt*(-1d0/2)
     & +log(4*omega**2/s)*born/pi*alpha*qbt**2*(-1d0/2)
     & +log(4*omega**2/s)*born/pi*alpha*qdn**2*(-1d0/2)
     & +log(4*omega**2/s)*log(1-mbt**2/s)*born/pi*alpha*qdn*qbt*(1)
     & +log(4*omega**2/s)*log(1d0/mdn**2*s)*born/pi*alpha*qdn*qbt*(1d0/2
     & )
     & +log(4*omega**2/s)*log(1d0/mbt**2*s)*born/pi*alpha*qdn*qbt*(1d0/2
     & )
     & +ddilog(1-mbt**2/s)*born/pi*alpha*qdn*qbt*(-1d0/2)
     & +ddilog(-1d0/(s-mbt**2)*mbt**2)*born/pi*alpha*qdn*qbt*(-1d0/2)
     & +ddilog(1/(s-mbt**2)*s)*born/pi*alpha*qdn*qbt*(1)
     & +ddilog(1d0)*born/pi*alpha*qdn*qbt*(3d0/2)

      softvirtfsr=
     & +born/pi*alpha*qtp**2*(3d0/4-3d0/4*log(s/thmu2))
     & +born/pi*alpha*qup**2*(3d0/4-3d0/4*log(s/thmu2))
     & +log(1-mtp**2/s)*born/pi*alpha*qup**2*(1)
     & +log(1-mtp**2/s)**2*born/pi*alpha*qup*qtp*(-7d0/4)
     & +log(1d0/mup**2*s)*born/pi*alpha*qup**2*(3d0/4)
     & +log(1d0/mup**2*s)*log(1-mtp**2/s)*born/pi*alpha*qup*qtp*(-1)
     & +log(1d0/mtp**2*s)*born/pi*alpha*qtp**2*(3d0/4+1d0/(s-mtp**2)*mtp
     & **2)
     & +log(1d0/mtp**2*s)*log(1-mtp**2/s)*born/pi*alpha*qup*qtp*(-1d0/2)
     & +log(4*omega**2/s)*born/pi*alpha*qtp**2*(-1d0/2)
     & +log(4*omega**2/s)*born/pi*alpha*qup**2*(-1d0/2)
     & +log(4*omega**2/s)*log(1-mtp**2/s)*born/pi*alpha*qup*qtp*(1)
     & +log(4*omega**2/s)*log(1d0/mup**2*s)*born/pi*alpha*qup*qtp*(1d0/2
     & )
     & +log(4*omega**2/s)*log(1d0/mtp**2*s)*born/pi*alpha*qup*qtp*(1d0/2
     & )
     & +ddilog(1-mtp**2/s)*born/pi*alpha*qup*qtp*(-1d0/2)
     & +ddilog(-1d0/(s-mtp**2)*mtp**2)*born/pi*alpha*qup*qtp*(-1d0/2)
     & +ddilog(1/(s-mtp**2)*s)*born/pi*alpha*qup*qtp*(1)
     & +ddilog(1d0)*born/pi*alpha*qup*qtp*(3d0/2)

      softvirtifi=
     & +ibetatpbtt*log(1d0/mtp**2*s)**2*born/pi*alpha*qtp*qbt*(1d0/4)
     & +ibetatpbtt*log(1d0/mtp**2*s)*jbwttpbt*born/pi*alpha*qtp*qbt*(-1d
     & 0/4)
     & +ibetatpbtt*log(1d0/mbt**2*s)**2*born/pi*alpha*qtp*qbt*(-1d0/4)
     & +ibetatpbtt*log(1d0/mbt**2*s)*jbwttpbt*born/pi*alpha*qtp*qbt*(-1d
     & 0/4)
     & +ibetatpbtt*log(4*omega**2/s)*jbwttpbt*born/pi*alpha*qtp*qbt*(-1d
     & 0/2)
     & +ibetatpbtt*log(-isqrtltpbtt*t)*jbwttpbt*born/pi*alpha*qtp*qbt*(-
     & 1d0/4)
     & +ibetatpbtt*log(isqrtltpbtt*mbt**2)*log(-1/(1+betajtbttp)
     & +1/(1+betajtbttp)*betajtbttp)*born/pi*alpha*qtp*qbt*(-1d0/4)
     & +ibetatpbtt*log(isqrtltpbtt*mtp**2)*log(-1/(1+betajttpbt)
     & +1/(1+betajttpbt)*betajttpbt)*born/pi*alpha*qtp*qbt*(-1d0/4)
     & +ibetatpbtt*ddilog(1d0/2-1d0/2/mtp**2*s+isqrtltpbtt*s+isqrtltpbtt
     & *mbt**2-1d0/2*ibetatpbtt-1d0/2*ibetatpbtt/mtp**2*s)*born/pi*alpha
     & *qtp*qbt*(1)
     & +ibetatpbtt*ddilog(1d0/2-1d0/2*mbt**2/s-isqrtltpbtt*mbt**2-isqrtl
     & tpbtt*mtp**2*mbt**2/s+1d0/2*ibetatpbtt+1d0/2*ibetatpbtt*mbt**2/s)
     & *born/pi*alpha*qtp*qbt*(-1)
     & +ibetatpbtt*ddilog(1d0/2-1d0/2*mtp**2/s+isqrtltpbtt*mtp**2+isqrtl
     & tpbtt*mtp**2*mbt**2/s-1d0/2*ibetatpbtt-1d0/2*ibetatpbtt*mtp**2/s)
     & *born/pi*alpha*qtp*qbt*(1)
     & +ibetatpbtt*ddilog(1d0/2-1d0/2*ibetajtbttp)*born/pi*alpha*qtp*qbt
     & *(-1d0/2)
     & +ibetatpbtt*ddilog(1d0/2+1d0/2*ibetajtbttp)*born/pi*alpha*qtp*qbt
     & *(1d0/2)
     & +ibetatpbtt*ddilog(1d0/2-1d0/2*ibetajttpbt)*born/pi*alpha*qtp*qbt
     & *(-1d0/2)
     & +ibetatpbtt*ddilog(1d0/2+1d0/2*ibetajttpbt)*born/pi*alpha*qtp*qbt
     & *(1d0/2)
     & +ibetatpbtt*ddilog(1-isqrtltpbtt*s-isqrtltpbtt*mtp**2+2/(-t+mbt**
     & 2+mtp**2+sqrtltpbtt)*isqrtltpbtt*mtp**2*s+2/(-t+mbt**2+mtp**2+sqr
     & tltpbtt)*isqrtltpbtt*mtp**2*mbt**2)*born/pi*alpha*qtp*qbt*(-1)
     & +log(1-mbt**2/s)**2*born/pi*alpha*qdn*qtp*(1)
     & +log(1-mbt**2/s)**2*born/pi*alpha*qup*qdn*(-1)
     & +log(1-mtp**2/s)**2*born/pi*alpha*qup*qbt*(1)
     & +log(1-mtp**2/s)**2*born/pi*alpha*qup*qdn*(-1)
     & +log(1d0/(-u+mbt**2)*mbt**2)*log(1d0/mbt**2*s)*born/pi*alpha*qup*
     & qbt*(1)
     & +log(1d0/(-u+mbt**2)*mbt**2)*log(4*omega**2/s)*born/pi*alpha*qup*
     & qbt*(1)
     & +log(1d0/mup**2*s)*log(1-mtp**2/s)*born/pi*alpha*qup*qbt*(1)
     & +log(1d0/mup**2*s)*log(1-mtp**2/s)*born/pi*alpha*qup*qdn*(-1)
     & +log(1d0/mdn**2*s)*log(1-mbt**2/s)*born/pi*alpha*qdn*qtp*(1)
     & +log(1d0/mdn**2*s)*log(1-mbt**2/s)*born/pi*alpha*qup*qdn*(-1)
     & +log(1d0/mtp**2*s)**2*born/pi*alpha*qdn*qtp*(-1d0/2)
     & +log(1d0/mbt**2*s)**2*born/pi*alpha*qup*qbt*(1d0/2)
     & +log(1d0/s*(-u+mtp**2))**2*born/pi*alpha*qdn*qtp*(1d0/2)
     & +log(-1d0/s*t)**2*born/pi*alpha*qup*qdn*(-1d0/2)
     & +log(4*omega**2/s)*log(1d0/mup**2*s)*born/pi*alpha*qup*qbt*(-1d0/
     & 2)
     & +log(4*omega**2/s)*log(1d0/mup**2*s)*born/pi*alpha*qup*qdn*(1d0/2
     & )
     & +log(4*omega**2/s)*log(1d0/mdn**2*s)*born/pi*alpha*qdn*qtp*(-1d0/
     & 2)
     & +log(4*omega**2/s)*log(1d0/mdn**2*s)*born/pi*alpha*qup*qdn*(1d0/2
     & )
     & +log(4*omega**2/s)*log(1d0/mtp**2*s)*born/pi*alpha*qdn*qtp*(-1d0/
     & 2)
     & +log(4*omega**2/s)*log(1d0/mbt**2*s)*born/pi*alpha*qup*qbt*(1d0/2
     & )
     & +log(4*omega**2/s)*log(1d0/s*(-u+mtp**2))*born/pi*alpha*qdn*qtp*(
     & -1)
     & +log(4*omega**2/s)*log(-1d0/s*t)*born/pi*alpha*qup*qdn*(1)
     & +log((-u+mbt**2)/mbt**2)**2*born/pi*alpha*qup*qbt*(1d0/2)
     & +ddilog(1-(s-mbt**2)/(mtp**2-u)
     & -(s-mbt**2)/(mtp**2-u)*mtp**2/s+(s-mbt**2)**2/(mtp**2-u)**2*mtp**
     & 2/s)*born/pi*alpha*qdn*qtp*(1)
     & +ddilog(1+(s-mtp**2)*(s-mbt**2)/s/t)*born/pi*alpha*qup*qdn*(-1)
     & +ddilog(1-1/(-u+mbt**2)*(s-mtp**2))*born/pi*alpha*qup*qbt*(1)
     & +ddilog(1-1/(-u+mbt**2)*(s-mtp**2)*mbt**2/s)*born/pi*alpha*qup*qb
     & t*(1)
     & +ddilog(-1d0/mtp**2*s+(s-mbt**2)/(mtp**2-u))*born/pi*alpha*qdn*qt
     & p*(-1)
     & +ddilog(-mtp**2/s+(s-mbt**2)/(mtp**2-u)*mtp**2/s)*born/pi*alpha*q
     & dn*qtp*(-1)
     & +ddilog(1/(u-mbt**2)*u)*born/pi*alpha*qup*qbt*(-1)
     & +ddilog(1/(u-mtp**2)*u)*born/pi*alpha*qdn*qtp*(-1)
     & +ddilog(1d0)*born/pi*alpha*qdn*qtp*(1)
     & +ddilog(1d0)*born/pi*alpha*qup*qbt*(1)
     & +ddilog(1d0)*born/pi*alpha*qup*qdn*(-1)

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
