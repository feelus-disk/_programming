// Bjarne Stroustrup 4/26/2009
// Chapter 8 Exercises 2-3

/*
	Exercise 2: write an output finction for vector<int>

	Exercise 3: make a vector<int> containing Fibbonacci numbers,
		e.g. 1, 2, 3, 5, 8, 13, 21, 34
		makes a good test case for exercise 2.

*/

#include "std_lib_facilities.h"	

/*
	What should a vector<int> look like when printed?
	That depends on many things, such as what we want to use the output for,
	how many elements there are, etc.

	There is an argument for simply printing the values one per line,
	but the exercise asks for the vector to be "labelled" by a name.

	Let's make some assumptions (we have to):
		(1) this print is to be used for a human to look at relatively small vectors
		(2) humans like numbers to be comma separated
	The output is a bit "elaborate", with { } to bracket the elements and the size
	(the number of elements) in parentheses.

	When I tried this, the lines got too long, so I arbitrarily decided to print a
	newline after every 8 integers.
*/

void print(vector<int>& v, const string& name)
	// print ints to cout
	// label the output with name
{
	cout << name << ": (" << v.size() << ") {";
	for (int i = 0; i<v.size(); ++i) {
		if (i%8==0) cout << "\n   ";	// to avoid long lines
		cout << v[i];
		if (i<v.size()-1) cout << ", ";	// messy; to avoid a trailing comma
	}
	cout << "\n}\n";
}

/*
	the fibonnaci() function is not hard to write,
	but I "forgot" to specify anything about checking.
	Feel free to try to crash it by giving it bad input (I do check for low values of n).
*/

void fibonacci(int x, int y, vector<int>& v, int n)
	// fill v with n elements of a fibonnaci series starting with x y
{
	// first deal with low values of n:
	if (n<1) return;
	if (1<=n) v.push_back(x);
	if (1<=2) v.push_back(y);

	// here comes the real generation of a series:
	for (int i=2; i<n; ++i) {	// why start at 2? because initially v[0]==x and v[1]==y
		int z = x+y;	// next element
		v.push_back(z);
		x = y;	// move the sequence on
		y = z;
	}
}


int main()
try
{
	vector<int> vtest;
	vtest.push_back(2);
	vtest.push_back(4);
	vtest.push_back(2);
	vtest.push_back(-1);
	print(vtest,"vtest");

	cout<< "please enter two integer values (to be used to start a Fibinacci series) and the number of elements of the series: ";
	int val1 = 0;
	int val2 = 0;
	int n;
	while (cin>>val1>>val2>>n) {	// read two integers
		vector<int> vf;
		fibonacci(val1,val2,vf,n);
		cout << "fibonnaci(" << val1 << "," << val2 << ") ";
		print(vf,"");
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
	as usual, I provided a bit of "biolerplate" to allow me several test runs in a single program.

	What's the largest number of elements of the usual fibonacci series (the one starting 1 2) that
	will fit into and int?
*/
