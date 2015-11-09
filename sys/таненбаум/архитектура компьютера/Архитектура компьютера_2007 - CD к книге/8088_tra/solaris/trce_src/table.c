#define EXTERN
#include "88.h"

/* Most PDP-11 compilers refuse to compile arrays that exceed 32K bytes.
 * To get around this defect, the array m is split up into two pieces.
 * The only way to have the loader put the two parts contiguously in memory
 * is to partially initialize each.
 */

#ifdef pdp
char m[HALFMEM] = {0};
char mx[HALFMEM] = {0};
#else
char mdump1[1024], m[MEMBYTES], mdump2[1024];
#endif

REG r;

/* union{unchar rc[16]; word rw[8];}r;      /* AX,BX,CX,DX,SI,DI,BP,SP */
