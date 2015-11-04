!++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
!> Provide PDF arguments ranges
!<-------------------------------------------------------------

      subroutine GetMinMax(nmem,xmin,xmax,q2min,q2max)

      implicit none
      
      integer nmem
      double precision xmin, xmax, q2min, q2max

      call getxmin(nmem, xmin)
      call getxmax(nmem, xmax)
      call getq2min(nmem, q2min)
      call getq2min(nmem, q2min)

      end
