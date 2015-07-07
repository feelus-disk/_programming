// Bjarne Stroustrup 7/20/2009
// Chapter 4 Exercise 11

#include "std_lib_facilities.h"	
// note that different compilers/SDEs keep header files in different places
// so that you may have to use "../std_lib_facilities.h" or "../../std_lib_facilities.h"
// the ../ notation means "look one directly/folder up from the current directory/folder"

/*
	Compute prime numbers: 2 3 5 7 11 ...

	In case you forgot, a prime is a positive integer that can be divided only by 1 and by itself.
	For this exercise, we decided to consider 2 the first prime (ignoring 1).

	Our general strategy (our algorithm) is to see if a number can be divided by a prime smaller
	than itself and if not it is itself a prime and we add it to our vector of primes.

	I didn't bother with a separate vector of primes to compare with. Instead, I simply checked
	that the primes computed were the correct.
*/


vector<int> prime;

bool is_prime(int n)
{
	for (int p = 0; p<prime.size(); ++p)
		if (n%prime[p]==0) return false;	// no remainder: prime[p] divided
	return true;	// no smaller prime could divide
}
int main()
try
{
	prime.push_back(2);	// consider the smallest prime

	for (int i = 3; i<=100; ++i)	// test all integers [3:100]
		if (is_prime(i)) prime.push_back(i);	// add new prime to vector

	cout << "Primes: ";
	for (int p = 0; p<prime.size(); ++p)
		cout << prime[p] << '\n';

	keep_window_open("~");	// For some Windows(tm) setups
}
catch (runtime_error e) {	// this code is to produce error messages; it will be described in Chapter 5
	cout << e.what() << '\n';
	keep_window_open("~");	// For some Windows(tm) setups
}
catch (...) {	// this code is to produce error messages; it will be described in Chapter 5
	cout << "exiting\n";
	keep_window_open("~");	// For some Windows(tm) setups
}

/*
	Look at the algorithm. Can you see a way of checking against fewer primes?
*/
