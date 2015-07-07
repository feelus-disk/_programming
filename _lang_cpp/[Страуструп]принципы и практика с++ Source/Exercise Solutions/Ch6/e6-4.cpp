// Bjarne Stroustrup 7/25/2009
// Chapter 6 Exercise 4

#include "std_lib_facilities.h"	
// note that different compilers/SDEs keep header files in different places
// so that you may have to use "../std_lib_facilities.h" or "../../std_lib_facilities.h"
// the ../ notation means "look one directly/folder up from the current directory/folder"

/*
	enter name-and-value pairs into a vector<Name_value>
	check that each name is unique
	exit when we see the input "NoName 0"
	output the pairs
*/

class Name_value {	// much like Token from 6.3.3
public:
	Name_value(string n, int s): name(n), score(s) { }
	string name;
	int score;
};

int main()
try
{
	vector<Name_value> pairs;

	string n;
	int v;

	while (cin>>n>>v && n!="NoName") {	// read string int pair
		for (int i=0; i<pairs.size(); ++i)
			if (n==pairs[i].name) error("duplicate: ",n); // chek for duplicate
		pairs.push_back(Name_value(n,v));
	}

	for (int i=0; i<pairs.size(); ++i)
			cout << '(' << pairs[i].name << ',' << pairs[i].score << ")\n";

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
	This exercise is simply 4-19 done with a vector of pairs rather than a pair of vectors.

	I wrote this by a simple cut and paste of the solution to 4-19 and it worked (not too
	surprisingly) first time. It is often a great time saver to have a program that already
	has been written and tested on whichto build a new on.

	One the onther hand: If there were bugs in 4-19, they are also here.

	Do you prefer this solution or the one from 4-19? If you have a preference, why?
*/
