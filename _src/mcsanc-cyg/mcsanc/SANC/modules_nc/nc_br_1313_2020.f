************************************************************************
* sanc_nc_v1.30 package.
************************************************************************
* File (nc_br_1313_2020.f) is created on Wed Apr 18 13:17:50 MSK 2012.
************************************************************************
* This is the FORTRAN module (nc_bo_1313_2020) to calculate EW
* integrated Born cross section for the anti-up + up -> ta^+ + ta^- process.
*
* It is produced by s2n package of SANC (v1.10) Project.
* Copyright (C), SANC Project Team, 2002-2012.
*
* http://sanc.jinr.ru/
* http://pcphsanc.cern.ch/
* E-mail: <sanc@jinr.ru>
************************************************************************
      subroutine nc_bo_1313_2020 (s,born)
      implicit none!
      include 's2n_declare.h'

      real*8 v1z,v2z,vaz
      real*8 v0s,vas
      real*8 kappaz
      complex*16 chizs,chizsc
      real*8 betastata,ibetastata

      cmz2 = mz2

      kappaz   = gf*rzm2/(dsqrt(2d0)*8d0*pi)/alpha
      if (irun.eq.0) then
         chizs = 4d0*kappaz*s/(s-cmz2)
      else
         chizs = 4d0*kappaz*s/(s-dcmplx(mz**2,-s*wz/mz))
      endif
      chizsc   = dconjg(chizs)

      v1z = vup*vta
      v2z = (vup**2+aup**2)*(vta**2+ata**2)
      vaz = (vup**2+aup**2)*(vta**2-ata**2)

      v0s =
     & +qup**2*qta**2
     & +qup*qta*(chizs+chizsc)*v1z
     & +chizs*chizsc*v2z
      vas =
     & +qup**2*qta**2
     & +qup*qta*(chizs+chizsc)*v1z
     & +chizs*chizsc*vaz

      betastata = sqrt(1d0-4d0*mta**2/s)
      ibetastata = 1d0/betastata

      born=
     & +v0s*betastata*pi*alpha**2*(4d0/3*mta**2/s**2)
     & +v0s*betastata**3*pi*alpha**2*(4d0/9/s)
     & +vas*betastata*pi*alpha**2*(4d0/3*mta**2/s**2)

      born = born*conhc

      return
      end
