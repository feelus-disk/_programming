!++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
!> SANC modules interfaces
!<-------------------------------------------------------------
      subroutine sanc_br (neg_s,neg_t,neg_u,aborn,asoft)

      implicit none

      include 'process.h'
      include 'constants.h'
      include 's2n_declare.h'

      double precision neg_s, neg_t, neg_u, aborn(2), asoft(2), qsoft(2)

      integer in
      integer fspart_id
      integer charge_id

      charge_id = processId/100
      fspart_id = abs(mod(processId,100))

      do in=1,2
         aborn(in) = 0d0
         asoft(in) = 0d0
         qsoft(in) = 0d0
      enddo

      if (charge_id .lt. 0) then
         if ( fspart_id .eq. idel ) then
            if ((iborn.eq.1).or.(iqed.ne.0)) then
               call cc_br_1314_1112    (neg_s,neg_t,neg_u,aborn(1),asoft(1),hard)
            endif
            if (iqcd.ne.0) then
               call cc_qcd_br_1314_1112(neg_s,neg_t,neg_u,aborn(1),qsoft(1),hard)
            endif
         elseif ( fspart_id .eq. idmu ) then
            if ((iborn.eq.1).or.(iqed.ne.0)) then
               call cc_br_1314_1516    (neg_s,neg_t,neg_u,aborn(1),asoft(1),hard)
            endif
            if (iqcd.ne.0) then
               call cc_qcd_br_1314_1516(neg_s,neg_t,neg_u,aborn(1),qsoft(1),hard)
            endif
         elseif ( fspart_id .eq. idtau ) then
            if ((iborn.eq.1).or.(iqed.ne.0)) then
               call cc_br_1314_1920    (neg_s,neg_t,neg_u,aborn(1),asoft(1),hard)
            endif
            if (iqcd.ne.0) then
               call cc_qcd_br_1314_1920(neg_s,neg_t,neg_u,aborn(1),qsoft(1),hard)
            endif
         elseif ( fspart_id .eq. idhiggs ) then
            if ((iborn.eq.1).or.(iqed.ne.0)) then
               call cc_br_1314_34      (neg_s,neg_t,neg_u,aborn(1),asoft(1),hard)
            endif
            if (iqcd.ne.0) then
               call cc_qcd_br_1314_34  (neg_s,neg_t,neg_u,aborn(1),qsoft(1),hard)
            endif
         elseif ( fspart_id .eq. idtops ) then
            if ((iborn.eq.1).or.(iqed.ne.0)) then
               call cc_br_1314_2122    (neg_s,neg_t,neg_u,aborn(1),asoft(1),hard)
            endif
            if (iqcd.ne.0) then
               call cc_qcd_br_1314_2122(neg_s,neg_t,neg_u,aborn(1),qsoft(1),hard)
            endif
         elseif ( fspart_id .eq. idtopt ) then
            if ((iborn.eq.1).or.(iqed.ne.0)) then
               call cc_br_1322_2114    (neg_s,neg_t,neg_u,aborn(1),asoft(1),hard)
               call cc_br_2214_2113    (neg_s,neg_t,neg_u,aborn(2),asoft(2),hard)
            endif
            if (iqcd.ne.0) then
               call cc_qcd_br_1322_2114(neg_s,neg_t,neg_u,aborn(1),qsoft(1),hard)
               call cc_qcd_br_2214_2113(neg_s,neg_t,neg_u,aborn(2),qsoft(2),hard)
            endif
         endif
      elseif (charge_id .gt. 0) then
         if ( fspart_id .eq. idel ) then
            if ((iborn.eq.1).or.(iqed.ne.0)) then
               call cc_br_1413_1211    (neg_s,neg_t,neg_u,aborn(1),asoft(1),hard)
            endif
            if (iqcd.ne.0) then
               call cc_qcd_br_1413_1211(neg_s,neg_t,neg_u,aborn(1),qsoft(1),hard)
            endif
         elseif ( fspart_id .eq. idmu ) then
            if ((iborn.eq.1).or.(iqed.ne.0)) then
               call cc_br_1413_1615    (neg_s,neg_t,neg_u,aborn(1),asoft(1),hard)
            endif
            if (iqcd.ne.0) then
               call cc_qcd_br_1413_1615(neg_s,neg_t,neg_u,aborn(1),qsoft(1),hard)
