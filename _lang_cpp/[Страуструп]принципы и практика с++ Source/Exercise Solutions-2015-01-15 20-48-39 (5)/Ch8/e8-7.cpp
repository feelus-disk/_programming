// Bjarne Stroustrup 7/25/2009
// Chapter 8 Exercise 7

#include "std_lib_facilities.h"	
// note that different compilers/SDEs keep header files in different places
// so that you may have to use "../std_lib_facilities.h" or "../../std_lib_facilities.h"
// the ../ notation means "look one directly/folder up from the current directory/folder"

/*
	Read 5 names into a vector<string>
	prompt the user for ages for the 5 names and store the ages in a vector<int>
	sort the names by name (e.g. "bill" before "joe")
	print out the (name,age) pairs.

	As stated, the tricky part is not to loose the corresponence between names and ages when you sort.

	We looked at reading and writing (name,value) pairs in 4-19 (and 6-4).

	We "steal" the reading and writing of pairs from 4-19, but make a couple of separate functions
	to make the code more readable and manageable.

	The solution presented here is simple, but unless you have struggled a bit with the problem
	you may not appreciate that. Please try! Most people first come up with something far more
	complicated (and therefore far harder to get right). Simplicity isn't always simple to achieve.
*/

vector<string> name;
vector<int> age;

void read_pairs()
{
	string n;
	int v;

	while (cin>>n>>v && n!="NoName") {	// read string int pair
		for (int i=0; i<name.size(); ++i)
			if (n==name[i]) error("duplicate: ",n); // chek for duplicate
		name.push_back(n);
		age.push_back(v);
	}
}

void write_pairs(string label)
{
	cout << label;
	for (int i=0; i<name.size(); ++i)
			cout << '(' << name[i] << ',' << age[i] << ")\n";
}

int find_index(const vector<string>& v,const string& n)
	// find n's index in v
{
	for (int i=0; i<n.size(); ++i)
			if (n==v[i]) return i;
	error("name not found: ",n);
}

int main()
try
{
	read_pairs();

	write_pairs("\nAs read:\n");

	vector<string> original_names = name;	// copy the names
	vector<int> original_ages = age;		// copy the ages

	sort(name.begin(),name.end());			// sort the names

	for(int i=0; i<name.size(); ++i)		// update ages
		age[i] = original_ages[find_index(original_names,name[i])];

	write_pairs("\nSorted:\n");

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
	Note how easy it is to copy a vector.

	The find_index() function demonstrates a useful technique, which we can use again and again until
	we get to data structures (maps, hash tables) where we can loop up a value based on a string
	directly (Chapter 21).
		
	Keeping related data, such as a name and an age in separate vectors can be a bit of a bother.
	Imagine if we could keep (name,age) in a single object (we can, see 6-4) and sort them (we
	can, but that's for much later (sorting and searching is described in some detail in Chapter 21).
*/
