// Bjarne Stroustrup 1/17/2010
// Chapter 11 Exercise 3

/*
	Write a program called multi_input.cpp that prompts the user to enter several integers in any
	combination of octal, decimal, or hexadecimal, using the 0 and 0x base suffixes; interprets
	the numbers correctly, and converts them to decimal form. Then your program should output the
	values in properly spaced columns like this:
		0x4	    hexadecimal	converts to 	67	decimal
		0123	octal		converts to 	83	decimal
		65	    decimal	    converts to 	65	decimal
*/

#include "std_lib_facilities.h"	


/*
	By "properly spaced columns" in the problem refinition, I intended to force the use of fields,
	as opposedto spaces and tabs. But look carefully: I accidentally right adjusted the placement
	of digits in a field. The default (and almost always the correct placement) is left adjusted
	placement. Nowhere in the book is it explained hot to right adjust!

	You are definitely excused if you just left the adjustment as the standard-library default,
	but just to show how, I used setf() to do the job (thesamefunction I used to mess with
	floating point formats on page 381). This is definitely the job for a more experience programmer
	looking at expert level documentation. Sorry.
*/

enum Base { octal, decimal, hexadecimal };

void write(Base b, int x)
{
	cout.setf(ios_base::left,ios_base::adjustfield);	// ouch!
	switch (b) {
	case octal:
		cout << oct << setw(12) << x << "octal       converts to ";
		break;
	case decimal:
		cout << dec << setw(12) << x << "decimal     converts to ";
		break;
	case hexadecimal:
		cout << hex << setw(12) << x << "hexadecimal converts to ";
		break;
	}     
	cout << dec << setw(12) << x << "decimal\n";
}

/*
	Looking at the requirements, I was annoyed that I didn't allow the solution
	just to let the iostream library do the conversions. That would be so simple!
	But it would not allow us to determinethe original format used.

	So, I did the exercise twice:
		First, the simple and incomplete way
		Second, the somewhat elaborate and complete way.


*/

int main()
try
{
	cout << "Please enter octal, decimal, and hexadecimal numbers\n(use 0 to indicate that you are finished): ";

	int x;
	cin.unsetf(ios::dec);	// see page 380
	cin.unsetf(ios::oct);
	cin.unsetf(ios::hex);
	cout << showbase;	// see page 378
	while (cin>>x && x!=0) {
		cout << hex << x <<'\t'
			<< oct << x <<'\t'
			<< dec << x <<'\n';
	}

	cout << "Please enter more octal, decimal, and hexadecimal numbers: ";
	char ch;
	while (cin.get(ch)) {
		if (ch=='0') {
			cin.get(ch);
			if (ch=='x' || ch=='X') {	// read hexadecimal
				cin>>hex>>x;
				write(hexadecimal,x);
			}
			else if (isdigit(ch)) {	// read octal
				cin.unget();	// put character back
				cin>>oct>>x;
				write(octal,x);
			}
			else {	// it was plain 0
					// 0 is an octal number (really!)
				cin.unget();	// put character back
				write(octal,0);
			}
		}
		else if (isdigit(ch)) {	// read decimal
			cin.unget();	// put character back
			cin>>dec>>x;
			write(decimal,x);
		}
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
	Formatting tends to be messy.

	In the code above, I did not worry about overflow. You can get messy output by entering numbers
	larger than the largest integer on your machine. On my machine, 0xffffffff gives an error.
*/