c               call cc_qcd_br_1413_1615_test(neg_s,neg_t,neg_u,aborn(1),qsoft(1),hard)
            endif
         elseif ( fspart_id .eq. idtau ) then
            if ((iborn.eq.1).or.(iqed.ne.0)) then
               call cc_br_1413_2019    (neg_s,neg_t,neg_u,aborn(1),asoft(1),hard)
            endif
            if (iqcd.ne.0) then
               call cc_qcd_br_1413_2019(neg_s,neg_t,neg_u,aborn(1),qsoft(1),hard)
            endif
         elseif ( fspart_id .eq. idhiggs ) then
            if ((iborn.eq.1).or.(iqed.ne.0)) then
               call cc_br_1413_43      (neg_s,neg_t,neg_u,aborn(1),asoft(1),hard)
            endif
            if (iqcd.ne.0) then
               call cc_qcd_br_1413_43  (neg_s,neg_t,neg_u,aborn(1),qsoft(1),hard)
            endif
         elseif ( fspart_id .eq. idtops ) then
            if ((iborn.eq.1).or.(iqed.ne.0)) then
               call cc_br_1413_2221    (neg_s,neg_t,neg_u,aborn(1),asoft(1),hard)
            endif
            if (iqcd.ne.0) then
               call cc_qcd_br_1413_2221(neg_s,neg_t,neg_u,aborn(1),qsoft(1),hard)
            endif
         elseif ( fspart_id .eq. idtopt ) then
            if ((iborn.eq.1).or.(iqed.ne.0)) then
               call cc_br_2213_1421    (neg_s,neg_t,neg_u,aborn(1),asoft(1),hard)
               call cc_br_1422_1321    (neg_s,neg_t,neg_u,aborn(2),asoft(2),hard)
            endif
            if (iqcd.ne.0) then
               call cc_qcd_br_2213_1421(neg_s,neg_t,neg_u,aborn(1),qsoft(1),hard)
               call cc_qcd_br_1422_1321(neg_s,neg_t,neg_u,aborn(2),qsoft(2),hard)
            endif
         endif
      else
         if ( fspart_id .eq. idel ) then
            if ((iborn.eq.1).or.(iqed.ne.0).or.(ifgg.eq.1)) then
               call nc_br_1313_1212    (neg_s,neg_t,neg_u,aborn(1),asoft(1),hard)
               call nc_br_1414_1212    (neg_s,neg_t,neg_u,aborn(2),asoft(2),hard)
            endif
            if (iqcd.ne.0) then
               call nc_qcd_br_1313_1212(neg_s,neg_t,neg_u,aborn(1),qsoft(1),hard)
               call nc_qcd_br_1414_1212(neg_s,neg_t,neg_u,aborn(2),qsoft(2),hard)
            endif
         elseif ( fspart_id .eq. idmu ) then
            if ((iborn.eq.1).or.(iqed.ne.0).or.(ifgg.eq.1)) then
               call nc_br_1313_1616    (neg_s,neg_t,neg_u,aborn(1),asoft(1),hard)
               call nc_br_1414_1616    (neg_s,neg_t,neg_u,aborn(2),asoft(2),hard)
            endif
            if (iqcd.ne.0) then
               call nc_qcd_br_1313_1616(neg_s,neg_t,neg_u,aborn(1),qsoft(1),hard)
               call nc_qcd_br_1414_1616(neg_s,neg_t,neg_u,aborn(2),qsoft(2),hard)
            endif
         elseif ( fspart_id .eq. idtau ) then
            if ((iborn.eq.1).or.(iqed.ne.0).or.(ifgg.eq.1)) then
               call nc_br_1313_2020    (neg_s,neg_t,neg_u,aborn(1),asoft(1),hard)
               call nc_br_1414_2020    (neg_s,neg_t,neg_u,aborn(2),asoft(2),hard)
            endif
            if (iqcd.ne.0) then
               call nc_qcd_br_1313_2020(neg_s,neg_t,neg_u,aborn(1),qsoft(1),hard)
               call nc_qcd_br_1414_2020(neg_s,neg_t,neg_u,aborn(2),qsoft(2),hard)
            endif
         elseif ( fspart_id .eq. idhiggs ) then
            if ((iborn.eq.1).or.(iqed.ne.0)) then
               call nc_br_1313_42      (neg_s,neg_t,neg_u,aborn(1),asoft(1),hard)
               call nc_br_1414_42      (neg_s,neg_t,neg_u,aborn(2),asoft(2),hard)
            endif
            if (iqcd.ne.0) then
               call nc_qcd_br_1313_42  (neg_s,neg_t,neg_u,aborn(1),qsoft(1),hard)
               call nc_qcd_br_1414_42  (neg_s,neg_t,neg_u,aborn(2),qsoft(2),hard)
            endif
         elseif ( fspart_id .eq. idtops ) then
            print *, 'sanc_interface: top production is not implemented'
            stop
         endif
      endif

      do in=1,2
         asoft(in) = asoft(in)+qsoft(in)
      enddo

      return
      end

