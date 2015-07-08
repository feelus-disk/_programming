#define EXTERN extern
#include "88.h"
#include "macro.h"

#define DS xs=ds		/* indicates that ds segment used */
#define SS xs=ss		/* indicates that ss segment used */

wd()
{
/* Compute the effective address and put it in 'ea'.
 * Also compute the register and put a pointer to it in 'rapc.'
 * This routine only called for word operands.
 */

    register	word	t;

    t = *pcx++ & mask;

    switch (t)
    {
	case 0x00: DS; ea = bx + si; ra = AX; break;
	case 0x01: DS; ea = bx + di; ra = AX; break;
	case 0x02: SS; ea = bp + si; ra = AX; break;
	case 0x03: SS; ea = bp + di; ra = AX; break;
	case 0x04: DS; ea = si; ra = AX; break;
	case 0x05: DS; ea = di; ra = AX; break;
	case 0x06: DS; ealo = *pcx++; eahi = *pcx++; ra = AX; break;
	case 0x07: DS; ea = bx; ra = AX; break;

	case 0x08: DS; ea = bx + si; ra = CX; break;
	case 0x09: DS; ea = bx + di; ra = CX; break;
	case 0x0A: SS; ea = bp + si; ra = CX; break;
	case 0x0B: SS; ea = bp + di; ra = CX; break;
	case 0x0C: DS; ea = si; ra = CX; break;
	case 0x0D: DS; ea = di; ra = CX; break;
	case 0x0E: DS; ealo = *pcx++; eahi = *pcx++; ra = CX; break;
	case 0x0F: DS; ea = bx; ra = CX; break;

	case 0x10: DS; ea = bx + si; ra = DX; break;
	case 0x11: DS; ea = bx + di; ra = DX; break;
	case 0x12: SS; ea = bp + si; ra = DX; break;
	case 0x13: SS; ea = bp + di; ra = DX; break;
	case 0x14: DS; ea = si; ra = DX; break;
	case 0x15: DS; ea = di; ra = DX; break;
	case 0x16: DS; ealo = *pcx++; eahi = *pcx++; ra = DX; break;
	case 0x17: DS; ea = bx; ra = DX; break;

	case 0x18: DS; ea = bx + si; ra = BX; break;
	case 0x19: DS; ea = bx + di; ra = BX; break;
	case 0x1A: SS; ea = bp + si; ra = BX; break;
	case 0x1B: SS; ea = bp + di; ra = BX; break;
	case 0x1C: DS; ea = si; ra = BX; break;
	case 0x1D: DS; ea = di; ra = BX; break;
	case 0x1E: DS; ealo = *pcx++; eahi = *pcx++; ra = BX; break;
	case 0x1F: DS; ea = bx; ra = BX; break;

	case 0x20: DS; ea = bx + si; ra = SP; break;
	case 0x21: DS; ea = bx + di; ra = SP; break;
	case 0x22: SS; ea = bp + si; ra = SP; break;
	case 0x23: SS; ea = bp + di; ra = SP; break;
	case 0x24: DS; ea = si; ra = SP; break;
	case 0x25: DS; ea = di; ra = SP; break;
	case 0x26: DS; ealo = *pcx++; eahi = *pcx++; ra = SP; break;
	case 0x27: DS; ea = bx; ra = SP; break;

	case 0x28: DS; ea = bx + si; ra = BP; break;
	case 0x29: DS; ea = bx + di; ra = BP; break;
	case 0x2A: SS; ea = bp + si; ra = BP; break;
	case 0x2B: SS; ea = bp + di; ra = BP; break;
	case 0x2C: DS; ea = si; ra = BP; break;
	case 0x2D: DS; ea = di; ra = BP; break;
	case 0x2E: DS; ealo = *pcx++; eahi = *pcx++; ra = BP; break;
	case 0x2F: DS; ea = bx; ra = BP; break;

	case 0x30: DS; ea = bx + si; ra = SI; break;
	case 0x31: DS; ea = bx + di; ra = SI; break;
	case 0x32: SS; ea = bp + si; ra = SI; break;
	case 0x33: SS; ea = bp + di; ra = SI; break;
	case 0x34: DS; ea = si; ra = SI; break;
	case 0x35: DS; ea = di; ra = SI; break;
	case 0x36: DS; ealo = *pcx++; eahi = *pcx++; ra = SI; break;
	case 0x37: DS; ea = bx; ra = SI; break;

	case 0x38: DS; ea = bx + si; ra = DI; break;
	case 0x39: DS; ea = bx + di; ra = DI; break;
	case 0x3A: SS; ea = bp + si; ra = DI; break;
	case 0x3B: SS; ea = bp + di; ra = DI; break;
	case 0x3C: DS; ea = si; ra = DI; break;
	case 0x3D: DS; ea = di; ra = DI; break;
	case 0x3E: DS; ealo = *pcx++; eahi = *pcx++; ra = DI; break;
	case 0x3F: DS; ea = bx; ra = DI; break;

	case 0x40: DS; DISP8; ea += bx + si; ra = AX; break;
	case 0x41: DS; DISP8; ea += bx + di; ra = AX; break;
	case 0x42: SS; DISP8; ea += bp + si; ra = AX; break;
	case 0x43: SS; DISP8; ea += bp + di; ra = AX; break;
	case 0x44: DS; DISP8; ea += si; ra = AX; break;
	case 0x45: DS; DISP8; ea += di; ra = AX; break;
	case 0x46: SS; DISP8; ea += bp; ra = AX; break;
	case 0x47: DS; DISP8; ea += bx; ra = AX; break;

	case 0x48: DS; DISP8; ea += bx + si; ra = CX; break;
	case 0x49: DS; DISP8; ea += bx + di; ra = CX; break;
	case 0x4A: SS; DISP8; ea += bp + si; ra = CX; break;
	case 0x4B: SS; DISP8; ea += bp + di; ra = CX; break;
	case 0x4C: DS; DISP8; ea += si; ra = CX; break;
	case 0x4D: DS; DISP8; ea += di; ra = CX; break;
	case 0x4E: SS; DISP8; ea += bp; ra = CX; break;
	case 0x4F: DS; DISP8; ea += bx; ra = CX; break;

	case 0x50: DS; DISP8; ea += bx + si; ra = DX; break;
	case 0x51: DS; DISP8; ea += bx + di; ra = DX; break;
	case 0x52: SS; DISP8; ea += bp + si; ra = DX; break;
	case 0x53: SS; DISP8; ea += bp + di; ra = DX; break;
	case 0x54: DS; DISP8; ea += si; ra = DX; break;
	case 0x55: DS; DISP8; ea += di; ra = DX; break;
	case 0x56: SS; DISP8; ea += bp; ra = DX; break;
	case 0x57: DS; DISP8; ea += bx; ra = DX; break;

	case 0x58: DS; DISP8; ea += bx + si; ra = BX; break;
	case 0x59: DS; DISP8; ea += bx + di; ra = BX; break;
	case 0x5A: SS; DISP8; ea += bp + si; ra = BX; break;
	case 0x5B: SS; DISP8; ea += bp + di; ra = BX; break;
	case 0x5C: DS; DISP8; ea += si; ra = BX; break;
	case 0x5D: DS; DISP8; ea += di; ra = BX; break;
	case 0x5E: SS; DISP8; ea += bp; ra = BX; break;
	case 0x5F: DS; DISP8; ea += bx; ra = BX; break;

	case 0x60: DS; DISP8; ea += bx + si; ra = SP; break;
	case 0x61: DS; DISP8; ea += bx + di; ra = SP; break;
	case 0x62: SS; DISP8; ea += bp + si; ra = SP; break;
	case 0x63: SS; DISP8; ea += bp + di; ra = SP; break;
	case 0x64: DS; DISP8; ea += si; ra = SP; break;
	case 0x65: DS; DISP8; ea += di; ra = SP; break;
	case 0x66: SS; DISP8; ea += bp; ra = SP; break;
	case 0x67: DS; DISP8; ea += bx; ra = SP; break;

	case 0x68: DS; DISP8; ea += bx + si; ra = BP; break;
	case 0x69: DS; DISP8; ea += bx + di; ra = BP; break;
	case 0x6A: SS; DISP8; ea += bp + si; ra = BP; break;
	case 0x6B: SS; DISP8; ea += bp + di; ra = BP; break;
	case 0x6C: DS; DISP8; ea += si; ra = BP; break;
	case 0x6D: DS; DISP8; ea += di; ra = BP; break;
	case 0x6E: SS; DISP8; ea += bp; ra = BP; break;
	case 0x6F: DS; DISP8; ea += bx; ra = BP; break;

	case 0x70: DS; DISP8; ea += bx + si; ra = SI; break;
	case 0x71: DS; DISP8; ea += bx + di; ra = SI; break;
	case 0x72: SS; DISP8; ea += bp + si; ra = SI; break;
	case 0x73: SS; DISP8; ea += bp + di; ra = SI; break;
	case 0x74: DS; DISP8; ea += si; ra = SI; break;
	case 0x75: DS; DISP8; ea += di; ra = SI; break;
	case 0x76: SS; DISP8; ea += bp; ra = SI; break;
	case 0x77: DS; DISP8; ea += bx; ra = SI; break;

	case 0x78: DS; DISP8; ea += bx + si; ra = DI; break;
	case 0x79: DS; DISP8; ea += bx + di; ra = DI; break;
	case 0x7A: SS; DISP8; ea += bp + si; ra = DI; break;
	case 0x7B: SS; DISP8; ea += bp + di; ra = DI; break;
	case 0x7C: DS; DISP8; ea += si; ra = DI; break;
	case 0x7D: DS; DISP8; ea += di; ra = DI; break;
	case 0x7E: SS; DISP8; ea += bp; ra = DI; break;
	case 0x7F: DS; DISP8; ea += bx; ra = DI; break;

	case 0x80: DS; DISP16; ea += bx + si; ra = AX; break;
	case 0x81: DS; DISP16; ea += bx + di; ra = AX; break;
	case 0x82: SS; DISP16; ea += bp + si; ra = AX; break;
	case 0x83: SS; DISP16; ea += bp + di; ra = AX; break;
	case 0x84: DS; DISP16; ea += si; ra = AX; break;
	case 0x85: DS; DISP16; ea += di; ra = AX; break;
	case 0x86: SS; DISP16; ea += bp; ra = AX; break;
	case 0x87: DS; DISP16; ea += bx; ra = AX; break;

	case 0x88: DS; DISP16; ea += bx + si; ra = CX; break;
	case 0x89: DS; DISP16; ea += bx + di; ra = CX; break;
	case 0x8A: SS; DISP16; ea += bp + si; ra = CX; break;
	case 0x8B: SS; DISP16; ea += bp + di; ra = CX; break;
	case 0x8C: DS; DISP16; ea += si; ra = CX; break;
	case 0x8D: DS; DISP16; ea += di; ra = CX; break;
	case 0x8E: SS; DISP16; ea += bp; ra = CX; break;
	case 0x8F: DS; DISP16; ea += bx; ra = CX; break;

	case 0x90: DS; DISP16; ea += bx + si; ra = DX; break;
	case 0x91: DS; DISP16; ea += bx + di; ra = DX; break;
	case 0x92: SS; DISP16; ea += bp + si; ra = DX; break;
	case 0x93: SS; DISP16; ea += bp + di; ra = DX; break;
	case 0x94: DS; DISP16; ea += si; ra = DX; break;
	case 0x95: DS; DISP16; ea += di; ra = DX; break;
	case 0x96: SS; DISP16; ea += bp; ra = DX; break;
	case 0x97: DS; DISP16; ea += bx; ra = DX; break;

	case 0x98: DS; DISP16; ea += bx + si; ra = BX; break;
	case 0x99: DS; DISP16; ea += bx + di; ra = BX; break;
	case 0x9A: SS; DISP16; ea += bp + si; ra = BX; break;
	case 0x9B: SS; DISP16; ea += bp + di; ra = BX; break;
	case 0x9C: DS; DISP16; ea += si; ra = BX; break;
	case 0x9D: DS; DISP16; ea += di; ra = BX; break;
	case 0x9E: SS; DISP16; ea += bp; ra = BX; break;
	case 0x9F: DS; DISP16; ea += bx; ra = BX; break;

	case 0xA0: DS; DISP16; ea += bx + si; ra = SP; break;
	case 0xA1: DS; DISP16; ea += bx + di; ra = SP; break;
	case 0xA2: SS; DISP16; ea += bp + si; ra = SP; break;
	case 0xA3: SS; DISP16; ea += bp + di; ra = SP; break;
	case 0xA4: DS; DISP16; ea += si; ra = SP; break;
	case 0xA5: DS; DISP16; ea += di; ra = SP; break;
	case 0xA6: SS; DISP16; ea += bp; ra = SP; break;
	case 0xA7: DS; DISP16; ea += bx; ra = SP; break;

	case 0xA8: DS; DISP16; ea += bx + si; ra = BP; break;
	case 0xA9: DS; DISP16; ea += bx + di; ra = BP; break;
	case 0xAA: SS; DISP16; ea += bp + si; ra = BP; break;
	case 0xAB: SS; DISP16; ea += bp + di; ra = BP; break;
	case 0xAC: DS; DISP16; ea += si; ra = BP; break;
	case 0xAD: DS; DISP16; ea += di; ra = BP; break;
	case 0xAE: SS; DISP16; ea += bp; ra = BP; break;
	case 0xAF: DS; DISP16; ea += bx; ra = BP; break;

	case 0xB0: DS; DISP16; ea += bx + si; ra = SI; break;
	case 0xB1: DS; DISP16; ea += bx + di; ra = SI; break;
	case 0xB2: SS; DISP16; ea += bp + si; ra = SI; break;
	case 0xB3: SS; DISP16; ea += bp + di; ra = SI; break;
	case 0xB4: DS; DISP16; ea += si; ra = SI; break;
	case 0xB5: DS; DISP16; ea += di; ra = SI; break;
	case 0xB6: SS; DISP16; ea += bp; ra = SI; break;
	case 0xB7: DS; DISP16; ea += bx; ra = SI; break;

	case 0xB8: DS; DISP16; ea += bx + si; ra = DI; break;
	case 0xB9: DS; DISP16; ea += bx + di; ra = DI; break;
	case 0xBA: SS; DISP16; ea += bp + si; ra = DI; break;
	case 0xBB: SS; DISP16; ea += bp + di; ra = DI; break;
	case 0xBC: DS; DISP16; ea += si; ra = DI; break;
	case 0xBD: DS; DISP16; ea += di; ra = DI; break;
	case 0xBE: SS; DISP16; ea += bp; ra = DI; break;
	case 0xBF: DS; DISP16; ea += bx; ra = DI; break;

	case 0xC0: ea = AX; ra = AX; break;
	case 0xC1: ea = CX; ra = AX; break;
	case 0xC2: ea = DX; ra = AX; break;
	case 0xC3: ea = BX; ra = AX; break;
	case 0xC4: ea = SP; ra = AX; break;
	case 0xC5: ea = BP; ra = AX; break;
	case 0xC6: ea = SI; ra = AX; break;
	case 0xC7: ea = DI; ra = AX; break;

	case 0xC8: ea = AX; ra = CX; break;
	case 0xC9: ea = CX; ra = CX; break;
	case 0xCA: ea = DX; ra = CX; break;
	case 0xCB: ea = BX; ra = CX; break;
	case 0xCC: ea = SP; ra = CX; break;
	case 0xCD: ea = BP; ra = CX; break;
	case 0xCE: ea = SI; ra = CX; break;
	case 0xCF: ea = DI; ra = CX; break;

	case 0xD0: ea = AX; ra = DX; break;
	case 0xD1: ea = CX; ra = DX; break;
	case 0xD2: ea = DX; ra = DX; break;
	case 0xD3: ea = BX; ra = DX; break;
	case 0xD4: ea = SP; ra = DX; break;
	case 0xD5: ea = BP; ra = DX; break;
	case 0xD6: ea = SI; ra = DX; break;
	case 0xD7: ea = DI; ra = DX; break;

	case 0xD8: ea = AX; ra = BX; break;
	case 0xD9: ea = CX; ra = BX; break;
	case 0xDA: ea = DX; ra = BX; break;
	case 0xDB: ea = BX; ra = BX; break;
	case 0xDC: ea = SP; ra = BX; break;
	case 0xDD: ea = BP; ra = BX; break;
	case 0xDE: ea = SI; ra = BX; break;
	case 0xDF: ea = DI; ra = BX; break;

	case 0xE0: ea = AX; ra = SP; break;
	case 0xE1: ea = CX; ra = SP; break;
	case 0xE2: ea = DX; ra = SP; break;
	case 0xE3: ea = BX; ra = SP; break;
	case 0xE4: ea = SP; ra = SP; break;
	case 0xE5: ea = BP; ra = SP; break;
	case 0xE6: ea = SI; ra = SP; break;
	case 0xE7: ea = DI; ra = SP; break;

	case 0xE8: ea = AX; ra = BP; break;
	case 0xE9: ea = CX; ra = BP; break;
	case 0xEA: ea = DX; ra = BP; break;
	case 0xEB: ea = BX; ra = BP; break;
	case 0xEC: ea = SP; ra = BP; break;
	case 0xED: ea = BP; ra = BP; break;
	case 0xEE: ea = SI; ra = BP; break;
	case 0xEF: ea = DI; ra = BP; break;

	case 0xF0: ea = AX; ra = SI; break;
	case 0xF1: ea = CX; ra = SI; break;
	case 0xF2: ea = DX; ra = SI; break;
	case 0xF3: ea = BX; ra = SI; break;
	case 0xF4: ea = SP; ra = SI; break;
	case 0xF5: ea = BP; ra = SI; break;
	case 0xF6: ea = SI; ra = SI; break;
	case 0xF7: ea = DI; ra = SI; break;

	case 0xF8: ea = AX; ra = DI; break;
	case 0xF9: ea = CX; ra = DI; break;
	case 0xFA: ea = DX; ra = DI; break;
	case 0xFB: ea = BX; ra = DI; break;
	case 0xFC: ea = SP; ra = DI; break;
	case 0xFD: ea = BP; ra = DI; break;
	case 0xFE: ea = SI; ra = DI; break;
	case 0xFF: ea = DI; ra = DI; break;
    }

    if (t <= 0xBF)
    {
	register reg	t;

	MEM(eapc, xs, ea);

	eoplo = *eapc;		/* XXX */
	eophi = *(eapc + 1);	/* XXX */

	t.w = r.rw[ra];
	roplo = t.b.lo;
	rophi = t.b.hi;
	rapw = &r.rw[ra];
    }
    else {
	register reg	t;

	eapc = (char *) &r.rw[ea];

	t.w = r.rw[ea];
	eoplo = t.b.lo;
	eophi = t.b.hi;
	rapw = &r.rw[ra];
	rop = *rapw;
    }
}


