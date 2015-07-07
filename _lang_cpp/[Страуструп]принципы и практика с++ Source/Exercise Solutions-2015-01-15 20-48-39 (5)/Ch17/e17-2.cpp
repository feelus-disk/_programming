// Bjarne Stroustrup 3/25/2009
// Chapter 17 Exercise 2

#include <iostream>
using namespace std;

/*
	The trick/technique is to get two consecutive objects of the type we are interested in,
	take a pointer to each,
	turn those pointers into char*s (that is byte addresses)
	and subtract the resulting addresses.

	Graphically:

		|		  |
		v         v
		-------------------
		|        |        |
		-------------------
*/

int size(int)	// I use the type of the argument, but not its value, so I don't bother naming the argument
{
	int* p = new int[2];
	int s = reinterpret_cast<char*>(&p[1])-reinterpret_cast<char*>(&p[0]);
	delete[] p;
	return s;
}

/*
	Note that plain &p[1]-&p[0] is 0. Subtracting pointers to elements of an array
	gives the number of elements between the two pointers.
*/

int size(double)	
{
	double* p = new double[2];
	int s = reinterpret_cast<char*>(&p[1])-reinterpret_cast<char*>(&p[0]);
	delete[] p;
	return s;
}

int size(bool)	
{
	bool* p = new bool[2];
	int s = reinterpret_cast<char*>(&p[1])-reinterpret_cast<char*>(&p[0]);
	delete[] p;
	return s;
}

/*
	This techniqu works fo all types, so let's try with a couple of more types:
*/

struct X { int a, b, c; };

int size(X)	
{
	X* p = new X[2];
	int s = reinterpret_cast<char*>(&p[1])-reinterpret_cast<char*>(&p[0]);
	delete[] p;
	return s;
}


struct V {
		int a, b, c;
		virtual void f() {}
};

int size(V)	
{
	V* p = new V[2];
	int s = reinterpret_cast<char*>(&p[1])-reinterpret_cast<char*>(&p[0]);
	delete[] p;
	return s;
}

int main()
{
	cout << "size of int: " << size(1) << '\n';
	cout << "size of double: " << size(1.0) << '\n';
	cout << "size of bool: " << size(true) << '\n';
	cout << "size of X: " << size(X()) << '\n';
	cout << "size of V: " << size(V()) << '\n';
	char c; cin>>c;
}

/*

	You may find the code of the size() functions a bit repetetive.
	In Chapter 19, we will show how to make a function (a function template) work for all types:


template<class T> int size(T)	// for every type T
{
	T* p = new T[2];
	int s = reinterpret_cast<char*>(&p[1])-reinterpret_cast<char*>(&p[0]);
	delete[] p;
	return s;
}

	You may still find it odd that we use free store (new and delete) for something this simple.
	In Chapter 18, we will show how to allocate arrays on the stack so that we can simplify further:


template<class T> int size(T x)	// for every type T
{
	T p[2];
	return reinterpret_cast<char*>(&p[1])-reinterpret_cast<char*>(&p[0]);
}

	And of couse in real code, we would just use sizeof(int), sizeof(double), etc.,
	but that would teach us nothing about pointers and addresses.
*/