C--------------------------------------------------------------

      subroutine sanc_si (s,t,u,asigma)

      implicit none

      include 'process.h'
      include 'constants.h'

      double precision s, t, u, asigma(2)

      integer in
      integer fspart_id
      integer charge_id

      do in = 1,2
         asigma(in) = 0d0
      enddo

      charge_id = processId/100
      fspart_id = abs(mod(processId,100))

      if (charge_id .lt. 0) then
         if ( fspart_id .eq. idel ) then
            call cc_si_1314_1112(s,t,u,asigma(1))
         elseif ( fspart_id .eq. idmu ) then
            call cc_si_1314_1516(s,t,u,asigma(1))
         elseif ( fspart_id .eq. idtau ) then
            call cc_si_1314_1920(s,t,u,asigma(1))
         elseif ( fspart_id .eq. idhiggs ) then
            call cc_si_1314_34  (s,t,u,asigma(1))
         elseif ( fspart_id .eq. idtops ) then
            call cc_si_1314_2122(s,t,u,asigma(1))
         elseif ( fspart_id .eq. idtopt ) then
            call cc_si_1322_2114(s,t,u,asigma(1))
            call cc_si_2214_2113(s,t,u,asigma(2))
         endif
      elseif (charge_id .gt. 0) then
         if ( fspart_id .eq. idel ) then
            call cc_si_1413_1211(s,t,u,asigma(1))
         elseif ( fspart_id .eq. idmu ) then
            call cc_si_1413_1615(s,t,u,asigma(1))
         elseif ( fspart_id .eq. idtau ) then
            call cc_si_1413_2019(s,t,u,asigma(1))
         elseif ( fspart_id .eq. idhiggs ) then
            call cc_si_1413_43  (s,t,u,asigma(1))
         elseif ( fspart_id .eq. idtops ) then
            call cc_si_1413_2221(s,t,u,asigma(1))
         elseif ( fspart_id .eq. idtopt ) then
            call cc_si_2213_1421(s,t,u,asigma(1))
            call cc_si_1422_1321(s,t,u,asigma(2))
         endif
      else
         if ( fspart_id .eq. idel ) then
            call nc_si_1313_1212(s,t,u,asigma(1))
            call nc_si_1414_1212(s,t,u,asigma(2))
         elseif ( fspart_id .eq. idmu ) then
            call nc_si_1313_1616(s,t,u,asigma(1))
            call nc_si_1414_1616(s,t,u,asigma(2))
         elseif ( fspart_id .eq. idtau ) then
            call nc_si_1313_2020(s,t,u,asigma(1))
            call nc_si_1414_2020(s,t,u,asigma(2))
         elseif ( fspart_id .eq. idhiggs ) then
            call nc_si_1313_42  (s,t,u,asigma(1))
            call nc_si_1414_42  (s,t,u,asigma(2))
         elseif ( fspart_id .eq. idtops ) then
            print *,
     &    'sanc_interface: top-atop production is not implemented. stop'
            stop
         endif
      endif

      end

