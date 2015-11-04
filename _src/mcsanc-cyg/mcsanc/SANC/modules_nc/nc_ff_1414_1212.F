************************************************************************
* sanc_nc_v1.30 package.
************************************************************************
* File (nc_ff_1414_1212.F) is created on Wed Apr 18 13:08:31 MSK 2012.
************************************************************************
* This is the FORTRAN module (nc_ff_1414_1212) to calculate 1-loop EW
* form factors for the anti-dn + dn -> el^+ + el^- process.
*
* It is produced by s2n package of SANC (v1.10) Project.
* Copyright (C), SANC Project Team, 2002-2012.
*
* http://sanc.jinr.ru/
* http://pcphsanc.cern.ch/
* E-mail: <sanc@jinr.ru>
************************************************************************
      subroutine nc_ff_1414_1212 (qs,ts,us)
      implicit none!
#include "s2n_declare.h"

      complex*16 ff_qed_ll,ff_qed_lq,ff_qed_ql,ff_qed_qq,ff_qed_ld
      complex*16 ff_qed_qd,ff_ew_ll,ff_ew_ld,ff_ew_lq,ff_ew_ql,ff_ew_qq
      complex*16 ff_ew_qd,ff_qed_gg
      real*8 isr,ifi,fsr

      real*8 a0fel,a0fdn,a0fw,a0fz,a0fh
      real*8 lnladnm,lnlaelm
      complex*16 b0fqszc,b0fqscc,b0ftscc,b0fuscc,b0fqsww,b0fqszz,b0fqsz
     & h
      complex*16 c0dndnqszdnc,c0irdndnqs,c0dndnqscdnc,c0irdnelts,c0irdn
     & elus,c0elelqszelc,c0irelelqs,c0elelqscelc,c0celtsczel,c0celusczel
     & ,c0ireldnts,c0ireldnus,c0ccqswcw,c0ccqszcz,c0ccqscwc,c0ccqsczc,c0
     & cctscwc,c0cctsczc,c0ccusczc
      complex*16 d0ccccqstswcwc,d0ccccqstszczc,d0ccccqsuszczc
      complex*16 jaaqstsdnel,jaaqsusdnel,javqstsdnelz,javqsusdnelz
      real*8 pxx2zqsc
      complex*16 propzqs,propizqs,prop1zqs

      common/unibos_bos/za1bos,zmzzzbos,zmwzwbos,zmhzhbos,deltarhobos
      common/unibos_fer/za1fer,zz1fer,zh1fer,zw1fer,zmsqrfer,
     & zmzzzfer,zmwzwfer,zmhzhfer,deltarhofer,tadfer
      common/unipro_fer/caldzfer,caldwfer,pizgfer,piggfer

      if (iqed.eq.1) then
         isr = 1d0
         ifi = 1d0
         fsr = 1d0
      elseif(iqed.eq.2) then
         isr = 1d0
         ifi = 0d0
         fsr = 0d0
      elseif(iqed.eq.3) then
         isr = 0d0
         ifi = 1d0
         fsr = 0d0
      elseif(iqed.eq.4) then
         isr = 0d0
         ifi = 0d0
         fsr = 1d0
      elseif(iqed.eq.5) then
         isr = 0d0
         ifi = 1d0
         fsr = 1d0
      elseif(iqed.eq.6) then
         isr = 1d0
         ifi = 1d0
         fsr = 0d0
      else
         isr = 0d0
         ifi = 0d0
         fsr = 0d0
      endif

      cmz2 = mz2

      if (irun.eq.0) then
         prop1zqs = (cmz2+qs)
      else
         prop1zqs = (dcmplx(mz**2,qs*wz/mz)+qs)
      endif
      propizqs = (rzm2+qs)
      propzqs = 1d0/propizqs
      a0fel = log(relm2/thmu2) - 1d0
      a0fdn = log(rdnm2/thmu2) - 1d0
      a0fw = log(rwm2/thmu2) - 1d0
      a0fz = log(rzm2/thmu2) - 1d0
      a0fh = log(rhm2/thmu2) - 1d0
      lnladnm = log(rdnm2/tlmu2)
      lnlaelm = log(relm2/tlmu2)
      b0fqszc = b0f(qs,thmu2,zm2,cm2)
      b0fqscc = b0f(qs,thmu2,cm2,cm2)
      b0ftscc = b0f(ts,thmu2,cm2,cm2)
      b0fuscc = b0f(us,thmu2,cm2,cm2)
      b0fqsww = b0f(qs,thmu2,wm2,wm2)
      b0fqszz = b0f(qs,thmu2,zm2,zm2)
      b0fqszh = b0f(qs,thmu2,zm2,hm2)
      c0dndnqszdnc = c01(-rdnm2,-rdnm2,qs,zm2,dnm2,cm2)
      c0irdndnqs = c0ir(tlmu2,dnm2,dnm2,qs)
      c0dndnqscdnc = c01(-rdnm2,-rdnm2,qs,cm2,dnm2,cm2)
      c0irdnelts = c0ir(tlmu2,dnm2,elm2,ts)
      c0irdnelus = c0ir(tlmu2,dnm2,elm2,us)
      c0elelqszelc = c01(-relm2,-relm2,qs,zm2,elm2,cm2)
      c0irelelqs = c0ir(tlmu2,elm2,elm2,qs)
      c0elelqscelc = c01(-relm2,-relm2,qs,cm2,elm2,cm2)
      c0celtsczel = c01(0d0,-relm2,ts,cm2,zm2,elm2)
      c0celusczel = c01(0d0,-relm2,us,cm2,zm2,elm2)
      c0ireldnts = c0ir(tlmu2,elm2,dnm2,ts)
      c0ireldnus = c0ir(tlmu2,elm2,dnm2,us)
      c0ccqswcw = c01(0d0,0d0,qs,wm2,cm2,wm2)
      c0ccqszcz = c01(0d0,0d0,qs,zm2,cm2,zm2)
      c0ccqscwc = c01(0d0,0d0,qs,cm2,wm2,cm2)
      c0ccqsczc = c01(0d0,0d0,qs,cm2,zm2,cm2)
      c0cctscwc = c01(0d0,0d0,ts,cm2,wm2,cm2)
      c0cctsczc = c01(0d0,0d0,ts,cm2,zm2,cm2)
      c0ccusczc = c01(0d0,0d0,us,cm2,zm2,cm2)
      d0ccccqstswcwc = d040(qs,ts,wm2,cm2)
      d0ccccqstszczc = d040(qs,ts,zm2,cm2)
      d0ccccqsuszczc = d040(qs,us,zm2,cm2)
      jaaqstsdnel = jaa(qs,ts,dnm2,elm2)
      jaaqsusdnel = jaa(qs,us,dnm2,elm2)
      javqstsdnelz = jav(qs,ts,dnm2,elm2,cmz2)
      javqsusdnelz = jav(qs,us,dnm2,elm2,cmz2)
      pxx2zqsc = (2*mz**2)+(qs)

      ff_qed_gg =
     & -za1fer+stw**2*piggfer

      ff_qed_ll =
     & +fsr*(-stw**2*qel**2)
     & +isr*(-stw**2*qdn**2)
     & +jaaqstsdnel*dreal(propizqs)*ifi*cfscheme*(8*stw**4*ctw**2*qel**2
     & *qdn**2*ts/us-8*stw**4*ctw**2*qel**2*qdn**2*ts**2/us**2)
     & +jaaqsusdnel*dreal(propizqs)*ifi*cfscheme*(-8*stw**4*ctw**2*qel**
     & 2*qdn**2/ts**2*us**2+8*stw**4*ctw**2*qel**2*qdn**2/ts*us)
     & +javqstsdnelz*ifi*(4*stw**2*qel*qdn*vmael*vmadn*ts-4*stw**2*qel*q
     & dn*vmael*vpadn*ts-4*stw**2*qel*qdn*vpael*vmadn*ts+4*stw**2*qel*qd
     & n*vpael*vpadn*ts)
     & +javqstsdnelz*dreal(propizqs)*ifi*(2*stw**2*qel*qdn*vmael*vmadn*t
     & s/us**2*mz**2+2*stw**2*qel*qdn*vmael*vmadn*ts/us-2*stw**2*qel*qdn
     & *vmael*vmadn*ts**2/us**2+2*stw**2*qel*qdn*vpael*vpadn*ts/us**2*mz
     & **2+2*stw**2*qel*qdn*vpael*vpadn*ts/us-2*stw**2*qel*qdn*vpael*vpa
     & dn*ts**2/us**2)
     & +javqsusdnelz*ifi*(-4*stw**2*qel*qdn*vmael*vmadn*us+4*stw**2*qel*
     & qdn*vmael*vpadn*us+4*stw**2*qel*qdn*vpael*vmadn*us-4*stw**2*qel*q
     & dn*vpael*vpadn*us)
     & +javqsusdnelz*dreal(propizqs)*ifi*(2*stw**2*qel*qdn*vmael*vpadn/t
     & s**2*us*mz**2-2*stw**2*qel*qdn*vmael*vpadn/ts**2*us**2+2*stw**2*q
     & el*qdn*vmael*vpadn/ts*us+2*stw**2*qel*qdn*vpael*vmadn/ts**2*us*mz
     & **2-2*stw**2*qel*qdn*vpael*vmadn/ts**2*us**2+2*stw**2*qel*qdn*vpa
     & el*vmadn/ts*us)
     & +c0dndnqszdnc*dreal(propizqs)*ifi*(-2*stw**2*qel*qdn*vmael*vmadn/
     & us*mz**2-2*stw**2*qel*qdn*vmael*vmadn-2*stw**2*qel*qdn*vmael*vmad
     & n*ts/us**2*mz**2+2*stw**2*qel*qdn*vmael*vmadn*ts**2/us**2-2*stw**
     & 2*qel*qdn*vmael*vpadn/ts**2*us*mz**2+2*stw**2*qel*qdn*vmael*vpadn
     & /ts**2*us**2-2*stw**2*qel*qdn*vmael*vpadn/ts*mz**2-2*stw**2*qel*q
     & dn*vmael*vpadn-2*stw**2*qel*qdn*vpael*vmadn/ts**2*us*mz**2+2*stw*
     & *2*qel*qdn*vpael*vmadn/ts**2*us**2-2*stw**2*qel*qdn*vpael*vmadn/t
     & s*mz**2-2*stw**2*qel*qdn*vpael*vmadn-2*stw**2*qel*qdn*vpael*vpadn
     & /us*mz**2-2*stw**2*qel*qdn*vpael*vpadn-2*stw**2*qel*qdn*vpael*vpa
     & dn*ts/us**2*mz**2+2*stw**2*qel*qdn*vpael*vpadn*ts**2/us**2)
     & +c0irdndnqs*isr*(-2*stw**2*qdn**2*qs)
     & +c0dndnqscdnc*dreal(propizqs)*ifi*cfscheme*(8*stw**4*ctw**2*qel**
     & 2*qdn**2/ts**2*us**2-16*stw**4*ctw**2*qel**2*qdn**2+8*stw**4*ctw*
     & *2*qel**2*qdn**2*ts**2/us**2)
     & +c0irdnelts*ifi*(-4*stw**2*qel*qdn*vmael*vmadn*ts+4*stw**2*qel*qd
     & n*vmael*vpadn*ts+4*stw**2*qel*qdn*vpael*vmadn*ts-4*stw**2*qel*qdn
     & *vpael*vpadn*ts)
     & +c0irdnelus*ifi*(4*stw**2*qel*qdn*vmael*vmadn*us-4*stw**2*qel*qdn
     & *vmael*vpadn*us-4*stw**2*qel*qdn*vpael*vmadn*us+4*stw**2*qel*qdn*
     & vpael*vpadn*us)
     & +c0elelqszelc*dreal(propizqs)*ifi*(-2*stw**2*qel*qdn*vmael*vmadn/
     & us*mz**2-2*stw**2*qel*qdn*vmael*vmadn-2*stw**2*qel*qdn*vmael*vmad
     & n*ts/us**2*mz**2+2*stw**2*qel*qdn*vmael*vmadn*ts**2/us**2-2*stw**
     & 2*qel*qdn*vmael*vpadn/ts**2*us*mz**2+2*stw**2*qel*qdn*vmael*vpadn
     & /ts**2*us**2-2*stw**2*qel*qdn*vmael*vpadn/ts*mz**2-2*stw**2*qel*q
     & dn*vmael*vpadn-2*stw**2*qel*qdn*vpael*vmadn/ts**2*us*mz**2+2*stw*
     & *2*qel*qdn*vpael*vmadn/ts**2*us**2-2*stw**2*qel*qdn*vpael*vmadn/t
     & s*mz**2-2*stw**2*qel*qdn*vpael*vmadn-2*stw**2*qel*qdn*vpael*vpadn
     & /us*mz**2-2*stw**2*qel*qdn*vpael*vpadn-2*stw**2*qel*qdn*vpael*vpa
     & dn*ts/us**2*mz**2+2*stw**2*qel*qdn*vpael*vpadn*ts**2/us**2)
     & +c0irelelqs*fsr*(-2*stw**2*qel**2*qs)
     & +c0elelqscelc*dreal(propizqs)*ifi*cfscheme*(8*stw**4*ctw**2*qel**
     & 2*qdn**2/ts**2*us**2-16*stw**4*ctw**2*qel**2*qdn**2+8*stw**4*ctw*
     & *2*qel**2*qdn**2*ts**2/us**2)
     & +c0celtsczel*ifi*(4*stw**2*qel*qdn*vmael*vmadn*ts-4*stw**2*qel*qd
     & n*vmael*vpadn*ts-4*stw**2*qel*qdn*vpael*vmadn*ts+4*stw**2*qel*qdn
     & *vpael*vpadn*ts)
     & +c0celtsczel*dreal(propizqs)*ifi*(4*stw**2*qel*qdn*vmael*vmadn*ts
     & /us**2*mz**2+4*stw**2*qel*qdn*vmael*vmadn*ts/us-4*stw**2*qel*qdn*
     & vmael*vmadn*ts**2/us**2+4*stw**2*qel*qdn*vpael*vpadn*ts/us**2*mz*
     & *2+4*stw**2*qel*qdn*vpael*vpadn*ts/us-4*stw**2*qel*qdn*vpael*vpad
     & n*ts**2/us**2)
     & +c0celusczel*ifi*(-4*stw**2*qel*qdn*vmael*vmadn*us+4*stw**2*qel*q
     & dn*vmael*vpadn*us+4*stw**2*qel*qdn*vpael*vmadn*us-4*stw**2*qel*qd
     & n*vpael*vpadn*us)
     & +c0celusczel*dreal(propizqs)*ifi*(4*stw**2*qel*qdn*vmael*vpadn/ts
     & **2*us*mz**2-4*stw**2*qel*qdn*vmael*vpadn/ts**2*us**2+4*stw**2*qe
     & l*qdn*vmael*vpadn/ts*us+4*stw**2*qel*qdn*vpael*vmadn/ts**2*us*mz*
     & *2-4*stw**2*qel*qdn*vpael*vmadn/ts**2*us**2+4*stw**2*qel*qdn*vpae
     & l*vmadn/ts*us)
     & +a0fel*fsr*(-3*stw**2*qel**2)
     & +a0fdn*isr*(-3*stw**2*qdn**2)
     & +b0fqszc*dreal(propizqs)*ifi*(-4*stw**2*qel*qdn*vmael*vmadn/us-4*
     & stw**2*qel*qdn*vmael*vpadn/ts-4*stw**2*qel*qdn*vpael*vmadn/ts-4*s
     & tw**2*qel*qdn*vpael*vpadn/us)
     & +b0fqscc*fsr*(-3*stw**2*qel**2)
     & +b0fqscc*isr*(-3*stw**2*qdn**2)
     & +b0fqscc*dreal(propizqs)*ifi*cfscheme*(-16*stw**4*ctw**2*qel**2*q
     & dn**2/ts-16*stw**4*ctw**2*qel**2*qdn**2/us)
     & +b0ftscc*dreal(propizqs)*ifi*(4*stw**2*qel*qdn*vmael*vmadn/us+4*s
     & tw**2*qel*qdn*vpael*vpadn/us)
     & +b0ftscc*dreal(propizqs)*ifi*cfscheme*(16*stw**4*ctw**2*qel**2*qd
     & n**2/us)
     & +b0fuscc*dreal(propizqs)*ifi*(4*stw**2*qel*qdn*vmael*vpadn/ts+4*s
     & tw**2*qel*qdn*vpael*vmadn/ts)
     & +b0fuscc*dreal(propizqs)*ifi*cfscheme*(16*stw**4*ctw**2*qel**2*qd
     & n**2/ts)
     & +lnladnm*isr*(2*stw**2*qdn**2)
     & +lnlaelm*fsr*(2*stw**2*qel**2)

      ff_qed_ql =
     & +fsr*(-stw**2*qel**2)
     & +isr*(-stw**2*qdn**2)
     & +jaaqstsdnel*dreal(propizqs)*ifi*cfscheme*(-2*stw**2*ctw**2*qel**
     & 2*qdn*ts/us+2*stw**2*ctw**2*qel**2*qdn*ts**2/us**2)
     & +jaaqsusdnel*dreal(propizqs)*ifi*cfscheme*(2*stw**2*ctw**2*qel**2
     & *qdn/ts**2*us**2-2*stw**2*ctw**2*qel**2*qdn/ts*us)
     & +javqstsdnelz*ifi*(4*stw**2*qel*qdn*vmael*ts-4*stw**2*qel*qdn*vpa
     & el*ts)
     & +javqstsdnelz*dreal(propizqs)*ifi*(2*stw**2*qel*qdn*vmael*ts/us**
     & 2*mz**2+2*stw**2*qel*qdn*vmael*ts/us-2*stw**2*qel*qdn*vmael*ts**2
     & /us**2)
     & +javqsusdnelz*ifi*(-4*stw**2*qel*qdn*vmael*us+4*stw**2*qel*qdn*vp
     & ael*us)
     & +javqsusdnelz*dreal(propizqs)*ifi*(2*stw**2*qel*qdn*vpael/ts**2*u
     & s*mz**2-2*stw**2*qel*qdn*vpael/ts**2*us**2+2*stw**2*qel*qdn*vpael
     & /ts*us)
     & +c0dndnqszdnc*dreal(propizqs)*ifi*(-2*stw**2*qel*qdn*vmael/us*mz*
     & *2-2*stw**2*qel*qdn*vmael-2*stw**2*qel*qdn*vmael*ts/us**2*mz**2+2
     & *stw**2*qel*qdn*vmael*ts**2/us**2-2*stw**2*qel*qdn*vpael/ts**2*us
     & *mz**2+2*stw**2*qel*qdn*vpael/ts**2*us**2-2*stw**2*qel*qdn*vpael/
     & ts*mz**2-2*stw**2*qel*qdn*vpael)
     & +c0irdndnqs*isr*(-2*stw**2*qdn**2*qs)
     & +c0dndnqscdnc*dreal(propizqs)*ifi*cfscheme*(-2*stw**2*ctw**2*qel*
     & *2*qdn/ts**2*us**2+4*stw**2*ctw**2*qel**2*qdn-2*stw**2*ctw**2*qel
     & **2*qdn*ts**2/us**2)
     & +c0irdnelts*ifi*(-4*stw**2*qel*qdn*vmael*ts+4*stw**2*qel*qdn*vpae
     & l*ts)
     & +c0irdnelus*ifi*(4*stw**2*qel*qdn*vmael*us-4*stw**2*qel*qdn*vpael
     & *us)
     & +c0elelqszelc*dreal(propizqs)*ifi*(-2*stw**2*qel*qdn*vmael/us*mz*
     & *2-2*stw**2*qel*qdn*vmael-2*stw**2*qel*qdn*vmael*ts/us**2*mz**2+2
     & *stw**2*qel*qdn*vmael*ts**2/us**2-2*stw**2*qel*qdn*vpael/ts**2*us
     & *mz**2+2*stw**2*qel*qdn*vpael/ts**2*us**2-2*stw**2*qel*qdn*vpael/
     & ts*mz**2-2*stw**2*qel*qdn*vpael)
     & +c0irelelqs*fsr*(-2*stw**2*qel**2*qs)
     & +c0elelqscelc*dreal(propizqs)*ifi*cfscheme*(-2*stw**2*ctw**2*qel*
     & *2*qdn/ts**2*us**2+4*stw**2*ctw**2*qel**2*qdn-2*stw**2*ctw**2*qel
     & **2*qdn*ts**2/us**2)
     & +c0celtsczel*ifi*(4*stw**2*qel*qdn*vmael*ts-4*stw**2*qel*qdn*vpae
     & l*ts)
     & +c0celtsczel*dreal(propizqs)*ifi*(4*stw**2*qel*qdn*vmael*ts/us**2
     & *mz**2+4*stw**2*qel*qdn*vmael*ts/us-4*stw**2*qel*qdn*vmael*ts**2/
     & us**2)
     & +c0celusczel*ifi*(-4*stw**2*qel*qdn*vmael*us+4*stw**2*qel*qdn*vpa
     & el*us)
     & +c0celusczel*dreal(propizqs)*ifi*(4*stw**2*qel*qdn*vpael/ts**2*us
     & *mz**2-4*stw**2*qel*qdn*vpael/ts**2*us**2+4*stw**2*qel*qdn*vpael/
     & ts*us)
     & +a0fel*fsr*(-3*stw**2*qel**2)
     & +a0fdn*isr*(-3*stw**2*qdn**2)
     & +b0fqszc*dreal(propizqs)*ifi*(-4*stw**2*qel*qdn*vmael/us-4*stw**2
     & *qel*qdn*vpael/ts)
     & +b0fqscc*fsr*(-3*stw**2*qel**2)
     & +b0fqscc*isr*(-3*stw**2*qdn**2)
     & +b0fqscc*dreal(propizqs)*ifi*cfscheme*(4*stw**2*ctw**2*qel**2*qdn
     & /ts+4*stw**2*ctw**2*qel**2*qdn/us)
     & +b0ftscc*dreal(propizqs)*ifi*(4*stw**2*qel*qdn*vmael/us)
     & +b0ftscc*dreal(propizqs)*ifi*cfscheme*(-4*stw**2*ctw**2*qel**2*qd
     & n/us)
     & +b0fuscc*dreal(propizqs)*ifi*(4*stw**2*qel*qdn*vpael/ts)
     & +b0fuscc*dreal(propizqs)*ifi*cfscheme*(-4*stw**2*ctw**2*qel**2*qd
     & n/ts)
     & +lnladnm*isr*(2*stw**2*qdn**2)
     & +lnlaelm*fsr*(2*stw**2*qel**2)

      ff_qed_lq =
     & +fsr*(-stw**2*qel**2)
     & +isr*(-stw**2*qdn**2)
     & +jaaqstsdnel*dreal(propizqs)*ifi*cfscheme*(-2*stw**2*ctw**2*qel*q
     & dn**2*ts/us+2*stw**2*ctw**2*qel*qdn**2*ts**2/us**2)
     & +jaaqsusdnel*dreal(propizqs)*ifi*cfscheme*(2*stw**2*ctw**2*qel*qd
     & n**2/ts**2*us**2-2*stw**2*ctw**2*qel*qdn**2/ts*us)
     & +javqstsdnelz*ifi*(4*stw**2*qel*qdn*vmadn*ts-4*stw**2*qel*qdn*vpa
     & dn*ts)
     & +javqstsdnelz*dreal(propizqs)*ifi*(2*stw**2*qel*qdn*vmadn*ts/us**
     & 2*mz**2+2*stw**2*qel*qdn*vmadn*ts/us-2*stw**2*qel*qdn*vmadn*ts**2
     & /us**2)
     & +javqsusdnelz*ifi*(-4*stw**2*qel*qdn*vmadn*us+4*stw**2*qel*qdn*vp
     & adn*us)
     & +javqsusdnelz*dreal(propizqs)*ifi*(2*stw**2*qel*qdn*vpadn/ts**2*u
     & s*mz**2-2*stw**2*qel*qdn*vpadn/ts**2*us**2+2*stw**2*qel*qdn*vpadn
     & /ts*us)
     & +c0dndnqszdnc*dreal(propizqs)*ifi*(-2*stw**2*qel*qdn*vmadn/us*mz*
     & *2-2*stw**2*qel*qdn*vmadn-2*stw**2*qel*qdn*vmadn*ts/us**2*mz**2+2
     & *stw**2*qel*qdn*vmadn*ts**2/us**2-2*stw**2*qel*qdn*vpadn/ts**2*us
     & *mz**2+2*stw**2*qel*qdn*vpadn/ts**2*us**2-2*stw**2*qel*qdn*vpadn/
     & ts*mz**2-2*stw**2*qel*qdn*vpadn)
     & +c0irdndnqs*isr*(-2*stw**2*qdn**2*qs)
     & +c0dndnqscdnc*dreal(propizqs)*ifi*cfscheme*(-2*stw**2*ctw**2*qel*
     & qdn**2/ts**2*us**2+4*stw**2*ctw**2*qel*qdn**2-2*stw**2*ctw**2*qel
     & *qdn**2*ts**2/us**2)
     & +c0irdnelts*ifi*(-4*stw**2*qel*qdn*vmadn*ts+4*stw**2*qel*qdn*vpad
     & n*ts)
     & +c0irdnelus*ifi*(4*stw**2*qel*qdn*vmadn*us-4*stw**2*qel*qdn*vpadn
     & *us)
     & +c0elelqszelc*dreal(propizqs)*ifi*(-2*stw**2*qel*qdn*vmadn/us*mz*
     & *2-2*stw**2*qel*qdn*vmadn-2*stw**2*qel*qdn*vmadn*ts/us**2*mz**2+2
     & *stw**2*qel*qdn*vmadn*ts**2/us**2-2*stw**2*qel*qdn*vpadn/ts**2*us
     & *mz**2+2*stw**2*qel*qdn*vpadn/ts**2*us**2-2*stw**2*qel*qdn*vpadn/
     & ts*mz**2-2*stw**2*qel*qdn*vpadn)
     & +c0irelelqs*fsr*(-2*stw**2*qel**2*qs)
     & +c0elelqscelc*dreal(propizqs)*ifi*cfscheme*(-2*stw**2*ctw**2*qel*
     & qdn**2/ts**2*us**2+4*stw**2*ctw**2*qel*qdn**2-2*stw**2*ctw**2*qel
     & *qdn**2*ts**2/us**2)
     & +c0celtsczel*ifi*(4*stw**2*qel*qdn*vmadn*ts-4*stw**2*qel*qdn*vpad
     & n*ts)
     & +c0celtsczel*dreal(propizqs)*ifi*(4*stw**2*qel*qdn*vmadn*ts/us**2
     & *mz**2+4*stw**2*qel*qdn*vmadn*ts/us-4*stw**2*qel*qdn*vmadn*ts**2/
     & us**2)
     & +c0celusczel*ifi*(-4*stw**2*qel*qdn*vmadn*us+4*stw**2*qel*qdn*vpa
     & dn*us)
     & +c0celusczel*dreal(propizqs)*ifi*(4*stw**2*qel*qdn*vpadn/ts**2*us
     & *mz**2-4*stw**2*qel*qdn*vpadn/ts**2*us**2+4*stw**2*qel*qdn*vpadn/
     & ts*us)
     & +a0fel*fsr*(-3*stw**2*qel**2)
     & +a0fdn*isr*(-3*stw**2*qdn**2)
     & +b0fqszc*dreal(propizqs)*ifi*(-4*stw**2*qel*qdn*vmadn/us-4*stw**2
     & *qel*qdn*vpadn/ts)
     & +b0fqscc*fsr*(-3*stw**2*qel**2)
     & +b0fqscc*isr*(-3*stw**2*qdn**2)
     & +b0fqscc*dreal(propizqs)*ifi*cfscheme*(4*stw**2*ctw**2*qel*qdn**2
     & /ts+4*stw**2*ctw**2*qel*qdn**2/us)
     & +b0ftscc*dreal(propizqs)*ifi*(4*stw**2*qel*qdn*vmadn/us)
     & +b0ftscc*dreal(propizqs)*ifi*cfscheme*(-4*stw**2*ctw**2*qel*qdn**
     & 2/us)
     & +b0fuscc*dreal(propizqs)*ifi*(4*stw**2*qel*qdn*vpadn/ts)
     & +b0fuscc*dreal(propizqs)*ifi*cfscheme*(-4*stw**2*ctw**2*qel*qdn**
     & 2/ts)
     & +lnladnm*isr*(2*stw**2*qdn**2)
     & +lnlaelm*fsr*(2*stw**2*qel**2)

      ff_qed_qq =
     & +fsr*(-stw**2*qel**2)
     & +isr*(-stw**2*qdn**2)
     & +prop1zqs*c0irdndnqs*isr*cfscheme*(-2*qdn**2+2*stw**2*qdn**2)
     & +prop1zqs*c0ireldnts*ifi*cfscheme*(-4*ctw**2*qel*qdn/qs*ts)
     & +prop1zqs*c0ireldnus*ifi*cfscheme*(4*ctw**2*qel*qdn/qs*us)
     & +prop1zqs*c0irelelqs*fsr*cfscheme*(-2*qel**2+2*stw**2*qel**2)
     & +prop1zqs*lnladnm*isr*cfscheme*(2*qdn**2/qs-2*stw**2*qdn**2/qs)
     & +prop1zqs*lnlaelm*fsr*cfscheme*(2*qel**2/qs-2*stw**2*qel**2/qs)
     & +jaaqstsdnel*dreal(propizqs)*ifi*cfscheme*(2*ctw**2*qel*qdn/qs*ts
     & +ctw**2*qel*qdn*ts/us-ctw**2*qel*qdn*ts**2/us**2)
     & +jaaqsusdnel*dreal(propizqs)*ifi*cfscheme*(-2*ctw**2*qel*qdn/qs*u
     & s)
     & +javqstsdnelz*ifi*(4*stw**2*qel*qdn*ts)
     & +javqstsdnelz*dreal(propizqs)*ifi*(2*stw**2*qel*qdn*ts/us**2*mz**
     & 2+2*stw**2*qel*qdn*ts/us-2*stw**2*qel*qdn*ts**2/us**2)
     & +javqsusdnelz*ifi*(-4*stw**2*qel*qdn*us)
     & +c0dndnqszdnc*dreal(propizqs)*ifi*(-2*stw**2*qel*qdn/us*mz**2-2*s
     & tw**2*qel*qdn-2*stw**2*qel*qdn*ts/us**2*mz**2+2*stw**2*qel*qdn*ts
     & **2/us**2)
     & +c0irdndnqs*isr*(-2*stw**2*qdn**2*qs)
     & +c0dndnqscdnc*dreal(propizqs)*ifi*cfscheme*(-ctw**2*qel*qdn+ctw**
     & 2*qel*qdn*ts**2/us**2)
     & +c0irdnelts*ifi*(-4*stw**2*qel*qdn*ts)
     & +c0irdnelus*ifi*(4*stw**2*qel*qdn*us)
     & +c0elelqszelc*dreal(propizqs)*ifi*(-2*stw**2*qel*qdn/us*mz**2-2*s
     & tw**2*qel*qdn-2*stw**2*qel*qdn*ts/us**2*mz**2+2*stw**2*qel*qdn*ts
     & **2/us**2)
     & +c0irelelqs*fsr*(-2*stw**2*qel**2*qs)
     & +c0elelqscelc*dreal(propizqs)*ifi*cfscheme*(-ctw**2*qel*qdn+ctw**
     & 2*qel*qdn*ts**2/us**2)
     & +c0celtsczel*ifi*(4*stw**2*qel*qdn*ts)
     & +c0celtsczel*dreal(propizqs)*ifi*(4*stw**2*qel*qdn*ts/us**2*mz**2
     & +4*stw**2*qel*qdn*ts/us-4*stw**2*qel*qdn*ts**2/us**2)
     & +c0celusczel*ifi*(-4*stw**2*qel*qdn*us)
     & +a0fel*fsr*(-3*stw**2*qel**2)
     & +a0fel*dreal(propizqs)*fsr*cfscheme*(-3*qel**2/qs+3*stw**2*qel**2
     & /qs)
     & +a0fdn*isr*(-3*stw**2*qdn**2)
     & +a0fdn*dreal(propizqs)*isr*cfscheme*(-3*qdn**2/qs+3*stw**2*qdn**2
     & /qs)
     & +b0fqszc*dreal(propizqs)*ifi*(-4*stw**2*qel*qdn/us)
     & +b0fqscc*fsr*(-3*stw**2*qel**2)
     & +b0fqscc*isr*(-3*stw**2*qdn**2)
     & +b0fqscc*dreal(propizqs)*ifi*cfscheme*(-2*ctw**2*qel*qdn/us)
     & +b0fqscc*dreal(propizqs)*fsr*cfscheme*(-3*qel**2/qs+3*stw**2*qel*
     & *2/qs)
     & +b0fqscc*dreal(propizqs)*isr*cfscheme*(-3*qdn**2/qs+3*stw**2*qdn*
     & *2/qs)
     & +b0ftscc*dreal(propizqs)*ifi*(4*stw**2*qel*qdn/us)
     & +b0ftscc*dreal(propizqs)*ifi*cfscheme*(2*ctw**2*qel*qdn/us)
     & +lnladnm*isr*(2*stw**2*qdn**2)
     & +lnlaelm*fsr*(2*stw**2*qel**2)
     & +dreal(propizqs)*fsr*cfscheme*(-qel**2/qs+stw**2*qel**2/qs)
     & +dreal(propizqs)*isr*cfscheme*(-qdn**2/qs+stw**2*qdn**2/qs)

      ff_qed_ld =
     & 0

      ff_qed_qd =
     & 0

      ff_ew_ll =
     & +d0ccccqstswcwc*dreal(propizqs)*(-2/us*mw**4*rwz-4*ts/us**2*mw**4
     & *rwz-ts*rwz+4*ts**2/us**2*mw**2*rwz-ts**3/us**2*rwz)
     & +d0ccccqstszczc*dreal(propizqs)*pxx2zqsc**2*(-1d0/8/ctw**2*vmael*
     & *2*vmadn**2/us-1d0/4/ctw**2*vmael**2*vmadn**2*ts/us**2-1d0/8/ctw*
     & *2*vpael**2*vpadn**2/us-1d0/4/ctw**2*vpael**2*vpadn**2*ts/us**2)
     & +d0ccccqstszczc*dreal(propizqs)*pxx2zqsc*(-3d0/4/ctw**2*vmael**2*
     & vmadn**2*ts/us-3d0/4/ctw**2*vpael**2*vpadn**2*ts/us)
     & +d0ccccqstszczc*dreal(propizqs)*(-1d0/2/ctw**2*vmael**2*vmadn**2*
     & mz**2+1d0/8/ctw**2*vmael**2*vmadn**2*us-1d0/2/ctw**2*vmael**2*vma
     & dn**2*ts-1d0/8/ctw**2*vmael**2*vmadn**2*ts**2/us+1d0/2/ctw**2*vma
     & el**2*vpadn**2*ts+1d0/2/ctw**2*vpael**2*vmadn**2*ts-1d0/2/ctw**2*
     & vpael**2*vpadn**2*mz**2+1d0/8/ctw**2*vpael**2*vpadn**2*us-1d0/2/c
     & tw**2*vpael**2*vpadn**2*ts-1d0/8/ctw**2*vpael**2*vpadn**2*ts**2/u
     & s)
     & +d0ccccqsuszczc*dreal(propizqs)*pxx2zqsc**2*(-1d0/4/ctw**2*vmael*
     & *2*vpadn**2/ts**2*us-1d0/8/ctw**2*vmael**2*vpadn**2/ts-1d0/4/ctw*
     & *2*vpael**2*vmadn**2/ts**2*us-1d0/8/ctw**2*vpael**2*vmadn**2/ts)
     & +d0ccccqsuszczc*dreal(propizqs)*pxx2zqsc*(-3d0/4/ctw**2*vmael**2*
     & vpadn**2/ts*us-1d0/4/ctw**2*vmael**2*vpadn**2-3d0/4/ctw**2*vpael*
     & *2*vmadn**2/ts*us-1d0/4/ctw**2*vpael**2*vmadn**2)
     & +d0ccccqsuszczc*dreal(propizqs)*(1d0/2/ctw**2*vmael**2*vmadn**2*u
     & s-1d0/8/ctw**2*vmael**2*vpadn**2/ts*us**2-3d0/4/ctw**2*vmael**2*v
     & padn**2*us-1d0/8/ctw**2*vmael**2*vpadn**2*ts-1d0/8/ctw**2*vpael**
     & 2*vmadn**2/ts*us**2-3d0/4/ctw**2*vpael**2*vmadn**2*us-1d0/8/ctw**
     & 2*vpael**2*vmadn**2*ts+1d0/2/ctw**2*vpael**2*vpadn**2*us)
     & +c0ccqswcw*dreal(propizqs)*(-4/us*mw**2*rwz+2*rwz-4*ts/us**2*mw**
     & 2*rwz+2*ts**2/us**2*rwz)
     & +c0ccqswcw*(4/qs*mw**4*rwz-8*mw**2*rwz)
     & +c0ccqszcz*dreal(propizqs)*pxx2zqsc*(-1d0/2/ctw**2*vmael**2*vmadn
     & **2/us-1d0/2/ctw**2*vmael**2*vmadn**2*ts/us**2-1d0/2/ctw**2*vmael
     & **2*vpadn**2/ts**2*us-1d0/2/ctw**2*vmael**2*vpadn**2/ts-1d0/2/ctw
     & **2*vpael**2*vmadn**2/ts**2*us-1d0/2/ctw**2*vpael**2*vmadn**2/ts-
     & 1d0/2/ctw**2*vpael**2*vpadn**2/us-1d0/2/ctw**2*vpael**2*vpadn**2*
     & ts/us**2)
     & +c0ccqszcz*dreal(propizqs)*(-1d0/ctw**2*vmael**2*vmadn**2-1d0/ctw
     & **2*vmael**2*vmadn**2*ts/us-1d0/ctw**2*vmael**2*vpadn**2/ts*us-1d
     & 0/ctw**2*vmael**2*vpadn**2-1d0/ctw**2*vpael**2*vmadn**2/ts*us-1d0
     & /ctw**2*vpael**2*vmadn**2-1d0/ctw**2*vpael**2*vpadn**2-1d0/ctw**2
     & *vpael**2*vpadn**2*ts/us)
     & +c0ccqscwc*(-1d0/qs*mw**4+2/qs*mw**4*rwz+2*mw**2-4*mw**2*rwz-qs+2
     & *qs*rwz+vpaup/qs*mw**4-2*vpaup*mw**2+vpaup*qs+vmael/qs*mw**4-2*vm
     & ael*mw**2+vmael*qs)
     & +c0ccqsczc*(-1d0/qs*mw**4/rwz**3+2*mw**2/rwz**2-qs/rwz-3d0/2*vpad
     & n/qs*mw**4/rwz**3+3*vpadn*mw**2/rwz**2-3d0/2*vpadn*qs/rwz-3d0/2*v
     & padn**2/qs*mw**4/rwz**3+3*vpadn**2*mw**2/rwz**2-3d0/2*vpadn**2*qs
     & /rwz+3d0/2*vmael/qs*mw**4/rwz**3-3*vmael*mw**2/rwz**2+3d0/2*vmael
     & *qs/rwz-3d0/2*vmael**2/qs*mw**4/rwz**3+3*vmael**2*mw**2/rwz**2-3d
     & 0/2*vmael**2*qs/rwz)
     & +c0cctscwc*dreal(propizqs)*(4*ts/us**2*mw**2*rwz+2*ts/us*rwz-2*ts
     & **2/us**2*rwz)
     & +c0cctsczc*dreal(propizqs)*pxx2zqsc*(1d0/2/ctw**2*vmael**2*vmadn*
     & *2*ts/us**2+1d0/2/ctw**2*vpael**2*vpadn**2*ts/us**2)
     & +c0cctsczc*dreal(propizqs)*(1d0/ctw**2*vmael**2*vmadn**2*ts/us+1d
     & 0/ctw**2*vpael**2*vpadn**2*ts/us)
     & +c0ccusczc*dreal(propizqs)*pxx2zqsc*(1d0/2/ctw**2*vmael**2*vpadn*
     & *2/ts**2*us+1d0/2/ctw**2*vpael**2*vmadn**2/ts**2*us)
     & +c0ccusczc*dreal(propizqs)*(1d0/ctw**2*vmael**2*vpadn**2/ts*us+1d
     & 0/ctw**2*vpael**2*vmadn**2/ts*us)
     & +a0fw*dreal(propzqs)*(3*mw**2/rwz/rhw+1d0/6*mw**2/rwz-8d0/3*mw**2
     & -4*mw**2*rwz)
     & +a0fw*(-3d0/2+1d0/qs*mw**2+2/qs*mw**2*rwz+rwz-vpaup/qs*mw**2+3d0/
     & 2*vpaup-vmael/qs*mw**2+3d0/2*vmael)
     & +a0fz*dreal(propzqs)*(3d0/2*mw**2/rwz**3/rhw+1d0/6*mw**2/rwz**2-1
     & d0/12*mw**2/rwz*rhw)
     & +a0fz*(11d0/12/qs*mw**2/rwz**2+1d0/12/qs*mw**2/rwz*rhw-3d0/2/rwz+
     & 3d0/2*vpadn/qs*mw**2/rwz**2-9d0/4*vpadn/rwz+3d0/2*vpadn**2/qs*mw*
     & *2/rwz**2-9d0/4*vpadn**2/rwz-3d0/2*vmael/qs*mw**2/rwz**2+9d0/4*vm
     & ael/rwz+3d0/2*vmael**2/qs*mw**2/rwz**2-9d0/4*vmael**2/rwz)
     & +a0fh*dreal(propzqs)*(1d0/2*mw**2/rwz*rhw+1d0/12*mw**2*rhw**2)
     & +a0fh*(1d0/12/qs*mw**2/rwz*rhw-1d0/12/qs*mw**2*rhw**2)
     & +b0fqsww*dreal(propzqs)*(1d0/12*mw**2/rwz**2+4d0/3*mw**2/rwz-17d0
     & /3*mw**2-4*mw**2*rwz)
     & +b0fqsww*dreal(propizqs)*(-2/us*rwz+5d0/3/mw**2*rwz-1d0/12*qs/mw*
     & *4*rwz)
     & +b0fqsww*(-4d0/3+4/qs*mw**2*rwz-1d0/12/rwz+rwz+1d0/12*qs/mw**2-5d
     & 0/3*qs/mw**2*rwz+1d0/12*qs**2/mw**4*rwz)
     & +b0fqszz*dreal(propizqs)*(-1d0/2/ctw**2*vmael**2*vmadn**2/us-1d0/
     & 2/ctw**2*vmael**2*vpadn**2/ts-1d0/2/ctw**2*vpael**2*vmadn**2/ts-1
     & d0/2/ctw**2*vpael**2*vpadn**2/us)
     & +b0fqszh*dreal(propzqs)*(mw**2/rwz**2-1d0/3*mw**2/rwz*rhw+1d0/12*
     & mw**2*rhw**2)
     & +b0fqszh*(-1d0/12/qs*mw**2/rwz**2+1d0/6/qs*mw**2/rwz*rhw-1d0/12/q
     & s*mw**2*rhw**2-1d0/12/rwz)
     & +b0fqscc*(-3d0/2+1d0/qs*mw**2/rwz**2+1d0/qs*mw**2-2/qs*mw**2*rwz-
     & 3d0/2/rwz+3*rwz+3d0/2*vpadn/qs*mw**2/rwz**2-9d0/4*vpadn/rwz+3d0/2
     & *vpadn**2/qs*mw**2/rwz**2-9d0/4*vpadn**2/rwz-vpaup/qs*mw**2+3d0/2
     & *vpaup-3d0/2*vmael/qs*mw**2/rwz**2-vmael/qs*mw**2+9d0/4*vmael/rwz
     & +3d0/2*vmael+3d0/2*vmael**2/qs*mw**2/rwz**2-9d0/4*vmael**2/rwz)
     & +b0ftscc*dreal(propizqs)*(1d0/2/ctw**2*vmael**2*vmadn**2/us+1d0/2
     & /ctw**2*vpael**2*vpadn**2/us+2/us*rwz)
     & +b0fuscc*dreal(propizqs)*(1d0/2/ctw**2*vmael**2*vpadn**2/ts+1d0/2
     & /ctw**2*vpael**2*vmadn**2/ts)
     & +dreal(propzqs)*(mw**2/rwz**3/rhw-1d0/18*mw**2/rwz**2+2*mw**2/rwz
     & /rhw-5d0/9*mw**2/rwz-mw**2/rwz*zmzzzbos-1d0/6*mw**2/rwz*rhw-8d0/3
     & *mw**2-4*mw**2*rwz)
     & -1d0/36+1d0/stw**2*deltarhofer+1d0/stw**2*deltarhobos-13d0/36/rwz
     & +caldzfer-2*deltarhofer-za1fer-2*deltarhobos-za1bos+6*rwz-3d0/8*v
     & padn/rwz-3d0/4*vpadn-3d0/8*vpadn**2/rwz+vpaup+3d0/8*vmael/rwz+1d0
     & /4*vmael-3d0/8*vmael**2/rwz

      ff_ew_ql =
     & +d0ccccqstszczc*dreal(propizqs)*pxx2zqsc**2*(-1d0/8/ctw**2*vmael*
     & *2*vmadn/us-1d0/4/ctw**2*vmael**2*vmadn*ts/us**2)
     & +d0ccccqstszczc*dreal(propizqs)*pxx2zqsc*(-3d0/4/ctw**2*vmael**2*
     & vmadn*ts/us)
     & +d0ccccqstszczc*dreal(propizqs)*(-1d0/2/ctw**2*vmael**2*vmadn*mz*
     & *2+1d0/8/ctw**2*vmael**2*vmadn*us-1d0/2/ctw**2*vmael**2*vmadn*ts-
     & 1d0/8/ctw**2*vmael**2*vmadn*ts**2/us+1d0/2/ctw**2*vpael**2*vmadn*
     & ts)
     & +d0ccccqsuszczc*dreal(propizqs)*pxx2zqsc**2*(-1d0/4/ctw**2*vpael*
     & *2*vmadn/ts**2*us-1d0/8/ctw**2*vpael**2*vmadn/ts)
     & +d0ccccqsuszczc*dreal(propizqs)*pxx2zqsc*(-3d0/4/ctw**2*vpael**2*
     & vmadn/ts*us-1d0/4/ctw**2*vpael**2*vmadn)
     & +d0ccccqsuszczc*dreal(propizqs)*(1d0/2/ctw**2*vmael**2*vmadn*us-1
     & d0/8/ctw**2*vpael**2*vmadn/ts*us**2-3d0/4/ctw**2*vpael**2*vmadn*u
     & s-1d0/8/ctw**2*vpael**2*vmadn*ts)
     & +c0ccqswcw*(-2/qs**2*mw**6+4/qs*mw**4)
     & +c0ccqszcz*dreal(propizqs)*pxx2zqsc*(-1d0/2/ctw**2*vmael**2*vmadn
     & /us-1d0/2/ctw**2*vmael**2*vmadn*ts/us**2-1d0/2/ctw**2*vpael**2*vm
     & adn/ts**2*us-1d0/2/ctw**2*vpael**2*vmadn/ts)
     & +c0ccqszcz*dreal(propizqs)*(-1d0/ctw**2*vmael**2*vmadn-1d0/ctw**2
     & *vmael**2*vmadn*ts/us-1d0/ctw**2*vpael**2*vmadn/ts*us-1d0/ctw**2*
     & vpael**2*vmadn)
     & +c0ccqscwc*(-1d0/qs*mw**4+2/qs*mw**4*rwz+2*mw**2-4*mw**2*rwz-qs+2
     & *qs*rwz+vmael/qs*mw**4-2*vmael*mw**2+vmael*qs)
     & +c0ccqsczc*(-1d0/qs*mw**4/rwz**3+2*mw**2/rwz**2-qs/rwz-vpadn/qs*m
     & w**4/rwz**3+2*vpadn*mw**2/rwz**2-vpadn*qs/rwz-1d0/2*vpadn**2/qs*m
     & w**4/rwz**3+vpadn**2*mw**2/rwz**2-1d0/2*vpadn**2*qs/rwz+3d0/2*vma
     & el/qs*mw**4/rwz**3-3*vmael*mw**2/rwz**2+3d0/2*vmael*qs/rwz-3d0/2*
     & vmael**2/qs*mw**4/rwz**3+3*vmael**2*mw**2/rwz**2-3d0/2*vmael**2*q
     & s/rwz-qel/qs**2*mw**6/rwz**3+qel/qs*mw**4/rwz**2+qel*mw**2/rwz-qe
     & l*qs+2*qel*vmael/qs**2*mw**6/rwz**3-2*qel*vmael/qs*mw**4/rwz**2-2
     & *qel*vmael*mw**2/rwz+2*qel*vmael*qs)
     & +c0cctsczc*dreal(propizqs)*pxx2zqsc*(1d0/2/ctw**2*vmael**2*vmadn*
     & ts/us**2)
     & +c0cctsczc*dreal(propizqs)*(1d0/ctw**2*vmael**2*vmadn*ts/us)
     & +c0ccusczc*dreal(propizqs)*pxx2zqsc*(1d0/2/ctw**2*vpael**2*vmadn/
     & ts**2*us)
     & +c0ccusczc*dreal(propizqs)*(1d0/ctw**2*vpael**2*vmadn/ts*us)
     & +a0fw*dreal(propzqs)*(3*mw**2/rwz/rhw+1d0/6*mw**2/rwz-8d0/3*mw**2
     & -4*mw**2*rwz)
     & +a0fw*(-3d0/2-2/qs**2*mw**4+10d0/3/qs*mw**2+2/qs*mw**2*rwz+3*rwz-
     & vmael/qs*mw**2+3d0/2*vmael)
     & +a0fz*dreal(propzqs)*(3d0/2*mw**2/rwz**3/rhw+1d0/6*mw**2/rwz**2-1
     & d0/12*mw**2/rwz*rhw)
     & +a0fz*(11d0/12/qs*mw**2/rwz**2+1d0/12/qs*mw**2/rwz*rhw-3d0/2/rwz+
     & vpadn/qs*mw**2/rwz**2-3d0/2*vpadn/rwz+1d0/2*vpadn**2/qs*mw**2/rwz
     & **2-3d0/4*vpadn**2/rwz-3d0/2*vmael/qs*mw**2/rwz**2+9d0/4*vmael/rw
     & z+3d0/2*vmael**2/qs*mw**2/rwz**2-9d0/4*vmael**2/rwz+qel/qs**2*mw*
     & *4/rwz**2-1d0/2*qel/qs*mw**2/rwz-3d0/2*qel-2*qel*vmael/qs**2*mw**
     & 4/rwz**2+qel*vmael/qs*mw**2/rwz+3*qel*vmael)
     & +a0fh*dreal(propzqs)*(1d0/2*mw**2/rwz*rhw+1d0/12*mw**2*rhw**2)
     & +a0fh*(1d0/12/qs*mw**2/rwz*rhw-1d0/12/qs*mw**2*rhw**2)
     & +b0fqsww*dreal(propzqs)*(1d0/12*mw**2/rwz**2+4d0/3*mw**2/rwz-17d0
     & /3*mw**2-4*mw**2*rwz)
     & +b0fqsww*(1d0/6-2/qs**2*mw**4+7d0/3/qs*mw**2+4/qs*mw**2*rwz-1d0/1
     & 2/rwz)
     & +b0fqszz*dreal(propizqs)*(-1d0/2/ctw**2*vmael**2*vmadn/us-1d0/2/c
     & tw**2*vpael**2*vmadn/ts)
     & +b0fqszh*dreal(propzqs)*(mw**2/rwz**2-1d0/3*mw**2/rwz*rhw+1d0/12*
     & mw**2*rhw**2)
     & +b0fqszh*(-1d0/12/qs*mw**2/rwz**2+1d0/6/qs*mw**2/rwz*rhw-1d0/12/q
     & s*mw**2*rhw**2-1d0/12/rwz)
     & +b0fqscc*(-3d0/2+1d0/qs*mw**2/rwz**2+1d0/qs*mw**2-2/qs*mw**2*rwz-
     & 3d0/2/rwz+3*rwz+vpadn/qs*mw**2/rwz**2-3d0/2*vpadn/rwz+1d0/2*vpadn
     & **2/qs*mw**2/rwz**2-3d0/4*vpadn**2/rwz-3d0/2*vmael/qs*mw**2/rwz**
     & 2-vmael/qs*mw**2+9d0/4*vmael/rwz+3d0/2*vmael+3d0/2*vmael**2/qs*mw
     & **2/rwz**2-9d0/4*vmael**2/rwz+qel/qs**2*mw**4/rwz**2-1d0/2*qel/qs
     & *mw**2/rwz-3d0/2*qel-2*qel*vmael/qs**2*mw**4/rwz**2+qel*vmael/qs*
     & mw**2/rwz+3*qel*vmael)
     & +b0ftscc*dreal(propizqs)*(1d0/2/ctw**2*vmael**2*vmadn/us)
     & +b0fuscc*dreal(propizqs)*(1d0/2/ctw**2*vpael**2*vmadn/ts)
     & +dreal(propzqs)*(mw**2/rwz**3/rhw-1d0/18*mw**2/rwz**2+2*mw**2/rwz
     & /rhw-5d0/9*mw**2/rwz-mw**2/rwz*zmzzzbos-1d0/6*mw**2/rwz*rhw-8d0/3
     & *mw**2-4*mw**2*rwz)
     & -5d0/36-2d0/3/qs*mw**2+4/qs*mw**2*rwz-13d0/36/rwz-pizgfer+caldzfe
     & r-deltarhofer-za1fer-deltarhobos-za1bos+2*rwz-1d0/4*vpadn/rwz-1d0
     & /8*vpadn**2/rwz+3d0/8*vmael/rwz+1d0/4*vmael-3d0/8*vmael**2/rwz-1d
     & 0/4*qel/qs*mw**2/rwz+3d0/2*qel/qs*mw**2-1d0/4*qel+3d0/2*qel*rwz+1
     & d0/2*qel*vmael/qs*mw**2/rwz+1d0/2*qel*vmael

      ff_ew_lq =
     & +d0ccccqstszczc*dreal(propizqs)*pxx2zqsc**2*(-1d0/8/ctw**2*vmael*
     & vmadn**2/us-1d0/4/ctw**2*vmael*vmadn**2*ts/us**2)
     & +d0ccccqstszczc*dreal(propizqs)*pxx2zqsc*(-3d0/4/ctw**2*vmael*vma
     & dn**2*ts/us)
     & +d0ccccqstszczc*dreal(propizqs)*(-1d0/2/ctw**2*vmael*vmadn**2*mz*
     & *2+1d0/8/ctw**2*vmael*vmadn**2*us-1d0/2/ctw**2*vmael*vmadn**2*ts-
     & 1d0/8/ctw**2*vmael*vmadn**2*ts**2/us+1d0/2/ctw**2*vmael*vpadn**2*
     & ts)
     & +d0ccccqsuszczc*dreal(propizqs)*pxx2zqsc**2*(-1d0/4/ctw**2*vmael*
     & vpadn**2/ts**2*us-1d0/8/ctw**2*vmael*vpadn**2/ts)
     & +d0ccccqsuszczc*dreal(propizqs)*pxx2zqsc*(-3d0/4/ctw**2*vmael*vpa
     & dn**2/ts*us-1d0/4/ctw**2*vmael*vpadn**2)
     & +d0ccccqsuszczc*dreal(propizqs)*(1d0/2/ctw**2*vmael*vmadn**2*us-1
     & d0/8/ctw**2*vmael*vpadn**2/ts*us**2-3d0/4/ctw**2*vmael*vpadn**2*u
     & s-1d0/8/ctw**2*vmael*vpadn**2*ts)
     & +c0ccqswcw*(-2/qs**2*mw**6+4/qs*mw**4)
     & +c0ccqszcz*dreal(propizqs)*pxx2zqsc*(-1d0/2/ctw**2*vmael*vmadn**2
     & /us-1d0/2/ctw**2*vmael*vmadn**2*ts/us**2-1d0/2/ctw**2*vmael*vpadn
     & **2/ts**2*us-1d0/2/ctw**2*vmael*vpadn**2/ts)
     & +c0ccqszcz*dreal(propizqs)*(-1d0/ctw**2*vmael*vmadn**2-1d0/ctw**2
     & *vmael*vmadn**2*ts/us-1d0/ctw**2*vmael*vpadn**2/ts*us-1d0/ctw**2*
     & vmael*vpadn**2)
     & +c0ccqscwc*(vpaup/qs*mw**4-2*vpaup*mw**2+vpaup*qs-2*qup/qs**2*mw*
     & *6+4*qup/qs*mw**4-2*qup/qs*mw**4*rwz-2*qup*mw**2+4*qup*mw**2*rwz-
     & 2*qup*qs*rwz)
     & +c0ccqsczc*(-1d0/2/qs*mw**4/rwz**3+mw**2/rwz**2-1d0/2*qs/rwz-3d0/
     & 2*vpadn/qs*mw**4/rwz**3+3*vpadn*mw**2/rwz**2-3d0/2*vpadn*qs/rwz-3
     & d0/2*vpadn**2/qs*mw**4/rwz**3+3*vpadn**2*mw**2/rwz**2-3d0/2*vpadn
     & **2*qs/rwz-1d0/2*vmael**2/qs*mw**4/rwz**3+vmael**2*mw**2/rwz**2-1
     & d0/2*vmael**2*qs/rwz+qdn/qs**2*mw**6/rwz**3-qdn/qs*mw**4/rwz**2-q
     & dn*mw**2/rwz+qdn*qs+2*qdn*vpadn/qs**2*mw**6/rwz**3-2*qdn*vpadn/qs
     & *mw**4/rwz**2-2*qdn*vpadn*mw**2/rwz+2*qdn*vpadn*qs)
     & +c0cctsczc*dreal(propizqs)*pxx2zqsc*(1d0/2/ctw**2*vmael*vmadn**2*
     & ts/us**2)
     & +c0cctsczc*dreal(propizqs)*(1d0/ctw**2*vmael*vmadn**2*ts/us)
     & +c0ccusczc*dreal(propizqs)*pxx2zqsc*(1d0/2/ctw**2*vmael*vpadn**2/
     & ts**2*us)
     & +c0ccusczc*dreal(propizqs)*(1d0/ctw**2*vmael*vpadn**2/ts*us)
     & +a0fw*dreal(propzqs)*(3*mw**2/rwz/rhw+1d0/6*mw**2/rwz-8d0/3*mw**2
     & -4*mw**2*rwz)
     & +a0fw*(-2/qs**2*mw**4+7d0/3/qs*mw**2+4/qs*mw**2*rwz-vpaup/qs*mw**
     & 2+3d0/2*vpaup+2*qup/qs**2*mw**4-3*qup/qs*mw**2+2*qup/qs*mw**2*rwz
     & -3*qup*rwz)
     & +a0fz*dreal(propzqs)*(3d0/2*mw**2/rwz**3/rhw+1d0/6*mw**2/rwz**2-1
     & d0/12*mw**2/rwz*rhw)
     & +a0fz*(5d0/12/qs*mw**2/rwz**2+1d0/12/qs*mw**2/rwz*rhw-3d0/4/rwz+3
     & d0/2*vpadn/qs*mw**2/rwz**2-9d0/4*vpadn/rwz+3d0/2*vpadn**2/qs*mw**
     & 2/rwz**2-9d0/4*vpadn**2/rwz+1d0/2*vmael**2/qs*mw**2/rwz**2-3d0/4*
     & vmael**2/rwz-qdn/qs**2*mw**4/rwz**2+1d0/2*qdn/qs*mw**2/rwz+3d0/2*
     & qdn-2*qdn*vpadn/qs**2*mw**4/rwz**2+qdn*vpadn/qs*mw**2/rwz+3*qdn*v
     & padn)
     & +a0fh*dreal(propzqs)*(1d0/2*mw**2/rwz*rhw+1d0/12*mw**2*rhw**2)
     & +a0fh*(1d0/12/qs*mw**2/rwz*rhw-1d0/12/qs*mw**2*rhw**2)
     & +b0fqsww*dreal(propzqs)*(1d0/12*mw**2/rwz**2+4d0/3*mw**2/rwz-17d0
     & /3*mw**2-4*mw**2*rwz)
     & +b0fqsww*(1d0/6-2/qs**2*mw**4+7d0/3/qs*mw**2+4/qs*mw**2*rwz-1d0/1
     & 2/rwz)
     & +b0fqszz*dreal(propizqs)*(-1d0/2/ctw**2*vmael*vmadn**2/us-1d0/2/c
     & tw**2*vmael*vpadn**2/ts)
     & +b0fqszh*dreal(propzqs)*(mw**2/rwz**2-1d0/3*mw**2/rwz*rhw+1d0/12*
     & mw**2*rhw**2)
     & +b0fqszh*(-1d0/12/qs*mw**2/rwz**2+1d0/6/qs*mw**2/rwz*rhw-1d0/12/q
     & s*mw**2*rhw**2-1d0/12/rwz)
     & +b0fqscc*(1d0/2/qs*mw**2/rwz**2-3d0/4/rwz+3d0/2*vpadn/qs*mw**2/rw
     & z**2-9d0/4*vpadn/rwz+3d0/2*vpadn**2/qs*mw**2/rwz**2-9d0/4*vpadn**
     & 2/rwz-vpaup/qs*mw**2+3d0/2*vpaup+1d0/2*vmael**2/qs*mw**2/rwz**2-3
     & d0/4*vmael**2/rwz-qdn/qs**2*mw**4/rwz**2+1d0/2*qdn/qs*mw**2/rwz+3
     & d0/2*qdn-2*qdn*vpadn/qs**2*mw**4/rwz**2+qdn*vpadn/qs*mw**2/rwz+3*
     & qdn*vpadn+2*qup/qs**2*mw**4-3*qup/qs*mw**2+2*qup/qs*mw**2*rwz-3*q
     & up*rwz)
     & +b0ftscc*dreal(propizqs)*(1d0/2/ctw**2*vmael*vmadn**2/us)
     & +b0fuscc*dreal(propizqs)*(1d0/2/ctw**2*vmael*vpadn**2/ts)
     & +dreal(propzqs)*(mw**2/rwz**3/rhw-1d0/18*mw**2/rwz**2+2*mw**2/rwz
     & /rhw-5d0/9*mw**2/rwz-mw**2/rwz*zmzzzbos-1d0/6*mw**2/rwz*rhw-8d0/3
     & *mw**2-4*mw**2*rwz)
     & +1d0/9-2d0/3/qs*mw**2+4/qs*mw**2*rwz-17d0/72/rwz-pizgfer+caldzfer
     & -deltarhofer-za1fer-deltarhobos-za1bos-3d0/8*vpadn/rwz-3d0/4*vpad
     & n-3d0/8*vpadn**2/rwz+vpaup-1d0/8*vmael**2/rwz+1d0/4*qdn/qs*mw**2/
     & rwz+3d0/2*qdn/qs*mw**2+1d0/4*qdn+3d0/2*qdn*rwz+1d0/2*qdn*vpadn/qs
     & *mw**2/rwz+1d0/2*qdn*vpadn-2*qup/qs*mw**2-2*qup*rwz

      ff_ew_qq =
     & +d0ccccqstszczc*dreal(propizqs)*pxx2zqsc**2*(-1d0/8/ctw**2*vmael*
     & vmadn/us-1d0/4/ctw**2*vmael*vmadn*ts/us**2)
     & +d0ccccqstszczc*dreal(propizqs)*pxx2zqsc*(-3d0/4/ctw**2*vmael*vma
     & dn*ts/us)
     & +d0ccccqstszczc*dreal(propizqs)*(-1d0/2/ctw**2*vmael*vmadn*mz**2+
     & 1d0/8/ctw**2*vmael*vmadn*us-1d0/2/ctw**2*vmael*vmadn*ts-1d0/8/ctw
     & **2*vmael*vmadn*ts**2/us)
     & +d0ccccqsuszczc*dreal(propizqs)*(1d0/2/ctw**2*vmael*vmadn*us)
     & +c0ccqszcz*dreal(propizqs)*pxx2zqsc*(-1d0/2/ctw**2*vmael*vmadn/us
     & -1d0/2/ctw**2*vmael*vmadn*ts/us**2)
     & +c0ccqszcz*dreal(propizqs)*(-1d0/ctw**2*vmael*vmadn-1d0/ctw**2*vm
     & ael*vmadn*ts/us)
     & +c0ccqsczc*(-1d0/2/stw**2/qs**2*mw**6+1d0/2/stw**2/qs*mw**4+1d0/2
     & /stw**2*mw**2-1d0/2/stw**2*qs-1d0/stw**2*vpadn/qs**2*mw**6+1d0/st
     & w**2*vpadn/qs*mw**4+1d0/stw**2*vpadn*mw**2-1d0/stw**2*vpadn*qs-1d
     & 0/2/stw**2*vpadn**2/qs**2*mw**6+1d0/2/stw**2*vpadn**2/qs*mw**4+1d
     & 0/2/stw**2*vpadn**2*mw**2-1d0/2/stw**2*vpadn**2*qs-1d0/2/qs**2*mw
     & **6/rwz**3-1d0/2/qs**2*mw**6/rwz**2-1d0/2/qs**2*mw**6/rwz-1d0/2/q
     & s*mw**4/rwz**3+1d0/2/qs*mw**4/rwz**2+1d0/2/qs*mw**4/rwz+mw**2/rwz
     & **2+1d0/2*mw**2/rwz-1d0/2*qs/rwz-vpadn/qs**2*mw**6/rwz**3-vpadn/q
     & s**2*mw**6/rwz**2-vpadn/qs**2*mw**6/rwz-vpadn/qs*mw**4/rwz**3+vpa
     & dn/qs*mw**4/rwz**2+vpadn/qs*mw**4/rwz+2*vpadn*mw**2/rwz**2+vpadn*
     & mw**2/rwz-vpadn*qs/rwz-1d0/2*vpadn**2/qs**2*mw**6/rwz**3-1d0/2*vp
     & adn**2/qs**2*mw**6/rwz**2-1d0/2*vpadn**2/qs**2*mw**6/rwz-1d0/2*vp
     & adn**2/qs*mw**4/rwz**3+1d0/2*vpadn**2/qs*mw**4/rwz**2+1d0/2*vpadn
     & **2/qs*mw**4/rwz+vpadn**2*mw**2/rwz**2+1d0/2*vpadn**2*mw**2/rwz-1
     & d0/2*vpadn**2*qs/rwz-1d0/2*vmael**2/qs*mw**4/rwz**3+vmael**2*mw**
     & 2/rwz**2-1d0/2*vmael**2*qs/rwz+qel*vmael/qs**2*mw**6/rwz**3-qel*v
     & mael/qs*mw**4/rwz**2-qel*vmael*mw**2/rwz+qel*vmael*qs)
     & +c0cctsczc*dreal(propizqs)*pxx2zqsc*(1d0/2/ctw**2*vmael*vmadn*ts/
     & us**2)
     & +c0cctsczc*dreal(propizqs)*(1d0/ctw**2*vmael*vmadn*ts/us)
     & +a0fw*dreal(propzqs)*(3*mw**2/rwz/rhw+1d0/6*mw**2/rwz-8d0/3*mw**2
     & -4*mw**2*rwz)
     & +a0fw*(-4/qs**2*mw**4+8d0/3/qs*mw**2+4/qs*mw**2*rwz)
     & +a0fz*dreal(propzqs)*(3d0/2*mw**2/rwz**3/rhw+1d0/6*mw**2/rwz**2-1
     & d0/12*mw**2/rwz*rhw)
     & +a0fz*(1d0/2/stw**2/qs**2*mw**4-1d0/4/stw**2/qs*mw**2-3d0/4/stw**
     & 2+1d0/stw**2*vpadn/qs**2*mw**4-1d0/2/stw**2*vpadn/qs*mw**2-3d0/2/
     & stw**2*vpadn+1d0/2/stw**2*vpadn**2/qs**2*mw**4-1d0/4/stw**2*vpadn
     & **2/qs*mw**2-3d0/4/stw**2*vpadn**2+1d0/2/qs**2*mw**4/rwz**2+1d0/2
     & /qs**2*mw**4/rwz+5d0/12/qs*mw**2/rwz**2-1d0/4/qs*mw**2/rwz+1d0/12
     & /qs*mw**2/rwz*rhw-3d0/4/rwz+vpadn/qs**2*mw**4/rwz**2+vpadn/qs**2*
     & mw**4/rwz+vpadn/qs*mw**2/rwz**2-1d0/2*vpadn/qs*mw**2/rwz-3d0/2*vp
     & adn/rwz+1d0/2*vpadn**2/qs**2*mw**4/rwz**2+1d0/2*vpadn**2/qs**2*mw
     & **4/rwz+1d0/2*vpadn**2/qs*mw**2/rwz**2-1d0/4*vpadn**2/qs*mw**2/rw
     & z-3d0/4*vpadn**2/rwz+1d0/2*vmael**2/qs*mw**2/rwz**2-3d0/4*vmael**
     & 2/rwz-qel*vmael/qs**2*mw**4/rwz**2+1d0/2*qel*vmael/qs*mw**2/rwz+3
     & d0/2*qel*vmael)
     & +a0fh*dreal(propzqs)*(1d0/2*mw**2/rwz*rhw+1d0/12*mw**2*rhw**2)
     & +a0fh*(1d0/12/qs*mw**2/rwz*rhw-1d0/12/qs*mw**2*rhw**2)
     & +b0fqsww*dreal(propzqs)*(1d0/12*mw**2/rwz**2+4d0/3*mw**2/rwz-17d0
     & /3*mw**2-4*mw**2*rwz)
     & +b0fqsww*(-4/qs**2*mw**4+17d0/3/qs*mw**2+4/qs*mw**2*rwz-1d0/12/rw
     & z)
     & +b0fqszz*dreal(propizqs)*(-1d0/2/ctw**2*vmael*vmadn/us)
     & +b0fqszh*dreal(propzqs)*(mw**2/rwz**2-1d0/3*mw**2/rwz*rhw+1d0/12*
     & mw**2*rhw**2)
     & +b0fqszh*(-1d0/12/qs*mw**2/rwz**2+1d0/6/qs*mw**2/rwz*rhw-1d0/12/q
     & s*mw**2*rhw**2-1d0/12/rwz)
     & +b0fqscc*(1d0/2/stw**2/qs**2*mw**4-1d0/4/stw**2/qs*mw**2-3d0/4/st
     & w**2+1d0/stw**2*vpadn/qs**2*mw**4-1d0/2/stw**2*vpadn/qs*mw**2-3d0
     & /2/stw**2*vpadn+1d0/2/stw**2*vpadn**2/qs**2*mw**4-1d0/4/stw**2*vp
     & adn**2/qs*mw**2-3d0/4/stw**2*vpadn**2+1d0/2/qs**2*mw**4/rwz**2+1d
     & 0/2/qs**2*mw**4/rwz+1d0/2/qs*mw**2/rwz**2-1d0/4/qs*mw**2/rwz-3d0/
     & 4/rwz+vpadn/qs**2*mw**4/rwz**2+vpadn/qs**2*mw**4/rwz+vpadn/qs*mw*
     & *2/rwz**2-1d0/2*vpadn/qs*mw**2/rwz-3d0/2*vpadn/rwz+1d0/2*vpadn**2
     & /qs**2*mw**4/rwz**2+1d0/2*vpadn**2/qs**2*mw**4/rwz+1d0/2*vpadn**2
     & /qs*mw**2/rwz**2-1d0/4*vpadn**2/qs*mw**2/rwz-3d0/4*vpadn**2/rwz+1
     & d0/2*vmael**2/qs*mw**2/rwz**2-3d0/4*vmael**2/rwz-qel*vmael/qs**2*
     & mw**4/rwz**2+1d0/2*qel*vmael/qs*mw**2/rwz+3d0/2*qel*vmael)
     & +b0ftscc*dreal(propizqs)*(1d0/2/ctw**2*vmael*vmadn/us)
     & +dreal(propzqs)*(mw**2/rwz**3/rhw-1d0/18*mw**2/rwz**2+2*mw**2/rwz
     & /rhw-5d0/9*mw**2/rwz-mw**2/rwz*zmzzzbos-1d0/6*mw**2/rwz*rhw-8d0/3
     & *mw**2-4*mw**2*rwz)
     & -1d0/8/stw**2/qs*mw**2-1d0/stw**2/qs*mw**2*za1bos-1d0/8/stw**2-1d
     & 0/stw**2*deltarhofer-1d0/stw**2*deltarhobos-1d0/stw**2*za1bos-1d0
     & /4/stw**2*vpadn/qs*mw**2-1d0/4/stw**2*vpadn-1d0/8/stw**2*vpadn**2
     & /qs*mw**2-1d0/8/stw**2*vpadn**2-4/qs**2*mw**4-1d0/8/qs*mw**2/rwz+
     & 8d0/3/qs*mw**2+4/qs*mw**2*rwz-17d0/72/rwz-2*pizgfer+caldzfer-za1f
     & er-1d0/4*vpadn/qs*mw**2/rwz-1d0/4*vpadn/rwz-1d0/8*vpadn**2/qs*mw*
     & *2/rwz-1d0/8*vpadn**2/rwz-1d0/8*vmael**2/rwz+1d0/4*qel*vmael/qs*m
     & w**2/rwz+1d0/4*qel*vmael

      ff_ew_ld =
     & 0

      ff_ew_qd =
     & 0

      ffarray(1,1) = ff_qed_ll
      ffarray(1,2) = ff_ew_ll
      ffarray(1,3) = ff_qed_lq
      ffarray(1,4) = ff_ew_lq
      ffarray(1,5) = ff_qed_ql
      ffarray(1,6) = ff_ew_ql
      ffarray(1,7) = ff_qed_qq
      ffarray(1,8) = ff_ew_qq
      ffarray(1,9) = ff_qed_ld
      ffarray(1,10) = ff_ew_ld
      ffarray(1,11) = ff_qed_qd
      ffarray(1,12) = ff_ew_qd
      ffarray(1,13) = ff_qed_gg

      return
      end
