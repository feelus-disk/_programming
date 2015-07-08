/* $Header: keywhash.c,v 2.17 03/08/12 14:55:13 evert Exp $ */
/*
 * (c) copyright 1987 by the Vrije Universiteit, Amsterdam, The Netherlands.
 * See the copyright notice in the ACK home directory, in the file "Copyright".
 */
/* @(#)keywhash.c	1.6 */
/*
 * Micro processor assembler framework written by
 *	Johan Stevenson, Vrije Universiteit, Amsterdam
 * modified by
 *	Johan Stevenson, Han Schaminee and Hans de Vries
 *		Philips S&I, T&M, PMDS, Eindhoven
 */

#include	"comm0.h"
#include	"comm1.h"

/* #include <stdio.h>
 FILE *inptr, *uitptr;  */

char includfil[] = "#include", namar[2049], includnam[100];
int inclutel = 0, includarr[65], includlen[65];
char *bigdarr[] = { "align", "ascii", "asciz", "assert", "base", "byte", "bss",
"comm", "data", "define", "extern", "file", "line", "list", "long", "nolist",
"sect", "space", "symb", "symd", "text", "word", ""};
char *bigaarr[] = { "aaa", "aad", "aam", "aas", "adc", "adcb", "add", "addb",
"ah", "al", "and", "andb", "ax", "bh", "bl", "bp", "bx", "call", "callf", "cbw",
"ch", "cl", "clc", "cld", "cli", "cmc", "cmp", "cmpb", "cmps", "cmpsb", "cmpsw",
"cs", "cseg", "cwd", "cx", "daa", "das", "dec", "decb", "dh", "di", "div",
"divb", "dl", "ds", "dseg", "dx", "es", "esc", "eseg", "hlt", "idiv", "idivb",
"imul", "imulb", "in", "inb", "inc", "incb", "int", "into", "inw", "iret", "ja",
"jae", "jb", "jbe", "jc", "jcxz", "je", "jg", "jge", "jl", "jle", "jmp", "jmpf",
"jna", "jnae", "jnb", "jnbe", "jnc", "jne", "jng", "jnge", "jnl", "jnle", "jno",
"jnp", "jns", "jnz", "jo", "jp", "jpe", "jpo", "js", "jz", "lahf", "lds", "lea",
"les", "lock", "lods", "lodsb", "lodsw", "loop", "loope", "loopne", "loopnz",
"loopz", "mov", "movb", "movs", "movsb", "movsw", "movw", "mul", "mulb", "neg",
"negb", "nop", "not", "notb", "or", "orb", "out", "outb", "outw", "pop", "popf",
"push", "pushf", "rcl", "rclb", "rcr", "rcrb", "rep", "repe", "repne", "repnz",
"repz", "ret", "retf", "rol", "rolb", "ror", "rorb", "sahf", "sal", "salb",
"sar", "sarb", "sbb", "sbbb", "scas", "scasb", "scasw", "shl", "shlb", "shr",
"shrb", "si", "sp", "ss", "sseg", "stc", "std", "sti", "stos", "stosb", "stosw",
"sub", "subb", "sys", "test", "testb", "wait", "xchg", "xchgb", "xlat", "xor",
"xorb", ""};
int teld, tela, ltaba[200], ltabd[25], tabnr, nxtabd[25], nxtaba[200];
int htabd[33], htaba[33];
char chdarr[128],chaarr[1024],tokenc[10],regel[256],*tptr,aord,*sptr;

int maaktoken(m,n) int m,n; {
  int len,hsh,i,j;
  char *p,c,t;
  len = hsh = 0;
  if(m) p = bigaarr[n]; else p = bigdarr[n];
  while(*p) { len++; hsh += *p++;} hsh &= 0x17;
  if(m) {nxtaba[n] = htaba[hsh]; htaba[hsh] = n; ltaba[n] = len;}
  else  {nxtabd[n] = htabd[hsh]; htabd[hsh] = n; ltabd[n] = len;}
}

int getregel() {
  int i,c;
  i = 0; while ((c=getc(inptr)) != '\n') {if (c==EOF) return(-1);
    if(c=='\r'){c = getc(inptr); if(c=='\n') ungetc(c,inptr); else break;}
    else { regel[i++] = (char)(c&255);
      if(i>250){fprintf(stderr,"Buffer too small. Line truncated.\n"); break;}}
    }
    regel[i++] = '\0'; regel[i++] = '\0'; regel[i] = '\0';
        /*fprintf(stderr,"%s\n",regel);*/
  return(i-1);
}

