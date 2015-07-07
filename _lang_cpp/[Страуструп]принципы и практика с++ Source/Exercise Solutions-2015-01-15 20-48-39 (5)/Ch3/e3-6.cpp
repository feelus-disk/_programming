// Bjarne Stroustrup 4/4/2009
// Chapter 3 Exercise 6

#include "std_lib_facilities.h"	
// note that different compilers/SDEs keep header files in different places
// so that you may have to use "../std_lib_facilities.h" or "../../std_lib_facilities.h"
// the ../ notation means "look one directly/folder up from the current directory/folder"

int main()
try
{
	int val1 = 0;
	int val2 = 0;
	int val3 = 0;
	cout << "Please enter three integer values separated by a space: ";
	cin >> val1 >> val2 >> val3;
	if (!cin) error("something went bad with the read");
	cout << "values read : " << val1 << ", " << val2 << ", " << val3 <<'\n';

	// idea for solution:
	//		just test which value is the smallest and put it into "smallest"
	//		then test which ofthe remaining two values is the smaller and put it into "middle"
	//		then but the remaining variable int "largest"
	int smallest = 0;
	int middle = 0;
	int largest = 0;
	if (val1<=val2 && val1<=val3) {	// && means and
		smallest = val1;
		if (val2<=val3) {
			middle = val2;
			largest = val3;
		}
		else {
			middle = val3;
			largest = val2;
		}
	}
	else if (val2<=val1 && val2<=val3) {
		smallest = val2;
		if (val1<=val3)  {
			middle = val1;
			largest = val3;
		}
		else {
			middle = val3;
			largest = val1;
		}
	}
	else {	// since neither val1 nor val2 was smaller than val3, val3 must be the smallest
		smallest = val3;
		if (val1<=val2) {
			middle = val1;
			largest = val2;
		}
		else {
			middle = val2;
			largest = val1;
		}
	}

	cout << "values sorted : " << smallest << ", " << middle << ", " << largest <<'\n';

	keep_window_open();	// For some Windows(tm) setups
}
catch (runtime_error e) {	// this code is to produceerror messages; it will be described in Chapter 5
	cout << e.what() << '\n';
	keep_window_open("~");	// For some Windows(tm) setups
}

/*
	I think this code is rather tedious. That is, it repeats similar code three times with different
	variable names. How do we know that it is correct?

	Is there a *simple* way of doing less work? (yes) Does doing less work make this code easier to understand?
	
	What would e have to do to do this exercise for four variables? for five?
	How many if-statements would you need for four variables? for five variables?
	Chapter 4 will give us the key tool for better solutions: vectors.
*/