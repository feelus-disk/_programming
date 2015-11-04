      COMPLEX*16 FUNCTION C0analys(MT,MB,WTP,Q2)
*-----------------------------------------------
      IMPLICIT NONE
      REAL*8 MB,MT,Q2,WTP,GTP,RMT2,RMB2,ZET2
      COMPLEX*16 MB2,MT2,DMT2,ieps,XSPENZ
      COMPLEX*16 Bd,Sd,yd1,yd2
      COMPLEX*16 Bl,Sl,yl1,yl2
      COMPLEX*16 i,yl1myd1,yl2myd2
      DATA ZET2/1.6449340668482264364724151666460251D0/

      MT2 = DCMPLX(mt**2,-mt*wtp)
      MB2 = DCMPLX(mb**2,-1d-30)
      ieps=DCMPLX(0d0,1d-30)

      if (mb.ge.1d-1) then

         Bd=Q2+DREAL(MT2-MB2)
         Sd  =SQRT(Q2**2+2*Q2*(DREAL(MT2+MB2)-2*ieps)+DREAL(MT2-MB2)**2)
         yd1 =(Bd-Sd)/2D0/Q2
         yd2 =(Bd+Sd)/2D0/Q2
         Bl  =Q2+(MT2-MB2)
         Sl  =SQRT(Q2**2+2*Q2*(MT2+MB2)+(MT2-MB2)**2)
         yl1 =(Bl-Sl)/2D0/Q2
         yl2 =(Bl+Sl)/2D0/Q2
         DMT2=DCMPLX(0d0,-mt*wtp)
         yl1myd1=DMT2*(1-(2*Q2-2*MB2+2*DREAL(MT2)+DMT2)/(Sl+Sd))/2D0/Q2
         yl2myd2=DMT2*(1+(2*Q2-2*MB2+2*DREAL(MT2)+DMT2)/(Sl+Sd))/2D0/Q2
*
         C0analys=1d0/Sd*(
*
     &        +1d0/2*LOG(-yl1myd1/(1d0-yd1))**2

     &        -1d0/2*LOG(-yl2myd2/(1d0-yd2))**2
     &        -1d0/2*LOG(+yl1myd1/yd1)**2
     &        +1d0/2*LOG(+yl2myd2/yd2)**2
*
     &        +XSPENZ((yl1myd1)/(1d0-yd1))
     &        -XSPENZ((yl2myd2)/(1d0-yd2))
     &        -XSPENZ(-(yl1myd1)/yd1)
     &        +XSPENZ(-(yl2myd2)/yd2)
*
     &        +LOG(yd1)*LOG(1d0-1d0/yd1)
     &        -XSPENZ(      (1d0/yd1    ))
     &        -XSPENZ((1d0-yd1)/(yl2-yd1))
     &        +XSPENZ(-yd1/(yl2-yd1))
     &        -LOG(yd2)*LOG(1d0-1d0/yd2)
     &        +XSPENZ(      (1d0/yd2    ))
     &        +XSPENZ((1d0-yd2)/(yl1-yd2))
     &        -XSPENZ(-yd2/(yl1-yd2))
     &        )

         else

            RMT2=DREAL(MT2)
            RMB2=DREAL(MB2)
            DMT2=MT2-RMT2
            Bl=Q2+MT2
            Bd=Q2+RMT2-ieps
*      
            C0analys=1d0/Bd*(
     &           +LOG(Bl/DMT2)*LOG(RMT2/RMB2)
     &           +2*LOG(Bd/RMT2)*LOG(RMT2/DMT2)
     &
     &           +(1d0/2*LOG(Bd/RMT2)+LOG(Bl/RMT2))*LOG(Bd/RMT2)
     &           -XSPENZ(-DMT2/RMT2)
     &           +XSPENZ(-DMT2/Bd)
     &           -XSPENZ( DMT2/Bl)
     &           -XSPENZ(   Q2/Bl)
     &           +ZET2      )

         endif

      RETURN
      END