************************************************************************
* This is the FORTRAN module (nc_br_1313_2020) to calculate EW Born
* cross section and soft photon Bremsstrahlung
* for the anti-up + up -> ta^+ + ta^- process.
*
* It is produced by s2n package of SANC (v1.10) Project.
* Copyright (C), SANC Project Team, 2002-2012.
*
* http://sanc.jinr.ru/
* http://pcphsanc.cern.ch/
* E-mail: <sanc@jinr.ru>
************************************************************************
      subroutine nc_br_1313_2020 (qs,ts,us,born,soft,hard)
      implicit none!
      include 's2n_declare.h'

      real*8 lnlaom,cpl,cmi
      real*8 a0s,v0s,vaz
      real*8 a1z,a2z,v1z,v2z,vas
      real*8 softisr,softfsr,softifi
      real*8 kappaz
      complex*16 chizs,chizsc,chizspr,chizsprc
      real*8 betastata,ibetastata
      real*8 jintqstata

      cmz2 = mz2
      s = -qs
      t = -ts
      u = -us

      betastata = sqrt(1d0-4d0*mta**2/s)
      ibetastata = 1d0/betastata
      cosf = (t-u)/s/betastata
      sinf = dsqrt(1d0-cosf**2)

      cpl = (1+cosf)/2d0
      cmi = (1-cosf)/2d0

      kappaz   = gf*rzm2/(dsqrt(2d0)*8d0*pi)/alpha
      if (irun.eq.0) then
         chizs = 4d0*kappaz*s/(s-cmz2)
      else
         chizs = 4d0*kappaz*s/(s-dcmplx(mz**2,-s*wz/mz))
      endif
      chizsc   = dconjg(chizs)

      a1z = aup*ata
      a2z = 4d0*vup*aup*vta*ata
      v1z = vup*vta
      v2z = (vup**2+aup**2)*(vta**2+ata**2)
      vaz = (vup**2+aup**2)*(vta**2-ata**2)

      v0s =
     & +qup**2*qta**2
     & +qup*qta*(chizs+chizsc)*v1z
     & +chizs*chizsc*v2z
      a0s =
     & +qup*qta*(chizs+chizsc)*a1z
     & +chizs*chizsc*a2z
      vas =
     & +qup**2*qta**2
     & +qup*qta*(chizs+chizsc)*v1z
     & +chizs*chizsc*vaz


      born=
     & +a0s*betastata**2*pi*alpha**2*(1d0/3*cosf/s)
     & +v0s*betastata*pi*alpha**2*(2d0/3*mta**2/s**2)
     & +v0s*betastata**3*pi*alpha**2*(1d0/6*(1+cosf**2)/s)
     & +vas*betastata*pi*alpha**2*(2d0/3*mta**2/s**2)

      born = born*conhc
      virt = 0d0
      soft = 0d0
      hard = 0d0

      if (iborn.eq.1) return

      lnlaom = log(4d0*omega**2/tlmu2)
      jintqstata = log((1d0-betastata)/(1d0+betastata))

      softisr=
     & +born*pi*alpha*qup**2*(-1d0/3)
     & +lnlaom*born/pi*alpha*qup**2*(-1)
     & +lnlaom*log(mup**2/s)*born/pi*alpha*qup**2*(-1)
     & +log(mup**2/s)*born/pi*alpha*qup**2*(-1)
     & +log(mup**2/s)**2*born/pi*alpha*qup**2*(-1d0/2)

      softfsr=
     & +ibetastata*born/pi*alpha*qta**2*(-jintqstata-1d0/2*jintqstata**2
     & +jintqstata**2*mta**2/s)
     & +ibetastata*born*pi*alpha*qta**2*(-1d0/3+2d0/3*mta**2/s)
     & +ibetastata*lnlaom*born/pi*alpha*qta**2*(-jintqstata+2*jintqstata
     & *mta**2/s)
     & +ibetastata*log(2-2/(1+betastata))*born/pi*alpha*qta**2*(2*jintqs
     & tata-4*jintqstata*mta**2/s)
     & +ibetastata*ddilog(-1+2/(1+betastata))*born/pi*alpha*qta**2*(2-4*
     & mta**2/s)
     & +lnlaom*born/pi*alpha*qta**2*(-1)

      softifi=
     & +lnlaom*log(1/(mta**2+us)*mta**2+1/(mta**2+us)*ts)*born/pi*alpha*
     & qup*qta*(2)
     & +log(1+1d0/qs/ts*mta**4+2/qs*mta**2+1d0/qs*ts)*log(-1/(mta**4+2*t
     & s*mta**2+ts**2)*qs*ts)*born/pi*alpha*qup*qta*(2)
     & +log(1+1d0/qs/us*mta**4+2/qs*mta**2+1d0/qs*us)*log(-1/(mta**4+2*u
     & s*mta**2+us**2)*qs*us)*born/pi*alpha*qup*qta*(-2)
     & +log(1-2/(1+betastata)/(mta**2+us)*mta**2)*born/pi*alpha*qup*qta*
     & (-2*jintqstata)
     & +log(1-2/(1+betastata)/(mta**2+us)*mta**2)**2*born/pi*alpha*qup*q
     & ta*(1)
     & +log(1-2/(1+betastata)/(mta**2+ts)*mta**2)*born/pi*alpha*qup*qta*
     & (2*jintqstata)
     & +log(1-2/(1+betastata)/(mta**2+ts)*mta**2)**2*born/pi*alpha*qup*q
     & ta*(-1)
     & +log(-1/(mta**4+2*us*mta**2+us**2)*qs*us)**2*born/pi*alpha*qup*qt
     & a*(-1)
     & +log(-1/(mta**4+2*ts*mta**2+ts**2)*qs*ts)**2*born/pi*alpha*qup*qt
     & a*(1)
     & +ddilog(1-2/(1+betastata)/(mta**2+us)*us)*born/pi*alpha*qup*qta*(
     & -2)
     & +ddilog(1-2/(1+betastata)/(mta**2+ts)*ts)*born/pi*alpha*qup*qta*(
     & 2)
     & +ddilog(-1d0/qs/ts*mta**4-2/qs*mta**2-1d0/qs*ts)*born/pi*alpha*qu
     & p*qta*(-2)
     & +ddilog(-1d0/qs/us*mta**4-2/qs*mta**2-1d0/qs*us)*born/pi*alpha*qu
     & p*qta*(2)
     & +ddilog(-1/(-mta**2+us+betastata*mta**2+betastata*us)*mta**2-1/(-
     & mta**2+us+betastata*mta**2+betastata*us)*us+1/(-mta**2+us+betasta
     & ta*mta**2+betastata*us)*betastata*mta**2+1/(-mta**2+us+betastata*
     & mta**2+betastata*us)*betastata*us)*born/pi*alpha*qup*qta*(2)
     & +ddilog(-1/(-mta**2+ts+betastata*mta**2+betastata*ts)*mta**2-1/(-
     & mta**2+ts+betastata*mta**2+betastata*ts)*ts+1/(-mta**2+ts+betasta
     & ta*mta**2+betastata*ts)*betastata*mta**2+1/(-mta**2+ts+betastata*
     & mta**2+betastata*ts)*betastata*ts)*born/pi*alpha*qup*qta*(-2)

      if (iqed.eq.1) then
         soft = softisr+softfsr+softifi
      elseif(iqed.eq.2) then
         soft = softisr
      elseif(iqed.eq.3) then
         soft = softifi
      elseif(iqed.eq.4) then
         soft = softfsr
      elseif(iqed.eq.5) then
         soft = softifi+softfsr
      elseif(iqed.eq.6) then
         soft = softisr+softifi
      endif
      soft = soft*cfprime

      return
      end
