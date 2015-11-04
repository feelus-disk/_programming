      program MCSANC

C--------------------------------------------------------------
C
C>    MCSANC program
C
C--------------------------------------------------------------

      implicit none

      include 'process.h'

C--------------------------------------------------------------
*     ---------------------------------------------------------
*     Print info message
*     ---------------------------------------------------------
      call printMCSANCinfo

*     ---------------------------------------------------------
*     Read input parameters
*     ---------------------------------------------------------
      call read_input

*     ---------------------------------------------------------
*     Initialize calculations
*     ---------------------------------------------------------
      call init_run

*     ---------------------------------------------------------
*     Calculate the process cross sections
*     ---------------------------------------------------------
      call calc_proc

*     ---------------------------------------------------------
*     Print final statistics
*     ---------------------------------------------------------
      call print_final

*     ---------------------------------------------------------
*     Done
*     ---------------------------------------------------------
      call release_shmem
      stop
      end


!++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
!> Prints logo
!<-------------------------------------------------------------
      subroutine printMCSANCinfo
      print *,' '
      print *,' '
      print *,'---------------------------------------------------------'
      print *,'                                                         '
      print *,'  MM    MM   CCCCC    SSSSS    AAAAA   NN   NN   CCCCC   '
      print *,'  MMM  MMM  CC   CC  SS   SS  AA   AA  NNN  NN  CC   CC  '
      print *,'  MMMMMMMM  CC        SSS     AA   AA  NNNN NN  CC       '
      print *,'  MM MM MM  CC          SSS   AAAAAAA  NN NNNN  CC       '
      print *,'  MM    MM  CC   CC  SS   SS  AA   AA  NN  NNN  CC   CC  '
      print *,'  HM    MM   CCCCC    SSSSS   AA   AA  NN   NN   CCCCC   '
      print *,'                                                         '
      print *,'  Version 1.0.1                                          '
      print *,'  http://sanc.jinr.ru             sanc@jinr.ru           '
      print *,'---------------------------------------------------------'
      print *,' '
      print *,' '

      end

