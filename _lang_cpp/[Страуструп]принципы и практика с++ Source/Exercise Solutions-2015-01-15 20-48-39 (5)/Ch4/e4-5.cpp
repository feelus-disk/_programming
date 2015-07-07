// Bjarne Stroustrup 3/26/2009
// Chapter 4 Exercise 5

#include "std_lib_facilities.h"	
// note that different compilers/SDEs keep header files in different places
// so that you may have to use "../std_lib_facilities.h" or "../../std_lib_facilities.h"
// the ../ notation means "look one directly/folder up from the current directory/folder"

// Correction/errata: % is not defined for floating-point numbers, so we don't implement %
// the alternative would be to use integers for the input values.

// How do you exit?

int main()
try
{
	cout<< "please enter two floating-point values separated by an operator\n The operator can be + - * or / : ";
	double val1 = 0;
	double val2 = 0;
	char op = 0;
	while (cin>>val1>>op>>val2) {	// read number operation number
		string oper;
		double result;
		switch (op) {
		case '+':
			oper = "sum of ";
			result = val1+val2; 
			break;
		case '-':
			oper = "difference between ";
			result = val1-val2; 
			break;
		case '*':
			oper = "product of ";
			result = val1*val2; 
			break;
		case '/':
			oper = "ratio of";
			if (val2==0) error("trying to divide by zero");
			result = val1/val2; 
			break;
		//case '%':
		//	oper = "remainder of ";
		//	result = val1%val2; 
		//	break;
		default:
				error("bad operator");
		}
		cout << oper << val1 << " and " << val2 << " is " << result << '\n';
		cout << "Try again: ";
	}
}
catch (runtime_error e) {	// this code is to produce error messages; it will be described in Chapter 5
	cout << e.what() << '\n';
	keep_window_open("~");	// For some Windows(tm) setups
}
catch (...) {	// this code is to produce error messages; it will be described in Chapter 5
	cout << "exiting\n";
	keep_window_open("~");	// For some Windows(tm) setups
}