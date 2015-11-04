!++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
!> Produces PDF convolutions for neutral and charge currents
!<-------------------------------------------------------------
      subroutine pdf_conv (x1,x2,Q,conv)

      implicit none

      include 'constants.h'
      include 'ckm.h'
      include 'process.h'

      integer in
      integer fspart_id
      integer charge_id
      integer ifl,ifl1,ifl2
      double precision x1,x2,Q,conv(2)
      double precision xf1(-6:6),xf2(-6:6)
      double precision vxf(2)

      charge_id = processId/100
      fspart_id = abs(mod(processId,100))

      do in = 1,2
         vxf(in) = 0d0
         conv(in) = 0d0
      enddo

      call evolvePDF(x1, Q, xf1)
      call evolvePDF(x2, Q, xf2)

C     numbering:
C     \bar{t  b  c  s  u  d} g  d  u  s  c  b  t
C         -6 -5 -4 -3 -2 -1  0  1  2  3  4  5  6

      if ( charge_id .lt. 0 ) then

         if ( fspart_id .eq. idtopt ) then
c     1322_2114     | anti-up + anti-bt -> anti-tp   + anti-dn
            vxf(1) =
     $           + (Vsq(-2, 1)+Vsq(-2, 3))*xf1(-5)*xf2(-2)
     $           + (Vsq(-4, 1)+Vsq(-4, 3))*xf1(-5)*xf2(-4)
c     2214_2113     | anti-bt +      dn -> anti-tp   +      up
            vxf(2) =
     $           + (Vsq(-2, 1)+Vsq(-4, 1))*xf1(-5)*xf2( 1)
     $           + (Vsq(-2, 3)+Vsq(-4, 3))*xf1(-5)*xf2( 3)
         else
            do ifl1=-nf,-1
               do ifl2 = 1,nf
                  vxf(1) = vxf(1) + Vsq(ifl1,ifl2)*xf1(ifl1)*xf2(ifl2)
               enddo
            enddo
         endif

      elseif ( charge_id .gt. 0 ) then

         if ( fspart_id .eq. idtopt ) then
c     2213_1421     |      bt +      up ->      dn   +      tp
            vxf(1) =
     $           + (Vsq( 2,-1)+Vsq( 2,-3))*xf1( 5)*xf2( 2)
     $           + (Vsq( 4,-1)+Vsq( 4,-3))*xf1( 5)*xf2( 4)
c     1422_1321     | anti-dn +      bt -> anti-up   +      tp
            vxf(2) =
     $           + (Vsq( 2,-1)+Vsq( 4,-1))*xf1( 5)*xf2(-1)
     $           + (Vsq( 2,-3)+Vsq( 4,-3))*xf1( 5)*xf2(-3)
         else
            do ifl1=1,nf
               do ifl2 = -nf,-1
                  vxf(1) = vxf(1) + Vsq(ifl1,ifl2)*xf1(ifl1)*xf2(ifl2)
               enddo
            enddo
         endif

      elseif ( charge_id .eq. 0 ) then

         do ifl=2,4,2
            vxf(1) = vxf(1) + xf1(ifl)*xf2(-ifl)
         enddo

         do ifl=1,5,2
            vxf(2) = vxf(2) + xf1(ifl)*xf2(-ifl)
         enddo

      else

         print *, "something wrong. stop"
         stop

      endif

      do in = 1,2
         conv(in) = 2d0*vxf(in)/x1/x2
      enddo

      return
      end

C--------------------------------------------------------------

!++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
!> Produces PDF convolutions for subtraction component
!<-------------------------------------------------------------
      subroutine pdf_conv_subt (x1,x2,Q,subip,dconv)

      implicit none

      include 'constants.h'
      include 'ckm.h'
      include 'process.h'
      include 's2n_declare.h'

      integer in
      integer charge_id
      integer fspart_id
      integer ifl,ifl1,ifl2
      integer ik,iud,iud1,iud2
      double precision x1,x2,Q,subip,dconv(2)
      double precision xf1(-6:6),xf2(-6:6),xf1d(-6:6),xf2d(-6:6)
      double precision xzf1(-6:6),xzf2(-6:6)
      double precision vxf(2)

      double precision mskern1(3),mskern2(3),ai_0tox1(3),ai_0tox2(3)
      double precision z1,z2,jacob_z1,jacob_z2,gap
      !data gap/1d-10/
      data gap/0d0/
      
      double precision alphcoef(3)

      charge_id = processId/100
      fspart_id = abs(mod(processId,100))

      do in = 1,2
         vxf(in) = 0d0
         dconv(in) = 0d0
      enddo

      call evolvePDF(x1, Q, xf1)
      call evolvePDF(x2, Q, xf2)

