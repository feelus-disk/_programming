// Bjarne Stroustrup 1/16/2010
// Chapter 9 Exercise 11

/*
	Provide helper functions for the Date class, such as next_workay() and week_of_year().

	Apologies: I had assumed the the formulas and explanations needed to make date calculations
		simple were more easily available on the web and clearer than I found.
		The mathematical explanations seem to have been drowned in little widgets that will
		calculate for you, but don't explain how.

		The next_workday() and week_of_year() are not very hard, but just about anything further
		gets you into trouble. I did a bit of that below.

		To keep the code simple and comprehensible, the code below has been restricted in
		places (e.g. handling only dates after 1 Jan 1601).

	Warning: Do not try anything non-trivial with date unless you are experienced with either
		data calculations, algorithms in general, or have a good source of algorithms (in some
		language) to guide your work.

	This exercise was meant partly as a motivation for the next exercise: changing the representation
	of a date to "number of days after a designated first date" rather than (day,month,year).
	I think it succeeded all too well at that. To avoid really messy code, I first convert the
	"days after first_date".

*/

#include "std_lib_facilities.h"	

/*
	If you know the day of the week of *any* day (e.g. Jan 16, 2010 is a Saturday) and how to
	calculate leapyear() (exercise 9-10), you can find the day of the week of every day (of the
	current calendar). For example, 7 days after 1/16/2010 is another Saturday, 10 days after
	1/16/2010 is a "Saturday+3"; that is, a Tuesday. 10 days before 1/16/2010 is a "Saturday-3";
	that is, a Wednesday.
	
	Primary school children can do that by counting on their fingers; Our job is to translate
	what those children do into code (formulas) so that we can deal with larger numbers.

	So as not to try to invent everything from scratch, try typing "day of the week" into google (or equivalent).
	For more than you ever wanted to know about calendars, see http://www.tondering.dk/claus/calendar.html
	(e.g. where and when did they have a February 30th?)
*/

//_____________________________________
/*
	for simplicity of distribution on the web, I have copied the code of a Date class into this file.
	Had my aim been realism and proper code organization, I would have used a Date.h and a Date.cpp.
*/

//
// This is example code from Chapter 9.8 "The Date class" of 
// "Programming -- Principles and Practice Using C++" by Bjarne Stroustrup
//

#include <iostream>

using namespace std;

// file Chrono.h

namespace Chrono {

//------------------------------------------------------------------------------

class Date {
public:
    enum Month {
        jan=1, feb, mar, apr, may, jun, jul, aug, sep, oct, nov, dec
    };

	class Invalid { };                 // to throw as exception

    Date(int y, Month m, int d);       // check for valid date and initialize
    Date();                            // default constructor
    // the default copy operations are fine

    // non-modifying operations:
    int   day()   const { return d; }
    Month month() const { return m; }
    int   year()  const { return y; }

    // modifying operations:
    void add_day(int n);        
    void add_month(int n);
    void add_year(int n);
private:
    int   y;
    Month m;
    int   d;
};


bool is_date(int y, Date::Month m, int d); // true for valid date

bool leapyear(int y);                  // true if y is a leap year

bool operator==(const Date& a, const Date& b);
bool operator!=(const Date& a, const Date& b);

ostream& operator<<(ostream& os, const Date& d);
istream& operator>>(istream& is, Date& dd);

const Date& default_date();

} // Chrono


//------------------------------------------------------------------------------

//The definitions go into Chrono.cpp:

// Chrono.cpp

