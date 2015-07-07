// Bjarne Stroustrup 1/15/2010
// Chapter 6 Exercise 9

/*
	Compose integers out of characters:
	123 is 1 hundered 2 tens and 3 ones

*/

#include "std_lib_facilities.h"	


int main()
try
{
	vector<int> digit;		// collect digits here
	vector<string> unit;	// unit names go here
	unit.push_back(" ones ");
	unit.push_back(" tens ");
	unit.push_back(" hundreds ");;
	unit.push_back(" thousands ");
	unit.push_back(" tens of thousands ");
	unit.push_back(" hundreds of thousands ");
	unit.push_back(" millions ");
	unit.push_back(" tens of millions ");
	unit.push_back(" hundreds of millions ");

	/*
		note that the size of the unit vector is used to determine how many digits
		we can handle. Not magic constant has been introduced.
	*/

	/*
		The exercise didn't specify how to terminate a number, so we have to decide.
	*/
	cout << "Please enter an integer with no more than " << unit.size()
		<< "\ndigits followed by semicolon and a newline: ";
	char ch;
	while (cin>>ch) {					// remember cin>>ch skips whitespace (this could be simpler written using cin.get(ch) )
		if (ch<'0' || '9'<ch) break;	// actually: any non-digit acts as a terminator
		digit.push_back(ch-'0');
	}

	if (digit.size()==0) error("no digits");
	if (unit.size()<digit.size()) error("Sorry, cannot handle that many digits");

	// write out the number:
	for (int i =0; i<digit.size(); ++i)
		cout << char('0'+digit[i]);
	cout << '\n';

	// write the digits with their units
	// also compute the integer value:
	int num = 0;
	for (int i = 0; i<digit.size(); ++i) {
		if (digit[i])	// don't mention a unit if its count is zero
			cout << digit[i] << unit[digit.size()-i-1];
		num = num*10+digit[i];
	}
	cout << "\nthat is " << num << '\n';

	keep_window_open("~");	// For some Windows(tm) setups
}
catch (runtime_error e) {	// this code is to produce error messages
	cout << e.what() << '\n';
	keep_window_open("~");	// For some Windows(tm) setups
}

/*
	Ideas for further elaboration:

	Try to get the plurals right: Not "2 hundreds 1 tens 1 ones" but "2 hundreds 1 ten 1 one".

	Try to get the colloquial "and" in there where it makes sense, e.g., "2 hundreds 1 ten and 1 one"
	That's a messy problem for which I cannot imagine a really clean solution.

	Instead of writing digits, write their written form: Not "2 hundreds 1 ten and 1 one" but
	"two hundreds one ten and one one".

	Suppress "one" (1): Not "two hundreds one ten and one one" but "two hundreds ten and one".

	Replace numbers with their conventional versions: Not "ten and two" but "twelve".

	Because of the use of tables, it should be relatively easy to make a version of this program
	that uses a language different from English (as long as that language's spoken integers is
	similar to that of English).
*/
