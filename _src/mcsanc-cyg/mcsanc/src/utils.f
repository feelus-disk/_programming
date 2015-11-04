!++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
!> Various algebraic procedures
!<-------------------------------------------------------------
      subroutine scalar(p1, p2, p1p2)

      implicit none
      
      integer i
      double precision p1(4), p2(4), p1p2

      p1p2 = 0d0

c$$$      do i=1,3
c$$$        p1p2 = p1p2 + p1(i)*p2(i)
c$$$      enddo

      p1p2 = p1(4)*p2(4) - p1(1)*p2(1) - p1(2)*p2(2) - p1(3)*p2(3)

      return
      end

C--------------------------------------------------------------
      subroutine set_betaftu(costh,s,t,u)

C--------------------------------------------------------------
      implicit none

      include 'process.h'
      include 'constants.h'
      include 's2n_declare.h'

      double precision costh

      integer fspart_id
      integer charge_id

      charge_id = processId/100
      fspart_id = abs(mod(processId,100))

      if ( charge_id .ne. 0 .and. fspart_id .eq. idtopt ) then
         t =
     &        + (s-mtp**2) * (  - 1d0/2 )
     &        + costh*(s-mtp**2) * ( + 1d0/2/s*(s-mbt**2) )
     &        + 1d0/2*mbt**2 - 1d0/2*mtp**2*mbt**2/s
         u =
     &        + (s-mtp**2) * (  - 1d0/2 )
     &        + costh*(s-mtp**2) * ( - 1d0/2/s*(s-mbt**2) )
     &        + 1d0/2*mbt**2 + 1d0/2*mtp**2*mbt**2/s
      else
         betaf = 1d0-4*s*mf**2/(s+mf**2-mf1**2)**2
         if ( betaf .lt. 0d0 ) then
            print *, 'error in set_betaftu: betaf^2 < 0'
            print *, betaf, s, mf, mf1
         endif
         betaf = dsqrt(betaf)
         t = mf**2-1d0/2*(s+mf**2-mf1**2)*(1d0+betaf*costh)
         u = mf**2-1d0/2*(s+mf**2-mf1**2)*(1d0-betaf*costh)
      endif

      end
