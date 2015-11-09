#define EXTERN extern
#include "88.h"
#include "macro.h"

#define	SLOP		(80 * 2)

wstore(x)
register word	x;
{
    register reg	t;
    register char	*sav_eapc = eapc;

#ifdef LITTLE_ENDIAN
    *eapc++ = x;
    *eapc = x>>8;
#else

    t.w = x;

    /*
     * XXX WATCH OUT HERE!!
     *
     * This is special depending on the type of machine you have and
     * whether the registers fall below memory or above memory in the
     * final link map
     */

    if (eapc>= M && eapc < M + MEMBYTES) {
		/* memory store is different from register */
	    *eapc++ = t.b.lo;
	    *eapc = t.b.hi;
    }
    else {
	*eapc++ = t.b.hi;
	*eapc = t.b.lo;
    }
#endif
}

xstore(x)
register char	*x;
{
    register reg t;

    register char	*sav_eapc = eapc;

#ifdef LITTLE_ENDIAN
    *eapc= *x;
    *(eapc+1)= *(x+1);
#else

    t.w = *(word *)x;
    /*
     * XXX WATCH OUT HERE!!
     *
     * This is special depending on the type of machine you have and
     * whether the registers fall below memory or above memory in the
     * final link map
     */
    if (eapc <= M + MEMBYTES) {	/* memory store is different from register */
	    *eapc = t.b.hi;
	    *(eapc+1) = t.b.lo;
    }
    else {
	*eapc = t.b.lo;
	*(eapc+1) = t.b.hi;
    }
#endif /*!LITTLE_ENDIAN*/

}

rapwstore(w)
register word	w;
{
    register reg	t;
    register char	*ptr = (char *)rapw;
#ifdef LITTLE_ENDIAN
    *rapw = w;
#else

    t.w = w;
    /*
     * XXX WATCH OUT HERE!!
     *
     * This is special depending on the type of machine you have and
     * whether the registers fall below memory or above memory in the
     * final link map
     */
    if (ptr <= M + MEMBYTES) {	/* memory store is different from register */
	    *ptr++ = t.b.lo;
	    *ptr = t.b.hi;
    }
    else {
	*ptr++ = t.b.hi;
	*ptr = t.b.lo;
    }
#endif
}
