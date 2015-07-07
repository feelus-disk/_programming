// Bjarne Stroustrup 7/25/2009
// Chapter 8 Exercise 5

#include "std_lib_facilities.h"	


/*
	write two reverse functions that reverses the order of elements in a vector.
	For example
		1 2 3 4 5
	becomes
		5 4 3 2 1
*/

void print(const string& label, const vector<int>& v)
	// print vector to cout
{
	cout << label << "( ";
	for (int i = 0; i<v.size(); ++i) cout << v[i] << ' ';
	cout << ")\n";
}

void reverse1(vector<int>& v)
	// reverse by putting elements into a new vector in reverse order
{
	vector<int> v2;
	for (int i = v.size()-1; 0<=i; --i)	// copy "backwards"
			v2.push_back(v[i]);	
	v = v2;
}

void reverse2(vector<int>& v)
	// reverse by swapping "corresponding" elements
{
	for(int i = 0; i<v.size()/2; ++i)
		swap(v[i],v[v.size()-1-i]);	// first swaps with last, etc.
}


int main()
try
{
	vector<int> val;

	cout << "Please enter a sequence of integers ending with any non-digit character: ";
	int i;
	while (cin>>i) val.push_back(i);
	print("\nInput:\n",val);
	reverse1(val);
	print("\nReversed once:\n",val);
	reverse2(val);
	print("\nReversed again:\n",val);


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
	I used the standard library swap(); you could have written your own; that's easy (8.5.5),
	but since there is a standard library version why bother?

	How do we test this? For anything to do with a sequence of values, we try with 0, 1, and 2 elements.
	Then we try with "a lot of elements" (but in this code there are no fixed-sized buffers to overflow
	so that's boring. In reverse2(), we look for the middle (the midpoint) of a sequence; whenever we do
	that it's good to test with both even and odd number of elements.

	Note how reversing twice gives us the original. That's a nice visual test of correctness.

	Yes, there is also a standard library function for reversing sequences, but we'll save that for
	Chapter 21.

	I chose to copy in place. maybe I should have defined reverse1() and reverse2() not to modify their
	inputs and return a value:
		vector<int> reverse3(const vector<int>&);	// return reversed vector
	Try!
	Which variant do you prefer? Why?
*/
