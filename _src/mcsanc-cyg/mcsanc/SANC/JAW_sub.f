      COMPLEX*16 FUNCTION JAWsub(Qs,Ps,m12,m22,m32)
*---------------------------------------------------------
      IMPLICIT NONE!
      REAL*8 Qs,Ps,m12,m22,m32,yPs1R,ykxy1R,ykxy2R,bkxyy,bLmk,zet2
      COMPLEX*16 ieps,MASTERYDR,XSPENZ,yPs1L
      COMPLEX*16 sdkxy,ykxy1,ykxy2,sdLmk,yLmk1,yLmk2
      PARAMETER (zet2=1.6449340668482264364724151666460251d0)
*
      ieps =CMPLX(0d0,1d-30)
      yPs1L=(Ps+m12-ieps)/Ps
      yPs1R =DREAL(yPs1L)
*
      bkxyy=m22-m12-Qs
      sdkxy=SQRT(bkxyy**2+4*m22*(Qs+ieps))
      ykxy1=(-bkxyy+sdkxy)/2/(-m22)
      ykxy2=(-bkxyy-sdkxy)/2/(-m22)
      ykxy1R=DREAL(ykxy1)
      ykxy2R=DREAL(ykxy2)
*
      bLmk=-m22+m12-m32
      sdLmk=SQRT(bLmk**2-4*m22*(m32-ieps))
      yLmk1=(-bLmk+sdLmk)/2/m22
      yLmk2=(-bLmk-sdLmk)/2/m22
*
      JAWsub=1d0/sdkxy*(
     &      -MASTERYDR(yLmk1,ykxy1R)
     &      -MASTERYDR(yLmk2,ykxy1R)
     &      +MASTERYDR(yLmk1,ykxy2R)
     &      +MASTERYDR(yLmk2,ykxy2R)
     &      +LOG(1d0-ykxy1)*LOG(1d0-1d0/ykxy1)
     &      +XSPENZ(-ykxy1/(1d0-ykxy1))
     &      -LOG(1d0-ykxy2)*LOG(1d0-1d0/ykxy2)
     &      -XSPENZ(-ykxy2/(1d0-ykxy2))
     &      +LOG((Qs+m32-ieps)/m32)*LOG(1d0-1d0/ykxy1)
     &      -LOG((Qs+m32-ieps)/m32)*LOG(1d0-1d0/ykxy2)
     &                        )
     &      +1d0/(Ps+m12)*(
     &      +MASTERYDR(yLmk1,yPs1R)
     &      +MASTERYDR(yLmk2,yPs1R)
     &      +XSPENZ(1d0/yLmk1)
     &      +XSPENZ(1d0/yLmk2)
     &      -LOG(1d0-yPs1L)*LOG(1d0-1d0/yPs1L)
     &      -XSPENZ(-yPs1L/(1d0-yPs1L))
     &      -LOG((Qs+m32-ieps)/m32)*LOG(1d0-1d0/yPs1L)
     &      -LOG((Qs+m32-ieps)/m32)*LOG(m32/(Ps+m12-ieps))
     &      -LOG((Qs+m32-ieps)/m32)*LOG(-Qs/m32)
     &      -XSPENZ((Qs+m32-ieps)/m32)+zet2
     &                     )
c$$$     & -QLOG(-Qs/rm32)*CQLOG((Qs+m32)/rm32)
c$$$     & -XSPENZ((Qs+m32)/rm32)
c$$$     & +zet2
c$$$       =
c$$$     & +1d0/2*(LOG(Qs/(Qs+m32-ieps)))**2
c$$$     & -1d0/2*(LOG(Qs/(m32-ieps)))**2
c$$$     & +XSPENZ(rm32/(Qs+m32))
c$$$     & -zet2
*
      RETURN
      END

      COMPLEX*16 FUNCTION MASTERYDR(yl,yd)
*-----------------------------------------
* MASTERYDR=\int^1_0 dy/(y-yd)*ln(1-y/yl)
* FOR YD-REAL, BEYOND THE INTERVAL [0,1],
* REALLY, HERE YD > 1D0.
      IMPLICIT NONE!
      REAL*8 yd
      COMPLEX*16 yl,XSPENZ
*
      IF(YD.GT.1D0) THEN
       MASTERYDR=
     &      +LOG(1d0-yd/yl)*LOG(1d0-1d0/yd)
     &      -XSPENZ((1d0-yd)/(yl-yd))
     &      +XSPENZ(-yd/(yl-yd))
       ELSE
       PRINT *,'WRONG YD=',YD
      ENDIF
*
      RETURN
      END