int zoektoken(){
  int len, hsh, n;
  char t,*dptr, *tt, bk;
  t = '?'; len = hsh = n = 0; tt=tokenc;
  bk = *tptr; if((bk == '\0') || (bk == '!') || (bk == '"')) return(-1);
  while (bk=t, t = *tptr++){ /*fprintf(stderr," -%c-%c- %s\n",bk,t,(tptr-1));*/
   if((bk == '\0') || (bk == '!') || (bk == '"')) return(-1);
    if(t=='.' && *tptr>='a' && *tptr <= 'z') { /* search the d-tables */
      sptr = dptr = tptr; t= *dptr++; len++; hsh = t; *tt++ = t; t = *dptr++;
      while((t >='a') && (t<= 'z')) {len++; hsh += t; *tt++ = t; t = *dptr++;}
      if((t<='Z')&&(t>='A') || (t=='_') || (t<='9')&&(t>='0')) return(0);
      hsh &= 0x17; n = htabd[hsh];
      while(n>=0){
	if((len == ltabd[n]) && (!strncmp(bigdarr[n],tokenc,len))) return(len);
	n = nxtabd[n];
      }
      return(0);
    }
/* fprintf(stderr,"start token %c %c %s %s\n",bk,t,tptr-1,tptr); */
    if((bk<='Z')&&(bk>='A') || (bk=='_') || (bk<='9')&&(bk>='0')) return(0);
/*fprintf(stderr,"START token %c %s %s\n",bk,tptr-1,tptr); */
    if(t>='a' && t<='z') { /* search the a-tables */
/*fprintf(stderr,"Erdoor   %c %s %s\n",bk,tptr-1,tptr); */
      dptr = sptr = tptr; sptr--; len++; hsh = t; *tt++ = t; t = *dptr++;
      while((t >='a') && (t<= 'z')) {len++; hsh += t; *tt++ = t; t = *dptr++;}
      if((t<='Z')&&(t>='A') || (t=='_') || (t<='9')&&(t>='0')) return(0);
      hsh &= 0x17; n = htaba[hsh];
      while(n>=0){
	if((len == ltaba[n]) && (!strncmp(bigaarr[n],tokenc,len))) return(len);
	n = nxtaba[n];
      }
      tptr = dptr-1; return(0);
    }
  }
  return(-1);
}

void hashh(){
  int i,j,k,l;
  for(i=0;i<65;i++) includarr[i] = includlen[i] = 0;
  for(i=0;i<33;i++) htaba[i] = htabd[i] = -1;
  i=0; while(bigdarr[i][0]){maaktoken(0,i); i++;} teld = i;
  /*for(i=0;i<32;i++){fprintf(stderr,"i %d\t",i); j = htabd[i];
	while(j>=0) {fprintf(stderr,"%3d j %6s  ",j,bigdarr[j]); j=nxtabd[j];}
	putc('\n',stderr);} putc('\n',stderr);*/
  i=0; while(bigaarr[i][0]){maaktoken(1,i); i++;} tela = i;
  /*for(i=0;i<32;i++){fprintf(stderr,"i %d\t",i); j = htaba[i];
	while(j>=0) {fprintf(stderr,"%3d j %6s  ",j,bigaarr[j]); j=nxtaba[j];}
	putc('\n',stderr);} putc('\n',stderr);*/
  hphash();
}

hphash(){
  int i,j,rlen,flen;
  char *p,*q;
  FILE *inputsafe;
  while((rlen = getregel())>-1){ tptr = regel;
    if((rlen>10) && (regel[8]<=' ') && !(strncmp(includfil,regel,8))) {
	while(*tptr != '"') tptr++; tptr++; p=tptr;
	while(*tptr != '"') tptr++; *tptr++ = '\0'; flen = tptr-p;
	for(i=0;i<inclutel;i++) { j = includarr[i]; q = namar+j;
/* fprintf(stderr,"i %d j %d flen %d includlen %d p %s namar %s past %d \n",
		i,j,flen,includlen[i],p,q,strncmp(p,q,flen));*/
	  if((includlen[i] == flen) && !(strncmp(p,q,flen))) {fprintf(stderr,
		"Include request %s encountered before\n",p); break;}}
	if(i<inclutel) continue; includlen[inclutel] = flen;
	j = includarr[inclutel]; q = namar+j; strcpy(q,p);
	inclutel++; j += flen; includarr[inclutel] = j; inputsafe = inptr; 
	if((inptr = fopen(p,"r")) == NULL){ fprintf(stderr,
	    "cannot open include file %s\n",p); inptr = inputsafe; continue;}
	else fprintf(stderr,"Include file found %s\n",p);
	hphash(); inptr = inputsafe;
    }
    else {while((j=zoektoken())>=0){
      if(j){ for(i=0;i<j;i++) *sptr++ &= 0xdf; tptr = sptr;}
    }
    fprintf(uitptr,"%s\n",regel);}
  }
}

/* main(){ inptr = stdin; uitptr = stdout; hashh();} */
