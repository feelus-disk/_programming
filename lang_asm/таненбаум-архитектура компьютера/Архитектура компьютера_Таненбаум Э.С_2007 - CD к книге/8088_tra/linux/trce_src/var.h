#define CALLONLY 1
#define CALLJUMP 2
#define NE 16			/* how many -e flags are allowed */
#define NP 16			/* how many -p flags are allowed */
#define NS 16			/* how many -s flags are allowed */
#define NU 16			/* how many -u flags are allowed */
#define NY 16			/* how many -y flags are allowed */

extern errno;
long hexin(), atol(), lseek();
int quit0(), quit1(), quit2(), quit3(), quit4();
char *traceptr;			/* ptr to word to be traced */
char *prevpcx;			/* previous pcx (used for dumping) */

int a_used;			/* set if -a flag present */
char *alow, *ahigh;		/* turn dumping on and off by address */
char *breakadr;			/* breakpoint address */
int breakcount;			/* cause break when this reaches 0 */
int c_used;			/* set if -c flag present */
char *c_adr;			/* address to count */
long c_count;			/* counter used by -c flag */
int e_used;			/* set if -e flag present */
char *e_adr[NE];		/* address to check for -e */
word e_val[NE];			/* values to check for */
int f_used;			/* set by -f flag (explicit input file) */
int h_used;			/* set to enable histogram output */
int i_used;			/* set to enable counting of instructions */
long m_used;			/* how often to sample */
long n_used;			/* when to begin dumping */
int p_used;			/* counts number of -p flags read */
char *plow[NP], *phigh[NP];	/* used by -p flag */
int s_used;			/* counts number of -s flags read */
char *slow[NS], *shigh[NS];	/* used by -s flag */
char *startadr; 		/* starting address (hex) */
int u_used;			/* set if -u flag present */
char *u_adr[NU];		/* address to check for -u */
word u_val[NU];			/* values to check for */
int wval;			/* value of 'w' arg */
int y_used;			/* counts number of -y flags read */
char *yadr[NY];			/* used by -y flag */
long z_used;			/* # instructions to execute */


char hexfill;
int traceflag;			/* set to 1 if tracing of 'traceptr' enabled */
long instcount;			/* count instructions executed */
word initseg;			/* initial value of all the segment registers */


#define CLICKSIZE 16
#define CLICKSHIFT 4
#define NCLICKS (MEMBYTES/16)
long histo[NCLICKS];

int dumphdr;