C     numbering:
C     \bar{t  b  c  s  u  d} g  d  u  s  c  b  t
C         -6 -5 -4 -3 -2 -1  0  1  2  3  4  5  6

      jacob_z1 = 1d0 - x1 - 2d0*gap
      jacob_z2 = 1d0 - x2 - 2d0*gap

      if ( jacob_z1 .le. 0d0 ) return
      if ( jacob_z2 .le. 0d0 ) return
      z1 = x1+gap+jacob_z1*subip
      z2 = x2+gap+jacob_z2*subip

      call getMassSubtKern(z1, Q, mskern1)
      call getMassSubtKern(z2, Q, mskern2)
      do ik = 1,3
        mskern1(ik) = mskern1(ik)*jacob_z1
        mskern2(ik) = mskern2(ik)*jacob_z2
      enddo

      call getAI_0tox(x1, Q, ai_0tox1)
      call getAI_0tox(x2, Q, ai_0tox2)

      if ((iqed .ne. 0) .and. (iqcd .ne. 0)) then
         alphcoef(1) = (cfprime*alpha*qup**2+cf*alphas)/2/pi
         alphcoef(2) = (cfprime*alpha*qdn**2+cf*alphas)/2/pi
         alphcoef(3) = (cfprime*alpha*qbt**2+cf*alphas)/2/pi
      elseif ((iqed .ne. 0) .and. (iqcd .eq. 0)) then
         alphcoef(1) = cfprime*alpha*qup**2/2/pi
         alphcoef(2) = cfprime*alpha*qdn**2/2/pi
         alphcoef(3) = cfprime*alpha*qbt**2/2/pi
      elseif ((iqed .eq. 0) .and. (iqcd .ne. 0)) then
         alphcoef(1) = cf*alphas/2d0/pi
         alphcoef(2) = cf*alphas/2d0/pi
         alphcoef(3) = cf*alphas/2d0/pi
      else
         print *, "something wrong. stop."
         stop
      endif

      call evolvePDF(x1/z1, Q, xzf1)
      call evolvePDF(x2/z2, Q, xzf2)

      do ifl = -nf, nf
         iud = 2-mod(abs(ifl+1),2)
         xf1d(ifl) = xf1(ifl)*ai_0tox1(iud)+(xzf1(ifl)-xf1(ifl))*mskern1(iud)
         xf2d(ifl) = xf2(ifl)*ai_0tox2(iud)+(xzf2(ifl)-xf2(ifl))*mskern2(iud)
      enddo

      if ( charge_id .lt. 0 ) then

         if ( fspart_id .eq. idtopt ) then
            xf1d( 5) = xf1( 5)*ai_0tox1(3)+(xzf1( 5)-xf1( 5))*mskern1(3)
            xf2d( 5) = xf2( 5)*ai_0tox2(3)+(xzf2( 5)-xf2( 5))*mskern2(3)
            do ifl1=-nf,-1
               do ifl2 = 1,nf
                  iud1 = 2-mod(abs(ifl1+1),2)
                  iud2 = 2-mod(abs(ifl2+1),2)
                  vxf(1) = vxf(1)-Vsq(ifl1,ifl2)*(
     $                 (xf2(ifl1)*xf1d(   5)*alphcoef(   3) + 
     $                  xf1(   5)*xf2d(ifl1)*alphcoef(iud1)))
                  vxf(2) = vxf(2)-Vsq(ifl1,ifl2)*(
     $                 (xf1(   5)*xf2d(ifl2)*alphcoef(iud2) + 
     $                  xf2(ifl2)*xf1d(   5)*alphcoef(   3)))
               enddo
            enddo
         else
            do ifl1=-nf,-1
               do ifl2 = 1,nf
                  iud1 = 2-mod(abs(ifl1+1),2)
                  iud2 = 2-mod(abs(ifl2+1),2)
                  vxf(1) = vxf(1)-Vsq(ifl1,ifl2)*(
     $                 (xf1(ifl1)*xf2d(ifl2)*alphcoef(iud2) + 
     $                  xf2(ifl2)*xf1d(ifl1)*alphcoef(iud1)))
               enddo
            enddo
         endif

      elseif ( charge_id .gt. 0 ) then

         if ( fspart_id .eq. idtopt ) then
            xf1d(-5) = xf1(-5)*ai_0tox1(3)+(xzf1(-5)-xf1(-5))*mskern1(3)
            xf2d(-5) = xf2(-5)*ai_0tox2(3)+(xzf2(-5)-xf2(-5))*mskern2(3)
            do ifl1 = 1,nf
               do ifl2=-nf,-1
                  iud1 = 2-mod(abs(ifl1+1),2)
                  iud2 = 2-mod(abs(ifl2+1),2)
                  vxf(1) = vxf(1)-Vsq(ifl1,ifl2)*(
     $                 (xf2(ifl1)*xf1d(  -5)*alphcoef(   3) + 
     $                  xf1(  -5)*xf2d(ifl1)*alphcoef(iud1)))
                  vxf(2) = vxf(2)-Vsq(ifl1,ifl2)*(
     $                 (xf1(  -5)*xf2d(ifl2)*alphcoef(iud2) + 
     $                  xf2(ifl2)*xf1d(  -5)*alphcoef(   3)))
               enddo
            enddo
         else
            do ifl1 = 1,nf
               do ifl2=-nf,-1
                  iud1 = 2-mod(abs(ifl1+1),2)
                  iud2 = 2-mod(abs(ifl2+1),2)
                  vxf(1) = vxf(1)-Vsq(ifl1,ifl2)*(
     $                 (xf1(ifl1)*xf2d(ifl2)*alphcoef(iud2) + 
     $                  xf2(ifl2)*xf1d(ifl1)*alphcoef(iud1)))
               enddo
            enddo
         endif

      elseif ( charge_id .eq. 0 ) then

         do ifl=2,4,2
            vxf(1) = vxf(1)-(xf1d(ifl)*xf2(-ifl)+xf1(ifl)*xf2d(-ifl))*alphcoef(1)
         enddo

         do ifl=1,5,2
            vxf(2) = vxf(2)-(xf1d(ifl)*xf2(-ifl)+xf1(ifl)*xf2d(-ifl))*alphcoef(2)
         enddo

      else

         print *, "something wrong. stop"
         stop

      endif

      do in=1,2
         dconv(in) = 2*vxf(in)/x1/x2
      enddo

      return
      end

