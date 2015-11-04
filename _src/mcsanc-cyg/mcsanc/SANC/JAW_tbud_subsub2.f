      COMPLEX*16 FUNCTION JAW_tbud_subsub2(Qs,Ps,m12,m22,m32)
*------------------------------------------------------
* m22 and m42 in the limit
      IMPLICIT NONE
      REAL*8 Qs,Ps,rm12,rm22,rm32
      REAL*8 eps,pi,zet2,Ps13
      COMPLEX*16 ieps,sC1,sC2
      COMPLEX*16 yprmax,yprmin,tmax,tmin,dt,zlp,zlm
      COMPLEX*16 P,XSPENZ,JAW0,JAW1,JAW2
      COMPLEX*16 m12,m22,m32
*
      PARAMETER (eps =1d-30)
      PARAMETER (pi  =3.1415926535897932384626433832795028d0)
      PARAMETER (zet2=1.6449340668482264364724151666460251d0)
*
*     m1=mtp, m2=mbt, m3=mw, m4=mel
*    
      rm12=DREAL(m12)
      rm22=DREAL(m22)
      rm32=DREAL(m32)
      P=Qs+m32
      ieps=DCMPLX(0d0,eps)
*
      JAW0=+1d0/(Ps+rm12)*(
     & +CDLOG(P/rm32)*(CDLOG((Ps+m12)/rm32)+CDLOG((Ps+m12)/rm12))
     & -CDLOG((Qs+m32-ieps)/rm32)*CDLOG(-Qs/(rm32-ieps))
     & -XSPENZ( (Qs+m32-ieps)/rm32)
     & +XSPENZ(-(Ps+rm12-rm32-ieps)/rm32)
     & +1d0/2*DLOG(-rm32/Ps)*CDLOG((Ps+m12)/rm12)
     &                    )
* The first part:
      sC1=Ps+rm12-rm32+ieps
      JAW1=CDLOG((Ps+m12)/rm32)*CDLOG(sC1/(rm12-rm32))
     &    +XSPENZ(Ps/(Ps+m12))
     &    -XSPENZ((-Ps/(rm12-rm32)-ieps)*(rm32-ieps)/(Ps+rm12))
     &    +XSPENZ( -Ps/(rm12-rm32)-ieps)
* The second part:
      sC2=-(rm32-ieps)
      IF(DREAL(sC2).LT.0d0) THEN
       yprmax=  -m12/Ps
       yprmin=-1-m12/Ps
       sC2=rm32-ieps
       tmax=(CDSQRT(Ps**2*yprmax**2+2*Ps*yprmax*sC2+sC2**2)-sC2)/yprmax
       Ps13=Ps+rm12-rm32
       IF(Ps13.GE.0d0) THEN
        tmin=-Ps-2*(rm32-ieps)/yprmin
        dt=tmax-tmin
        zlm=+(Ps-tmin)/dt
        zlp=-(Ps+tmin)/dt
        JAW2=(CDLOG(zlm*dt/Ps*(1-zlp/zlm))
     &      -CDLOG(-zlp*dt/Ps)
     &      -CDLOG(1-zlm/zlp))*CDLOG(1-1/zlm)
     &      +1d0/2*CDLOG(1-1/zlp)**2
     &      -CDLOG(2*sC2/(zlp*dt))*CDLOG(1-1/zlp)
     &      +XSPENZ((1-zlm)/(zlp-zlm))
     &      -XSPENZ(  -zlm /(zlp-zlm))   
       ELSE
        tmin=Ps
        dt=tmax-tmin
        zlp=-2*Ps/dt
        JAW2=
     &      +1d0/2*CDLOG(dt/2/Ps)**2
     &      -1d0/2*CDLOG(-dt*sC2/2/Ps/(yprmin*Ps+sC2))**2
     &      +CDLOG(2*sC2/zlp/dt)*CDLOG(-dt*sC2/2/yprmin/Ps**2)
     &      -CDLOG(-2*yprmin*Ps/dt/zlp)*CDLOG(dt/2/Ps)
     &      -CDLOG(1+sC2/yprmin/Ps)*CDLOG(dt/2/Ps)
     &      -CDLOG(2*sC2/zlp/dt)*CDLOG(1-1/zlp)
     &      +1d0/2*CDLOG(1-1/zlp)**2
     &      +XSPENZ(1/zlp)-XSPENZ(sC2/(yprmin*Ps+sC2))-zet2
       ENDIF
      ELSE
       print*,'non-foreseen situation, sC2=',sC2
       stop
      ENDIF
      JAW_tbud_subsub2=JAW0+1d0/2/(Ps+m12)*(JAW1+JAW2)
      RETURN
      END
