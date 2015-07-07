// Bjarne Stroustrup 4/11/2009
// Chapter 6 Exercise 10

/*
	calculate number of permutations
*/

#include "std_lib_facilities.h"	
// note that different compilers/SDEs keep header files in different places
// so that you may have to use "../std_lib_facilities.h" or "../../std_lib_facilities.h"
// the ../ notation means "look one directly/folder up from the current directory/folder"

/*
	The computation is straightforward: just write a simple function for each formula.
	If the formula are correct (how would you know?) all should be simple.
	Did you notice that the correct formula for combinations is C(a,b) = P(a,b)/fac(b)
	rather than the C(a,b) = P(a-b)/fac(b) claimed in the 1st printing of the book.

	That leaves getting input and checking that the inputs make sense (e.g. that the number
	of elements in a set is larger then the size of the subset).
	
	The exercise doesn't ask for "both combinations and permutations" but I think that's more
	interesting that either on its own, so I added that option.
*/

int factorial(int n)
	// return n*(n-1)*(n-2)* ... *2
	// return 1 if n<1
{
	int fac = 1;
	while (1<n) {
		fac *= n;
		--n;
		if (fac<1) error("factorial overflow");
	}
	return fac;
}

int n_permutations(int a, int b)
{
	if (a<b || a<1 || b<1) error("bad permutation sizes");
	return factorial(a)/factorial(a-b);
}

int n_combinations(int a, int b)
{
	return n_permutations(a,b)/factorial(b);
}

int main()
try
{
	cout << "I can calculate the number of combinations and permutations for sets of numbers\n";
	cout << "Please enter two numbers (separated by whitespace)\n";
	cout << "first the number of elements in the set and then the number of elements in a subset thereof: ";
	int a, b;
	if (!(cin>>a>>b)) error("that wasn't two integers");

	cout << "enter 'c' to get the number of combinations,\n'p' to get the number of permutations,\nor 'b' to get both: ";
	bool perm = false;
	bool comb = false;
	string s;
	cin >> s;
	if (s=="p")
		perm = true;
	else if (s=="c")
		comb = true;
	else if (s=="b") {
		perm = true;
		comb = true;
	}
	else
		error("bad input instruction");

	if (perm) cout << "P(" << a << ',' << b << ") = " << n_permutations(a,b) << '\n';
	if (comb) cout << "C(" << a << ',' << b << ") = " << n_combinations(a,b) << '\n';

	keep_window_open("~");	// For some Windows(tm) setups
}
catch (runtime_error e) {	// this code is to produceerror messages; it will be described in Chapter 5
	cout << e.what() << '\n';
	keep_window_open("~");	// For some Windows(tm) setups
}

/*
	Note that we divide with the result of factorial() so we have to be sure that factorial() doesn't
	return zero. Furthermore, factorials can get very large - too large to fit into an int - so we
	check for that.

	We also check the input to n_permutations: you can't have negative numbers of elements or more
	elements in a subset than there are in its set.

	Possible follow-up:
		(1) add a loop so that a user can more numbers after a successful calculation
		(2) what's the lagest number that we can use correctly as an argument to factorial?
			(factorials get large awfully fast)
*/