by()
{
/* Compute the effective address and put it in 'ea'.
 * Also compute the register and put a pointer to it in 'rapc.'
 * This routine only called for byte operands.
 */

    register	word	t;

    t = *pcx++ & mask;

    switch (t)
    {
	case 0x00: DS; ea = bx + si; ra = AL; break;
	case 0x01: DS; ea = bx + di; ra = AL; break;
	case 0x02: SS; ea = bp + si; ra = AL; break;
	case 0x03: SS; ea = bp + di; ra = AL; break;
	case 0x04: DS; ea = si; ra = AL; break;
	case 0x05: DS; ea = di; ra = AL; break;
	case 0x06: DS; ealo = *pcx++; eahi = *pcx++; ra = AL; break;
	case 0x07: DS; ea = bx; ra = AL; break;

	case 0x08: DS; ea = bx + si; ra = CL; break;
	case 0x09: DS; ea = bx + di; ra = CL; break;
	case 0x0A: SS; ea = bp + si; ra = CL; break;
	case 0x0B: SS; ea = bp + di; ra = CL; break;
	case 0x0C: DS; ea = si; ra = CL; break;
	case 0x0D: DS; ea = di; ra = CL; break;
	case 0x0E: DS; ealo = *pcx++; eahi = *pcx++; ra = CL; break;
	case 0x0F: DS; ea = bx; ra = CL; break;

	case 0x10: DS; ea = bx + si; ra = DL; break;
	case 0x11: DS; ea = bx + di; ra = DL; break;
	case 0x12: SS; ea = bp + si; ra = DL; break;
	case 0x13: SS; ea = bp + di; ra = DL; break;
	case 0x14: DS; ea = si; ra = DL; break;
	case 0x15: DS; ea = di; ra = DL; break;
	case 0x16: DS; ealo = *pcx++; eahi = *pcx++; ra = DL; break;
	case 0x17: DS; ea = bx; ra = DL; break;

	case 0x18: DS; ea = bx + si; ra = BL; break;
	case 0x19: DS; ea = bx + di; ra = BL; break;
	case 0x1A: SS; ea = bp + si; ra = BL; break;
	case 0x1B: SS; ea = bp + di; ra = BL; break;
	case 0x1C: DS; ea = si; ra = BL; break;
	case 0x1D: DS; ea = di; ra = BL; break;
	case 0x1E: DS; ealo = *pcx++; eahi = *pcx++; ra = BL; break;
	case 0x1F: DS; ea = bx; ra = BL; break;

	case 0x20: DS; ea = bx + si; ra = AH; break;
	case 0x21: DS; ea = bx + di; ra = AH; break;
	case 0x22: SS; ea = bp + si; ra = AH; break;
	case 0x23: SS; ea = bp + di; ra = AH; break;
	case 0x24: DS; ea = si; ra = AH; break;
	case 0x25: DS; ea = di; ra = AH; break;
	case 0x26: DS; ealo = *pcx++; eahi = *pcx++; ra = AH; break;
	case 0x27: DS; ea = bx; ra = AH; break;

	case 0x28: DS; ea = bx + si; ra = CH; break;
	case 0x29: DS; ea = bx + di; ra = CH; break;
	case 0x2A: SS; ea = bp + si; ra = CH; break;
	case 0x2B: SS; ea = bp + di; ra = CH; break;
	case 0x2C: DS; ea = si; ra = CH; break;
	case 0x2D: DS; ea = di; ra = CH; break;
	case 0x2E: DS; ealo = *pcx++; eahi = *pcx++; ra = CH; break;
	case 0x2F: DS; ea = bx; ra = CH; break;

	case 0x30: DS; ea = bx + si; ra = DH; break;
	case 0x31: DS; ea = bx + di; ra = DH; break;
	case 0x32: SS; ea = bp + si; ra = DH; break;
	case 0x33: SS; ea = bp + di; ra = DH; break;
	case 0x34: DS; ea = si; ra = DH; break;
	case 0x35: DS; ea = di; ra = DH; break;
	case 0x36: DS; ealo = *pcx++; eahi = *pcx++; ra = DH; break;
	case 0x37: DS; ea = bx; ra = DH; break;

	case 0x38: DS; ea = bx + si; ra = BH; break;
	case 0x39: DS; ea = bx + di; ra = BH; break;
	case 0x3A: SS; ea = bp + si; ra = BH; break;
	case 0x3B: SS; ea = bp + di; ra = BH; break;
	case 0x3C: DS; ea = si; ra = BH; break;
	case 0x3D: DS; ea = di; ra = BH; break;
	case 0x3E: DS; ealo = *pcx++; eahi = *pcx++; ra = BH; break;
	case 0x3F: DS; ea = bx; ra = BH; break;

	case 0x40: DS; DISP8; ea += bx + si; ra = AL; break;
	case 0x41: DS; DISP8; ea += bx + di; ra = AL; break;
	case 0x42: SS; DISP8; ea += bp + si; ra = AL; break;
	case 0x43: SS; DISP8; ea += bp + di; ra = AL; break;
	case 0x44: DS; DISP8; ea += si; ra = AL; break;
	case 0x45: DS; DISP8; ea += di; ra = AL; break;
	case 0x46: SS; DISP8; ea += bp; ra = AL; break;
	case 0x47: DS; DISP8; ea += bx; ra = AL; break;

	case 0x48: DS; DISP8; ea += bx + si; ra = CL; break;
	case 0x49: DS; DISP8; ea += bx + di; ra = CL; break;
	case 0x4A: SS; DISP8; ea += bp + si; ra = CL; break;
	case 0x4B: SS; DISP8; ea += bp + di; ra = CL; break;
	case 0x4C: DS; DISP8; ea += si; ra = CL; break;
	case 0x4D: DS; DISP8; ea += di; ra = CL; break;
	case 0x4E: SS; DISP8; ea += bp; ra = CL; break;
	case 0x4F: DS; DISP8; ea += bx; ra = CL; break;

	case 0x50: DS; DISP8; ea += bx + si; ra = DL; break;
	case 0x51: DS; DISP8; ea += bx + di; ra = DL; break;
	case 0x52: SS; DISP8; ea += bp + si; ra = DL; break;
	case 0x53: SS; DISP8; ea += bp + di; ra = DL; break;
	case 0x54: DS; DISP8; ea += si; ra = DL; break;
	case 0x55: DS; DISP8; ea += di; ra = DL; break;
	case 0x56: SS; DISP8; ea += bp; ra = DL; break;
	case 0x57: DS; DISP8; ea += bx; ra = DL; break;

	case 0x58: DS; DISP8; ea += bx + si; ra = BL; break;
	case 0x59: DS; DISP8; ea += bx + di; ra = BL; break;
	case 0x5A: SS; DISP8; ea += bp + si; ra = BL; break;
	case 0x5B: SS; DISP8; ea += bp + di; ra = BL; break;
	case 0x5C: DS; DISP8; ea += si; ra = BL; break;
	case 0x5D: DS; DISP8; ea += di; ra = BL; break;
	case 0x5E: SS; DISP8; ea += bp; ra = BL; break;
	case 0x5F: DS; DISP8; ea += bx; ra = BL; break;

	case 0x60: DS; DISP8; ea += bx + si; ra = AH; break;
	case 0x61: DS; DISP8; ea += bx + di; ra = AH; break;
	case 0x62: SS; DISP8; ea += bp + si; ra = AH; break;
	case 0x63: SS; DISP8; ea += bp + di; ra = AH; break;
	case 0x64: DS; DISP8; ea += si; ra = AH; break;
	case 0x65: DS; DISP8; ea += di; ra = AH; break;
	case 0x66: SS; DISP8; ea += bp; ra = AH; break;
	case 0x67: DS; DISP8; ea += bx; ra = AH; break;

	case 0x68: DS; DISP8; ea += bx + si; ra = CH; break;
	case 0x69: DS; DISP8; ea += bx + di; ra = CH; break;
	case 0x6A: SS; DISP8; ea += bp + si; ra = CH; break;
	case 0x6B: SS; DISP8; ea += bp + di; ra = CH; break;
	case 0x6C: DS; DISP8; ea += si; ra = CH; break;
	case 0x6D: DS; DISP8; ea += di; ra = CH; break;
	case 0x6E: SS; DISP8; ea += bp; ra = CH; break;
	case 0x6F: DS; DISP8; ea += bx; ra = CH; break;

	case 0x70: DS; DISP8; ea += bx + si; ra = DH; break;
	case 0x71: DS; DISP8; ea += bx + di; ra = DH; break;
	case 0x72: SS; DISP8; ea += bp + si; ra = DH; break;
	case 0x73: SS; DISP8; ea += bp + di; ra = DH; break;
	case 0x74: DS; DISP8; ea += si; ra = DH; break;
	case 0x75: DS; DISP8; ea += di; ra = DH; break;
	case 0x76: SS; DISP8; ea += bp; ra = DH; break;
	case 0x77: DS; DISP8; ea += bx; ra = DH; break;

	case 0x78: DS; DISP8; ea += bx + si; ra = BH; break;
	case 0x79: DS; DISP8; ea += bx + di; ra = BH; break;
	case 0x7A: SS; DISP8; ea += bp + si; ra = BH; break;
	case 0x7B: SS; DISP8; ea += bp + di; ra = BH; break;
	case 0x7C: DS; DISP8; ea += si; ra = BH; break;
	case 0x7D: DS; DISP8; ea += di; ra = BH; break;
	case 0x7E: SS; DISP8; ea += bp; ra = BH; break;
	case 0x7F: DS; DISP8; ea += bx; ra = BH; break;

	case 0x80: DS; DISP16; ea += bx + si; ra = AL; break;
	case 0x81: DS; DISP16; ea += bx + di; ra = AL; break;
	case 0x82: SS; DISP16; ea += bp + si; ra = AL; break;
	case 0x83: SS; DISP16; ea += bp + di; ra = AL; break;
	case 0x84: DS; DISP16; ea += si; ra = AL; break;
	case 0x85: DS; DISP16; ea += di; ra = AL; break;
	case 0x86: SS; DISP16; ea += bp; ra = AL; break;
	case 0x87: DS; DISP16; ea += bx; ra = AL; break;

	case 0x88: DS; DISP16; ea += bx + si; ra = CL; break;
	case 0x89: DS; DISP16; ea += bx + di; ra = CL; break;
	case 0x8A: SS; DISP16; ea += bp + si; ra = CL; break;
	case 0x8B: SS; DISP16; ea += bp + di; ra = CL; break;
	case 0x8C: DS; DISP16; ea += si; ra = CL; break;
	case 0x8D: DS; DISP16; ea += di; ra = CL; break;
	case 0x8E: SS; DISP16; ea += bp; ra = CL; break;
	case 0x8F: DS; DISP16; ea += bx; ra = CL; break;

	case 0x90: DS; DISP16; ea += bx + si; ra = DL; break;
	case 0x91: DS; DISP16; ea += bx + di; ra = DL; break;
	case 0x92: SS; DISP16; ea += bp + si; ra = DL; break;
	case 0x93: SS; DISP16; ea += bp + di; ra = DL; break;
	case 0x94: DS; DISP16; ea += si; ra = DL; break;
	case 0x95: DS; DISP16; ea += di; ra = DL; break;
	case 0x96: SS; DISP16; ea += bp; ra = DL; break;
	case 0x97: DS; DISP16; ea += bx; ra = DL; break;

	case 0x98: DS; DISP16; ea += bx + si; ra = BL; break;
	case 0x99: DS; DISP16; ea += bx + di; ra = BL; break;
	case 0x9A: SS; DISP16; ea += bp + si; ra = BL; break;
	case 0x9B: SS; DISP16; ea += bp + di; ra = BL; break;
	case 0x9C: DS; DISP16; ea += si; ra = BL; break;
	case 0x9D: DS; DISP16; ea += di; ra = BL; break;
	case 0x9E: SS; DISP16; ea += bp; ra = BL; break;
	case 0x9F: DS; DISP16; ea += bx; ra = BL; break;

	case 0xA0: DS; DISP16; ea += bx + si; ra = AH; break;
	case 0xA1: DS; DISP16; ea += bx + di; ra = AH; break;
	case 0xA2: SS; DISP16; ea += bp + si; ra = AH; break;
	case 0xA3: SS; DISP16; ea += bp + di; ra = AH; break;
	case 0xA4: DS; DISP16; ea += si; ra = AH; break;
	case 0xA5: DS; DISP16; ea += di; ra = AH; break;
	case 0xA6: SS; DISP16; ea += bp; ra = AH; break;
	case 0xA7: DS; DISP16; ea += bx; ra = AH; break;

	case 0xA8: DS; DISP16; ea += bx + si; ra = CH; break;
	case 0xA9: DS; DISP16; ea += bx + di; ra = CH; break;
	case 0xAA: SS; DISP16; ea += bp + si; ra = CH; break;
	case 0xAB: SS; DISP16; ea += bp + di; ra = CH; break;
	case 0xAC: DS; DISP16; ea += si; ra = CH; break;
	case 0xAD: DS; DISP16; ea += di; ra = CH; break;
	case 0xAE: SS; DISP16; ea += bp; ra = CH; break;
	case 0xAF: DS; DISP16; ea += bx; ra = CH; break;

	case 0xB0: DS; DISP16; ea += bx + si; ra = DH; break;
	case 0xB1: DS; DISP16; ea += bx + di; ra = DH; break;
	case 0xB2: SS; DISP16; ea += bp + si; ra = DH; break;
	case 0xB3: SS; DISP16; ea += bp + di; ra = DH; break;
	case 0xB4: DS; DISP16; ea += si; ra = DH; break;
	case 0xB5: DS; DISP16; ea += di; ra = DH; break;
	case 0xB6: SS; DISP16; ea += bp; ra = DH; break;
	case 0xB7: DS; DISP16; ea += bx; ra = DH; break;

	case 0xB8: DS; DISP16; ea += bx + si; ra = BH; break;
	case 0xB9: DS; DISP16; ea += bx + di; ra = BH; break;
	case 0xBA: SS; DISP16; ea += bp + si; ra = BH; break;
	case 0xBB: SS; DISP16; ea += bp + di; ra = BH; break;
	case 0xBC: DS; DISP16; ea += si; ra = BH; break;
	case 0xBD: DS; DISP16; ea += di; ra = BH; break;
	case 0xBE: SS; DISP16; ea += bp; ra = BH; break;
	case 0xBF: DS; DISP16; ea += bx; ra = BH; break;

	case 0xC0: ea = AL; ra = AL; break;
	case 0xC1: ea = CL; ra = AL; break;
	case 0xC2: ea = DL; ra = AL; break;
	case 0xC3: ea = BL; ra = AL; break;
	case 0xC4: ea = AH; ra = AL; break;
	case 0xC5: ea = CH; ra = AL; break;
	case 0xC6: ea = DH; ra = AL; break;
	case 0xC7: ea = BH; ra = AL; break;

	case 0xC8: ea = AL; ra = CL; break;
	case 0xC9: ea = CL; ra = CL; break;
	case 0xCA: ea = DL; ra = CL; break;
	case 0xCB: ea = BL; ra = CL; break;
	case 0xCC: ea = AH; ra = CL; break;
	case 0xCD: ea = CH; ra = CL; break;
	case 0xCE: ea = DH; ra = CL; break;
	case 0xCF: ea = BH; ra = CL; break;

	case 0xD0: ea = AL; ra = DL; break;
	case 0xD1: ea = CL; ra = DL; break;
	case 0xD2: ea = DL; ra = DL; break;
	case 0xD3: ea = BL; ra = DL; break;
	case 0xD4: ea = AH; ra = DL; break;
	case 0xD5: ea = CH; ra = DL; break;
	case 0xD6: ea = DH; ra = DL; break;
	case 0xD7: ea = BH; ra = DL; break;

	case 0xD8: ea = AL; ra = BL; break;
	case 0xD9: ea = CL; ra = BL; break;
	case 0xDA: ea = DL; ra = BL; break;
	case 0xDB: ea = BL; ra = BL; break;
	case 0xDC: ea = AH; ra = BL; break;
	case 0xDD: ea = CH; ra = BL; break;
	case 0xDE: ea = DH; ra = BL; break;
	case 0xDF: ea = BH; ra = BL; break;

	case 0xE0: ea = AL; ra = AH; break;
	case 0xE1: ea = CL; ra = AH; break;
	case 0xE2: ea = DL; ra = AH; break;
	case 0xE3: ea = BL; ra = AH; break;
	case 0xE4: ea = AH; ra = AH; break;
	case 0xE5: ea = CH; ra = AH; break;
	case 0xE6: ea = DH; ra = AH; break;
	case 0xE7: ea = BH; ra = AH; break;

	case 0xE8: ea = AL; ra = CH; break;
	case 0xE9: ea = CL; ra = CH; break;
	case 0xEA: ea = DL; ra = CH; break;
	case 0xEB: ea = BL; ra = CH; break;
	case 0xEC: ea = AH; ra = CH; break;
	case 0xED: ea = CH; ra = CH; break;
	case 0xEE: ea = DH; ra = CH; break;
	case 0xEF: ea = BH; ra = CH; break;

	case 0xF0: ea = AL; ra = DH; break;
	case 0xF1: ea = CL; ra = DH; break;
	case 0xF2: ea = DL; ra = DH; break;
	case 0xF3: ea = BL; ra = DH; break;
	case 0xF4: ea = AH; ra = DH; break;
	case 0xF5: ea = CH; ra = DH; break;
	case 0xF6: ea = DH; ra = DH; break;
	case 0xF7: ea = BH; ra = DH; break;

	case 0xF8: ea = AL; ra = BH; break;
	case 0xF9: ea = CL; ra = BH; break;
	case 0xFA: ea = DL; ra = BH; break;
	case 0xFB: ea = BL; ra = BH; break;
	case 0xFC: ea = AH; ra = BH; break;
	case 0xFD: ea = CH; ra = BH; break;
	case 0xFE: ea = DH; ra = BH; break;
	case 0xFF: ea = BH; ra = BH; break;
    }
    if (t <= 0xBF)
    {
	/*
	 * At this point, 'ea' and 'ra' have been set to the index into
	 * memory of the effective address and register address,
	 * respectively.  Compute pointers to them and fetch the operands
	 * into 'eoplo' and 'roplo' respectively.
	 */
	MEM(eapc, xs, ea);
    }
    else {
	/*
	 * At this point, 'ea' and 'ra' have been set to the index into
	 * memory of the effective address and register address,
	 * respectively.  Compute pointers to them and fetch the operands
	 * into 'eoplo' and 'roplo' respectively.
	 */
	eapc = (char *) &r.rc[ea];
    }
    eoplo = *eapc;
    rapc = (char *) &r.rc[ra];
    roplo = *rapc;
}
