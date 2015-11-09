#define EXTERN extern
#include "88.h"

#define X (unsigned short)x
#define Y (unsigned short)y

cc()
{
/* Compute the condition codes. Rewriting this routine in assembly code will 
 * improve overall performance considerably.
 */

  register short r;
  register unsigned short u, u1;
  char c;

  switch(operator) {
     case ADDW:
	l = X;
	l += Y;
	if ( (r = (short) l) > 0) {signf = 0; zerof = 0;}
	else if (r == 0) {zerof = 1; signf = 0;}
	else {zerof = 0; signf = 1;}

	ovf = ( (x^y) < 0 || (x^r) >= 0 ? 0 : 1);
	cf = (l >> 16) & 1;
	ccvalid = 1;
	return;

     case ADDB:
	u = (unchr) xc;
	u1 = (unchr) yc;
	u += u1;
	if ( (r = u&0377) == 0) {zerof = 1; signf = 0;}
	else if (r < 128) {zerof = 0; signf = 0;}
	else {zerof = 0; signf = 1;}

	ovf = (  ((xc^yc)& 0200) || ((xc^r)&0200) == 0 ? 0 : 1);
	cf = (u >> 8) & 1;
	ccvalid = 1;
	return;

     case ADCW:
	l = X;
	l += Y;
	l += z;
	if ( (r = (short) l) > 0) {signf = 0; zerof = 0;}
	else if (r == 0) {zerof = 1; signf = 0;}
	else {zerof = 0; signf = 1;}

	ovf = (  (x^y) < 0 || (x^(x+y)) >= 0 ? 0 : 1);
	if (((x+y)^z) >= 0 && (r^z) < 0) ovf = 1;
	cf = (l >>16) & 1;
	ccvalid = 1;
	return;

     case ADCB:
	u = (unchr) xc;
	u1 = (unchr) yc;
	u += u1;
	r = ((char)zc < 0 ? -1 : zc);
	u += r;
	if ( (r = u&0377) == 0) {zerof = 1; signf = 0;}
	else if (r < 128) {zerof = 0; signf = 0;}
	else {zerof = 0; signf = 1;}

	ovf = (  ((xc^yc)& 0200) || ((xc^(xc+yc))&0200) == 0 ? 0 : 1);
	c = xc + yc;
	if ( ((c^zc)&0200) == 0 && ( ((r^zc)&0200) != 0) ) ovf = 1;
	cf = (u >> 8) & 1;
	ccvalid = 1;
	return;

     case INCW:
	l = X;
	l += 1;
	if ( (r = (short) l) > 0) {signf = 0; zerof = 0;}
	else if (r == 0) {zerof = 1; signf = 0;}
	else {zerof = 0; signf = 1;}

	ovf = (x == 0x7FFF ? 1 : 0);
	/* DON'T TOUCH THE CARRY BIT! */
	ccvalid = 1;
	return;

     case INCB:
	u = (unchr) xc;
	u += 1;
	if ( (r = u&0377) == 0) {zerof = 1; signf = 0;}
	else if (r < 128) {zerof = 1; signf = 0;}
	else {zerof = 0; signf = 1;}

	ovf = (xc == 0x80 ? 1 : 0);
	/* DON'T TOUCH THE CARRY BIT! */
	ccvalid = 1;
	return;

     case SUBW:
	l = X;
	l -= Y;
	if ( (r = (short) l) > 0) {signf = 0; zerof = 0;}
	else if (r == 0) {zerof = 1; signf = 0;}
	else {zerof = 0; signf = 1;}

	ovf = ( (x^y) >= 0 || (x^r) >= 0 ? 0 : 1);
	cf = (l >> 16) & 1;
	ccvalid = 1;
	return;

     case SUBB:
	u = (unchr) xc;
	u1 = (unchr) yc;
	u -= u1;
	if ( (r = u&0377) == 0) {zerof = 1; signf = 0;}
	else if (r < 128) {zerof = 0; signf = 0;}
	else {zerof = 0; signf = 1;}

	ovf = (  ((xc^yc)& 0200)==0 || ((xc^r)&0200) == 0 ? 0 : 1);
	cf = (u >> 8) & 1;
	ccvalid = 1;
	return;

     case SBBW:
	l = X;
	l -= Y;
	l -= z;
	if ( (r = (short) l) > 0) {signf = 0; zerof = 0;}
	else if (r == 0) {zerof = 1; signf = 0;}
	else {zerof = 0; signf = 1;}

	ovf = (  (x^y) >= 0 || (x^(x-y)) >= 0 ? 0 : 1);
	if (((x-y)^z) < 0 && (r^(x-y)) < 0) ovf = 1;
	cf = (l >>16) & 1;
	ccvalid = 1;
	return;

     case SBBB:
	u = (unchr) xc;
	u1 = (unchr) yc;
	u -= u1;
	u -= (unsigned short) zc;
	if ( (r = u&0377) == 0) {zerof = 1; signf = 0;}
	else if (r < 128) {zerof = 0; signf = 0;}
	else {zerof = 0; signf = 1;}

	ovf = (  ((xc^yc)& 0200)==0 || ((xc^(xc-yc))&0200) == 0 ? 0 : 1);
	c = xc - yc;
	if ( ((c^zc)&0200) != 0 && ( ((r^c)&0200) != 0) ) ovf = 1;
	cf = (u >> 8) & 1;
	ccvalid = 1;
	return;

     case DECW:
	l = X;
	l -= 1;
	if ( (r = (short) l) > 0) {signf = 0; zerof = 0;}
	else if (r == 0) {zerof = 1; signf = 0;}
	else {zerof = 0; signf = 1;}

	ovf = ( ((unsigned short)x) == 0x8000 ? 1 : 0);
	/* DON'T TOUCH THE CARRY BIT! */
	ccvalid = 1;
	return;

     case DECB:
	u = (unchr) xc;
	u -= 1;
	if ( (r = u&0377) == 0) {zerof = 1; signf = 0;}
	else if (r < 128) {zerof = 1; signf = 0;}
	else {zerof = 0; signf = 1;}

	ovf = (xc == 0x80 ? 1 : 0);
	/* DON'T TOUCH THE CARRY BIT! */
	ccvalid = 1;
	return;

     case BOOLW:
	if ((r = x) > 0) {signf = 0; zerof = 0;}
	else if (r == 0) {zerof = 1; signf = 0;}
	else {zerof = 0; signf = 1;}
	cf = 0;
	ovf = 0;
	ccvalid = 1;
	return;

     case BOOLC:
	if (xc > 0) {signf = 0; zerof = 0;}
	else if (xc == 0) {zerof = 1; signf = 0;}
	else {zerof = 0; signf = 1;}
	cf = 0;
	ovf = 0;
	ccvalid = 1;
	return;

    default: panic("Invalid operator for lazy condition code");
  }
}