namespace Chrono {

// member function definitions:


Date::Date(int yy, Month mm, int dd)
    : y(yy), m(mm), d(dd)
{
    if (!is_date(yy,mm,dd)) throw Invalid();
}

const Date& default_date();

Date::Date()
    :y(default_date().year()),
     m(default_date().month()),
     d(default_date().day())
{
}

int days_in_month(int y, Date::Month m);

void Date::add_day(int n)
{
	// use linear_day() below or things get really messy
	if (n<0) error("add_day(): can't handle negative n");	// not yet
	while (days_in_month(y,m)<n) {	// move one month at a time
		add_month(1);
		n -= days_in_month(y,m);
	}
	d += n;
}


void Date::add_month(int n)
{
	if (n<0) error("add_month(): cnot implemented");	// not yet
	// ...
}


void Date::add_year(int n)
{
    if (m==feb && d==29 && !leapyear(y+n)) { // beware of leap years!
			// makes sense for both positive and negative n (n==0 should be impossible here)
			m = mar;        // use March 1 instead of February 29
			d = 1;
    }
    y+=n;
}

//------------------------------------------------------------------------------

// helper functions, etc.:



enum Day {	// sunday==0
    sunday, monday, tuesday, wednesday, thursday, friday, saturday
};

const Date first_date(1601,Date::jan,1);	// don't try dates anywhere near this far back in time
											// the calendar calculation code is brittle the first date
											// must be the first day of a year divisible by 400
const Day first_day = monday;				//Januaray 1, 1600 would have been a Monday (had they had the Georgian calendar)

const Date& default_date()
{
    static const Date dd(2001,Date::jan,1); // start of 21st century
    return dd;
}

int days_in_month(int y, Date::Month m)
{
    switch (m) {
	case Date::feb:                        // the length of February varies
		return (leapyear(y))?29:28;
	case Date::apr: case Date::jun: case Date::sep: case Date::nov:
		return 30;
	default:
		return 31;
    }
}

bool is_date(int y, Date::Month  m, int d)
{
    // assume that y is valid

    if (d<=0) return false;            // d must be positive
    if (days_in_month(y,m)<d) return false;

    return true;
} 


bool leapyear(int y)
{
    // See exercise 9-10	

	// any year divisible by 4 except centenary years not divisible by 400

	if (y%4) return false;
	if (y%100==0 && y%400) return false;
	return true;
}


bool operator==(const Date& a, const Date& b)
{
    return a.year()==b.year()
        && a.month()==b.month()
        && a.day()==b.day();
}


bool operator!=(const Date& a, const Date& b)
{
    return !(a==b);
}


ostream& operator<<(ostream& os, const Date& d)
{
    return os << '(' << d.year()
              << ',' << d.month()
              << ',' << d.day() 
              << ')';
}


istream& operator>>(istream& is, Date& dd)
{
    int y, m, d;
    char ch1, ch2, ch3, ch4;
    is >> ch1 >> y >> ch2 >> m >> ch3 >> d >> ch4;
    if (!is) return is;
    if (ch1!='(' || ch2!=',' || ch3!=',' || ch4!=')') { // oops: format error
        is.clear(ios_base::failbit);                    // set the fail bit
        return is;
    }
    dd = Date(y,Date::Month(m),d);     // update dd
    return is;
}

ostream& operator<<(ostream& os, Day d)
	// sloppy: I should have used a table
{
	switch (d) {
	case sunday:
		os << "Sunday";
		break;
	case monday:
		os << "Monday";
		break;
	case tuesday:
		os << "Tuesday";
		break;
	case wednesday:
		os << "Wednesday";
		break;
	case thursday:
		os << "Thursday";
		break;
	case friday:
		os << "Friday";
		break;
	case saturday:
		os << "Saturday";
		break;
	}
	return os;
}

int nmonth(int m)
	// number of days before the first day of month #m (january is #1) ignoring leap days
{
	switch(m)
	{
	case Date::jan:	return 0;
	case Date::feb:	return 31;
	case Date::mar:	return 31+28;
	case Date::apr:	return 31+28+31;
	case Date::may:	return 31+28+31+30;
	case Date::jun:	return 31+28+31+30+31;
	case Date::jul:	return 31+28+31+30+31+30;
	case Date::aug:	return 31+28+31+30+31+30+31;
	case Date::sep:	return 31+28+31+30+31+30+31+31;
	case Date::oct:	return 31+28+31+30+31+30+31+31+30;
	case Date::nov:	return 31+28+31+30+31+30+31+31+30+31;
	case Date::dec:	return 31+28+31+30+31+30+31+31+30+31+30;
	}
}


int day_in_year(Date a)
	// e.g. Jan 1 is day #1, Jan 2 is day #1 and feb 3 is day #34
{
	int m = nmonth(a.month()-1);
	if (Date::feb<a.month() && leapyear(a.year())) ++m;	// adjust if we passed a dat added for a leapyear
	return m+a.day();
}


int nleaps(int y)
	// number of leapyears between Jan 1, y and first_year
	// first_year must be divisible by 400
{
	const int yy = y-first_date.year();
	return yy/4 - yy/100 + yy/400; // number of leapyears
}

int linear_day(Date a)
	// days since default date
{
	int y = a.year()-first_date.year();
	if (y<0) error("linear_day: can't handle days before (1601,jan,1)");
	int m = a.month()-first_date.month();
	int d = a.day()-first_date.day();
	/*
		If it wasn't for leap years and different lengths of month the answer would be
			365*y+31*m+d
		However, ther real world (the real physical world + conventions) is not that simple.
	*/
	if (y==0 && m==0) return d;	// same month
	int days_in_years = 365*y+nleaps(a.year());
	return days_in_years+day_in_year(a)-1;
}

Date date_from_linear(int n)
	// compose the Date (2001,jan,1)+n
{
	return Date(first_date.year(),first_date.month(),first_date.day()+n);	// rather limited implementatiuon :-)
}

int operator-(Date a, Date b)
	// how many days are there between a and b?
	// if b is earlier than a the answer will be negative
{
	int aval = linear_day(a);
	int bval = linear_day(b);
	return aval-bval;
}


Date operator+(const Date& d, int dd)
	// dd days beyond d
{
	Date x = d;
	x.add_day(dd);
	return x;
}

/*
	Note the difference between + and - for Date.
	It makes sense to subtract two dates, but not to add two dates
*/


Day day_of_week(const Date& d)
	// ``just count the days since the start of (our) dates''
{
	int x = first_day + linear_day(d);
	return Day(x%7);				// every week is 7 days
}


Date next_Sunday(const Date& d)
{
    Day dd = day_of_week(d);
    Date ns = d;
	ns.add_day(7-dd);
	return ns;
}


Date next_weekday(const Date& d)
	// assume that Saturday and Sunday are not weekdays
{
    Day dd = day_of_week(d);
	int n = 1;
	switch(dd) {
	case friday:	// skip Saturday and Sunday
		n = 3;
		break;
	case saturday:	// Skip Sunday
		n = 2;
		break;
	}
	return d+n;
}

int week_in_year(const Date& d)
	// the number of a week in a year is defined by ISO 8601:
	//	week #1 is the week with the year's first Thursday in it
	//	Monday is the first day of the week

