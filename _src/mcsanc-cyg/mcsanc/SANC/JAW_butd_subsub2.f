      COMPLEX*16 FUNCTION JAW_butd_subsub2(Qs,Ps,m12,m22,m32)
*--------------------------------------------------------
* m22 and m42 in the limit; butd Real*8 paper
      IMPLICIT NONE
      REAL*8 Qs,Ps,rm12,rm22,rm32,eps
      COMPLEX*16 m12,m22,m32,ieps,ypr,P
      COMPLEX*16 XSPENZ,JAW0,JAW1,JAW2
      PARAMETER (eps =1d-30)
*
*     m1=mtp, m2=mbt, m3=mw, m4=mel
*             limit          limit
      rm12=DREAL(m12)
      rm22=DREAL(m22)
      rm32=DREAL(m32)
      P=Qs+m32
      ieps=DCMPLX(0d0,eps)
*
      JAW0=
     & +1d0/(Ps+rm12)*(
     & +CDLOG(P/rm32)*(CDLOG((Ps+m12)/rm32)
     & -CDLOG((-Qs+ieps)/rm32)-CDLOG(-m12/Ps)+CDLOG(-1-m12/Ps))
     & -1d0/2*CDLOG(-m32/Ps)*(CDLOG(-m12/Ps)-CDLOG(-1-m12/Ps))
     & -XSPENZ(P/rm32)+XSPENZ(-(Ps+rm12-ieps-rm32)/rm32) )
*
* The first part:
      JAW1=1d0/2/(Ps+rm12)*(
     &     XSPENZ(-(rm12-rm32)/m32)-XSPENZ(-(Ps+rm12-rm32)/m32) )
*
* The second part:
      ypr=1+m12/Ps
      JAW2=1d0/2/(Ps+rm12)*(
     &    +1d0/2*CDLOG(-Ps/m32)**2-1d0/2*CDLOG(-ypr)**2
     &    +CDLOG(-Ps/m32)*CDLOG(m32/rm12)
     &    -XSPENZ(1-m32/Ps/ypr)
     &    -XSPENZ(-(rm12-rm32)/m32) )
*
      JAW_butd_subsub2=JAW0+JAW1+JAW2
*
      RETURN
      END
