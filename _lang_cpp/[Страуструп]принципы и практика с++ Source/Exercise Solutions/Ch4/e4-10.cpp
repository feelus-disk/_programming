// Bjarne Stroustrup 4/4/2009
// Chapter 4 Exercise 10

/*
	Write a program that plays the game "Rock, paper, scissors." If you are not familiar with the game do some research
	(e.g. on the web using Google). Research is a common task for programmers. Use a switch statement to solve this exercise.
	Also, the machine should give random answers (i.e., select the next Rock, paper, or scissors randomly). Real randomness
	is too hard to provide just now, so just build a vector with a sequence of values to be used as "the next value."
	If you build the vector into the program, it will always play the same game, so maybe you should let the user enter some values).
	Try variations to make it less easy for the user to guess which move the machine will do next.
*/

#include "std_lib_facilities.h"	
// note that different compilers/SDEs keep header files in different places
// so that you may have to use "../std_lib_facilities.h" or "../../std_lib_facilities.h"
// the ../ notation means "look one directly/folder up from the current directory/folder"

/*
	Somehow, we have to get the computer to be a bit unpredicatble.
	There are many ways of doing that. All of the good ones involves random numbers,
	but here I'll just do somthing simple that does not use any advanced programming.

	The computer will play based on a series of (Fibbonacci) numbers that we generate using the
	function next_play().

	To avoid having the computer always play the same game we ask the player to enter a "seed";
	different seeds can give different games.
*/

int v1 = 1;
int v2 = 2;

int fib()	// generate the next element of a (Fibbonacci) series:
			// 1 2 3 5 8 13 21 34
{
	int s = v1+v2;
	if (s<=0) s = 1;	// how could s become less than zero?
	v1 = v2;
	v2 = s;
	return s;
}

void generate(int seed)
	// use the seed to choose where in the sequence the game starts
{
		if (seed<0) seed = -seed;	// don't want a negative number
		seed %=10;					// don't want a number larger than 9
		if (seed==0) return;		// don't bother: use the default
		for (int i=0 ; i<seed; ++i) fib();	// move seed steps forward
}

int next_play()	// generate a reasonably obscure sequence of 0s, 1s, and 2s
{
	return fib()%3;	// we are only interested in a value 0, 1, or 2 (% is the modulus/remainder operation)
}


int main()
try
{
	cout << "enter an integer \"seed\" to help me play: ";
	int seed = 0;
	cin >> seed;
	generate(seed);	// get the computer ready to play

	// let's keep track of who's winning:
	int count1 = 0;	// user's score
	int count2 = 0;	// computer's score
	int draws = 0;	// number of draws/ties

	cout << "enter \"rock\", \"paper\", or \"scissors\"\n"
		<< "(I'll do the same and promises not to cheat by peeping at your input): ";
	string s;
	while(cin >> s) {	// we'll as long as we get "good" input and then stop

						// the computer prefers numbers, so convert string representations to numbers
						// we prefer strings (except when wet ype), so convert abbreviations to full words
		int x = 0;
		if (s=="scissors" || s=="s") {
			x = 0;
			s = "scissors";
		}
		else if (s=="rock" || s=="r") {
			x = 1;
			s = "rock";
		}
		else if (s=="paper" || s=="p") {
			x = 2;
			s = "paper";
		}
		else error("sorry: bad operator: ",s);

		int xx = next_play();
		string ss;	// computers play
		switch(xx) {	// we prefer strings, so convert numeric representations to strings
		case 0: ss = "scissors"; break;
		case 1:	ss = "rock"; break;
		case 2:	ss = "paper"; break;
		}
	
		if (x==xx) {
			cout << "a draw!\n";
			++draws;
		}
		else {
			string res = "I win!";
			if (xx==0 && x==1) {
				res = "You win!";	// rock beats sissors
				++count1;
			}
			else if (xx==1 && x==2) {
				res = "You win!";	// paper beats rock
				++count1;
			}
			else if (xx==2 && x==0) {
				res = "You win!";	// scissors beat paper
				++count1;
			}
			else
				++count2;

			cout << "you said \"" << s << "\" I said \"" << ss << "\": " << res ;
			cout << " score: you==" << count1 << " me==" << count2 << " same==" << draws << "\n";
		}
		cout << "Please try again: ";
	}
	cout << "exit because of bad input\n";
	keep_window_open("~");	// For some Windows(tm) setups
}
catch (runtime_error e) {	// this code is to produceerror messages; it will be described in Chapter 5
	cout << e.what() << '\n';
	keep_window_open("~");	// For some Windows(tm) setups
}

/*
	Did you have trouble remembering that
		0 means "scissors"
		1 means "rock"
		2 means "paper"
	?

	I did. We could have avoided most of the use of numbers. Alternatively, we could have introduced
	synbolic names for the numbers 0, 1, 2 - we'll get to that in chapters 7 and 8.
*/