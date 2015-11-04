      COMPLEX*16 FUNCTION JAW_udtb_subsub1(Qs,Ps,m12,m22,m32)
*-------------------------------------------------------
* m12 and m42 are zero
      IMPLICIT NONE!
      REAL*8 Qs,Ps,m12,m22,m32,zet2
      COMPLEX*16 ieps,XSPENZ
      PARAMETER (zet2=1.6449340668482264364724151666460251d0)
*
      ieps=DCMPLX(0d0,1d-35)
*
      JAW_udtb_subsub1=1d0/Ps*(
     &   -LOG( (Qs+m32-ieps)/m32)*LOG((Qs+m32-ieps)/Ps)
     &   +LOG(-(Qs+m32-ieps)/(m22-m32))
     &   *LOG((Qs+m32)**2/(Qs+m22)**2*Ps/m32)
     & +2*XSPENZ(-(m22-m32)/(Qs+m32-ieps))
     &   +XSPENZ(1+Ps/(m22-m32+ieps))
     &   -XSPENZ( m22/(m22-m32+ieps))
     &   -3*zet2       )
*
      RETURN
      END
