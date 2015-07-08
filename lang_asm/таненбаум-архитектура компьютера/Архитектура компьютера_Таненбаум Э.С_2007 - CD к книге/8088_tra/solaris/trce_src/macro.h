/* Macros for memory references. */
#define M m

#define WSTORE(x)	wstore(x)
#define	RAPWSTORE(x)	rapwstore(x)
#define XSTORE(x)	xstore(x)

#if CHECK
#define MEM(x,b,t)\
	if ( (xx= ((long)b<<4) +(unsigned short)t) >= MEMBYTES)\
	    merr(b,t);\
	x = M + xx

#define CSMEM(x,t)\
	if ( (xx= cs16 +(unsigned short)t) >= MEMBYTES)\
	    merr(cs,t);\
	x = M + xx

#define STACKPTR(t)\
	xx = ( (long)ss << 4) + (unsigned short)sp;\
	t = (word *) (M + xx);\
	stackck()

#define BSTORE(x)\
	progck1();\
	*eapc = x

#ifdef LITTLE_ENDIAN
#define MOV16\
	progck2();\
	*eapc++ = *pcx++;\
	*eapc++ = *pcx++
#else
/*
 * XXX watch for memory layout here
 */
#define MOV16\
	progck2();\
	if (eapc <= M + MEMBYTES) {\
	    *eapc++ = *pcx++;\
	    *eapc++ = *pcx++;\
	} else {\
	    *(eapc+1) = *pcx++;\
	    *eapc++ = *pcx++;\
	    eapc++;\
	}
#endif

#else	/* not check */

#define MEM(x,b,t)\
	x = M + (b<<4) + (unsigned short)t

#define CSMEM(x,t)\
	x = M + cs16 + (unsigned short)t

#define STACKPTR(t)\
	xx = ( (long)ss << 4) + (unsigned short)sp;\
	t = (word *) (M + xx);

#define BSTORE(x)\
	*eapc = x

#ifdef LITTLE_ENDIAN
#define MOV16\
	*eapc++ = *pcx++;\
	*eapc++ = *pcx++
#else
/*
 * XXX watch for memory layout here
 */
#define MOV16\
	if (eapc <= M + MEMBYTES) {\
	    *eapc++ = *pcx++;\
	    *eapc++ = *pcx++;\
	} else {\
	    *(eapc+1) = *pcx++;\
	    *eapc++ = *pcx++;\
	    eapc++;\
	}
#endif

#endif	/* check */

#define PC (pcx - M) - cs16
#define CS(x) cs = x; cs16 = cs << 4;

#ifdef LITTLE_ENDIAN
# define WFETCH\
	eoplo= *eapc++; eophi= *eapc++
#else
/*
 * XXX watch for memory layout here
 */
# define WFETCH\
    if (eapc <= M + MEMBYTES) {\
	eoplo = *eapc++; eophi = *eapc++;\
    } else {\
	eophi = *eapc++; eoplo = *eapc++;\
    }
#endif

#define BFETCH eoplo= *eapc

/* Macros for handling operands. */
#define	DISP8		eahi  = ((char)(ealo = *pcx++) < 0) ? 0xFF : 0;
#define DISP16		ealo  = *pcx++; eahi = *pcx++;
#define IMMED		eoplo = *pcx++; eophi = *pcx++
#define IMMED8		eoplo = *pcx++
#define IMMED8X		eophi = ((char)(eoplo = *pcx++) < 0) ? 0xFF : 0
#define IMMED8Z		eoplo = *pcx++; eophi = 0
#define RMCONST		roplo = *pcx++; rophi = *pcx++
#define BRMCONST	roplo = *pcx++;  
#define XRMCONST	rophi = ((char)(roplo = *pcx++) < 0) ? 0xFF : 0

/* Macros for setting condition codes. * /
#define SZONLY(a)          ccvalid= 0; x= a; operator= BOOLW
#define BSZONLY(a)         ccvalid= 0; xc= a; operator= BOOLC
#define LAZYCC(a,b,op)     ccvalid= 0; x= a; y= b; operator= op
#define BLAZYCC(a,b,op)    ccvalid= 0; xc= a; yc= b; operator= op
#define LAZYCC3(a,b,c,op)  ccvalid= 0; x= a; y= b; z= c; operator= op
#define BLAZYCC3(a,b,c,op) ccvalid= 0; xc= a; yc= b; zc= c; operator= op;*/
#define CC if (ccvalid == 0) cc()
#define SZONLY(a)          x= a; operator= BOOLW; cc()
#define BSZONLY(a)         xc= a; operator= BOOLC; cc()
#define LAZYCC(a,b,op)     x= a; y= b; operator= op; cc()
#define BLAZYCC(a,b,op)    xc= a; yc= b; operator= op; cc()
#define LAZYCC3(a,b,c,op)  x= a; y= b; z= c; operator= op; cc()
#define BLAZYCC3(a,b,c,op) xc= a; yc= b; zc= c; operator= op; cc()

/* Macros for stack operations. */
#ifdef LITTLE_ENDIAN
# define PUSH(x) sp -= 2; STACKPTR(stkp); *stkp = x
# define POP(x)  STACKPTR(stkp); x = *stkp; sp += 2
#else
# define PUSH(x)\
	sp -= 2;\
	STACKPTR(stkp);{\
	reg _t; char *ptr = (char *)stkp;\
	_t.w = x; *ptr = _t.b.lo; *(ptr+1) = _t.b.hi; }

# define POP(x)\
	STACKPTR(stkp);\
	{ reg _t;\
	char *ptr = (char *)stkp;\
	_t.b.lo = *ptr;\
	_t.b.hi = *(ptr+1);\
	x = _t.w;\
	} sp += 2

#endif /*LITTLE_ENDIAN*/

/* Macros for interrupt and PSW operations. */
#define FLAGWD(t)	CC;\
		t=((ovf<<11)+(dirf<<10)+(intf<<9)+(signf<<7)+(zerof<<6)+cf)

#define LOADFLAGS(t)	ovf     = (t>>11)&1;\
			dirf    = (t>>10)&1;\
			intf    = (t>>9)&1;\
			signf   = (t>>7)&1;\
			zerof   = (t>>6)&1;\
			cf      = t&1;\
			ccvalid = 1

/* Macros for string operations. */
#define STRING   MEM(xapc, ds, si); MEM(eapc, es, di)
#define WDIRF(t) t += (dirf == 0) ? 2 : -2;
#define BDIRF(t) t += (dirf == 0) ? 1 : -1;
#define WSIDI    if (dirf == 0) {si +=2; di +=2;} else {si -=2; di -=2;}
#define BSIDI    if (dirf == 0) {si +=1; di +=1;} else {si -=1; di -=1;}

/* Miscellaneous macros. */
#define OVERRIDE(seg)\
	dsx=ds; \
	ssx=ss; \
	ds=seg; \
	ss=seg; \
	realtime += ticks - timer; \
	ticks = 2; \
	timer = 2; \
	nextint=SEGOVER

#define BITSEL(v1,n1,v2,n2) v1=(eop>>n1)&1;  v2=(eop>>n2)&1
#define LOOP goto loop
