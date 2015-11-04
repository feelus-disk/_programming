!++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
!> Calls components calculation for user defined processes
!<-----------------------------------------------------------------------
      subroutine calc_proc

      implicit none
      integer fspart_id
      integer charge_id

      include 'process.h'
      include 'constants.h'
      include 's2n_declare.h'
      include 'iph.h'

      charge_id = processId/100
      fspart_id = abs(mod(processId,100))

      if (iborn .eq. -1) goto 20
      call qq_born

 20   continue
      if ( iborn .ne. 1 ) then

         if (iph .ge. 1) goto 30

         if ((iqed .eq. 1) .or. (iqed .eq. 2) .or. (iqed .eq. 6)
     $  .or. (iqcd .ne. 0))                    call qq_brdq

         if ((charge_id .eq. 0) .and. ((fspart_id .eq. idel)
     $  .or. (fspart_id .eq. idmu) .or. (fspart_id .eq. idtau))) then
            if ((iew.eq.0).and.(iqed.eq.0).and.(iqcd.eq.1).and.(ifgg.eq.0)) goto 10
                                               call qq_virt
         elseif (iew .ne. 0) then
                                               call qq_virt
         endif

 10      continue

         if  (iqcd .ne. 0)                     call qg_brdq

         if  (iqcd .ne. 0)                     call qg_hard

         if ((iqed .ne. 0) .or. (iqcd .ne. 0)) call qq_soft

         if ((iqed .ne. 0) .or. (iqcd .ne. 0)) call qq_hard

 30      continue

         if (iph .eq. 0) goto 40

         if (dabs(iph) .eq. 1) then
            if  (iqed .ne. 0)                  call qg_brdq

            if (charge_id .eq. 0) then
            if  (iqed .ne. 0)                  call qg_brd2
            endif

            if  (iqed .ne. 0)                  call qg_hard
         endif

         if (dabs(iph) .eq. 2)                 call gg_born

      endif

 40   return
      end
