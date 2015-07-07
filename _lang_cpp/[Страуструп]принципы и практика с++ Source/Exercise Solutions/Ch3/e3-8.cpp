// Bjarne Stroustrup 7/20/2009
// Chapter 3 Exercise 8

#include "std_lib_facilities.h"	
// note that different compilers/SDEs keep header files in different places
// so that you may have to use "../std_lib_facilities.h" or "../../std_lib_facilities.h"
// the ../ notation means "look one directly/folder up from the current directory/folder"

int main()
try
{
	int val = 0;
	cout << "Please enter an integer: ";
	cin >> val;;
	if (!cin) error("something went bad with the read");
	string res = "even";
	if (val%2) res = "odd";	// a number is even if it is 0 modulo 2 and odd otherwise

	cout << "The value " << val << " is an " << res << " number\n";

	keep_window_open();	// For some Windows(tm) setups
}
catch (runtime_error e) {	// this code is to produceerror messages; it will be described in Chapter 5
	cout << e.what() << '\n';
	keep_window_open("~");	// For some Windows(tm) setups
}

/*
	Note the technique of picking a default value for the result ("even") and changing it only if needed.
	The alternative would be to use a conditional expression and write
		string res = (val%2) ? "even" : "odd";

	Did I get it right? Does it work for negative numbers? For 0?

	It would be less tedious to check the program if it had a loop so that we could read and check
	several numbers in one run.
*/