C--------------------------------------------------------------

      subroutine sanc_ha (s,spr,phi4,costh4,costh5,ahard)

      implicit none

      include 'process.h'
      include 'constants.h'
      include 's2n_declare.h'

      double precision phi4,costh4,costh5,ahard(2),qhard(2)

      integer in
      integer fspart_id
      integer charge_id

      do in = 1,2
         ahard(in) = 0d0
         qhard(in) = 0d0
      enddo

      charge_id = processId/100
      fspart_id = abs(mod(processId,100))

      if (charge_id .lt. 0) then
         if ( fspart_id .eq. idel ) then
            if (iqed.ne.0) call cc_ha_1314_1112    (s,spr,phi4,costh4,costh5,ahard(1))
            if (iqcd.ne.0) call cc_qcd_ha_1314_1112(s,spr,phi4,costh4,costh5,qhard(1))
         elseif ( fspart_id .eq. idmu ) then
            if (iqed.ne.0) call cc_ha_1314_1516    (s,spr,phi4,costh4,costh5,ahard(1))
            if (iqcd.ne.0) call cc_qcd_ha_1314_1516(s,spr,phi4,costh4,costh5,qhard(1))
         elseif ( fspart_id .eq. idtau ) then
            if (iqed.ne.0) call cc_ha_1314_1920    (s,spr,phi4,costh4,costh5,ahard(1))
            if (iqcd.ne.0) call cc_qcd_ha_1314_1920(s,spr,phi4,costh4,costh5,qhard(1))
         elseif ( fspart_id .eq. idhiggs ) then
            if (iqed.ne.0) call cc_ha_1314_34      (s,spr,phi4,costh4,costh5,ahard(1))
            if (iqcd.ne.0) call cc_qcd_ha_1314_34  (s,spr,phi4,costh4,costh5,qhard(1))
         elseif ( fspart_id .eq. idtops ) then
            if (iqed.ne.0) call cc_ha_1314_2122    (s,spr,phi4,costh4,costh5,ahard(1))
            if (iqcd.ne.0) call cc_qcd_ha_1314_2122(s,spr,phi4,costh4,costh5,qhard(1))
         elseif ( fspart_id .eq. idtopt ) then
            if (iqed.ne.0) then
                           call cc_ha_1322_2114    (s,spr,phi4,costh4,costh5,ahard(1))
                           call cc_ha_2214_2113    (s,spr,phi4,costh4,costh5,ahard(2))
            endif
            if (iqcd.ne.0) then
                           call cc_qcd_ha_1322_2114(s,spr,phi4,costh4,costh5,qhard(1))
                           call cc_qcd_ha_2214_2113(s,spr,phi4,costh4,costh5,qhard(2))
            endif
         endif
      elseif (charge_id .gt. 0) then
         if ( fspart_id .eq. idel ) then
            if (iqed.ne.0) call cc_ha_1413_1211    (s,spr,phi4,costh4,costh5,ahard(1))
            if (iqcd.ne.0) call cc_qcd_ha_1413_1211(s,spr,phi4,costh4,costh5,qhard(1))
         elseif ( fspart_id .eq. idmu ) then
            if (iqed.ne.0) call cc_ha_1413_1615    (s,spr,phi4,costh4,costh5,ahard(1))
            if (iqcd.ne.0) call cc_qcd_ha_1413_1615(s,spr,phi4,costh4,costh5,qhard(1))
