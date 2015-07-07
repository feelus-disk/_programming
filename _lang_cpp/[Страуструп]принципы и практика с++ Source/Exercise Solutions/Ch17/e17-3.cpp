// Bjarne Stroustrup 3/22/2009
// Chapter 17 Exercise 3

#include <iostream>
#include <string>
using namespace std;

/*
// solution #1, using subscripting:
void to_lower(char* p)
	// assume that lower and upper case characters have consecutive integer values
{
	for (int i = 0; p[i]; ++i) {
        if ('A'<=p[i] && p[i]<='Z') // is upper case (only characters are considered upper case - e.g. not !@#$)
            p[i] -= ('A'-'a');		// make lower case
	}
}
*/


/*
	it has been suggested that to avoid repeating p[i], we should introduce a variable to hold the currect character:

// solution #1.1, using subscripting and a local variable:
void to_lower(char* p)
	// assume that lower and upper case characters have consecutive integer values
{
	for (int i = 0; char c = p[i]; ++i) {
        if ('A'<=c && c<='Z')		// is upper case (only characters are considered upper case - e.g. not !@#$)
            p[i] -= ('A'-'a');		// make lower case
	}
}

Personally, I don't find this clearer.

It has been suggested that not repeating p[i] is "more efficient" but with modern optimizers
the code generated for solution #1 and solution #1.1 will be identical.

*/



// solution #2, using pointer dereferencing:
void to_lower(char* p)
	// assume that lower and upper case characters have consecutive integer values
{
	if (p==0) return;	// just in case some user tries to_lower(0)
	for (; *p; ++p) {			// p is already initialized, so we don't need and initializer part of the for-statement
        if ('A'<=*p && *p<='Z') // is upper case (only characters are considered upper case - e.g. not !@#$)
            *p -= ('A'-'a');	// make lower case
	}
}


void test(const string& ss)	// rely on visual inspection
{
	string s = ss;	// take a copy to avoid modifying original
	cout << s << '\n';
	char* p = &s[0];	// assume (correctly) that the characters are stored with a terminating 0
	to_lower(p);
	cout << p << '\n';
}

int main()
{
	test("Hello, World!");
    
	string s;	// read examples into std::string rather than C-style string
				// to avoid the possibility of overflow
	while (cin>>s && s!="quit")	// take examples from input, one word at a time, until "quit"
		test(s);
}