C--------------------------------------------------------------

!++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
!> Produces PDF convolutions with gluon in initial state
!<-------------------------------------------------------------
      subroutine pdf_conv_gl (x1,x2,Q,conv)

      implicit none

      include 'constants.h'
      include 'ckm.h'
      include 'process.h'
      include 's2n_declare.h'
      !include 'scales.h'

      integer in,charge_id,fspart_id
      integer ifl,ifl1,ifl2
      double precision x1,x2,Q,conv(3)
      double precision xf1(-6:6),xf2(-6:6)
      double precision vxf(3),quanta,phot

      charge_id = processId/100
      fspart_id = abs(mod(processId,100))

      do in = 1,3
         vxf(in) = 0d0
         conv(in) = 0d0
      enddo

      call evolvePDF(x1, Q, xf1)
      call evolvePDF(x2, Q, xf2)

C     numbering:
C     \bar{t  b  c  s  u  d} g  d  u  s  c  b  t
C         -6 -5 -4 -3 -2 -1  0  1  2  3  4  5  6

      !if (iqed.ne.0) quanta=phot
      if (iqcd.ne.0) quanta=xf1(0)

      if ( charge_id .lt. 0 ) then

         if ( fspart_id .eq. idtopt ) then
c     13_23__22_21_14 | anti-up + g  ->      bt + anti-tp + anti-dn (t-ch)
            vxf(1) = quanta*(
     $           + (Vsq(-2, 1)+Vsq(-2, 3))*xf2(-2)
     $           + (Vsq(-4, 1)+Vsq(-4, 3))*xf2(-4)
     $           )
c     23_14__22_21_13 | g       + dn ->      bt + anti-tp +      up (t-ch)
            vxf(2) = quanta*(
     $           + (Vsq(-2, 1)+Vsq(-4, 1))*xf2( 1)
     $           + (Vsq(-2, 3)+Vsq(-4, 3))*xf2( 3)
     $           )
c     22_23__14_21_13 | anti-bt + g  -> anti-dn + anti-tp +      up (t-ch)
            vxf(3) = quanta*(
     $           + (Vsq(-2, 1)+Vsq(-4, 1)+Vsq(-2, 3)+Vsq(-4, 3))*xf2(-5)
     $           )
         else
            vxf(1) = quanta*(
     $           +xf2(-2)*(Vsq(-2, 1)+Vsq(-2, 3)+Vsq(-2, 5))
     $           +xf2(-4)*(Vsq(-4, 1)+Vsq(-4, 3)+Vsq(-4, 5))
     $           )
            vxf(2) = quanta*(
     $           +xf2( 1)*(Vsq(-2, 1)+Vsq(-4, 1))
     $           +xf2( 3)*(Vsq(-2, 3)+Vsq(-4, 3))
     $           +xf2( 5)*(Vsq(-2, 5)+Vsq(-4, 5))
     $           )
         endif

      elseif ( charge_id .gt. 0 ) then

         if ( fspart_id .eq. idtopt ) then
c     23_13__22_14_21 | g       + up -> anti-bt +      dn +      tp (t-ch)
            vxf(1) = quanta*(
     $           + (Vsq(-2, 1)+Vsq(-2, 3))*xf2( 2)
     $           + (Vsq(-4, 1)+Vsq(-4, 3))*xf2( 4)
     $           )
