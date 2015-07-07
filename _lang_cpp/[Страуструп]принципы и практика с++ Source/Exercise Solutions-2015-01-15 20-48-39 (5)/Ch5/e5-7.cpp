// Bjarne Stroustrup 4/5/2009
// Chapter 5 Exercise 7

/*
	quadratic equation solver:
	find the real roots (values of x) of a*x*x+b*x+c==0 given (a,b,c)

	corrections to found() by Teresa Leyk (2/1/2010)
*/

#include "std_lib_facilities.h"	
// note that different compilers/SDEs keep header files in different places
// so that you may have to use "../std_lib_facilities.h" or "../../std_lib_facilities.h"
// the ../ notation means "look one directly/folder up from the current directory/folder"

/*
	the solution is basically to express the formula given
		x = (-b+sqrt(b*b-4*a*c))/(2*a) and x = (-b-sqrt(b*b-4*a*c))/(2*a)
	while avoiding dividing by zero and taking the square root of a negative number.

	We have to be careful and systematic when writing those checks. Adding comments help.
*/

double a,b,c;	// coefficients

void solve()
{
	cout << "Please enter three floating-point numbers (a b c) to be used as the coefficients in a*x*x + b*x + c == 0: ";

	while (cin>>a>>b>>c) {
		if(a==0) {	// just b*x+c==0
					// easy: x == -c/b
			if (b==0)	// easy: c == 0
				cout << "no root (since x isn't used)\n";
			else
				cout << "x == " << -c/b << '\n';
		}
		else if (b==0) { // a*x*x+c==0
							// we know that a is not zero so, x*x == -c/a
							// if -c/a 0, obviousl x is zero
							// if -c/a is positive, there are two real solutions
							// if -c/a is negative, there are not real solutions
			double ca = -c/a;
			if (ca == 0)
				cout << "x==0\n";
			else if (ca < 0)
				cout << "no real roots\n";
			else
				cout << "two real roots: " << sqrt(ca) << " and " << -sqrt(ca) << '\n';
		}
		else {	// here we finally have to apply the complete formula
				// we know that neither a nor b is zero
			double sq = b*b-4*a*c;
			if (sq==0)
				cout << "one real root: " << -b/(2*a) << '\n';
			else if (sq<0)
				cout << "no real roots\n";
			else
				cout << "two real roots: " << setprecision(12) << (-b+sqrt(sq))/(2*a) << " and " << (-b-sqrt(sq))/(2*a) << '\n';
		}

		cout << "please try again (enter a b c): ";
	}
}

/*
	I used "setprecision(12)", which will not be described until Chapter 12, because someone got confused
	over apparantly senseless output: By default, only the most significant six digits of a floating-point number
	is output: That can indeed lead to confusion, so I upped the limit to 12 digits.
*/


/*
	So, that looks like a reasonably neat solution and if you test it a bit it seems to give reasonable results.
	But how do you know it really is right? Most of us can't solve non-trivial quadratic equations in our heads
	and checking using a calculator soon becomes tedious (and is quite unsystematic - how do you select the inputs
	for which to check?).

	So, let's make a version that checks its results before printing them out to the user.
	Checking seems easy: just plus the x we found back into the formula a*x*x+b*x+c==0 and
	see if we really gets zero.

	There is one problem we have to take into account: floating-point arithmetic is not 100% accurate
	so we can't just test against zero, we must test that our result is "close enough to zero". In real
	life, determining what "close enough" should be can be an interesting task. Here, we'll simply pick
	a very small number.
*/


const double epsilon = 1.0e-7;	// "close enough to zero" for us

double found(double x)
	// check x against epsilon;
	// in case of a poor solution print a message to alert the user
{
	double e = a*x*x+b*x+c;

	if (e==0) return x;
	if (0<e && epsilon<e)
		cout << "poor root; off by " << e << '\n';	// positive and larger than epsilon
	else if (e<-epsilon)
		cout << "poor root; off by " << e << '\n';	// negative and smaller than epsilon
	return x;
}


void solve2()
{
	cout << "Please enter three floating-point numbers (a b c) to be used as the coefficients in a*x*x + b*x + c == 0: ";

	while (cin>>a>>b>>c) {
		if(a==0) {	// just b*x+c==0
					// easy: x == -c/b
			if (b==0)	// easy: c == 0 
				cout << "no root (since x isn't used)\n";
			else
				cout << "x == " << found(-c/b) << '\n';
		}
		else if (b==0) { // a*x*x+c==0
							// we know that a is not zero so, x*x == -c/a
							// if -c/a 0, obviousl x is zero
							// if -c/a is positive, there are two real solutions
							// if -c/a is negative, there are not real solutions
			double ca = -c/a;
			if (ca == 0)
				cout << "x==0\n";
			else if (ca < 0)
				cout << "no real roots\n";
			else
				cout << "two real roots: " << found(sqrt(ca)) << " and " << found(-sqrt(ca)) << '\n';
		}
		else {	// here we finally have to apply the complete formula
				// we know that neither a nor b is zero
			double sq = b*b-4*a*c;
			if (sq==0)
				cout << "one real root: " << found(-b/(2*a)) << '\n';
			else if (sq<0)
				cout << "no real roots\n";
			else
				cout << "two real roots: " << setprecision(12) << found((-b+sqrt(sq))/(2*a)) << " and " << found((-b-sqrt(sq))/(2*a)) << '\n';
		}

		cout << "please try again (enter a b c): ";
	}
}


int main()
try
{
	cout << "Do you want your results checked? (yes/no): ";
	string s;
	cin >> s;
	if (s=="no")
		solve();
	else if (s=="yes")
		solve2();
	else
		error("I don't understand the answer ",s);
	keep_window_open("~");	// For some Windows(tm) setups
}
catch (runtime_error e) {	// this code is to produceerror messages; it will be described in Chapter 5
	cout << e.what() << '\n';
	keep_window_open("~");	// For some Windows(tm) setups
}

/*
	I defined a b and c as global variables (so that found() can access them); that's not ideal.
	I repeated the input in solve() and solve2() statements; that's not ideal.
	In later chapters (e.g. 7, 8, and 10) we will discuss techniques for cleaning up such code.
	For example, global variables can be a source of confusion and errors, so a, b, and c might
	be made local to solve() and solve2() and passed to found as arguments,
	like this found((-b+sqrt(sq))/(2*a),a,b,c).

	Possible improvement: I replicated all the solution logic in solve() and solve2();
	that's verbose and bad for code maintenance: What if I wanted to make some improvement?
	I'd have to make the improvement twice - once in solve() and once in solve2()).
	Maybe, to simplify, we should always check?
*/
