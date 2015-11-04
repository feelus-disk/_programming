      COMPLEX*16 FUNCTION C000(p12,p22,Q2,m12,m22,m32)
*     ------------------------------------------------
* particular case of C01 with Real*8; SANC group, version 07/10/08
* p12=0, p22=-rm22, m12=mw2, m22=mtp2, m32=cm2-photon
      IMPLICIT NONE!
      REAL*8 eps,pi,zet2,p12,p22,Q2
      REAL*8 rm12,rm22
      COMPLEX*16 m12,m22,m32,ieps,P,XSPENZ
*
      PARAMETER (eps=1D-30)
      PARAMETER (pi=3.1415926535897932384626433832795028D0)
      PARAMETER (zet2=1.6449340668482264364724151666460251D0)
*
      rm12=DREAL(m12)
      rm22=DREAL(m22)
*
      ieps=DCMPLX(0d0,1d-30)
      P=Q2+m12
*
      C000=1d0/(Q2+rm22)*(
     & +DLOG(-Q2/rm22)*DREAL(CDLOG(P/(rm22-rm12)))
     & -1d0/2*DLOG(-Q2/rm22)**2
     & -XSPENZ(-rm22/Q2*(Q2+rm12-ieps)/(rm12-rm22))
     & -XSPENZ(-Q2/(rm22-ieps))
     & +XSPENZ((Q2+rm12-ieps)/(rm12-rm22))
     & +zet2 )
*
      RETURN
      END
