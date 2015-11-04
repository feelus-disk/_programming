************************************************************************
* sanc_nc_v1.30 package.
************************************************************************
* File (nc_ha_1313_1212.f) is created on Wed Apr 18 13:26:24 MSK 2012.
************************************************************************
* This is the FORTRAN module (nc_ha_1313_1212) to calculate differential
* hard photon Bremsstrahlung for the anti-up + up -> el^+ + el^- process.
*
* It is produced by s2n package of SANC (v1.10) Project.
* Copyright (C), SANC Project Team, 2002-2012.
*
* http://sanc.jinr.ru/
* http://pcphsanc.cern.ch/
* E-mail: <sanc@jinr.ru>
************************************************************************
      subroutine nc_ha_1313_1212 (s,spr,ph4,costh4,costh5,hard)
      implicit none!
      include 's2n_declare.h'

      real*8 kappaz,sq,sqspr
      real*8 a1z,a2z,v1z,v2z,vaz
      real*8 p1p2,p1p3,p1p4,p1p5,p2p3,p2p4,p2p5,p3p4,p3p5,p4p5
      real*8 ph4,cosph4,sinph4,costh4,costh5,sinth4,sinth5
      complex*16 chizs,chizsc,chizspr,chizsprc

      real*8 betasupup,ibetasupup,betasprelel,ibetasprelel
      real*8 iz1up,iz2up,iz3el,iz4el
      real*8 a0spr,v0spr,a2sspr,v2sspr,a0s,v0s

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

      a1z = aup*ael
      a2z = 4d0*vup*aup*vel*ael
      v1z = vup*vel
      v2z = (vup**2+aup**2)*(vel**2+ael**2)
      vaz = (vup**2+aup**2)*(vel**2-ael**2)

      betasupup = sqrt(1d0-4d0*rupm2/s)
      ibetasupup = 1d0/betasupup
      betasprelel = sqrt(1d0-4d0*relm2/spr)
      ibetasprelel = 1d0/betasprelel
      
      a0spr =
     & +qup*qel*(chizspr+chizsprc)*a1z
     & +chizspr*chizsprc*a2z
      
      v0spr =
     & +qup**2*qel**2
     & +qup*qel*(chizspr+chizsprc)*v1z
     & +chizspr*chizsprc*v2z
      
      a2sspr =
     & +qup*qel*(chizs+chizsc+chizspr+chizsprc)*a1z
     & +(chizs*chizsprc+chizsc*chizspr)*a2z
      
      v2sspr =
     & +2d0*qup**2*qel**2
     & +qup*qel*(chizs+chizsc+chizspr+chizsprc)*v1z
     & +(chizs*chizsprc+chizsc*chizspr)*v2z
      
      a0s =
     & +qup*qel*(chizs+chizsc)*a1z
     & +chizs*chizsc*a2z
      
      v0s =
     & +qup**2*qel**2
     & +qup*qel*(chizs+chizsc)*v1z
     & +chizs*chizsc*v2z

      iz1up=
     & +1d0/(mup**2/s+1d0/4*sinth5**2-sinth5**2*mup**2/s)/(s-spr)*(1d0/2
     & -1d0/2*betasupup*costh5)

      iz2up=
     & +1d0/(mup**2/s+1d0/4*sinth5**2-sinth5**2*mup**2/s)/(s-spr)*(1d0/2
     & +1d0/2*betasupup*costh5)

      iz3el=
     & +1d0/(mel**2/spr+1d0/4*sinth4**2-sinth4**2*mel**2/spr)/(s-spr)*(1
     & d0/2-1d0/2*betasprelel*costh4)

      iz4el=
     & +1d0/(mel**2/spr+1d0/4*sinth4**2-sinth4**2*mel**2/spr)/(s-spr)*(1
     & d0/2+1d0/2*betasprelel*costh4)

      p1p2=
     & -1d0/2*s

      p1p3=
     & +(s-spr)*(1d0/8)
     & +sinph4*sinth4*sinth5*(-1d0/4*sq*sqspr)
     & +costh4*(s-spr)*(-1d0/8)
     & +costh4*costh5*(s-spr)*(-1d0/8)
     & +costh4*costh5*(1d0/4*s)
     & +costh5*(s-spr)*(1d0/8)
     & -1d0/4*s

      p1p4=
     & +(s-spr)*(1d0/8)
     & +sinph4*sinth4*sinth5*(1d0/4*sq*sqspr)
     & +costh4*(s-spr)*(1d0/8)
     & +costh4*costh5*(s-spr)*(1d0/8)
     & +costh4*costh5*(-1d0/4*s)
     & +costh5*(s-spr)*(1d0/8)
     & -1d0/4*s

      p2p3=
     & +(s-spr)*(1d0/8)
     & +sinph4*sinth4*sinth5*(1d0/4*sq*sqspr)
     & +costh4*(s-spr)*(-1d0/8)
     & +costh4*costh5*(s-spr)*(1d0/8)
     & +costh4*costh5*(-1d0/4*s)
     & +costh5*(s-spr)*(-1d0/8)
     & -1d0/4*s

      p2p4=
     & +(s-spr)*(1d0/8)
     & +sinph4*sinth4*sinth5*(-1d0/4*sq*sqspr)
     & +costh4*(s-spr)*(1d0/8)
     & +costh4*costh5*(s-spr)*(-1d0/8)
     & +costh4*costh5*(1d0/4*s)
     & +costh5*(s-spr)*(-1d0/8)
     & -1d0/4*s

      p3p4=
     & +(s-spr)*(1d0/2)
     & -1d0/2*s

      p1p5=
     & +(s-spr)*(-1d0/4)
     & +costh5*(s-spr)*(-1d0/4)

      p2p5=
     & +(s-spr)*(-1d0/4)
     & +costh5*(s-spr)*(1d0/4)

      p3p5=
     & +(s-spr)*(-1d0/4)
     & +costh4*(s-spr)*(-1d0/4)

      p4p5=
     & +(s-spr)*(-1d0/4)
     & +costh4*(s-spr)*(1d0/4)

      hardisr=
     & +a0spr*iz1up/pi*alpha**3*qup**2*(s-spr)*(-1d0/6*p1p3*p2p4/s**2/sp
     & r**2+1d0/6*p1p4*p2p3/s**2/spr**2-1d0/6*p2p3*p4p5/s**2/spr**2+1d0/
     & 6*p2p4*p3p5/s**2/spr**2)
     & +a0spr*iz1up**2*theta_hard(s,spr,omega)/pi*alpha**3*qup**2*mup**2
     & *(s-spr)*(-1d0/3*p1p3*p2p4/s**2/spr**2+1d0/3*p1p4*p2p3/s**2/spr**
     & 2-1d0/3*p2p3*p4p5/s**2/spr**2+1d0/3*p2p4*p3p5/s**2/spr**2)
     & +a0spr*iz1up*iz2up*theta_hard(s,spr,omega)/pi*alpha**3*qup**2*(s-
     & spr)*(1d0/3*p1p3*p2p4/s/spr**2-1d0/6*p1p3*p4p5/s/spr**2-1d0/3*p1p
     & 4*p2p3/s/spr**2+1d0/6*p1p4*p3p5/s/spr**2+1d0/6*p2p3*p4p5/s/spr**2
     & -1d0/6*p2p4*p3p5/s/spr**2)
     & +a0spr*iz2up/pi*alpha**3*qup**2*(s-spr)*(-1d0/6*p1p3*p2p4/s**2/sp
     & r**2+1d0/6*p1p3*p4p5/s**2/spr**2+1d0/6*p1p4*p2p3/s**2/spr**2-1d0/
     & 6*p1p4*p3p5/s**2/spr**2)
     & +a0spr*iz2up**2*theta_hard(s,spr,omega)/pi*alpha**3*qup**2*mup**2
     & *(s-spr)*(-1d0/3*p1p3*p2p4/s**2/spr**2+1d0/3*p1p3*p4p5/s**2/spr**
     & 2+1d0/3*p1p4*p2p3/s**2/spr**2-1d0/3*p1p4*p3p5/s**2/spr**2)
     & +v0spr*iz1up/pi*alpha**3*qup**2*(s-spr)*(1d0/3*p1p3*p1p4/s**2/spr
     & **2-1d0/6*p1p3*p2p4/s**2/spr**2-1d0/6*p1p4*p2p3/s**2/spr**2+1d0/6
     & *p2p3*p4p5/s**2/spr**2+1d0/6*p2p4*p3p5/s**2/spr**2)
     & +v0spr*iz1up**2*theta_hard(s,spr,omega)/pi*alpha**3*qup**2*mup**2
     & *(s-spr)*(-1d0/3*p1p3*p2p4/s**2/spr**2-1d0/3*p1p4*p2p3/s**2/spr**
     & 2+1d0/3*p2p3*p4p5/s**2/spr**2+1d0/3*p2p4*p3p5/s**2/spr**2)
     & +v0spr*iz1up*iz2up*theta_hard(s,spr,omega)/pi*alpha**3*qup**2*(s-
     & spr)*(1d0/3*p1p3*p2p4/s/spr**2-1d0/6*p1p3*p4p5/s/spr**2+1d0/3*p1p
     & 4*p2p3/s/spr**2-1d0/6*p1p4*p3p5/s/spr**2-1d0/6*p2p3*p4p5/s/spr**2
     & -1d0/6*p2p4*p3p5/s/spr**2)
     & +v0spr*iz2up/pi*alpha**3*qup**2*(s-spr)*(-1d0/6*p1p3*p2p4/s**2/sp
     & r**2+1d0/6*p1p3*p4p5/s**2/spr**2-1d0/6*p1p4*p2p3/s**2/spr**2+1d0/
     & 6*p1p4*p3p5/s**2/spr**2+1d0/3*p2p3*p2p4/s**2/spr**2)
     & +v0spr*iz2up**2*theta_hard(s,spr,omega)/pi*alpha**3*qup**2*mup**2
     & *(s-spr)*(-1d0/3*p1p3*p2p4/s**2/spr**2+1d0/3*p1p3*p4p5/s**2/spr**
     & 2-1d0/3*p1p4*p2p3/s**2/spr**2+1d0/3*p1p4*p3p5/s**2/spr**2)

      hardifi=
     & +a2sspr/pi*alpha**3*qel*qup*(s-spr)*(-1d0/12*p1p3/s**3/spr-1d0/12
     & *p1p4/s**3/spr-1d0/12*p2p3/s**3/spr-1d0/12*p2p4/s**3/spr)
     & +a2sspr*iz1up/pi*alpha**3*qel*qup*(s-spr)*(1d0/12*p1p3*p2p3/s**3/
     & spr+1d0/12*p1p3*p2p4/s**3/spr+1d0/24*p1p3/s**2/spr+1d0/12*p1p4*p2
     & p3/s**3/spr+1d0/12*p1p4*p2p4/s**3/spr+1d0/24*p1p4/s**2/spr)
     & +a2sspr*iz1up*iz3el*theta_hard(s,spr,omega)/pi*alpha**3*qel*qup*(
     & s-spr)*(-1d0/3*p1p3*p1p4*p2p3/s**3/spr+1d0/3*p1p3**2*p2p4/s**3/sp
     & r)
     & +a2sspr*iz1up*iz3el*theta_hard(s,spr,omega)/pi*alpha**3*qel*qup*(
     & s-spr)**2*(1d0/12*p1p3*p1p4/s**3/spr-1d0/12*p1p3*p2p3/s**3/spr)
     & +a2sspr*iz1up*iz4el*theta_hard(s,spr,omega)/pi*alpha**3*qel*qup*(
     & s-spr)*(-1d0/3*p1p3*p1p4*p2p4/s**3/spr+1d0/3*p1p4**2*p2p3/s**3/sp
     & r)
     & +a2sspr*iz1up*iz4el*theta_hard(s,spr,omega)/pi*alpha**3*qel*qup*(
     & s-spr)**2*(1d0/12*p1p3*p1p4/s**3/spr-1d0/12*p1p4*p2p4/s**3/spr)
     & +a2sspr*iz2up/pi*alpha**3*qel*qup*(s-spr)*(1d0/12*p1p3*p2p3/s**3/
     & spr+1d0/12*p1p3*p2p4/s**3/spr+1d0/12*p1p4*p2p3/s**3/spr+1d0/12*p1
     & p4*p2p4/s**3/spr+1d0/24*p2p3/s**2/spr+1d0/24*p2p4/s**2/spr)
     & +a2sspr*iz2up*iz3el*theta_hard(s,spr,omega)/pi*alpha**3*qel*qup*(
     & s-spr)*(-1d0/3*p1p3*p2p3*p2p4/s**3/spr+1d0/3*p1p4*p2p3**2/s**3/sp
     & r)
     & +a2sspr*iz2up*iz3el*theta_hard(s,spr,omega)/pi*alpha**3*qel*qup*(
     & s-spr)**2*(-1d0/12*p1p3*p2p3/s**3/spr+1d0/12*p2p3*p2p4/s**3/spr)
     & +a2sspr*iz2up*iz4el*theta_hard(s,spr,omega)/pi*alpha**3*qel*qup*(
     & s-spr)*(1d0/3*p1p3*p2p4**2/s**3/spr-1d0/3*p1p4*p2p3*p2p4/s**3/spr
     & )
     & +a2sspr*iz2up*iz4el*theta_hard(s,spr,omega)/pi*alpha**3*qel*qup*(
     & s-spr)**2*(-1d0/12*p1p4*p2p4/s**3/spr+1d0/12*p2p3*p2p4/s**3/spr)
     & +a2sspr*iz3el/pi*alpha**3*qel*qup*(s-spr)*(-1d0/12*p1p3*p1p4/s**3
     & /spr-1d0/12*p1p3*p2p4/s**3/spr-1d0/24*p1p3/s**3-1d0/12*p1p4*p2p3/
     & s**3/spr-1d0/12*p2p3*p2p4/s**3/spr-1d0/24*p2p3/s**3)
     & +a2sspr*iz4el/pi*alpha**3*qel*qup*(s-spr)*(-1d0/12*p1p3*p1p4/s**3
     & /spr-1d0/12*p1p3*p2p4/s**3/spr-1d0/12*p1p4*p2p3/s**3/spr-1d0/24*p
     & 1p4/s**3-1d0/12*p2p3*p2p4/s**3/spr-1d0/24*p2p4/s**3)
     & +v2sspr/pi*alpha**3*qel*qup*(s-spr)*(-1d0/12*p1p3/s**3/spr+1d0/12
     & *p1p4/s**3/spr+1d0/12*p2p3/s**3/spr-1d0/12*p2p4/s**3/spr)
     & +v2sspr*iz1up/pi*alpha**3*qel*qup*(s-spr)*(-1d0/12*p1p3*p2p3/s**3
     & /spr+1d0/12*p1p3*p2p4/s**3/spr+1d0/24*p1p3/s**2/spr-1d0/12*p1p4*p
     & 2p3/s**3/spr+1d0/12*p1p4*p2p4/s**3/spr-1d0/24*p1p4/s**2/spr)
     & +v2sspr*iz1up*iz3el*theta_hard(s,spr,omega)/pi*alpha**3*qel*qup*(
     & s-spr)*(1d0/3*p1p3*p1p4*p2p3/s**3/spr+1d0/3*p1p3**2*p2p4/s**3/spr
     & )
     & +v2sspr*iz1up*iz3el*theta_hard(s,spr,omega)/pi*alpha**3*qel*qup*(
     & s-spr)**2*(-1d0/12*p1p3*p1p4/s**3/spr+1d0/12*p1p3*p2p3/s**3/spr)
     & +v2sspr*iz1up*iz4el*theta_hard(s,spr,omega)/pi*alpha**3*qel*qup*(
     & s-spr)*(-1d0/3*p1p3*p1p4*p2p4/s**3/spr-1d0/3*p1p4**2*p2p3/s**3/sp
     & r)
     & +v2sspr*iz1up*iz4el*theta_hard(s,spr,omega)/pi*alpha**3*qel*qup*(
     & s-spr)**2*(1d0/12*p1p3*p1p4/s**3/spr-1d0/12*p1p4*p2p4/s**3/spr)
     & +v2sspr*iz2up/pi*alpha**3*qel*qup*(s-spr)*(1d0/12*p1p3*p2p3/s**3/
     & spr+1d0/12*p1p3*p2p4/s**3/spr-1d0/12*p1p4*p2p3/s**3/spr-1d0/12*p1
     & p4*p2p4/s**3/spr-1d0/24*p2p3/s**2/spr+1d0/24*p2p4/s**2/spr)
     & +v2sspr*iz2up*iz3el*theta_hard(s,spr,omega)/pi*alpha**3*qel*qup*(
     & s-spr)*(-1d0/3*p1p3*p2p3*p2p4/s**3/spr-1d0/3*p1p4*p2p3**2/s**3/sp
     & r)
     & +v2sspr*iz2up*iz3el*theta_hard(s,spr,omega)/pi*alpha**3*qel*qup*(
     & s-spr)**2*(-1d0/12*p1p3*p2p3/s**3/spr+1d0/12*p2p3*p2p4/s**3/spr)
     & +v2sspr*iz2up*iz4el*theta_hard(s,spr,omega)/pi*alpha**3*qel*qup*(
     & s-spr)*(1d0/3*p1p3*p2p4**2/s**3/spr+1d0/3*p1p4*p2p3*p2p4/s**3/spr
     & )
     & +v2sspr*iz2up*iz4el*theta_hard(s,spr,omega)/pi*alpha**3*qel*qup*(
     & s-spr)**2*(1d0/12*p1p4*p2p4/s**3/spr-1d0/12*p2p3*p2p4/s**3/spr)
     & +v2sspr*iz3el/pi*alpha**3*qel*qup*(s-spr)*(1d0/12*p1p3*p1p4/s**3/
     & spr-1d0/12*p1p3*p2p4/s**3/spr-1d0/24*p1p3/s**3+1d0/12*p1p4*p2p3/s
     & **3/spr-1d0/12*p2p3*p2p4/s**3/spr+1d0/24*p2p3/s**3)
     & +v2sspr*iz4el/pi*alpha**3*qel*qup*(s-spr)*(-1d0/12*p1p3*p1p4/s**3
     & /spr-1d0/12*p1p3*p2p4/s**3/spr+1d0/12*p1p4*p2p3/s**3/spr+1d0/24*p
     & 1p4/s**3+1d0/12*p2p3*p2p4/s**3/spr-1d0/24*p2p4/s**3)

      hardfsr=
     & +a0s*iz3el/pi*alpha**3*qel**2*(s-spr)*(1d0/6*p1p3*p2p4/s**4-1d0/6
     & *p1p4*p2p3/s**4-1d0/6*p1p4*p2p5/s**4+1d0/6*p1p5*p2p4/s**4)
     & +a0s*iz3el**2*theta_hard(s,spr,omega)/pi*alpha**3*qel**2*mel**2*(
     & s-spr)*(-1d0/3*p1p3*p2p4/s**4+1d0/3*p1p4*p2p3/s**4+1d0/3*p1p4*p2p
     & 5/s**4-1d0/3*p1p5*p2p4/s**4)
     & +a0s*iz3el*iz4el*theta_hard(s,spr,omega)/pi*alpha**3*qel**2*(s-sp
     & r)*(1d0/3*p1p3*p2p4/s**4*spr+1d0/6*p1p3*p2p5/s**4*spr-1d0/3*p1p4*
     & p2p3/s**4*spr-1d0/6*p1p4*p2p5/s**4*spr-1d0/6*p1p5*p2p3/s**4*spr+1
     & d0/6*p1p5*p2p4/s**4*spr)
     & +a0s*iz4el/pi*alpha**3*qel**2*(s-spr)*(1d0/6*p1p3*p2p4/s**4+1d0/6
     & *p1p3*p2p5/s**4-1d0/6*p1p4*p2p3/s**4-1d0/6*p1p5*p2p3/s**4)
     & +a0s*iz4el**2*theta_hard(s,spr,omega)/pi*alpha**3*qel**2*mel**2*(
     & s-spr)*(-1d0/3*p1p3*p2p4/s**4-1d0/3*p1p3*p2p5/s**4+1d0/3*p1p4*p2p
     & 3/s**4+1d0/3*p1p5*p2p3/s**4)
     & +v0s*iz3el/pi*alpha**3*qel**2*(s-spr)*(-1d0/3*p1p3*p2p3/s**4+1d0/
     & 6*p1p3*p2p4/s**4+1d0/6*p1p4*p2p3/s**4+1d0/6*p1p4*p2p5/s**4+1d0/6*
     & p1p5*p2p4/s**4)
     & +v0s*iz3el**2*theta_hard(s,spr,omega)/pi*alpha**3*qel**2*mel**2*(
     & s-spr)*(-1d0/3*p1p3*p2p4/s**4-1d0/3*p1p4*p2p3/s**4-1d0/3*p1p4*p2p
     & 5/s**4-1d0/3*p1p5*p2p4/s**4)
     & +v0s*iz3el*iz4el*theta_hard(s,spr,omega)/pi*alpha**3*qel**2*(s-sp
     & r)*(1d0/3*p1p3*p2p4/s**4*spr+1d0/6*p1p3*p2p5/s**4*spr+1d0/3*p1p4*
     & p2p3/s**4*spr+1d0/6*p1p4*p2p5/s**4*spr+1d0/6*p1p5*p2p3/s**4*spr+1
     & d0/6*p1p5*p2p4/s**4*spr)
     & +v0s*iz4el/pi*alpha**3*qel**2*(s-spr)*(1d0/6*p1p3*p2p4/s**4+1d0/6
     & *p1p3*p2p5/s**4+1d0/6*p1p4*p2p3/s**4-1d0/3*p1p4*p2p4/s**4+1d0/6*p
     & 1p5*p2p3/s**4)
     & +v0s*iz4el**2*theta_hard(s,spr,omega)/pi*alpha**3*qel**2*mel**2*(
     & s-spr)*(-1d0/3*p1p3*p2p4/s**4-1d0/3*p1p3*p2p5/s**4-1d0/3*p1p4*p2p
     & 3/s**4-1d0/3*p1p5*p2p3/s**4)

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
