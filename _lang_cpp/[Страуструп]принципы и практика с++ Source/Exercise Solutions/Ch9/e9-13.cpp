// Bjarne Stroustrup 7/25/2009
// Chapter 9 Exercise 13

/*
	Design and implement a rational number class with the usual arithmetic operations, etc.

*/

#include "std_lib_facilities.h"	

/*
	A rational number is represented by a numerator and a denominator. Its value is numerator/denominator.

	You may want to loop up the definition of rational aithmetic in a book (or on the web). For what we need
	here, the math is (easy) high school level.

	Design decisions:
		1. allow direct access to the representation (num,den)
		2. try to keep rational numbers "normalized", that is with the smallest possible denominator
		   (e.g. 5/3 rather than 15/9); that requires a gcd (greatest common denominator) function.
		3. don't try to make the code very fast; "simple and not too inefficient" is the ideal (to keep the code simple)
		4. I won't check for overflow (to keep the code simple)
*/

int gcd(int x, int y)
	// greatest common denominator
	// Euclid's algorithm (using remainder)
{
	x = abs(x);	// don't get confused by negative values
	y = abs(y);
	while (y) {
		int t = y;
		y = x%y;
		x = t;
	}
	return x;
}

//--- the class ----------------------------------------------------------------

class Rational {
public:
	Rational(int n, int d) :num(n), den(d) { normalize(); } 
	// Rational(int n) :num(n), den(1) { }	// deleted because I kept writing things like Rational(24/8)
	Rational() :num(0), den(1) { }

	void normalize()	// keep denominator positive and minimal
	{
		if (den==0) error("negative denominator");
		if (den<0) { den = -den; num = -num; }
		int n = gcd(num,den);
		if (n>1) { num/=n; den/=n; }
	}

	int num, den;
};

//--- utilities ----------------------------------------------------------------

ostream& operator<<(ostream& os, Rational x)
{
	return cout << '(' << x.num << '/' << x.den << ')';
}

bool operator==(Rational x1, Rational x2)
{
	return x1.num*x2.den==x1.den*x2.num;
}

bool operator!=(Rational x1, Rational x2)
{
	return !(x1==x2);
}

double to_double(Rational x)	// convert to double (to floating point representation)
{
	return double(x.num)/x.den;
}

//----- arithmetic operations --------------------------------------------------------

Rational operator+(Rational x1, Rational x2)
{
	Rational r(x1.num*x2.den+x1.den*x2.num, x1.den*x2.den);
	r.normalize();
	return r;
}

Rational operator-(Rational x1, Rational x2)
{
	Rational r(x1.num*x2.den-x1.den*x2.num, x1.den*x2.den);
	r.normalize();
	return r;
}

Rational operator-(Rational x)	// unary minus
{
	return Rational(-x.num,x.den);
}

Rational operator*(Rational x1, Rational x2)
{
	Rational r(x1.num*x2.num,x1.den*x2.den);
	r.normalize();
	return r;
}

Rational operator/(Rational x1, Rational x2)
{
	Rational r(x1.num*x2.den,x1.den*x2.num);
	r.normalize();
	return r;
}



/*
	How do we test all that?

	The simplest is to compute a number of values using Rational and double and see if
	we get roughly the same results; if so we are not far off. That's a variant of the
	time honored and often elegant technique of calculating something in two different
	ways and then comparing the results.

	What you see below is *not* exhaustive, thorough, or sufficient testing. Please try some more.
*/

int main()
try
{
	Rational r1(4,2);
	cout << r1 << "==" << to_double(r1) << '\n';
	Rational r2(42,24);
	cout << r2 << "==" << to_double(r2) <<'\n';
	cout << r1+r2 << "==" << to_double(r1+r2) << "==" << to_double(r1)+to_double(r2) << '\n';
	cout << r1-r2 << "==" << to_double(r1-r2) << "==" << to_double(r1)-to_double(r2) << '\n';
	cout << -r2 << "==" << to_double(-r2) << "==" << -to_double(r2) << '\n';
	cout << r1*r2 << "==" << to_double(r1*r2) << "==" << to_double(r1)*to_double(r2) << '\n';
	cout << r1/r2 << "==" << to_double(r1/r2) << "==" << to_double(r1)/to_double(r2) << '\n';
	if (r2==Rational(14,8)) cout << "equal\n";
	if (r2!=Rational(14,8)) cout << "not equal\n";
	Rational(3,0);	// we're out of here!

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
	Why would anyone use rational numbers? Well, floating point is imprecise (e.g. can't represent a third
	exactly) and some things are for good and/or legal reasons required to be exact (e.g. financial calculations).
*/