c     14_23__22_13_21 | anti-dn + g  -> anti-bt + anti-up +      tp (t-ch)
            vxf(2) = quanta*(
     $           + (Vsq(-2, 1)+Vsq(-4, 1))*xf2(-1)
     $           + (Vsq(-2, 3)+Vsq(-4, 3))*xf2(-3)
     $           )
c     23_22__14_13_21 | g  +      bt ->      dn + anti-up +      tp (t-ch)
            vxf(3) = quanta*(
     $           + (Vsq(-2, 1)+Vsq(-4, 1)+Vsq(-2, 3)+Vsq(-4, 3))*xf2( 5)
     $           )
         else
            vxf(1) = quanta*(
     $           +xf2( 2)*(Vsq( 2,-1)+Vsq( 2,-3)+Vsq( 2,-5))
     $           +xf2( 4)*(Vsq( 4,-1)+Vsq( 4,-3)+Vsq( 4,-5))
     $           )
            vxf(2) = quanta*(
     $           +xf2(-1)*(Vsq( 2,-1)+Vsq( 4,-1))
     $           +xf2(-3)*(Vsq( 2,-3)+Vsq( 4,-3))
     $           +xf2(-5)*(Vsq( 2,-5)+Vsq( 4,-5))
     $        )
         endif

      elseif ( charge_id .eq. 0 ) then

         vxf(1) = quanta*(xf2( 2)+xf2(-2)+xf2( 4)+xf2(-4)               )
         vxf(2) = quanta*(xf2( 1)+xf2(-1)+xf2( 3)+xf2(-3)+xf2(5)+xf2(-5))

      else

         print *, "something wrong. stop"
         stop

      endif

      do in=1,3
         conv(in) = 2*vxf(in)/x1/x2
      enddo

      return
      end

C--------------------------------------------------------------

!++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
!> Produces PDF convolutions with gluon in initial state
!! for subtraction components
!<-------------------------------------------------------------
      subroutine pdf_conv_subt_gl (x1,x2,Q,subip,ddconv)

      implicit none

      include 'constants.h'
      include 'ckm.h'
      include 'process.h'
      include 's2n_declare.h'
      !include 'scales.h'
      include 'iph.h'

      integer in,charge_id,fspart_id
      integer ik,ifl,iud,has_photon
      double precision x1,x2,Q,subip,dconv(4),ddconv(4)
      double precision xf1(-6:6),xf2(-6:6)
      double precision vxf(4),quanta,phota,photb

      double precision mskern(3)
      double precision gap
      !data gap/1d-10/
      data gap/0d0/
      
      double precision alphcoef(3)

      charge_id = processId/100
      fspart_id = abs(mod(processId,100))

      do in = 1,4
         vxf(in) = 0d0
         dconv(in) = 0d0
      enddo

      if (iph.ne.0) then
         if (has_photon().eq.1) then
            call evolvePDFphoton(x1,Q,xf1,phota)
            call evolvePDFphoton(x2,Q,xf2,photb)
         else
            print *, "There is no photon function in the PDF. Exit"
            stop
         endif
      endif

      if (iqcd.ne.0) then
         call evolvePDF(x1, Q, xf1)
         call evolvePDF(x2, Q, xf2)
      endif

C     numbering:
C     \bar{t  b  c  s  u  d} g  d  u  s  c  b  t
C         -6 -5 -4 -3 -2 -1  0  1  2  3  4  5  6

      if (iph.ne.0) then
         alphcoef(1) = cfprime*alpha*qup**2/2/pi
         alphcoef(2) = cfprime*alpha*qdn**2/2/pi
         alphcoef(3) = cfprime*alpha*qbt**2/2/pi
      endif

      if (iqcd .ne. 0) then
         alphcoef(1) = cf*alphas/2d0/pi
         alphcoef(2) = cf*alphas/2d0/pi
         alphcoef(3) = cf*alphas/2d0/pi
      endif

      if (iph .ne.0) quanta=phota
      if (iqcd.ne.0) quanta=xf1(0)/8d0

      if ( charge_id .lt. 0 ) then

         if ( fspart_id .eq. idtopt ) then
c     1322_2114     | anti-up + anti-bt -> anti-tp   + anti-dn
            vxf(1) = quanta*(
     $           + (Vsq(-2, 1)+Vsq(-2, 3))*xf2(-2)
     $           + (Vsq(-4, 1)+Vsq(-4, 3))*xf2(-4)
     $           )
