// Bjarne Stroustrup 1/17/2010
// Chapter 11 Exercise 12

/*
	Reverse the order of words (defined as whitespace separated strings) in a file.
	For example, Norwegian Blue parrot becomes parrot Blue Norwegian.
	You are allowed to assume that all the strings from the file will fit into memory at once.
*/

#include "std_lib_facilities.h"	


/*
	Did I mean "make a new file containing the words from the original file in reverse order"
	or "replace the words in a file with the words in the reverse order"?

	Here I will assume the former because it's easier and I hate overwriting information until
	I know that my new version is correct and complete.

	Did I mean "preserve the whitespace between the words (e.g. what do we do about empty lines)?
	I don't even know what "preserve the whitespace" wouldexactly mean, so I'll just replace
	whitespace with newlines.

	Requirements are never (well, hardly ever) complete and unambiguous. Always the first task
	of a real-world problem is: What would the user really want? Hopefully, a user is there to
	give answers so that we don't have to guess. If in doubt, choose the simplest solution.
*/


int main()
try
{
	cout << "Please enter a file name: ";
	string iname;
	cin>>iname;
	ifstream ifs(iname.c_str());
	if (!ifs) error("couldn't open ",iname);

	string oname = "rev-"+iname;
	ofstream ofs(oname.c_str());
	if (!ofs) error("couldn't open ",oname);

	vector<string> words;
	string w;
	while (ifs>>w) words.push_back(w);

	for (int i=words.size()-1; 0<=i; --i)	// write in reverse order
		ofs << words[i] << '\n';
}
catch (runtime_error& e) {	// this code is to produce error messages; it will be described in Chapter 5
	cout << e.what() << '\n';
	keep_window_open("~");	// For some Windows(tm) setups
}
catch (...) {	// this code is to produce error messages; it will be described in Chapter 5
	cout << "exiting\n";
	keep_window_open("~");	// For some Windows(tm) setups
}

/*
	So I just read the words into memory and wrote them out backwards.
	That was so easy that it felt like cheating :-) But it isn't: simple is good.

	The doubtful design decision was to build the name of the output file into the program: "rev-"+iname.
	Usually, I don't recommend that, but I wanted to show how it can be done.

	Now, if we couldn't fit the whole file into memory, this problem would be more difficult.
*/
