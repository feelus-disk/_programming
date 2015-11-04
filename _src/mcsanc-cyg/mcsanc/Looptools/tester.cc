// test program to check looptool linking against c++ code.

#include <iostream>
#include <complex>
#include "Herwig++/Looptools/clooptools.h"

using namespace Herwig::Looptools;
using namespace std;

int main() {
  double ps2 = 1.2268e+10;
  double pv1s = 0;
  double pv2s = 0;
  double mls = 2.65501e+11;

  cout << "before ini" << endl;
  ffini();
  cout << "after ini" << endl;
  long theC = Cget(ps2,pv2s,pv1s,
		      mls,mls,mls);
  cerr << "theC: " << theC << '\n';
  complex<double> C1 = Cval(cc1,theC);
  ffexi();
  cout << "after: " << C1 << endl;
  
  cerr << sizeof(long) << '\n';

  return 0;
}
