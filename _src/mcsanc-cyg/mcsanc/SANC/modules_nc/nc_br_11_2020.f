************************************************************************
* This is the FORTRAN module (nc_br_11_2020) to calculate EW Born
* cross section for the a + a -> ta^+ + ta^- process.
*
* It is produced by s2n package of SANC (v1.10) Project.
* Copyright (C), SANC Project Team, 2002-2013.
*
* http://sanc.jinr.ru/
* http://pcphsanc.cern.ch/
* E-mail: <sanc@jinr.ru>
************************************************************************
      subroutine nc_br_11_2020 (qs,ts,us,born,soft,hard)
      implicit none!
      include 's2n_declare.h'

      real*8 betastata

      cmz2 = mz2
      s = -qs
      t = -ts
      u = -us

      betastata = sqrt(1d0-4d0*mta**2/s)
      cosf = (t-u)/s/betastata

      born =
     $     (alpha*cfprime)**2*pi/s*(
     $     +1d0/(1d0-betastata*cosf)*(1d0+betastata*cosf+4d0*mf**2/s*(
     $                    1d0-(1d0+betastata**2)/(1d0-betastata*cosf)))
     $     +1d0/(1d0+betastata*cosf)*(1d0-betastata*cosf+4d0*mf**2/s*(
     $                    1d0-(1d0+betastata**2)/(1d0+betastata*cosf)))
     $     )

      born = born*conhc
      virt = 0d0
      soft = 0d0
      hard = 0d0

      if (iborn.eq.1) return

      return
      end