c            if (iqcd.ne.0) call cc_qcd_ha_1413_1615_test(s,spr,phi4,costh4,costh5,qhard(1))
         elseif ( fspart_id .eq. idtau ) then
            if (iqed.ne.0) call cc_ha_1413_2019    (s,spr,phi4,costh4,costh5,ahard(1))
            if (iqcd.ne.0) call cc_qcd_ha_1413_2019(s,spr,phi4,costh4,costh5,qhard(1))
         elseif ( fspart_id .eq. idhiggs ) then
            if (iqed.ne.0) call cc_ha_1413_43      (s,spr,phi4,costh4,costh5,ahard(1))
            if (iqcd.ne.0) call cc_qcd_ha_1413_43  (s,spr,phi4,costh4,costh5,qhard(1))
         elseif ( fspart_id .eq. idtops ) then
            if (iqed.ne.0) call cc_ha_1413_2221    (s,spr,phi4,costh4,costh5,ahard(1))
            if (iqcd.ne.0) call cc_qcd_ha_1413_2221(s,spr,phi4,costh4,costh5,qhard(1))
         elseif ( fspart_id .eq. idtopt ) then
            if (iqed.ne.0) then
                           call cc_ha_2213_1421    (s,spr,phi4,costh4,costh5,ahard(1))
                           call cc_ha_1422_1321    (s,spr,phi4,costh4,costh5,ahard(2))
            endif
            if (iqcd.ne.0) then
                           call cc_qcd_ha_2213_1421(s,spr,phi4,costh4,costh5,qhard(1))
                           call cc_qcd_ha_1422_1321(s,spr,phi4,costh4,costh5,qhard(2))
            endif
         endif
      else
         if ( fspart_id .eq. idel ) then
            if (iqed.ne.0) call nc_ha_1313_1212    (s,spr,phi4,costh4,costh5,ahard(1))
            if (iqed.ne.0) call nc_ha_1414_1212    (s,spr,phi4,costh4,costh5,ahard(2))
            if (iqcd.ne.0) call nc_qcd_ha_1313_1212(s,spr,phi4,costh4,costh5,qhard(1))
            if (iqcd.ne.0) call nc_qcd_ha_1414_1212(s,spr,phi4,costh4,costh5,qhard(2))
         elseif ( fspart_id .eq. idmu ) then
            if (iqed.ne.0) call nc_ha_1313_1616    (s,spr,phi4,costh4,costh5,ahard(1))
            if (iqed.ne.0) call nc_ha_1414_1616    (s,spr,phi4,costh4,costh5,ahard(2))
            if (iqcd.ne.0) call nc_qcd_ha_1313_1616(s,spr,phi4,costh4,costh5,qhard(1))
            if (iqcd.ne.0) call nc_qcd_ha_1414_1616(s,spr,phi4,costh4,costh5,qhard(2))
         elseif ( fspart_id .eq. idtau ) then
            if (iqed.ne.0) call nc_ha_1313_2020    (s,spr,phi4,costh4,costh5,ahard(1))
            if (iqed.ne.0) call nc_ha_1414_2020    (s,spr,phi4,costh4,costh5,ahard(2))
            if (iqcd.ne.0) call nc_qcd_ha_1313_2020(s,spr,phi4,costh4,costh5,qhard(1))
            if (iqcd.ne.0) call nc_qcd_ha_1414_2020(s,spr,phi4,costh4,costh5,qhard(2))
         elseif ( fspart_id .eq. idhiggs ) then
            if (iqed.ne.0) call nc_ha_1313_42      (s,spr,phi4,costh4,costh5,ahard(1))
            if (iqed.ne.0) call nc_ha_1414_42      (s,spr,phi4,costh4,costh5,ahard(2))
            if (iqcd.ne.0) call nc_qcd_ha_1313_42  (s,spr,phi4,costh4,costh5,qhard(1))
            if (iqcd.ne.0) call nc_qcd_ha_1414_42  (s,spr,phi4,costh4,costh5,qhard(2))
         elseif ( fspart_id .eq. idtops ) then
            print *,
     &    'sanc_interface: top-atop production is not implemented. stop'
            stop
         endif
      endif

      do in = 1,2
         ahard(in) = ahard(in) + qhard(in)
      enddo

      end

