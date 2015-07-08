#include <stdio.h>
#define EXTERN extern
#include "88.h"
#include "macro.h"

#ifdef INPUT
#include <signal.h>
#endif
extern void prut();

interp()
{
register word             t;
register word             t2;
register char             c;
register int              mm, n, k;       /* 1 if dumping on, 0 if off */
register adr              u, u1, u2;

    mask = 0377;
/* Here is the main loop of the interpreter. */
loop:
/* dump();
    if (anything)
        dumpck();

    if (--timer == 0)
        checkint(); */

next:
    t = *pcx++ & mask;
    if(stopvlag) dump();
    else if(traceflag && !(--instrcount & 0x3fff)){
	sprintf(errbuf,"Telstop %3d",((instrcount)>>14)&0Xff); meldroutine();
		if(instrcount) {/* system("sleep 1"); winupdate();*/}
		else dump();}
    if((PC)>codelength) {
      if (traceflag) dump();
	fprintf(stderr,"Code out of range %d\n",(PC)); exit(1);}
bloop:
    /* if (t == 0x90)
        goto next; */

    /* Some compilers balk at 256-case switches */
    switch(t) {

    case 0x00: by(); c=eoplo+roplo; BSTORE(c); BLAZYCC(eoplo,roplo,ADDB); LOOP;
    case 0x01: wd(); t=eop+rop; WSTORE(t); LAZYCC(eop,rop,ADDW); LOOP;
    case 0x02: by(); c=roplo+eoplo; *rapc=c; BLAZYCC(roplo,eoplo,ADDB); LOOP;
    case 0x03: wd(); t=rop+eop; *rapw=t; LAZYCC(eop,rop,ADDW); LOOP;
    case 0x04: IMMED8; c=al; al+=eoplo; BLAZYCC(c,eoplo,ADDB); LOOP;
    case 0x05: IMMED; t= ax; ax+=eop; LAZYCC(t,eop,ADDW); LOOP;
    case 0x06: PUSH(es); LOOP;
    case 0x07: POP(es); LOOP;

    case 0x08: by(); c=eoplo|roplo; BSTORE(c); BSZONLY(c); LOOP;
    case 0x09: wd(); t=eop|rop; WSTORE(t); SZONLY(t); LOOP;
    case 0x0A: by(); c=roplo|eoplo; *rapc=c; BSZONLY(c); LOOP;
    case 0x0B: wd(); t=rop|eop; *rapw=t; SZONLY(t); LOOP;
    case 0x0C: IMMED8; c=al|eoplo; al=c; BSZONLY(c); LOOP;
    case 0x0D: IMMED; t= ax|eop; ax=t; SZONLY(t); LOOP;
    case 0x0E: PUSH(cs); LOOP;
    case 0x0F: syscal(); LOOP; /* spare(0x0F);*/

    case 0x10: by(); CC; c=eoplo+roplo+cf; BSTORE(c);
		BLAZYCC3(eoplo,roplo,cf,ADCB); LOOP;
    case 0x11: wd(); CC; t=eop+rop+cf; WSTORE(t);
		LAZYCC3(eop,rop,cf,ADCW); LOOP;
    case 0x12: by(); CC; c=roplo+eoplo+cf; *rapc=c;
		BLAZYCC3(roplo,eoplo,cf,ADCB); LOOP;
    case 0x13: wd(); CC; t=rop+eop+cf; *rapw=t;
		LAZYCC3(eop,rop,cf,ADCW); LOOP;
    case 0x14: IMMED8; CC; c=al; al+=eoplo+cf;
		BLAZYCC3(c,eoplo,cf,ADCB); LOOP;
    case 0x15: IMMED; CC; t= ax; ax+=eop+cf;
		LAZYCC3(t,eop,cf,ADCW); LOOP;
    case 0x16: PUSH(ss); LOOP;
    case 0x17: POP(ss); LOOP;

    case 0x18: by(); CC; c=eoplo-roplo-cf; BSTORE(c);
		BLAZYCC3(eoplo,roplo,cf,SBBB); LOOP;
    case 0x19: wd(); CC; t=eop-rop-cf; WSTORE(t);
		LAZYCC3(eop,rop,cf,SBBW); LOOP;
    case 0x1A: by(); CC; c=roplo-eoplo-cf; *rapc=c;
		BLAZYCC3(roplo,eoplo,cf,SBBB); LOOP;
    case 0x1B: wd(); CC; t=rop-eop-cf; *rapw=t;
		LAZYCC3(rop,eop,cf,SBBW); LOOP;
    case 0x1C: IMMED8; CC; c=al; al-=(eoplo+cf);
		BLAZYCC3(c,eoplo,cf,SBBB); LOOP;
    case 0x1D: IMMED; CC; t= ax; ax-=(eop+cf);
		LAZYCC3(t,eop,cf,SBBW); LOOP;
    case 0x1E: PUSH(ds); LOOP;
    case 0x1F: POP(ds); LOOP;

    case 0x20: by(); c=eoplo&roplo; BSTORE(c); BSZONLY(c); LOOP;
    case 0x21: wd(); t=eop&rop; WSTORE(t); SZONLY(t); LOOP;
    case 0x22: by(); c=roplo&eoplo; *rapc=c; BSZONLY(c); LOOP;
    case 0x23: wd(); t=rop&eop; *rapw=t; SZONLY(t); LOOP;
    case 0x24: IMMED8; c=al&eoplo; al=c; BSZONLY(c); LOOP;
    case 0x25: IMMED; t= ax&eop; ax=t; SZONLY(t); LOOP;
    case 0x26: OVERRIDE(es); LOOP;
    case 0x27: notim(t);

    case 0x28: by(); c=eoplo-roplo; BSTORE(c); BLAZYCC(eoplo,roplo,SUBB); LOOP;
    case 0x29: wd(); t=eop-rop; WSTORE(t); LAZYCC(eop,rop,SUBW); LOOP;
    case 0x2A: by(); c=roplo-eoplo; *rapc=c; BLAZYCC(roplo,eoplo,SUBB); LOOP;
    case 0x2B: wd(); t=rop-eop; *rapw=t; LAZYCC(rop,eop,SUBW); LOOP;
    case 0x2C: IMMED8; c=al; al-=eoplo; BLAZYCC(c,eoplo,SUBB); LOOP;
    case 0x2D: IMMED; t= ax; ax-=eop; LAZYCC(t,eop,SUBW); LOOP;
    case 0x2E: OVERRIDE(cs); LOOP;
    case 0x2F: notim(t);

    case 0x30: by(); c=eoplo^roplo; BSTORE(c); BSZONLY(c); LOOP;
    case 0x31: wd(); t=eop^rop; WSTORE(t); SZONLY(t); LOOP;
    case 0x32: by(); c=roplo^eoplo; *rapc=c; BSZONLY(c); LOOP;
    case 0x33: wd(); t=rop^eop; *rapw=t; SZONLY(t); LOOP;
    case 0x34: IMMED8; c=al^eoplo; al=c; BSZONLY(c); LOOP;
    case 0x35: IMMED; t= ax^eop; ax=t; SZONLY(t); LOOP;
    case 0x36: OVERRIDE(ss); LOOP;
    case 0x37: notim(t);

    case 0x38: by(); BLAZYCC(eoplo,roplo,SUBB); LOOP;
    case 0x39: wd(); LAZYCC(eop,rop,SUBW); LOOP;
    case 0x3A: by(); BLAZYCC(roplo,eoplo,SUBB); LOOP;
    case 0x3B: wd(); LAZYCC(rop,eop,SUBW); LOOP;
    case 0x3C: IMMED8; BLAZYCC(al,eoplo,SUBB); LOOP;
    case 0x3D: IMMED; LAZYCC(ax,eop,SUBW); LOOP;
    case 0x3E: OVERRIDE(ds); LOOP;
    case 0x3F: notim(t);

    case 0x40: CC; t= ax; ax=t+1; LAZYCC(t,1,INCW); LOOP;
    case 0x41: CC; t= cx; cx=t+1; LAZYCC(t,1,INCW); LOOP;
    case 0x42: CC; t= dx; dx=t+1; LAZYCC(t,1,INCW); LOOP;
    case 0x43: CC; t= bx; bx=t+1; LAZYCC(t,1,INCW); LOOP;
    case 0x44: CC; t= sp; sp=t+1; LAZYCC(t,1,INCW); LOOP;
    case 0x45: CC; t= bp; bp=t+1; LAZYCC(t,1,INCW); LOOP;
    case 0x46: CC; t= si; si=t+1; LAZYCC(t,1,INCW); LOOP;
    case 0x47: CC; t= di; di=t+1; LAZYCC(t,1,INCW); LOOP;

    case 0x48: CC; t= ax; ax=t-1; LAZYCC(t,1,DECW); LOOP;
    case 0x49: CC; t= cx; cx=t-1; LAZYCC(t,1,DECW); LOOP;
    case 0x4A: CC; t= dx; dx=t-1; LAZYCC(t,1,DECW); LOOP;
    case 0x4B: CC; t= bx; bx=t-1; LAZYCC(t,1,DECW); LOOP;
    case 0x4C: CC; t= sp; sp=t-1; LAZYCC(t,1,DECW); LOOP;
    case 0x4D: CC; t= bp; bp=t-1; LAZYCC(t,1,DECW); LOOP;
    case 0x4E: CC; t= si; si=t-1; LAZYCC(t,1,DECW); LOOP;
    case 0x4F: CC; t= di; di=t-1; LAZYCC(t,1,DECW); LOOP;

    case 0x50: PUSH(ax); LOOP;
    case 0x51: PUSH(cx); LOOP;
    case 0x52: PUSH(dx); LOOP;
    case 0x53: PUSH(bx); LOOP;
    case 0x54: t=sp; PUSH(t); LOOP;
    case 0x55: PUSH(bp); LOOP;
    case 0x56: PUSH(si); LOOP;
    case 0x57: PUSH(di); LOOP;

    case 0x58: POP(ax); LOOP;
    case 0x59: POP(cx); LOOP;
    case 0x5A: POP(dx); LOOP;
    case 0x5B: POP(bx); LOOP;
    case 0x5C: POP(t); sp=t; LOOP;
    case 0x5D: POP(bp); LOOP;
    case 0x5E: POP(si); LOOP;
    case 0x5F: POP(di); LOOP;

    case 0x60:
    case 0x61:
    case 0x62:
    case 0x63:
    case 0x64:
    case 0x65:
    case 0x66:
    case 0x67: spare(t);

    case 0x68: IMMED; PUSH(eop); LOOP;
    case 0x69: spare(t);
    case 0x6A: IMMED8X; PUSH(eop); LOOP;
    case 0x6B:
    case 0x6C:
    case 0x6D:
    case 0x6E:
    case 0x6F: spare(t);

    case 0x70: IMMED8X; CC; if (ovf > 0) pcx += eop; LOOP;
    case 0x71: IMMED8X; CC; if (ovf == 0) pcx += eop; LOOP;
    case 0x72: IMMED8X; CC; if (cf > 0) pcx += eop; LOOP;
    case 0x73: IMMED8X; CC; if (cf == 0) pcx += eop; LOOP;
    case 0x74: IMMED8X; CC; if (zerof > 0) pcx += eop; LOOP;
    case 0x75: IMMED8X; CC; if (zerof == 0) pcx += eop; LOOP;
    case 0x76: IMMED8X; CC; if (cf+zerof > 0) pcx += eop; LOOP;
    case 0x77: IMMED8X; CC; if (cf+zerof == 0) pcx += eop; LOOP;

    case 0x78: IMMED8X; CC; if (signf > 0) pcx += eop; LOOP;
    case 0x79: IMMED8X; CC; if (signf == 0) pcx += eop; LOOP;
    case 0x7A:
    case 0x7B: notim(t);
    case 0x7C: IMMED8X; CC; if (signf != ovf) pcx += eop; LOOP;
    case 0x7D: IMMED8X; CC; if (signf == ovf) pcx += eop; LOOP;
    case 0x7E: IMMED8X; CC; if (zerof > 0 || signf != ovf) pcx += eop; LOOP;
    case 0x7F: IMMED8X; CC; if (zerof == 0 && signf == ovf) pcx += eop; LOOP;

    case 0x80: by(); 
	switch(ra) {		/* this opcode splits on reg field (in ra) */
	    case B00: BRMCONST; c=eoplo+roplo; BSTORE(c);
			BLAZYCC(eoplo,roplo,ADDB); LOOP;
	    case B01: BRMCONST; c=eoplo|roplo; BSTORE(c); BSZONLY(c); LOOP;
	    case B02: BRMCONST; CC; c=eoplo+roplo+cf; BSTORE(c);
			BLAZYCC3(eoplo,roplo,cf,ADCB); LOOP;
	    case B03: BRMCONST; CC; c=eoplo-roplo-cf; BSTORE(c);
			BLAZYCC3(eoplo,roplo,cf,SBBB); LOOP;
	    case B04: BRMCONST; c=eoplo&roplo; BSTORE(c); BSZONLY(c); LOOP;
	    case B05: BRMCONST; c=eoplo-roplo; BSTORE(c);
			BLAZYCC(eoplo,roplo,SUBB); LOOP;
	    case B06: BRMCONST; c=eoplo^roplo; BSTORE(c); BSZONLY(c); LOOP;
	    case B07: BRMCONST; BLAZYCC(eoplo,roplo,SUBB); LOOP;
	}

    case 0x81: wd(); 
	switch(ra) {		/* this opcode splits on reg field (in ra) */
	    case W00: RMCONST; t=eop+rop; WSTORE(t); LAZYCC(eop,rop,ADDW); LOOP;
	    case W01: RMCONST; t=eop|rop; WSTORE(t); SZONLY(t); LOOP;
	    case W02: RMCONST; CC; t=eop+rop+cf; WSTORE(t);
			LAZYCC3(eop,rop,cf,ADCW); LOOP;
	    case W03: RMCONST; CC; t=eop-rop-cf; WSTORE(t);
			LAZYCC3(eop,rop,cf,SBBW); LOOP;
	    case W04: RMCONST; t=eop&rop; WSTORE(t); SZONLY(t); LOOP;
	    case W05: RMCONST; t=eop-rop; WSTORE(t); LAZYCC(eop,rop,SUBW); LOOP;
	    case W06: RMCONST; t=eop^rop; WSTORE(t); SZONLY(t); LOOP;
	    case W07: RMCONST; LAZYCC(eop,rop,SUBW); LOOP;
	}

    case 0x82: by(); 
	switch(ra) {		/* this opcode splits on reg field (in ra) */
	    case B00: BRMCONST; c=eoplo+roplo; BSTORE(c); BLAZYCC(eoplo,roplo,ADDB); LOOP;
	    case B01: spare(t);
	    case B02: BRMCONST; CC; c=eoplo+roplo+cf; BSTORE(c);
			BLAZYCC3(eoplo,roplo,cf,ADCB); LOOP;
	    case B03: BRMCONST; CC; c=eoplo-roplo-cf; BSTORE(c);
			BLAZYCC3(eoplo,roplo,cf,SBBB); LOOP;
	    case B04: spare(t);
	    case B05: BRMCONST; c=eoplo-roplo; BSTORE(c);
			BLAZYCC(eoplo,roplo,SUBB); LOOP;
	    case B06: spare(t);
	    case B07: RMCONST; BLAZYCC(eoplo,roplo,SUBB); LOOP;
	}

    case 0x83: wd(); 
	switch(ra) {		/* this opcode splits on reg field (in ra) */
	    case W00: XRMCONST; t=eop+rop; WSTORE(t);
			LAZYCC(eop,rop,ADDW); LOOP;
	    case W01: XRMCONST; t=eop|rop; WSTORE(t); SZONLY(t); LOOP;
	    case W02: XRMCONST; CC; t=eop+rop+cf; WSTORE(t);
			LAZYCC3(eop,rop,cf,ADCW); LOOP;
	    case W03: XRMCONST; CC; t=eop-rop-cf; WSTORE(t);
			LAZYCC3(eop,rop,cf,SBBW); LOOP;
	    case W04: XRMCONST; t=eop&rop; WSTORE(t); SZONLY(t); LOOP;
	    case W05: XRMCONST; t=eop-rop; WSTORE(t);
			LAZYCC(eop,rop,SUBW); LOOP;
	    case W06: XRMCONST; t=eop^rop; WSTORE(t); SZONLY(t); LOOP;
	    case W07: XRMCONST; LAZYCC(eop,rop,SUBW); LOOP;
	}

    case 0x84: by(); c=eoplo&roplo; BSZONLY(c); LOOP;
    case 0x85: wd(); SZONLY(eop&rop); LOOP;
    case 0x86: by(); BSTORE(roplo); *rapc=eoplo; LOOP;
    case 0x87: wd(); WSTORE(rop); *rapw=eop; LOOP;

    case 0x88: by(); BSTORE(roplo); LOOP;
    case 0x89: wd(); WSTORE(rop); LOOP;
    case 0x8A: by(); *rapc = eoplo; LOOP;
    case 0x8B: wd(); *rapw = eop; LOOP;
    case 0x8C: wd();
	switch(ra) {
	    case W00: WSTORE(es); LOOP;
	    case W01: WSTORE(cs); LOOP;
	    case W02: WSTORE(ss); LOOP;
	    case W03: WSTORE(ds); LOOP;
	    default:  spare(t);
	}

    case 0x8D: wd(); *rapw = ea; LOOP;
    case 0x8E: wd();
	switch(ra) {		/* this opcode splits on reg field (in ra) */
	    case W00: es=eop; LOOP;
	    case W01: CS(eop); LOOP;
	    case W02: ss=eop; LOOP;
	    case W03: ds=eop; LOOP;
	    default:  spare(t);
	}

    case 0x8F: wd(); POP(t); WSTORE(t); LOOP;	/* some spares treated as POP */

    case 0x90: LOOP;
    case 0x91: t= ax; ax= cx; cx=t; LOOP;
    case 0x92: t= ax; ax= dx; dx=t; LOOP;
    case 0x93: t= ax; ax= bx; bx=t; LOOP;
    case 0x94: t= ax; ax= sp; sp=t; LOOP;
    case 0x95: t= ax; ax= bp; bp=t; LOOP;
    case 0x96: t= ax; ax= si; si=t; LOOP;
    case 0x97: t= ax; ax= di; di=t; LOOP;
    /*case 0x98: ah = (al < 0 ? 0xFF : 0); LOOP;*/
    case 0x98: /*prut(ah,al);*/ ah = ( (al & 0X80) ? 0xFF : 0); LOOP;
    case 0x99: dx = (ax < 0 ? 0xFFFF : 0); LOOP;
    case 0x9A: IMMED; RMCONST; PUSH(cs); PUSH(PC); CS(rop);
		    CSMEM(pcx,eop); if(traceflag) procdepth(1); LOOP;
    case 0x9B: timer=1; if (!(intstruct[nextint].int_status&ENABLED)) pcx--;
		LOOP;
    case 0x9C: FLAGWD(eop); PUSH(eop); LOOP;
    case 0x9D: POP(t); LOADFLAGS(t); LOOP;
    case 0x9E: CC;t=ah; signf=(t>>7)&1; zerof=(t>>6)&1; cf=t&1; LOOP;
    case 0x9F: CC; ah= (signf<<7) + (zerof<<6) + cf; LOOP;

    case 0xA0: IMMED; MEM(xapc,ds,eop); al= *xapc; LOOP;
    case 0xA1: IMMED; MEM(xapc,ds,eop); al= *xapc++; ah= *xapc++; LOOP;
    case 0xA2: IMMED; MEM(xapc,ds,eop); *xapc=al; LOOP;
    case 0xA3: IMMED; MEM(eapc,ds,eop); WSTORE(ax); LOOP;
    case 0xA4: rep(0xA4); LOOP;
    case 0xA5: rep(0xA5); LOOP;
    case 0xA6: rep(0xA6); LOOP;
    case 0xA7: rep(0xA7); LOOP;

    case 0xA8: IMMED8; c=al&eoplo; BSZONLY(c); LOOP;
    case 0xA9: IMMED; SZONLY(ax&eop); LOOP;
    case 0xAA: rep(0xAA); LOOP;
    case 0xAB: rep(0xAB); LOOP;
    case 0xAC: rep(0xAC); LOOP;
    case 0xAD: rep(0xAD); LOOP;
    case 0xAE: rep(0xAE); LOOP;
    case 0xAF: rep(0xAF); LOOP;

    case 0xB0: al= *pcx++; LOOP;
    case 0xB1: cl= *pcx++; LOOP;
    case 0xB2: dl= *pcx++; LOOP;
    case 0xB3: bl= *pcx++; LOOP;
    case 0xB4: ah= *pcx++; LOOP;
    case 0xB5: ch= *pcx++; LOOP;
    case 0xB6: dh= *pcx++; LOOP;
    case 0xB7: bh= *pcx++; LOOP;

    case 0xB8: al= *pcx++; ah= *pcx++; LOOP;
    case 0xB9: cl= *pcx++; ch= *pcx++; LOOP;
    case 0xBA: dl= *pcx++; dh= *pcx++; LOOP;
    case 0xBB: bl= *pcx++; bh= *pcx++; LOOP;
    case 0xBC: IMMED; sp = eop; LOOP;
    case 0xBD: IMMED; bp = eop; LOOP;
    case 0xBE: IMMED; si = eop; LOOP;
    case 0xBF: IMMED; di = eop; LOOP;

    case 0xC0:
    case 0xC1: spare(t);
    case 0xC2: if(traceflag) procdepth(-1); IMMED; POP(t);
		CSMEM(pcx,t); sp += eop; LOOP;
    case 0xC3: if(traceflag) procdepth(-1); POP(t); CSMEM(pcx,t);
                 LOOP;
    case 0xC4: wd(); *rapw= eop; eapc+=2; WFETCH; es=eop; LOOP;
    case 0xC5: wd(); *rapw= eop; eapc+=2; WFETCH; ds=eop; LOOP;
    case 0xC6: by(); BSTORE(*pcx++); LOOP;	/* subopcodes ignored */
    case 0xC7: wd(); MOV16; LOOP;	/* subopcodes ignored */

    case 0xC8:
    case 0xC9: spare(t);
    case 0xCA: if(traceflag) procdepth(-1); IMMED; POP(t); POP(t2);
		CS(t2); CSMEM(pcx,t); sp+=eop; LOOP;
    case 0xCB: if(traceflag) procdepth(-1); POP(t); POP(t2); CS(t2);
		CSMEM(pcx,t); LOOP;
    case 0xCC: if(traceflag) procdepth(1); panic("int 3 executed.");
		interrupt(3); LOOP;
    case 0xCD: if(traceflag) procdepth(1); IMMED8Z; interrupt(eop); LOOP;
    case 0xCE: if(traceflag) procdepth(1); CC; if (ovf) interrupt(4); CC; LOOP;
    case 0xCF: if(traceflag) procdepth(-1); POP(t); POP(t2); CS(t2); POP(eop);
		CSMEM(pcx,t); LOADFLAGS(eop); if (intf) checkint(); LOOP;

    case 0xD0: by(); CC;
	switch(ra) {		/* this opcode splits on reg field (in ra) */
	    case B00: BITSEL(cf,7,t,6); BSTORE(eoplo+eoplo+cf);
			ovf=(cf+t)&1; LOOP;
	    case B01: BITSEL(cf,0,t,7); BSTORE(((eoplo>>1)&0177) | (cf<<7));
			ovf=(cf+t)&1; LOOP;
	    case B02: BITSEL(n,7,t,6); BSTORE(eoplo+eoplo+cf); cf=n;
			ovf=(n+t)&1;LOOP;
	    case B03: BITSEL(n,7,t,0); BSTORE(((eoplo>>1)&0177)|(cf<<7));
			ovf=(cf+n)&1; cf=t; LOOP;
	    case B04: BITSEL(cf,7,t,6); BSTORE(eoplo+eoplo); ovf=(cf+t)&1; LOOP;
	    case B05: BITSEL(cf,0,ovf,7); BSTORE(((eoplo>>1)&0177)); LOOP;
	    case B06: spare(t);
	    case B07: BITSEL(cf,0,t,7); BSTORE(((eoplo>>1)&0177) | (t<<7));
			ovf=0; LOOP;
	}

    case 0xD1: wd(); CC;
	switch(ra) {		/* this opcode splits on reg field (in ra) */
	    case W00: BITSEL(cf,15,t,14); eop+=eop+cf;
			WSTORE(eop); ovf=(cf+t)&1; LOOP;
	    case W01: BITSEL(cf,0,t,15); eop=((eop>>1)&077777) | (cf<<15);
			WSTORE(eop); ovf=(cf+t)&1; LOOP;
	    case W02: BITSEL(n,15,t,14); eop+=eop+cf;cf=n;
			WSTORE(eop);ovf=(n+t)&1;LOOP;
	    case W03: BITSEL(n,15,t,0); eop=((eop>>1)&077777)|(cf<<15);
			WSTORE(eop); ovf=(cf+n)&1; cf=t; LOOP;
	    case W04: BITSEL(cf,15,t,14); eop+=eop;
			WSTORE(eop); ovf=(cf+t)&1; LOOP;
	    case W05: BITSEL(cf,0,ovf,15); eop=((eop>>1)&077777);
			WSTORE(eop); LOOP;
	    case W06: spare(t);
	    case W07: BITSEL(cf,0,t,15); eop=((eop>>1)&077777) | (t<<15);
			WSTORE(eop); ovf=0; LOOP;
	}

    case 0xD2: by(); CC;
	switch(ra) {		/* this opcode splits on reg field (in ra) */
	    case B00: n=cl; while(n--){
		    BITSEL(cf,7,t,6); eop+=eop+cf;} BSTORE(eoplo); LOOP;
	    case B01: n=cl; while(n--) {BITSEL(cf,0,t,7); 
		    eoplo=((eoplo>>1)&0177) | (cf<<7);} BSTORE(eoplo); LOOP;
	    case B02: n=cl; while(n--) {BITSEL(t,7,mm,6);
		    eop+=eop+cf; cf=t;} BSTORE(eoplo); LOOP;
	    case B03: n=cl; while(n--) {BITSEL(mm,7,t,0);
		    eoplo=((eoplo>>1)&0177)|(cf<<7); cf=t;} BSTORE(eoplo); LOOP;
	    case B04: n=cl; while(n--){
		    BITSEL(cf,7,t,6); eop+=eop;} BSTORE(eoplo); LOOP;
	    case B05: n=cl;
		    while(n--) { BITSEL(cf,0,t,7); eoplo=((eoplo>>1)&0177); }
		    BSTORE(eoplo); LOOP;
	    case B06: spare(t);
	    case B07: n=cl;
		    while(n--) {BITSEL(cf,0,t,7);
				eoplo=((eoplo>>1)&0177) | (t<<7);}
		    BSTORE(eoplo); ovf=0; LOOP;
	}

    case 0xD3: wd(); CC;
	switch(ra) {		/* this opcode splits on reg field (in ra) */
	    case W00: n=cl; while(n--) {
		    BITSEL(cf,15,t,14); eop+=eop+cf;} WSTORE(eop); LOOP;
	    case W01: n=cl; while(n--) {BITSEL(cf,0,t,15);
		    eop=((eop>>1)&077777) | (cf<<15);} WSTORE(eop); LOOP;
	    case W02: n=cl; while(n--) {BITSEL(t,15,mm,14);
		    eop+=eop+cf; cf=t;} WSTORE(eop); LOOP;
	    case W03: n=cl; while(n--) {BITSEL(mm,15,t,0); 
		    eop=((eop>>1)&077777) | (cf<<15); cf=t;} WSTORE(eop); LOOP;
	    case W04: n=cl; while(n--) {
		    BITSEL(cf,15,t,14); eop+=eop;} WSTORE(eop); LOOP;
	    case W05: n=cl;
		    while(n--) {BITSEL(cf,0,t,15); eop=((eop>>1)&077777);}
		    WSTORE(eop); LOOP;
	    case W06: spare(t);
	    case W07: n=cl;
		    while(n--) {BITSEL(cf,0,t,15);
				eop=((eop>>1)&077777) | (t<<15);}
		    WSTORE(eop); ovf=0; LOOP;
	}

    case 0xD4:
    case 0xD5: notim(t);
    case 0xD6: spare(t);
    case 0xD7: eoplo=al; eophi=0; eop+= bx; MEM(eapc,ds,eop);
		BFETCH; al=eoplo; LOOP;
    case 0xD8: notim(t);

    case 0xD9:
    case 0xDA:
    case 0xDB:
    case 0xDC:
    case 0xDD:
    case 0xDE:
    case 0xDF: spare(t);

    case 0xE0: IMMED8X; CC; if ( (cx -=1) != 0 && zerof == 0) pcx+=eop; LOOP;
    case 0xE1: IMMED8X; CC; if ( (cx -=1) != 0 && zerof > 0) pcx+=eop; LOOP;
    case 0xE2: IMMED8X; if ( (cx -=1) != 0) pcx+=eop; LOOP;
    case 0xE3: IMMED8X; if (cx == 0) pcx+=eop; LOOP;
    case 0xE4: IMMED8Z; inio(eop,1); LOOP;
    case 0xE5: IMMED8Z; inio(eop,2); LOOP;
    case 0xE6: IMMED8Z; roplo=al; rophi=0; outio(eop,rop,1); LOOP;
    case 0xE7: IMMED8Z; outio(eop,ax,2); LOOP;
    case 0xE8: if(traceflag) procdepth(1); IMMED; t=PC; PUSH(t);
		CSMEM(pcx,t+eop); LOOP;
    case 0xE9: IMMED; t=PC+eop; CSMEM(pcx,t); LOOP;	/*careful: wraparound */
    case 0xEA: IMMED; roplo= *pcx++; rophi= *pcx++; CS(rop); CSMEM(pcx,eop); LOOP;
    case 0xEB: IMMED8X; t=PC+eop; CSMEM(pcx,t); LOOP;	/* wraparound */
    case 0xEC: inio(dx,1); LOOP;
    case 0xED: inio(dx,2); LOOP;
    case 0xEE: eoplo=al; eophi=0;  outio(dx,eop,1); LOOP;
    case 0xEF: outio(dx,ax,2); LOOP;

    case 0xF0: breakpt(); t = dumpt; goto bloop; /* ew break point trap */
	 /* vidsim(); LOOP;	dirty trick to trap video ram access */
    case 0xF1: spare(t);
    case 0xF2: t = *pcx++ & mask;
	switch(t) {
	    case 0xA4:
	/*	if (timer > (unsigned) cx) {
		    /* No interrupt during this instruction * /
		    timer -= cx;
	*/	    STRING; t=1-dirf-dirf; n= cx;
		    while(cx) {BSTORE(*xapc); eapc+=t; xapc+=t; (cx)--;} 
		    si += n*t;  di += n*t;
	/*	} else {
		    /* Interrupt this instruction. * /
		    k = cx - (timer - 1);
		    cx = timer - 1;
		    STRING; t=1-dirf-dirf; n= cx;
		    while(cx) {BSTORE(*xapc); eapc+=t; xapc+=t; (cx)--;} 
		    si += n*t;  di += n*t;
		    cx = k;
		    pcx -= 2;
		    timer = 1;
	       }
	*/       LOOP;
	    case 0xA5:
	/*	if (timer > (unsigned) cx) {
		    timer -= cx;
	*/	    STRING; t=2*(1-dirf-dirf); n= cx;
		    while(cx) {XSTORE(xapc); eapc+=t; xapc+=t; (cx)--; }
		    si += n*t;  di += n*t;
	/*       } else {
		    k = cx - (timer - 1);
		    cx = timer - 1;
		    STRING; t=2*(1-dirf-dirf); n= cx;
		    while(cx) {XSTORE(xapc); eapc+=t; xapc+=t; (cx)--; }
		    si += n*t;  di += n*t;
		    cx = k;
		    pcx -= 2;
		    timer = 1;
	       }
	*/       LOOP;
	    case 0xA6:
	    case 0xA7:
	    case 0xAE: while(cx) {rep(t); CC; (cx)--; if (zerof != 0) LOOP;}
			LOOP;
	    case 0xAA:
	    case 0xAB:
	    case 0xAC:
	    case 0xAD: while(cx) {rep(t); (cx)--;} LOOP;
	    case 0xAF: while( (cx)-- ) {rep(t); CC; if (zerof != 0) LOOP;} LOOP;
	    default: panic("REP followed by nonstring operator.");
	}

    case 0xF3: t = *pcx++ & mask;
	switch(t) {
	    case 0xA4:
	/*	if (timer > (unsigned) cx) {
		    /* No interrupt during this instruction * /
		    timer -= cx;
	*/	    STRING; t=1-dirf-dirf; n= cx;
		    while(cx) {BSTORE(*xapc); eapc+=t; xapc+=t; (cx)--;} 
		    si += n*t;  di += n*t;
	/*	} else {
		    /* Interrupt this instruction. * /
		    k = cx - (timer - 1);
		    cx = timer - 1;
		    STRING; t=1-dirf-dirf; n= cx;
		    while(cx) {BSTORE(*xapc); eapc+=t; xapc+=t; (cx)--;} 
		    si += n*t;  di += n*t;
		    cx = k;
		    pcx -= 2;
		    timer = 1;
	       }
	*/       LOOP;
	    case 0xA5:
	/*	if (timer > (unsigned) cx) {
		    timer -= cx;
	*/	    STRING; t=2*(1-dirf-dirf); n= cx;
		    while(cx) {XSTORE(xapc); eapc+=t; xapc+=t; (cx)--; }
		    si += n*t;  di += n*t;
	/*       } else {
		    k = cx - (timer - 1);
		    cx = timer - 1;
		    STRING; t=2*(1-dirf-dirf); n= cx;
		    while(cx) {XSTORE(xapc); eapc+=t; xapc+=t; (cx)--; }
		    si += n*t;  di += n*t;
		    cx = k;
		    pcx -= 2;
		    timer = 1;
	       }
	*/       LOOP;
	    case 0xA6:
	    case 0xA7:
	    case 0xAE:
	    case 0xAF: while( (cx)-- ) {rep(t); CC; if (zerof == 0) LOOP;} LOOP;

	    case 0xAA:
	    case 0xAB:
	    case 0xAC:
	    case 0xAD: while( (cx)-- ) {rep(t);} LOOP;
	    default: panic("REP followed by nonstring operator.");
	}

    case 0xF4: printf("Halt instruction executed.  End of run.\n"); 
	    write(2,"Normal exit\n",12); stat(); exit(0);
    case 0xF5: CC; cf=cf^1; LOOP;
    case 0xF6: by();
	switch(ra) {		/* this opcode splits on reg field (in ra) */
	    case B00: BRMCONST; c=eoplo&roplo; BSZONLY(c); LOOP;
	    case B01: spare(t);
	    case B02: BSTORE(~eoplo); LOOP;
	    case B03: c= 0-eoplo; BSTORE(c); BLAZYCC(0,eoplo,SUBB); LOOP;
	    case B04: u1=(unchr)al; u2=(unchr)eoplo; u=u1*u2;ax=u;
		    cf=(u<256 ? 0 : 1); ovf=cf; ccvalid=1; LOOP;
	    case B05: t=(short)al; n=(short)eoplo; ax=t*n;
		    /*cf=((al>=0&&ah==0)||(al<0&&ah==0xFF)?0:1);*/
		    cf=(((!(al&0X80))&&ah==0)||((al&0X80)&&ah==0xFF)?0:1);
			 ovf=cf; ccvalid=1;LOOP;
	    case B06: u1=(adr)ax; u2=(adr)eoplo; u=u1/u2; al=(char)u;
		    if(u>255)interrupt(0); else ah=(char)(u1%u2); LOOP;
	    case B07: t=ax; n=(short)eoplo; mm=t/n; al=(char)mm;
		    if(mm>127||mm<-128)interrupt(0); 
		    else ah=(char)(t-mm*n); LOOP;
	}

    case 0xF7: wd();
	switch(ra) {		/* this opcode splits on reg field (in ra) */
	    case W00: RMCONST; SZONLY(eop&rop); LOOP;
	    case W01: spare(t);
	    case W02: WSTORE((~eop)); LOOP;
	    case W03: t= 0-eop; WSTORE(t); LAZYCC(0,eop,SUBW); LOOP;
	    case W04: l1=(adr)ax; l2=(adr)eop; l1=l1*l2; ax=(short)l1;
		    dx= (l1>>16)&0177777;
		    cf=(l1<65536 ? 0 : 1); ovf=cf; ccvalid=1; LOOP;
	    case W05: l1= ax; l2= eop; l1=l1*l2; ax=(short)l1;
		    dx= (l1>>16)&0177777;
		    cf=(l1<65536 ? 0 : 1); ovf=cf; ccvalid=1; LOOP;
	    case W06: if (dx<0)
			panic("simulator can't handle dividends >=2**31");
			/* {printf("simulator can't handle dividends >=2**31\n");
			    abort();}*/
		    l1=(adr)dx; l1=(l1<<16)+(adr)ax; l2=(adr)eop;
		    l=l1/l2; ax=(short)l;
		    if (l>65535||l<-65535)interrupt(0); else dx=l1%l2; LOOP;
	    case W07: l1=(adr)dx; l1=(l1<<16)+(adr)ax; l2=eop; l=l1/l2;
		    /*ax=(short)l;if (l>65535||l<-65535)interrupt(0);*/
		    ax=(short)l;if (l>32767||l<-32767)interrupt(0);
		    else dx=l1%l2; LOOP;
	}

    case 0xF8: CC; cf=0; LOOP;
    case 0xF9: CC; cf=1; LOOP;
    case 0xFA: intf=0; LOOP;
    case 0xFB: intf=1; checkint(); LOOP;
    case 0xFC: dirf=0; LOOP;
    case 0xFD: dirf=1; LOOP;
    case 0xFE: by();
	switch(ra) {		/* this opcode splits on reg field (in ra) */
	    case B00: CC; c=eoplo; BSTORE(c+1); BLAZYCC(c,1,INCB); LOOP;
	    case B01: CC; c=eoplo; BSTORE(c-1); BLAZYCC(c,1,DECB); LOOP;
	    default: spare(t);
	}

    case 0xFF: wd();
	switch(ra) {		/* this opcode splits on reg field (in ra) */
	    case W00: CC; t=eop; WSTORE(t+1); LAZYCC(t,1,INCW); LOOP;
	    case W01: CC; t=eop; WSTORE(t-1); LAZYCC(t,1,DECW); LOOP;
	    case W02: if(traceflag) procdepth(2); t=PC; PUSH(t); CSMEM(pcx,eop);
			LOOP;
	    case W03: if(traceflag) procdepth(2); PUSH(cs); PUSH(PC); t=eop;
			eapc+=2; WFETCH; CS(eop); CSMEM(pcx,t);
			LOOP;
	    case W04: CSMEM(pcx,eop); LOOP;
	    case W05: notim(t);	/* can't figure out which comes first, cs or off */
	    case W06: PUSH(eop); LOOP;
	    case W07: spare(t);
	}

    default: panic("Error.  bad opcode %x \n", --*pcx);
    /*default: printf("Error.  bad opcode %x \n", --*pcx); dump(); abort();*/
    }
}

