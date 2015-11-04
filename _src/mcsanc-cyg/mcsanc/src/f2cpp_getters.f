C     A set of functions providing access of some data
C     hidden in fortran headers to C++ code
      integer function get_max_kin_cuts()
        include  'kin_cuts.h'
        get_max_kin_cuts=maxKinCuts
        return
      end function


      subroutine get_process_name(pname) 
        include 'process.h'
        integer ipid
        character(len=128) pname
      do ipid=1,npid
        if (processId .eq. pid_array(ipid)) goto 101
      enddo
 101  continue
      pname= trim(pnames(ipid))//CHAR(0)
      return
      end subroutine