C--------------------------------------------------------------

      subroutine sanc_gl (s,spr,phi4,costh4,costh5,ahard)

      implicit none

      include 'process.h'
      include 'constants.h'
      include 's2n_declare.h'

      double precision phi4,costh4,costh5,ahard(4),qhard(4),bi,bf

      integer in
      integer fspart_id
      integer charge_id

      do in = 1,4
         ahard(in) = 0d0
         qhard(in) = 0d0
      enddo

      charge_id = processId/100
      fspart_id = abs(mod(processId,100))

      if (charge_id .lt. 0) then
         if ( fspart_id .eq. idel ) then
            if (iqcd.ne.0) then
               call cc_qcd_ha_13_23__14_11_12 (s,spr,phi4,costh4,costh5,qhard(1))
               call cc_qcd_ha_23_14__13_11_12 (s,spr,phi4,costh4,costh5,qhard(2))
            endif
            if (iqed.ne.0) then
               call cc_ha_13_1__14_11_12 (s,spr,phi4,costh4,costh5,qhard(1))
               call cc_ha_1_14__13_11_12 (s,spr,phi4,costh4,costh5,qhard(2))
            endif
         elseif ( fspart_id .eq. idmu ) then
            if (iqcd.ne.0) then
               call cc_qcd_ha_13_23__14_15_16 (s,spr,phi4,costh4,costh5,qhard(1))
               call cc_qcd_ha_23_14__13_15_16 (s,spr,phi4,costh4,costh5,qhard(2))
            endif
            if (iqed.ne.0) then
               call cc_ha_13_1__14_15_16 (s,spr,phi4,costh4,costh5,qhard(1))
               call cc_ha_1_14__13_15_16 (s,spr,phi4,costh4,costh5,qhard(2))
            endif
         elseif ( fspart_id .eq. idtau ) then
            if (iqcd.ne.0) then
               call cc_qcd_ha_13_23__14_19_20 (s,spr,phi4,costh4,costh5,qhard(1))
               call cc_qcd_ha_23_14__13_19_20 (s,spr,phi4,costh4,costh5,qhard(2))
            endif
            if (iqed.ne.0) then
               call cc_ha_13_1__14_19_20 (s,spr,phi4,costh4,costh5,qhard(1))
               call cc_ha_1_14__13_19_20 (s,spr,phi4,costh4,costh5,qhard(2))
            endif
         elseif ( fspart_id .eq. idhiggs ) then
            if (iqcd.ne.0) then
               call cc_qcd_ha_13_23__14_3_4   (s,spr,phi4,costh4,costh5,qhard(1))
               call cc_qcd_ha_23_14__13_3_4   (s,spr,phi4,costh4,costh5,qhard(2))
            endif
         elseif ( fspart_id .eq. idtops ) then
            if (iqcd.ne.0) then
               call cc_qcd_ha_13_23__14_21_22 (s,spr,phi4,costh4,costh5,qhard(1))
               call cc_qcd_ha_23_14__13_21_22 (s,spr,phi4,costh4,costh5,qhard(2))
            endif
         elseif ( fspart_id .eq. idtopt ) then
            if (iqcd.ne.0) then
               call cc_qcd_ha_13_23__22_21_14 (s,spr,phi4,costh4,costh5,qhard(1))
               call cc_qcd_ha_23_14__22_21_13 (s,spr,phi4,costh4,costh5,qhard(2))
               call cc_qcd_ha_22_23__14_21_13 (s,spr,phi4,costh4,costh5,qhard(3))
            endif
         endif
      elseif (charge_id .gt. 0) then
         if ( fspart_id .eq. idel ) then
            if (iqcd.ne.0) then
               call cc_qcd_ha_23_13__14_12_11 (s,spr,phi4,costh4,costh5,qhard(1))
               call cc_qcd_ha_14_23__13_12_11 (s,spr,phi4,costh4,costh5,qhard(2))
            endif
            if (iqed.ne.0) then
               call cc_ha_1_13__14_12_11 (s,spr,phi4,costh4,costh5,qhard(1))
               call cc_ha_14_1__13_12_11 (s,spr,phi4,costh4,costh5,qhard(2))
            endif
         elseif ( fspart_id .eq. idmu ) then
            if (iqcd.ne.0) then
               call cc_qcd_ha_23_13__14_16_15 (s,spr,phi4,costh4,costh5,qhard(1))
               call cc_qcd_ha_14_23__13_16_15 (s,spr,phi4,costh4,costh5,qhard(2))
            endif
            if (iqed.ne.0) then
               call cc_ha_1_13__14_16_15 (s,spr,phi4,costh4,costh5,qhard(1))
               call cc_ha_14_1__13_16_15 (s,spr,phi4,costh4,costh5,qhard(2))
            endif
         elseif ( fspart_id .eq. idtau ) then
            if (iqcd.ne.0) then
               call cc_qcd_ha_23_13__14_20_19 (s,spr,phi4,costh4,costh5,qhard(1))
               call cc_qcd_ha_14_23__13_20_19 (s,spr,phi4,costh4,costh5,qhard(2))
            endif
            if (iqed.ne.0) then
               call cc_ha_1_13__14_20_19 (s,spr,phi4,costh4,costh5,qhard(1))
               call cc_ha_14_1__13_20_19 (s,spr,phi4,costh4,costh5,qhard(2))
            endif
         elseif ( fspart_id .eq. idhiggs ) then
             if (iqcd.ne.0) then
                call cc_qcd_ha_23_13__14_4_3  (s,spr,phi4,costh4,costh5,qhard(1))
                call cc_qcd_ha_14_23__13_4_3  (s,spr,phi4,costh4,costh5,qhard(2))
             endif
         elseif ( fspart_id .eq. idtops ) then
            if (iqcd.ne.0) then
               call cc_qcd_ha_23_13__14_22_21 (s,spr,phi4,costh4,costh5,qhard(1))
               call cc_qcd_ha_14_23__13_22_21 (s,spr,phi4,costh4,costh5,qhard(2))
            endif
         elseif ( fspart_id .eq. idtopt ) then
            if (iqcd.ne.0) then
               call cc_qcd_ha_23_13__22_14_21 (s,spr,phi4,costh4,costh5,qhard(1))
               call cc_qcd_ha_14_23__22_13_21 (s,spr,phi4,costh4,costh5,qhard(2))
               call cc_qcd_ha_23_22__14_13_21 (s,spr,phi4,costh4,costh5,qhard(3))
            endif
         endif
      else
         if ( fspart_id .eq. idel ) then
            if (iqcd.ne.0) then
               call nc_qcd_ha_23_13__13_12_12 (s,spr,phi4,costh4,costh5,qhard(1))
               call nc_qcd_ha_23_14__14_12_12 (s,spr,phi4,costh4,costh5,qhard(2))
            endif
            if (iqed.ne.0) then
               call nc_ha_1_13__13_12_12 (s,spr,phi4,costh4,costh5,ahard(1))
               call nc_ha_1_14__14_12_12 (s,spr,phi4,costh4,costh5,ahard(2))
               ahard(3) = ahard(1)
               ahard(4) = ahard(2)
            endif
         elseif ( fspart_id .eq. idmu ) then
            if (iqcd.ne.0) then
               call nc_qcd_ha_23_13__13_16_16 (s,spr,phi4,costh4,costh5,qhard(1))
               call nc_qcd_ha_23_14__14_16_16 (s,spr,phi4,costh4,costh5,qhard(2))
            endif
            if (iqed.ne.0) then
               call nc_ha_1_13__13_16_16 (s,spr,phi4,costh4,costh5,ahard(1))
               call nc_ha_1_14__14_16_16 (s,spr,phi4,costh4,costh5,ahard(2))
