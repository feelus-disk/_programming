      real*8 function theta_hard (s,spr,omega)
      implicit none!
      real*8 eg,s,spr,omega

      theta_hard = 1d0
      if (spr.ge.s-2d0*sqrt(s)*omega) theta_hard = 0d0

      return
      end
