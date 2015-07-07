// Bjarne Stroustrup 1/17/2010
// Chapter 11 Exercise 9

/*
	Write a function vector<string> split(const string& s) that returns a vector of whitespace-separated
	substrings from the argument s.
*/

#include "std_lib_facilities.h"	


/*
	Here, first, is the obvious split():
*/

vector<string> split(const string& s)
	// return a vector of copies of words in s
{
		istringstream is(s);
		vector<string> vs;
		string buf;
		while (is>>buf)
			vs.push_back(buf);
		return vs;
}

/*

	This split() is easy to implement and trivial to use (see the test below),
	but we do copy strings a lot and we get back *copies* of the words.

	An alternative design returns a vecor of indices into the string:
*/

vector<int> spliti(const string& s)
	// return a vector of indices of words in s
{
	vector<int> res;
	bool in_word = false;
	for (int i = 0; i<s.size(); ++i) {
		if (isspace(s[i]))
			in_word = false;
		else {
			if (!in_word)	// first character in word
				res.push_back(i);
			in_word = true;
		}
	}
	return res;
}

/*
	This is a bit messier: The implementation is basically a state maching keeping
	track of whether we are in a word or not.

	The idea of this spliti() is for a user to access the words of the string
	starting at each index. Since those words are still whitespace separated,
	we need to look for whitespace when we use it (see test below).
*/

void print_word1(const string& s, int i)
	// print whitespace terminated word
	// the last word in the string is *not* whitespace terminated; we stop at the end of string
{
	for (; i<s.size() && !isspace(s[i]); ++i)
		cout << s[i];
	cout << ' ';
}


int main()
try
{
	cout << "Please enter a line:\n";

	string line;
	while (getline(cin,line)) {
		cout << "line:\n" << line <<'\n';

		vector<string> ln1 = split(line);
		cout << "words in line:\n";
		for (int i=0; i<ln1.size(); ++i)
			cout << ln1[i] << ' ';
		cout << '\n';

		vector<int> ln2 = spliti(line);
		cout << "words in line:\n";
		for (int i=0; i<ln2.size(); ++i)
			print_word1(line,ln2[i]);
		cout << '\n';
			
		cout << "Please enter another line:\n";
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
	People look at split() and spliti() and think: are they efficient?
	split() is very simple and easily efficient enough for splitting the odd line in a program
	(e.g. breaking up a command line or splitting a few thousand lines into fields).

	If you need to process tens or thousands of lines, or millions of lines, or have hard
	real-time deadlines, you start thinking about spliti().

	If that's not fast enough, you start thinking about not passing a vector by copying it
	and about modifying the string as you read it (e.g. inserting specific end-of-word markers into
	the original string rather than whitespace (rember to get the last word properly terminated).
	
	However, it is hard to imagine a student project for which split() or spliti() wouldn't
	be sufficiently efficient on a "normal laptop."
	
	Don't ignore the simplest solutions in search for "efficiency" untill you know (from measurements;
	don't just guess) that you need it. Your time is valuable compared to that of your laptop.
	The simple solutions lead to fewer bugs - and therefore to less time spent debugging
	(I still hate debugging).
*/