c     2214_2113     | anti-bt +      dn -> anti-tp   +      up
            vxf(2) = quanta*(
     $           + (Vsq(-2, 1)+Vsq(-4, 1))*xf2( 1)
     $           + (Vsq(-2, 3)+Vsq(-4, 3))*xf2( 3)
     $           )
            vxf(3) = quanta*(
     $           + (Vsq(-2, 1)+Vsq(-4, 1)+Vsq(-2, 3)+Vsq(-4, 3))*xf2(-5)
     $           )
         else
            vxf(1) = quanta*(
     $           +xf2(-2)*(Vsq(-2, 1)+Vsq(-2, 3)+Vsq(-2, 5))
     $           +xf2(-4)*(Vsq(-4, 1)+Vsq(-4, 3)+Vsq(-4, 5))
     $           )
            vxf(2) = quanta*(
     $           +xf2( 1)*(Vsq(-2, 1)+Vsq(-4, 1))
     $           +xf2( 3)*(Vsq(-2, 3)+Vsq(-4, 3))
     $           +xf2( 5)*(Vsq(-2, 5)+Vsq(-4, 5))
     $           )
         endif

      elseif ( charge_id .gt. 0 ) then

         if ( fspart_id .eq. idtopt ) then
c     2213_1421     |      bt +      up ->      dn   +      tp
            vxf(1) = quanta*(
     $           + (Vsq( 2,-1)+Vsq( 2,-3))*xf2( 2)
     $           + (Vsq( 4,-1)+Vsq( 4,-3))*xf2( 4)
     $           )
c     1422_1321     | anti-dn +      bt -> anti-up   +      tp
            vxf(2) = quanta*(
     $           + (Vsq( 2,-1)+Vsq( 4,-1))*xf2(-1)
     $           + (Vsq( 2,-3)+Vsq( 4,-3))*xf2(-3)
     $           )
c     23_22__14_13_21 | g  +      bt ->      dn + anti-up +      tp (t-ch)
            vxf(3) = quanta*(
     $           + (Vsq(-2, 1)+Vsq(-4, 1)+Vsq(-2, 3)+Vsq(-4, 3))*xf2( 5)
     $           )
         else
            vxf(1) = quanta*(
     $           +xf2( 2)*(Vsq( 2,-1)+Vsq( 2,-3)+Vsq( 2,-5))
     $           +xf2( 4)*(Vsq( 4,-1)+Vsq( 4,-3)+Vsq( 4,-5))
     $           )
            vxf(2) = quanta*(
     $           +xf2(-1)*(Vsq( 2,-1)+Vsq( 4,-1))
     $           +xf2(-3)*(Vsq( 2,-3)+Vsq( 4,-3))
     $           +xf2(-5)*(Vsq( 2,-5)+Vsq( 4,-5))
     $           )
         endif

      elseif ( charge_id .eq. 0 ) then

         vxf(1) = quanta*(xf2( 2)+xf2( 4)        )
         vxf(2) = quanta*(xf2( 1)+xf2( 3)+xf2( 5))
         vxf(3) = quanta*(xf2(-2)+xf2(-4)        )
         vxf(4) = quanta*(xf2(-1)+xf2(-3)+xf2(-5))

      else

         print *, "something wrong. stop"
         stop

      endif

      do ik=1,4
         dconv(ik) = -2*vxf(ik)/x1/x2
      enddo

      call getMassSubtKern_gl(subip, Q, mskern)
      do ik=1,3
         mskern(ik) = mskern(ik)*alphcoef(ik)
      enddo

      if ( charge_id .ne. 0 ) then

         if ( fspart_id .eq. idtopt ) then
            ddconv(1) = dconv(1)*mskern(3)
            ddconv(2) = dconv(2)*mskern(3)
            ddconv(3) = dconv(3)*mskern(1)
            ddconv(4) = dconv(3)*mskern(2)
         else
            ddconv(1) = dconv(1)*mskern(2)
            ddconv(2) = dconv(2)*mskern(1)
         endif

      elseif ( charge_id .eq. 0 ) then

         ddconv(1) = dconv(1)*mskern(1)
         ddconv(2) = dconv(2)*mskern(2)
         ddconv(3) = dconv(3)*mskern(1)
         ddconv(4) = dconv(4)*mskern(2)

      else

         print *, "something wrong. stop"
         stop

      endif  

      return
      end

C--------------------------------------------------------------
      subroutine pdf_conv_ph (x1,x2,Q,conv)

      implicit none

      include 'constants.h'
      include 'ckm.h'
      include 'process.h'
      include 's2n_declare.h'
      !include 'scales.h'
      include 'iph.h'

      integer in,charge_id,fspart_id
      integer ifl,ifl1,ifl2,has_photon
      double precision x1,x2,Q,conv(4)
      double precision xf1(-6:6),xf2(-6:6)
      double precision vxf(4),quanta,phota,photb

      charge_id = processId/100
      fspart_id = abs(mod(processId,100))

      do in = 1,4
         vxf(in) = 0d0
         conv(in) = 0d0
      enddo

      if (iph.ne.0) then
         if (has_photon().eq.1) then
            call evolvePDFphoton(x1,Q,xf1,phota)
            call evolvePDFphoton(x2,Q,xf2,photb)
         else
            print *, "There is no photon function in the PDF. Exit"
            stop
         endif
      endif

