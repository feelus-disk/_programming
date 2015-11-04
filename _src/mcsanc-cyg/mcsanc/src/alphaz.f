!++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
!> Function to calculate running \f$ \alpha \f$
!! @param alpha0 \f$\alpha(0)\f$
!! @param sq \f$\sqrt{s}\f$
!<-----------------------------------------------------------------------
      real*8 function alphaz (alpha0,sq)
      implicit none!
      include 's2n_declare.h'
      real*8 sq,coeff,alpha0
      complex*16 ff_gg

      common/unibos_fer/za1fer,zz1fer,zh1fer,zw1fer,zmsqrfer,
     & zmzzzfer,zmwzwfer,zmhzhfer,deltarhofer,tadfer
      common/unipro_fer/caldzfer,caldwfer,pizgfer,piggfer

      s = sq**2

      call UniBosConsts_Fer ()
      call UniProConsts_fer (-s)

      ff_gg =
     & +stw**2*piggfer-za1fer

      coeff = alpha0/4d0/pi/stw2
      ff_gg = coeff*ff_gg

      alphaz = alpha0/(1-ff_gg)

      !print *, "alphaz = ", alphaz,1d0/alphaz
      !stop

      return
      end
