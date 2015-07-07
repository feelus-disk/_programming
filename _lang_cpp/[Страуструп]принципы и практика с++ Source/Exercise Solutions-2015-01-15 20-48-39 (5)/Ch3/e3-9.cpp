// Bjarne Stroustrup 7/20/2009
// Chapter 3 Exercise 9

#include "std_lib_facilities.h"	
// note that different compilers/SDEs keep header files in different places
// so that you may have to use "../std_lib_facilities.h" or "../../std_lib_facilities.h"
// the ../ notation means "look one directly/folder up from the current directory/folder"



int main()
try
{
	cout << "Please enter an integer as a text string: ";
	string s;
	while (cin>>s) {
		if (s =="zero")
				cout << s << " has the value 0\n";
		else if (s =="one")
				cout << s << " has the value 1\n";
		else if (s =="two")
				cout << s << " has the value 2\n";
		else if (s =="three")
				cout << s << " has the value 3\n";
		else if (s =="four")
				cout << s << " has the value 4\n";
		else
				cout << s << " does not have a numeric value I understand\n";
		cout << "Please enter another integer as a text string: ";
	}

	keep_window_open();	// For some Windows(tm) setups
}
catch (runtime_error e) {	// this code is to produce error messages; it will be described in Chapter 5
	cout << e.what() << '\n';
	keep_window_open("~");	// For some Windows(tm) setups
}

/*
	To make it less tedious to test I made a loop testing strings. I "forgot" to provide a way to exit
	that loop so you must either kill the program or enter an end-of-input (cntrl-Z for Windows or cntrl-D
	for Unix). Maybe you could modify the program to end if it sees "Quit"?

	All of those ifs can get tedious (and anything tedious is error prone), but for now we don't have
	the tools to do better. later (e.g. Chapter 4), we'll see how this code can be simplified by using
	a for-loop and a vector of strings.
*/