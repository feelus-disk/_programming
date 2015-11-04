      integer maxnsig
      parameter (maxnsig=8)
      integer*8 nsig, ncall(maxnsig)
      character*32 sig_name(maxnsig)
      double precision sig(maxnsig), sig_err(maxnsig)

      common/stats/nsig, ncall, sig_name, sig, sig_err

