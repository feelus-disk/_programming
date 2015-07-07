// Bjarne Stroustrup 7/25/2009
// Chapter 9 Exercise 10

/*
	implement leapyear()

*/

#include "std_lib_facilities.h"	

/*
	The definition of leapyear is: any year divisible by 4 except centenary years not divisible by 400

	That's easy to implement, but how do you test it?
*/

bool leapyear(int y)
	// any year divisible by 4 except centenary years not divisible by 400
	// % is the modulo (remainder) operator
{
	if (y%4) return false;
	if (y%100==0 && y%400) return false;
	return true;
}

int main()
try
{
	vector<int> year;	// for a bit of automatic testing
	year.push_back(0);
	year.push_back(2000);
	year.push_back(1900);
	year.push_back(2009);
	year.push_back(2400);
	year.push_back(1968);
	year.push_back(1950);
	year.push_back(2010);
	year.push_back(2012);
	year.push_back(2020);
	year.push_back(1968);

	for (int i = 0; i<year.size(); ++i) {
		cout << year[i] << " is ";
		if (leapyear(year[i])==false) cout << "not ";
		cout << "a leapyear\n";
	}
	
	// now let the user try:
	cout<< "please enter a year: ";

	int n;
	while (cin>>n) {	// read a year
		cout << n << " is ";
		if (leapyear(n)==false) cout << "not ";
		cout << "a leapyear\n";
		cout << "Try again: ";
	}
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
	I decided to leave negative numbers as B.C. eventhough leapyears (as far as I know) were either not
	used or used a different rule.

	Any character that is not - or a (base 10) digit terminates the input loop.
*/

