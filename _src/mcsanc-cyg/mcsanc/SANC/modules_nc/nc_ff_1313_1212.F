************************************************************************
* sanc_nc_v1.30 package.
************************************************************************
* File (nc_ff_1313_1212.F) is created on Wed Apr 18 13:08:00 MSK 2012.
************************************************************************
* This is the FORTRAN module (nc_ff_1313_1212) to calculate 1-loop EW
* form factors for the anti-up + up -> el^+ + el^- process.
*
* It is produced by s2n package of SANC (v1.10) Project.
* Copyright (C), SANC Project Team, 2002-2012.
*
* http://sanc.jinr.ru/
* http://pcphsanc.cern.ch/
* E-mail: <sanc@jinr.ru>
************************************************************************
      subroutine nc_ff_1313_1212 (qs,ts,us)
      implicit none!
#include "s2n_declare.h"

      complex*16 ff_qed_ll,ff_qed_lq,ff_qed_ql,ff_qed_qq,ff_qed_ld
      complex*16 ff_qed_qd,ff_ew_ll,ff_ew_ld,ff_ew_lq,ff_ew_ql,ff_ew_qq
      complex*16 ff_ew_qd,ff_qed_gg
      real*8 isr,ifi,fsr

      real*8 a0fel,a0fup,a0fw,a0fz,a0fh
      real*8 lnlaupm,lnlaelm
      complex*16 b0fqszc,b0fqscc,b0ftscc,b0fuscc,b0fqsww,b0fqszz,b0fqsz
     & h
      complex*16 c0upupqszupc,c0irupupqs,c0upupqscupc,c0irupelts,c0irup
     & elus,c0elelqszelc,c0irelelqs,c0elelqscelc,c0celtsczel,c0celusczel
     & ,c0irelupts,c0irelupus,c0ccqswcw,c0ccqszcz,c0ccqscwc,c0ccqsczc,c0
     & cctsczc,c0ccusczc
      complex*16 d0ccccqsuswcwc,d0ccccqstszczc,d0ccccqsuszczc
      complex*16 jaaqstsupel,jaaqsusupel,javqstsupelz,javqsusupelz
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
      a0fup = log(rupm2/thmu2) - 1d0
      a0fw = log(rwm2/thmu2) - 1d0
      a0fz = log(rzm2/thmu2) - 1d0
      a0fh = log(rhm2/thmu2) - 1d0
      lnlaupm = log(rupm2/tlmu2)
      lnlaelm = log(relm2/tlmu2)
      b0fqszc = b0f(qs,thmu2,zm2,cm2)
      b0fqscc = b0f(qs,thmu2,cm2,cm2)
      b0ftscc = b0f(ts,thmu2,cm2,cm2)
      b0fuscc = b0f(us,thmu2,cm2,cm2)
      b0fqsww = b0f(qs,thmu2,wm2,wm2)
      b0fqszz = b0f(qs,thmu2,zm2,zm2)
      b0fqszh = b0f(qs,thmu2,zm2,hm2)
      c0upupqszupc = c01(-rupm2,-rupm2,qs,zm2,upm2,cm2)
      c0irupupqs = c0ir(tlmu2,upm2,upm2,qs)
      c0upupqscupc = c01(-rupm2,-rupm2,qs,cm2,upm2,cm2)
      c0irupelts = c0ir(tlmu2,upm2,elm2,ts)
      c0irupelus = c0ir(tlmu2,upm2,elm2,us)
      c0elelqszelc = c01(-relm2,-relm2,qs,zm2,elm2,cm2)
      c0irelelqs = c0ir(tlmu2,elm2,elm2,qs)
      c0elelqscelc = c01(-relm2,-relm2,qs,cm2,elm2,cm2)
      c0celtsczel = c01(0d0,-relm2,ts,cm2,zm2,elm2)
      c0celusczel = c01(0d0,-relm2,us,cm2,zm2,elm2)
      c0irelupts = c0ir(tlmu2,elm2,upm2,ts)
      c0irelupus = c0ir(tlmu2,elm2,upm2,us)
      c0ccqswcw = c01(0d0,0d0,qs,wm2,cm2,wm2)
      c0ccqszcz = c01(0d0,0d0,qs,zm2,cm2,zm2)
      c0ccqscwc = c01(0d0,0d0,qs,cm2,wm2,cm2)
      c0ccqsczc = c01(0d0,0d0,qs,cm2,zm2,cm2)
      c0cctsczc = c01(0d0,0d0,ts,cm2,zm2,cm2)
      c0ccusczc = c01(0d0,0d0,us,cm2,zm2,cm2)
      d0ccccqsuswcwc = d040(qs,us,wm2,cm2)
      d0ccccqstszczc = d040(qs,ts,zm2,cm2)
      d0ccccqsuszczc = d040(qs,us,zm2,cm2)
      jaaqstsupel = jaa(qs,ts,upm2,elm2)
      jaaqsusupel = jaa(qs,us,upm2,elm2)
      javqstsupelz = jav(qs,ts,upm2,elm2,cmz2)
      javqsusupelz = jav(qs,us,upm2,elm2,cmz2)
      pxx2zqsc = (2*mz**2)+(qs)

      ff_qed_gg =
     & -za1fer+stw**2*piggfer

      ff_qed_ll =
     & +fsr*(-stw**2*qel**2)
     & +isr*(-stw**2*qup**2)
     & +jaaqstsupel*dreal(propizqs)*ifi*cfscheme*(-8*stw**4*ctw**2*qel**
     & 2*qup**2*ts/us+8*stw**4*ctw**2*qel**2*qup**2*ts**2/us**2)
     & +jaaqsusupel*dreal(propizqs)*ifi*cfscheme*(8*stw**4*ctw**2*qel**2
     & *qup**2/ts**2*us**2-8*stw**4*ctw**2*qel**2*qup**2/ts*us)
     & +javqstsupelz*ifi*(-4*stw**2*qel*qup*vmael*vmaup*ts+4*stw**2*qel*
     & qup*vmael*vpaup*ts+4*stw**2*qel*qup*vpael*vmaup*ts-4*stw**2*qel*q
     & up*vpael*vpaup*ts)
     & +javqstsupelz*dreal(propizqs)*ifi*(-2*stw**2*qel*qup*vmael*vmaup*
     & ts/us**2*mz**2-2*stw**2*qel*qup*vmael*vmaup*ts/us+2*stw**2*qel*qu
     & p*vmael*vmaup*ts**2/us**2-2*stw**2*qel*qup*vpael*vpaup*ts/us**2*m
     & z**2-2*stw**2*qel*qup*vpael*vpaup*ts/us+2*stw**2*qel*qup*vpael*vp
     & aup*ts**2/us**2)
     & +javqsusupelz*ifi*(4*stw**2*qel*qup*vmael*vmaup*us-4*stw**2*qel*q
     & up*vmael*vpaup*us-4*stw**2*qel*qup*vpael*vmaup*us+4*stw**2*qel*qu
     & p*vpael*vpaup*us)
     & +javqsusupelz*dreal(propizqs)*ifi*(-2*stw**2*qel*qup*vmael*vpaup/
     & ts**2*us*mz**2+2*stw**2*qel*qup*vmael*vpaup/ts**2*us**2-2*stw**2*
     & qel*qup*vmael*vpaup/ts*us-2*stw**2*qel*qup*vpael*vmaup/ts**2*us*m
     & z**2+2*stw**2*qel*qup*vpael*vmaup/ts**2*us**2-2*stw**2*qel*qup*vp
     & ael*vmaup/ts*us)
     & +c0upupqszupc*dreal(propizqs)*ifi*(2*stw**2*qel*qup*vmael*vmaup/u
     & s*mz**2+2*stw**2*qel*qup*vmael*vmaup+2*stw**2*qel*qup*vmael*vmaup
     & *ts/us**2*mz**2-2*stw**2*qel*qup*vmael*vmaup*ts**2/us**2+2*stw**2
     & *qel*qup*vmael*vpaup/ts**2*us*mz**2-2*stw**2*qel*qup*vmael*vpaup/
     & ts**2*us**2+2*stw**2*qel*qup*vmael*vpaup/ts*mz**2+2*stw**2*qel*qu
     & p*vmael*vpaup+2*stw**2*qel*qup*vpael*vmaup/ts**2*us*mz**2-2*stw**
     & 2*qel*qup*vpael*vmaup/ts**2*us**2+2*stw**2*qel*qup*vpael*vmaup/ts
     & *mz**2+2*stw**2*qel*qup*vpael*vmaup+2*stw**2*qel*qup*vpael*vpaup/
     & us*mz**2+2*stw**2*qel*qup*vpael*vpaup+2*stw**2*qel*qup*vpael*vpau
     & p*ts/us**2*mz**2-2*stw**2*qel*qup*vpael*vpaup*ts**2/us**2)
     & +c0irupupqs*isr*(-2*stw**2*qup**2*qs)
     & +c0upupqscupc*dreal(propizqs)*ifi*cfscheme*(-8*stw**4*ctw**2*qel*
     & *2*qup**2/ts**2*us**2+16*stw**4*ctw**2*qel**2*qup**2-8*stw**4*ctw
     & **2*qel**2*qup**2*ts**2/us**2)
     & +c0irupelts*ifi*(4*stw**2*qel*qup*vmael*vmaup*ts-4*stw**2*qel*qup
     & *vmael*vpaup*ts-4*stw**2*qel*qup*vpael*vmaup*ts+4*stw**2*qel*qup*
     & vpael*vpaup*ts)
     & +c0irupelus*ifi*(-4*stw**2*qel*qup*vmael*vmaup*us+4*stw**2*qel*qu
     & p*vmael*vpaup*us+4*stw**2*qel*qup*vpael*vmaup*us-4*stw**2*qel*qup
     & *vpael*vpaup*us)
     & +c0elelqszelc*dreal(propizqs)*ifi*(2*stw**2*qel*qup*vmael*vmaup/u
     & s*mz**2+2*stw**2*qel*qup*vmael*vmaup+2*stw**2*qel*qup*vmael*vmaup
     & *ts/us**2*mz**2-2*stw**2*qel*qup*vmael*vmaup*ts**2/us**2+2*stw**2
     & *qel*qup*vmael*vpaup/ts**2*us*mz**2-2*stw**2*qel*qup*vmael*vpaup/
     & ts**2*us**2+2*stw**2*qel*qup*vmael*vpaup/ts*mz**2+2*stw**2*qel*qu
     & p*vmael*vpaup+2*stw**2*qel*qup*vpael*vmaup/ts**2*us*mz**2-2*stw**
     & 2*qel*qup*vpael*vmaup/ts**2*us**2+2*stw**2*qel*qup*vpael*vmaup/ts
     & *mz**2+2*stw**2*qel*qup*vpael*vmaup+2*stw**2*qel*qup*vpael*vpaup/
     & us*mz**2+2*stw**2*qel*qup*vpael*vpaup+2*stw**2*qel*qup*vpael*vpau
     & p*ts/us**2*mz**2-2*stw**2*qel*qup*vpael*vpaup*ts**2/us**2)
     & +c0irelelqs*fsr*(-2*stw**2*qel**2*qs)
     & +c0elelqscelc*dreal(propizqs)*ifi*cfscheme*(-8*stw**4*ctw**2*qel*
     & *2*qup**2/ts**2*us**2+16*stw**4*ctw**2*qel**2*qup**2-8*stw**4*ctw
     & **2*qel**2*qup**2*ts**2/us**2)
     & +c0celtsczel*ifi*(-4*stw**2*qel*qup*vmael*vmaup*ts+4*stw**2*qel*q
     & up*vmael*vpaup*ts+4*stw**2*qel*qup*vpael*vmaup*ts-4*stw**2*qel*qu
     & p*vpael*vpaup*ts)
     & +c0celtsczel*dreal(propizqs)*ifi*(-4*stw**2*qel*qup*vmael*vmaup*t
     & s/us**2*mz**2-4*stw**2*qel*qup*vmael*vmaup*ts/us+4*stw**2*qel*qup
     & *vmael*vmaup*ts**2/us**2-4*stw**2*qel*qup*vpael*vpaup*ts/us**2*mz
     & **2-4*stw**2*qel*qup*vpael*vpaup*ts/us+4*stw**2*qel*qup*vpael*vpa
     & up*ts**2/us**2)
     & +c0celusczel*ifi*(4*stw**2*qel*qup*vmael*vmaup*us-4*stw**2*qel*qu
     & p*vmael*vpaup*us-4*stw**2*qel*qup*vpael*vmaup*us+4*stw**2*qel*qup
     & *vpael*vpaup*us)
     & +c0celusczel*dreal(propizqs)*ifi*(-4*stw**2*qel*qup*vmael*vpaup/t
     & s**2*us*mz**2+4*stw**2*qel*qup*vmael*vpaup/ts**2*us**2-4*stw**2*q
     & el*qup*vmael*vpaup/ts*us-4*stw**2*qel*qup*vpael*vmaup/ts**2*us*mz
     & **2+4*stw**2*qel*qup*vpael*vmaup/ts**2*us**2-4*stw**2*qel*qup*vpa
     & el*vmaup/ts*us)
     & +a0fel*fsr*(-3*stw**2*qel**2)
     & +a0fup*isr*(-3*stw**2*qup**2)
     & +b0fqszc*dreal(propizqs)*ifi*(4*stw**2*qel*qup*vmael*vmaup/us+4*s
     & tw**2*qel*qup*vmael*vpaup/ts+4*stw**2*qel*qup*vpael*vmaup/ts+4*st
     & w**2*qel*qup*vpael*vpaup/us)
     & +b0fqscc*fsr*(-3*stw**2*qel**2)
     & +b0fqscc*isr*(-3*stw**2*qup**2)
     & +b0fqscc*dreal(propizqs)*ifi*cfscheme*(16*stw**4*ctw**2*qel**2*qu
     & p**2/ts+16*stw**4*ctw**2*qel**2*qup**2/us)
     & +b0ftscc*dreal(propizqs)*ifi*(-4*stw**2*qel*qup*vmael*vmaup/us-4*
     & stw**2*qel*qup*vpael*vpaup/us)
     & +b0ftscc*dreal(propizqs)*ifi*cfscheme*(-16*stw**4*ctw**2*qel**2*q
     & up**2/us)
     & +b0fuscc*dreal(propizqs)*ifi*(-4*stw**2*qel*qup*vmael*vpaup/ts-4*
     & stw**2*qel*qup*vpael*vmaup/ts)
     & +b0fuscc*dreal(propizqs)*ifi*cfscheme*(-16*stw**4*ctw**2*qel**2*q
     & up**2/ts)
     & +lnlaupm*isr*(2*stw**2*qup**2)
     & +lnlaelm*fsr*(2*stw**2*qel**2)

      ff_qed_ql =
     & +fsr*(-stw**2*qel**2)
     & +isr*(-stw**2*qup**2)
     & +jaaqstsupel*dreal(propizqs)*ifi*cfscheme*(-2*stw**2*ctw**2*qel**
     & 2*qup*ts/us+2*stw**2*ctw**2*qel**2*qup*ts**2/us**2)
     & +jaaqsusupel*dreal(propizqs)*ifi*cfscheme*(2*stw**2*ctw**2*qel**2
     & *qup/ts**2*us**2-2*stw**2*ctw**2*qel**2*qup/ts*us)
     & +javqstsupelz*ifi*(4*stw**2*qel*qup*vmael*ts-4*stw**2*qel*qup*vpa
     & el*ts)
     & +javqstsupelz*dreal(propizqs)*ifi*(2*stw**2*qel*qup*vmael*ts/us**
     & 2*mz**2+2*stw**2*qel*qup*vmael*ts/us-2*stw**2*qel*qup*vmael*ts**2
     & /us**2)
     & +javqsusupelz*ifi*(-4*stw**2*qel*qup*vmael*us+4*stw**2*qel*qup*vp
     & ael*us)
     & +javqsusupelz*dreal(propizqs)*ifi*(2*stw**2*qel*qup*vpael/ts**2*u
     & s*mz**2-2*stw**2*qel*qup*vpael/ts**2*us**2+2*stw**2*qel*qup*vpael
     & /ts*us)
     & +c0upupqszupc*dreal(propizqs)*ifi*(-2*stw**2*qel*qup*vmael/us*mz*
     & *2-2*stw**2*qel*qup*vmael-2*stw**2*qel*qup*vmael*ts/us**2*mz**2+2
     & *stw**2*qel*qup*vmael*ts**2/us**2-2*stw**2*qel*qup*vpael/ts**2*us
     & *mz**2+2*stw**2*qel*qup*vpael/ts**2*us**2-2*stw**2*qel*qup*vpael/
     & ts*mz**2-2*stw**2*qel*qup*vpael)
     & +c0irupupqs*isr*(-2*stw**2*qup**2*qs)
     & +c0upupqscupc*dreal(propizqs)*ifi*cfscheme*(-2*stw**2*ctw**2*qel*
     & *2*qup/ts**2*us**2+4*stw**2*ctw**2*qel**2*qup-2*stw**2*ctw**2*qel
     & **2*qup*ts**2/us**2)
     & +c0irupelts*ifi*(-4*stw**2*qel*qup*vmael*ts+4*stw**2*qel*qup*vpae
     & l*ts)
     & +c0irupelus*ifi*(4*stw**2*qel*qup*vmael*us-4*stw**2*qel*qup*vpael
     & *us)
     & +c0elelqszelc*dreal(propizqs)*ifi*(-2*stw**2*qel*qup*vmael/us*mz*
     & *2-2*stw**2*qel*qup*vmael-2*stw**2*qel*qup*vmael*ts/us**2*mz**2+2
     & *stw**2*qel*qup*vmael*ts**2/us**2-2*stw**2*qel*qup*vpael/ts**2*us
     & *mz**2+2*stw**2*qel*qup*vpael/ts**2*us**2-2*stw**2*qel*qup*vpael/
     & ts*mz**2-2*stw**2*qel*qup*vpael)
     & +c0irelelqs*fsr*(-2*stw**2*qel**2*qs)
     & +c0elelqscelc*dreal(propizqs)*ifi*cfscheme*(-2*stw**2*ctw**2*qel*
     & *2*qup/ts**2*us**2+4*stw**2*ctw**2*qel**2*qup-2*stw**2*ctw**2*qel
     & **2*qup*ts**2/us**2)
     & +c0celtsczel*ifi*(4*stw**2*qel*qup*vmael*ts-4*stw**2*qel*qup*vpae
     & l*ts)
     & +c0celtsczel*dreal(propizqs)*ifi*(4*stw**2*qel*qup*vmael*ts/us**2
     & *mz**2+4*stw**2*qel*qup*vmael*ts/us-4*stw**2*qel*qup*vmael*ts**2/
     & us**2)
     & +c0celusczel*ifi*(-4*stw**2*qel*qup*vmael*us+4*stw**2*qel*qup*vpa
     & el*us)
     & +c0celusczel*dreal(propizqs)*ifi*(4*stw**2*qel*qup*vpael/ts**2*us
     & *mz**2-4*stw**2*qel*qup*vpael/ts**2*us**2+4*stw**2*qel*qup*vpael/
     & ts*us)
     & +a0fel*fsr*(-3*stw**2*qel**2)
     & +a0fup*isr*(-3*stw**2*qup**2)
     & +b0fqszc*dreal(propizqs)*ifi*(-4*stw**2*qel*qup*vmael/us-4*stw**2
     & *qel*qup*vpael/ts)
     & +b0fqscc*fsr*(-3*stw**2*qel**2)
     & +b0fqscc*isr*(-3*stw**2*qup**2)
     & +b0fqscc*dreal(propizqs)*ifi*cfscheme*(4*stw**2*ctw**2*qel**2*qup
     & /ts+4*stw**2*ctw**2*qel**2*qup/us)
     & +b0ftscc*dreal(propizqs)*ifi*(4*stw**2*qel*qup*vmael/us)
     & +b0ftscc*dreal(propizqs)*ifi*cfscheme*(-4*stw**2*ctw**2*qel**2*qu
     & p/us)
     & +b0fuscc*dreal(propizqs)*ifi*(4*stw**2*qel*qup*vpael/ts)
     & +b0fuscc*dreal(propizqs)*ifi*cfscheme*(-4*stw**2*ctw**2*qel**2*qu
     & p/ts)
     & +lnlaupm*isr*(2*stw**2*qup**2)
     & +lnlaelm*fsr*(2*stw**2*qel**2)

      ff_qed_lq =
     & +fsr*(-stw**2*qel**2)
     & +isr*(-stw**2*qup**2)
     & +jaaqstsupel*dreal(propizqs)*ifi*cfscheme*(2*stw**2*ctw**2*qel*qu
     & p**2*ts/us-2*stw**2*ctw**2*qel*qup**2*ts**2/us**2)
     & +jaaqsusupel*dreal(propizqs)*ifi*cfscheme*(-2*stw**2*ctw**2*qel*q
     & up**2/ts**2*us**2+2*stw**2*ctw**2*qel*qup**2/ts*us)
     & +javqstsupelz*ifi*(-4*stw**2*qel*qup*vmaup*ts+4*stw**2*qel*qup*vp
     & aup*ts)
     & +javqstsupelz*dreal(propizqs)*ifi*(-2*stw**2*qel*qup*vmaup*ts/us*
     & *2*mz**2-2*stw**2*qel*qup*vmaup*ts/us+2*stw**2*qel*qup*vmaup*ts**
     & 2/us**2)
     & +javqsusupelz*ifi*(4*stw**2*qel*qup*vmaup*us-4*stw**2*qel*qup*vpa
     & up*us)
     & +javqsusupelz*dreal(propizqs)*ifi*(-2*stw**2*qel*qup*vpaup/ts**2*
     & us*mz**2+2*stw**2*qel*qup*vpaup/ts**2*us**2-2*stw**2*qel*qup*vpau
     & p/ts*us)
     & +c0upupqszupc*dreal(propizqs)*ifi*(2*stw**2*qel*qup*vmaup/us*mz**
     & 2+2*stw**2*qel*qup*vmaup+2*stw**2*qel*qup*vmaup*ts/us**2*mz**2-2*
     & stw**2*qel*qup*vmaup*ts**2/us**2+2*stw**2*qel*qup*vpaup/ts**2*us*
     & mz**2-2*stw**2*qel*qup*vpaup/ts**2*us**2+2*stw**2*qel*qup*vpaup/t
     & s*mz**2+2*stw**2*qel*qup*vpaup)
     & +c0irupupqs*isr*(-2*stw**2*qup**2*qs)
     & +c0upupqscupc*dreal(propizqs)*ifi*cfscheme*(2*stw**2*ctw**2*qel*q
     & up**2/ts**2*us**2-4*stw**2*ctw**2*qel*qup**2+2*stw**2*ctw**2*qel*
     & qup**2*ts**2/us**2)
     & +c0irupelts*ifi*(4*stw**2*qel*qup*vmaup*ts-4*stw**2*qel*qup*vpaup
     & *ts)
     & +c0irupelus*ifi*(-4*stw**2*qel*qup*vmaup*us+4*stw**2*qel*qup*vpau
     & p*us)
     & +c0elelqszelc*dreal(propizqs)*ifi*(2*stw**2*qel*qup*vmaup/us*mz**
     & 2+2*stw**2*qel*qup*vmaup+2*stw**2*qel*qup*vmaup*ts/us**2*mz**2-2*
     & stw**2*qel*qup*vmaup*ts**2/us**2+2*stw**2*qel*qup*vpaup/ts**2*us*
     & mz**2-2*stw**2*qel*qup*vpaup/ts**2*us**2+2*stw**2*qel*qup*vpaup/t
     & s*mz**2+2*stw**2*qel*qup*vpaup)
     & +c0irelelqs*fsr*(-2*stw**2*qel**2*qs)
     & +c0elelqscelc*dreal(propizqs)*ifi*cfscheme*(2*stw**2*ctw**2*qel*q
     & up**2/ts**2*us**2-4*stw**2*ctw**2*qel*qup**2+2*stw**2*ctw**2*qel*
     & qup**2*ts**2/us**2)
     & +c0celtsczel*ifi*(-4*stw**2*qel*qup*vmaup*ts+4*stw**2*qel*qup*vpa
     & up*ts)
     & +c0celtsczel*dreal(propizqs)*ifi*(-4*stw**2*qel*qup*vmaup*ts/us**
     & 2*mz**2-4*stw**2*qel*qup*vmaup*ts/us+4*stw**2*qel*qup*vmaup*ts**2
     & /us**2)
     & +c0celusczel*ifi*(4*stw**2*qel*qup*vmaup*us-4*stw**2*qel*qup*vpau
     & p*us)
     & +c0celusczel*dreal(propizqs)*ifi*(-4*stw**2*qel*qup*vpaup/ts**2*u
     & s*mz**2+4*stw**2*qel*qup*vpaup/ts**2*us**2-4*stw**2*qel*qup*vpaup
     & /ts*us)
     & +a0fel*fsr*(-3*stw**2*qel**2)
     & +a0fup*isr*(-3*stw**2*qup**2)
     & +b0fqszc*dreal(propizqs)*ifi*(4*stw**2*qel*qup*vmaup/us+4*stw**2*
     & qel*qup*vpaup/ts)
     & +b0fqscc*fsr*(-3*stw**2*qel**2)
     & +b0fqscc*isr*(-3*stw**2*qup**2)
     & +b0fqscc*dreal(propizqs)*ifi*cfscheme*(-4*stw**2*ctw**2*qel*qup**
     & 2/ts-4*stw**2*ctw**2*qel*qup**2/us)
     & +b0ftscc*dreal(propizqs)*ifi*(-4*stw**2*qel*qup*vmaup/us)
     & +b0ftscc*dreal(propizqs)*ifi*cfscheme*(4*stw**2*ctw**2*qel*qup**2
     & /us)
     & +b0fuscc*dreal(propizqs)*ifi*(-4*stw**2*qel*qup*vpaup/ts)
     & +b0fuscc*dreal(propizqs)*ifi*cfscheme*(4*stw**2*ctw**2*qel*qup**2
     & /ts)
     & +lnlaupm*isr*(2*stw**2*qup**2)
     & +lnlaelm*fsr*(2*stw**2*qel**2)

      ff_qed_qq =
     & +fsr*(-stw**2*qel**2)
     & +isr*(-stw**2*qup**2)
     & +prop1zqs*c0irupupqs*isr*cfscheme*(-2*qup**2+2*stw**2*qup**2)
     & +prop1zqs*c0irelupts*ifi*cfscheme*(-4*ctw**2*qel*qup/qs*ts)
     & +prop1zqs*c0irelupus*ifi*cfscheme*(4*ctw**2*qel*qup/qs*us)
     & +prop1zqs*c0irelelqs*fsr*cfscheme*(-2*qel**2+2*stw**2*qel**2)
     & +prop1zqs*lnlaupm*isr*cfscheme*(2*qup**2/qs-2*stw**2*qup**2/qs)
     & +prop1zqs*lnlaelm*fsr*cfscheme*(2*qel**2/qs-2*stw**2*qel**2/qs)
     & +jaaqstsupel*dreal(propizqs)*ifi*cfscheme*(2*ctw**2*qel*qup/qs*ts
     & +ctw**2*qel*qup*ts/us-ctw**2*qel*qup*ts**2/us**2)
     & +jaaqsusupel*dreal(propizqs)*ifi*cfscheme*(-2*ctw**2*qel*qup/qs*u
     & s)
     & +javqstsupelz*ifi*(4*stw**2*qel*qup*ts)
     & +javqstsupelz*dreal(propizqs)*ifi*(2*stw**2*qel*qup*ts/us**2*mz**
     & 2+2*stw**2*qel*qup*ts/us-2*stw**2*qel*qup*ts**2/us**2)
     & +javqsusupelz*ifi*(-4*stw**2*qel*qup*us)
     & +c0upupqszupc*dreal(propizqs)*ifi*(-2*stw**2*qel*qup/us*mz**2-2*s
     & tw**2*qel*qup-2*stw**2*qel*qup*ts/us**2*mz**2+2*stw**2*qel*qup*ts
     & **2/us**2)
     & +c0irupupqs*isr*(-2*stw**2*qup**2*qs)
     & +c0upupqscupc*dreal(propizqs)*ifi*cfscheme*(-ctw**2*qel*qup+ctw**
     & 2*qel*qup*ts**2/us**2)
     & +c0irupelts*ifi*(-4*stw**2*qel*qup*ts)
     & +c0irupelus*ifi*(4*stw**2*qel*qup*us)
     & +c0elelqszelc*dreal(propizqs)*ifi*(-2*stw**2*qel*qup/us*mz**2-2*s
     & tw**2*qel*qup-2*stw**2*qel*qup*ts/us**2*mz**2+2*stw**2*qel*qup*ts
     & **2/us**2)
     & +c0irelelqs*fsr*(-2*stw**2*qel**2*qs)
     & +c0elelqscelc*dreal(propizqs)*ifi*cfscheme*(-ctw**2*qel*qup+ctw**
     & 2*qel*qup*ts**2/us**2)
     & +c0celtsczel*ifi*(4*stw**2*qel*qup*ts)
     & +c0celtsczel*dreal(propizqs)*ifi*(4*stw**2*qel*qup*ts/us**2*mz**2
     & +4*stw**2*qel*qup*ts/us-4*stw**2*qel*qup*ts**2/us**2)
     & +c0celusczel*ifi*(-4*stw**2*qel*qup*us)
     & +a0fel*fsr*(-3*stw**2*qel**2)
     & +a0fel*dreal(propizqs)*fsr*cfscheme*(-3*qel**2/qs+3*stw**2*qel**2
     & /qs)
     & +a0fup*isr*(-3*stw**2*qup**2)
     & +a0fup*dreal(propizqs)*isr*cfscheme*(-3*qup**2/qs+3*stw**2*qup**2
     & /qs)
     & +b0fqszc*dreal(propizqs)*ifi*(-4*stw**2*qel*qup/us)
     & +b0fqscc*fsr*(-3*stw**2*qel**2)
     & +b0fqscc*isr*(-3*stw**2*qup**2)
     & +b0fqscc*dreal(propizqs)*ifi*cfscheme*(-2*ctw**2*qel*qup/us)
     & +b0fqscc*dreal(propizqs)*fsr*cfscheme*(-3*qel**2/qs+3*stw**2*qel*
     & *2/qs)
     & +b0fqscc*dreal(propizqs)*isr*cfscheme*(-3*qup**2/qs+3*stw**2*qup*
     & *2/qs)
     & +b0ftscc*dreal(propizqs)*ifi*(4*stw**2*qel*qup/us)
     & +b0ftscc*dreal(propizqs)*ifi*cfscheme*(2*ctw**2*qel*qup/us)
     & +lnlaupm*isr*(2*stw**2*qup**2)
     & +lnlaelm*fsr*(2*stw**2*qel**2)
     & +dreal(propizqs)*fsr*cfscheme*(-qel**2/qs+stw**2*qel**2/qs)
     & +dreal(propizqs)*isr*cfscheme*(-qup**2/qs+stw**2*qup**2/qs)

      ff_qed_ld =
     & 0

      ff_qed_qd =
     & 0

      ff_ew_ll =
     & +d0ccccqstszczc*dreal(propizqs)*pxx2zqsc**2*(1d0/8/ctw**2*vmael**
     & 2*vmaup**2/us+1d0/4/ctw**2*vmael**2*vmaup**2*ts/us**2+1d0/8/ctw**
     & 2*vpael**2*vpaup**2/us+1d0/4/ctw**2*vpael**2*vpaup**2*ts/us**2)
     & +d0ccccqstszczc*dreal(propizqs)*pxx2zqsc*(3d0/4/ctw**2*vmael**2*v
     & maup**2*ts/us+3d0/4/ctw**2*vpael**2*vpaup**2*ts/us)
     & +d0ccccqstszczc*dreal(propizqs)*(1d0/2/ctw**2*vmael**2*vmaup**2*m
     & z**2-1d0/8/ctw**2*vmael**2*vmaup**2*us+1d0/2/ctw**2*vmael**2*vmau
     & p**2*ts+1d0/8/ctw**2*vmael**2*vmaup**2*ts**2/us-1d0/2/ctw**2*vmae
     & l**2*vpaup**2*ts-1d0/2/ctw**2*vpael**2*vmaup**2*ts+1d0/2/ctw**2*v
     & pael**2*vpaup**2*mz**2-1d0/8/ctw**2*vpael**2*vpaup**2*us+1d0/2/ct
     & w**2*vpael**2*vpaup**2*ts+1d0/8/ctw**2*vpael**2*vpaup**2*ts**2/us
     & )
     & +d0ccccqsuswcwc*dreal(propizqs)*(-2*us*rwz)
     & +d0ccccqsuszczc*dreal(propizqs)*pxx2zqsc**2*(1d0/4/ctw**2*vmael**
     & 2*vpaup**2/ts**2*us+1d0/8/ctw**2*vmael**2*vpaup**2/ts+1d0/4/ctw**
     & 2*vpael**2*vmaup**2/ts**2*us+1d0/8/ctw**2*vpael**2*vmaup**2/ts)
     & +d0ccccqsuszczc*dreal(propizqs)*pxx2zqsc*(3d0/4/ctw**2*vmael**2*v
     & paup**2/ts*us+1d0/4/ctw**2*vmael**2*vpaup**2+3d0/4/ctw**2*vpael**
     & 2*vmaup**2/ts*us+1d0/4/ctw**2*vpael**2*vmaup**2)
     & +d0ccccqsuszczc*dreal(propizqs)*(-1d0/2/ctw**2*vmael**2*vmaup**2*
     & us+1d0/8/ctw**2*vmael**2*vpaup**2/ts*us**2+3d0/4/ctw**2*vmael**2*
     & vpaup**2*us+1d0/8/ctw**2*vmael**2*vpaup**2*ts+1d0/8/ctw**2*vpael*
     & *2*vmaup**2/ts*us**2+3d0/4/ctw**2*vpael**2*vmaup**2*us+1d0/8/ctw*
     & *2*vpael**2*vmaup**2*ts-1d0/2/ctw**2*vpael**2*vpaup**2*us)
     & +c0ccqswcw*dreal(propizqs)*(4*rwz)
     & +c0ccqswcw*(4/qs*mw**4*rwz-8*mw**2*rwz)
     & +c0ccqszcz*dreal(propizqs)*pxx2zqsc*(1d0/2/ctw**2*vmael**2*vmaup*
     & *2/us+1d0/2/ctw**2*vmael**2*vmaup**2*ts/us**2+1d0/2/ctw**2*vmael*
     & *2*vpaup**2/ts**2*us+1d0/2/ctw**2*vmael**2*vpaup**2/ts+1d0/2/ctw*
     & *2*vpael**2*vmaup**2/ts**2*us+1d0/2/ctw**2*vpael**2*vmaup**2/ts+1
     & d0/2/ctw**2*vpael**2*vpaup**2/us+1d0/2/ctw**2*vpael**2*vpaup**2*t
     & s/us**2)
     & +c0ccqszcz*dreal(propizqs)*(1d0/ctw**2*vmael**2*vmaup**2+1d0/ctw*
     & *2*vmael**2*vmaup**2*ts/us+1d0/ctw**2*vmael**2*vpaup**2/ts*us+1d0
     & /ctw**2*vmael**2*vpaup**2+1d0/ctw**2*vpael**2*vmaup**2/ts*us+1d0/
     & ctw**2*vpael**2*vmaup**2+1d0/ctw**2*vpael**2*vpaup**2+1d0/ctw**2*
     & vpael**2*vpaup**2*ts/us)
     & +c0ccqscwc*(-1d0/qs*mw**4+2/qs*mw**4*rwz+2*mw**2-4*mw**2*rwz-qs+2
     & *qs*rwz-vpadn/qs*mw**4+2*vpadn*mw**2-vpadn*qs+vmael/qs*mw**4-2*vm
     & ael*mw**2+vmael*qs)
     & +c0ccqsczc*(-1d0/qs*mw**4/rwz**3+2*mw**2/rwz**2-qs/rwz+3d0/2*vpau
     & p/qs*mw**4/rwz**3-3*vpaup*mw**2/rwz**2+3d0/2*vpaup*qs/rwz-3d0/2*v
     & paup**2/qs*mw**4/rwz**3+3*vpaup**2*mw**2/rwz**2-3d0/2*vpaup**2*qs
     & /rwz+3d0/2*vmael/qs*mw**4/rwz**3-3*vmael*mw**2/rwz**2+3d0/2*vmael
     & *qs/rwz-3d0/2*vmael**2/qs*mw**4/rwz**3+3*vmael**2*mw**2/rwz**2-3d
     & 0/2*vmael**2*qs/rwz)
     & +c0cctsczc*dreal(propizqs)*pxx2zqsc*(-1d0/2/ctw**2*vmael**2*vmaup
     & **2*ts/us**2-1d0/2/ctw**2*vpael**2*vpaup**2*ts/us**2)
     & +c0cctsczc*dreal(propizqs)*(-1d0/ctw**2*vmael**2*vmaup**2*ts/us-1
     & d0/ctw**2*vpael**2*vpaup**2*ts/us)
     & +c0ccusczc*dreal(propizqs)*pxx2zqsc*(-1d0/2/ctw**2*vmael**2*vpaup
     & **2/ts**2*us-1d0/2/ctw**2*vpael**2*vmaup**2/ts**2*us)
     & +c0ccusczc*dreal(propizqs)*(-1d0/ctw**2*vmael**2*vpaup**2/ts*us-1
     & d0/ctw**2*vpael**2*vmaup**2/ts*us)
     & +a0fw*dreal(propzqs)*(3*mw**2/rwz/rhw+1d0/6*mw**2/rwz-8d0/3*mw**2
     & -4*mw**2*rwz)
     & +a0fw*(-3d0/2+1d0/qs*mw**2+2/qs*mw**2*rwz+rwz+vpadn/qs*mw**2-3d0/
     & 2*vpadn-vmael/qs*mw**2+3d0/2*vmael)
     & +a0fz*dreal(propzqs)*(3d0/2*mw**2/rwz**3/rhw+1d0/6*mw**2/rwz**2-1
     & d0/12*mw**2/rwz*rhw)
     & +a0fz*(11d0/12/qs*mw**2/rwz**2+1d0/12/qs*mw**2/rwz*rhw-3d0/2/rwz-
     & 3d0/2*vpaup/qs*mw**2/rwz**2+9d0/4*vpaup/rwz+3d0/2*vpaup**2/qs*mw*
     & *2/rwz**2-9d0/4*vpaup**2/rwz-3d0/2*vmael/qs*mw**2/rwz**2+9d0/4*vm
     & ael/rwz+3d0/2*vmael**2/qs*mw**2/rwz**2-9d0/4*vmael**2/rwz)
     & +a0fh*dreal(propzqs)*(1d0/2*mw**2/rwz*rhw+1d0/12*mw**2*rhw**2)
     & +a0fh*(1d0/12/qs*mw**2/rwz*rhw-1d0/12/qs*mw**2*rhw**2)
     & +b0fqsww*dreal(propzqs)*(1d0/12*mw**2/rwz**2+4d0/3*mw**2/rwz-17d0
     & /3*mw**2-4*mw**2*rwz)
     & +b0fqsww*dreal(propizqs)*(5d0/3/mw**2*rwz-1d0/12*qs/mw**4*rwz)
     & +b0fqsww*(-4d0/3+4/qs*mw**2*rwz-1d0/12/rwz+rwz+1d0/12*qs/mw**2-5d
     & 0/3*qs/mw**2*rwz+1d0/12*qs**2/mw**4*rwz)
     & +b0fqszz*dreal(propizqs)*(1d0/2/ctw**2*vmael**2*vmaup**2/us+1d0/2
     & /ctw**2*vmael**2*vpaup**2/ts+1d0/2/ctw**2*vpael**2*vmaup**2/ts+1d
     & 0/2/ctw**2*vpael**2*vpaup**2/us)
     & +b0fqszh*dreal(propzqs)*(mw**2/rwz**2-1d0/3*mw**2/rwz*rhw+1d0/12*
     & mw**2*rhw**2)
     & +b0fqszh*(-1d0/12/qs*mw**2/rwz**2+1d0/6/qs*mw**2/rwz*rhw-1d0/12/q
     & s*mw**2*rhw**2-1d0/12/rwz)
     & +b0fqscc*(-3d0/2+1d0/qs*mw**2/rwz**2+1d0/qs*mw**2-2/qs*mw**2*rwz-
     & 3d0/2/rwz+3*rwz+vpadn/qs*mw**2-3d0/2*vpadn-3d0/2*vpaup/qs*mw**2/r
     & wz**2+9d0/4*vpaup/rwz+3d0/2*vpaup**2/qs*mw**2/rwz**2-9d0/4*vpaup*
     & *2/rwz-3d0/2*vmael/qs*mw**2/rwz**2-vmael/qs*mw**2+9d0/4*vmael/rwz
     & +3d0/2*vmael+3d0/2*vmael**2/qs*mw**2/rwz**2-9d0/4*vmael**2/rwz)
     & +b0ftscc*dreal(propizqs)*(-1d0/2/ctw**2*vmael**2*vmaup**2/us-1d0/
     & 2/ctw**2*vpael**2*vpaup**2/us)
     & +b0fuscc*dreal(propizqs)*(-1d0/2/ctw**2*vmael**2*vpaup**2/ts-1d0/
     & 2/ctw**2*vpael**2*vmaup**2/ts)
     & +dreal(propzqs)*(mw**2/rwz**3/rhw-1d0/18*mw**2/rwz**2+2*mw**2/rwz
     & /rhw-5d0/9*mw**2/rwz-mw**2/rwz*zmzzzbos-1d0/6*mw**2/rwz*rhw-8d0/3
     & *mw**2-4*mw**2*rwz)
     & -1d0/36+1d0/stw**2*deltarhofer+1d0/stw**2*deltarhobos-13d0/36/rwz
     & +caldzfer-2*deltarhofer-za1fer-2*deltarhobos-za1bos+6*rwz-vpadn+3
     & d0/8*vpaup/rwz+3d0/4*vpaup-3d0/8*vpaup**2/rwz+3d0/8*vmael/rwz+1d0
     & /4*vmael-3d0/8*vmael**2/rwz

      ff_ew_ql =
     & +d0ccccqstszczc*dreal(propizqs)*pxx2zqsc**2*(-1d0/8/ctw**2*vmael*
     & *2*vmaup/us-1d0/4/ctw**2*vmael**2*vmaup*ts/us**2)
     & +d0ccccqstszczc*dreal(propizqs)*pxx2zqsc*(-3d0/4/ctw**2*vmael**2*
     & vmaup*ts/us)
     & +d0ccccqstszczc*dreal(propizqs)*(-1d0/2/ctw**2*vmael**2*vmaup*mz*
     & *2+1d0/8/ctw**2*vmael**2*vmaup*us-1d0/2/ctw**2*vmael**2*vmaup*ts-
     & 1d0/8/ctw**2*vmael**2*vmaup*ts**2/us+1d0/2/ctw**2*vpael**2*vmaup*
     & ts)
     & +d0ccccqsuszczc*dreal(propizqs)*pxx2zqsc**2*(-1d0/4/ctw**2*vpael*
     & *2*vmaup/ts**2*us-1d0/8/ctw**2*vpael**2*vmaup/ts)
     & +d0ccccqsuszczc*dreal(propizqs)*pxx2zqsc*(-3d0/4/ctw**2*vpael**2*
     & vmaup/ts*us-1d0/4/ctw**2*vpael**2*vmaup)
     & +d0ccccqsuszczc*dreal(propizqs)*(1d0/2/ctw**2*vmael**2*vmaup*us-1
     & d0/8/ctw**2*vpael**2*vmaup/ts*us**2-3d0/4/ctw**2*vpael**2*vmaup*u
     & s-1d0/8/ctw**2*vpael**2*vmaup*ts)
     & +c0ccqswcw*(-2/qs**2*mw**6+4/qs*mw**4)
     & +c0ccqszcz*dreal(propizqs)*pxx2zqsc*(-1d0/2/ctw**2*vmael**2*vmaup
     & /us-1d0/2/ctw**2*vmael**2*vmaup*ts/us**2-1d0/2/ctw**2*vpael**2*vm
     & aup/ts**2*us-1d0/2/ctw**2*vpael**2*vmaup/ts)
     & +c0ccqszcz*dreal(propizqs)*(-1d0/ctw**2*vmael**2*vmaup-1d0/ctw**2
     & *vmael**2*vmaup*ts/us-1d0/ctw**2*vpael**2*vmaup/ts*us-1d0/ctw**2*
     & vpael**2*vmaup)
     & +c0ccqscwc*(-1d0/qs*mw**4+2/qs*mw**4*rwz+2*mw**2-4*mw**2*rwz-qs+2
     & *qs*rwz+vmael/qs*mw**4-2*vmael*mw**2+vmael*qs)
     & +c0ccqsczc*(-1d0/qs*mw**4/rwz**3+2*mw**2/rwz**2-qs/rwz+vpaup/qs*m
     & w**4/rwz**3-2*vpaup*mw**2/rwz**2+vpaup*qs/rwz-1d0/2*vpaup**2/qs*m
     & w**4/rwz**3+vpaup**2*mw**2/rwz**2-1d0/2*vpaup**2*qs/rwz+3d0/2*vma
     & el/qs*mw**4/rwz**3-3*vmael*mw**2/rwz**2+3d0/2*vmael*qs/rwz-3d0/2*
     & vmael**2/qs*mw**4/rwz**3+3*vmael**2*mw**2/rwz**2-3d0/2*vmael**2*q
     & s/rwz-qel/qs**2*mw**6/rwz**3+qel/qs*mw**4/rwz**2+qel*mw**2/rwz-qe
     & l*qs+2*qel*vmael/qs**2*mw**6/rwz**3-2*qel*vmael/qs*mw**4/rwz**2-2
     & *qel*vmael*mw**2/rwz+2*qel*vmael*qs)
     & +c0cctsczc*dreal(propizqs)*pxx2zqsc*(1d0/2/ctw**2*vmael**2*vmaup*
     & ts/us**2)
     & +c0cctsczc*dreal(propizqs)*(1d0/ctw**2*vmael**2*vmaup*ts/us)
     & +c0ccusczc*dreal(propizqs)*pxx2zqsc*(1d0/2/ctw**2*vpael**2*vmaup/
     & ts**2*us)
     & +c0ccusczc*dreal(propizqs)*(1d0/ctw**2*vpael**2*vmaup/ts*us)
     & +a0fw*dreal(propzqs)*(3*mw**2/rwz/rhw+1d0/6*mw**2/rwz-8d0/3*mw**2
     & -4*mw**2*rwz)
     & +a0fw*(-3d0/2-2/qs**2*mw**4+10d0/3/qs*mw**2+2/qs*mw**2*rwz+3*rwz-
     & vmael/qs*mw**2+3d0/2*vmael)
     & +a0fz*dreal(propzqs)*(3d0/2*mw**2/rwz**3/rhw+1d0/6*mw**2/rwz**2-1
     & d0/12*mw**2/rwz*rhw)
     & +a0fz*(11d0/12/qs*mw**2/rwz**2+1d0/12/qs*mw**2/rwz*rhw-3d0/2/rwz-
     & vpaup/qs*mw**2/rwz**2+3d0/2*vpaup/rwz+1d0/2*vpaup**2/qs*mw**2/rwz
     & **2-3d0/4*vpaup**2/rwz-3d0/2*vmael/qs*mw**2/rwz**2+9d0/4*vmael/rw
     & z+3d0/2*vmael**2/qs*mw**2/rwz**2-9d0/4*vmael**2/rwz+qel/qs**2*mw*
     & *4/rwz**2-1d0/2*qel/qs*mw**2/rwz-3d0/2*qel-2*qel*vmael/qs**2*mw**
     & 4/rwz**2+qel*vmael/qs*mw**2/rwz+3*qel*vmael)
     & +a0fh*dreal(propzqs)*(1d0/2*mw**2/rwz*rhw+1d0/12*mw**2*rhw**2)
     & +a0fh*(1d0/12/qs*mw**2/rwz*rhw-1d0/12/qs*mw**2*rhw**2)
     & +b0fqsww*dreal(propzqs)*(1d0/12*mw**2/rwz**2+4d0/3*mw**2/rwz-17d0
     & /3*mw**2-4*mw**2*rwz)
     & +b0fqsww*(1d0/6-2/qs**2*mw**4+7d0/3/qs*mw**2+4/qs*mw**2*rwz-1d0/1
     & 2/rwz)
     & +b0fqszz*dreal(propizqs)*(-1d0/2/ctw**2*vmael**2*vmaup/us-1d0/2/c
     & tw**2*vpael**2*vmaup/ts)
     & +b0fqszh*dreal(propzqs)*(mw**2/rwz**2-1d0/3*mw**2/rwz*rhw+1d0/12*
     & mw**2*rhw**2)
     & +b0fqszh*(-1d0/12/qs*mw**2/rwz**2+1d0/6/qs*mw**2/rwz*rhw-1d0/12/q
     & s*mw**2*rhw**2-1d0/12/rwz)
     & +b0fqscc*(-3d0/2+1d0/qs*mw**2/rwz**2+1d0/qs*mw**2-2/qs*mw**2*rwz-
     & 3d0/2/rwz+3*rwz-vpaup/qs*mw**2/rwz**2+3d0/2*vpaup/rwz+1d0/2*vpaup
     & **2/qs*mw**2/rwz**2-3d0/4*vpaup**2/rwz-3d0/2*vmael/qs*mw**2/rwz**
     & 2-vmael/qs*mw**2+9d0/4*vmael/rwz+3d0/2*vmael+3d0/2*vmael**2/qs*mw
     & **2/rwz**2-9d0/4*vmael**2/rwz+qel/qs**2*mw**4/rwz**2-1d0/2*qel/qs
     & *mw**2/rwz-3d0/2*qel-2*qel*vmael/qs**2*mw**4/rwz**2+qel*vmael/qs*
     & mw**2/rwz+3*qel*vmael)
     & +b0ftscc*dreal(propizqs)*(1d0/2/ctw**2*vmael**2*vmaup/us)
     & +b0fuscc*dreal(propizqs)*(1d0/2/ctw**2*vpael**2*vmaup/ts)
     & +dreal(propzqs)*(mw**2/rwz**3/rhw-1d0/18*mw**2/rwz**2+2*mw**2/rwz
     & /rhw-5d0/9*mw**2/rwz-mw**2/rwz*zmzzzbos-1d0/6*mw**2/rwz*rhw-8d0/3
     & *mw**2-4*mw**2*rwz)
     & -5d0/36-2d0/3/qs*mw**2+4/qs*mw**2*rwz-13d0/36/rwz-pizgfer+caldzfe
     & r-deltarhofer-za1fer-deltarhobos-za1bos+2*rwz+1d0/4*vpaup/rwz-1d0
     & /8*vpaup**2/rwz+3d0/8*vmael/rwz+1d0/4*vmael-3d0/8*vmael**2/rwz-1d
     & 0/4*qel/qs*mw**2/rwz+3d0/2*qel/qs*mw**2-1d0/4*qel+3d0/2*qel*rwz+1
     & d0/2*qel*vmael/qs*mw**2/rwz+1d0/2*qel*vmael

      ff_ew_lq =
     & +d0ccccqstszczc*dreal(propizqs)*pxx2zqsc**2*(1d0/8/ctw**2*vmael*v
     & maup**2/us+1d0/4/ctw**2*vmael*vmaup**2*ts/us**2)
     & +d0ccccqstszczc*dreal(propizqs)*pxx2zqsc*(3d0/4/ctw**2*vmael*vmau
     & p**2*ts/us)
     & +d0ccccqstszczc*dreal(propizqs)*(1d0/2/ctw**2*vmael*vmaup**2*mz**
     & 2-1d0/8/ctw**2*vmael*vmaup**2*us+1d0/2/ctw**2*vmael*vmaup**2*ts+1
     & d0/8/ctw**2*vmael*vmaup**2*ts**2/us-1d0/2/ctw**2*vmael*vpaup**2*t
     & s)
     & +d0ccccqsuszczc*dreal(propizqs)*pxx2zqsc**2*(1d0/4/ctw**2*vmael*v
     & paup**2/ts**2*us+1d0/8/ctw**2*vmael*vpaup**2/ts)
     & +d0ccccqsuszczc*dreal(propizqs)*pxx2zqsc*(3d0/4/ctw**2*vmael*vpau
     & p**2/ts*us+1d0/4/ctw**2*vmael*vpaup**2)
     & +d0ccccqsuszczc*dreal(propizqs)*(-1d0/2/ctw**2*vmael*vmaup**2*us+
     & 1d0/8/ctw**2*vmael*vpaup**2/ts*us**2+3d0/4/ctw**2*vmael*vpaup**2*
     & us+1d0/8/ctw**2*vmael*vpaup**2*ts)
     & +c0ccqswcw*(-2/qs**2*mw**6+4/qs*mw**4)
     & +c0ccqszcz*dreal(propizqs)*pxx2zqsc*(1d0/2/ctw**2*vmael*vmaup**2/
     & us+1d0/2/ctw**2*vmael*vmaup**2*ts/us**2+1d0/2/ctw**2*vmael*vpaup*
     & *2/ts**2*us+1d0/2/ctw**2*vmael*vpaup**2/ts)
     & +c0ccqszcz*dreal(propizqs)*(1d0/ctw**2*vmael*vmaup**2+1d0/ctw**2*
     & vmael*vmaup**2*ts/us+1d0/ctw**2*vmael*vpaup**2/ts*us+1d0/ctw**2*v
     & mael*vpaup**2)
     & +c0ccqscwc*(-vpadn/qs*mw**4+2*vpadn*mw**2-vpadn*qs+2*qdn/qs**2*mw
     & **6-4*qdn/qs*mw**4+2*qdn/qs*mw**4*rwz+2*qdn*mw**2-4*qdn*mw**2*rwz
     & +2*qdn*qs*rwz)
     & +c0ccqsczc*(-1d0/2/qs*mw**4/rwz**3+mw**2/rwz**2-1d0/2*qs/rwz+3d0/
     & 2*vpaup/qs*mw**4/rwz**3-3*vpaup*mw**2/rwz**2+3d0/2*vpaup*qs/rwz-3
     & d0/2*vpaup**2/qs*mw**4/rwz**3+3*vpaup**2*mw**2/rwz**2-3d0/2*vpaup
     & **2*qs/rwz-1d0/2*vmael**2/qs*mw**4/rwz**3+vmael**2*mw**2/rwz**2-1
     & d0/2*vmael**2*qs/rwz-qup/qs**2*mw**6/rwz**3+qup/qs*mw**4/rwz**2+q
     & up*mw**2/rwz-qup*qs+2*qup*vpaup/qs**2*mw**6/rwz**3-2*qup*vpaup/qs
     & *mw**4/rwz**2-2*qup*vpaup*mw**2/rwz+2*qup*vpaup*qs)
     & +c0cctsczc*dreal(propizqs)*pxx2zqsc*(-1d0/2/ctw**2*vmael*vmaup**2
     & *ts/us**2)
     & +c0cctsczc*dreal(propizqs)*(-1d0/ctw**2*vmael*vmaup**2*ts/us)
     & +c0ccusczc*dreal(propizqs)*pxx2zqsc*(-1d0/2/ctw**2*vmael*vpaup**2
     & /ts**2*us)
     & +c0ccusczc*dreal(propizqs)*(-1d0/ctw**2*vmael*vpaup**2/ts*us)
     & +a0fw*dreal(propzqs)*(3*mw**2/rwz/rhw+1d0/6*mw**2/rwz-8d0/3*mw**2
     & -4*mw**2*rwz)
     & +a0fw*(-2/qs**2*mw**4+7d0/3/qs*mw**2+4/qs*mw**2*rwz+vpadn/qs*mw**
     & 2-3d0/2*vpadn-2*qdn/qs**2*mw**4+3*qdn/qs*mw**2-2*qdn/qs*mw**2*rwz
     & +3*qdn*rwz)
     & +a0fz*dreal(propzqs)*(3d0/2*mw**2/rwz**3/rhw+1d0/6*mw**2/rwz**2-1
     & d0/12*mw**2/rwz*rhw)
     & +a0fz*(5d0/12/qs*mw**2/rwz**2+1d0/12/qs*mw**2/rwz*rhw-3d0/4/rwz-3
     & d0/2*vpaup/qs*mw**2/rwz**2+9d0/4*vpaup/rwz+3d0/2*vpaup**2/qs*mw**
     & 2/rwz**2-9d0/4*vpaup**2/rwz+1d0/2*vmael**2/qs*mw**2/rwz**2-3d0/4*
     & vmael**2/rwz+qup/qs**2*mw**4/rwz**2-1d0/2*qup/qs*mw**2/rwz-3d0/2*
     & qup-2*qup*vpaup/qs**2*mw**4/rwz**2+qup*vpaup/qs*mw**2/rwz+3*qup*v
     & paup)
     & +a0fh*dreal(propzqs)*(1d0/2*mw**2/rwz*rhw+1d0/12*mw**2*rhw**2)
     & +a0fh*(1d0/12/qs*mw**2/rwz*rhw-1d0/12/qs*mw**2*rhw**2)
     & +b0fqsww*dreal(propzqs)*(1d0/12*mw**2/rwz**2+4d0/3*mw**2/rwz-17d0
     & /3*mw**2-4*mw**2*rwz)
     & +b0fqsww*(1d0/6-2/qs**2*mw**4+7d0/3/qs*mw**2+4/qs*mw**2*rwz-1d0/1
     & 2/rwz)
     & +b0fqszz*dreal(propizqs)*(1d0/2/ctw**2*vmael*vmaup**2/us+1d0/2/ct
     & w**2*vmael*vpaup**2/ts)
     & +b0fqszh*dreal(propzqs)*(mw**2/rwz**2-1d0/3*mw**2/rwz*rhw+1d0/12*
     & mw**2*rhw**2)
     & +b0fqszh*(-1d0/12/qs*mw**2/rwz**2+1d0/6/qs*mw**2/rwz*rhw-1d0/12/q
     & s*mw**2*rhw**2-1d0/12/rwz)
     & +b0fqscc*(1d0/2/qs*mw**2/rwz**2-3d0/4/rwz+vpadn/qs*mw**2-3d0/2*vp
     & adn-3d0/2*vpaup/qs*mw**2/rwz**2+9d0/4*vpaup/rwz+3d0/2*vpaup**2/qs
     & *mw**2/rwz**2-9d0/4*vpaup**2/rwz+1d0/2*vmael**2/qs*mw**2/rwz**2-3
     & d0/4*vmael**2/rwz-2*qdn/qs**2*mw**4+3*qdn/qs*mw**2-2*qdn/qs*mw**2
     & *rwz+3*qdn*rwz+qup/qs**2*mw**4/rwz**2-1d0/2*qup/qs*mw**2/rwz-3d0/
     & 2*qup-2*qup*vpaup/qs**2*mw**4/rwz**2+qup*vpaup/qs*mw**2/rwz+3*qup
     & *vpaup)
     & +b0ftscc*dreal(propizqs)*(-1d0/2/ctw**2*vmael*vmaup**2/us)
     & +b0fuscc*dreal(propizqs)*(-1d0/2/ctw**2*vmael*vpaup**2/ts)
     & +dreal(propzqs)*(mw**2/rwz**3/rhw-1d0/18*mw**2/rwz**2+2*mw**2/rwz
     & /rhw-5d0/9*mw**2/rwz-mw**2/rwz*zmzzzbos-1d0/6*mw**2/rwz*rhw-8d0/3
     & *mw**2-4*mw**2*rwz)
     & +1d0/9-2d0/3/qs*mw**2+4/qs*mw**2*rwz-17d0/72/rwz-pizgfer+caldzfer
     & -deltarhofer-za1fer-deltarhobos-za1bos-vpadn+3d0/8*vpaup/rwz+3d0/
     & 4*vpaup-3d0/8*vpaup**2/rwz-1d0/8*vmael**2/rwz+2*qdn/qs*mw**2+2*qd
     & n*rwz-1d0/4*qup/qs*mw**2/rwz-3d0/2*qup/qs*mw**2-1d0/4*qup-3d0/2*q
     & up*rwz+1d0/2*qup*vpaup/qs*mw**2/rwz+1d0/2*qup*vpaup

      ff_ew_qq =
     & +d0ccccqstszczc*dreal(propizqs)*pxx2zqsc**2*(-1d0/8/ctw**2*vmael*
     & vmaup/us-1d0/4/ctw**2*vmael*vmaup*ts/us**2)
     & +d0ccccqstszczc*dreal(propizqs)*pxx2zqsc*(-3d0/4/ctw**2*vmael*vma
     & up*ts/us)
     & +d0ccccqstszczc*dreal(propizqs)*(-1d0/2/ctw**2*vmael*vmaup*mz**2+
     & 1d0/8/ctw**2*vmael*vmaup*us-1d0/2/ctw**2*vmael*vmaup*ts-1d0/8/ctw
     & **2*vmael*vmaup*ts**2/us)
     & +d0ccccqsuszczc*dreal(propizqs)*(1d0/2/ctw**2*vmael*vmaup*us)
     & +c0ccqszcz*dreal(propizqs)*pxx2zqsc*(-1d0/2/ctw**2*vmael*vmaup/us
     & -1d0/2/ctw**2*vmael*vmaup*ts/us**2)
     & +c0ccqszcz*dreal(propizqs)*(-1d0/ctw**2*vmael*vmaup-1d0/ctw**2*vm
     & ael*vmaup*ts/us)
     & +c0ccqsczc*(-1d0/2/stw**2/qs**2*mw**6+1d0/2/stw**2/qs*mw**4+1d0/2
     & /stw**2*mw**2-1d0/2/stw**2*qs+1d0/stw**2*vpaup/qs**2*mw**6-1d0/st
     & w**2*vpaup/qs*mw**4-1d0/stw**2*vpaup*mw**2+1d0/stw**2*vpaup*qs-1d
     & 0/2/stw**2*vpaup**2/qs**2*mw**6+1d0/2/stw**2*vpaup**2/qs*mw**4+1d
     & 0/2/stw**2*vpaup**2*mw**2-1d0/2/stw**2*vpaup**2*qs-1d0/2/qs**2*mw
     & **6/rwz**3-1d0/2/qs**2*mw**6/rwz**2-1d0/2/qs**2*mw**6/rwz-1d0/2/q
     & s*mw**4/rwz**3+1d0/2/qs*mw**4/rwz**2+1d0/2/qs*mw**4/rwz+mw**2/rwz
     & **2+1d0/2*mw**2/rwz-1d0/2*qs/rwz+vpaup/qs**2*mw**6/rwz**3+vpaup/q
     & s**2*mw**6/rwz**2+vpaup/qs**2*mw**6/rwz+vpaup/qs*mw**4/rwz**3-vpa
     & up/qs*mw**4/rwz**2-vpaup/qs*mw**4/rwz-2*vpaup*mw**2/rwz**2-vpaup*
     & mw**2/rwz+vpaup*qs/rwz-1d0/2*vpaup**2/qs**2*mw**6/rwz**3-1d0/2*vp
     & aup**2/qs**2*mw**6/rwz**2-1d0/2*vpaup**2/qs**2*mw**6/rwz-1d0/2*vp
     & aup**2/qs*mw**4/rwz**3+1d0/2*vpaup**2/qs*mw**4/rwz**2+1d0/2*vpaup
     & **2/qs*mw**4/rwz+vpaup**2*mw**2/rwz**2+1d0/2*vpaup**2*mw**2/rwz-1
     & d0/2*vpaup**2*qs/rwz-1d0/2*vmael**2/qs*mw**4/rwz**3+vmael**2*mw**
     & 2/rwz**2-1d0/2*vmael**2*qs/rwz+qel*vmael/qs**2*mw**6/rwz**3-qel*v
     & mael/qs*mw**4/rwz**2-qel*vmael*mw**2/rwz+qel*vmael*qs)
     & +c0cctsczc*dreal(propizqs)*pxx2zqsc*(1d0/2/ctw**2*vmael*vmaup*ts/
     & us**2)
     & +c0cctsczc*dreal(propizqs)*(1d0/ctw**2*vmael*vmaup*ts/us)
     & +a0fw*dreal(propzqs)*(3*mw**2/rwz/rhw+1d0/6*mw**2/rwz-8d0/3*mw**2
     & -4*mw**2*rwz)
     & +a0fw*(-4/qs**2*mw**4+8d0/3/qs*mw**2+4/qs*mw**2*rwz)
     & +a0fz*dreal(propzqs)*(3d0/2*mw**2/rwz**3/rhw+1d0/6*mw**2/rwz**2-1
     & d0/12*mw**2/rwz*rhw)
     & +a0fz*(1d0/2/stw**2/qs**2*mw**4-1d0/4/stw**2/qs*mw**2-3d0/4/stw**
     & 2-1d0/stw**2*vpaup/qs**2*mw**4+1d0/2/stw**2*vpaup/qs*mw**2+3d0/2/
     & stw**2*vpaup+1d0/2/stw**2*vpaup**2/qs**2*mw**4-1d0/4/stw**2*vpaup
     & **2/qs*mw**2-3d0/4/stw**2*vpaup**2+1d0/2/qs**2*mw**4/rwz**2+1d0/2
     & /qs**2*mw**4/rwz+5d0/12/qs*mw**2/rwz**2-1d0/4/qs*mw**2/rwz+1d0/12
     & /qs*mw**2/rwz*rhw-3d0/4/rwz-vpaup/qs**2*mw**4/rwz**2-vpaup/qs**2*
     & mw**4/rwz-vpaup/qs*mw**2/rwz**2+1d0/2*vpaup/qs*mw**2/rwz+3d0/2*vp
     & aup/rwz+1d0/2*vpaup**2/qs**2*mw**4/rwz**2+1d0/2*vpaup**2/qs**2*mw
     & **4/rwz+1d0/2*vpaup**2/qs*mw**2/rwz**2-1d0/4*vpaup**2/qs*mw**2/rw
     & z-3d0/4*vpaup**2/rwz+1d0/2*vmael**2/qs*mw**2/rwz**2-3d0/4*vmael**
     & 2/rwz-qel*vmael/qs**2*mw**4/rwz**2+1d0/2*qel*vmael/qs*mw**2/rwz+3
     & d0/2*qel*vmael)
     & +a0fh*dreal(propzqs)*(1d0/2*mw**2/rwz*rhw+1d0/12*mw**2*rhw**2)
     & +a0fh*(1d0/12/qs*mw**2/rwz*rhw-1d0/12/qs*mw**2*rhw**2)
     & +b0fqsww*dreal(propzqs)*(1d0/12*mw**2/rwz**2+4d0/3*mw**2/rwz-17d0
     & /3*mw**2-4*mw**2*rwz)
     & +b0fqsww*(-4/qs**2*mw**4+17d0/3/qs*mw**2+4/qs*mw**2*rwz-1d0/12/rw
     & z)
     & +b0fqszz*dreal(propizqs)*(-1d0/2/ctw**2*vmael*vmaup/us)
     & +b0fqszh*dreal(propzqs)*(mw**2/rwz**2-1d0/3*mw**2/rwz*rhw+1d0/12*
     & mw**2*rhw**2)
     & +b0fqszh*(-1d0/12/qs*mw**2/rwz**2+1d0/6/qs*mw**2/rwz*rhw-1d0/12/q
     & s*mw**2*rhw**2-1d0/12/rwz)
     & +b0fqscc*(1d0/2/stw**2/qs**2*mw**4-1d0/4/stw**2/qs*mw**2-3d0/4/st
     & w**2-1d0/stw**2*vpaup/qs**2*mw**4+1d0/2/stw**2*vpaup/qs*mw**2+3d0
     & /2/stw**2*vpaup+1d0/2/stw**2*vpaup**2/qs**2*mw**4-1d0/4/stw**2*vp
     & aup**2/qs*mw**2-3d0/4/stw**2*vpaup**2+1d0/2/qs**2*mw**4/rwz**2+1d
     & 0/2/qs**2*mw**4/rwz+1d0/2/qs*mw**2/rwz**2-1d0/4/qs*mw**2/rwz-3d0/
     & 4/rwz-vpaup/qs**2*mw**4/rwz**2-vpaup/qs**2*mw**4/rwz-vpaup/qs*mw*
     & *2/rwz**2+1d0/2*vpaup/qs*mw**2/rwz+3d0/2*vpaup/rwz+1d0/2*vpaup**2
     & /qs**2*mw**4/rwz**2+1d0/2*vpaup**2/qs**2*mw**4/rwz+1d0/2*vpaup**2
     & /qs*mw**2/rwz**2-1d0/4*vpaup**2/qs*mw**2/rwz-3d0/4*vpaup**2/rwz+1
     & d0/2*vmael**2/qs*mw**2/rwz**2-3d0/4*vmael**2/rwz-qel*vmael/qs**2*
     & mw**4/rwz**2+1d0/2*qel*vmael/qs*mw**2/rwz+3d0/2*qel*vmael)
     & +b0ftscc*dreal(propizqs)*(1d0/2/ctw**2*vmael*vmaup/us)
     & +dreal(propzqs)*(mw**2/rwz**3/rhw-1d0/18*mw**2/rwz**2+2*mw**2/rwz
     & /rhw-5d0/9*mw**2/rwz-mw**2/rwz*zmzzzbos-1d0/6*mw**2/rwz*rhw-8d0/3
     & *mw**2-4*mw**2*rwz)
     & -1d0/8/stw**2/qs*mw**2-1d0/stw**2/qs*mw**2*za1bos-1d0/8/stw**2-1d
     & 0/stw**2*deltarhofer-1d0/stw**2*deltarhobos-1d0/stw**2*za1bos+1d0
     & /4/stw**2*vpaup/qs*mw**2+1d0/4/stw**2*vpaup-1d0/8/stw**2*vpaup**2
     & /qs*mw**2-1d0/8/stw**2*vpaup**2-4/qs**2*mw**4-1d0/8/qs*mw**2/rwz+
     & 8d0/3/qs*mw**2+4/qs*mw**2*rwz-17d0/72/rwz-2*pizgfer+caldzfer-za1f
     & er+1d0/4*vpaup/qs*mw**2/rwz+1d0/4*vpaup/rwz-1d0/8*vpaup**2/qs*mw*
     & *2/rwz-1d0/8*vpaup**2/rwz-1d0/8*vmael**2/rwz+1d0/4*qel*vmael/qs*m
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
