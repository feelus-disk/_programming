// Bjarne Stroustrup 7/23/2009
// Chapter 5 Exercise 8

/*
	sum part of a sequence.

	Note errata to 1st printing requesting N before the sequence; that makes the exercise much simpler.

	Write a program that reads and stores a series of integers
	and then computes the sum of the first N integers.
	First ask for N, then read the values into a <b>vector<int></b>,
	then calculate the sum of the first N values. For example:

		Please enter the number of values you want to sum, starting with the first:
			<b>3</b>
		Please enter some integers (press '|' to stop):
			<b>12 23 13 24 15 |</b> 
		The sum of the first <b>3</b> numbers (<b> 12 23 13 </b>) is <b>48</b>

	I stop reading after anything that's not an integer (not just a | character).
	That's the natural and simple solution. Checking specifically for '|' would be unnecessary work
	(but the prompt has to make some suggestion to the user)

*/

#include "std_lib_facilities.h"	


/*
	An example input would be
		2
		1 2 3 4 |
	and an example of corresponding output
		the sum of the first 2 numbers (1 2) is 3
*/


int main()
try
{
	cout << "Please enter the number of values you want to sum, starting with the first: ";
	int n = -1;	// initializing to a negative number means that a failed read will be handled by the check of the value
	cin >> n;
	if (n<1) error("the number of elements must be a positive integer");

	cout << "Please enter some integers (press '|' to stop): ";
	vector<int> v;
	int x;
	while (cin>>x) v.push_back(x);	// read until we find something that's not an integer

	if (v.size()<n) error("too few numbers; we need ", n);
	int sum = 0;
	for (int i=0; i<n; ++i) sum += v[i];

	cout << "The sum of the first " << n << " numbers ( ";
	for (int i = 0; i<n; ++i) cout << v[i] << ' ';
	cout << ") is " << sum << '\n';

	keep_window_open("~");	// For some Windows(tm) setups
}
catch (runtime_error e) {	// this code is to produce error messages
	cout << e.what() << '\n';
	keep_window_open("~");	// For some Windows(tm) setups
}

/*
	A more realistic example would be to read the sequence from a file.
	Chapter 10 will show how and also explain about how to handle a variety
	of input errors.
*/