C     numbering:
C     \bar{t  b  c  s  u  d} g  d  u  s  c  b  t
C         -6 -5 -4 -3 -2 -1  0  1  2  3  4  5  6

      if (iqed.ne.0) quanta=phota
      if (iqcd.ne.0) quanta=xf1(0)

      if ( charge_id .lt. 0 ) then

            vxf(1) = quanta*(
     $           +xf2(-2)*(Vsq(-2, 1)+Vsq(-2, 3)+Vsq(-2, 5))
     $           +xf2(-4)*(Vsq(-4, 1)+Vsq(-4, 3)+Vsq(-4, 5))
     $           )
            vxf(2) = quanta*(
     $           +xf2( 1)*(Vsq(-2, 1)+Vsq(-4, 1))
     $           +xf2( 3)*(Vsq(-2, 3)+Vsq(-4, 3))
     $           +xf2( 5)*(Vsq(-2, 5)+Vsq(-4, 5))
     $           )

      elseif ( charge_id .gt. 0 ) then

            vxf(1) = quanta*(
     $           +xf2( 2)*(Vsq( 2,-1)+Vsq( 2,-3)+Vsq( 2,-5))
     $           +xf2( 4)*(Vsq( 4,-1)+Vsq( 4,-3)+Vsq( 4,-5))
     $           )
            vxf(2) = quanta*(
     $           +xf2(-1)*(Vsq( 2,-1)+Vsq( 4,-1))
     $           +xf2(-3)*(Vsq( 2,-3)+Vsq( 4,-3))
     $           +xf2(-5)*(Vsq( 2,-5)+Vsq( 4,-5))
     $        )

      elseif ( charge_id .eq. 0 ) then

         vxf(1) = quanta*(xf2( 2)+xf2( 4)        )
         vxf(2) = quanta*(xf2( 1)+xf2( 3)+xf2( 5))
         vxf(3) = quanta*(xf2(-2)+xf2(-4)        )
         vxf(4) = quanta*(xf2(-1)+xf2(-3)+xf2(-5))

      else

         print *, "something wrong. stop"
         stop

      endif

      do in=1,4
         conv(in) = 2*vxf(in)/x1/x2
      enddo

      return
      end

C--------------------------------------------------------------
      subroutine pdf_conv_gg (x1,x2,Q,conv)

      implicit none

      include 'constants.h'
      include 'ckm.h'
      include 'process.h'
      include 's2n_declare.h'
      !include 'scales.h'
      include 'iph.h'

      integer in,charge_id,fspart_id,has_photon
      integer ifl,ifl1,ifl2
      double precision x1,x2,Q,conv(1)
      double precision xf1(-6:6),xf2(-6:6)
      double precision vxf(1),phota,photb

      do in = 1,1
         vxf(in) = 0d0
         conv(in) = 0d0
      enddo

      if (iph.ne.0) then
         if (has_photon().eq.1) then
            call evolvePDFphoton(x1,Q,xf1,phota)
            call evolvePDFphoton(x2,Q,xf2,photb)
         else
            print *, "There is no photon function in the PDF. Exit"
            stop
         endif
      endif

      vxf(1) = phota*photb

      do in=1,1
         conv(in) = 2*vxf(in)/x1/x2
      enddo

      return
      end

C--------------------------------------------------------------

!++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
!> Calculates mass singularity subtraction kernels for quarks
!<-------------------------------------------------------------
      subroutine getMassSubtKern (z, Q, mskern)

      implicit none

      include 's2n_declare.h'
      include 'process.h'

      integer iud
      double precision z, Q, mskern(3)

      mskern(1) = (1d0+z**2)/(1d0-z)*(dlog(Q**2/mup**2)-2d0*dlog(1d0-z)-1d0)
      mskern(2) = (1d0+z**2)/(1d0-z)*(dlog(Q**2/mdn**2)-2d0*dlog(1d0-z)-1d0)
      mskern(3) = (1d0+z**2)/(1d0-z)*(dlog(Q**2/mbt**2)-2d0*dlog(1d0-z)-1d0)

      if (imsb .eq. 2) then
        do iud = 1,3
          mskern(iud) = mskern(iud)
     &       +(1d0+z**2)/(1d0-z)*dlog((1d0-z)/z) - 3d0/2d0/(1d0-z)
     &       +2d0*z + 3d0
	enddo
      endif

      return
      end

C--------------------------------------------------------------

