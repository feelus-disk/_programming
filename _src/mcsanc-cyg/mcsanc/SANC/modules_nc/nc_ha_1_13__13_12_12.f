************************************************************************
* sanc_nc_v1.30 package.
************************************************************************
* File (nc_ha_1_13__13_12_12.f) is created on Fri Aug 16 13:10:03 CEST 2013.
************************************************************************
* This is the FORTRAN module (nc_ha_1_13__13_12_12) to calculate differential
* hard photon Bremsstrahlung for the a + up -> up + el^+ + el^- process.
*
* It is produced by s2n package of SANC (v1.10) Project.
* Copyright (C), SANC Project Team, 2002-2013.
*
* http://sanc.jinr.ru/
* http://pcphsanc.cern.ch/
* E-mail: <sanc@jinr.ru>
************************************************************************
      subroutine nc_ha_1_13__13_12_12 (s,spr,ph3,costh3,costh5,hard)
      implicit none!
      include 's2n_declare.h'

      real*8 kappaz,sq,sqspr,ps
      real*8 a1z,a2z,v1z,v2z,vaz
      real*8 p1p2,p1p3,p1p4,p1p5,p2p3,p2p4,p2p5,p3p4,p3p5,p4p5
      real*8 ph3,cosph3,sinph3,costh3,costh5,sinth3,sinth5
      real*8 sqrtlssprup,isqrtlssprup
      complex*16 chizs,chizsc,chizspr,chizsprc,chizps,chizpsc
      real*8 betasprelel,ibetasprelel
      real*8 iz1up,iz2up,iz3el,iz4el
      real*8 v0ps,v0spr,v0sprps,a0ps,a0spr,a0sprps,a1sprps

      cmz2 = mz2

      sq = dsqrt(s)
      sqspr = dsqrt(spr)

      cosph3 = dcos(ph3)
      sinph3 = dsin(ph3)
      sinth3 = dsqrt(1d0-costh3**2)
      sinth5 = dsqrt(1d0-costh5**2)

      kappaz   = gf*rzm2/(dsqrt(2d0)*8d0*pi)/alpha
      if (irun.eq.0) then
         chizs = 4d0*kappaz*s/(s-cmz2)
         chizspr = 4d0*kappaz*spr/(spr-cmz2)
      else
         chizs = 4d0*kappaz*s/(s-dcmplx(mz**2,-s*wz/mz))
         chizspr = 4d0*kappaz*spr/(spr-dcmplx(mz**2,-spr*wz/mz))
      endif

      sqrtlssprup = sqrt(s**2-2d0*s*(spr+rupm2)+(spr-rupm2)**2)
      isqrtlssprup = 1d0/sqrtlssprup
      ps=(s+mup**2)*(s-spr+mup**2)/2/s-2*mup**2+(s-mup**2)*sqrtlssprup*costh5/2/s

      chizps   = 4d0*kappaz*ps/(ps+mz**2)
      chizsc   = dconjg(chizs)
      chizsprc = dconjg(chizspr)
      chizpsc  = dconjg(chizps)

      a1z = aup*ael
      a2z = 4d0*vup*aup*vel*ael
      v1z = vup*vel
      v2z = (vup**2+aup**2)*(vel**2+ael**2)
      vaz = (vup**2+aup**2)*(vel**2-ael**2)

      betasprelel = sqrt(1d0-4d0*relm2/spr)
      ibetasprelel = 1d0/betasprelel
      
      v0ps =
     & +qup**2*qel**2
     & +qup*qel*(chizps+chizpsc)*v1z
     & +chizps*chizpsc*v2z
      
      v0spr =
     & +qup**2*qel**2
     & +qup*qel*(chizspr+chizsprc)*v1z
     & +chizspr*chizsprc*v2z
      
      v0sprps =
     & +qup**2*qel**2
     & +qup*qel*(chizspr+chizsprc)*v1z
     & +chizps*chizpsc*v2z
      
      a0ps =
     & +qup*qel*(chizps+chizpsc)*a1z
     & +chizps*chizpsc*a2z
      
      a0spr =
     & +qup*qel*(chizspr+chizsprc)*a1z
     & +chizspr*chizsprc*a2z
      
      a0sprps =
     & +qup*qel*(chizspr+chizsprc)*a1z
     & +chizps*chizpsc*a2z
      
      a1sprps =
     & -(chizspr+chizsprc-chizps-chizpsc)*a1z

      p1p2=
     & +sqrtlssprup*costh5*(-1d0/4+1d0/4*mup**2/s)
     & +1d0/4*spr-1d0/4*s+1d0/4*mup**2/s*spr-1d0/2*mup**2-1d0/4*mup**4/s

      p1p3=
     & +sqrtlssprup**2*(-1d0/8/s)
     & +sqrtlssprup*costh3*(1d0/4)
     & +1d0/8/s*spr**2-1d0/8*s-1d0/4*mup**2/s*spr+1d0/8*mup**4/s

      p1p4=
     & +sqrtlssprup**2*(-1d0/8/s)
     & +sqrtlssprup*costh3*(-1d0/4)
     & +1d0/8/s*spr**2-1d0/8*s-1d0/4*mup**2/s*spr+1d0/8*mup**4/s

      p1p5=
     & +sqrtlssprup*costh5*(1d0/4-1d0/4*mup**2/s)
     & +1d0/4*spr-1d0/4*s-1d0/4*mup**2/s*spr+1d0/4*mup**4/s

      p2p3=
     & +sqrtlssprup*costh3*(1d0/8+1d0/8*mup**2/s)
     & +sqrtlssprup*costh5*(1d0/8-1d0/8*mup**2/s)
     & +sinph3*sinth3*sinth5*(-1d0/4*sq*sqspr+1d0/4*sq*sqspr*mup**2/s)
     & +costh3*costh5*(-1d0/8*spr-1d0/8*s+1d0/8*mup**2/s*spr+1d0/4*mup**
     & 2-1d0/8*mup**4/s)
     & -1d0/8*spr-1d0/8*s-1d0/8*mup**2/s*spr+1d0/8*mup**4/s

      p2p4=
     & +sqrtlssprup*costh3*(-1d0/8-1d0/8*mup**2/s)
     & +sqrtlssprup*costh5*(1d0/8-1d0/8*mup**2/s)
     & +sinph3*sinth3*sinth5*(1d0/4*sq*sqspr-1d0/4*sq*sqspr*mup**2/s)
     & +costh3*costh5*(1d0/8*spr+1d0/8*s-1d0/8*mup**2/s*spr-1d0/4*mup**2
     & +1d0/8*mup**4/s)
     & -1d0/8*spr-1d0/8*s-1d0/8*mup**2/s*spr+1d0/8*mup**4/s

      p2p5=
     & -1d0/2*s+1d0/2*mup**2

      p3p4=
     & -1d0/2*spr

      p3p5=
     & +sqrtlssprup*costh3*(1d0/8-1d0/8*mup**2/s)
     & +sqrtlssprup*costh5*(-1d0/8+1d0/8*mup**2/s)
     & +sinph3*sinth3*sinth5*(1d0/4*sq*sqspr-1d0/4*sq*sqspr*mup**2/s)
     & +costh3*costh5*(1d0/8*spr+1d0/8*s-1d0/8*mup**2/s*spr-1d0/4*mup**2
     & +1d0/8*mup**4/s)
     & -1d0/8*spr-1d0/8*s+1d0/8*mup**2/s*spr+1d0/4*mup**2-1d0/8*mup**4/s

      p4p5=
     & +sqrtlssprup*costh3*(-1d0/8+1d0/8*mup**2/s)
     & +sqrtlssprup*costh5*(-1d0/8+1d0/8*mup**2/s)
     & +sinph3*sinth3*sinth5*(-1d0/4*sq*sqspr+1d0/4*sq*sqspr*mup**2/s)
     & +costh3*costh5*(-1d0/8*spr-1d0/8*s+1d0/8*mup**2/s*spr+1d0/4*mup**
     & 2-1d0/8*mup**4/s)
     & -1d0/8*spr-1d0/8*s+1d0/8*mup**2/s*spr+1d0/4*mup**2-1d0/8*mup**4/s

      iz1up=
     & +1d0/(mup**2/s+1d0/4*sqrtlssprup**2*sinth5**2/s**2)/(s-mup**2)*(1
     & -1d0/2/s*spr+1d0/2*sqrtlssprup*costh5/s)
     & +1d0/(mup**2/s+1d0/4*sqrtlssprup**2*sinth5**2/s**2)*(-1d0/2/s)

      iz2up=
     & +1d0/(s-mup**2)*(1)

      iz3el=
     & +1d0/(1d0/4*spr+1d0/4*s-1d0/4*mup**2/s*spr-1d0/2*mup**2+1d0/4*mup
     & **4/s-1d0/4*sqrtlssprup*betasprelel*costh3+1d0/4*sqrtlssprup*beta
     & sprelel*costh3*mup**2/s+1d0/4*sqrtlssprup*costh5-1d0/4*sqrtlsspru
     & p*costh5*mup**2/s-1d0/2*betasprelel*sinph3*sinth3*sinth5*sq*sqspr
     & +1d0/2*betasprelel*sinph3*sinth3*sinth5*sq*sqspr*mup**2/s-1d0/4*b
     & etasprelel*costh3*costh5*spr-1d0/4*betasprelel*costh3*costh5*s+1d
     & 0/4*betasprelel*costh3*costh5*mup**2/s*spr+1d0/2*betasprelel*cost
     & h3*costh5*mup**2-1d0/4*betasprelel*costh3*costh5*mup**4/s)*(1)

      iz4el=
     & +1d0/(1d0/4*spr+1d0/4*s-1d0/4*mup**2/s*spr-1d0/2*mup**2+1d0/4*mup
     & **4/s+1d0/4*sqrtlssprup*betasprelel*costh3-1d0/4*sqrtlssprup*beta
     & sprelel*costh3*mup**2/s+1d0/4*sqrtlssprup*costh5-1d0/4*sqrtlsspru
     & p*costh5*mup**2/s+1d0/2*betasprelel*sinph3*sinth3*sinth5*sq*sqspr
     & -1d0/2*betasprelel*sinph3*sinth3*sinth5*sq*sqspr*mup**2/s+1d0/4*b
     & etasprelel*costh3*costh5*spr+1d0/4*betasprelel*costh3*costh5*s-1d
     & 0/4*betasprelel*costh3*costh5*mup**2/s*spr-1d0/2*betasprelel*cost
     & h3*costh5*mup**2+1d0/4*betasprelel*costh3*costh5*mup**4/s)*(1)

      hard=
     & +v0ps*iz3el/ps**2/(s-mup**2)/pi*alpha**3*qel**2/s*(s-spr)*(p1p3*p
     & 2p3-1d0/2*p1p3*p2p4-1d0/2*p1p4*p2p3+1d0/2*p1p4*p2p5+1d0/2*p1p5*p2
     & p4-p3p4*mup**2+1d0/2*p4p5*mup**2)
     & +v0ps*iz3el**2/ps**2/(s-mup**2)/pi*alpha**3*qel**2/s*(s-spr)*(-p1
     & p3*p2p4*mel**2-p1p4*p2p3*mel**2+p1p4*p2p5*mel**2+p1p5*p2p4*mel**2
     & -p3p4*mel**2*mup**2+p4p5*mel**2*mup**2)
     & +v0ps*iz3el*iz4el/ps**2/(s-mup**2)/pi*alpha**3*qel**2/s*(s-spr)*(
     & -2*p1p3*p2p4*p3p4+p1p3*p2p5*p3p4-2*p1p4*p2p3*p3p4+p1p4*p2p5*p3p4+
     & p1p5*p2p3*p3p4+p1p5*p2p4*p3p4-2*p3p4**2*mup**2)
     & +v0ps*iz4el/ps**2/(s-mup**2)/pi*alpha**3*qel**2/s*(s-spr)*(-1d0/2
     & *p1p3*p2p4+1d0/2*p1p3*p2p5-1d0/2*p1p4*p2p3+p1p4*p2p4+1d0/2*p1p5*p
     & 2p3-p3p4*mup**2+1d0/2*p3p5*mup**2)
     & +v0ps*iz4el**2/ps**2/(s-mup**2)/pi*alpha**3*qel**2/s*(s-spr)*(-p1
     & p3*p2p4*mel**2+p1p3*p2p5*mel**2-p1p4*p2p3*mel**2+p1p5*p2p3*mel**2
     & -p3p4*mel**2*mup**2+p3p5*mel**2*mup**2)
     & +v0spr*iz1up/(s-mup**2)/pi*alpha**3*qup**2/s/spr**2*(s-spr)*(-p1p
     & 3*p1p4-1d0/2*p1p3*p2p4-1d0/2*p1p4*p2p3+1d0/2*p2p3*p4p5+1d0/2*p2p4
     & *p3p5)
     & +v0spr*iz1up**2/(s-mup**2)/pi*alpha**3*qup**2/s/spr**2*(s-spr)*(-
     & p1p3*p2p4*mup**2-p1p4*p2p3*mup**2+p2p3*p4p5*mup**2+p2p4*p3p5*mup*
     & *2-p3p4*mup**4)
     & +v0spr*iz1up*iz2up/(s-mup**2)/pi*alpha**3*qup**2/s/spr**2*(s-spr)
     & *(-2*p1p2*p1p3*p2p4-p1p2*p1p3*p4p5-2*p1p2*p1p4*p2p3-p1p2*p1p4*p3p
     & 5+p1p2*p2p3*p4p5+p1p2*p2p4*p3p5-2*p1p2*p3p4*mup**2-2*p3p5*p4p5*mu
     & p**2)
     & +v0spr*iz2up/(s-mup**2)/pi*alpha**3*qup**2/s/spr**2*(s-spr)*(1d0/
     & 2*p1p3*p2p4+1d0/2*p1p3*p4p5+1d0/2*p1p4*p2p3+1d0/2*p1p4*p3p5+p2p3*
     & p2p4)
     & +v0spr*iz2up**2/(s-mup**2)/pi*alpha**3*qup**2/s/spr**2*(s-spr)*(-
     & p1p3*p2p4*mup**2-p1p3*p4p5*mup**2-p1p4*p2p3*mup**2-p1p4*p3p5*mup*
     & *2-p3p4*mup**4)
     & +v0sprps/ps/(s-mup**2)/pi*alpha**3*qel*qup/s/spr*(s-spr)*(1d0/4*p
     & 1p3-1d0/4*p1p4+1d0/4*p2p3-1d0/4*p2p4)
     & +v0sprps*iz1up/ps/(s-mup**2)/pi*alpha**3*qel*qup/s/spr*(s-spr)*(-
     & 1d0/4*p1p2*p1p3+1d0/4*p1p2*p1p4-1d0/4*p1p3*p2p4-1d0/4*p1p3*mup**2
     & +1d0/4*p1p4*p2p3+1d0/4*p1p4*mup**2+1d0/4*p2p3*mup**2-1d0/4*p2p4*m
     & up**2-1d0/4*p3p5*mup**2+1d0/4*p4p5*mup**2)
     & +v0sprps*iz1up*iz3el/ps/(s-mup**2)/pi*alpha**3*qel*qup/s/spr*(s-s
     & pr)*(-p1p3*p1p4*p2p3+1d0/2*p1p3*p1p4*p2p5+1d0/2*p1p3*p2p3*p4p5-p1
     & p3*p3p4*mup**2+1d0/2*p1p3*p4p5*mup**2-p1p3**2*p2p4)
     & +v0sprps*iz1up*iz4el/ps/(s-mup**2)/pi*alpha**3*qel*qup/s/spr*(s-s
     & pr)*(p1p3*p1p4*p2p4-1d0/2*p1p3*p1p4*p2p5-1d0/2*p1p4*p2p4*p3p5+p1p
     & 4*p3p4*mup**2-1d0/2*p1p4*p3p5*mup**2+p1p4**2*p2p3)
     & +v0sprps*iz2up/ps/(s-mup**2)/pi*alpha**3*qel*qup/s/spr*(s-spr)*(1
     & d0/4*p1p2*p2p3-1d0/4*p1p2*p2p4+1d0/4*p1p3*p2p4-1d0/4*p1p3*mup**2-
     & 1d0/4*p1p4*p2p3+1d0/4*p1p4*mup**2+1d0/4*p2p3*mup**2-1d0/4*p2p4*mu
     & p**2-1d0/4*p3p5*mup**2+1d0/4*p4p5*mup**2)
     & +v0sprps*iz2up*iz3el/ps/(s-mup**2)/pi*alpha**3*qel*qup/s/spr*(s-s
     & pr)*(p1p3*p2p3*p2p4+1d0/2*p1p3*p2p3*p4p5+p1p4*p2p3**2-1d0/2*p1p5*
     & p2p3*p2p4+p2p3*p3p4*mup**2-1d0/2*p2p3*p4p5*mup**2)
     & +v0sprps*iz2up*iz4el/ps/(s-mup**2)/pi*alpha**3*qel*qup/s/spr*(s-s
     & pr)*(-p1p3*p2p4**2-p1p4*p2p3*p2p4-1d0/2*p1p4*p2p4*p3p5+1d0/2*p1p5
     & *p2p3*p2p4-p2p4*p3p4*mup**2+1d0/2*p2p4*p3p5*mup**2)
     & +v0sprps*iz3el/ps/(s-mup**2)/pi*alpha**3*qel*qup/s/spr*(s-spr)*(-
     & 1d0/4*p1p3*p2p4+1d0/4*p1p3*p3p4+1d0/4*p1p4*p2p3+1d0/4*p2p3*p3p4)
     & +v0sprps*iz4el/ps/(s-mup**2)/pi*alpha**3*qel*qup/s/spr*(s-spr)*(-
     & 1d0/4*p1p3*p2p4+1d0/4*p1p4*p2p3-1d0/4*p1p4*p3p4-1d0/4*p2p4*p3p4)
     & +a0ps*iz3el/ps**2/(s-mup**2)/pi*alpha**3*qel**2/s*(s-spr)*(-1d0/2
     & *p1p3*p2p4+1d0/2*p1p4*p2p3-1d0/2*p1p4*p2p5+1d0/2*p1p5*p2p4)
     & +a0ps*iz3el**2/ps**2/(s-mup**2)/pi*alpha**3*qel**2/s*(s-spr)*(-p1
     & p3*p2p4*mel**2+p1p4*p2p3*mel**2-p1p4*p2p5*mel**2+p1p5*p2p4*mel**2
     & )
     & +a0ps*iz3el*iz4el/ps**2/(s-mup**2)/pi*alpha**3*qel**2/s*(s-spr)*(
     & -2*p1p3*p2p4*p3p4+p1p3*p2p5*p3p4+2*p1p4*p2p3*p3p4-p1p4*p2p5*p3p4-
     & p1p5*p2p3*p3p4+p1p5*p2p4*p3p4)
     & +a0ps*iz4el/ps**2/(s-mup**2)/pi*alpha**3*qel**2/s*(s-spr)*(-1d0/2
     & *p1p3*p2p4+1d0/2*p1p3*p2p5+1d0/2*p1p4*p2p3-1d0/2*p1p5*p2p3)
     & +a0ps*iz4el**2/ps**2/(s-mup**2)/pi*alpha**3*qel**2/s*(s-spr)*(-p1
     & p3*p2p4*mel**2+p1p3*p2p5*mel**2+p1p4*p2p3*mel**2-p1p5*p2p3*mel**2
     & )
     & +a0spr*iz1up/(s-mup**2)/pi*alpha**3*qup**2/s/spr**2*(s-spr)*(-1d0
     & /2*p1p3*p2p4+1d0/2*p1p4*p2p3-1d0/2*p2p3*p4p5+1d0/2*p2p4*p3p5)
     & +a0spr*iz1up**2/(s-mup**2)/pi*alpha**3*qup**2/s/spr**2*(s-spr)*(-
     & p1p3*p2p4*mup**2+p1p4*p2p3*mup**2-p2p3*p4p5*mup**2+p2p4*p3p5*mup*
     & *2)
     & +a0spr*iz1up*iz2up/(s-mup**2)/pi*alpha**3*qup**2/s/spr**2*(s-spr)
     & *(-2*p1p2*p1p3*p2p4-p1p2*p1p3*p4p5+2*p1p2*p1p4*p2p3+p1p2*p1p4*p3p
     & 5-p1p2*p2p3*p4p5+p1p2*p2p4*p3p5)
     & +a0spr*iz2up/(s-mup**2)/pi*alpha**3*qup**2/s/spr**2*(s-spr)*(1d0/
     & 2*p1p3*p2p4+1d0/2*p1p3*p4p5-1d0/2*p1p4*p2p3-1d0/2*p1p4*p3p5)
     & +a0spr*iz2up**2/(s-mup**2)/pi*alpha**3*qup**2/s/spr**2*(s-spr)*(-
     & p1p3*p2p4*mup**2-p1p3*p4p5*mup**2+p1p4*p2p3*mup**2+p1p4*p3p5*mup*
     & *2)
     & +a0sprps/ps/(s-mup**2)/pi*alpha**3*qel*qup/s/spr*(s-spr)*(1d0/4*p
     & 1p3+1d0/4*p1p4-1d0/4*p2p3-1d0/4*p2p4)
     & +a0sprps*iz1up/ps/(s-mup**2)/pi*alpha**3*qel*qup/s/spr*(s-spr)*(-
     & 1d0/4*p1p2*p1p3-1d0/4*p1p2*p1p4-1d0/4*p1p3*p2p4-1d0/4*p1p4*p2p3-1
     & d0/4*p2p3*mup**2-1d0/4*p2p4*mup**2)
     & +a0sprps*iz1up*iz3el/ps/(s-mup**2)/pi*alpha**3*qel*qup/s/spr*(s-s
     & pr)*(p1p3*p1p4*p2p3-1d0/2*p1p3*p1p4*p2p5-1d0/2*p1p3*p2p3*p4p5-p1p
     & 3**2*p2p4)
     & +a0sprps*iz1up*iz4el/ps/(s-mup**2)/pi*alpha**3*qel*qup/s/spr*(s-s
     & pr)*(p1p3*p1p4*p2p4-1d0/2*p1p3*p1p4*p2p5-1d0/2*p1p4*p2p4*p3p5-p1p
     & 4**2*p2p3)
     & +a0sprps*iz2up/ps/(s-mup**2)/pi*alpha**3*qel*qup/s/spr*(s-spr)*(-
     & 1d0/4*p1p2*p2p3-1d0/4*p1p2*p2p4+1d0/4*p1p3*p2p4-1d0/4*p1p3*mup**2
     & +1d0/4*p1p4*p2p3-1d0/4*p1p4*mup**2)
     & +a0sprps*iz2up*iz3el/ps/(s-mup**2)/pi*alpha**3*qel*qup/s/spr*(s-s
     & pr)*(p1p3*p2p3*p2p4+1d0/2*p1p3*p2p3*p4p5-p1p4*p2p3**2-1d0/2*p1p5*
     & p2p3*p2p4)
     & +a0sprps*iz2up*iz4el/ps/(s-mup**2)/pi*alpha**3*qel*qup/s/spr*(s-s
     & pr)*(-p1p3*p2p4**2+p1p4*p2p3*p2p4+1d0/2*p1p4*p2p4*p3p5-1d0/2*p1p5
     & *p2p3*p2p4)
     & +a0sprps*iz3el/ps/(s-mup**2)/pi*alpha**3*qel*qup/s/spr*(s-spr)*(-
     & 1d0/4*p1p3*p2p4+1d0/4*p1p3*p3p4-1d0/4*p1p4*p2p3-1d0/4*p2p3*p3p4)
     & +a0sprps*iz4el/ps/(s-mup**2)/pi*alpha**3*qel*qup/s/spr*(s-spr)*(-
     & 1d0/4*p1p3*p2p4-1d0/4*p1p4*p2p3+1d0/4*p1p4*p3p4-1d0/4*p2p4*p3p4)
     & +a1sprps*iz1up/ps/(s-mup**2)/pi*alpha**3*qel**2*qup**2/s/spr*(s-s
     & pr)*(1d0/2*p3p4*mup**2-1d0/4*p3p5*mup**2-1d0/4*p4p5*mup**2)
     & +a1sprps*iz1up*iz3el*chizsprc/ps/(s-mup**2)*a1z/pi*alpha**3*qel*q
     & up/s/spr*(s-spr)*(2*p1p3*p3p4*mup**2-p1p3*p4p5*mup**2)
     & +a1sprps*iz1up*iz4el*chizsprc/ps/(s-mup**2)*a1z/pi*alpha**3*qel*q
     & up/s/spr*(s-spr)*(-2*p1p4*p3p4*mup**2+p1p4*p3p5*mup**2)
     & +a1sprps*iz1up*chizsprc/ps/(s-mup**2)*a1z/pi*alpha**3*qel*qup/s/s
     & pr*(s-spr)*(1d0/2*p1p3*mup**2-1d0/2*p1p4*mup**2+1d0/2*p3p5*mup**2
     & -1d0/2*p4p5*mup**2)
     & +a1sprps*iz2up/ps/(s-mup**2)/pi*alpha**3*qel**2*qup**2/s/spr*(s-s
     & pr)*(-1d0/2*p3p4*mup**2+1d0/4*p3p5*mup**2+1d0/4*p4p5*mup**2)
     & +a1sprps*iz2up*iz3el*chizsprc/ps/(s-mup**2)*a1z/pi*alpha**3*qel*q
     & up/s/spr*(s-spr)*(-2*p2p3*p3p4*mup**2+p2p3*p4p5*mup**2)
     & +a1sprps*iz2up*iz4el*chizsprc/ps/(s-mup**2)*a1z/pi*alpha**3*qel*q
     & up/s/spr*(s-spr)*(2*p2p4*p3p4*mup**2-p2p4*p3p5*mup**2)
     & +a1sprps*iz2up*chizsprc/ps/(s-mup**2)*a1z/pi*alpha**3*qel*qup/s/s
     & pr*(s-spr)*(-1d0/2*p2p3*mup**2+1d0/2*p2p4*mup**2+1d0/2*p3p5*mup**
     & 2-1d0/2*p4p5*mup**2)
     & +a1sprps*iz3el**2*chizpsc/ps**2/(s-mup**2)*a1z/pi*alpha**3*qel**2
     & /s*(s-spr)*(2*p3p4*mel**2*mup**2-2*p4p5*mel**2*mup**2)
     & +a1sprps*iz3el*iz4el*chizpsc/ps**2/(s-mup**2)*a1z/pi*alpha**3*qel
     & **2/s*(s-spr)*(4*p3p4**2*mup**2)
     & +a1sprps*iz3el*chizpsc/ps**2/(s-mup**2)*a1z/pi*alpha**3*qel**2/s*
     & (s-spr)*(2*p3p4*mup**2-p4p5*mup**2)
     & +a1sprps*iz4el**2*chizpsc/ps**2/(s-mup**2)*a1z/pi*alpha**3*qel**2
     & /s*(s-spr)*(2*p3p4*mel**2*mup**2-2*p3p5*mel**2*mup**2)
     & +a1sprps*iz4el*chizpsc/ps**2/(s-mup**2)*a1z/pi*alpha**3*qel**2/s*
     & (s-spr)*(2*p3p4*mup**2-p3p5*mup**2)
     & +iz1up**2*chizspr*chizsprc/(s-mup**2)/pi*alpha**3*qup**2/s/spr**2
     & *(s-spr)*(2*p3p4*vel**2*aup**2*mup**4)
     & +iz1up**2*chizspr*chizsprc/(s-mup**2)*a1z**2/pi*alpha**3*qup**2/s
     & /spr**2*(s-spr)*(2*p3p4*mup**4)
     & +iz1up*iz2up*chizspr*chizsprc/(s-mup**2)/pi*alpha**3*qup**2/s/spr
     & **2*(s-spr)*(4*p1p2*p3p4*vel**2*aup**2*mup**2+4*p3p5*p4p5*vel**2*
     & aup**2*mup**2)
     & +iz1up*iz2up*chizspr*chizsprc/(s-mup**2)*a1z**2/pi*alpha**3*qup**
     & 2/s/spr**2*(s-spr)*(4*p1p2*p3p4*mup**2+4*p3p5*p4p5*mup**2)
     & +iz1up*iz3el*chizps*chizsprc/ps/(s-mup**2)/pi*alpha**3*qel*qup/s/
     & spr*(s-spr)*(2*p1p3*p3p4*vel**2*aup**2*mup**2-p1p3*p4p5*vel**2*au
     & p**2*mup**2)
     & +iz1up*iz3el*chizspr*chizpsc/ps/(s-mup**2)/pi*alpha**3*qel*qup/s/
     & spr*(s-spr)*(2*p1p3*p3p4*vel**2*aup**2*mup**2-p1p3*p4p5*vel**2*au
     & p**2*mup**2)
     & +iz1up*iz3el*chizspr*chizpsc/ps/(s-mup**2)*a1z**2/pi*alpha**3*qel
     & *qup/s/spr*(s-spr)*(2*p1p3*p3p4*mup**2-p1p3*p4p5*mup**2)
     & +iz1up*iz3el*chizspr*chizsprc/ps/(s-mup**2)*a1z**2/pi*alpha**3*qe
     & l*qup/s/spr*(s-spr)*(2*p1p3*p3p4*mup**2-p1p3*p4p5*mup**2)
     & +iz1up*iz3el*chizpsc*chizsprc/ps/(s-mup**2)*a1z**2/pi*alpha**3*qe
     & l*qup/s/spr*(s-spr)*(-2*p1p3*p3p4*mup**2+p1p3*p4p5*mup**2)
     & +iz1up*iz3el*chizsprc**2/ps/(s-mup**2)*a1z**2/pi*alpha**3*qel*qup
     & /s/spr*(s-spr)*(2*p1p3*p3p4*mup**2-p1p3*p4p5*mup**2)
     & +iz1up*iz4el*chizps*chizsprc/ps/(s-mup**2)/pi*alpha**3*qel*qup/s/
     & spr*(s-spr)*(-2*p1p4*p3p4*vel**2*aup**2*mup**2+p1p4*p3p5*vel**2*a
     & up**2*mup**2)
     & +iz1up*iz4el*chizspr*chizpsc/ps/(s-mup**2)/pi*alpha**3*qel*qup/s/
     & spr*(s-spr)*(-2*p1p4*p3p4*vel**2*aup**2*mup**2+p1p4*p3p5*vel**2*a
     & up**2*mup**2)
     & +iz1up*iz4el*chizspr*chizpsc/ps/(s-mup**2)*a1z**2/pi*alpha**3*qel
     & *qup/s/spr*(s-spr)*(-2*p1p4*p3p4*mup**2+p1p4*p3p5*mup**2)
     & +iz1up*iz4el*chizspr*chizsprc/ps/(s-mup**2)*a1z**2/pi*alpha**3*qe
     & l*qup/s/spr*(s-spr)*(-2*p1p4*p3p4*mup**2+p1p4*p3p5*mup**2)
     & +iz1up*iz4el*chizpsc*chizsprc/ps/(s-mup**2)*a1z**2/pi*alpha**3*qe
     & l*qup/s/spr*(s-spr)*(2*p1p4*p3p4*mup**2-p1p4*p3p5*mup**2)
     & +iz1up*iz4el*chizsprc**2/ps/(s-mup**2)*a1z**2/pi*alpha**3*qel*qup
     & /s/spr*(s-spr)*(-2*p1p4*p3p4*mup**2+p1p4*p3p5*mup**2)
     & +iz1up*chizps*chizsprc/ps/(s-mup**2)/pi*alpha**3*qel*qup/s/spr*(s
     & -spr)*(1d0/2*p1p3*vel**2*aup**2*mup**2-1d0/2*p1p4*vel**2*aup**2*m
     & up**2+1d0/2*p3p5*vel**2*aup**2*mup**2-1d0/2*p4p5*vel**2*aup**2*mu
     & p**2)
     & +iz1up*chizspr*chizpsc/ps/(s-mup**2)/pi*alpha**3*qel*qup/s/spr*(s
     & -spr)*(1d0/2*p1p3*vel**2*aup**2*mup**2-1d0/2*p1p4*vel**2*aup**2*m
     & up**2+1d0/2*p3p5*vel**2*aup**2*mup**2-1d0/2*p4p5*vel**2*aup**2*mu
     & p**2)
     & +iz1up*chizspr*chizpsc/ps/(s-mup**2)*a1z**2/pi*alpha**3*qel*qup/s
     & /spr*(s-spr)*(1d0/2*p1p3*mup**2-1d0/2*p1p4*mup**2+1d0/2*p3p5*mup*
     & *2-1d0/2*p4p5*mup**2)
     & +iz1up*chizspr*chizsprc/ps/(s-mup**2)*a1z**2/pi*alpha**3*qel*qup/
     & s/spr*(s-spr)*(1d0/2*p1p3*mup**2-1d0/2*p1p4*mup**2+1d0/2*p3p5*mup
     & **2-1d0/2*p4p5*mup**2)
     & +iz1up*chizpsc*chizsprc/ps/(s-mup**2)*a1z**2/pi*alpha**3*qel*qup/
     & s/spr*(s-spr)*(-1d0/2*p1p3*mup**2+1d0/2*p1p4*mup**2-1d0/2*p3p5*mu
     & p**2+1d0/2*p4p5*mup**2)
     & +iz1up*chizsprc**2/ps/(s-mup**2)*a1z**2/pi*alpha**3*qel*qup/s/spr
     & *(s-spr)*(1d0/2*p1p3*mup**2-1d0/2*p1p4*mup**2+1d0/2*p3p5*mup**2-1
     & d0/2*p4p5*mup**2)
     & +iz2up**2*chizspr*chizsprc/(s-mup**2)/pi*alpha**3*qup**2/s/spr**2
     & *(s-spr)*(2*p3p4*vel**2*aup**2*mup**4)
     & +iz2up**2*chizspr*chizsprc/(s-mup**2)*a1z**2/pi*alpha**3*qup**2/s
     & /spr**2*(s-spr)*(2*p3p4*mup**4)
     & +iz2up*iz3el*chizps*chizsprc/ps/(s-mup**2)/pi*alpha**3*qel*qup/s/
     & spr*(s-spr)*(-2*p2p3*p3p4*vel**2*aup**2*mup**2+p2p3*p4p5*vel**2*a
     & up**2*mup**2)
     & +iz2up*iz3el*chizspr*chizpsc/ps/(s-mup**2)/pi*alpha**3*qel*qup/s/
     & spr*(s-spr)*(-2*p2p3*p3p4*vel**2*aup**2*mup**2+p2p3*p4p5*vel**2*a
     & up**2*mup**2)
     & +iz2up*iz3el*chizspr*chizpsc/ps/(s-mup**2)*a1z**2/pi*alpha**3*qel
     & *qup/s/spr*(s-spr)*(-2*p2p3*p3p4*mup**2+p2p3*p4p5*mup**2)
     & +iz2up*iz3el*chizspr*chizsprc/ps/(s-mup**2)*a1z**2/pi*alpha**3*qe
     & l*qup/s/spr*(s-spr)*(-2*p2p3*p3p4*mup**2+p2p3*p4p5*mup**2)
     & +iz2up*iz3el*chizpsc*chizsprc/ps/(s-mup**2)*a1z**2/pi*alpha**3*qe
     & l*qup/s/spr*(s-spr)*(2*p2p3*p3p4*mup**2-p2p3*p4p5*mup**2)
     & +iz2up*iz3el*chizsprc**2/ps/(s-mup**2)*a1z**2/pi*alpha**3*qel*qup
     & /s/spr*(s-spr)*(-2*p2p3*p3p4*mup**2+p2p3*p4p5*mup**2)
     & +iz2up*iz4el*chizps*chizsprc/ps/(s-mup**2)/pi*alpha**3*qel*qup/s/
     & spr*(s-spr)*(2*p2p4*p3p4*vel**2*aup**2*mup**2-p2p4*p3p5*vel**2*au
     & p**2*mup**2)
     & +iz2up*iz4el*chizspr*chizpsc/ps/(s-mup**2)/pi*alpha**3*qel*qup/s/
     & spr*(s-spr)*(2*p2p4*p3p4*vel**2*aup**2*mup**2-p2p4*p3p5*vel**2*au
     & p**2*mup**2)
     & +iz2up*iz4el*chizspr*chizpsc/ps/(s-mup**2)*a1z**2/pi*alpha**3*qel
     & *qup/s/spr*(s-spr)*(2*p2p4*p3p4*mup**2-p2p4*p3p5*mup**2)
     & +iz2up*iz4el*chizspr*chizsprc/ps/(s-mup**2)*a1z**2/pi*alpha**3*qe
     & l*qup/s/spr*(s-spr)*(2*p2p4*p3p4*mup**2-p2p4*p3p5*mup**2)
     & +iz2up*iz4el*chizpsc*chizsprc/ps/(s-mup**2)*a1z**2/pi*alpha**3*qe
     & l*qup/s/spr*(s-spr)*(-2*p2p4*p3p4*mup**2+p2p4*p3p5*mup**2)
     & +iz2up*iz4el*chizsprc**2/ps/(s-mup**2)*a1z**2/pi*alpha**3*qel*qup
     & /s/spr*(s-spr)*(2*p2p4*p3p4*mup**2-p2p4*p3p5*mup**2)
     & +iz2up*chizps*chizsprc/ps/(s-mup**2)/pi*alpha**3*qel*qup/s/spr*(s
     & -spr)*(-1d0/2*p2p3*vel**2*aup**2*mup**2+1d0/2*p2p4*vel**2*aup**2*
     & mup**2+1d0/2*p3p5*vel**2*aup**2*mup**2-1d0/2*p4p5*vel**2*aup**2*m
     & up**2)
     & +iz2up*chizspr*chizpsc/ps/(s-mup**2)/pi*alpha**3*qel*qup/s/spr*(s
     & -spr)*(-1d0/2*p2p3*vel**2*aup**2*mup**2+1d0/2*p2p4*vel**2*aup**2*
     & mup**2+1d0/2*p3p5*vel**2*aup**2*mup**2-1d0/2*p4p5*vel**2*aup**2*m
     & up**2)
     & +iz2up*chizspr*chizpsc/ps/(s-mup**2)*a1z**2/pi*alpha**3*qel*qup/s
     & /spr*(s-spr)*(-1d0/2*p2p3*mup**2+1d0/2*p2p4*mup**2+1d0/2*p3p5*mup
     & **2-1d0/2*p4p5*mup**2)
     & +iz2up*chizspr*chizsprc/ps/(s-mup**2)*a1z**2/pi*alpha**3*qel*qup/
     & s/spr*(s-spr)*(-1d0/2*p2p3*mup**2+1d0/2*p2p4*mup**2+1d0/2*p3p5*mu
     & p**2-1d0/2*p4p5*mup**2)
     & +iz2up*chizpsc*chizsprc/ps/(s-mup**2)*a1z**2/pi*alpha**3*qel*qup/
     & s/spr*(s-spr)*(1d0/2*p2p3*mup**2-1d0/2*p2p4*mup**2-1d0/2*p3p5*mup
     & **2+1d0/2*p4p5*mup**2)
     & +iz2up*chizsprc**2/ps/(s-mup**2)*a1z**2/pi*alpha**3*qel*qup/s/spr
     & *(s-spr)*(-1d0/2*p2p3*mup**2+1d0/2*p2p4*mup**2+1d0/2*p3p5*mup**2-
     & 1d0/2*p4p5*mup**2)
     & +iz3el**2*chizps*chizpsc/ps**2/(s-mup**2)/pi*alpha**3*qel**2/s*(s
     & -spr)*(2*p3p4*vel**2*aup**2*mel**2*mup**2-2*p4p5*vel**2*aup**2*me
     & l**2*mup**2)
     & +iz3el**2*chizspr*chizpsc/ps**2/(s-mup**2)*a1z**2/pi*alpha**3*qel
     & **2/s*(s-spr)*(2*p3p4*mel**2*mup**2-2*p4p5*mel**2*mup**2)
     & +iz3el**2*chizpsc**2/ps**2/(s-mup**2)*a1z**2/pi*alpha**3*qel**2/s
     & *(s-spr)*(-2*p3p4*mel**2*mup**2+2*p4p5*mel**2*mup**2)
     & +iz3el**2*chizpsc*chizsprc/ps**2/(s-mup**2)*a1z**2/pi*alpha**3*qe
     & l**2/s*(s-spr)*(2*p3p4*mel**2*mup**2-2*p4p5*mel**2*mup**2)
     & +iz3el*iz4el*chizps*chizpsc/ps**2/(s-mup**2)/pi*alpha**3*qel**2/s
     & *(s-spr)*(4*p3p4**2*vel**2*aup**2*mup**2)
     & +iz3el*iz4el*chizspr*chizpsc/ps**2/(s-mup**2)*a1z**2/pi*alpha**3*
     & qel**2/s*(s-spr)*(4*p3p4**2*mup**2)
     & +iz3el*iz4el*chizpsc**2/ps**2/(s-mup**2)*a1z**2/pi*alpha**3*qel**
     & 2/s*(s-spr)*(-4*p3p4**2*mup**2)
     & +iz3el*iz4el*chizpsc*chizsprc/ps**2/(s-mup**2)*a1z**2/pi*alpha**3
     & *qel**2/s*(s-spr)*(4*p3p4**2*mup**2)
     & +iz3el*chizps*chizpsc/ps**2/(s-mup**2)/pi*alpha**3*qel**2/s*(s-sp
     & r)*(2*p3p4*vel**2*aup**2*mup**2-p4p5*vel**2*aup**2*mup**2)
     & +iz3el*chizspr*chizpsc/ps**2/(s-mup**2)*a1z**2/pi*alpha**3*qel**2
     & /s*(s-spr)*(2*p3p4*mup**2-p4p5*mup**2)
     & +iz3el*chizpsc**2/ps**2/(s-mup**2)*a1z**2/pi*alpha**3*qel**2/s*(s
     & -spr)*(-2*p3p4*mup**2+p4p5*mup**2)
     & +iz3el*chizpsc*chizsprc/ps**2/(s-mup**2)*a1z**2/pi*alpha**3*qel**
     & 2/s*(s-spr)*(2*p3p4*mup**2-p4p5*mup**2)
     & +iz4el**2*chizps*chizpsc/ps**2/(s-mup**2)/pi*alpha**3*qel**2/s*(s
     & -spr)*(2*p3p4*vel**2*aup**2*mel**2*mup**2-2*p3p5*vel**2*aup**2*me
     & l**2*mup**2)
     & +iz4el**2*chizspr*chizpsc/ps**2/(s-mup**2)*a1z**2/pi*alpha**3*qel
     & **2/s*(s-spr)*(2*p3p4*mel**2*mup**2-2*p3p5*mel**2*mup**2)
     & +iz4el**2*chizpsc**2/ps**2/(s-mup**2)*a1z**2/pi*alpha**3*qel**2/s
     & *(s-spr)*(-2*p3p4*mel**2*mup**2+2*p3p5*mel**2*mup**2)
     & +iz4el**2*chizpsc*chizsprc/ps**2/(s-mup**2)*a1z**2/pi*alpha**3*qe
     & l**2/s*(s-spr)*(2*p3p4*mel**2*mup**2-2*p3p5*mel**2*mup**2)
     & +iz4el*chizps*chizpsc/ps**2/(s-mup**2)/pi*alpha**3*qel**2/s*(s-sp
     & r)*(2*p3p4*vel**2*aup**2*mup**2-p3p5*vel**2*aup**2*mup**2)
     & +iz4el*chizspr*chizpsc/ps**2/(s-mup**2)*a1z**2/pi*alpha**3*qel**2
     & /s*(s-spr)*(2*p3p4*mup**2-p3p5*mup**2)
     & +iz4el*chizpsc**2/ps**2/(s-mup**2)*a1z**2/pi*alpha**3*qel**2/s*(s
     & -spr)*(-2*p3p4*mup**2+p3p5*mup**2)
     & +iz4el*chizpsc*chizsprc/ps**2/(s-mup**2)*a1z**2/pi*alpha**3*qel**
     & 2/s*(s-spr)*(2*p3p4*mup**2-p3p5*mup**2)

      hard = hard*conhc*cfprime

      return
      end
