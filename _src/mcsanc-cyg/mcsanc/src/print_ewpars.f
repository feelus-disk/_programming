!++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
!> Print electroweak parameters to file descriptor fd
!<-------------------------------------------------------------
      subroutine print_ewpars(fd)

      implicit none

      external alphasPDF

      include 'constants.h'
      include 'process.h'
      include 's2n_declare.h'
      include 'ckm.h'

      integer fd
      character*128 fmt1, fmt2
      double precision alphasPDF

      if (fscale .gt. 0d0 ) then
        alphas = alphasPDF(fscale)
      else
        alphas = 0d0
      endif

      fmt1='(X, A, X, A14, ES13.6E2, X, A14, ES13.6E2, 2X, A)'

      write (fd,'(A61)') '.. EW parameters ...........................................'
      write (fd,fmt1) '.','alpha_em = ',alpha,'alphas = ', alphas, '.'
      write (fd,fmt1) '.','1/alpha = ',1d0/alpha,'G_mu = ',gf,'.'
      write (fd,fmt1) '.','mw = ',mw,'ww = ', ww, '.'
      write (fd,fmt1) '.','mz = ',mz,'wz = ', wz, '.'
      write (fd,fmt1) '.','mh = ',mh,'wh = ', wh, '.'
      write (fd,fmt1) '.','sin2thw = ',stw2,'cos2thw = ', ctw2, '.'
      write (fd,fmt1) '.','fscale = ',fscale,'rscale = ', rscale, '.'
      write (fd,fmt1) '.','omega = ',ome,'conhc = ', conhc,'.'
      write (fd,'(A61)') '............................................................'

      write (fd,'(A)') ''

      fmt2='(X, A, X, A8, ES10.4E2, 1X, A8, ES10.4E2, 1X, A8, ES10.4E2, X, A)'

      write (fd,'(A61)') '.. CKM .....................................................'
      write (fd,fmt2) '.','Vud = ',sqrt(Vsq(2,-1)),'Vus = ', sqrt(Vsq(2,-3)), 'Vub = ', sqrt(Vsq(2,-5)), '.'
      write (fd,fmt2) '.','Vcd = ',sqrt(Vsq(4,-1)),'Vcs = ', sqrt(Vsq(4,-3)), 'Vcb = ', sqrt(Vsq(4,-5)), '.'
      write (fd,'(A61)') '............................................................'

      write (fd,'(A)') ''
      write (fd,'(A61)') '.. Fermion masses ..........................................'
      write (fd,fmt2) '.','mel = ',mel,'mmo = ', mmo, 'mta = ', mta, '.'
      write (fd,fmt2) '.','men = ',men,'mmn = ', mmn, 'mtn = ', mtn, '.'
      write (fd,fmt2) '.','mup = ',mup,'mch = ', mch, 'mtp = ', mtp, '.'
      write (fd,fmt2) '.','mdn = ',mdn,'mst = ', mst, 'mbt = ', mbt, '.'
      write (fd,'(A61)') '............................................................'
      

      end

