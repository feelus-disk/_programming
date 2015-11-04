* GaussPivot.F
* Solution of the linear equation A.x = B by Gaussian elimination
* with partial pivoting
* this file is part of LoopTools
* last modified 24 Jan 06 th

* Author: Michael Rauch, 7 Dec 2004
* Reference: Folkmar Bornemann, course notes to
* Numerische Mathematik 1, Technische Universitaet, Munich, Germany

#include "defs.h"

#define MAXDIM 8

************************************************************************
* LUDecomp computes the LU decomposition of the n-by-n matrix A
* by Gaussian Elimination with partial pivoting;
* compact (in situ) storage scheme
* Input:
*   A: n-by-n matrix to LU-decompose
*   n: dimension of A
* Output:
*   A: mangled LU decomposition of A in the form
*     ( y11 y12 ... y1n )
*     ( x21 y22 ... y2n )
*     ( x31 x32 ... y3n )
*     ( ............... )
*     ( xn1 xn2 ... ynn )
*   where 
*     (   1   0 ...   0 )  ( y11 y12 ... y1n )
*     ( x21   1 ...   0 )  (   0 y22 ... y2n )
*     ( x31 x32 ...   0 )  (   0   0 ... y3n )  =  Permutation(A)
*     ( ............... )  ( ............... )
*     ( xn1 xn2 ...   1 )  (   0   0 ... ynn ) 
*   perm: permutation vector

	subroutine XLUDecomp(A, n, perm)
	implicit none
	integer n, perm(*)
	QVAR A(n,*)

	integer i, j, k, imax
	QVAR tmp
	QREAL Amax

	do j = 1, n
* do U part (minus diagonal one)
	  do i = 1, j - 1
	    do k = 1, i - 1
	      A(i,j) = A(i,j) - A(i,k)*A(k,j)
	    enddo
	  enddo

* do L part (plus diagonal from U case)
	  Amax = 0
	  do i = j, n
	    tmp = 0
	    do k = 1, j - 1
	      tmp = tmp + A(i,k)*A(k,j)
	    enddo
	    A(i,j) = A(i,j) - tmp

* do partial pivoting ...
* find the pivot
	    if( abs(A(i,j)) .gt. Amax ) then
	      Amax = abs(A(i,j))
	      imax = i
	    endif
	  enddo

* exchange rows
	  perm(j) = imax
	  do k = 1, n
	    tmp = A(j,k)
	    A(j,k) = A(imax,k)
	    A(imax,k) = tmp
	  enddo

* division by the pivot element
	  if( A(j,j) .eq. 0 ) then
	    tmp = 1D123
	  else
	    tmp = 1/A(j,j)
	  endif
	  do i = j + 1, n
	    A(i,j) = A(i,j)*tmp
	  enddo
	enddo
	end

************************************************************************
* LUBackSubst computes the x in A.x = b from the LU-decomposed A.
* Input:
*   A: LU-decomposed n-by-n matrix A
*   b: input vector b in A.x = b
*   n: dimension of A
*   p: permutation vector from LU decomposition
* Output:
*   b: solution vector x in A.x = b

	subroutine XLUBackSubst(A, n, p, b)
	implicit none
	integer n, p(*)
	QVAR A(n,*)
	double complex b(*)

	integer i, j
	double complex tmp

* permute b 
	do i = 1, n
	  tmp = b(i)
	  b(i) = b(p(i))
	  b(p(i)) = tmp
	enddo

* forward substitution L.Y = B
	do i = 1, n
	  do j = 1, i - 1
	    b(i) = b(i) - A(i,j)*b(j)
	  enddo
	enddo

* backward substitution U.X = Y
	do i = n, 1, -1
	  do j = i + 1, n
	    b(i) = b(i) - A(i,j)*b(j)
	  enddo
	  b(i) = b(i)/A(i,i)
	enddo
	end

************************************************************************
* same as LUBackSubst, but for real b

#ifdef COMPLEXPARA
#define LUBackSubstD LUBackSubstC
#else
	subroutine LUBackSubstD(A, n, p, b)
	implicit none
	integer n, p(*)
	QVAR A(n,*)
	QVAR b(*)

	integer i, j
	QVAR tmp

* permute b 
	do i = 1, n
	  tmp = b(i)
	  b(i) = b(p(i))
	  b(p(i)) = tmp
	enddo

* forward substitution L.Y = B
	do i = 1, n
	  do j = 1, i - 1
	    b(i) = b(i) - A(i,j)*b(j)
	  enddo
	enddo

* backward substitution U.X = Y
	do i = n, 1, -1
	  do j = i + 1, n
	    b(i) = b(i) - A(i,j)*b(j)
	  enddo
	  b(i) = b(i)/A(i,i)
	enddo
	end
#endif

************************************************************************
* Det computes the determinant of a matrix.
* Input:
*   A: n-by-n matrix A
*   n: dimension of A
* Output:
*   determinant of A
* Warning: A is overwritten

	QVAR function XDet(A, n)
	implicit none
	integer n
	QVAR A(n,*)

	integer i, perm(MAXDIM)

	call XLUDecomp(A, n, perm)
	XDet = 1
	do i = 1, n
	  XDet = XDet*A(i,i)
	  if( perm(i) .ne. i ) XDet = -XDet
	enddo
	end

************************************************************************
* Inverse computes the inverse of a matrix.
* Input:
*   A: n-by-n matrix A
*   n: dimension of A
* Output:
*   A: mangled LU decomposition of A
*   Ainv: inverse of A
*   perm: permutation vector

	subroutine XInverse(A, Ainv, n, perm)
	implicit none
	integer n, perm(*)
	QVAR A(n,*), Ainv(n,*)

	integer i, j

	call XLUDecomp(A, n, perm)
	do i = 1, n
	  do j = 1, n
	    Ainv(j,i) = 0
	  enddo
	  Ainv(i,i) = 1
	  call LUBackSubstD(A, n, perm, Ainv(1,i))
	enddo
	end

