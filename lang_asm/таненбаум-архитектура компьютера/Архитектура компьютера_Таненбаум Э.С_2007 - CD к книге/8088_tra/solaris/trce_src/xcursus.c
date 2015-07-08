/*#include <termio.h>
#include <unistd.h>*/
#include <termios.h>
#include <stdio.h>
#include <sys/types.h>
#include <signal.h>
#include <pwd.h>
/*#include <curses.h>*/

char nwindow[24][81];
extern char window[24][81];
extern char *tgoto();
extern char *tgetstr();
extern char *getenv();
extern putch();
extern die();
extern winfirst();
extern char **environ;

#define curinvis()      tputs(VI,0,putch)
#define curvisible()    tputs(VE,0,putch)
#define clearscreen()   tputs(CL,0,putch)
#define clearline()     tputs(CE,0,putch)
#define standout()      tputs(SO,0,putch)
#define standend()      tputs(SE,0,putch)
#define beep()          putchar('\7')
#define startterm()     (VE&&VI&&tputs(VI,0,putch),TI&&tputs(TI,0,putch))
#define begunder()      tputs(US,0,putch)       /* Begin underscore */
#define endunder()      tputs(UE,0,putch)       /* End underscore   */
#define endterm()       (VE&&VI&&tputs(VE,0,putch),TE&&tputs(TE,0,putch))
#define mvcur(y,x)      tputs(tgoto(CM,x,y),0,putch)
#define streq(s1,s2)    (strcmp(s1,s2)==0)
#define isctrl(c)       ((unsigned)(((c)^0100)-'?')<='_'-'?')

int tospeed;             /* terminal speed (needed by tputs) */
char *BC;               /* back cursor movement (needed by tgoto) */
char *CE;               /* clear to end of line */
char *CL;               /* clear screen */
char *CM;               /* cursor motion */
char *SE;               /* exit standout mode */
char *SO;               /* enter standout mode */
char *TE;               /* string to end programs that use termcap */
char *TI;               /* string to start programs that use termcap */
char *VE;               /* undo VI */
char *VI;               /* make cursor invisible */
char *UP;               /* up cursor movement (needed by tgoto) */
char *US;               /* Start underscore                     */
char *UE;               /* End underscore                       */
char PC;                /* pad character (needed by tputs) */
int CO;                 /* # of columns */
int LI;                 /* # of lines */

/* --------------------------------------------------------- */

putch(c)
{
        putchar(c);
}

/* --------------------------------------------------------- */

/*#include <sgtty.h>*/
#include <signal.h>

/*struct sgttyb ttybuf;
int ttyflags;*/



/* ------------------------------------------------------------ */

char *gettermname()

{
  static char s[40];
	int i;

  printf("Dit is een administratie programma\n\n");
  printf("Het programma weet niet wat uw type terminal is.\n\n");
  printf("Geef het type terminal op als bijv. : a230 of d80 etc.\n\n");
  printf("Geef het type van uw terminal aub : ");
  fgets(s,38,stdin);
    for(i=0;i<39;i++) if(s[i]<'\016') s[i] = '\0';
	
  return(s);
}

/* ------------------------------------------------------------- */

setty()
{
        char buf[1024];
        static char buf2[256];
        char *area;
        register char *xPC;
        char *termname;

        termname=getenv("TERM");
        if ( (strcmp(termname,"remote")==0)||
             (strcmp(termname,"dialup")==0)   ) {
          termname=gettermname();
        }
        switch (tgetent(buf, termname )) {
        case 0:
        case -1:
                printf("Sorry, you cannot run this program\n");
                exit(1);
        }
        area = &buf2[0];
        BC = tgetstr("bc", &area);
        CE = tgetstr("ce", &area);
        CL = tgetstr("cl", &area);
        CM = tgetstr("cm", &area);
        CO = tgetnum("co");
        LI = tgetnum("li");
        xPC = tgetstr("pc", &area);
        SE = tgetstr("se", &area);
        SO = tgetstr("so", &area);
        TE = tgetstr("te", &area);
        TI = tgetstr("ti", &area);
        VE = tgetstr("ve", &area);
        VI = tgetstr("vi", &area);
        UP = tgetstr("up", &area);
        UE = tgetstr("ue", &area);
        US = tgetstr("us", &area);
        if (xPC)
                PC = *xPC;
        if (CM == 0 || CL == 0) {
                printf("Your terminal misses important features\n");
                exit(1);
        }
        if (LI < 3)
                LI = 24;
        if (CO < 16)
                CO = 80;
/*        ioctl(0, TIOCGETP, &ttybuf);    /* Get flags of tty     * /
        ttyflags = ttybuf.sg_flags;
        ttybuf.sg_flags &= ~(ECHO|RAW);
        ttybuf.sg_flags |= CBREAK;      /* Set mode             */
/*
        signal(SIGINT, die);
* /
        ioctl(0, TIOCSETN, &ttybuf);    /* Initialize           * /
/*
        tospeed = ttybuf.sg_ospeed;* /
        startterm();
*/
}

/* --------------------------------------------------------- * /

int undotty()

{ 
        ttybuf.sg_flags=ttyflags;
        ioctl(0,TIOCSETN,&ttybuf);
}

/* --------------------------------------------------------- */


winfirst(){
 setty();
 clearscreen();
 standend();
 wingo();
}
wingo(){
 int i,j,k,l; char c,*p,*q;
 p = window[0]; for(i=0;i<1944;i++) *p++ = ' ';
/*234567890123456789012345678901234567890123456789012345678901234567890*/
 strncpy(window[0],"CS: 00  DS=SS=ES: 000 |=>---- | ",32);
 strncpy(window[1],"AH:00 AL:00 AX:...... |  ---- | ",32);
 strncpy(window[2],"BH:00 BL:00 BX:...... |  ---- | ",32);
 strncpy(window[3],"CH:00 CL:00 CX:...... |  ---- | ",32);
 strncpy(window[4],"DH:00 DL:00 DX:...... |  ---- | ",32);
 strncpy(window[5],"SP: 0000 sf O D S Z C |  ---- | ",32);
 strncpy(window[6],"BP: 0000 cc - - - - - |  ---- =>",32);
 strncpy(window[7],"SI: 0000  IP:0000:PC  |  ---- | ",32);
 strncpy(window[8],"DI: 0000  ........+0  |  ---- | ",32);
 for(i=0;i<80;i++) window[16][i] = window[9][i] = '-';
 for(i=0;i<20;i++) window[13][i] = '-';
 for(i=0;i<6;i++) window[i+10][20] = '|';
 p = window[0]; q = nwindow[0]; for(i=0;i<1944;i++) *q++ = *p++;
 for(i=0;i<23;i++){ mvcur(i,0); printf("%-80.80s",window[i]);}
 mvcur(23,0); printf("%-79.79s",window[23]);
}

immain(){
 int i,j,b;
 char *p,*q;
 b = 1; p = window[0]-1; q = nwindow[0]-1;
 for(i=0;i<23;i++) for(j=0;j<81;j++) 
    if ((*(++p) != *(++q)) || (j != 80 && p < window[13] && p > window[10]+22))
	{ *q = *p; if (b) wmv(i,j); putchar(*p); b=0; }
    else b=1;
 for(j=0;j<81;j++) 
    if ((*(++p) != *(++q)) || (j != 80 && p < window[13] && p > window[10]+22))
	{ *q = *p; if (b) wmv(i,j); putchar(*p); b=0; }
    else b=1;
}

wmv(a,b) int a,b; {mvcur(a,b);}
viscursor() {standout();}
inviscur() {standend();}
refresh(){wingo();immain();}