************************************************************************
* This is the FORTRAN module (nc_ha_1313_2020_1spr) to calculate hard
* photon Bremsstrahlung for the anti-up + up -> ta^+ + ta^- process.
*
* It is produced by s2n package of SANC (v1.10) Project.
* Copyright (C), SANC Project Team, 2002-2012.
*
* http://sanc.jinr.ru/
* http://pcphsanc.cern.ch/
* E-mail: <sanc@jinr.ru>
************************************************************************
      subroutine nc_ha_1313_2020_1spr (s,spr,hard)
      implicit none!
      include 's2n_declare.h'

      real*8 kappaz,coef,sqs
      real*8 betasupup,betasprtata
      real*8 jintsupup,jintsprtata,ln1sup,ln1bsprta
      real*8 a1z,a2z,v1z,v2z,vaz
      real*8 v0s,vas,v0spr,vaspr,a1sspr,a2sspr
      complex*16 chizs,chizsc,chizspr,chizsprc

      cmz2 = mz2

      kappaz   = gf*rzm2/(dsqrt(2d0)*8d0*pi)/alpha
      if (irun.eq.0) then
         chizs = 4d0*kappaz*s/(s-cmz2)
         chizspr = 4d0*kappaz*spr/(spr-cmz2)
      else
         chizs = 4d0*kappaz*s/(s-dcmplx(mz**2,-s*wz/mz))
         chizspr = 4d0*kappaz*spr/(spr-dcmplx(mz**2,-spr*wz/mz))
      endif
      chizsc   = dconjg(chizs)
      chizsprc = dconjg(chizspr)

      a1z = aup*ata
      a2z = 4d0*vup*aup*vta*ata
      v1z = vup*vta
      v2z = (vup**2+aup**2)*(vta**2+ata**2)
      vaz = (vup**2+aup**2)*(vta**2-ata**2)

      v0s =
     & +qup**2*qta**2
     & +qup*qta*(chizs+chizsc)*v1z
     & +chizs*chizsc*v2z
      vas =
     & +qup**2*qta**2
     & +qup*qta*(chizs+chizsc)*v1z
     & +chizs*chizsc*vaz
      v0spr =
     & +qup**2*qta**2
     & +qup*qta*(chizspr+chizsprc)*v1z
     & +chizspr*chizsprc*v2z
      vaspr =
     & +qup**2*qta**2
     & +qup*qta*(chizspr+chizsprc)*v1z
     & +chizspr*chizsprc*vaz
      a1sspr =
     & -(chizs+chizsc-chizspr-chizsprc)*a1z
      a2sspr =
     & +qup*qta*(chizs+chizsc+chizspr+chizsprc)*a1z
     & +(chizs*chizsprc+chizsc*chizspr)*a2z

      betasupup = dsqrt(1d0-4d0*rupm2/s)
      jintsupup = dlog((1d0-betasupup)/(1d0+betasupup))
      ln1sup    = -jintsupup-1d0
      betasprtata = dsqrt(1d0-4d0*rtam2/spr)
      jintsprtata = dlog((1d0-betasprtata)/(1d0+betasprtata))
      ln1bsprta   = -jintsprtata-betasprtata

      hard=
     & +v0s*alpha**3*qta**2/(s-spr)*theta_hard(s,spr,omega)*(16d0/9*jint
     & sprtata*mta**2/s**2-16d0/9*jintsprtata*mta**4/s**3)
     & +v0s*alpha**3*qta**2*spr/(s-spr)*theta_hard(s,spr,omega)*(16d0/9*
     & jintsprtata*mta**2/s**3)
     & +v0s*(s**2+spr**2)*alpha**3*qta**2/(s-spr)*theta_hard(s,spr,omega
     & )*(-4d0/9*jintsprtata*mta**2/s**4+4d0/9*ln1bsprta/s**3)
     & +v0s*betasprtata*alpha**3*qta**2*spr/(s-spr)*theta_hard(s,spr,ome
     & ga)*(8d0/9*mta**2/s**3)
     & +v0spr*betasprtata*(s**2+spr**2)*alpha**3*qup**2/spr**2/(s-spr)*t
     & heta_hard(s,spr,omega)*(-4d0/9*ln1sup*mta**2/s**2)
     & +v0spr*betasprtata*(s**2+spr**2)*alpha**3*qup**2/spr/(s-spr)*thet
     & a_hard(s,spr,omega)*(4d0/9*ln1sup/s**2)
     & +a2sspr*(s+spr)**2*alpha**3*qup*qta/spr/(s-spr)*theta_hard(s,spr,
     & omega)*(-2d0/3*jintsprtata*mta**2/s**3)
     & +a2sspr*betasprtata*(s+spr)*alpha**3*qup*qta/(s-spr)*theta_hard(s
     & ,spr,omega)*(-2d0/3/s**2)
     & +vas*alpha**3*qta**2/(s-spr)*theta_hard(s,spr,omega)*(16d0/3*jint
     & sprtata*mta**4/s**3)
     & +vas*alpha**3*qta**2*spr/(s-spr)*theta_hard(s,spr,omega)*(-32d0/9
     & *jintsprtata*mta**2/s**3)
     & +vas*(s**2+spr**2)*alpha**3*qta**2/(s-spr)*theta_hard(s,spr,omega
     & )*(4d0/9*jintsprtata*mta**2/s**4)
     & +vas*betasprtata*alpha**3*qta**2*spr/(s-spr)*theta_hard(s,spr,ome
     & ga)*(-8d0/3*mta**2/s**3)
     & +vaspr*betasprtata*(s**2+spr**2)*alpha**3*qup**2/spr**2/(s-spr)*t
     & heta_hard(s,spr,omega)*(4d0/3*ln1sup*mta**2/s**2)
     & +a1sspr*(s+spr)*alpha**3*qup**2*qta**2/spr*(-2d0/3*jintsprtata*mt
     & a**2/s**3)

      hard = hard*conhc*cfprime

      return
      end
