      COMPLEX*16 FUNCTION JAW_butd_subsub1(Qs,Ps,m12,m22,m32)
*--------------------------------------------------------
      IMPLICIT NONE!
      REAL*8 Qs,Ps,rm12,rm22,rm32
      REAL*8 eps,pi,zet2,A,Ps13,B1
      COMPLEX*16 ieps,C1,sC1,D1,sD1,E,sC2
      COMPLEX*16 yprmax,yprmin,tmax,tmin,dt,zd,zlp,zlm,zdm1
      COMPLEX*16 P,XSPENZ,MASTER_BUTD_SUBSUB1,JAW0,JAW1,JAW2
      COMPLEX*16 m12,m22,m32
*
      PARAMETER (eps =1d-30)
      PARAMETER (pi  =3.1415926535897932384626433832795028d0)
      PARAMETER (zet2=1.6449340668482264364724151666460251d0)
*
*     m1=mbt, m2=mtp, m3=mw, m4=mel
*     limit                  limit
      rm12=DREAL(m12)
      rm22=DREAL(m22)
      rm32=DREAL(m32)
      P=Qs+m32
      ieps=DCMPLX(0d0,eps)
*
      JAW0=1d0/Ps*(
     & +2*CDLOG(-(Ps-ieps)/(Qs+rm22))*CDLOG(P/rm32)
     & +(2*CDLOG(-(Qs+rm22)/(rm32-ieps))+DLOG(rm32/rm22))
     &                      *CDLOG(-(rm22-rm32+ieps)/rm32)
     & -1d0/2*CDLOG(-(Ps-ieps)/rm32)*CDLOG((Ps-ieps)/rm32)
     & +XSPENZ(-(Ps-rm32-ieps)/rm32)
     & -XSPENZ(-(rm22-rm32+ieps)/rm32)
     & -XSPENZ(P/(rm32-rm22))
     & -XSPENZ(DCONJG(P)/(rm32-rm22))
     & +2*zet2    )
* The first part:
      A=Ps+rm22
      Ps13=Ps-ieps+m32
      C1=-(Ps-ieps-m32)
      B1=-A*C1+2*m32*rm22
      D1=A**2-2*B1+C1**2
      sD1=CDSQRT(D1)
      E=sD1*C1-C1**2+B1
      JAW1=1d0/2/Ps*(
     &  -CDLOG((Ps-ieps)/rm32)*CDLOG((A**2*C1**2-B1**2)/(2*C1**2*E))
     &  +XSPENZ(Ps/(Ps-ieps))
     &  -(-XSPENZ(E/(B1+A*C1))
     &    -XSPENZ(E*(Ps13-C1)/(Ps13+C1)/(B1-A*C1))
     &    +XSPENZ(E/(B1-A*C1))
     &    +XSPENZ(E*(Ps13+C1)/(Ps13-C1)/(B1+A*C1))
     &   )          )
* The second part:
      zlm=Ps/(Ps-ieps)*(rm22-m32)/(rm22-m32+Ps)
      zlp=-(rm22-m32)/m32
      JAW2=1d0/2/Ps*(
     &     -CDLOG(-(Ps-ieps)/Ps)*CDLOG(1d0-1d0/zlp)
     &     +1d0/2*CDLOG(1d0-1d0/zlp)**2
     &     +MASTER_BUTD_SUBSUB1(zlm,zlp)
     &     -MASTER_BUTD_SUBSUB1(DCMPLX(1d0,0d0),zlp)
     &     -CDLOG(-(Ps-ieps)/Ps)*CDLOG(1d0-1d0/zlm)
     &     +1d0/2*CDLOG(1d0-1d0/zlm)**2
     &     +MASTER_BUTD_SUBSUB1(zlp,zlm)
     &     -MASTER_BUTD_SUBSUB1(DCMPLX(1d0,0d0),zlm)
     &   -2*XSPENZ(1d0/(1d0-zlm))
     &   +(2*CDLOG((rm22-rm32+ieps)/Ps)+CDLOG(-Ps/(rm32-ieps))
     &    )*CDLOG(-rm32*rm22/(rm22-m32)**2)
     &              )
      JAW_butd_subsub1=JAW0+JAW1+JAW2
c$$$      print *, "jaw0",JAW0
c$$$      print *, "jaw1",JAW1
c$$$      print *, "jaw2",JAW2
c$$$      print *, "jaw ",JAW_butd_subsub1
      RETURN
      END

      COMPLEX*16 FUNCTION MASTER_BUTD_SUBSUB1(ayl,ayd)
*----------------------------------------
      COMPLEX*16 ayl,ayd,yl,yd,XSPENZ
*
      yl=ayl
      yd=ayd
*
      MASTER_BUTD_SUBSUB1=
     &      +CDLOG(1d0-yd/yl)*CDLOG(1d0-1d0/yd)
     &      -XSPENZ((1d0-yd)/(yl-yd))
     &      +XSPENZ(-yd/(yl-yd))
*
      RETURN
      END