!++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
!> Calculates mass singularity subtraction kernels for gluons
!<-------------------------------------------------------------
      subroutine getMassSubtKern_gl (z, Q, mskern)

      implicit none

      include 's2n_declare.h'
      include 'process.h'

      double precision z, Q, mskern(3)

      mskern(1) = dlog(Q**2/mup**2)*(z**2+(1d0-z)**2)
      mskern(2) = dlog(Q**2/mdn**2)*(z**2+(1d0-z)**2)
      mskern(3) = dlog(Q**2/mbt**2)*(z**2+(1d0-z)**2)

      if (imsb .eq. 2) then
         mskern(1) = dlog(Q**2*(1d0-z)/mup**2/z)*(z**2+(1d0-z)**2)
     &    - 2d0 + 16d0*z - 16d0*z**2
         mskern(2) = dlog(Q**2*(1d0-z)/mdn**2/z)*(z**2+(1d0-z)**2)
     &    - 2d0 + 16d0*z - 16d0*z**2
         mskern(3) = dlog(Q**2*(1d0-z)/mbt**2/z)*(z**2+(1d0-z)**2)
     &    - 2d0 + 16d0*z - 16d0*z**2
      endif

      return
      end
C--------------------------------------------------------------

!++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
!> Calculates mass singularity subtraction kernels for gluons
!<-------------------------------------------------------------
      subroutine getMassSubtKern_2 (z, Q, mskern)

      implicit none

      include 's2n_declare.h'
      include 'process.h'

      double precision z, Q, mskern

      mskern = (1d0+z**2)/(1d0-z)*dlog((1d0-z)/z)-3d0/2d0/(1d0-z)
     $+2d0*z+3d0

      return
      end
C--------------------------------------------------------------

!++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
!> Calculates analytical integral of the subtraction coefficient
!<-------------------------------------------------------------
      subroutine getAI_0tox(x, Q, ai_0tox)

      implicit none

      include 's2n_declare.h'
      include 'process.h'

      double precision x, Q, ai_0tox(3)
      double precision ald, ard
 
      ald = 1d0/2*x**2+x+2d0*dlog(1d0-x)
      ard = 2d0*x+(1d0-2d0*x-x**2)*dlog(1d0-x)-2d0*dlog(1d0-x)**2
      if (imsb .eq. 2) then
        ard = ard +2d0*ddilog(1d0-x)-pi**2/3d0+dlog(1d0-x)**2
     &        +(-3d0+x+1d0/2*x**2)*dlog(1d0-x)
     &        -(     x+1d0/2*x**2)*dlog(x)-1d0/2*x
      endif

      ai_0tox(1) = ald*2d0*dlog(Q/mup)+ard
      ai_0tox(2) = ald*2d0*dlog(Q/mdn)+ard
      ai_0tox(3) = ald*2d0*dlog(Q/mbt)+ard

      return
      end

!++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
!> Calculates analytical integral of the subtraction coefficient
!<-------------------------------------------------------------
      subroutine getAI_0tox_2(x, Q, ai_0tox_2)

      implicit none

      include 's2n_declare.h'
      include 'process.h'

      double precision x, Q, ai_0tox_2(4)

      ai_0tox_2(1) = (1d0+(1d0-x)**2)/x*(dlog(q**2/mup**2)-2d0*dlog(x)-1d0)
      ai_0tox_2(2) = (1d0+(1d0-x)**2)/x*(dlog(q**2/mdn**2)-2d0*dlog(x)-1d0)
      ai_0tox_2(3) = +(1d0+x**2)/(1d0-x)*(dlog(x/(1d0-x))+3d0/4d0)
     $     -(9d0+5d0*x)/4d0
      ai_0tox_2(4) = +(1d0+x**2)/(1d0-x)*(dlog(x/(1d0-x))+3d0/4d0)
     $     -(9d0+5d0*x)/4d0

      return
      end
C--------------------------------------------------------------


!++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
!> Produces PDF convolutions with gluon in initial state
!! for subtraction components
!<-------------------------------------------------------------
      subroutine pdf_conv_subt_ph_2 (x1,x2,Q,subip,dconv)

      implicit none

      include 'constants.h'
      include 'ckm.h'
      include 'process.h'
      include 's2n_declare.h'
      include 'kin_cuts.h'
      !include 'scales.h'
      include 'iph.h'

      integer in,charge_id,fspart_id
      integer ik,ifl,iud,jud,has_photon
      double precision x1,x2,Q,subip,dconv(4),ddconv(4)
      double precision xf1(-6:6),xf2(-6:6),xf3(-6:6),xzf2(-6:6),xf2d(-6:6)
      double precision vxf(4),vvxf(4),quanta,phota,photb,photc

      double precision mskern,ai_0tox_2(4)
      double precision gap,ard,jacob_z,z
      !data gap/1d-10/
      data gap/0d0/
      
      double precision alphcoef(2)

      charge_id = processId/100
      fspart_id = abs(mod(processId,100))

      do in = 1,4
         vxf(in) = 0d0
         dconv(in) = 0d0
      enddo

      if (iph.ne.0) then
         if (has_photon().eq.1) then
            call evolvePDFphoton(x1,Q,xf1,phota)
            if ( x2 .lt. xmin  .or. x2 .gt. xmax  ) goto 10
            call evolvePDFphoton(x2,Q,xf2,photb)
         else
            print *, "There is no photon function in the PDF. Exit"
            stop
         endif
      endif

 10   continue
      if ( x2 .lt. xmin  .or. x2 .gt. xmax  ) then
         do ik=-6,6,1
            xf2(ik) = 0d0
         enddo
      endif

