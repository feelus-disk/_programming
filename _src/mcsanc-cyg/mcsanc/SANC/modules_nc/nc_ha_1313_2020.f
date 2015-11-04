************************************************************************
* sanc_nc_v1.30 package.
************************************************************************
* File (nc_ha_1313_2020.f) is created on Wed Apr 18 13:29:14 MSK 2012.
************************************************************************
* This is the FORTRAN module (nc_ha_1313_2020) to calculate differential
* hard photon Bremsstrahlung for the anti-up + up -> ta^+ + ta^- process.
*
* It is produced by s2n package of SANC (v1.10) Project.
* Copyright (C), SANC Project Team, 2002-2012.
*
* http://sanc.jinr.ru/
* http://pcphsanc.cern.ch/
* E-mail: <sanc@jinr.ru>
************************************************************************
      subroutine nc_ha_1313_2020 (s,spr,ph4,costh4,costh5,hard)
      implicit none!
      include 's2n_declare.h'

      real*8 kappaz,sq,sqspr
      real*8 a1z,a2z,v1z,v2z,vaz
      real*8 p1p2,p1p3,p1p4,p1p5,p2p3,p2p4,p2p5,p3p4,p3p5,p4p5
      real*8 ph4,cosph4,sinph4,costh4,costh5,sinth4,sinth5
      complex*16 chizs,chizsc,chizspr,chizsprc

      real*8 betasupup,ibetasupup,betasprtata,ibetasprtata
      real*8 iz1up,iz2up,iz3ta,iz4ta
      real*8 a0spr,v0spr,vaspr,a2sspr,v2sspr,vasspr,a1sspr,a0s,v0s,vas

      cmz2 = mz2

      sq = dsqrt(s)
      sqspr = dsqrt(spr)

      cosph4 = dcos(ph4)
      sinph4 = dsin(ph4)
      sinth4 = dsqrt(1d0-costh4**2)
      sinth5 = dsqrt(1d0-costh5**2)

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

      betasupup = sqrt(1d0-4d0*rupm2/s)
      ibetasupup = 1d0/betasupup
      betasprtata = sqrt(1d0-4d0*rtam2/spr)
      ibetasprtata = 1d0/betasprtata
      
      a0spr =
     & +qup*qta*(chizspr+chizsprc)*a1z
     & +chizspr*chizsprc*a2z
      
      v0spr =
     & +qup**2*qta**2
     & +qup*qta*(chizspr+chizsprc)*v1z
     & +chizspr*chizsprc*v2z
      
      vaspr =
     & +qup**2*qta**2
     & +qup*qta*(chizspr+chizsprc)*v1z
     & +chizspr*chizsprc*vaz
      
      a2sspr =
     & +qup*qta*(chizs+chizsc+chizspr+chizsprc)*a1z
     & +(chizs*chizsprc+chizsc*chizspr)*a2z
      
      v2sspr =
     & +2d0*qup**2*qta**2
     & +qup*qta*(chizs+chizsc+chizspr+chizsprc)*v1z
     & +(chizs*chizsprc+chizsc*chizspr)*v2z
      
      vasspr =
     & +2d0*qup**2*qta**2
     & +qup*qta*(chizs+chizsc+chizspr+chizsprc)*v1z
     & +(chizs*chizsprc+chizsc*chizspr)*vaz
      
      a1sspr =
     & -(chizs+chizsc-chizspr-chizsprc)*a1z
      
      a0s =
     & +qup*qta*(chizs+chizsc)*a1z
     & +chizs*chizsc*a2z
      
      v0s =
     & +qup**2*qta**2
     & +qup*qta*(chizs+chizsc)*v1z
     & +chizs*chizsc*v2z
      
      vas =
     & +qup**2*qta**2
     & +qup*qta*(chizs+chizsc)*v1z
     & +chizs*chizsc*vaz

      iz1up=
     & +1d0/(mup**2/s+1d0/4*sinth5**2-sinth5**2*mup**2/s)/(s-spr)*(1d0/2
     & -1d0/2*betasupup*costh5)

      iz2up=
     & +1d0/(mup**2/s+1d0/4*sinth5**2-sinth5**2*mup**2/s)/(s-spr)*(1d0/2
     & +1d0/2*betasupup*costh5)

      iz3ta=
     & +1d0/(mta**2/spr+1d0/4*sinth4**2-sinth4**2*mta**2/spr)/(s-spr)*(1
     & d0/2-1d0/2*betasprtata*costh4)

      iz4ta=
     & +1d0/(mta**2/spr+1d0/4*sinth4**2-sinth4**2*mta**2/spr)/(s-spr)*(1
     & d0/2+1d0/2*betasprtata*costh4)

      p1p2=
     & -1d0/2*s

      p1p3=
     & +(s-spr)*(1d0/8)
     & +betasprtata*sinph4*sinth4*sinth5*(-1d0/4*sq*sqspr)
     & +betasprtata*costh4*(s-spr)*(-1d0/8)
     & +betasprtata*costh4*costh5*(s-spr)*(-1d0/8)
     & +betasprtata*costh4*costh5*(1d0/4*s)
     & +costh5*(s-spr)*(1d0/8)
     & -1d0/4*s

      p1p4=
     & +(s-spr)*(1d0/8)
     & +betasprtata*sinph4*sinth4*sinth5*(1d0/4*sq*sqspr)
     & +betasprtata*costh4*(s-spr)*(1d0/8)
     & +betasprtata*costh4*costh5*(s-spr)*(1d0/8)
     & +betasprtata*costh4*costh5*(-1d0/4*s)
     & +costh5*(s-spr)*(1d0/8)
     & -1d0/4*s

      p2p3=
     & +(s-spr)*(1d0/8)
     & +betasprtata*sinph4*sinth4*sinth5*(1d0/4*sq*sqspr)
     & +betasprtata*costh4*(s-spr)*(-1d0/8)
     & +betasprtata*costh4*costh5*(s-spr)*(1d0/8)
     & +betasprtata*costh4*costh5*(-1d0/4*s)
     & +costh5*(s-spr)*(-1d0/8)
     & -1d0/4*s

      p2p4=
     & +(s-spr)*(1d0/8)
     & +betasprtata*sinph4*sinth4*sinth5*(-1d0/4*sq*sqspr)
     & +betasprtata*costh4*(s-spr)*(1d0/8)
     & +betasprtata*costh4*costh5*(s-spr)*(-1d0/8)
     & +betasprtata*costh4*costh5*(1d0/4*s)
     & +costh5*(s-spr)*(-1d0/8)
     & -1d0/4*s

      p3p4=
     & +(s-spr)*(1d0/2)
     & -1d0/2*s+mta**2

      p1p5=
     & +(s-spr)*(-1d0/4)
     & +costh5*(s-spr)*(-1d0/4)

      p2p5=
     & +(s-spr)*(-1d0/4)
     & +costh5*(s-spr)*(1d0/4)

      p3p5=
     & +(s-spr)*(-1d0/4)
     & +betasprtata*costh4*(s-spr)*(-1d0/4)

      p4p5=
     & +(s-spr)*(-1d0/4)
     & +betasprtata*costh4*(s-spr)*(1d0/4)

      hardisr=
     & +a0spr*iz1up**2*theta_hard(s,spr,omega)*betasprtata/pi*alpha**3*q
     & up**2*mup**2*(s-spr)*(-1d0/3*p1p3*p2p4/s**2/spr**2+1d0/3*p1p4*p2p
     & 3/s**2/spr**2-1d0/3*p2p3*p4p5/s**2/spr**2+1d0/3*p2p4*p3p5/s**2/sp
     & r**2)
     & +a0spr*iz1up*iz2up*theta_hard(s,spr,omega)*betasprtata/pi*alpha**
     & 3*qup**2*(s-spr)*(1d0/3*p1p3*p2p4/s/spr**2-1d0/6*p1p3*p4p5/s/spr*
     & *2-1d0/3*p1p4*p2p3/s/spr**2+1d0/6*p1p4*p3p5/s/spr**2+1d0/6*p2p3*p
     & 4p5/s/spr**2-1d0/6*p2p4*p3p5/s/spr**2)
     & +a0spr*iz1up*betasprtata/pi*alpha**3*qup**2*(s-spr)*(-1d0/6*p1p3*
     & p2p4/s**2/spr**2+1d0/6*p1p4*p2p3/s**2/spr**2-1d0/6*p2p3*p4p5/s**2
     & /spr**2+1d0/6*p2p4*p3p5/s**2/spr**2)
     & +a0spr*iz2up**2*theta_hard(s,spr,omega)*betasprtata/pi*alpha**3*q
     & up**2*mup**2*(s-spr)*(-1d0/3*p1p3*p2p4/s**2/spr**2+1d0/3*p1p3*p4p
     & 5/s**2/spr**2+1d0/3*p1p4*p2p3/s**2/spr**2-1d0/3*p1p4*p3p5/s**2/sp
     & r**2)
     & +a0spr*iz2up*betasprtata/pi*alpha**3*qup**2*(s-spr)*(-1d0/6*p1p3*
     & p2p4/s**2/spr**2+1d0/6*p1p3*p4p5/s**2/spr**2+1d0/6*p1p4*p2p3/s**2
     & /spr**2-1d0/6*p1p4*p3p5/s**2/spr**2)
     & +v0spr*iz1up**2*theta_hard(s,spr,omega)*betasprtata/pi*alpha**3*q
     & up**2*mup**2*(s-spr)*(-1d0/3*p1p3*p2p4/s**2/spr**2-1d0/3*p1p4*p2p
     & 3/s**2/spr**2+1d0/3*p2p3*p4p5/s**2/spr**2+1d0/3*p2p4*p3p5/s**2/sp
     & r**2)
     & +v0spr*iz1up*iz2up*theta_hard(s,spr,omega)*betasprtata/pi*alpha**
     & 3*qup**2*(s-spr)*(1d0/3*p1p3*p2p4/s/spr**2-1d0/6*p1p3*p4p5/s/spr*
     & *2+1d0/3*p1p4*p2p3/s/spr**2-1d0/6*p1p4*p3p5/s/spr**2-1d0/6*p2p3*p
     & 4p5/s/spr**2-1d0/6*p2p4*p3p5/s/spr**2)
     & +v0spr*iz1up*betasprtata/pi*alpha**3*qup**2*(s-spr)*(1d0/3*p1p3*p
     & 1p4/s**2/spr**2-1d0/6*p1p3*p2p4/s**2/spr**2-1d0/6*p1p4*p2p3/s**2/
     & spr**2+1d0/6*p2p3*p4p5/s**2/spr**2+1d0/6*p2p4*p3p5/s**2/spr**2)
     & +v0spr*iz2up**2*theta_hard(s,spr,omega)*betasprtata/pi*alpha**3*q
     & up**2*mup**2*(s-spr)*(-1d0/3*p1p3*p2p4/s**2/spr**2+1d0/3*p1p3*p4p
     & 5/s**2/spr**2-1d0/3*p1p4*p2p3/s**2/spr**2+1d0/3*p1p4*p3p5/s**2/sp
     & r**2)
     & +v0spr*iz2up*betasprtata/pi*alpha**3*qup**2*(s-spr)*(-1d0/6*p1p3*
     & p2p4/s**2/spr**2+1d0/6*p1p3*p4p5/s**2/spr**2-1d0/6*p1p4*p2p3/s**2
     & /spr**2+1d0/6*p1p4*p3p5/s**2/spr**2+1d0/3*p2p3*p2p4/s**2/spr**2)
     & +vaspr*iz1up**2*theta_hard(s,spr,omega)*betasprtata/pi*alpha**3*q
     & up**2*mup**2*(s-spr)*(-1d0/6*mta**2/s**2/spr)
     & +vaspr*iz1up*iz2up*theta_hard(s,spr,omega)*betasprtata/pi*alpha**
     & 3*qup**2*(s-spr)*(1d0/6*mta**2/spr**2)
     & +vaspr*iz1up*betasprtata/pi*alpha**3*qup**2*(s-spr)*(-1d0/12*mta*
     & *2/s**2/spr-1d0/12*mta**2/s/spr**2)
     & +vaspr*iz2up**2*theta_hard(s,spr,omega)*betasprtata/pi*alpha**3*q
     & up**2*mup**2*(s-spr)*(-1d0/6*mta**2/s**2/spr)
     & +vaspr*iz2up*betasprtata/pi*alpha**3*qup**2*(s-spr)*(-1d0/12*mta*
     & *2/s**2/spr-1d0/12*mta**2/s/spr**2)
     & +vaspr*betasprtata/pi*alpha**3*qup**2*(s-spr)*(-1d0/6*mta**2/s**2
     & /spr**2)

      hardifi=
     & +a2sspr*iz1up*iz3ta*theta_hard(s,spr,omega)*betasprtata/pi*alpha*
     & *3*qup*(s-spr)*(-1d0/3*p1p3*p1p4*p2p3*qta/s**3/spr+1d0/3*p1p3**2*
     & p2p4*qta/s**3/spr)
     & +a2sspr*iz1up*iz3ta*theta_hard(s,spr,omega)*betasprtata/pi*alpha*
     & *3*qup*(s-spr)**2*(1d0/12*p1p3*p1p4*qta/s**3/spr-1d0/12*p1p3*p2p3
     & *qta/s**3/spr)
     & +a2sspr*iz1up*iz4ta*theta_hard(s,spr,omega)*betasprtata/pi*alpha*
     & *3*qup*(s-spr)*(-1d0/3*p1p3*p1p4*p2p4*qta/s**3/spr+1d0/3*p1p4**2*
     & p2p3*qta/s**3/spr)
     & +a2sspr*iz1up*iz4ta*theta_hard(s,spr,omega)*betasprtata/pi*alpha*
     & *3*qup*(s-spr)**2*(1d0/12*p1p3*p1p4*qta/s**3/spr-1d0/12*p1p4*p2p4
     & *qta/s**3/spr)
     & +a2sspr*iz1up*betasprtata/pi*alpha**3*qup*(s-spr)*(1d0/12*p1p3*p2
     & p3*qta/s**3/spr+1d0/12*p1p3*p2p4*qta/s**3/spr+1d0/24*p1p3*qta/s**
     & 2/spr+1d0/12*p1p4*p2p3*qta/s**3/spr+1d0/12*p1p4*p2p4*qta/s**3/spr
     & +1d0/24*p1p4*qta/s**2/spr)
     & +a2sspr*iz2up*iz3ta*theta_hard(s,spr,omega)*betasprtata/pi*alpha*
     & *3*qup*(s-spr)*(-1d0/3*p1p3*p2p3*p2p4*qta/s**3/spr+1d0/3*p1p4*p2p
     & 3**2*qta/s**3/spr)
     & +a2sspr*iz2up*iz3ta*theta_hard(s,spr,omega)*betasprtata/pi*alpha*
     & *3*qup*(s-spr)**2*(-1d0/12*p1p3*p2p3*qta/s**3/spr+1d0/12*p2p3*p2p
     & 4*qta/s**3/spr)
     & +a2sspr*iz2up*iz4ta*theta_hard(s,spr,omega)*betasprtata/pi*alpha*
     & *3*qup*(s-spr)*(1d0/3*p1p3*p2p4**2*qta/s**3/spr-1d0/3*p1p4*p2p3*p
     & 2p4*qta/s**3/spr)
     & +a2sspr*iz2up*iz4ta*theta_hard(s,spr,omega)*betasprtata/pi*alpha*
     & *3*qup*(s-spr)**2*(-1d0/12*p1p4*p2p4*qta/s**3/spr+1d0/12*p2p3*p2p
     & 4*qta/s**3/spr)
     & +a2sspr*iz2up*betasprtata/pi*alpha**3*qup*(s-spr)*(1d0/12*p1p3*p2
     & p3*qta/s**3/spr+1d0/12*p1p3*p2p4*qta/s**3/spr+1d0/12*p1p4*p2p3*qt
     & a/s**3/spr+1d0/12*p1p4*p2p4*qta/s**3/spr+1d0/24*p2p3*qta/s**2/spr
     & +1d0/24*p2p4*qta/s**2/spr)
     & +a2sspr*iz3ta*betasprtata/pi*alpha**3*qup*(s-spr)*(-1d0/12*p1p3*p
     & 1p4*qta/s**3/spr-1d0/12*p1p3*p2p4*qta/s**3/spr-1d0/24*p1p3*qta/s*
     & *3+1d0/12*p1p3*qta*mta**2/s**3/spr-1d0/12*p1p4*p2p3*qta/s**3/spr+
     & 1d0/12*p1p4*qta*mta**2/s**3/spr-1d0/12*p2p3*p2p4*qta/s**3/spr-1d0
     & /24*p2p3*qta/s**3+1d0/12*p2p3*qta*mta**2/s**3/spr+1d0/12*p2p4*qta
     & *mta**2/s**3/spr)
     & +a2sspr*iz4ta*betasprtata/pi*alpha**3*qup*(s-spr)*(-1d0/12*p1p3*p
     & 1p4*qta/s**3/spr-1d0/12*p1p3*p2p4*qta/s**3/spr+1d0/12*p1p3*qta*mt
     & a**2/s**3/spr-1d0/12*p1p4*p2p3*qta/s**3/spr-1d0/24*p1p4*qta/s**3+
     & 1d0/12*p1p4*qta*mta**2/s**3/spr-1d0/12*p2p3*p2p4*qta/s**3/spr+1d0
     & /12*p2p3*qta*mta**2/s**3/spr-1d0/24*p2p4*qta/s**3+1d0/12*p2p4*qta
     & *mta**2/s**3/spr)
     & +a2sspr*betasprtata/pi*alpha**3*qup*(s-spr)*(-1d0/12*p1p3*qta/s**
     & 3/spr-1d0/12*p1p4*qta/s**3/spr-1d0/12*p2p3*qta/s**3/spr-1d0/12*p2
     & p4*qta/s**3/spr)
     & +v2sspr*iz1up*iz3ta*theta_hard(s,spr,omega)*betasprtata/pi*alpha*
     & *3*qup*(s-spr)*(1d0/3*p1p3*p1p4*p2p3*qta/s**3/spr+1d0/3*p1p3**2*p
     & 2p4*qta/s**3/spr)
     & +v2sspr*iz1up*iz3ta*theta_hard(s,spr,omega)*betasprtata/pi*alpha*
     & *3*qup*(s-spr)**2*(-1d0/12*p1p3*p1p4*qta/s**3/spr+1d0/12*p1p3*p2p
     & 3*qta/s**3/spr)
     & +v2sspr*iz1up*iz4ta*theta_hard(s,spr,omega)*betasprtata/pi*alpha*
     & *3*qup*(s-spr)*(-1d0/3*p1p3*p1p4*p2p4*qta/s**3/spr-1d0/3*p1p4**2*
     & p2p3*qta/s**3/spr)
     & +v2sspr*iz1up*iz4ta*theta_hard(s,spr,omega)*betasprtata/pi*alpha*
     & *3*qup*(s-spr)**2*(1d0/12*p1p3*p1p4*qta/s**3/spr-1d0/12*p1p4*p2p4
     & *qta/s**3/spr)
     & +v2sspr*iz1up*betasprtata/pi*alpha**3*qup*(s-spr)*(-1d0/12*p1p3*p
     & 2p3*qta/s**3/spr+1d0/12*p1p3*p2p4*qta/s**3/spr+1d0/24*p1p3*qta/s*
     & *2/spr-1d0/12*p1p4*p2p3*qta/s**3/spr+1d0/12*p1p4*p2p4*qta/s**3/sp
     & r-1d0/24*p1p4*qta/s**2/spr)
     & +v2sspr*iz2up*iz3ta*theta_hard(s,spr,omega)*betasprtata/pi*alpha*
     & *3*qup*(s-spr)*(-1d0/3*p1p3*p2p3*p2p4*qta/s**3/spr-1d0/3*p1p4*p2p
     & 3**2*qta/s**3/spr)
     & +v2sspr*iz2up*iz3ta*theta_hard(s,spr,omega)*betasprtata/pi*alpha*
     & *3*qup*(s-spr)**2*(-1d0/12*p1p3*p2p3*qta/s**3/spr+1d0/12*p2p3*p2p
     & 4*qta/s**3/spr)
     & +v2sspr*iz2up*iz4ta*theta_hard(s,spr,omega)*betasprtata/pi*alpha*
     & *3*qup*(s-spr)*(1d0/3*p1p3*p2p4**2*qta/s**3/spr+1d0/3*p1p4*p2p3*p
     & 2p4*qta/s**3/spr)
     & +v2sspr*iz2up*iz4ta*theta_hard(s,spr,omega)*betasprtata/pi*alpha*
     & *3*qup*(s-spr)**2*(1d0/12*p1p4*p2p4*qta/s**3/spr-1d0/12*p2p3*p2p4
     & *qta/s**3/spr)
     & +v2sspr*iz2up*betasprtata/pi*alpha**3*qup*(s-spr)*(1d0/12*p1p3*p2
     & p3*qta/s**3/spr+1d0/12*p1p3*p2p4*qta/s**3/spr-1d0/12*p1p4*p2p3*qt
     & a/s**3/spr-1d0/12*p1p4*p2p4*qta/s**3/spr-1d0/24*p2p3*qta/s**2/spr
     & +1d0/24*p2p4*qta/s**2/spr)
     & +v2sspr*iz3ta*betasprtata/pi*alpha**3*qup*(s-spr)*(1d0/12*p1p3*p1
     & p4*qta/s**3/spr-1d0/12*p1p3*p2p4*qta/s**3/spr-1d0/24*p1p3*qta/s**
     & 3+1d0/12*p1p3*qta*mta**2/s**3/spr+1d0/12*p1p4*p2p3*qta/s**3/spr-1
     & d0/12*p1p4*qta*mta**2/s**3/spr-1d0/12*p2p3*p2p4*qta/s**3/spr+1d0/
     & 24*p2p3*qta/s**3-1d0/12*p2p3*qta*mta**2/s**3/spr+1d0/12*p2p4*qta*
     & mta**2/s**3/spr)
     & +v2sspr*iz4ta*betasprtata/pi*alpha**3*qup*(s-spr)*(-1d0/12*p1p3*p
     & 1p4*qta/s**3/spr-1d0/12*p1p3*p2p4*qta/s**3/spr+1d0/12*p1p3*qta*mt
     & a**2/s**3/spr+1d0/12*p1p4*p2p3*qta/s**3/spr+1d0/24*p1p4*qta/s**3-
     & 1d0/12*p1p4*qta*mta**2/s**3/spr+1d0/12*p2p3*p2p4*qta/s**3/spr-1d0
     & /12*p2p3*qta*mta**2/s**3/spr-1d0/24*p2p4*qta/s**3+1d0/12*p2p4*qta
     & *mta**2/s**3/spr)
     & +v2sspr*betasprtata/pi*alpha**3*qup*(s-spr)*(-1d0/12*p1p3*qta/s**
     & 3/spr+1d0/12*p1p4*qta/s**3/spr+1d0/12*p2p3*qta/s**3/spr-1d0/12*p2
     & p4*qta/s**3/spr)
     & +vasspr*iz1up*iz3ta*theta_hard(s,spr,omega)*betasprtata*(s+spr)/p
     & i*alpha**3*qup*(s-spr)*(1d0/12*p1p3*qta*mta**2/s**3/spr)
     & +vasspr*iz1up*iz4ta*theta_hard(s,spr,omega)*betasprtata*(s+spr)/p
     & i*alpha**3*qup*(s-spr)*(-1d0/12*p1p4*qta*mta**2/s**3/spr)
     & +vasspr*iz2up*iz3ta*theta_hard(s,spr,omega)*betasprtata*(s+spr)/p
     & i*alpha**3*qup*(s-spr)*(-1d0/12*p2p3*qta*mta**2/s**3/spr)
     & +vasspr*iz2up*iz4ta*theta_hard(s,spr,omega)*betasprtata*(s+spr)/p
     & i*alpha**3*qup*(s-spr)*(1d0/12*p2p4*qta*mta**2/s**3/spr)
     & +vasspr*iz3ta*betasprtata/pi*alpha**3*qup*(s-spr)*(1d0/12*p1p5*qt
     & a*mta**2/s**3/spr-1d0/12*p2p5*qta*mta**2/s**3/spr)
     & +vasspr*iz4ta*betasprtata/pi*alpha**3*qup*(s-spr)*(-1d0/12*p1p5*q
     & ta*mta**2/s**3/spr+1d0/12*p2p5*qta*mta**2/s**3/spr)
     & +a1sspr*iz3ta*betasprtata*(s+spr)/pi*alpha**3*qup**2*(s-spr)*(1d0
     & /24*qta**2*mta**2/s**3/spr)
     & +a1sspr*iz4ta*betasprtata*(s+spr)/pi*alpha**3*qup**2*(s-spr)*(1d0
     & /24*qta**2*mta**2/s**3/spr)

      hardfsr=
     & +a0s*iz3ta**2*theta_hard(s,spr,omega)*betasprtata/pi*alpha**3*(s-
     & spr)*(-1d0/3*p1p3*p2p4*qta**2*mta**2/s**4+1d0/3*p1p4*p2p3*qta**2*
     & mta**2/s**4+1d0/3*p1p4*p2p5*qta**2*mta**2/s**4-1d0/3*p1p5*p2p4*qt
     & a**2*mta**2/s**4)
     & +a0s*iz3ta*iz4ta*theta_hard(s,spr,omega)*betasprtata/pi*alpha**3*
     & (s-spr)*(1d0/3*p1p3*p2p4*qta**2/s**4*spr-2d0/3*p1p3*p2p4*qta**2*m
     & ta**2/s**4+1d0/6*p1p3*p2p5*qta**2/s**4*spr-1d0/3*p1p3*p2p5*qta**2
     & *mta**2/s**4-1d0/3*p1p4*p2p3*qta**2/s**4*spr+2d0/3*p1p4*p2p3*qta*
     & *2*mta**2/s**4-1d0/6*p1p4*p2p5*qta**2/s**4*spr+1d0/3*p1p4*p2p5*qt
     & a**2*mta**2/s**4-1d0/6*p1p5*p2p3*qta**2/s**4*spr+1d0/3*p1p5*p2p3*
     & qta**2*mta**2/s**4+1d0/6*p1p5*p2p4*qta**2/s**4*spr-1d0/3*p1p5*p2p
     & 4*qta**2*mta**2/s**4)
     & +a0s*iz3ta*betasprtata/pi*alpha**3*(s-spr)*(1d0/6*p1p3*p2p4*qta**
     & 2/s**4-1d0/6*p1p4*p2p3*qta**2/s**4-1d0/6*p1p4*p2p5*qta**2/s**4+1d
     & 0/6*p1p5*p2p4*qta**2/s**4)
     & +a0s*iz4ta**2*theta_hard(s,spr,omega)*betasprtata/pi*alpha**3*(s-
     & spr)*(-1d0/3*p1p3*p2p4*qta**2*mta**2/s**4-1d0/3*p1p3*p2p5*qta**2*
     & mta**2/s**4+1d0/3*p1p4*p2p3*qta**2*mta**2/s**4+1d0/3*p1p5*p2p3*qt
     & a**2*mta**2/s**4)
     & +a0s*iz4ta*betasprtata/pi*alpha**3*(s-spr)*(1d0/6*p1p3*p2p4*qta**
     & 2/s**4+1d0/6*p1p3*p2p5*qta**2/s**4-1d0/6*p1p4*p2p3*qta**2/s**4-1d
     & 0/6*p1p5*p2p3*qta**2/s**4)
     & +v0s*iz3ta**2*theta_hard(s,spr,omega)*betasprtata/pi*alpha**3*(s-
     & spr)*(-1d0/3*p1p3*p2p4*qta**2*mta**2/s**4-1d0/3*p1p4*p2p3*qta**2*
     & mta**2/s**4-1d0/3*p1p4*p2p5*qta**2*mta**2/s**4-1d0/3*p1p5*p2p4*qt
     & a**2*mta**2/s**4)
     & +v0s*iz3ta*iz4ta*theta_hard(s,spr,omega)*betasprtata/pi*alpha**3*
     & (s-spr)*(1d0/3*p1p3*p2p4*qta**2/s**4*spr-2d0/3*p1p3*p2p4*qta**2*m
     & ta**2/s**4+1d0/6*p1p3*p2p5*qta**2/s**4*spr-1d0/3*p1p3*p2p5*qta**2
     & *mta**2/s**4+1d0/3*p1p4*p2p3*qta**2/s**4*spr-2d0/3*p1p4*p2p3*qta*
     & *2*mta**2/s**4+1d0/6*p1p4*p2p5*qta**2/s**4*spr-1d0/3*p1p4*p2p5*qt
     & a**2*mta**2/s**4+1d0/6*p1p5*p2p3*qta**2/s**4*spr-1d0/3*p1p5*p2p3*
     & qta**2*mta**2/s**4+1d0/6*p1p5*p2p4*qta**2/s**4*spr-1d0/3*p1p5*p2p
     & 4*qta**2*mta**2/s**4)
     & +v0s*iz3ta*betasprtata/pi*alpha**3*(s-spr)*(-1d0/3*p1p3*p2p3*qta*
     & *2/s**4+1d0/6*p1p3*p2p4*qta**2/s**4+1d0/6*p1p4*p2p3*qta**2/s**4+1
     & d0/6*p1p4*p2p5*qta**2/s**4+1d0/6*p1p5*p2p4*qta**2/s**4)
     & +v0s*iz4ta**2*theta_hard(s,spr,omega)*betasprtata/pi*alpha**3*(s-
     & spr)*(-1d0/3*p1p3*p2p4*qta**2*mta**2/s**4-1d0/3*p1p3*p2p5*qta**2*
     & mta**2/s**4-1d0/3*p1p4*p2p3*qta**2*mta**2/s**4-1d0/3*p1p5*p2p3*qt
     & a**2*mta**2/s**4)
     & +v0s*iz4ta*betasprtata/pi*alpha**3*(s-spr)*(1d0/6*p1p3*p2p4*qta**
     & 2/s**4+1d0/6*p1p3*p2p5*qta**2/s**4+1d0/6*p1p4*p2p3*qta**2/s**4-1d
     & 0/3*p1p4*p2p4*qta**2/s**4+1d0/6*p1p5*p2p3*qta**2/s**4)
     & +vas*iz3ta**2*theta_hard(s,spr,omega)*betasprtata/pi*alpha**3*(s-
     & spr)*(-1d0/6*qta**2*mta**4/s**3)
     & +vas*iz3ta*iz4ta*theta_hard(s,spr,omega)*betasprtata/pi*alpha**3*
     & (s-spr)*(1d0/6*qta**2*mta**2/s**3*spr-1d0/3*qta**2*mta**4/s**3-2d
     & 0/3*p1p5*p2p5*qta**2*mta**2/s**4)
     & +vas*iz4ta**2*theta_hard(s,spr,omega)*betasprtata/pi*alpha**3*(s-
     & spr)*(-1d0/6*qta**2*mta**4/s**3)

      if (iqed.eq.1) then
         hard = hardisr+hardifi+hardfsr
      elseif(iqed.eq.2) then
         hard = hardisr
      elseif(iqed.eq.3) then
         hard = hardifi
      elseif(iqed.eq.4) then
         hard = hardfsr
      elseif(iqed.eq.5) then
         hard = hardifi+hardfsr
      elseif(iqed.eq.6) then
         hard = hardisr+hardifi
      endif

      hard = hard*conhc*cfprime

      return
      end
