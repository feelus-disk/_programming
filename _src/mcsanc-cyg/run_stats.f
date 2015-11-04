!++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
!> Print final results to mcsanc-*-output.txt
!<-------------------------------------------------------------
      subroutine print_final

C--------------------------------------------------------------
      implicit none

      include 'kin_cuts.h'
      include 'process.h'
      include 's2n_declare.h'
      include 'stats.h'
      include 'vegas.h'
      !include 'calo.h'

      double precision elapsed(2), total_time

      integer isig
      integer ic, ifh, ib, ipid
      integer*8 ncall_tot
      double precision sig_tot, sige_tot, delt, delte
      character*32 sig_name_tot, delt_name_tot
      character*256 output_fname

      output_fname='mcsanc-'//trim(run_tag)//'-output.txt'
      print *, output_fname
      open (81,file=output_fname)
C     process name
      do ipid=1,npid
        if (processId .eq. pid_array(ipid)) goto 101
      enddo
 101  continue
      write (81, *) "process: ", trim(pnames(ipid)), " (", processId,")"

C     cross section table
      ncall_tot = 0
      sig_tot = 0d0
      sige_tot = 0d0

      do isig=1,nsig
        ncall_tot = ncall_tot + ncall(isig)
        sig_tot = sig_tot+sig(isig)
        sige_tot = sige_tot+sig_err(isig)**2
      enddo
      sige_tot = dsqrt(sige_tot)

      delt  = (sig_tot/sig(1)-1)*1d2
      delte = dsqrt((sige_tot/sig(1))**2 + (sig_err(1)*sig_tot/sig(1)**2)**2)*1d2

      write (81, *) , repeat('-', 69)
      do isig=1,nsig
        write (81, '(X, A16,A,I15, E16.6, E16.6, 4X, A)'),
     $  sig_name(isig), '|' , ncall(isig), sig(isig), sig_err(isig), '|'
      enddo
      write (81, *) , repeat('-', 69)

      if (iborn .ne. 1) then
      sig_name_tot = repeat(' ', len(sig_name_tot))
      sig_name_tot = 'total'
      write (81, '(X, A16,A,I15, E16.6, E16.6, 4X, A)'),
     $  sig_name_tot, '|' , ncall_tot, sig_tot, sige_tot, '|'
      delt_name_tot = 'delta, %'
      write (81, '(X, A16,A,I15, E16.6, E16.6, 4X, A)'),
     $  delt_name_tot, '|' , ncall_tot, delt, delte, '|'
      write (81, *) , repeat('-', 69)
      endif

C     run info, time, cpu, mem (?) 
      call stop_clock(total_time, elapsed(1),elapsed(2))
      write (81, *) 'CPU usage:'
      write (81, *) 'total  = ', total_time/60.0, ' min'
      write (81, *) 'user   = ', elapsed(1)/60.0, ' min'
      write (81, *) 'system = ', elapsed(2)/60.0, ' min'

C     process config
      write (81, *) 'Run parameters:'
      write (81, *) 'process id = ', processId
      write (81, *) 'run tag    = ', trim(run_tag)
      write (81, *) 'sqs0       = ', sqs0
      write (81, *) 'beams      = ', beams
      write (81, *) 'iqed       = ', iflew(1)
      write (81, *) 'iew        = ', iflew(2)
      write (81, *) 'iborn      = ', iflew(3)
      write (81, *) 'ifgg       = ', iflew(4)
      write (81, *) 'irun       = ', iflew(5)
      write (81, *) 'iqcd       = ', iflqcd
      write (81, *) 'imsb       = ', imsb
      write (81, *) 'irecomb    = ', irecomb
      write (81, *) 'PDFSet, PDFMember = ' , trim(PDFSet), PDFMember

C     vegas config
      write (81, *) 'Vegas parameters:'
      write (81, *) 'Relative accuracy = ', relAcc
      write (81, *) 'Absolute accuracy = ', absAcc
      write (81, *) 'Nstart = ', nstart
      write (81, *) 'Nincrease = ', nincrease
      write (81, *) 'Maximum calls = ', maxEval

      write (81, *) ''
      call print_active_cuts(81)
      write (81, *) ''

      call print_ewpars(81)
      close(81)

      call print_hist
      call xml_write('mcsanc-'//trim(run_tag)//'-output.xml'//CHAR(0))
      end

!++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
!> Print histograms to mcsanc-*-output.txt
!<-------------------------------------------------------------
      subroutine print_hist

C--------------------------------------------------------------
      implicit none

      include 'compounds.h'
      include 'process.h'
      include 'stats.h'
      include 'vegas.h'

      character*64 hist_fname
      integer isig

c     clear and initialise
      call clear_all_hist

c     combine accumulated histograms from files
      do isig=1,nsig
         comp_name = sig_name(isig)
         hist_fname = trim(sfbase)//'_'//trim(comp_name)//'.hist'
         call set_hfname(trim(hist_fname)//CHAR(0))
         if ( comp_name .eq. 'born' ) call read_born_hist(0)
	 call read_hist(0)
	 call add_hist
      enddo
      call print_all_hist(trim(run_tag)//CHAR(0))

      end

!++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
!> Update statistics after each component calculation
!<-------------------------------------------------------------
      subroutine update_stats(neval, signd, signd_err)

C--------------------------------------------------------------
      implicit none

      integer*8 neval
      double precision signd, signd_err

      include 'compounds.h'
      include 's2n_declare.h'
      include 'stats.h'

      nsig = nsig+1
      sig_name(nsig) = repeat(' ', len(sig_name(nsig)))
      sig_name(nsig) = comp_name
      ncall(nsig) = neval
      sig(nsig) = signd
      sig_err(nsig) = signd_err

      end