C     numbering:
C     \bar{t  b  c  s  u  d} g  d  u  s  c  b  t
C         -6 -5 -4 -3 -2 -1  0  1  2  3  4  5  6

      alphcoef(1) = (cfprime*alpha*qup**2)/2/pi
      alphcoef(2) = (cfprime*alpha*qdn**2)/2/pi

      quanta=phota

      vxf(1) = quanta*(xf2( 2)+xf2( 4)        )
      vxf(2) = quanta*(xf2( 1)+xf2( 3)+xf2( 5))
      vxf(3) = quanta*(xf2(-2)+xf2(-4)        )
      vxf(4) = quanta*(xf2(-1)+xf2(-3)+xf2(-5))

      do ik=1,4
         dconv(ik) = -2*vxf(ik)/x1/x2
      enddo

      call getAI_0tox_2(subip, Q, ai_0tox_2)

      do ik=1,4
         iud=2-mod(abs(ik),2)
         dconv(ik) = dconv(ik)*ai_0tox_2(iud)*alphcoef(iud)
      enddo

c      print *, alphcoef(1)*ai_0tox_2(1),dconv(1)/2

c-----------------------------------------------------
      if (imsb. eq. 2) then

         if (iph.ne.0) then
            if (has_photon().eq.1) then
               call evolvePDFphoton(x2*subip,Q,xf3,photc)
            else
               print *, "There is no photon function in the PDF. Exit"
               stop
            endif
         endif

         vvxf(1) = quanta*(xf3( 2)+xf3( 4)        )
         vvxf(2) = quanta*(xf3( 1)+xf3( 3)+xf3( 5))
         vvxf(3) = quanta*(xf3(-2)+xf3(-4)        )
         vvxf(4) = quanta*(xf3(-1)+xf3(-3)+xf3(-5))

         do ik=1,4
            ddconv(ik) = -2*(vxf(ik)-vvxf(ik))/x1/x2
         enddo

         do ik=1,4
            iud=2-mod(abs(ik),2)
            jud=4-mod(abs(ik),2)
            ddconv(ik) = ddconv(ik)*ai_0tox_2(jud)*alphcoef(iud)
         enddo

c         print *, ddconv/2

         do ik=1,4
            iud=2-mod(abs(ik),2)
            dconv(ik) = dconv(ik)+ddconv(ik)
         enddo

c         print *, dconv/2

         return
      endif

      return

c     outdated expressions with dcx
      jacob_z = 1d0 - x2 - 2d0*gap
      if ( jacob_z .le. 0d0 ) return
      z = x2+jacob_z*subip
      call getMassSubtKern_2(z, Q, mskern)
      mskern = mskern*jacob_z

      call evolvePDF(x2/z, Q, xzf2)

!     DCX
      ard = +2d0*ddilog(1d0-x2)-pi**2/3d0+dlog(1d0-x2)**2
     $     -x2**2/2d0*dlog(x2/(1d0-x2))-(3d0-x2)*dlog(1d0-x2)-x2*dlog(x2)
     $     -7d0/2d0*x2-x2**2

      do ifl = -nf, nf
         xf2d(ifl) = -(mskern*(xzf2(ifl)-xf2(ifl))+xf2(ifl)*ard)
      enddo

      do in = 1,4
         vxf(in) = 0d0
         dconv(in) = 0d0
      enddo

      do ifl=2,4,2
         iud = 2-mod(abs(ifl+1),2)
         vxf(1) = vxf(1)-phota*(xf2( ifl)*ai_0tox_2(1)-xf2d( ifl))*alphcoef(1)
         vxf(3) = vxf(3)-phota*(xf2(-ifl)*ai_0tox_2(1)-xf2d(-ifl))*alphcoef(1)
      enddo

      do ifl=1,5,2
         vxf(2) = vxf(2)-phota*(xf2( ifl)*ai_0tox_2(2)-xf2d( ifl))*alphcoef(2)
         vxf(4) = vxf(4)-phota*(xf2(-ifl)*ai_0tox_2(2)-xf2d(-ifl))*alphcoef(2)
      enddo

      do ik=1,4
         dconv(ik) = 2*vxf(ik)/x1/x2
      enddo

      return
      end
C--------------------------------------------------------------
