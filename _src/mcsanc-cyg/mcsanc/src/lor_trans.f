!++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
!> Lorentz rotation and boost procedures
!<-------------------------------------------------------------
      subroutine lrotateX(p, phi)

      implicit none
      
      integer i
      double precision p0(4), p(4), phi, cosphi, sinphi

      cosphi = dcos(phi)
      sinphi = dsin(phi)

      do i=1,4
        p0(i) = p(i)
      enddo

      p(1) = p0(1)
      p(2) = p0(2)*cosphi + p0(3)*sinphi
      p(3) = -p0(2)*sinphi + p0(3)*cosphi
      p(4) = p0(4)

      end

C--------------------------------------------------------------

      subroutine lrotateY(p, phi)

      implicit none
      
      integer i
      double precision p0(4), p(4), phi, cosphi, sinphi

      cosphi = dcos(phi)
      sinphi = dsin(phi)

      do i=1,4
        p0(i) = p(i)
      enddo

      p(1) = p0(1)*cosphi + p0(3)*sinphi
      p(2) = p0(2)
      p(3) = -p0(1)*sinphi + p0(3)*cosphi
      p(4) = p0(4)

      end

C--------------------------------------------------------------

      subroutine lrotateZ(p, phi)

      implicit none
      
      integer i
      double precision p0(4), p(4), phi, cosphi, sinphi

      cosphi = dcos(phi)
      sinphi = dsin(phi)

      do i=1,4
        p0(i) = p(i)
      enddo

      p(1) = p0(1)*cosphi + p0(2)*sinphi
      p(2) = -p0(1)*sinphi + p0(2)*cosphi
      p(3) = p0(3)
      p(4) = p0(4)

      end

C--------------------------------------------------------------

      subroutine lboostX(p, b)

      implicit none
      
      integer i
      double precision p0(4), p(4), b
      double precision g

      g = 1d0/sqrt(1d0-b**2)

      do i=1,4
        p0(i) = p(i)
      enddo

      p(1) = g*p0(1) - b*g*p0(4)
      p(2) = p0(2)
      p(3) = p0(3)
      p(4) = -b*g*p0(1) + g*p0(4)

      end

C--------------------------------------------------------------

      subroutine lboostY(p, b)

      implicit none
      
      integer i
      double precision p0(4), p(4), b
      double precision g

      g = 1d0/sqrt(1d0-b**2)

      do i=1,4
        p0(i) = p(i)
      enddo

      p(1) = p0(1)
      p(2) = g*p0(2) - b*g*p0(4)
      p(3) = p0(3)
      p(4) = -b*g*p0(2) + g*p0(4)

      end

C--------------------------------------------------------------

      subroutine lboostZ(p, b)

      implicit none
      
      integer i
      double precision p0(4), p(4), b
      double precision g

      if (abs(b).ge.1d0) return

      g = 1d0/sqrt(1d0-b**2)

      do i=1,4
        p0(i) = p(i)
      enddo

      p(1) = p0(1)
      p(2) = p0(2)
      p(3) = g*p0(3) - b*g*p0(4)
      p(4) = -b*g*p0(3) + g*p0(4)

      return
      end

C--------------------------------------------------------------
