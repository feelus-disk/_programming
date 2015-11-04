************************************************************************
* sanc_cc_v1.40 package.
************************************************************************
* File (cc_ff_1413_2221.F) is created on Tue Aug  9 22:46:24 MSD 2011.
************************************************************************
* This is the FORTRAN module (cc_ff_1413_2221) to calculate 1-loop EW
* form factors for the anti-dn + up -> anti-bt + tp process.
*
* It is produced by s2n package of SANC (v1.10) Project.
* Copyright (C), SANC Project Team, 2002-2011.
*
* http://sanc.jinr.ru/
* http://pcphsanc.cern.ch/
* E-mail: <sanc@jinr.ru>
************************************************************************
      subroutine cc_ff_1413_2221 (qs,ts,us)
      implicit none!
#include "looptools.h"
#include "s2n_declare.h"

      complex*16 ff_ew_ll,ff_ew_lr,ff_ew_lld,ff_ew_lrd

      real*8 a0fw,a0fz,a0fh,a0ftp
      complex*16 b0ptpztp,b0ptphtp,b0ptpcw
      complex*16 b0fqswz,b0fqswh,b0fqswc,b0ftpwc,b0ftpztp,b0ftstpc,b0ft
     & scc,b0ftphtp,b0fqstpc,b0fqscc
      complex*16 c0ctptscwc,c0ctptscztp,c0ctpqswtpz,c0ctpqswtpc,c0ctpqs
     & zcw,c0ctpuscztp,c0ccqswcz,c0cctscwtp,c0cctsczc,c0ccuscwtp,c0ctpqs
     & wtph,c0ctpqscztp,c0ccqsczc
      complex*16 d0cctpcqstswcztp,d0cctpcqstszcwc,d0ccctpqsuswczc,d0ccc
     & tpqsuszcwtp
      complex*16 jawsubsubqststpcw,jawsubsubqstsctpw,jawsubsubqsustpcw,
     & jawsubsubqsusctpw
      real*8 sdet3ictpts,sdet3ictpqs
      real*8 invftpw
      complex*16 propwqs,propiwqs

      common/unibos_bos/za1bos,zmzzzbos,zmwzwbos,zmhzhbos,deltarhobos
      common/unibos_fer/za1fer,zz1fer,zh1fer,zw1fer,zmsqrfer,
     & zmzzzfer,zmwzwfer,zmhzhfer,deltarhofer,tadfer
      common/unipro_fer/caldzfer,caldwfer,pizgfer,piggfer

      cmw2 = rwm2

      propiwqs = (cmw2+qs)
      propwqs = 1d0/propiwqs
      a0fw = log(rwm2/thmu2) - 1d0
      a0fz = log(rzm2/thmu2) - 1d0
      a0fh = log(rhm2/thmu2) - 1d0
      a0ftp = log(rtpm2/thmu2) - 1d0
      b0ptpztp = b0p(-rtpm2,zm2,tpm2)
      b0ptphtp = b0p(-rtpm2,hm2,tpm2)
      b0ptpcw = b0p(-rtpm2,cm2,wm2)
      b0fqswz = b0f(qs,thmu2,wm2,zm2)
      b0fqswh = b0f(qs,thmu2,wm2,hm2)
      b0fqswc = b0f(qs,thmu2,wm2,cm2)
      b0ftpwc = b0f(-rtpm2,thmu2,wm2,cm2)
      b0ftpztp = b0f(-rtpm2,thmu2,zm2,tpm2)
      b0ftstpc = b0f(ts,thmu2,tpm2,cm2)
      b0ftscc = b0f(ts,thmu2,cm2,cm2)
      b0ftphtp = b0f(-rtpm2,thmu2,hm2,tpm2)
      b0fqstpc = b0f(qs,thmu2,tpm2,cm2)
      b0fqscc = b0f(qs,thmu2,cm2,cm2)
      c0ctptscwc = -c0(0d0,rtpm2,-ts,0d0,rwm2,0d0)
      c0ctptscztp = -c0(0d0,rtpm2,-ts,0d0,rzm2,rtpm2)
      c0ctpqswtpz = -c0(0d0,rtpm2,-qs,rwm2,rtpm2,rzm2)
      c0ctpqswtpc = -c0(0d0,rtpm2,-qs,rwm2,rtpm2,0d0)
      c0ctpqszcw = -c0(0d0,rtpm2,-qs,rzm2,0d0,rwm2)
      c0ctpuscztp = -c0(0d0,rtpm2,-us,0d0,rzm2,rtpm2)
      c0ccqswcz = -c0(0d0,0d0,-qs,rwm2,0d0,rzm2)
      c0cctscwtp = -c0(0d0,0d0,-ts,0d0,rwm2,rtpm2)
      c0cctsczc = -c0(0d0,0d0,-ts,0d0,rzm2,0d0)
      c0ccuscwtp = -c0(0d0,0d0,-us,0d0,rwm2,rtpm2)
      c0ctpqswtph = -c0(0d0,rtpm2,-qs,rwm2,rtpm2,rhm2)
      c0ctpqscztp = -c0(0d0,rtpm2,-qs,0d0,rzm2,rtpm2)
      c0ccqsczc = -c0(0d0,0d0,-qs,0d0,rzm2,0d0)
      d0cctpcqstswcztp =
     & d0(0d0,0d0,rtpm2,0d0,-qs,-ts,rwm2,0d0,rzm2,rtpm2)
      d0cctpcqstszcwc =
     & d0(0d0,0d0,rtpm2,0d0,-qs,-ts,rzm2,0d0,rwm2,0d0)
      d0ccctpqsuswczc =
     & d0(0d0,0d0,0d0,rtpm2,-qs,-us,rwm2,0d0,rzm2,0d0)
      d0ccctpqsuszcwtp =
     & d0(0d0,0d0,0d0,rtpm2,-qs,-us,rzm2,0d0,rwm2,rtpm2)
      jawsubsubqststpcw = jaw_udtb_subsub2(qs,ts,rtpm2,0d0,rwm2)
      jawsubsubqstsctpw = jaw_udtb_subsub1(qs,ts,0d0,rtpm2,rwm2)
      jawsubsubqsustpcw = jaw_udtb_subsub2(qs,us,rtpm2,0d0,rwm2)
      jawsubsubqsusctpw = jaw_udtb_subsub1(qs,us,0d0,rtpm2,rwm2)
      sdet3ictpts = 1d0/(ts+(mtp)**2)
      sdet3ictpqs = 1d0/(qs+(mtp)**2)
      invftpw = 1d0/(1d0-rtpm2/rwm2)

      ff_ew_ll =
     & +1d0/stw**2*(ctw**2*deltarhofer+ctw**2*deltarhobos)
     & +qbt*(-2+2*ctw**2)
     & +qbt**2*(-3d0/2+3d0/2*ctw**2)
     & +qtp*(2-2*ctw**2)
     & +qtp*qbt*(2-2*ctw**2)
     & +qtp**2*(-3d0/2+3d0/2*ctw**2)
     & +qdn*(-2+2*ctw**2)
     & +qdn**2*(-3d0/2+3d0/2*ctw**2)
     & +qup*(2-2*ctw**2)
     & +qup*qdn*(2-2*ctw**2)
     & +qup**2*(-3d0/2+3d0/2*ctw**2)
     & +propwqs*a0fw*(-1d0/12/ctw**2*mw**2-1d0/12*mh**2-5*mw**2+3*mw**4/
     & mh**2)
     & +propwqs*a0fz*(1d0/12/ctw**4*mw**2+3d0/2/ctw**4*mw**4/mh**2+2d0/3
     & /ctw**2*mw**2-2*mw**2)
     & +propwqs*a0fh*(1d0/12/mw**2*mh**4+1d0/2*mh**2)
     & +propwqs*b0fqswz*(1d0/12/ctw**4*mw**2+4d0/3/ctw**2*mw**2-17d0/3*m
     & w**2-4*ctw**2*mw**2)
     & +propwqs*b0fqswh*(1d0/12/mw**2*mh**4-1d0/3*mh**2+mw**2)
     & +propwqs*b0fqswc*(-4*mw**2+4*ctw**2*mw**2)
     & +propwqs*(1d0/ctw**4*mw**4/mh**2-1d0/6/ctw**2*mw**2-1d0/6*mh**2-6
     & 4d0/9*mw**2-mw**2*zmwzwbos+2*mw**4/mh**2)
     & +propiwqs*sdet3ictpts*qup*qtp*(2/us*mtp**2-2*ctw**2/us*mtp**2)
     & +propiwqs*sdet3ictpts*c0ctptscwc*qdn*qbt*(2/us*mw**2*mtp**2-2*ctw
     & **2/us*mw**2*mtp**2)
     & +propiwqs*sdet3ictpts*c0ctptscwc*(1d0/2/ctw**2*vpadn*vpabt/us*mw*
     & *2*mtp**2)
     & +propiwqs*sdet3ictpts*c0ctptscztp*(1d0/2/ctw**4*vpaup*vpatp/us*mw
     & **2*mtp**2)
     & +propiwqs*sdet3ictpts*a0ftp*qup*qtp*(-2/us*mtp**2+2*ctw**2/us*mtp
     & **2)
     & +propiwqs*sdet3ictpts*b0ftpwc*qdn*qbt*(2/us*mtp**2-2*ctw**2/us*mt
     & p**2)
     & +propiwqs*sdet3ictpts*b0ftpwc*(1d0/2/ctw**2*vpadn*vpabt/us*mtp**2
     & )
     & +propiwqs*sdet3ictpts*b0ftpztp*(1d0/2/ctw**2*vpaup*vpatp/us*mtp**
     & 2)
     & +propiwqs*sdet3ictpts*b0ftstpc*qup*qtp*(-2/us*mtp**2+2*ctw**2/us*
     & mtp**2)
     & +propiwqs*sdet3ictpts*b0ftstpc*(-1d0/2/ctw**2*vpaup*vpatp/us*mtp*
     & *2)
     & +propiwqs*sdet3ictpts*b0ftscc*qdn*qbt*(-2/us*mtp**2+2*ctw**2/us*m
     & tp**2)
     & +propiwqs*sdet3ictpts*b0ftscc*(-1d0/2/ctw**2*vpadn*vpabt/us*mtp**
     & 2)
     & +propiwqs*d0cctpcqstswcztp*(1d0/4/ctw**6*vpaup*vpatp/qs/us**2*mw*
     & *4*mtp**4+1d0/4/ctw**6*vpaup*vpatp/qs/us*mw**4*mtp**2+1d0/4/ctw**
     & 6*vpaup*vpatp/us**2*mw**4*mtp**2-1d0/4/ctw**6*vpaup*vpatp*ts/us**
     & 2*mw**4-1d0/4/ctw**4*vpaup*vmatp/qs/us*mw**2*mtp**4-1d0/4/ctw**4*
     & vpaup*vmatp/qs*mw**2*mtp**2-1d0/4/ctw**4*vpaup*vmatp/us*mw**2*mtp
     & **2+1d0/4/ctw**4*vpaup*vpatp/qs/us*mw**2*mtp**4-1d0/4/ctw**4*vpau
     & p*vpatp/qs/us*mw**4*mtp**2+1d0/4/ctw**4*vpaup*vpatp/qs*mw**2*mtp*
     & *2+1d0/2/ctw**4*vpaup*vpatp/us*mw**2*mtp**2-1d0/2/ctw**4*vpaup*vp
     & atp/us*mw**4+1d0/2/ctw**4*vpaup*vpatp*ts/us**2*mw**2*mtp**2-1d0/2
     & /ctw**4*vpaup*vpatp*ts/us**2*mw**4+1d0/2/ctw**4*vpaup*vpatp*ts**2
     & /us**2*mw**2+1d0/4/ctw**2*vpaup*vmatp/qs*mw**2*mtp**2+1d0/4/ctw**
     & 2*vpaup*vmatp/us*mtp**4-1d0/4/ctw**2*vpaup*vmatp/us*mw**2*mtp**2+
     & 1d0/4/ctw**2*vpaup*vmatp*ts/us*mtp**2-1d0/4/ctw**2*vpaup*vpatp/qs
     & *mw**2*mtp**2-1d0/4/ctw**2*vpaup*vpatp/us**2*mtp**6+1d0/2/ctw**2*
     & vpaup*vpatp/us**2*mw**2*mtp**4-1d0/4/ctw**2*vpaup*vpatp/us**2*mw*
     & *4*mtp**2-1d0/4/ctw**2*vpaup*vpatp/us*mtp**4+1d0/4/ctw**2*vpaup*v
     & patp/us*mw**2*mtp**2-1d0/4/ctw**2*vpaup*vpatp*mtp**2-3d0/4/ctw**2
     & *vpaup*vpatp*ts/us**2*mtp**4+1d0/ctw**2*vpaup*vpatp*ts/us**2*mw**
     & 2*mtp**2-1d0/4/ctw**2*vpaup*vpatp*ts/us**2*mw**4-1d0/4/ctw**2*vpa
     & up*vpatp*ts/us*mtp**2-1d0/4/ctw**2*vpaup*vpatp*ts-3d0/4/ctw**2*vp
     & aup*vpatp*ts**2/us**2*mtp**2+1d0/2/ctw**2*vpaup*vpatp*ts**2/us**2
     & *mw**2-1d0/4/ctw**2*vpaup*vpatp*ts**3/us**2)
     & +propiwqs*d0cctpcqstszcwc*(-1d0/4/ctw**6*vpadn*vpabt/us**2*mw**4*
     & mtp**2-1d0/4/ctw**6*vpadn*vpabt*ts/us**2*mw**4-1d0/4/ctw**4*vpadn
     & *vpabt/qs/us*mw**4*mtp**2-1d0/4/ctw**4*vpadn*vpabt/qs*mw**2*mtp**
     & 2-1d0/2/ctw**4*vpadn*vpabt/us*mw**4+1d0/2/ctw**4*vpadn*vpabt*ts/u
     & s**2*mw**2*mtp**2-1d0/2/ctw**4*vpadn*vpabt*ts/us**2*mw**4+1d0/2/c
     & tw**4*vpadn*vpabt*ts**2/us**2*mw**2+1d0/4/ctw**2*vpadn*vpabt/qs/u
     & s**2*mw**4*mtp**4+1d0/4/ctw**2*vpadn*vpabt/qs/us*mw**2*mtp**4+1d0
     & /4/ctw**2*vpadn*vpabt/qs/us*mw**4*mtp**2+1d0/4/ctw**2*vpadn*vpabt
     & /qs*mw**2*mtp**2+1d0/4/ctw**2*vpadn*vpabt/us**2*mw**4*mtp**2+1d0/
     & 4/ctw**2*vpadn*vpabt/us*mw**2*mtp**2-1d0/4/ctw**2*vpadn*vpabt*ts/
     & us**2*mw**4-1d0/4/ctw**2*vpadn*vpabt*ts-1d0/4/ctw**2*vpadn*vpabt*
     & ts**2/us**2*mtp**2+1d0/2/ctw**2*vpadn*vpabt*ts**2/us**2*mw**2-1d0
     & /4/ctw**2*vpadn*vpabt*ts**3/us**2)
     & +propiwqs*d0ccctpqsuswczc*(1d0/2/ctw**2*vpaup*vpabt*us)
     & +propiwqs*d0ccctpqsuszcwtp*(-1d0/4/ctw**4*vpadn*vmatp/qs*mw**2*mt
     & p**2+1d0/4/ctw**2*vpadn*vmatp/qs/us*mw**2*mtp**4+1d0/4/ctw**2*vpa
     & dn*vmatp/qs*mw**2*mtp**2+1d0/4/ctw**2*vpadn*vmatp/us*mtp**4+1d0/4
     & /ctw**2*vpadn*vmatp*mtp**2+1d0/2/ctw**2*vpadn*vpatp*mtp**2+1d0/2/
     & ctw**2*vpadn*vpatp*us)
     & +propiwqs*c0ctpqswtpz*(1d0/4/ctw**4*vpaup*vpatp/qs/us**2*mw**2*mt
     & p**4+1d0/4/ctw**4*vpaup*vpatp/us**2*mw**2*mtp**2-1d0/4/ctw**4*vpa
     & up*vpatp/us*mw**2-1d0/4/ctw**4*vpaup*vpatp*ts/us**2*mw**2+1d0/4/c
     & tw**2*vpadn*vmatp/qs/us*mtp**4+1d0/4/ctw**2*vpadn*vmatp/us*mtp**2
     & -1d0/2/ctw**2*vpadn*vpatp-1d0/4/ctw**2*vpaup*vmatp/qs/us*mtp**4-1
     & d0/4/ctw**2*vpaup*vmatp/us*mtp**2+1d0/4/ctw**2*vpaup*vpatp/qs/us*
     & mtp**4+1d0/2/ctw**2*vpaup*vpatp/us*mtp**2-1d0/4/ctw**2*vpaup*vpat
     & p/us*mw**2+1d0/4/ctw**2*vpaup*vpatp+1d0/4/ctw**2*vpaup*vpatp*ts/u
     & s**2*mtp**2-1d0/4/ctw**2*vpaup*vpatp*ts/us**2*mw**2+1d0/4/ctw**2*
     & vpaup*vpatp*ts**2/us**2)
     & +propiwqs*c0ctpqswtpc*qdn*qtp*(-2+1d0/qs/us*mtp**4+1d0/us*mtp**2-
     & ctw**2/qs/us*mtp**4-ctw**2/us*mtp**2+2*ctw**2)
     & +propiwqs*c0ctpqswtpc*qup*qtp*(1+1d0/us*mtp**2-1d0/us*mw**2+ts/us
     & **2*mtp**2-ts/us**2*mw**2+ts**2/us**2-ctw**2/us*mtp**2+ctw**2/us*
     & mw**2-ctw**2-ctw**2*ts/us**2*mtp**2+ctw**2*ts/us**2*mw**2-ctw**2*
     & ts**2/us**2)
     & +propiwqs*c0ctpqszcw*(-1d0/4/ctw**4*vpadn*vpabt/us*mw**2-1d0/4/ct
     & w**4*vpadn*vpabt*ts/us**2*mw**2+1d0/4/ctw**2*vpadn*vpabt/qs/us**2
     & *mw**2*mtp**4+1d0/4/ctw**2*vpadn*vpabt/qs/us*mtp**4+1d0/4/ctw**2*
     & vpadn*vpabt/us**2*mw**2*mtp**2+1d0/4/ctw**2*vpadn*vpabt/us*mtp**2
     & -1d0/4/ctw**2*vpadn*vpabt/us*mw**2+1d0/4/ctw**2*vpadn*vpabt-1d0/4
     & /ctw**2*vpadn*vpabt*ts/us**2*mw**2+1d0/4/ctw**2*vpadn*vpabt*ts**2
     & /us**2-1d0/2/ctw**2*vpaup*vpabt)
     & +propiwqs*c0ctptscwc*qdn*qbt*(1d0/qs/us*mw**2*mtp**2+1d0/qs*mtp**
     & 2-ts/us**2*mtp**2+ts/us**2*mw**2+ts/us-ts**2/us**2-ctw**2/qs/us*m
     & w**2*mtp**2-ctw**2/qs*mtp**2+ctw**2*ts/us**2*mtp**2-ctw**2*ts/us*
     & *2*mw**2-ctw**2*ts/us+ctw**2*ts**2/us**2)
     & +propiwqs*c0ctptscwc*(1d0/4/ctw**4*vpadn*vpabt/us**2*mw**2*mtp**2
     & +1d0/4/ctw**4*vpadn*vpabt*ts/us**2*mw**2+1d0/4/ctw**2*vpadn*vpabt
     & /qs/us*mw**2*mtp**2+1d0/4/ctw**2*vpadn*vpabt/qs*mtp**2-1d0/4/ctw*
     & *2*vpadn*vpabt*ts/us**2*mtp**2+1d0/4/ctw**2*vpadn*vpabt*ts/us**2*
     & mw**2+1d0/4/ctw**2*vpadn*vpabt*ts/us-1d0/4/ctw**2*vpadn*vpabt*ts*
     & *2/us**2)
     & +propiwqs*c0ctptscztp*(1d0/4/ctw**4*vpaup*vpatp/qs/us*mw**2*mtp**
     & 2+1d0/4/ctw**4*vpaup*vpatp*ts/us**2*mw**2-1d0/4/ctw**2*vpaup*vmat
     & p/qs*mtp**2+1d0/4/ctw**2*vpaup*vmatp/us*mtp**2+1d0/4/ctw**2*vpaup
     & *vpatp/qs*mtp**2-1d0/4/ctw**2*vpaup*vpatp/us**2*mtp**4+1d0/4/ctw*
     & *2*vpaup*vpatp/us**2*mw**2*mtp**2-1d0/2/ctw**2*vpaup*vpatp*ts/us*
     & *2*mtp**2+1d0/4/ctw**2*vpaup*vpatp*ts/us**2*mw**2+1d0/4/ctw**2*vp
     & aup*vpatp*ts/us-1d0/4/ctw**2*vpaup*vpatp*ts**2/us**2)
     & +propiwqs*c0ctpuscztp*(-1d0/4/ctw**2*vpadn*vmatp/qs/us*mtp**4-1d0
     & /4/ctw**2*vpadn*vmatp/qs*mtp**2)
     & +propiwqs*c0ccqswcz*(-1d0/4/ctw**4*vpadn*vpabt/us**2*mw**2*mtp**2
     & -1d0/4/ctw**4*vpadn*vpabt/us*mw**2-1d0/4/ctw**4*vpadn*vpabt*ts/us
     & **2*mw**2-1d0/4/ctw**4*vpaup*vpatp/us*mw**2-1d0/4/ctw**4*vpaup*vp
     & atp*ts/us**2*mw**2-1d0/4/ctw**2*vpadn*vpabt/us*mw**2+1d0/4/ctw**2
     & *vpadn*vpabt+1d0/4/ctw**2*vpadn*vpabt*ts/us**2*mtp**2-1d0/4/ctw**
     & 2*vpadn*vpabt*ts/us**2*mw**2+1d0/4/ctw**2*vpadn*vpabt*ts**2/us**2
     & -1d0/4/ctw**2*vpadn*vmatp/us*mtp**2-1d0/2/ctw**2*vpadn*vpatp-1d0/
     & 2/ctw**2*vpaup*vpabt-1d0/4/ctw**2*vpaup*vmatp/us*mtp**2+1d0/4/ctw
     & **2*vpaup*vpatp/us**2*mtp**4-1d0/4/ctw**2*vpaup*vpatp/us**2*mw**2
     & *mtp**2+1d0/4/ctw**2*vpaup*vpatp/us*mtp**2-1d0/4/ctw**2*vpaup*vpa
     & tp/us*mw**2+1d0/4/ctw**2*vpaup*vpatp+1d0/2/ctw**2*vpaup*vpatp*ts/
     & us**2*mtp**2-1d0/4/ctw**2*vpaup*vpatp*ts/us**2*mw**2+1d0/4/ctw**2
     & *vpaup*vpatp*ts**2/us**2)
     & +propiwqs*c0cctscwtp*qup*qtp*(-ts/us**2*mtp**2+ts/us**2*mw**2+ts/
     & us-ts**2/us**2+ctw**2*ts/us**2*mtp**2-ctw**2*ts/us**2*mw**2-ctw**
     & 2*ts/us+ctw**2*ts**2/us**2)
     & +propiwqs*c0cctscwtp*(-1d0/4/ctw**4*vpaup*vpatp/qs/us**2*mw**2*mt
     & p**4-1d0/4/ctw**4*vpaup*vpatp/qs/us*mw**2*mtp**2-1d0/4/ctw**4*vpa
     & up*vpatp/us**2*mw**2*mtp**2+1d0/4/ctw**4*vpaup*vpatp*ts/us**2*mw*
     & *2+1d0/4/ctw**2*vpaup*vmatp/qs/us*mtp**4+1d0/4/ctw**2*vpaup*vmatp
     & /qs*mtp**2+1d0/4/ctw**2*vpaup*vmatp/us*mtp**2-1d0/4/ctw**2*vpaup*
     & vpatp/qs/us*mtp**4-1d0/4/ctw**2*vpaup*vpatp/qs*mtp**2-1d0/4/ctw**
     & 2*vpaup*vpatp/us*mtp**2-1d0/4/ctw**2*vpaup*vpatp*ts/us**2*mtp**2+
     & 1d0/4/ctw**2*vpaup*vpatp*ts/us**2*mw**2+1d0/4/ctw**2*vpaup*vpatp*
     & ts/us-1d0/4/ctw**2*vpaup*vpatp*ts**2/us**2)
     & +propiwqs*c0cctsczc*(1d0/4/ctw**4*vpadn*vpabt*ts/us**2*mw**2-1d0/
     & 4/ctw**2*vpadn*vpabt/qs/us**2*mw**2*mtp**4-1d0/4/ctw**2*vpadn*vpa
     & bt/qs/us*mtp**4-1d0/4/ctw**2*vpadn*vpabt/qs/us*mw**2*mtp**2-1d0/4
     & /ctw**2*vpadn*vpabt/qs*mtp**2-1d0/4/ctw**2*vpadn*vpabt/us**2*mw**
     & 2*mtp**2-1d0/4/ctw**2*vpadn*vpabt/us*mtp**2+1d0/4/ctw**2*vpadn*vp
     & abt*ts/us**2*mw**2+1d0/4/ctw**2*vpadn*vpabt*ts/us-1d0/4/ctw**2*vp
     & adn*vpabt*ts**2/us**2)
     & +propiwqs*c0ccuscwtp*qdn*qtp*(1d0/qs*mtp**2-ctw**2/qs*mtp**2)
     & +propiwqs*c0ccuscwtp*(1d0/4/ctw**2*vpadn*vmatp/qs*mtp**2)
     & +propiwqs*a0fw*(-31d0/6/qs+3/qs*mw**2/mh**2)
     & +propiwqs*a0fz*(3d0/2/ctw**4/qs*mw**2/mh**2+1d0/12/ctw**2/qs-4d0/
     & 3/qs)
     & +propiwqs*b0fqswz*(5d0/6/ctw**2/qs-1d0/2/ctw**2*vpadn*vpabt/us-1d
     & 0/2/ctw**2*vpaup*vpatp/us-53d0/12/qs-14d0/3*ctw**2/qs)
     & +propiwqs*b0fqswh*(11d0/12/qs)
     & +propiwqs*b0fqswc*qdn*qbt*(-2/us+2*ctw**2/us)
     & +propiwqs*b0fqswc*qup*qtp*(-2/us+2*ctw**2/us)
     & +propiwqs*b0fqswc*(-14d0/3/qs+14d0/3*ctw**2/qs)
     & +propiwqs*b0ftstpc*qup*qtp*(2/us-2*ctw**2/us)
     & +propiwqs*b0ftstpc*(1d0/2/ctw**2*vpaup*vpatp/us)
     & +propiwqs*b0ftscc*qdn*qbt*(2/us-2*ctw**2/us)
     & +propiwqs*b0ftscc*(1d0/2/ctw**2*vpadn*vpabt/us)
     & +propiwqs*(1d0/ctw**4/qs*mw**2/mh**2-1d0/6/ctw**2/qs-64d0/9/qs+2/
     & qs*mw**2/mh**2)
     & +sdet3ictpqs*qtp*qbt*(-2*mtp**2+2*ctw**2*mtp**2)
     & +sdet3ictpqs**2*qtp*(-2*mtp**4+2*mw**2*mtp**2+2*ctw**2*mtp**4-2*c
     & tw**2*mw**2*mtp**2)
     & +sdet3ictpqs**2*c0ctpqswtpz*(1d0/4*vmatp/mw**2*mtp**8-1d0/2*vmatp
     & *mtp**6+1d0/4*vmatp*mw**2*mtp**4-1d0/4*vpatp/mw**2*mtp**8-1d0/2*v
     & patp*mtp**6+7d0/4*vpatp*mw**2*mtp**4-vpatp*mw**4*mtp**2)
     & +sdet3ictpqs**2*c0ctpqswtph*(-1d0/4/mw**2*mtp**8+1d0/2*mtp**6-1d0
     & /4*mw**2*mtp**4)
     & +sdet3ictpqs**2*c0ctpqswtpc*qtp*(-2*mtp**6+4*mw**2*mtp**4-2*mw**4
     & *mtp**2+2*ctw**2*mtp**6-4*ctw**2*mw**2*mtp**4+2*ctw**2*mw**4*mtp*
     & *2)
     & +sdet3ictpqs**2*c0ctpqszcw*(1d0/ctw**4*vpabt*mw**4*mtp**2)
     & +sdet3ictpqs**2*c0ctpqscztp*(1d0/2/ctw**6*vpatp*vpabt*mw**4*mtp**
     & 2)
     & +sdet3ictpqs**2*a0ftp*qtp*(2*mtp**4-2*mw**2*mtp**2-2*ctw**2*mtp**
     & 4+2*ctw**2*mw**2*mtp**2)
     & +sdet3ictpqs**2*b0ftpwc*(-1d0/ctw**2*vpabt*mw**2*mtp**2)
     & +sdet3ictpqs**2*b0ftpztp*(1d0/2/ctw**4*vpatp*vpabt*mw**2*mtp**2+1
     & d0/4*vmatp/mw**2*mtp**6-1d0/4*vmatp*mtp**4-1d0/4*vpatp/mw**2*mtp*
     & *6-3d0/4*vpatp*mtp**4+vpatp*mw**2*mtp**2)
     & +sdet3ictpqs**2*b0ftphtp*(-1d0/4/mw**2*mtp**6+1d0/4*mtp**4)
     & +sdet3ictpqs**2*b0fqswz*(1d0/ctw**2*vpabt*mw**2*mtp**2-1d0/4*vmat
     & p/mw**2*mtp**6+1d0/4*vmatp*mtp**4+1d0/4*vpatp/mw**2*mtp**6+3d0/4*
     & vpatp*mtp**4-vpatp*mw**2*mtp**2)
     & +sdet3ictpqs**2*b0fqswh*(1d0/4/mw**2*mtp**6-1d0/4*mtp**4)
     & +sdet3ictpqs**2*b0fqswc*qtp*(2*mtp**4-2*mw**2*mtp**2-2*ctw**2*mtp
     & **4+2*ctw**2*mw**2*mtp**2)
     & +sdet3ictpqs**2*b0fqstpc*(-1d0/2/ctw**4*vpatp*vpabt*mw**2*mtp**2)
     & +sdet3ictpqs*c0ctpqswtpz*(-1d0/4/ctw**2*vmatp*mtp**4+1d0/4/ctw**2
     & *vmatp*mw**2*mtp**2-1d0/4/ctw**2*vpatp*mtp**4-3d0/4/ctw**2*vpatp*
     & mw**2*mtp**2+1d0/ctw**2*vpatp*mw**4-1d0/2*vmatp/mw**2*mtp**6+vmat
     & p*mtp**4-1d0/2*vmatp*mw**2*mtp**2+1d0/2*vpatp/mw**2*mtp**6-1d0/2*
     & vpatp*mw**2*mtp**2)
     & +sdet3ictpqs*c0ctpqswtph*(1d0/2/mw**2*mtp**6-1d0/4/mw**2*mh**2*mt
     & p**4+1d0/4*mh**2*mtp**2-1d0/2*mw**2*mtp**2)
     & +sdet3ictpqs*c0ctpqswtpc*qtp*(2*mtp**4-2*mw**2*mtp**2-2*ctw**2*mt
     & p**4+2*ctw**2*mw**2*mtp**2)
     & +sdet3ictpqs*c0ctpqszcw*(-1d0/2/ctw**4*vpabt*mw**2*mtp**2-1d0/ctw
     & **2*vpabt*mw**4)
     & +sdet3ictpqs*c0ctpqscztp*(-1d0/2/ctw**6*vpatp*vpabt*mw**4-1d0/2/c
     & tw**4*vpatp*vpabt*mw**2*mtp**2)
     & +sdet3ictpqs*a0fw*qtp*(mw**2-ctw**2*mw**2)
     & +sdet3ictpqs*a0fw*(1d0/8*mtp**2-1d0/8*vmatp*mtp**2+1d0/8*vpatp*mt
     & p**2+1d0/2*vpatp*mw**2)
     & +sdet3ictpqs*a0fz*(1d0/4/ctw**4*vpatp*vpabt*mw**2-1d0/2/ctw**2*vp
     & abt*mw**2)
     & +sdet3ictpqs*a0ftp*qtp*(-mtp**2+ctw**2*mtp**2)
     & +sdet3ictpqs*a0ftp*qtp*qbt*(2*mtp**2-2*ctw**2*mtp**2)
     & +sdet3ictpqs*a0ftp*(-1d0/8/mw**2*mtp**4+1d0/8*vmatp/mw**2*mtp**4-
     & 1d0/8*vpatp/mw**2*mtp**4-1d0/2*vpatp*mtp**2)
     & +sdet3ictpqs*b0ftpwc*qbt*(mtp**2+mw**2-ctw**2*mtp**2-ctw**2*mw**2
     & )
     & +sdet3ictpqs*b0ftpwc*(1d0/2/ctw**2*vpabt*mtp**2+1d0/2*vpabt*mtp**
     & 2+1d0/2*vpabt*mw**2)
     & +sdet3ictpqs*b0ftpztp*(-1d0/4/ctw**4*vpatp*vpabt*mw**2-3d0/8/ctw*
     & *2*vmatp*mtp**2-1d0/8/ctw**2*vpatp*mtp**2-1d0/2/ctw**2*vpatp*mw**
     & 2-1d0/2/ctw**2*vpatp*vpabt*mtp**2-1d0/4*vmatp/mw**2*mtp**4+1d0/2*
     & vmatp*mtp**2+1d0/4*vpatp/mw**2*mtp**4-1d0/2*vpatp*mtp**2)
     & +sdet3ictpqs*b0ftphtp*(1d0/4/mw**2*mtp**4-1d0/8/mw**2*mh**2*mtp**
     & 2+1d0/2*mtp**2)
     & +sdet3ictpqs*b0fqswz*(-1d0/2/ctw**2*vpabt*mtp**2-1d0/2/ctw**2*vpa
     & bt*mw**2+3d0/8/ctw**2*vmatp*mtp**2+1d0/8/ctw**2*vpatp*mtp**2+1d0/
     & 2/ctw**2*vpatp*mw**2-1d0/2*vpabt*mtp**2-1d0/2*vpabt*mw**2+3d0/8*v
     & matp/mw**2*mtp**4-5d0/8*vmatp*mtp**2-3d0/8*vpatp/mw**2*mtp**4+1d0
     & /8*vpatp*mtp**2+1d0/2*vpatp*mw**2)
     & +sdet3ictpqs*b0fqswh*(-3d0/8/mw**2*mtp**4+1d0/8/mw**2*mh**2*mtp**
     & 2-3d0/8*mtp**2)
     & +sdet3ictpqs*b0fqswc*qbt*(-mtp**2-mw**2+ctw**2*mtp**2+ctw**2*mw**
     & 2)
     & +sdet3ictpqs*b0fqswc*qtp*(-mtp**2+mw**2+ctw**2*mtp**2-ctw**2*mw**
     & 2)
     & +sdet3ictpqs*b0fqstpc*qtp*qbt*(2*mtp**2-2*ctw**2*mtp**2)
     & +sdet3ictpqs*b0fqstpc*(1d0/2/ctw**4*vpatp*vpabt*mw**2+1d0/2/ctw**
     & 2*vpatp*vpabt*mtp**2)
     & +jawsubsubqststpcw*stw**2*qup*qtp*(-1d0/us**2*mtp**6+2/us**2*mw**
     & 2*mtp**4-1d0/us**2*mw**4*mtp**2-mtp**2-3*ts/us**2*mtp**4+4*ts/us*
     & *2*mw**2*mtp**2-ts/us**2*mw**4-ts-3*ts**2/us**2*mtp**2+2*ts**2/us
     & **2*mw**2-ts**3/us**2)
     & +jawsubsubqstsctpw*stw**2*qdn*qbt*(1d0/qs/us**2*mw**4*mtp**4+1d0/
     & qs/us*mw**2*mtp**4+1d0/qs/us*mw**4*mtp**2+1d0/qs*mw**2*mtp**2+1d0
     & /us**2*mw**4*mtp**2+1d0/us*mw**2*mtp**2-ts/us**2*mw**4-ts-ts**2/u
     & s**2*mtp**2+2*ts**2/us**2*mw**2-ts**3/us**2)
     & +jawsubsubqsustpcw*stw**2*qdn*qtp*(1d0/qs/us*mw**2*mtp**4+1d0/qs*
     & mw**2*mtp**2+1d0/us*mtp**4+3*mtp**2+2*us)
     & +jawsubsubqsusctpw*stw**2*qup*qbt*(2*us)
     & +c0ctpqswtpz*(1d0/2/ctw**2*vpatp*mtp**2-1d0/ctw**2*vpatp*mw**2+1d
     & 0/4*vmatp/mw**2*mtp**4-3d0/2*vmatp*mtp**2-1d0/4*vpatp/mw**2*mtp**
     & 4+1d0/2*vpatp*mtp**2-vpatp*mw**2)
     & +c0ctpqswtph*(-1d0/4/mw**2*mtp**4+1d0/2*mtp**2)
     & +c0ctpqswtpc*qtp*(-2*mtp**2-2*mw**2+2*ctw**2*mtp**2+2*ctw**2*mw**
     & 2)
     & +c0ctpqswtpc*qdn*qtp*(-1d0/qs/us*mw**2*mtp**4-1d0/qs*mw**2*mtp**2
     & -1d0/us*mtp**4-3*mtp**2-2*us+ctw**2/qs/us*mw**2*mtp**4+ctw**2/qs*
     & mw**2*mtp**2+ctw**2/us*mtp**4+3*ctw**2*mtp**2+2*ctw**2*us)
     & +c0ctpqswtpc*qup*qtp*(1d0/us**2*mtp**6-2/us**2*mw**2*mtp**4+1d0/u
     & s**2*mw**4*mtp**2+mtp**2+3*ts/us**2*mtp**4-4*ts/us**2*mw**2*mtp**
     & 2+ts/us**2*mw**4+ts+3*ts**2/us**2*mtp**2-2*ts**2/us**2*mw**2+ts**
     & 3/us**2-ctw**2/us**2*mtp**6+2*ctw**2/us**2*mw**2*mtp**4-ctw**2/us
     & **2*mw**4*mtp**2-ctw**2*mtp**2-3*ctw**2*ts/us**2*mtp**4+4*ctw**2*
     & ts/us**2*mw**2*mtp**2-ctw**2*ts/us**2*mw**4-ctw**2*ts-3*ctw**2*ts
     & **2/us**2*mtp**2+2*ctw**2*ts**2/us**2*mw**2-ctw**2*ts**3/us**2)
     & +c0ctpqszcw*(1d0/ctw**2*vpabt*mw**2-vpabt*mtp**2+vpabt*mw**2)
     & +c0ctpqscztp*(1d0/ctw**4*vpatp*vpabt*mw**2+1d0/2/ctw**2*vpatp*vpa
     & bt*us+1d0/2/ctw**2*vpatp*vpabt*ts)
     & +c0ccqswcz*(-1d0/ctw**2*vpadn/qs*mw**4+1d0/ctw**2*vpadn*mw**2+1d0
     & /ctw**2*vpaup/qs*mw**4-1d0/ctw**2*vpaup*mw**2+vpadn*mw**2-vpaup*m
     & w**2)
     & +c0ccqsczc*(-1d0/2/ctw**6*vpaup*vpadn/qs*mw**4+1d0/ctw**4*vpaup*v
     & padn*mw**2+1d0/2/ctw**2*vpaup*vpadn*mtp**2+1d0/2/ctw**2*vpaup*vpa
     & dn*us+1d0/2/ctw**2*vpaup*vpadn*ts)
     & +a0fw*qtp*(-2*invftpw+2*invftpw*ctw**2)
     & +a0fw*qdn*(2-1d0/qs*mw**2+ctw**2/qs*mw**2-2*ctw**2)
     & +a0fw*qup*(-2+1d0/qs*mw**2-ctw**2/qs*mw**2+2*ctw**2)
     & +a0fw*(223d0/24+1d0/12/ctw**2/qs*mw**2+1d0/12/qs*mh**2+5/qs*mw**2
     & -3/qs*mw**4/mh**2-3*mw**2/mh**2-1d0/2*vpadn/qs*mw**2+vpadn+1d0/2*
     & vpaup/qs*mw**2-vpaup+7d0/8*invftpw-invftpw*vpatp-3d0/8*invftpw**2
     & )
     & +a0fz*(4d0/3-1d0/12/ctw**4/qs*mw**2-3d0/2/ctw**4/qs*mw**4/mh**2-3
     & d0/2/ctw**4*mw**2/mh**2-1d0/8/ctw**4*vmatp**2*mw**2/mtp**2+1d0/2/
     & ctw**4*vpaup*vpadn/qs*mw**2-2d0/3/ctw**2/qs*mw**2-1d0/12/ctw**2+1
     & d0/8/ctw**2*vpabt**2-1d0/16/ctw**2*vmatp**2-1d0/2/ctw**2*vpatp*vp
     & abt+1d0/8/ctw**2*vpatp*vmatp-1d0/16/ctw**2*vpatp**2-1d0/2/ctw**2*
     & vpadn/qs*mw**2+1d0/8/ctw**2*vpadn**2+1d0/2/ctw**2*vpaup/qs*mw**2-
     & 1d0/ctw**2*vpaup*vpadn+1d0/8/ctw**2*vpaup**2+2/qs*mw**2+vpabt+vpa
     & dn-vpaup)
     & +a0fh*(-1d0/12/qs/mw**2*mh**4+1d0/12/qs*mh**2-1d0/16/mw**2*mh**2)
     & +a0ftp*qtp*(-4+4*ctw**2+2*invftpw-2*invftpw*ctw**2)
     & +a0ftp*qtp*qbt*(-2+2*ctw**2)
     & +a0ftp*stw**2*qtp**2*(2)
     & +a0ftp*(1d0/2+1d0/8/ctw**2*vmatp**2+3d0/16/mw**2*mtp**2+1d0/16*vm
     & atp**2/mw**2*mtp**2-vpatp-1d0/8*vpatp*vmatp/mw**2*mtp**2+1d0/16*v
     & patp**2/mw**2*mtp**2-7d0/8*invftpw+invftpw*vpatp+3d0/8*invftpw**2
     & )
     & +b0ftpwc*qbt*(-2+2*ctw**2)
     & +b0ftpwc*(-3d0/8-vpabt)
     & +b0ftpztp*(-1d0/8/ctw**4*vmatp**2*mw**2/mtp**2+1d0/16/ctw**2*vmat
     & p**2+1d0/2/ctw**2*vpatp*vpabt+1d0/8/ctw**2*vpatp*vmatp-3d0/16/ctw
     & **2*vpatp**2+vpatp)
     & +b0ftphtp*(-1d0/16/mw**2*mh**2)
     & +b0fqswz*(13d0/3-1d0/12/ctw**4/qs*mw**2-4d0/3/ctw**2/qs*mw**2-5d0
     & /6/ctw**2-1d0/2/ctw**2*vpadn/qs*mw**2+1d0/2/ctw**2*vpaup/qs*mw**2
     & +17d0/3/qs*mw**2+1d0/2*vpabt-1d0/8*vmatp/mw**2*mtp**2+1d0/8*vpatp
     & /mw**2*mtp**2-1d0/2*vpatp-1d0/2*vpadn/qs*mw**2+1d0/2*vpadn+1d0/2*
     & vpaup/qs*mw**2-1d0/2*vpaup+4*ctw**2/qs*mw**2+8*ctw**2)
     & +b0fqswh*(-1-1d0/12/qs/mw**2*mh**4+1d0/6/qs*mh**2-1d0/qs*mw**2+1d
     & 0/8/mw**2*mtp**2)
     & +b0fqswc*qbt*(1-ctw**2)
     & +b0fqswc*qtp*(-1+ctw**2)
     & +b0fqswc*qdn*(1-1d0/qs*mw**2+ctw**2/qs*mw**2-ctw**2)
     & +b0fqswc*qup*(-1+1d0/qs*mw**2-ctw**2/qs*mw**2+ctw**2)
     & +b0fqswc*(8+4/qs*mw**2-4*ctw**2/qs*mw**2-8*ctw**2)
     & +b0fqstpc*qtp*qbt*(-3+3*ctw**2)
     & +b0fqstpc*(-3d0/4/ctw**2*vpatp*vpabt)
     & +b0fqscc*qup*qdn*(-3+3*ctw**2)
     & +b0fqscc*(1d0/2/ctw**4*vpaup*vpadn/qs*mw**2-3d0/4/ctw**2*vpaup*vp
     & adn)
     & +dreal(b0ptpztp)*(-1d0/8/ctw**4*vmatp**2*mw**2-1d0/8/ctw**4*vpatp
     & **2*mw**2+1d0/8/ctw**2*vmatp**2*mtp**2-3d0/4/ctw**2*vpatp*vmatp*m
     & tp**2+1d0/8/ctw**2*vpatp**2*mtp**2)
     & +dreal(b0ptphtp)*(1d0/2/mw**2*mtp**4-1d0/8/mw**2*mh**2*mtp**2)
     & +dreal(b0ptpcw)*(1d0/8/mw**2*mtp**4+1d0/8*mtp**2-1d0/4*mw**2)
     & +110d0/9-1d0/ctw**4/qs*mw**4/mh**2-1d0/ctw**4*mw**2/mh**2+1d0/6/c
     & tw**2/qs*mw**2+1d0/6/ctw**2+3d0/16/ctw**2*vpabt**2-1d0/2/ctw**2*v
     & patp*vpabt+1d0/8/ctw**2*vpatp**2+3d0/16/ctw**2*vpadn**2-1d0/2/ctw
     & **2*vpaup*vpadn+3d0/16/ctw**2*vpaup**2+64d0/9/qs*mw**2-2/qs*mw**4
     & /mh**2+1d0/16/mw**2*mtp**2+caldwfer-za1fer-za1bos-2*mw**2/mh**2-1
     & d0/8*vmatp/mw**2*mtp**2+1d0/8*vpatp/mw**2*mtp**2+3d0/8*invftpw

      ff_ew_lr =
     & 0

      ff_ew_lld =
     & +propiwqs*sdet3ictpqs*qup*qtp*(2/us*mtp-2*ctw**2/us*mtp)
     & +propiwqs*sdet3ictpqs*c0ctpqswtpz*(1d0/2/ctw**2*vpaup*vpatp/us*mt
     & p**3-1d0/2/ctw**2*vpaup*vpatp/us*mw**2*mtp)
     & +propiwqs*sdet3ictpqs*c0ctpqswtpc*qup*qtp*(2/us*mtp**3-2/us*mw**2
     & *mtp-2*ctw**2/us*mtp**3+2*ctw**2/us*mw**2*mtp)
     & +propiwqs*sdet3ictpqs*c0ctpqszcw*(-1d0/2/ctw**4*vpadn*vpabt/us*mw
     & **2*mtp)
     & +propiwqs*sdet3ictpqs*a0ftp*qup*qtp*(-2/us*mtp+2*ctw**2/us*mtp)
     & +propiwqs*sdet3ictpqs*b0ftpwc*qdn*qbt*(2/us*mtp-2*ctw**2/us*mtp)
     & +propiwqs*sdet3ictpqs*b0ftpwc*(1d0/2/ctw**2*vpadn*vpabt/us*mtp)
     & +propiwqs*sdet3ictpqs*b0ftpztp*(1d0/2/ctw**2*vpaup*vpatp/us*mtp)
     & +propiwqs*sdet3ictpqs*b0fqswz*(-1d0/2/ctw**2*vpadn*vpabt/us*mtp-1
     & d0/2/ctw**2*vpaup*vpatp/us*mtp)
     & +propiwqs*sdet3ictpqs*b0fqswc*qdn*qbt*(-2/us*mtp+2*ctw**2/us*mtp)
     & +propiwqs*sdet3ictpqs*b0fqswc*qup*qtp*(-2/us*mtp+2*ctw**2/us*mtp)
     & +propiwqs*sdet3ictpts*qup*qtp*(2/us*mtp-2*ctw**2/us*mtp)
     & +propiwqs*sdet3ictpts*c0ctptscwc*qdn*qbt*(2/us*mw**2*mtp-2*ctw**2
     & /us*mw**2*mtp)
     & +propiwqs*sdet3ictpts*c0ctptscwc*(1d0/2/ctw**2*vpadn*vpabt/us*mw*
     & *2*mtp)
     & +propiwqs*sdet3ictpts*c0ctptscztp*(1d0/2/ctw**4*vpaup*vpatp/us*mw
     & **2*mtp)
     & +propiwqs*sdet3ictpts*a0ftp*qup*qtp*(-2/us*mtp+2*ctw**2/us*mtp)
     & +propiwqs*sdet3ictpts*b0ftpwc*qdn*qbt*(2/us*mtp-2*ctw**2/us*mtp)
     & +propiwqs*sdet3ictpts*b0ftpwc*(1d0/2/ctw**2*vpadn*vpabt/us*mtp)
     & +propiwqs*sdet3ictpts*b0ftpztp*(1d0/2/ctw**2*vpaup*vpatp/us*mtp)
     & +propiwqs*sdet3ictpts*b0ftstpc*qup*qtp*(-2/us*mtp+2*ctw**2/us*mtp
     & )
     & +propiwqs*sdet3ictpts*b0ftstpc*(-1d0/2/ctw**2*vpaup*vpatp/us*mtp)
     & +propiwqs*sdet3ictpts*b0ftscc*qdn*qbt*(-2/us*mtp+2*ctw**2/us*mtp)
     & +propiwqs*sdet3ictpts*b0ftscc*(-1d0/2/ctw**2*vpadn*vpabt/us*mtp)
     & +propiwqs*d0cctpcqstswcztp*(1d0/4/ctw**6*vpaup*vpatp/qs/us**2*mw*
     & *4*mtp**3+1d0/4/ctw**6*vpaup*vpatp/qs/us*mw**4*mtp+1d0/4/ctw**6*v
     & paup*vpatp/us**2*mw**4*mtp-1d0/4/ctw**4*vpaup*vmatp/qs/us*mw**2*m
     & tp**3-1d0/4/ctw**4*vpaup*vmatp/qs*mw**2*mtp-1d0/4/ctw**4*vpaup*vm
     & atp/us*mw**2*mtp+1d0/4/ctw**4*vpaup*vpatp/qs/us*mw**2*mtp**3-1d0/
     & 4/ctw**4*vpaup*vpatp/qs/us*mw**4*mtp+1d0/4/ctw**4*vpaup*vpatp/qs*
     & mw**2*mtp-1d0/2/ctw**4*vpaup*vpatp/us**2*mw**2*mtp**3+1d0/2/ctw**
     & 4*vpaup*vpatp/us**2*mw**4*mtp+1d0/4/ctw**4*vpaup*vpatp/us*mw**2*m
     & tp-1d0/2/ctw**4*vpaup*vpatp*ts/us**2*mw**2*mtp+1d0/4/ctw**2*vpaup
     & *vmatp/qs*mw**2*mtp+1d0/4/ctw**2*vpaup*vmatp/us*mtp**3-1d0/4/ctw*
     & *2*vpaup*vmatp/us*mw**2*mtp+1d0/4/ctw**2*vpaup*vmatp*ts/us*mtp-1d
     & 0/4/ctw**2*vpaup*vpatp/qs*mw**2*mtp+1d0/4/ctw**2*vpaup*vpatp/ts/u
     & s**2*mtp**7-1d0/2/ctw**2*vpaup*vpatp/ts/us**2*mw**2*mtp**5+1d0/4/
     & ctw**2*vpaup*vpatp/ts/us**2*mw**4*mtp**3+1d0/4/ctw**2*vpaup*vpatp
     & /ts/us*mtp**5-1d0/4/ctw**2*vpaup*vpatp/ts/us*mw**2*mtp**3+3d0/4/c
     & tw**2*vpaup*vpatp/us**2*mtp**5-1d0/ctw**2*vpaup*vpatp/us**2*mw**2
     & *mtp**3+1d0/4/ctw**2*vpaup*vpatp/us**2*mw**4*mtp+1d0/4/ctw**2*vpa
     & up*vpatp/us*mtp**3+3d0/4/ctw**2*vpaup*vpatp*ts/us**2*mtp**3-1d0/2
     & /ctw**2*vpaup*vpatp*ts/us**2*mw**2*mtp+1d0/4/ctw**2*vpaup*vpatp*t
     & s**2/us**2*mtp)
     & +propiwqs*d0cctpcqstszcwc*(1d0/4/ctw**6*vpadn*vpabt/ts/us**2*mw**
     & 4*mtp**3+1d0/4/ctw**6*vpadn*vpabt/us**2*mw**4*mtp-1d0/4/ctw**4*vp
     & adn*vpabt/qs/us*mw**4*mtp-1d0/4/ctw**4*vpadn*vpabt/qs*mw**2*mtp-1
     & d0/2/ctw**4*vpadn*vpabt/us**2*mw**2*mtp**3+1d0/2/ctw**4*vpadn*vpa
     & bt/us**2*mw**4*mtp-1d0/2/ctw**4*vpadn*vpabt*ts/us**2*mw**2*mtp+1d
     & 0/4/ctw**2*vpadn*vpabt/qs/us**2*mw**4*mtp**3+1d0/4/ctw**2*vpadn*v
     & pabt/qs/us*mw**2*mtp**3+1d0/4/ctw**2*vpadn*vpabt/qs/us*mw**4*mtp+
     & 1d0/4/ctw**2*vpadn*vpabt/qs*mw**2*mtp+1d0/4/ctw**2*vpadn*vpabt/us
     & **2*mw**4*mtp+1d0/4/ctw**2*vpadn*vpabt/us*mw**2*mtp+1d0/4/ctw**2*
     & vpadn*vpabt*ts/us**2*mtp**3-1d0/2/ctw**2*vpadn*vpabt*ts/us**2*mw*
     & *2*mtp+1d0/4/ctw**2*vpadn*vpabt*ts**2/us**2*mtp)
     & +propiwqs*d0ccctpqsuszcwtp*(-1d0/4/ctw**4*vpadn*vmatp/qs*mw**2*mt
     & p+1d0/4/ctw**4*vpadn*vmatp/ts*mw**2*mtp+1d0/4/ctw**2*vpadn*vmatp/
     & qs/us*mw**2*mtp**3+1d0/4/ctw**2*vpadn*vmatp/qs*mw**2*mtp-1d0/4/ct
     & w**2*vpadn*vmatp/ts/us*mtp**5+1d0/4/ctw**2*vpadn*vmatp/ts/us*mw**
     & 2*mtp**3-1d0/2/ctw**2*vpadn*vmatp/ts*mtp**3+1d0/4/ctw**2*vpadn*vm
     & atp/ts*mw**2*mtp-1d0/4/ctw**2*vpadn*vmatp/ts*us*mtp)
     & +propiwqs*c0ctpqswtpz*(1d0/4/ctw**4*vpaup*vpatp/qs/us**2*mw**2*mt
     & p**3+1d0/4/ctw**4*vpaup*vpatp/us**2*mw**2*mtp+1d0/4/ctw**2*vpadn*
     & vmatp/qs/us*mtp**3+1d0/4/ctw**2*vpadn*vmatp/ts*mtp-1d0/4/ctw**2*v
     & paup*vmatp/qs/us*mtp**3-1d0/4/ctw**2*vpaup*vmatp/us*mtp+1d0/4/ctw
     & **2*vpaup*vpatp/qs/us*mtp**3+1d0/4/ctw**2*vpaup*vpatp/ts/us*mtp**
     & 3-1d0/4/ctw**2*vpaup*vpatp/ts/us*mw**2*mtp-1d0/4/ctw**2*vpaup*vpa
     & tp/us**2*mtp**3+1d0/4/ctw**2*vpaup*vpatp/us**2*mw**2*mtp-1d0/4/ct
     & w**2*vpaup*vpatp*ts/us**2*mtp)
     & +propiwqs*c0ctpqswtpc*qdn*qtp*(1d0/qs/us*mtp**3+1d0/ts*mtp-ctw**2
     & /qs/us*mtp**3-ctw**2/ts*mtp)
     & +propiwqs*c0ctpqswtpc*qup*qtp*(1d0/ts/us*mtp**3-1d0/ts/us*mw**2*m
     & tp-1d0/us**2*mtp**3+1d0/us**2*mw**2*mtp-1d0/us*mtp-ts/us**2*mtp-c
     & tw**2/ts/us*mtp**3+ctw**2/ts/us*mw**2*mtp+ctw**2/us**2*mtp**3-ctw
     & **2/us**2*mw**2*mtp+ctw**2/us*mtp+ctw**2*ts/us**2*mtp)
     & +propiwqs*c0ctpqszcw*(-1d0/4/ctw**4*vpadn*vpabt/ts/us*mw**2*mtp+1
     & d0/4/ctw**4*vpadn*vpabt/us**2*mw**2*mtp+1d0/4/ctw**2*vpadn*vpabt/
     & qs/us**2*mw**2*mtp**3+1d0/4/ctw**2*vpadn*vpabt/qs/us*mtp**3+1d0/4
     & /ctw**2*vpadn*vpabt/us**2*mw**2*mtp-1d0/4/ctw**2*vpadn*vpabt*ts/u
     & s**2*mtp)
     & +propiwqs*c0ctptscwc*qdn*qbt*(1d0/qs/us*mw**2*mtp+1d0/qs*mtp+1d0/
     & us**2*mtp**3-1d0/us**2*mw**2*mtp-1d0/us*mtp+ts/us**2*mtp-ctw**2/q
     & s/us*mw**2*mtp-ctw**2/qs*mtp-ctw**2/us**2*mtp**3+ctw**2/us**2*mw*
     & *2*mtp+ctw**2/us*mtp-ctw**2*ts/us**2*mtp)
     & +propiwqs*c0ctptscwc*(-1d0/4/ctw**4*vpadn*vpabt/ts/us**2*mw**2*mt
     & p**3-1d0/4/ctw**4*vpadn*vpabt/us**2*mw**2*mtp+1d0/4/ctw**2*vpadn*
     & vpabt/qs/us*mw**2*mtp+1d0/4/ctw**2*vpadn*vpabt/qs*mtp+1d0/4/ctw**
     & 2*vpadn*vpabt/us**2*mtp**3-1d0/4/ctw**2*vpadn*vpabt/us**2*mw**2*m
     & tp-1d0/4/ctw**2*vpadn*vpabt/us*mtp+1d0/4/ctw**2*vpadn*vpabt*ts/us
     & **2*mtp)
     & +propiwqs*c0ctptscztp*(1d0/4/ctw**4*vpaup*vpatp/qs/us*mw**2*mtp-1
     & d0/4/ctw**4*vpaup*vpatp/us**2*mw**2*mtp-1d0/4/ctw**2*vpaup*vmatp/
     & qs*mtp+1d0/4/ctw**2*vpaup*vmatp/us*mtp+1d0/4/ctw**2*vpaup*vpatp/q
     & s*mtp+1d0/4/ctw**2*vpaup*vpatp/ts/us**2*mtp**5-1d0/4/ctw**2*vpaup
     & *vpatp/ts/us**2*mw**2*mtp**3+1d0/2/ctw**2*vpaup*vpatp/us**2*mtp**
     & 3-1d0/4/ctw**2*vpaup*vpatp/us**2*mw**2*mtp-1d0/4/ctw**2*vpaup*vpa
     & tp/us*mtp+1d0/4/ctw**2*vpaup*vpatp*ts/us**2*mtp)
     & +propiwqs*c0ctpuscztp*(-1d0/4/ctw**2*vpadn*vmatp/qs/us*mtp**3-1d0
     & /4/ctw**2*vpadn*vmatp/qs*mtp-1d0/4/ctw**2*vpadn*vmatp/ts/us*mtp**
     & 3-1d0/4/ctw**2*vpadn*vmatp/ts*mtp)
     & +propiwqs*c0ccqswcz*(1d0/4/ctw**4*vpadn*vpabt/ts/us**2*mw**2*mtp*
     & *3+1d0/4/ctw**4*vpadn*vpabt/ts/us*mw**2*mtp+1d0/4/ctw**4*vpadn*vp
     & abt/us**2*mw**2*mtp+1d0/4/ctw**4*vpaup*vpatp/us**2*mw**2*mtp-1d0/
     & 4/ctw**2*vpadn*vpabt/us**2*mtp**3+1d0/4/ctw**2*vpadn*vpabt/us**2*
     & mw**2*mtp-1d0/4/ctw**2*vpadn*vpabt*ts/us**2*mtp+1d0/4/ctw**2*vpad
     & n*vmatp/ts/us*mtp**3+1d0/4/ctw**2*vpadn*vmatp/ts*mtp-1d0/4/ctw**2
     & *vpaup*vmatp/us*mtp-1d0/4/ctw**2*vpaup*vpatp/ts/us**2*mtp**5+1d0/
     & 4/ctw**2*vpaup*vpatp/ts/us**2*mw**2*mtp**3-1d0/4/ctw**2*vpaup*vpa
     & tp/ts/us*mtp**3+1d0/4/ctw**2*vpaup*vpatp/ts/us*mw**2*mtp-1d0/2/ct
     & w**2*vpaup*vpatp/us**2*mtp**3+1d0/4/ctw**2*vpaup*vpatp/us**2*mw**
     & 2*mtp-1d0/4/ctw**2*vpaup*vpatp*ts/us**2*mtp)
     & +propiwqs*c0cctscwtp*qup*qtp*(1d0/us**2*mtp**3-1d0/us**2*mw**2*mt
     & p+ts/us**2*mtp-ctw**2/us**2*mtp**3+ctw**2/us**2*mw**2*mtp-ctw**2*
     & ts/us**2*mtp)
     & +propiwqs*c0cctscwtp*(-1d0/4/ctw**4*vpaup*vpatp/qs/us**2*mw**2*mt
     & p**3-1d0/4/ctw**4*vpaup*vpatp/qs/us*mw**2*mtp-1d0/4/ctw**4*vpaup*
     & vpatp/us**2*mw**2*mtp+1d0/4/ctw**2*vpaup*vmatp/qs/us*mtp**3+1d0/4
     & /ctw**2*vpaup*vmatp/qs*mtp+1d0/4/ctw**2*vpaup*vmatp/us*mtp-1d0/4/
     & ctw**2*vpaup*vpatp/qs/us*mtp**3-1d0/4/ctw**2*vpaup*vpatp/qs*mtp+1
     & d0/4/ctw**2*vpaup*vpatp/us**2*mtp**3-1d0/4/ctw**2*vpaup*vpatp/us*
     & *2*mw**2*mtp-1d0/4/ctw**2*vpaup*vpatp/us*mtp+1d0/4/ctw**2*vpaup*v
     & patp*ts/us**2*mtp)
     & +propiwqs*c0cctsczc*(-1d0/4/ctw**4*vpadn*vpabt/us**2*mw**2*mtp-1d
     & 0/4/ctw**2*vpadn*vpabt/qs/us**2*mw**2*mtp**3-1d0/4/ctw**2*vpadn*v
     & pabt/qs/us*mtp**3-1d0/4/ctw**2*vpadn*vpabt/qs/us*mw**2*mtp-1d0/4/
     & ctw**2*vpadn*vpabt/qs*mtp-1d0/4/ctw**2*vpadn*vpabt/us**2*mw**2*mt
     & p-1d0/4/ctw**2*vpadn*vpabt/us*mtp+1d0/4/ctw**2*vpadn*vpabt*ts/us*
     & *2*mtp)
     & +propiwqs*c0ccuscwtp*qdn*qtp*(1d0/qs*mtp-1d0/ts*mtp-ctw**2/qs*mtp
     & +ctw**2/ts*mtp)
     & +propiwqs*c0ccuscwtp*(1d0/4/ctw**2*vpadn*vmatp/qs*mtp-1d0/4/ctw**
     & 2*vpadn*vmatp/ts*mtp)
     & +sdet3ictpqs*qbt*(-mtp+ctw**2*mtp)
     & +sdet3ictpqs*qtp*(mtp-ctw**2*mtp)
     & +sdet3ictpqs*qtp*qbt*(mtp-ctw**2*mtp)
     & +sdet3ictpqs**2*qtp*(8*mtp**3-2*mw**2*mtp-8*ctw**2*mtp**3+2*ctw**
     & 2*mw**2*mtp)
     & +sdet3ictpqs**3*qtp*(-6*mtp**5+6*mw**2*mtp**3+6*ctw**2*mtp**5-6*c
     & tw**2*mw**2*mtp**3)
     & +sdet3ictpqs**3*c0ctpqswtpz*(3d0/4*vmatp/mw**2*mtp**9-3d0/2*vmatp
     & *mtp**7+3d0/4*vmatp*mw**2*mtp**5-3d0/4*vpatp/mw**2*mtp**9-3d0/2*v
     & patp*mtp**7+21d0/4*vpatp*mw**2*mtp**5-3*vpatp*mw**4*mtp**3)
     & +sdet3ictpqs**3*c0ctpqswtph*(-3d0/4/mw**2*mtp**9+3d0/2*mtp**7-3d0
     & /4*mw**2*mtp**5)
     & +sdet3ictpqs**3*c0ctpqswtpc*qtp*(-6*mtp**7+12*mw**2*mtp**5-6*mw**
     & 4*mtp**3+6*ctw**2*mtp**7-12*ctw**2*mw**2*mtp**5+6*ctw**2*mw**4*mt
     & p**3)
     & +sdet3ictpqs**3*c0ctpqszcw*(3/ctw**4*vpabt*mw**4*mtp**3)
     & +sdet3ictpqs**3*c0ctpqscztp*(3d0/2/ctw**6*vpatp*vpabt*mw**4*mtp**
     & 3)
     & +sdet3ictpqs**3*a0ftp*qtp*(6*mtp**5-6*mw**2*mtp**3-6*ctw**2*mtp**
     & 5+6*ctw**2*mw**2*mtp**3)
     & +sdet3ictpqs**3*b0ftpwc*(-3/ctw**2*vpabt*mw**2*mtp**3)
     & +sdet3ictpqs**3*b0ftpztp*(3d0/2/ctw**4*vpatp*vpabt*mw**2*mtp**3+3
     & d0/4*vmatp/mw**2*mtp**7-3d0/4*vmatp*mtp**5-3d0/4*vpatp/mw**2*mtp*
     & *7-9d0/4*vpatp*mtp**5+3*vpatp*mw**2*mtp**3)
     & +sdet3ictpqs**3*b0ftphtp*(-3d0/4/mw**2*mtp**7+3d0/4*mtp**5)
     & +sdet3ictpqs**3*b0fqswz*(3/ctw**2*vpabt*mw**2*mtp**3-3d0/4*vmatp/
     & mw**2*mtp**7+3d0/4*vmatp*mtp**5+3d0/4*vpatp/mw**2*mtp**7+9d0/4*vp
     & atp*mtp**5-3*vpatp*mw**2*mtp**3)
     & +sdet3ictpqs**3*b0fqswh*(3d0/4/mw**2*mtp**7-3d0/4*mtp**5)
     & +sdet3ictpqs**3*b0fqswc*qtp*(6*mtp**5-6*mw**2*mtp**3-6*ctw**2*mtp
     & **5+6*ctw**2*mw**2*mtp**3)
     & +sdet3ictpqs**3*b0fqstpc*(-3d0/2/ctw**4*vpatp*vpabt*mw**2*mtp**3)
     & +sdet3ictpqs**2*c0ctpqswtpz*(1d0/2/ctw**2*vmatp*mtp**5-1d0/2/ctw*
     & *2*vmatp*mw**2*mtp**3-1d0/2/ctw**2*vpatp*mtp**5-3d0/2/ctw**2*vpat
     & p*mw**2*mtp**3+2/ctw**2*vpatp*mw**4*mtp-7d0/4*vmatp/mw**2*mtp**7+
     & 5*vmatp*mtp**5-13d0/4*vmatp*mw**2*mtp**3+7d0/4*vpatp/mw**2*mtp**7
     & +2*vpatp*mtp**5-19d0/4*vpatp*mw**2*mtp**3+vpatp*mw**4*mtp)
     & +sdet3ictpqs**2*c0ctpqswtph*(3d0/4/mw**2*mtp**7-1d0/2/mw**2*mh**2
     & *mtp**5+1d0/2*mh**2*mtp**3-3d0/4*mw**2*mtp**3)
     & +sdet3ictpqs**2*c0ctpqswtpc*qtp*(14*mtp**5-16*mw**2*mtp**3+2*mw**
     & 4*mtp-14*ctw**2*mtp**5+16*ctw**2*mw**2*mtp**3-2*ctw**2*mw**4*mtp)
     & 
     & +sdet3ictpqs**2*c0ctpqszcw*(-1d0/ctw**4*vpabt*mw**2*mtp**3-1d0/ct
     & w**4*vpabt*mw**4*mtp+2/ctw**2*vpabt*mw**2*mtp**3-2/ctw**2*vpabt*m
     & w**4*mtp)
     & +sdet3ictpqs**2*c0ctpqscztp*(-3d0/2/ctw**6*vpatp*vpabt*mw**4*mtp+
     & 1d0/ctw**4*vmatp*vpabt*mw**2*mtp**3-1d0/ctw**4*vpatp*vpabt*mw**2*
     & mtp**3)
     & +sdet3ictpqs**2*a0fw*qtp*(3*mw**2*mtp-3*ctw**2*mw**2*mtp)
     & +sdet3ictpqs**2*a0fw*(3d0/8*mtp**3-3d0/8*vmatp*mtp**3+3d0/8*vpatp
     & *mtp**3+3d0/2*vpatp*mw**2*mtp)
     & +sdet3ictpqs**2*a0fz*(3d0/4/ctw**4*vpatp*vpabt*mw**2*mtp-3d0/2/ct
     & w**2*vpabt*mw**2*mtp)
     & +sdet3ictpqs**2*a0ftp*qtp*(-11*mtp**3+2*mw**2*mtp+11*ctw**2*mtp**
     & 3-2*ctw**2*mw**2*mtp)
     & +sdet3ictpqs**2*a0ftp*(-3d0/8/mw**2*mtp**5+3d0/8*vmatp/mw**2*mtp*
     & *5-3d0/8*vpatp/mw**2*mtp**5-3d0/2*vpatp*mtp**3)
     & +sdet3ictpqs**2*b0ftpwc*qbt*(-mtp**3+mw**2*mtp+ctw**2*mtp**3-ctw*
     & *2*mw**2*mtp)
     & +sdet3ictpqs**2*b0ftpwc*(1d0/ctw**2*vpabt*mtp**3+1d0/ctw**2*vpabt
     & *mw**2*mtp-1d0/2*vpabt*mtp**3+1d0/2*vpabt*mw**2*mtp)
     & +sdet3ictpqs**2*b0ftpztp*(-3d0/4/ctw**4*vpatp*vpabt*mw**2*mtp+1d0
     & /8/ctw**2*vmatp*mtp**3+1d0/ctw**2*vmatp*vpabt*mtp**3-1d0/8/ctw**2
     & *vpatp*mtp**3-1d0/2/ctw**2*vpatp*mw**2*mtp-1d0/ctw**2*vpatp*vpabt
     & *mtp**3-vmatp/mw**2*mtp**5+13d0/4*vmatp*mtp**3+vpatp/mw**2*mtp**5
     & +3d0/4*vpatp*mtp**3-vpatp*mw**2*mtp)
     & +sdet3ictpqs**2*b0ftphtp*(-1d0/8/mw**2*mh**2*mtp**3+3d0/4*mtp**3)
     & +sdet3ictpqs**2*b0fqswz*(-1d0/ctw**2*vpabt*mtp**3-5d0/2/ctw**2*vp
     & abt*mw**2*mtp-1d0/8/ctw**2*vmatp*mtp**3+1d0/8/ctw**2*vpatp*mtp**3
     & +1d0/2/ctw**2*vpatp*mw**2*mtp+1d0/2*vpabt*mtp**3-1d0/2*vpabt*mw**
     & 2*mtp+11d0/8*vmatp/mw**2*mtp**5-29d0/8*vmatp*mtp**3-11d0/8*vpatp/
     & mw**2*mtp**5-15d0/8*vpatp*mtp**3+5d0/2*vpatp*mw**2*mtp)
     & +sdet3ictpqs**2*b0fqswh*(-3d0/8/mw**2*mtp**5+1d0/8/mw**2*mh**2*mt
     & p**3-3d0/8*mtp**3)
     & +sdet3ictpqs**2*b0fqswc*qbt*(mtp**3-mw**2*mtp-ctw**2*mtp**3+ctw**
     & 2*mw**2*mtp)
     & +sdet3ictpqs**2*b0fqswc*qtp*(-11*mtp**3+5*mw**2*mtp+11*ctw**2*mtp
     & **3-5*ctw**2*mw**2*mtp)
     & +sdet3ictpqs**2*b0fqstpc*(3d0/2/ctw**4*vpatp*vpabt*mw**2*mtp-1d0/
     & ctw**2*vmatp*vpabt*mtp**3+1d0/ctw**2*vpatp*vpabt*mtp**3)
     & +sdet3ictpqs*c0ctpqswtpz*(-3d0/4/ctw**2*vmatp*mtp**3+2/ctw**2*vma
     & tp*mw**2*mtp+1d0/4/ctw**2*vpatp*mtp**3-1d0/2/ctw**2*vpatp*mw**2*m
     & tp+5d0/4*vmatp/mw**2*mtp**5-9d0/2*vmatp*mtp**3+vmatp*mw**2*mtp-5d
     & 0/4*vpatp/mw**2*mtp**5+1d0/2*vpatp*mtp**3)
     & +sdet3ictpqs*c0ctpqswtph*(1d0/4/mw**2*mtp**5-1d0/4/mw**2*mh**2*mt
     & p**3-mtp**3+1d0/2*mh**2*mtp)
     & +sdet3ictpqs*c0ctpqswtpc*qtp*(-8*mtp**3+2*mw**2*mtp+8*ctw**2*mtp*
     & *3-2*ctw**2*mw**2*mtp)
     & +sdet3ictpqs*c0ctpqszcw*(-1d0/2/ctw**2*vpabt*mtp**3+1d0/2/ctw**2*
     & vpabt*mw**2*mtp)
     & +sdet3ictpqs*c0ctpqscztp*(-1d0/ctw**4*vmatp*vpabt*mw**2*mtp+2/ctw
     & **4*vpatp*vpabt*mw**2*mtp)
     & +sdet3ictpqs*a0fw*qbt*(mw**2/mtp-ctw**2*mw**2/mtp)
     & +sdet3ictpqs*a0fw*qtp*(2*invftpw*mtp-2*invftpw*ctw**2*mtp)
     & +sdet3ictpqs*a0fw*(1d0/4*mtp+1d0/2*vpabt*mw**2/mtp+1d0/4*vmatp*mt
     & p-1d0/4*vpatp*mtp+1d0/4*invftpw*mtp+5d0/4*invftpw*vmatp*mtp-1d0/4
     & *invftpw*vpatp*mtp)
     & +sdet3ictpqs*a0fz*(-1d0/4/ctw**4*vpatp*vpabt*mw**2/mtp+1d0/2/ctw*
     & *2*vpabt*mtp+1d0/8/ctw**2*vmatp*mtp+1d0/2/ctw**2*vmatp*vpabt*mtp-
     & 1d0/8/ctw**2*vpatp*mtp-1d0/2/ctw**2*vpatp*mw**2/mtp-1d0/2/ctw**2*
     & vpatp*vpabt*mtp)
     & +sdet3ictpqs*a0fh*(-1d0/8/mw**2*mh**2*mtp)
     & +sdet3ictpqs*a0ftp*qtp*(3*mtp-3*ctw**2*mtp-2*invftpw*mtp+2*invftp
     & w*ctw**2*mtp)
     & +sdet3ictpqs*a0ftp*qtp*qbt*(-mtp+ctw**2*mtp)
     & +sdet3ictpqs*a0ftp*(1d0/4/ctw**2*vpatp*vpabt*mtp-1d0/8/mw**2*mtp*
     & *3+1d0/4*mtp-3d0/8*vmatp/mw**2*mtp**3+5d0/4*vmatp*mtp+3d0/8*vpatp
     & /mw**2*mtp**3+1d0/4*vpatp*mtp-1d0/4*invftpw*mtp-5d0/4*invftpw*vma
     & tp*mtp+1d0/4*invftpw*vpatp*mtp)
     & +sdet3ictpqs*b0ftpwc*qbt*(-mtp+mw**2/mtp+ctw**2*mtp-ctw**2*mw**2/
     & mtp)
     & +sdet3ictpqs*b0ftpwc*(-1d0/2*vpabt*mtp+1d0/2*vpabt*mw**2/mtp)
     & +sdet3ictpqs*b0ftpztp*(-1d0/4/ctw**4*vpatp*vpabt*mw**2/mtp-3d0/8/
     & ctw**2*vmatp*mtp-1d0/2/ctw**2*vmatp*vpabt*mtp-1d0/8/ctw**2*vpatp*
     & mtp-1d0/2/ctw**2*vpatp*mw**2/mtp+1d0/ctw**2*vpatp*vpabt*mtp+1d0/4
     & *vmatp/mw**2*mtp**3-vmatp*mtp-1d0/4*vpatp/mw**2*mtp**3+vpatp*mtp)
     & 
     & +sdet3ictpqs*b0ftphtp*(1d0/4/mw**2*mtp**3-1d0/8/mw**2*mh**2*mtp)
     & +sdet3ictpqs*b0fqswz*(1d0/2/ctw**2*vpabt*mtp+1d0/2/ctw**2*vmatp*m
     & tp+1d0/2*vpabt*mtp-5d0/8*vmatp/mw**2*mtp**3+5d0/2*vmatp*mtp+5d0/8
     & *vpatp/mw**2*mtp**3-vpatp*mtp)
     & +sdet3ictpqs*b0fqswh*(-3d0/8/mw**2*mtp**3+1d0/2*mtp)
     & +sdet3ictpqs*b0fqswc*qbt*(mtp-ctw**2*mtp)
     & +sdet3ictpqs*b0fqswc*qtp*(3*mtp-3*ctw**2*mtp)
     & +sdet3ictpqs*b0fqstpc*qtp*qbt*(-mtp+ctw**2*mtp)
     & +sdet3ictpqs*b0fqstpc*(1d0/ctw**2*vmatp*vpabt*mtp-5d0/4/ctw**2*vp
     & atp*vpabt*mtp)
     & +sdet3ictpqs*(-1d0/4/ctw**2*vpatp*vpabt*mtp+1d0/8/mw**2*mtp**3-1d
     & 0/2*vpabt*mtp-1d0/8*vmatp/mw**2*mtp**3+1d0/8*vpatp/mw**2*mtp**3+1
     & d0/2*vpatp*mtp)
     & +jawsubsubqststpcw*stw**2*qup*qtp*(1d0/ts/us**2*mtp**7-2/ts/us**2
     & *mw**2*mtp**5+1d0/ts/us**2*mw**4*mtp**3+1d0/ts/us*mtp**5-1d0/ts/u
     & s*mw**2*mtp**3+3/us**2*mtp**5-4/us**2*mw**2*mtp**3+1d0/us**2*mw**
     & 4*mtp+2/us*mtp**3-1d0/us*mw**2*mtp+3*ts/us**2*mtp**3-2*ts/us**2*m
     & w**2*mtp+ts/us*mtp+ts**2/us**2*mtp)
     & +jawsubsubqstsctpw*stw**2*qdn*qbt*(1d0/qs/us**2*mw**4*mtp**3+1d0/
     & qs/us*mw**2*mtp**3+1d0/qs/us*mw**4*mtp+1d0/qs*mw**2*mtp+1d0/us**2
     & *mw**4*mtp+1d0/us*mw**2*mtp+ts/us**2*mtp**3-2*ts/us**2*mw**2*mtp+
     & ts**2/us**2*mtp)
     & +jawsubsubqsustpcw*stw**2*qdn*qtp*(1d0/qs/us*mw**2*mtp**3+1d0/qs*
     & mw**2*mtp-1d0/ts/us*mtp**5+1d0/ts/us*mw**2*mtp**3-2/ts*mtp**3+1d0
     & /ts*mw**2*mtp-1d0/ts*us*mtp)
     & +c0ctpqswtpz*(-1d0/4*vmatp/mw**2*mtp**3+1d0/4*vpatp/mw**2*mtp**3)
     & +c0ctpqswtph*(-1d0/4/mw**2*mtp**3)
     & +c0ctpqswtpc*qdn*qtp*(-1d0/qs/us*mw**2*mtp**3-1d0/qs*mw**2*mtp+1d
     & 0/ts/us*mtp**5-1d0/ts/us*mw**2*mtp**3+2/ts*mtp**3-1d0/ts*mw**2*mt
     & p+1d0/ts*us*mtp+ctw**2/qs/us*mw**2*mtp**3+ctw**2/qs*mw**2*mtp-ctw
     & **2/ts/us*mtp**5+ctw**2/ts/us*mw**2*mtp**3-2*ctw**2/ts*mtp**3+ctw
     & **2/ts*mw**2*mtp-ctw**2/ts*us*mtp)
     & +c0ctpqswtpc*qup*qtp*(-1d0/ts/us**2*mtp**7+2/ts/us**2*mw**2*mtp**
     & 5-1d0/ts/us**2*mw**4*mtp**3-1d0/ts/us*mtp**5+1d0/ts/us*mw**2*mtp*
     & *3-3/us**2*mtp**5+4/us**2*mw**2*mtp**3-1d0/us**2*mw**4*mtp-2/us*m
     & tp**3+1d0/us*mw**2*mtp-3*ts/us**2*mtp**3+2*ts/us**2*mw**2*mtp-ts/
     & us*mtp-ts**2/us**2*mtp+ctw**2/ts/us**2*mtp**7-2*ctw**2/ts/us**2*m
     & w**2*mtp**5+ctw**2/ts/us**2*mw**4*mtp**3+ctw**2/ts/us*mtp**5-ctw*
     & *2/ts/us*mw**2*mtp**3+3*ctw**2/us**2*mtp**5-4*ctw**2/us**2*mw**2*
     & mtp**3+ctw**2/us**2*mw**4*mtp+2*ctw**2/us*mtp**3-ctw**2/us*mw**2*
     & mtp+3*ctw**2*ts/us**2*mtp**3-2*ctw**2*ts/us**2*mw**2*mtp+ctw**2*t
     & s/us*mtp+ctw**2*ts**2/us**2*mtp)
     & +c0ctpqscztp*(1d0/2/ctw**2*vmatp*vpabt*mtp-1d0/2/ctw**2*vpatp*vpa
     & bt*mtp)

      ff_ew_lrd =
     & 0

      ffarray(1,1) = ff_ew_ll
      ffarray(1,2) = ff_ew_lr
      ffarray(1,3) = ff_ew_lld
      ffarray(1,4) = ff_ew_lrd

      return
      end
