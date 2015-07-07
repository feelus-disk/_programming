// Bjarne Stroustrup 4/11/2009
// Chapter 6 Exercise 6

/*
	English grammar
*/

#include "std_lib_facilities.h"	
// note that different compilers/SDEs keep header files in different places
// so that you may have to use "../std_lib_facilities.h" or "../../std_lib_facilities.h"
// the ../ notation means "look one directly/folder up from the current directory/folder"

/*
	I started writing the sentence() function and then invented the classification functions
	is_noun(), etc., then I introduced the vectors of words to represent the classifications.

	Those word classification vectors makes it trivial to enlarge the vocabulary.

	The exercise didn't ask us to handle multiple statements, but why not?
*/

// vectors of words, appropriately classified:
vector<string> nouns;
vector<string> verbs;
vector<string> conjunctions;

void init()
// initialize word classes
{
	nouns.push_back("birds");
	nouns.push_back("fish");
	nouns.push_back("C++");	// I didn't suggest addin "C+" to this exercise
							// but it seems some people like that

	verbs.push_back("rules");
	verbs.push_back("fly");
	verbs.push_back("swim");

	conjunctions.push_back("and");
	conjunctions.push_back("or");
	conjunctions.push_back("but");
}

bool is_noun(string w)
{
		for(int i = 0; i<nouns.size(); ++i)
			if (w==nouns[i]) return true;
		return false;
}

bool is_verb(string w)
{
		for(int i = 0; i<verbs.size(); ++i)
			if (w==verbs[i]) return true;
		return false;
}

bool is_conjunction(string w)
{
		for(int i = 0; i<conjunctions.size(); ++i)
			if (w==conjunctions[i]) return true;
		return false;
}

bool sentence()
{
	string w;
	cin >> w;
	if (!is_noun(w)) return false;

	string w2;
	cin >> w2;
	if (!is_verb(w2)) return false;

	string w3;
	cin >> w3;
	if (w3 == ".") return true;	// end of sentence
	if (!is_conjunction(w3)) return false;	// not end of sentence and not conjunction
	return sentence();	// look for another sentence
}

int main()
try
{
	cout << "enter a sentence of the simplified grammar (terminated by a dot):\n";

	init();	// initialize word tables

	while (cin) {
			bool b = sentence();
			if (b)
				cout << "OK\n";
			else
				cout << "not OK\n";
			cout << "Try again: ";
	}

	keep_window_open("~");	// For some Windows(tm) setups
}
catch (runtime_error e) {	// this code is to produceerror messages; it will be described in Chapter 5
	cout << e.what() << '\n';
	keep_window_open("~");	// For some Windows(tm) setups
}

/*
	This is fairly simple, but not very polished. For example, how do you exit gracefully?
	I suggest adding a way ofgetting out, e.g. if a sentence ends with a '!' rather than with a '.', exit.
	Or maybe the work "quit" as the start of a sentence should cause an exit.
	Also, just saying "OK" or "not OK" is not very informative; maybe we could tell the user something
	about the sentence structure. On simple way of doing that would be for each sentence() call to
	push a string containing w+w2 onto a sentences vector and w3 onto a conjs vector, so that we could output 
	"( birds fly ) but (fish swim)" for the input "birds fly but fish swim ."
*/