rep(op)
register int op;
{
/* The string instructions (MOVS, CMPS, STOS, LODS, and SCAS are done here. */
  char c;

  switch(op) {
    case 0xA4: STRING; BSTORE(*xapc); BSIDI; return;
    case 0xA5: STRING; BSTORE(*xapc++); eapc++; BSTORE(*xapc); WSIDI; return;
    case 0xA6: STRING; BFETCH; BSIDI; BLAZYCC(*xapc,eoplo,SUBB); return;
    case 0xA7: STRING; WFETCH; roplo= *xapc++; rophi= *xapc; WSIDI; 
    		LAZYCC(rop,eop,SUBW); return;
    case 0xAA: MEM(eapc,es,di); BSTORE(al); BDIRF(di); return;
    case 0xAB: MEM(eapc,es,di); WSTORE(ax); WDIRF(di); return; 
    case 0xAC: MEM(xapc,ds,si); al= *xapc; BDIRF(si); return;
    case 0xAD: MEM(xapc,ds,si); al= *xapc++; ah= *xapc; WDIRF(si); return; 
    case 0xAE: MEM(eapc,es,di); BFETCH; c=al-eoplo; BDIRF(di);
		BLAZYCC(al,eoplo,SUBB); return;
    case 0xAF: MEM(eapc,es,di); WFETCH; WDIRF(di); 
		LAZYCC(ax,eop,SUBW); return;
  }
}


vidsim (){}
dumpck (){}
checkint (){}
inio (){}
outio (){}
