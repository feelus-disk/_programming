************************************************************************
* This is the FORTRAN module (nc_br_11_1616) to calculate EW Born
* cross section for the a + a -> el^+ + el^- process.
*
* It is produced by s2n package of SANC (v1.10) Project.
* Copyright (C), SANC Project Team, 2002-2013.
*
* http://sanc.jinr.ru/
* http://pcphsanc.cern.ch/
* E-mail: <sanc@jinr.ru>
************************************************************************
      subroutine nc_br_11_1212 (qs,ts,us,born,soft,hard)
      implicit none!
      include 's2n_declare.h'

      real*8 betaselel

      cmz2 = mz2
      s = -qs
      t = -ts
      u = -us

      betaselel = sqrt(1d0-4d0*mel**2/s)
      cosf = (t-u)/s/betaselel

      born =
     $     (alpha*cfprime)**2*pi/s*(
     $     +1d0/(1d0-betaselel*cosf)*(1d0+betaselel*cosf+4d0*mf**2/s*(
     $                    1d0-(1d0+betaselel**2)/(1d0-betaselel*cosf)))
     $     +1d0/(1d0+betaselel*cosf)*(1d0-betaselel*cosf+4d0*mf**2/s*(
     $                    1d0-(1d0+betaselel**2)/(1d0+betaselel*cosf)))
     $     )

      born = born*conhc
      virt = 0d0
      soft = 0d0
      hard = 0d0

      if (iborn.eq.1) return

      return
      end
