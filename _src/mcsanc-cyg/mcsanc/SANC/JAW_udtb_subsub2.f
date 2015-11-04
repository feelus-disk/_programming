      COMPLEX*16 FUNCTION JAW_udtb_subsub2(Qs,Ps,m12,m22,m32)
*-------------------------------------------------------
* m22 and m42 are zero
      IMPLICIT NONE!
      REAL*8 Qs,Ps,m12,m22,m32,zet2
      COMPLEX*16 ieps,XSPENZ
      COMPLEX*16 R3,P
      REAL*8   Delta13,Delta23
      PARAMETER (zet2=1.6449340668482264364724151666460251d0)
*
      ieps=DCMPLX(0d0,1d-35)
      R3=(Qs+m32-ieps)/m32
      P=Qs+m32-ieps
      Delta13=m12-m32
      Delta23=m22-m32
*
      JAW_udtb_subsub2=1d0/(Qs+m12)*(
     &      +XSPENZ(+Qs/m12*Delta13/P)
     &      -XSPENZ(-Delta13/P)
     &      -XSPENZ(-Qs/(m12-ieps))
     &      +zet2            )
     &         +1d0/(Ps+m12)*(
     &      -LOG(-(P)/(Ps+Delta13))*LOG(m12/(Ps+m12))
     &      -LOG(R3)*LOG(-Qs/(Ps+m12))
     &      +XSPENZ(-Delta13/(m32-ieps))
     &      -XSPENZ(R3)
     &      -XSPENZ((Ps+m12)/(m12-ieps))
     &      +XSPENZ((Ps+m12)/m12        /(1+Ps/(m12-m32+ieps)))
     &      -XSPENZ(1d0                 /(1+Ps/(m12-m32+ieps)))
     &      +zet2            )
*
      RETURN
      END
