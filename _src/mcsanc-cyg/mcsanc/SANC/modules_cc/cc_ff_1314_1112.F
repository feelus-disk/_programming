************************************************************************
* sanc_cc_v1.40 package.
************************************************************************
* File (cc_ff_1314_1112.F) is created on Tue Aug  9 22:35:22 MSD 2011.
************************************************************************
* This is the FORTRAN module (cc_ff_1314_1112) to calculate 1-loop EW
* form factors for the anti-up + dn -> en + el^- process.
*
* It is produced by s2n package of SANC (v1.10) Project.
* Copyright (C), SANC Project Team, 2002-2011.
*
* http://sanc.jinr.ru/
* http://pcphsanc.cern.ch/
* E-mail: <sanc@jinr.ru>
************************************************************************
      subroutine cc_ff_1314_1112 (qs,ts,us)
      implicit none!
#include "looptools.h"
#include "s2n_declare.h"

      complex*16 ff_ew_ll,ff_ew_ld,ff_ew_rd

      real*8 a0fw,a0fz,a0fh
      complex*16 b0fqswz,b0fqswh,b0fqscw,b0fqscc,b0ftscc
      complex*16 c0ccqswcz,c0ccqsczc,c0cctscwc,c0cctsczc,c0ccuscwc
      complex*16 d0ccccqstswczc,d0ccccqsuswczc
      complex*16 javsubqstsccw,javsubqsusccw
      complex*16 propwqs,propiwqs

      common/unibos_bos/za1bos,zmzzzbos,zmwzwbos,zmhzhbos,deltarhobos
      common/unibos_fer/za1fer,zz1fer,zh1fer,zw1fer,zmsqrfer,
     & zmzzzfer,zmwzwfer,zmhzhfer,deltarhofer,tadfer
      common/unipro_fer/caldzfer,caldwfer,pizgfer,piggfer

      cmw2 = mw2

      propiwqs = (cmw2+qs)
      propwqs = 1d0/propiwqs
      a0fw = log(rwm2/thmu2) - 1d0
      a0fz = log(rzm2/thmu2) - 1d0
      a0fh = log(rhm2/thmu2) - 1d0
      b0fqswz = b0f(qs,thmu2,wm2,zm2)
      b0fqswh = b0f(qs,thmu2,wm2,hm2)
      b0fqscw = b0f(qs,thmu2,cm2,mw2)
      b0fqscc = b0f(qs,thmu2,cm2,cm2)
      b0ftscc = b0f(ts,thmu2,cm2,cm2)
      c0ccqswcz = c01(0d0,0d0,qs,wm2,cm2,zm2)
      c0ccqsczc = c01(0d0,0d0,qs,cm2,zm2,cm2)
      c0cctscwc = c01(0d0,0d0,ts,cm2,wm2,cm2)
      c0cctsczc = c01(0d0,0d0,ts,cm2,zm2,cm2)
      c0ccuscwc = c01(0d0,0d0,us,cm2,wm2,cm2)
      d0ccccqstswczc = d040wz(qs,ts,wm2,zm2)
      d0ccccqsuswczc = d040wz(qs,us,wm2,zm2)
      javsubqstsccw = javsub(qs,ts,cm2,cm2,mw2)
      javsubqsusccw = javsub(qs,us,cm2,cm2,mw2)

      ff_ew_ll =
     & +propwqs*a0fw*(-1d0/12/ctw**2*mw**2-1d0/12*mh**2-5*mw**2+3*mw**4/
     & mh**2)
     & +propwqs*a0fz*(1d0/12/ctw**4*mw**2+3d0/2/ctw**4*mw**4/mh**2+2d0/3
     & /ctw**2*mw**2-2*mw**2)
     & +propwqs*a0fh*(-1d0/12/qs*mh**4+1d0/2*mh**2)
     & +propwqs*b0fqswz*(1d0/12/ctw**4*mw**2+4d0/3/ctw**2*mw**2-17d0/3*m
     & w**2-4*ctw**2*mw**2)
     & +propwqs*b0fqswh*(-1d0/12/qs*mh**4-1d0/3*mh**2+mw**2)
     & +propwqs*b0fqscw*(-4*mw**2+4*ctw**2*mw**2)
     & +propwqs*(1d0/ctw**4*mw**4/mh**2-1d0/6/ctw**2*mw**2-1d0/6*mh**2-6
     & 4d0/9*mw**2-mw**2*zmwzwbos+2*mw**4/mh**2)
     & +d0ccccqstswczc*(-1d0/4/ctw**6*vpael*vpadn*ts/us**2*mw**6-1d0/4/c
     & tw**6*vpael*vpadn*qs*ts/us**2*mw**4-1d0/4/ctw**6*vpaen*vpaup*ts/u
     & s**2*mw**6-1d0/4/ctw**6*vpaen*vpaup*qs*ts/us**2*mw**4-1d0/2/ctw**
     & 4*vpael*vpadn/us*mw**6-1d0/2/ctw**4*vpael*vpadn*ts/us**2*mw**6+1d
     & 0/2/ctw**4*vpael*vpadn*ts**2/us**2*mw**4-1d0/2/ctw**4*vpael*vpadn
     & *qs/us*mw**4-1d0/2/ctw**4*vpael*vpadn*qs*ts/us**2*mw**4+1d0/2/ctw
     & **4*vpael*vpadn*qs*ts**2/us**2*mw**2-1d0/2/ctw**4*vpaen*vpaup/us*
     & mw**6-1d0/2/ctw**4*vpaen*vpaup*ts/us**2*mw**6+1d0/2/ctw**4*vpaen*
     & vpaup*ts**2/us**2*mw**4-1d0/2/ctw**4*vpaen*vpaup*qs/us*mw**4-1d0/
     & 2/ctw**4*vpaen*vpaup*qs*ts/us**2*mw**4+1d0/2/ctw**4*vpaen*vpaup*q
     & s*ts**2/us**2*mw**2-1d0/4/ctw**2*vpael*vpadn*ts/us**2*mw**6-1d0/4
     & /ctw**2*vpael*vpadn*ts*mw**2+1d0/2/ctw**2*vpael*vpadn*ts**2/us**2
     & *mw**4-1d0/4/ctw**2*vpael*vpadn*ts**3/us**2*mw**2-1d0/4/ctw**2*vp
     & ael*vpadn*qs*ts/us**2*mw**4-1d0/4/ctw**2*vpael*vpadn*qs*ts+1d0/2/
     & ctw**2*vpael*vpadn*qs*ts**2/us**2*mw**2-1d0/4/ctw**2*vpael*vpadn*
     & qs*ts**3/us**2-1d0/4/ctw**2*vpaen*vpaup*ts/us**2*mw**6-1d0/4/ctw*
     & *2*vpaen*vpaup*ts*mw**2+1d0/2/ctw**2*vpaen*vpaup*ts**2/us**2*mw**
     & 4-1d0/4/ctw**2*vpaen*vpaup*ts**3/us**2*mw**2-1d0/4/ctw**2*vpaen*v
     & paup*qs*ts/us**2*mw**4-1d0/4/ctw**2*vpaen*vpaup*qs*ts+1d0/2/ctw**
     & 2*vpaen*vpaup*qs*ts**2/us**2*mw**2-1d0/4/ctw**2*vpaen*vpaup*qs*ts
     & **3/us**2)
     & +d0ccccqsuswczc*(-1d0/2/ctw**2*vpael*vpaup*ts*mw**2-1d0/2/ctw**2*
     & vpael*vpaup*qs*mw**2-1d0/2/ctw**2*vpael*vpaup*qs*ts-1d0/2/ctw**2*
     & vpael*vpaup*qs**2-1d0/2/ctw**2*vpaen*vpadn*ts*mw**2-1d0/2/ctw**2*
     & vpaen*vpadn*qs*mw**2-1d0/2/ctw**2*vpaen*vpadn*qs*ts-1d0/2/ctw**2*
     & vpaen*vpadn*qs**2)
     & +javsubqstsccw*(qel*qdn*ts/us**2*mw**4+qel*qdn*ts-2*qel*qdn*ts**2
     & /us**2*mw**2+qel*qdn*ts**3/us**2-ctw**2*qel*qdn*ts/us**2*mw**4-ct
     & w**2*qel*qdn*ts+2*ctw**2*qel*qdn*ts**2/us**2*mw**2-ctw**2*qel*qdn
     & *ts**3/us**2)
     & +javsubqsusccw*(2*qel*qup*ts+2*qel*qup*qs-2*ctw**2*qel*qup*ts-2*c
     & tw**2*qel*qup*qs)
     & +c0ccqswcz*(-1d0/2/ctw**4*vpael*vpadn/us*mw**4-1d0/2/ctw**4*vpael
     & *vpadn*ts/us**2*mw**4-1d0/2/ctw**4*vpael*vpadn*qs/us*mw**2-1d0/2/
     & ctw**4*vpael*vpadn*qs*ts/us**2*mw**2-1d0/2/ctw**4*vpaen*vpaup/us*
     & mw**4-1d0/2/ctw**4*vpaen*vpaup*ts/us**2*mw**4-1d0/2/ctw**4*vpaen*
     & vpaup*qs/us*mw**2-1d0/2/ctw**4*vpaen*vpaup*qs*ts/us**2*mw**2-1d0/
     & ctw**2*vpadn/qs*mw**4+1d0/ctw**2*vpadn*mw**2+1d0/ctw**2*vpaup/qs*
     & mw**4-1d0/ctw**2*vpaup*mw**2-1d0/ctw**2*vpael/qs*mw**4+1d0/ctw**2
     & *vpael*mw**2-1d0/2/ctw**2*vpael*vpadn/us*mw**4+1d0/2/ctw**2*vpael
     & *vpadn*mw**2-1d0/2/ctw**2*vpael*vpadn*ts/us**2*mw**4+1d0/2/ctw**2
     & *vpael*vpadn*ts**2/us**2*mw**2-1d0/2/ctw**2*vpael*vpadn*qs/us*mw*
     & *2+1d0/2/ctw**2*vpael*vpadn*qs-1d0/2/ctw**2*vpael*vpadn*qs*ts/us*
     & *2*mw**2+1d0/2/ctw**2*vpael*vpadn*qs*ts**2/us**2-1d0/ctw**2*vpael
     & *vpaup*mw**2-1d0/ctw**2*vpael*vpaup*qs+1d0/ctw**2*vpaen/qs*mw**4-
     & 1d0/ctw**2*vpaen*mw**2-1d0/ctw**2*vpaen*vpadn*mw**2-1d0/ctw**2*vp
     & aen*vpadn*qs-1d0/2/ctw**2*vpaen*vpaup/us*mw**4+1d0/2/ctw**2*vpaen
     & *vpaup*mw**2-1d0/2/ctw**2*vpaen*vpaup*ts/us**2*mw**4+1d0/2/ctw**2
     & *vpaen*vpaup*ts**2/us**2*mw**2-1d0/2/ctw**2*vpaen*vpaup*qs/us*mw*
     & *2+1d0/2/ctw**2*vpaen*vpaup*qs-1d0/2/ctw**2*vpaen*vpaup*qs*ts/us*
     & *2*mw**2+1d0/2/ctw**2*vpaen*vpaup*qs*ts**2/us**2+vpadn*mw**2-vpau
     & p*mw**2+vpael*mw**2-vpaen*mw**2)
     & +c0ccqsczc*(-1d0/2/ctw**6*vpaup*vpadn/qs*mw**4-1d0/2/ctw**6*vpaen
     & *vpael/qs*mw**4+1d0/ctw**4*vpaup*vpadn*mw**2+1d0/ctw**4*vpaen*vpa
     & el*mw**2-1d0/2/ctw**2*vpaup*vpadn*qs-1d0/2/ctw**2*vpaen*vpael*qs)
     & 
     & +c0cctscwc*(1d0/4/ctw**4*vpael*vpadn*ts/us**2*mw**4+1d0/4/ctw**4*
     & vpael*vpadn*qs*ts/us**2*mw**2+1d0/4/ctw**4*vpaen*vpaup*ts/us**2*m
     & w**4+1d0/4/ctw**4*vpaen*vpaup*qs*ts/us**2*mw**2+1d0/4/ctw**2*vpae
     & l*vpadn*ts/us**2*mw**4+1d0/4/ctw**2*vpael*vpadn*ts/us*mw**2-1d0/4
     & /ctw**2*vpael*vpadn*ts**2/us**2*mw**2+1d0/4/ctw**2*vpael*vpadn*qs
     & *ts/us**2*mw**2+1d0/4/ctw**2*vpael*vpadn*qs*ts/us-1d0/4/ctw**2*vp
     & ael*vpadn*qs*ts**2/us**2+1d0/4/ctw**2*vpaen*vpaup*ts/us**2*mw**4+
     & 1d0/4/ctw**2*vpaen*vpaup*ts/us*mw**2-1d0/4/ctw**2*vpaen*vpaup*ts*
     & *2/us**2*mw**2+1d0/4/ctw**2*vpaen*vpaup*qs*ts/us**2*mw**2+1d0/4/c
     & tw**2*vpaen*vpaup*qs*ts/us-1d0/4/ctw**2*vpaen*vpaup*qs*ts**2/us**
     & 2+2*qel*qdn*ts/us**2*mw**4+qel*qdn*ts/us*mw**2+qel*qdn*ts-3*qel*q
     & dn*ts**2/us**2*mw**2+qel*qdn*ts**3/us**2+qel*qdn*qs*ts/us**2*mw**
     & 2+qel*qdn*qs*ts/us-qel*qdn*qs*ts**2/us**2-2*ctw**2*qel*qdn*ts/us*
     & *2*mw**4-ctw**2*qel*qdn*ts/us*mw**2-ctw**2*qel*qdn*ts+3*ctw**2*qe
     & l*qdn*ts**2/us**2*mw**2-ctw**2*qel*qdn*ts**3/us**2-ctw**2*qel*qdn
     & *qs*ts/us**2*mw**2-ctw**2*qel*qdn*qs*ts/us+ctw**2*qel*qdn*qs*ts**
     & 2/us**2)
     & +c0cctsczc*(1d0/4/ctw**4*vpael*vpadn*ts/us**2*mw**4+1d0/4/ctw**4*
     & vpael*vpadn*qs*ts/us**2*mw**2+1d0/4/ctw**4*vpaen*vpaup*ts/us**2*m
     & w**4+1d0/4/ctw**4*vpaen*vpaup*qs*ts/us**2*mw**2+1d0/4/ctw**2*vpae
     & l*vpadn*ts/us**2*mw**4+1d0/4/ctw**2*vpael*vpadn*ts/us*mw**2-1d0/4
     & /ctw**2*vpael*vpadn*ts**2/us**2*mw**2+1d0/4/ctw**2*vpael*vpadn*qs
     & *ts/us**2*mw**2+1d0/4/ctw**2*vpael*vpadn*qs*ts/us-1d0/4/ctw**2*vp
     & ael*vpadn*qs*ts**2/us**2+1d0/4/ctw**2*vpaen*vpaup*ts/us**2*mw**4+
     & 1d0/4/ctw**2*vpaen*vpaup*ts/us*mw**2-1d0/4/ctw**2*vpaen*vpaup*ts*
     & *2/us**2*mw**2+1d0/4/ctw**2*vpaen*vpaup*qs*ts/us**2*mw**2+1d0/4/c
     & tw**2*vpaen*vpaup*qs*ts/us-1d0/4/ctw**2*vpaen*vpaup*qs*ts**2/us**
     & 2)
     & +c0ccuscwc*(2*qel*qup*ts+2*qel*qup*qs-2*ctw**2*qel*qup*ts-2*ctw**
     & 2*qel*qup*qs)
     & +a0fw*(5+1d0/12/ctw**2/qs*mw**2+1d0/12/qs*mh**2-1d0/6/qs*mw**2-1d
     & 0/2*vpadn/qs*mw**2+vpadn+1d0/2*vpaup/qs*mw**2-vpaup-1d0/2*vpael/q
     & s*mw**2+vpael+1d0/2*vpaen/qs*mw**2-vpaen-qdn/qs*mw**2+2*qdn+qup/q
     & s*mw**2-2*qup-qel/qs*mw**2+2*qel+ctw**2*qdn/qs*mw**2-2*ctw**2*qdn
     & -ctw**2*qup/qs*mw**2+2*ctw**2*qup+ctw**2*qel/qs*mw**2-2*ctw**2*qe
     & l)
     & +a0fz*(-1d0/12/ctw**4/qs*mw**2+1d0/2/ctw**4*vpaup*vpadn/qs*mw**2+
     & 1d0/2/ctw**4*vpaen*vpael/qs*mw**2-7d0/12/ctw**2/qs*mw**2-1d0/2/ct
     & w**2*vpadn/qs*mw**2+1d0/8/ctw**2*vpadn**2+1d0/2/ctw**2*vpaup/qs*m
     & w**2-1d0/ctw**2*vpaup*vpadn+1d0/8/ctw**2*vpaup**2-1d0/2/ctw**2*vp
     & ael/qs*mw**2+1d0/8/ctw**2*vpael**2+1d0/2/ctw**2*vpaen/qs*mw**2-1d
     & 0/ctw**2*vpaen*vpael+1d0/8/ctw**2*vpaen**2+2d0/3/qs*mw**2+vpadn-v
     & paup+vpael-vpaen)
     & +a0fh*(1d0/12/qs*mh**2)
     & +b0fqswz*(-1d0/12-1d0/12/ctw**4/qs*mw**2-1d0/2/ctw**2/qs*mw**2-1d
     & 0/2/ctw**2*vpadn/qs*mw**2+1d0/2/ctw**2*vpaup/qs*mw**2-1d0/2/ctw**
     & 2*vpael/qs*mw**2-1d0/2/ctw**2*vpael*vpadn/us*mw**2-1d0/2/ctw**2*v
     & pael*vpadn*qs/us+1d0/2/ctw**2*vpaen/qs*mw**2-1d0/2/ctw**2*vpaen*v
     & paup/us*mw**2-1d0/2/ctw**2*vpaen*vpaup*qs/us+5d0/4/qs*mw**2-1d0/2
     & *vpadn/qs*mw**2+1d0/2*vpadn+1d0/2*vpaup/qs*mw**2-1d0/2*vpaup-1d0/
     & 2*vpael/qs*mw**2+1d0/2*vpael+1d0/2*vpaen/qs*mw**2-1d0/2*vpaen-2d0
     & /3*ctw**2/qs*mw**2+10d0/3*ctw**2)
     & +b0fqswh*(-1d0/12+1d0/6/qs*mh**2-1d0/12/qs*mw**2)
     & +b0fqscw*(10d0/3-2d0/3/qs*mw**2-qdn/qs*mw**2+qdn+qup/qs*mw**2-qup
     & -qel/qs*mw**2+qel-2*qel*qdn/us*mw**2-2*qel*qdn*qs/us+2d0/3*ctw**2
     & /qs*mw**2-10d0/3*ctw**2+ctw**2*qdn/qs*mw**2-ctw**2*qdn-ctw**2*qup
     & /qs*mw**2+ctw**2*qup+ctw**2*qel/qs*mw**2-ctw**2*qel+2*ctw**2*qel*
     & qdn/us*mw**2+2*ctw**2*qel*qdn*qs/us)
     & +b0fqscc*(1d0/2/ctw**4*vpaup*vpadn/qs*mw**2+1d0/2/ctw**4*vpaen*vp
     & ael/qs*mw**2-3d0/4/ctw**2*vpaup*vpadn-3d0/4/ctw**2*vpaen*vpael-3*
     & qup*qdn+3*ctw**2*qup*qdn)
     & +b0ftscc*(1d0/2/ctw**2*vpael*vpadn/us*mw**2+1d0/2/ctw**2*vpael*vp
     & adn*qs/us+1d0/2/ctw**2*vpaen*vpaup/us*mw**2+1d0/2/ctw**2*vpaen*vp
     & aup*qs/us+2*qel*qdn/us*mw**2+2*qel*qdn*qs/us-2*ctw**2*qel*qdn/us*
     & mw**2-2*ctw**2*qel*qdn*qs/us)
     & +101d0/18+1d0/stw**2*ctw**2*deltarhofer+1d0/stw**2*ctw**2*deltarh
     & obos+3d0/16/ctw**2*vpadn**2-1d0/2/ctw**2*vpaup*vpadn+3d0/16/ctw**
     & 2*vpaup**2+3d0/16/ctw**2*vpael**2-1d0/2/ctw**2*vpaen*vpael+3d0/16
     & /ctw**2*vpaen**2+caldwfer-za1fer-za1bos-2*qdn-3d0/2*qdn**2+2*qup+
     & 2*qup*qdn-3d0/2*qup**2-2*qel-3d0/2*qel**2+2*ctw**2*qdn+3d0/2*ctw*
     & *2*qdn**2-2*ctw**2*qup-2*ctw**2*qup*qdn+3d0/2*ctw**2*qup**2+2*ctw
     & **2*qel+3d0/2*ctw**2*qel**2

      ff_ew_ld =
     & 0

      ff_ew_rd =
     & 0

      ffarray(1,1) = ff_ew_ll
      ffarray(1,2) = ff_ew_ld
      ffarray(1,3) = ff_ew_rd

      return
      end
