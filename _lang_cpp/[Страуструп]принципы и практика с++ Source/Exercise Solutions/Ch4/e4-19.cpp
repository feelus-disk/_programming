// Bjarne Stroustrup 7/25/2009
// Chapter 4 Exercise 19

#include "std_lib_facilities.h"	
// note that different compilers/SDEs keep header files in different places
// so that you may have to use "../std_lib_facilities.h" or "../../std_lib_facilities.h"
// the ../ notation means "look one directly/folder up from the current directory/folder"

/*
	enter name-and-value pairs into a pair of vectors
	check that each name is unique
	exit when we see the input "NoName 0"
	output the pairs
*/



int main()
try
{
	vector<string> names;
	vector<int> scores;

	string n;
	int v;

	while (cin>>n>>v && n!="NoName") {	// read string int pair
		for (int i=0; i<names.size(); ++i)
			if (n==names[i]) error("duplicate: ",n); // chek for duplicate
		names.push_back(n);
		scores.push_back(v);
	}

	for (int i=0; i<names.size(); ++i)
			cout << '(' << names[i] << ',' << scores[i] << ")\n";

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
	(name,value) pairs are useful in many contexts. This is just the first and simplest variant.
	Exercise 6.4 is another variant.

	Note how we could read a (name,value) pair and used a specific name to indicated the end of input.
	There is a second (undocumented) way of terminating the input. Try leaving out an integer; for example,
		frank 3 joe bill 7
	You may consider that a bug or a feature. If you consider it a bug, you'll find it a bit hard to detect
	it reliably.

	Checking for duplicates is another common activity, and easy.
*/