	// 0 means that the date is in the last week ofthe previous year
{
	int diy = day_in_year(d);	// jan 1 is day #1
	Day jan1 = day_of_week(Date(d.year(),Date::jan,1));
	int week1 = 0;	// Jan 1 is in the last week of the previous year
	int delta;
	switch(jan1) {
		// Jan 1 is in the first week of the year
	case monday:
		delta = 0;
		break;
	case tuesday:
		delta = 1;
		break;
	case wednesday:
		delta = 2;
		break;
	case thursday: 
		delta = 3;
		break;
		// Jan 1 is in the last week of the previous year
	case friday:
		delta = -3;
		break;
	case saturday:
		delta = -2;
		break;
	case sunday:
		delta = -1;
		break;
	}

	return (diy+delta)/7;
}


//------------------------------------------------------------------------------

} // Chrono

//------------------------------------------------------------------------------

int zxc;

void write(const Chrono::Date& d)	// debug output function
{
	cout << d << ": " << day_of_week(d) << "; linear: " << linear_day(d) << "; of week #" << week_in_year(d) << '\n';
}

int main()
try
{
	Chrono::Date xxx(2001,Chrono::Date::jan,1);
	write(xxx);
	Chrono::Date xxxw = next_weekday(xxx);
	write(xxxw);

	Chrono::Date xx(2001,Chrono::Date::jan,8);
	write(xx);
	Chrono::Date xxw = next_weekday(xx);
	write(xxw);

	Chrono::Date today(2010,Chrono::Date::jan,16);
	write(today);
	Chrono::Date todayw = next_weekday(today);
	write(todayw);

	Chrono::Date vote(2010,Chrono::Date::mar,13);
	write(vote);
	Chrono::Date votew = next_weekday(vote);
	write(votew);

	using namespace Chrono;
	cout << "enter some dates: ";
	Date d;
	while (cin>>d) {
		write(d);
	}

	keep_window_open("~");	// For some Windows(tm) setups
}
catch (Chrono::Date::Invalid&) {
    cerr << "error: Invalid date\n"; 
	keep_window_open("~");	// For some Windows(tm) setup
    return 1;
}
catch (runtime_error& e) {	// this code is to produce error messages
	cout << e.what() << '\n';
	keep_window_open("~");	// For some Windows(tm) setups
}

/*
	This has not been SYSTEMATICALLY tested, so you should be able to find bugs;
	I'd like to hear about those.

*/
