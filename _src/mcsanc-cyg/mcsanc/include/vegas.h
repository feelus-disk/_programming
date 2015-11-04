C
C     Cuba library vegas algorithm parameters
C

      integer*8 nmaxdim
      parameter (nmaxdim=10)

      integer*8 maxncomp
      parameter (maxncomp=1)

      integer*8
     $	ndim,		! number of integration dimensions
     $	ncomp,		! number of components of the integrand
     $	flags,	        ! flags for Cuba, see Cuba documentation
     $	seed,		! pseudorandom generator seed
     $	minEval,	! minimum number of integrand evaluations required
     $	nStart,		! number of starting integrand evaluations
     $	nIncrease,	! increase of number of evaluations per iteration
     $	nbatch,		! batch size of sample points, default 10000
     $	gridno,		! number of grid for accumulated results, up to 10
     $	fail		! error flag (out)

      integer*8
     $	neval,		! actual number of evaluations needed (out)
     $	maxEval,	! (approximate) maximum of evaluations allowed
     $  nExplore	! number of calls for grid exploration

      parameter (nbatch=1000)

      double precision
     $	limits(2*nmaxdim),	! integral limits
     $	relAcc, absAcc,		! relative and absolute accuracies requested
     $	integral(maxncomp),	! the integral of integrand (out)
     $	error(maxncomp),	! presumed absolute error of the integral
     $	prob(maxncomp)		! chi2 probability that the error is reliable


      character *128 statefile	! filename for storing internal state
      character *128 sfbase	! base for statefile
      integer ixplore           ! grid exploration flag
      integer vegas_pad

      common/comvegas/
     $    relAcc, absAcc, flags, seed,
     $    minEval, maxEval, nStart, nIncrease, nExplore,
     $    gridno, ixplore, statefile, sfbase