c               call nc_ha_13_1__13_16_16 (s,spr,phi4,costh4,costh5,ahard(3))
c               call nc_ha_14_1__14_16_16 (s,spr,phi4,costh4,costh5,ahard(4))
               ahard(3) = ahard(1)
               ahard(4) = ahard(2)
            endif
         elseif ( fspart_id .eq. idtau ) then
            if (iqcd.ne.0) then
               call nc_qcd_ha_23_13__13_20_20 (s,spr,phi4,costh4,costh5,qhard(1))
               call nc_qcd_ha_23_14__14_20_20 (s,spr,phi4,costh4,costh5,qhard(2))
            endif
            if (iqed.ne.0) then
               call nc_ha_1_13__13_20_20 (s,spr,phi4,costh4,costh5,ahard(1))
               call nc_ha_1_14__14_20_20 (s,spr,phi4,costh4,costh5,ahard(2))
               ahard(3) = ahard(1)
               ahard(4) = ahard(2)
            endif
         elseif ( fspart_id .eq. idhiggs ) then
            if (iqcd.ne.0) then
               call nc_qcd_ha_23_13__13_4_2   (s,spr,phi4,costh4,costh5,qhard(1))
               call nc_qcd_ha_23_14__14_4_2   (s,spr,phi4,costh4,costh5,qhard(2))
            endif
         elseif ( fspart_id .eq. idtops ) then
            print *,
     &    'sanc_interface: top-atop production is not implemented. stop'
            stop
         endif
      endif

      do in = 1,4
         ahard(in) = ahard(in) + qhard(in)
      enddo

      end
C--------------------------------------------------------------

      subroutine sanc_br_gg (neg_s,neg_t,neg_u,aborn,asoft)

      implicit none

      include 'process.h'
      include 'constants.h'
      include 's2n_declare.h'

      double precision neg_s, neg_t, neg_u, aborn(1), asoft(1)

      integer in
      integer fspart_id
      integer charge_id

      charge_id = processId/100
      fspart_id = abs(mod(processId,100))

      do in=1,1
         aborn(in) = 0d0
         asoft(in) = 0d0
      enddo

      if ( fspart_id .eq. idel ) then
         call nc_br_11_1212    (neg_s,neg_t,neg_u,aborn(1),asoft(1),hard)
      elseif ( fspart_id .eq. idmu ) then
         call nc_br_11_1616    (neg_s,neg_t,neg_u,aborn(1),asoft(1),hard)
      elseif ( fspart_id .eq. idtau ) then
         call nc_br_11_2020    (neg_s,neg_t,neg_u,aborn(1),asoft(1),hard)
      endif

      return
      end
