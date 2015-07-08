#ifndef lint
static char yysccsid[] = "@(#)yaccpar	1.8 (Berkeley) 01/20/90";
#endif
#define YYBYACC 1
#line 14 "as.y"





























































































#include	<stdio.h>
#include	<ctype.h>
#include	<signal.h>
















struct outhead {
	unsigned short 	oh_magic;	
	unsigned short 	oh_stamp;	
	unsigned short	oh_flags;	
	unsigned short	oh_nsect;	
	unsigned short	oh_nrelo;	
	unsigned short	oh_nname;	
	long	oh_nemit;		
	long	oh_nchar;		
};








struct outsect {
	long 	os_base;		
	long	os_size;		
	long	os_foff;		
	long	os_flen;		
	long	os_lign;		
};

struct outrelo {
	char	or_type;		
	char	or_sect;		
	unsigned short	or_nami;	
	long	or_addr;		
};

struct outname {
	union {
	  char	*on_ptr;		
	  long	on_off;			
	}	on_u;


	unsigned short	on_type;	
	unsigned short	on_desc;	
	long	on_valu;		
};























































































































struct expr_t {
	short	typ;
	long	val;
};

typedef	struct expr_t	expr_t;

struct item_t {
	struct item_t *
		i_next;	
	short	i_type;
	




	long	i_valu;		
	char	*i_name;	
};

struct common_t {
	struct common_t *
		c_next;
	struct item_t *c_it;

	long	c_size;

};

typedef struct common_t	common_t;

typedef	struct item_t	item_t;

struct sect_t {
	short	s_flag;		
	unsigned short		s_base;		
	unsigned short		s_size;		
	unsigned short		s_comm;		
	unsigned short		s_zero;		
	unsigned short		s_lign;		
	long	s_foff;		
	item_t	*s_item;	

	unsigned short		s_gain;		

};

typedef	struct sect_t	sect_t;














































extern FILE *fopen();   















extern short	pass ;
				
extern short	peekc;		
extern short	unresolved;	
extern long	lineno;		
extern short	hllino;		
extern short	nerrors;	
extern short	sflag ;
				
extern char	*progname;	
extern char	*modulename;	
extern common_t	*commons;	


extern short	uflag;		
				



extern short	dflag;		




extern long	relonami;



extern short	bflag;		


extern char	*aoutpath ;
extern char	temppath[50];

extern FILE	*input;
extern FILE	*tempfile;
extern FILE	*outFile;

extern char	*stringbuf;	
extern int	stringlen;	

extern sect_t	sect[64];




extern sect_t	*DOTSCT;	
extern unsigned short		DOTVAL;		
extern short	DOTTYP;		

extern unsigned short	nname;		

extern item_t	*hashtab[(2*307		)];
extern short	hashindex;	

extern item_t	*fb_ptr[4*10];



extern int	nbits;
extern int	bitindex;	





extern short	listmode;	
extern short	listtemp;	
extern short	listflag;	
extern short	listcolm;	
extern short	listeoln ;
				
extern FILE	*listfile;	
extern char	listpath[50];



extern item_t		keytab[];
extern struct outhead	outhead;




extern char	*remember();
extern item_t	*fb_shift();
extern item_t	*fb_alloc();
extern item_t	*item_alloc();
extern item_t	*item_search();
extern long	load();
extern FILE	*ffcreat();
extern FILE	*fftemp();


extern char	*mktemp();
extern char	*malloc();
extern char	*realloc();
extern char	*calloc();
extern char	*getenv();
extern char	*strncpy();




















extern int	mrg_1,mrg_2;
extern expr_t	exp_1,exp_2;

extern int	rel_1, rel_2;



extern char	sr_m[8];



extern char	dr_m[8][8];


static item_t	*last_it, *o_it;
#line 537 "as.y"
typedef union {
	short			y_word;
	long	y_valu;
	expr_t	y_expr;
	item_t	*y_item;

} YYSTYPE;
#line 534 "y.tab.c"
#define STRING 257
#define IDENT 258
#define FBSYM 259
#define CODE1 260
#define CODE2 261
#define CODE4 262
#define NUMBER0 263
#define NUMBER1 264
#define NUMBER2 265
#define NUMBER3 266
#define NUMBER 267
#define DOT 268
#define EXTERN 269
#define DATA 270
#define ASCII 271
#define SECTION 272
#define COMMON 273
#define BASE 274
#define SYMB 275
#define SYMD 276
#define ALIGN 277
#define ASSERT 278
#define SPACE 279
#define LINE 280
#define FILe 281
#define LIST 282
#define OP_EQ 283
#define OP_NE 284
#define OP_LE 285
#define OP_GE 286
#define OP_LL 287
#define OP_RR 288
#define OP_OO 289
#define OP_AA 290
#define R16 291
#define R8 292
#define RSEG 293
#define PREFIX 294
#define NOOP_1 295
#define NOOP_2 296
#define JOP 297
#define PUSHOP 298
#define IOOP 299
#define ADDOP 300
#define ROLOP 301
#define INCOP 302
#define NOTOP 303
#define CALLOP 304
#define CALFOP 305
#define LEAOP 306
#define ARPLOP 307
#define ESC 308
#define INT 309
#define RET 310
#define XCHG 311
#define TEST 312
#define MOV 313
#define IMUL 314
#define ENTER 315
#define EXTOP 316
#define EXTOP1 317
#define ST 318
#define YYERRCODE 256
short yylhs[] = {                                        -1,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    7,    7,    7,    7,    7,    7,    7,    8,    7,    7,
    7,    7,    7,    7,    7,    7,    7,    9,    9,   10,
   10,    4,    4,    4,    4,    4,    4,    4,    4,    4,
    4,    4,    4,    4,    4,    4,    4,    4,    4,    4,
    4,    4,    4,    4,    4,    4,    4,    4,    5,    5,
    1,    2,    2,    3,    3,    7,   11,   11,   12,   12,
   12,   12,   12,   12,   12,   12,   12,   12,   12,   12,
   12,   12,   12,   12,   12,   12,   12,   12,   12,   12,
   12,   12,   12,   12,   12,    6,   15,   15,   15,   17,
   17,   16,   16,   16,   16,   16,   13,   14,
};
short yylen[] = {                                         2,
    0,    3,    3,    2,    2,    2,    3,    3,    5,    3,
    0,    3,    1,    2,    4,    2,    2,    0,    7,    6,
    2,    2,    2,    2,    2,    2,    2,    1,    3,    1,
    3,    1,    1,    1,    1,    3,    3,    3,    3,    3,
    3,    3,    3,    3,    3,    3,    3,    3,    3,    3,
    3,    3,    3,    3,    2,    2,    2,    1,    1,    1,
    1,    0,    1,    0,    2,    2,    0,    2,    1,    1,
    2,    2,    2,    2,    2,    2,    2,    2,    2,    2,
    2,    4,    2,    4,    4,    4,    4,    2,    4,    2,
    1,    2,    2,    2,    2,    4,    3,    1,    2,    3,
    6,    1,    1,    1,    1,    1,    1,    3,
};
short yydefred[] = {                                      1,
    0,    0,    0,    4,    5,    6,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
   13,    0,    0,    0,   10,    2,    0,    3,   28,    0,
   32,   35,   59,   60,   33,   58,    0,    0,    0,    0,
    0,   34,    0,   27,   14,    0,   16,    0,    0,    0,
   63,   24,    0,   25,   21,   22,    0,    7,    8,   68,
   69,   70,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,   66,    0,    0,   55,   56,   57,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,  104,  103,  105,    0,    0,   72,
  102,  107,   98,   74,    0,    0,   75,   76,   77,   80,
   81,    0,   83,    0,    0,    0,    0,   90,    0,   93,
   94,   95,    0,   78,    0,    0,   88,   29,   36,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,   52,   53,   54,    0,   15,    0,
    0,    9,    0,    0,    0,   99,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,   97,  108,    0,   85,
   86,   89,   84,   87,    0,    0,   20,    0,   65,   19,
    0,  101,
};
short yydgoto[] = {                                       1,
   51,   52,  196,  119,   42,    0,   23,  184,   30,   43,
   24,   84,  126,  127,  121,  122,  123,
};
short yysindex[] = {                                      0,
  574,   13,  -33,    0,    0,    0,  -29, -203,  731, -199,
 -194, -179,  731, -198, -175,  731,  731,  731,  731, -157,
    0, -164,    3,  768,    0,    0,  731,    0,    0,   61,
    0,    0,    0,    0,    0,    0,  731,  731,  731,  731,
  530,    0,   75,    0,    0,   76,    0,  530,   91,   96,
    0,    0,  530,    0,    0,    0, -116,    0,    0,    0,
    0,    0,  731,  431,  667,  431,  431,  431,  431,  431,
  686, -145,  686,  731,  731,  731,  431,  431,  431,  431,
  731, -143,  431,    0,  530, -108,    0,    0,    0,  465,
  731,  731,  731,  731,  731,  731,  731,  731,  731,  731,
  731,  731,  731,  731,  731,  731,  731,  731,  731,  731,
  731,  731,  146,  530,    0,    0,    0,  682,  476,    0,
    0,    0,    0,    0,  530,  113,    0,    0,    0,    0,
    0,  430,    0,  114,  476,  118,  119,    0,  530,    0,
    0,    0,  113,    0,  120,  121,    0,    0,    0,  585,
  585,  -27,  -27,  197,  197,  541,  578,  606,  632,  -36,
  -27,  -27,  164,  164,    0,    0,    0,  530,    0,  530,
  133,    0,  138,  502, -111,    0,  431,  731,  686, -110,
  686,  731,  431,  142,  731,  149,    0,    0,  530,    0,
    0,    0,    0,    0,  731,  142,    0, -100,    0,    0,
  154,    0,
};
short yyrindex[] = {                                      0,
  -10,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    7,    0,    0,    7,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    9,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
   -6,    0,   24,    0,    0,    0,    0,   -2,    0,    0,
    0,    0,   31,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,   33,    0,    0,    0,    0,
    0,    0,    0,    0,   34,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,   50,    0,    0,    0,    0,    2,    0,
    0,    0,    0,    0,   84,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,   88,    0,
    0,    0,  107,    0,    0,    0,    0,    0,    0,  144,
  215,   74,  111,   37,   66,  321,  173,  396,  372,  367,
  134,  328,   -8,   29,    0,    0,    0,    4,    0,   12,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,  117,    0,   21,    0,    0,  128,    0,
    0,    0,    0,    0,    0,  117,    0,    0,    0,    0,
    0,    0,
};
short yygindex[] = {                                      0,
   27,  178,   11,  943,    0,    0,    0,    0,    0,    0,
    0,    0,  264,  141,  -68, -156,   10,
};
#define YYTABLESIZE 1138
short yytable[] = {                                      11,
  108,   50,  133,   30,  136,  106,  104,   61,  105,  108,
  107,  106,   59,   31,  106,  104,   62,  105,   23,  107,
  188,   18,   25,  102,   26,  103,  194,   27,   28,   50,
  100,   50,   50,   26,   50,   50,   50,   30,   51,   47,
   17,   61,   91,   12,   54,  106,   49,   31,   11,   50,
   50,   50,   30,   50,   29,   18,   61,   44,   49,   71,
  106,   58,   31,   45,  100,   62,   51,   23,   51,   51,
   18,   51,   51,   51,   49,   48,   49,   49,   46,  100,
   49,   50,   26,   46,   50,   50,   51,   51,   51,   17,
   51,   91,   12,   73,   49,   49,   49,   92,   49,   56,
  137,  138,   57,   48,   86,   48,   48,  145,   71,   48,
  190,   46,  192,   46,   46,   50,   79,   46,  109,  110,
   47,   51,   51,   48,   48,   48,   64,   48,  176,   49,
   49,   46,   46,   46,  111,   46,  169,   82,  171,  112,
  113,  176,   73,   44,  176,  134,   92,  146,   47,  148,
   47,   47,   51,   42,   47,  172,  177,  179,   48,   48,
   49,  180,  181,  182,  183,   79,   46,   46,   47,   47,
   47,   44,   47,   44,   44,   64,  185,   44,  186,  173,
  191,   42,   38,   42,   42,  195,   82,   42,  198,   48,
  201,   44,   44,   44,  202,   44,   55,   46,    0,    0,
  108,   42,   42,   47,   47,  106,  200,  128,  193,    0,
  107,  197,   38,   38,    0,    0,   38,  140,  141,  142,
  144,  199,    0,    0,   43,    0,   44,   44,    0,    0,
   38,   38,    0,  108,   47,    0,   42,   42,  106,  104,
    0,  105,    0,  107,    0,    0,   91,   92,   93,   94,
   95,   96,   43,    0,   43,   43,    0,   44,   43,   95,
   96,    0,    0,    0,    0,   38,    0,   42,    0,    0,
    0,    0,   43,   43,   50,   50,   50,   50,   50,   50,
   50,   50,    0,   67,   67,   67,   67,   67,   67,   67,
   67,   67,   67,   67,   67,   67,   67,   67,   67,   67,
   67,   67,   67,   67,   67,   67,   67,   43,   43,    0,
    0,   51,   51,   51,   51,   51,   51,   51,   51,   49,
   49,   49,   49,   49,   49,   49,   49,  120,    0,    0,
   37,  129,  130,  131,    0,    0,    0,   45,   43,    0,
    0,    0,    0,  143,    0,    0,  147,    0,   48,   48,
   48,   48,   48,   48,   48,   48,   46,   46,   46,   46,
   37,   37,   46,   46,   37,   45,    0,   45,   45,    0,
    0,   45,    0,    0,    0,    0,   41,    0,   37,   37,
    0,   40,    0,    0,    0,   45,   45,   45,    0,   45,
    0,    0,    0,   47,   47,   47,   47,    0,    0,   47,
   47,    0,    0,    0,   41,   39,   41,   41,    0,    0,
   41,   40,   40,   37,    0,   40,   44,   44,   44,   44,
   45,   45,   44,   44,   41,   41,   42,   42,    0,   40,
   40,    0,   42,   42,    0,   39,   39,    0,    0,   39,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,   45,    0,   39,   39,    0,    0,    0,    0,   41,
   41,   38,   38,    0,   40,   40,  108,  101,    0,  175,
  118,  106,  104,   37,  105,   38,  107,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,  178,   39,  102,
   41,  103,    0,    0,    0,   40,    0,   43,   43,    0,
    0,  108,  101,   43,   43,    0,  106,  104,    0,  105,
    0,  107,  108,  101,    0,  175,    0,  106,  104,   39,
  105,   40,  107,  100,  102,    0,  103,    0,    0,    0,
    0,    0,    0,    0,    0,  102,    0,  103,  108,  101,
    0,    0,  187,  106,  104,    0,  105,    0,  107,    0,
    0,    0,    0,   99,    0,    0,   39,  149,  100,    0,
    0,  102,    0,  103,    0,    0,  108,  101,    0,  100,
    0,  106,  104,    0,  105,    0,  107,  108,  101,    0,
    0,    0,  106,  104,    0,  105,    0,  107,   99,  102,
    0,  103,    0,    0,    0,  100,    0,    0,    0,   99,
  102,    0,  103,    0,    0,    0,    0,    0,   22,   37,
   45,   45,   45,   45,  108,  101,   45,   45,    0,  106,
  104,  108,  105,  100,  107,   99,  106,  104,    0,  105,
    0,  107,    0,    0,  100,    0,    0,  102,    0,  103,
    0,    0,  108,  101,  102,    0,  103,  106,  104,    0,
  105,    0,  107,   99,    0,   41,   41,    0,    0,    0,
   40,   40,    0,    0,   99,  102,    0,  103,  108,  101,
    0,  100,    0,  106,  104,    0,  105,    0,  107,    0,
    0,    0,    0,    0,   39,   39,   31,   32,   33,   34,
    0,  102,    0,  103,    0,    0,    0,   35,   36,  100,
    0,   99,    0,    0,    0,    0,    0,    0,    0,   37,
    0,   38,   91,   92,   93,   94,   95,   96,   97,   98,
    0,  115,  116,  117,   37,  118,   38,    0,   37,    0,
   38,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,   91,   92,   93,
   94,   95,   96,   97,   98,    0,    0,   40,   91,   92,
   93,   94,   95,   96,   97,   98,    0,    0,    0,    0,
    0,    0,   40,   37,    0,   38,   40,    0,    0,    0,
    0,    0,    0,    0,   91,   92,   93,   94,   95,   96,
   97,   98,   39,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,   39,    0,    0,
    0,   39,   91,   92,   93,   94,   95,   96,   97,   98,
    0,   40,    0,   91,   92,   93,   94,   95,   96,    2,
   98,    3,    0,    4,    5,    6,    0,    0,    0,    0,
    7,    0,    8,    9,   10,   11,   12,   13,   14,   15,
   16,   17,   18,   19,   20,   21,   39,    0,    0,    0,
   91,   92,   93,   94,   95,   96,    0,    0,    0,   93,
   94,   95,   96,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,   91,   92,
   93,   94,   95,   96,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,   91,   92,   93,   94,   95,   96,
    0,    0,   31,   32,   33,   34,    0,    0,    0,    0,
    0,    0,    0,   35,   36,    0,    0,   31,   32,   33,
   34,   31,   32,   33,   34,    0,    0,    0,   35,   36,
    0,   41,   35,   36,    0,   48,    0,  124,   48,   53,
   48,   48,    0,    0,    0,    0,    0,    0,    0,   85,
    0,    0,  173,    0,    0,    0,    0,    0,    0,   87,
   88,   89,   90,    0,    0,    0,   31,   32,   33,   34,
    0,    0,    0,    0,    0,    0,    0,   35,   36,    0,
    0,    0,    0,    0,    0,  114,    0,  125,    0,    0,
    0,    0,    0,  132,    0,  135,   48,   48,  139,    0,
    0,    0,    0,   48,    0,    0,    0,    0,    0,    0,
    0,    0,    0,  150,  151,  152,  153,  154,  155,  156,
  157,  158,  159,  160,  161,  162,  163,  164,  165,  166,
  167,  168,   48,  170,   48,    0,    0,    0,    0,    0,
  174,   60,   61,   62,   63,   64,   65,   66,   67,   68,
   69,   70,   71,   72,   73,   74,   75,   76,   77,   78,
   79,   80,   81,   82,   83,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
  189,  135,    0,  135,   48,    0,    0,   48,    0,    0,
    0,    0,    0,    0,    0,    0,    0,   48,
};
short yycheck[] = {                                      10,
   37,   10,   71,   10,   73,   42,   43,   10,   45,   37,
   47,   10,   10,   10,   42,   43,   10,   45,   10,   47,
  177,   10,   10,   60,   58,   62,  183,   61,   58,   38,
   10,   40,   41,   10,   43,   44,   45,   44,   10,   13,
   10,   44,   10,   10,   18,   44,   10,   44,   59,   58,
   59,   60,   59,   62,  258,   44,   59,  257,  257,   10,
   59,   59,   59,  258,   44,   59,   38,   59,   40,   41,
   59,   43,   44,   45,   38,   10,   40,   41,  258,   59,
   44,  257,   59,   10,   93,   94,   58,   59,   60,   59,
   62,   59,   59,   10,   58,   59,   60,   10,   62,  257,
   74,   75,  267,   38,   44,   40,   41,   81,   59,   44,
  179,   38,  181,   40,   41,  124,   10,   44,   44,   44,
   10,   93,   94,   58,   59,   60,   10,   62,  119,   93,
   94,   58,   59,   60,   44,   62,  110,   10,  112,   44,
  257,  132,   59,   10,  135,  291,   59,  291,   38,  258,
   40,   41,  124,   10,   44,   10,   44,   44,   93,   94,
  124,   44,   44,   44,   44,   59,   93,   94,   58,   59,
   60,   38,   62,   40,   41,   59,   44,   44,   41,  291,
  291,   38,   10,   40,   41,   44,   59,   44,   40,  124,
  291,   58,   59,   60,   41,   62,   19,  124,   -1,   -1,
   37,   58,   59,   93,   94,   42,  196,   67,  182,   -1,
   47,  185,   40,   41,   -1,   -1,   44,   77,   78,   79,
   80,  195,   -1,   -1,   10,   -1,   93,   94,   -1,   -1,
   58,   59,   -1,   37,  124,   -1,   93,   94,   42,   43,
   -1,   45,   -1,   47,   -1,   -1,  283,  284,  285,  286,
  287,  288,   38,   -1,   40,   41,   -1,  124,   44,  287,
  288,   -1,   -1,   -1,   -1,   93,   -1,  124,   -1,   -1,
   -1,   -1,   58,   59,  283,  284,  285,  286,  287,  288,
  289,  290,   -1,  294,  295,  296,  297,  298,  299,  300,
  301,  302,  303,  304,  305,  306,  307,  308,  309,  310,
  311,  312,  313,  314,  315,  316,  317,   93,   94,   -1,
   -1,  283,  284,  285,  286,  287,  288,  289,  290,  283,
  284,  285,  286,  287,  288,  289,  290,   64,   -1,   -1,
   10,   68,   69,   70,   -1,   -1,   -1,   10,  124,   -1,
   -1,   -1,   -1,   80,   -1,   -1,   83,   -1,  283,  284,
  285,  286,  287,  288,  289,  290,  283,  284,  285,  286,
   40,   41,  289,  290,   44,   38,   -1,   40,   41,   -1,
   -1,   44,   -1,   -1,   -1,   -1,   10,   -1,   58,   59,
   -1,   10,   -1,   -1,   -1,   58,   59,   60,   -1,   62,
   -1,   -1,   -1,  283,  284,  285,  286,   -1,   -1,  289,
  290,   -1,   -1,   -1,   38,   10,   40,   41,   -1,   -1,
   44,   40,   41,   93,   -1,   44,  283,  284,  285,  286,
   93,   94,  289,  290,   58,   59,  283,  284,   -1,   58,
   59,   -1,  289,  290,   -1,   40,   41,   -1,   -1,   44,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,  124,   -1,   58,   59,   -1,   -1,   -1,   -1,   93,
   94,  289,  290,   -1,   93,   94,   37,   38,   -1,   40,
   40,   42,   43,   43,   45,   45,   47,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   58,   93,   60,
  124,   62,   -1,   -1,   -1,  124,   -1,  283,  284,   -1,
   -1,   37,   38,  289,  290,   -1,   42,   43,   -1,   45,
   -1,   47,   37,   38,   -1,   40,   -1,   42,   43,  124,
   45,   91,   47,   94,   60,   -1,   62,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   60,   -1,   62,   37,   38,
   -1,   -1,   41,   42,   43,   -1,   45,   -1,   47,   -1,
   -1,   -1,   -1,  124,   -1,   -1,  126,   93,   94,   -1,
   -1,   60,   -1,   62,   -1,   -1,   37,   38,   -1,   94,
   -1,   42,   43,   -1,   45,   -1,   47,   37,   38,   -1,
   -1,   -1,   42,   43,   -1,   45,   -1,   47,  124,   60,
   -1,   62,   -1,   -1,   -1,   94,   -1,   -1,   -1,  124,
   60,   -1,   62,   -1,   -1,   -1,   -1,   -1,   35,  289,
  283,  284,  285,  286,   37,   38,  289,  290,   -1,   42,
   43,   37,   45,   94,   47,  124,   42,   43,   -1,   45,
   -1,   47,   -1,   -1,   94,   -1,   -1,   60,   -1,   62,
   -1,   -1,   37,   38,   60,   -1,   62,   42,   43,   -1,
   45,   -1,   47,  124,   -1,  289,  290,   -1,   -1,   -1,
  289,  290,   -1,   -1,  124,   60,   -1,   62,   37,   38,
   -1,   94,   -1,   42,   43,   -1,   45,   -1,   47,   -1,
   -1,   -1,   -1,   -1,  289,  290,  256,  257,  258,  259,
   -1,   60,   -1,   62,   -1,   -1,   -1,  267,  268,   94,
   -1,  124,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   43,
   -1,   45,  283,  284,  285,  286,  287,  288,  289,  290,
   -1,  291,  292,  293,   43,   40,   45,   -1,   43,   -1,
   45,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,  283,  284,  285,
  286,  287,  288,  289,  290,   -1,   -1,   91,  283,  284,
  285,  286,  287,  288,  289,  290,   -1,   -1,   -1,   -1,
   -1,   -1,   91,   43,   -1,   45,   91,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,  283,  284,  285,  286,  287,  288,
  289,  290,  126,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,  126,   -1,   -1,
   -1,  126,  283,  284,  285,  286,  287,  288,  289,  290,
   -1,   91,   -1,  283,  284,  285,  286,  287,  288,  256,
  290,  258,   -1,  260,  261,  262,   -1,   -1,   -1,   -1,
  267,   -1,  269,  270,  271,  272,  273,  274,  275,  276,
  277,  278,  279,  280,  281,  282,  126,   -1,   -1,   -1,
  283,  284,  285,  286,  287,  288,   -1,   -1,   -1,  285,
  286,  287,  288,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,  283,  284,
  285,  286,  287,  288,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,  283,  284,  285,  286,  287,  288,
   -1,   -1,  256,  257,  258,  259,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,  267,  268,   -1,   -1,  256,  257,  258,
  259,  256,  257,  258,  259,   -1,   -1,   -1,  267,  268,
   -1,    9,  267,  268,   -1,   13,   -1,  291,   16,   17,
   18,   19,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   27,
   -1,   -1,  291,   -1,   -1,   -1,   -1,   -1,   -1,   37,
   38,   39,   40,   -1,   -1,   -1,  256,  257,  258,  259,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,  267,  268,   -1,
   -1,   -1,   -1,   -1,   -1,   63,   -1,   65,   -1,   -1,
   -1,   -1,   -1,   71,   -1,   73,   74,   75,   76,   -1,
   -1,   -1,   -1,   81,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   91,   92,   93,   94,   95,   96,   97,
   98,   99,  100,  101,  102,  103,  104,  105,  106,  107,
  108,  109,  110,  111,  112,   -1,   -1,   -1,   -1,   -1,
  118,  294,  295,  296,  297,  298,  299,  300,  301,  302,
  303,  304,  305,  306,  307,  308,  309,  310,  311,  312,
  313,  314,  315,  316,  317,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
  178,  179,   -1,  181,  182,   -1,   -1,  185,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,  195,
};
#define YYFINAL 1
#ifndef YYDEBUG
#define YYDEBUG 0
#endif
#define YYMAXTOKEN 318
#if YYDEBUG
char *yyname[] = {
"end-of-file",0,0,0,0,0,0,0,0,0,"'\\n'",0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
0,0,0,0,"'#'",0,"'%'","'&'",0,"'('","')'","'*'","'+'","','","'-'",0,"'/'",0,0,0,
0,0,0,0,0,0,0,"':'","';'","'<'","'='","'>'",0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
0,0,0,0,0,0,0,0,0,0,"'['",0,"']'","'^'",0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
0,0,0,0,0,0,0,0,0,"'|'",0,"'~'",0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,"STRING","IDENT","FBSYM",
"CODE1","CODE2","CODE4","NUMBER0","NUMBER1","NUMBER2","NUMBER3","NUMBER","DOT",
"EXTERN","DATA","ASCII","SECTION","COMMON","BASE","SYMB","SYMD","ALIGN",
"ASSERT","SPACE","LINE","FILe","LIST","OP_EQ","OP_NE","OP_LE","OP_GE","OP_LL",
"OP_RR","OP_OO","OP_AA","R16","R8","RSEG","PREFIX","NOOP_1","NOOP_2","JOP",
"PUSHOP","IOOP","ADDOP","ROLOP","INCOP","NOTOP","CALLOP","CALFOP","LEAOP",
"ARPLOP","ESC","INT","RET","XCHG","TEST","MOV","IMUL","ENTER","EXTOP","EXTOP1",
"ST",
};
char *yyrule[] = {
"$accept : program",
"program :",
"program : program IDENT ':'",
"program : program NUMBER ':'",
"program : program CODE1",
"program : program CODE2",
"program : program CODE4",
"program : program operation ';'",
"program : program operation '\\n'",
"program : program '#' NUMBER STRING '\\n'",
"program : program error '\\n'",
"operation :",
"operation : IDENT '=' expr",
"operation : LIST",
"operation : SECTION IDENT",
"operation : COMMON IDENT ',' absexp",
"operation : BASE absexp",
"operation : ASSERT expr",
"$$1 :",
"operation : SYMB STRING ',' expr $$1 optabs2 optabs2",
"operation : SYMD STRING ',' absexp ',' absexp",
"operation : LINE optabs1",
"operation : FILe STRING",
"operation : EXTERN externlist",
"operation : ALIGN optabs1",
"operation : SPACE absexp",
"operation : DATA datalist",
"operation : ASCII STRING",
"externlist : IDENT",
"externlist : externlist ',' IDENT",
"datalist : expr",
"datalist : datalist ',' expr",
"expr : error",
"expr : NUMBER",
"expr : id_fb",
"expr : STRING",
"expr : '[' expr ']'",
"expr : expr OP_OO expr",
"expr : expr OP_AA expr",
"expr : expr '|' expr",
"expr : expr '^' expr",
"expr : expr '&' expr",
"expr : expr OP_EQ expr",
"expr : expr OP_NE expr",
"expr : expr '<' expr",
"expr : expr '>' expr",
"expr : expr OP_LE expr",
"expr : expr OP_GE expr",
"expr : expr OP_RR expr",
"expr : expr OP_LL expr",
"expr : expr '+' expr",
"expr : expr '-' expr",
"expr : expr '*' expr",
"expr : expr '/' expr",
"expr : expr '%' expr",
"expr : '+' expr",
"expr : '-' expr",
"expr : '~' expr",
"expr : DOT",
"id_fb : IDENT",
"id_fb : FBSYM",
"absexp : expr",
"optabs1 :",
"optabs1 : absexp",
"optabs2 :",
"optabs2 : ',' absexp",
"operation : prefix oper",
"prefix :",
"prefix : prefix PREFIX",
"oper : NOOP_1",
"oper : NOOP_2",
"oper : JOP expr",
"oper : PUSHOP ea_1",
"oper : IOOP expr",
"oper : IOOP R16",
"oper : ADDOP ea_ea",
"oper : ROLOP ea_ea",
"oper : INCOP ea_1",
"oper : IMUL ea_ea",
"oper : IMUL ea_1",
"oper : NOTOP ea_1",
"oper : CALLOP ea_1",
"oper : CALFOP expr ':' expr",
"oper : CALFOP mem",
"oper : ENTER absexp ',' absexp",
"oper : LEAOP R16 ',' mem",
"oper : ARPLOP mem ',' R16",
"oper : EXTOP R16 ',' ea_2",
"oper : EXTOP1 ea_1",
"oper : ESC absexp ',' mem",
"oper : INT absexp",
"oper : RET",
"oper : RET expr",
"oper : XCHG ea_ea",
"oper : TEST ea_ea",
"oper : MOV ea_ea",
"st_i : ST '(' absexp ')'",
"mem : '(' expr ')'",
"mem : bases",
"mem : expr bases",
"bases : '(' R16 ')'",
"bases : '(' R16 ')' '(' R16 ')'",
"ea_2 : mem",
"ea_2 : R8",
"ea_2 : R16",
"ea_2 : RSEG",
"ea_2 : expr",
"ea_1 : ea_2",
"ea_ea : ea_1 ',' ea_2",
};
#endif
#define yyclearin (yychar=(-1))
#define yyerrok (yyerrflag=0)
#ifdef YYSTACKSIZE
#ifndef YYMAXDEPTH
#define YYMAXDEPTH YYSTACKSIZE
#endif
#else
#ifdef YYMAXDEPTH
#define YYSTACKSIZE YYMAXDEPTH
#else
#define YYSTACKSIZE 200
#define YYMAXDEPTH 200
#endif
#endif
#if YYDEBUG
int yydebug;
#endif
int yynerrs;
int yyerrflag;
int yychar;
YYSTYPE yyval;
YYSTYPE yylval;
short yyss[YYSTACKSIZE];
YYSTYPE yyvs[YYSTACKSIZE];
#define yystacksize YYSTACKSIZE
#line 1149 "as.y"

#line 1096 "y.tab.c"
#define YYABORT goto yyabort
#define YYACCEPT goto yyaccept
#define YYERROR goto yyerrlab
int
yyparse()
{
    register int yym, yyn, yystate;
    register short *yyssp;
    register YYSTYPE *yyvsp;
#if YYDEBUG
    register char *yys;
    extern char *getenv();

    if (yys = getenv("YYDEBUG"))
    {
        yyn = *yys;
        if (yyn >= '0' && yyn <= '9')
            yydebug = yyn - '0';
    }
#endif

    yynerrs = 0;
    yyerrflag = 0;
    yychar = (-1);

    yyssp = yyss;
    yyvsp = yyvs;
    *yyssp = yystate = 0;

yyloop:
    if (yyn = yydefred[yystate]) goto yyreduce;
    if (yychar < 0)
    {
        if ((yychar = yylex()) < 0) yychar = 0;
#if YYDEBUG
        if (yydebug)
        {
            yys = 0;
            if (yychar <= YYMAXTOKEN) yys = yyname[yychar];
            if (!yys) yys = "illegal-symbol";
            printf("yydebug: state %d, reading %d (%s)\n", yystate,
                    yychar, yys);
        }
#endif
    }
    if ((yyn = yysindex[yystate]) && (yyn += yychar) >= 0 &&
            yyn <= YYTABLESIZE && yycheck[yyn] == yychar)
    {
#if YYDEBUG
        if (yydebug)
            printf("yydebug: state %d, shifting to state %d\n",
                    yystate, yytable[yyn]);
#endif
        if (yyssp >= yyss + yystacksize - 1)
        {
            goto yyoverflow;
        }
        *++yyssp = yystate = yytable[yyn];
        *++yyvsp = yylval;
        yychar = (-1);
        if (yyerrflag > 0)  --yyerrflag;
        goto yyloop;
    }
    if ((yyn = yyrindex[yystate]) && (yyn += yychar) >= 0 &&
            yyn <= YYTABLESIZE && yycheck[yyn] == yychar)
    {
        yyn = yytable[yyn];
        goto yyreduce;
    }
    if (yyerrflag) goto yyinrecovery;
#ifdef lint
    goto yynewerror;
#endif
yynewerror:
    yyerror("syntax error");
#ifdef lint
    goto yyerrlab;
#endif
yyerrlab:
    ++yynerrs;
yyinrecovery:
    if (yyerrflag < 3)
    {
        yyerrflag = 3;
        for (;;)
        {
            if ((yyn = yysindex[*yyssp]) && (yyn += YYERRCODE) >= 0 &&
                    yyn <= YYTABLESIZE && yycheck[yyn] == YYERRCODE)
            {
#if YYDEBUG
                if (yydebug)
                    printf("yydebug: state %d, error recovery shifting\
 to state %d\n", *yyssp, yytable[yyn]);
#endif
                if (yyssp >= yyss + yystacksize - 1)
                {
                    goto yyoverflow;
                }
                *++yyssp = yystate = yytable[yyn];
                *++yyvsp = yylval;
                goto yyloop;
            }
            else
            {
#if YYDEBUG
                if (yydebug)
                    printf("yydebug: error recovery discarding state %d\n",
                            *yyssp);
#endif
                if (yyssp <= yyss) goto yyabort;
                --yyssp;
                --yyvsp;
            }
        }
    }
    else
    {
        if (yychar == 0) goto yyabort;
#if YYDEBUG
        if (yydebug)
        {
            yys = 0;
            if (yychar <= YYMAXTOKEN) yys = yyname[yychar];
            if (!yys) yys = "illegal-symbol";
            printf("yydebug: state %d, error recovery discards token %d (%s)\n",
                    yystate, yychar, yys);
        }
#endif
        yychar = (-1);
        goto yyloop;
    }
yyreduce:
#if YYDEBUG
    if (yydebug)
        printf("yydebug: state %d, reducing by rule %d (%s)\n",
                yystate, yyn, yyrule[yyn]);
#endif
    yym = yylen[yyn];
    yyval = yyvsp[1-yym];
    switch (yyn)
    {
case 2:
#line 665 "as.y"
{	newident(yyvsp[-1].y_item, DOTTYP); newlabel(yyvsp[-1].y_item);}
break;
case 3:
#line 667 "as.y"
{	if (yyvsp[-1].y_valu < 0 || yyvsp[-1].y_valu > 9) {
					serror("bad f/b label");
					yyvsp[-1].y_valu = 0;
				}
				newlabel(fb_shift((int)yyvsp[-1].y_valu));
			}
break;
case 4:
#line 674 "as.y"
{	emit1((int)yyvsp[0].y_valu); if (listflag) listline(0);  			else if (listtemp) { listflag = listtemp; listeoln = 1; };}
break;
case 5:
#line 676 "as.y"
{	emit2((int)yyvsp[0].y_valu); if (listflag) listline(0);  			else if (listtemp) { listflag = listtemp; listeoln = 1; };}
break;
case 6:
#line 678 "as.y"
{	emit4((long)yyvsp[0].y_valu); if (listflag) listline(0);  			else if (listtemp) { listflag = listtemp; listeoln = 1; };}
break;
case 8:
#line 681 "as.y"
{	lineno++; if (listflag) listline(1);  			else if (listtemp) { listflag = listtemp; listeoln = 1; }; {if (!(relonami == 0)) assert2("/home/ceriel/evert/comm2.y", 129);};}
break;
case 9:
#line 683 "as.y"
{	lineno = yyvsp[-2].y_valu;
				if (modulename) strncpy(modulename, stringbuf, 200	-1);
				if (listflag) listline(1);  			else if (listtemp) { listflag = listtemp; listeoln = 1; }; {if (!(relonami == 0)) assert2("/home/ceriel/evert/comm2.y", 133);};
			}
break;
case 10:
#line 688 "as.y"
{	serror("syntax error"); yyerrok;
				lineno++; if (listflag) listline(1);  			else if (listtemp) { listflag = listtemp; listeoln = 1; }; {if (!(relonami == 0)) assert2("/home/ceriel/evert/comm2.y", 137);};
			}
break;
case 12:
#line 697 "as.y"
{

				if (listflag & 1)
					listcolm += printx(4, yyvsp[0].y_expr.val);

				newequate(yyvsp[-2].y_item, yyvsp[0].y_expr.typ);
				store(yyvsp[-2].y_item, yyvsp[0].y_expr.val);
			}
break;
case 13:
#line 707 "as.y"
{	if (yyvsp[0].y_word)
					listtemp = listmode;
				else if ((dflag & 01000) == 0)
					listtemp = 0;
			}
break;
case 14:
#line 714 "as.y"
{	newsect(yyvsp[0].y_item);}
break;
case 15:
#line 716 "as.y"
{	newcomm(yyvsp[-2].y_item, yyvsp[0].y_valu);}
break;
case 16:
#line 718 "as.y"
{	if (pass == 0) newbase(yyvsp[0].y_valu);}
break;
case 17:
#line 720 "as.y"
{	if (yyvsp[0].y_expr.val == 0 && pass == 2)
					warning("assertion failed");
			}
break;
case 18:
#line 723 "as.y"
{ o_it = last_it; }
break;
case 19:
#line 725 "as.y"
{	if ((sflag & 010	) && (pass != 0)) {

					if (
						pass == 2
						&&
						(yyvsp[-3].y_expr.typ & 0x007F			) == 0x0000			
					   ) {
						serror("expression undefined");
						relonami = -1;
					}
					if (
						(pass != 0)
						&&
						(yyvsp[-3].y_expr.typ & 0x1000			)
					   ) {
						




						yyvsp[-3].y_expr.typ = 0x007F						;
						yyvsp[-3].y_expr.val = new_string(o_it->i_name);
						relonami = 0;
					}

					    
					newsymb(
						*stringbuf ? stringbuf : (char *) 0,
						(short)(
							(yyvsp[-3].y_expr.typ & (0x0080			|0x007F			))
							|
							((unsigned short)yyvsp[-1].y_valu<<8)
						),
						(short)yyvsp[0].y_valu,
						yyvsp[-3].y_expr.val
					);
				}
			}
break;
case 20:
#line 764 "as.y"
{	if ((sflag & 010	) && (pass != 0)) {
					newsymb(
						*stringbuf ? stringbuf : (char *) 0,
						(short)(
							(DOTTYP & (0x0080			|0x007F			))
							|
							((unsigned short)yyvsp[-2].y_valu<<8)
						),
						(short)yyvsp[0].y_valu,
						(long)DOTVAL
					);
				}
			}
break;
case 21:
#line 778 "as.y"
{	if ((sflag & 020	) && (pass != 0)) {
					if (yyvsp[0].y_valu)
						hllino = (short)yyvsp[0].y_valu;
					else
						hllino++;
					newsymb(
						(char *)0,
						(DOTTYP | 0x0200			),
						hllino,
						(long)DOTVAL
					);
				}
			}
break;
case 22:
#line 792 "as.y"
{	if ((sflag & 020	) && (pass != 0)) {
					hllino = 0;
					newsymb(
						stringbuf,
						(DOTTYP | 0x0300			),
						0,
						(long)DOTVAL
					);
				}
			}
break;
case 24:
#line 804 "as.y"
{	align(yyvsp[0].y_valu);}
break;
case 25:
#line 806 "as.y"
{	if (DOTSCT == NULL)
					nosect();
				DOTVAL += yyvsp[0].y_valu;
				DOTSCT->s_zero += yyvsp[0].y_valu;
			}
break;
case 27:
#line 813 "as.y"
{	emitstr(yyvsp[-1].y_word);}
break;
case 28:
#line 817 "as.y"
{	yyvsp[0].y_item->i_type |= 0x0080			;}
break;
case 29:
#line 819 "as.y"
{	yyvsp[0].y_item->i_type |= 0x0080			;}
break;
case 30:
#line 823 "as.y"
{

				if (1 != 0 && (pass != 0))
					newrelo(yyvsp[0].y_expr.typ, (int)yyvsp[-1].y_word|(0));

				emitx(yyvsp[0].y_expr.val, (int)yyvsp[-1].y_word);
			}
break;
case 31:
#line 831 "as.y"
{

				if (1 != 0 && (pass != 0))
					newrelo(yyvsp[0].y_expr.typ, (int)yyvsp[-3].y_word|(0));

				emitx(yyvsp[0].y_expr.val, (int)yyvsp[-3].y_word);
			}
break;
case 32:
#line 840 "as.y"
{	serror("expr syntax err");
				yyval.y_expr.val = 0; yyval.y_expr.typ = 0x0000			;
			}
break;
case 33:
#line 844 "as.y"
{	yyval.y_expr.val = yyvsp[0].y_valu; yyval.y_expr.typ = 0x0001			;}
break;
case 34:
#line 846 "as.y"
{	yyval.y_expr.val = load(yyvsp[0].y_item); 
				last_it = yyvsp[0].y_item;
				yyval.y_expr.typ = yyvsp[0].y_item->i_type & ~0x0080			;
			}
break;
case 35:
#line 851 "as.y"
{	if (stringlen != 1)
					serror("too many chars");
				yyval.y_expr.val = stringbuf[0];
				yyval.y_expr.typ = 0x0001			;
			}
break;
case 36:
#line 857 "as.y"
{	yyval.y_expr = yyvsp[-1].y_expr;}
break;
case 37:
#line 859 "as.y"
{	yyval.y_expr.val = (yyvsp[-2].y_expr.val || yyvsp[0].y_expr.val);
				yyval.y_expr.typ = combine(yyvsp[-2].y_expr.typ, yyvsp[0].y_expr.typ, 0);
			}
break;
case 38:
#line 863 "as.y"
{	yyval.y_expr.val = (yyvsp[-2].y_expr.val && yyvsp[0].y_expr.val);
				yyval.y_expr.typ = combine(yyvsp[-2].y_expr.typ, yyvsp[0].y_expr.typ, 0);
			}
break;
case 39:
#line 867 "as.y"
{	yyval.y_expr.val = (yyvsp[-2].y_expr.val | yyvsp[0].y_expr.val);
				yyval.y_expr.typ = combine(yyvsp[-2].y_expr.typ, yyvsp[0].y_expr.typ, 0);
			}
break;
case 40:
#line 871 "as.y"
{	yyval.y_expr.val = (yyvsp[-2].y_expr.val ^ yyvsp[0].y_expr.val);
				yyval.y_expr.typ = combine(yyvsp[-2].y_expr.typ, yyvsp[0].y_expr.typ, 0);
			}
break;
case 41:
#line 875 "as.y"
{	yyval.y_expr.val = (yyvsp[-2].y_expr.val & yyvsp[0].y_expr.val);
				yyval.y_expr.typ = combine(yyvsp[-2].y_expr.typ, yyvsp[0].y_expr.typ, 0);
			}
break;
case 42:
#line 879 "as.y"
{	yyval.y_expr.val = (yyvsp[-2].y_expr.val == yyvsp[0].y_expr.val);
				yyval.y_expr.typ = combine(yyvsp[-2].y_expr.typ, yyvsp[0].y_expr.typ, '>');
			}
break;
case 43:
#line 883 "as.y"
{	yyval.y_expr.val = (yyvsp[-2].y_expr.val != yyvsp[0].y_expr.val);
				yyval.y_expr.typ = combine(yyvsp[-2].y_expr.typ, yyvsp[0].y_expr.typ, '>');
			}
break;
case 44:
#line 887 "as.y"
{	yyval.y_expr.val = (yyvsp[-2].y_expr.val < yyvsp[0].y_expr.val);
				yyval.y_expr.typ = combine(yyvsp[-2].y_expr.typ, yyvsp[0].y_expr.typ, '>');
			}
break;
case 45:
#line 891 "as.y"
{	yyval.y_expr.val = (yyvsp[-2].y_expr.val > yyvsp[0].y_expr.val);
				yyval.y_expr.typ = combine(yyvsp[-2].y_expr.typ, yyvsp[0].y_expr.typ, '>');
			}
break;
case 46:
#line 895 "as.y"
{	yyval.y_expr.val = (yyvsp[-2].y_expr.val <= yyvsp[0].y_expr.val);
				yyval.y_expr.typ = combine(yyvsp[-2].y_expr.typ, yyvsp[0].y_expr.typ, '>');
			}
break;
case 47:
#line 899 "as.y"
{	yyval.y_expr.val = (yyvsp[-2].y_expr.val >= yyvsp[0].y_expr.val);
				yyval.y_expr.typ = combine(yyvsp[-2].y_expr.typ, yyvsp[0].y_expr.typ, '>');
			}
break;
case 48:
#line 903 "as.y"
{	yyval.y_expr.val = (yyvsp[-2].y_expr.val >> yyvsp[0].y_expr.val);
				yyval.y_expr.typ = combine(yyvsp[-2].y_expr.typ, yyvsp[0].y_expr.typ, 0);
			}
break;
case 49:
#line 907 "as.y"
{	yyval.y_expr.val = (yyvsp[-2].y_expr.val << yyvsp[0].y_expr.val);
				yyval.y_expr.typ = combine(yyvsp[-2].y_expr.typ, yyvsp[0].y_expr.typ, 0);
			}
break;
case 50:
#line 911 "as.y"
{	yyval.y_expr.val = (yyvsp[-2].y_expr.val + yyvsp[0].y_expr.val);
				yyval.y_expr.typ = combine(yyvsp[-2].y_expr.typ, yyvsp[0].y_expr.typ, '+');
			}
break;
case 51:
#line 915 "as.y"
{	yyval.y_expr.val = (yyvsp[-2].y_expr.val - yyvsp[0].y_expr.val);
				yyval.y_expr.typ = combine(yyvsp[-2].y_expr.typ, yyvsp[0].y_expr.typ, '-');
			}
break;
case 52:
#line 919 "as.y"
{	yyval.y_expr.val = (yyvsp[-2].y_expr.val * yyvsp[0].y_expr.val);
				yyval.y_expr.typ = combine(yyvsp[-2].y_expr.typ, yyvsp[0].y_expr.typ, 0);
			}
break;
case 53:
#line 923 "as.y"
{	if (yyvsp[0].y_expr.val == 0) {
					if (pass == 2)
						serror("divide by zero");
					yyval.y_expr.val = 0;
				} else
					yyval.y_expr.val = (yyvsp[-2].y_expr.val / yyvsp[0].y_expr.val);
				yyval.y_expr.typ = combine(yyvsp[-2].y_expr.typ, yyvsp[0].y_expr.typ, 0);
			}
break;
case 54:
#line 932 "as.y"
{	if (yyvsp[0].y_expr.val == 0) {
					if (pass == 2)
						serror("divide by zero");
					yyval.y_expr.val = 0;
				} else
					yyval.y_expr.val = (yyvsp[-2].y_expr.val % yyvsp[0].y_expr.val);
				yyval.y_expr.typ = combine(yyvsp[-2].y_expr.typ, yyvsp[0].y_expr.typ, 0);
			}
break;
case 55:
#line 941 "as.y"
{	yyval.y_expr.val = yyvsp[0].y_expr.val;
				yyval.y_expr.typ = combine(0x0001			, yyvsp[0].y_expr.typ, 0);
			}
break;
case 56:
#line 945 "as.y"
{	yyval.y_expr.val = -yyvsp[0].y_expr.val;
				yyval.y_expr.typ = combine(0x0001			, yyvsp[0].y_expr.typ, 0);
			}
break;
case 57:
#line 949 "as.y"
{	yyval.y_expr.val = ~yyvsp[0].y_expr.val;
				yyval.y_expr.typ = combine(0x0001			, yyvsp[0].y_expr.typ, 0);
			}
break;
case 58:
#line 953 "as.y"
{	yyval.y_expr.val = DOTVAL;
				yyval.y_expr.typ = DOTTYP|0x0400;
			}
break;
case 61:
#line 961 "as.y"
{	if ((yyvsp[0].y_expr.typ & ~0x0080			) != 0x0001			)
					serror("must be absolute");
				yyval.y_valu = yyvsp[0].y_expr.val;
			}
break;
case 62:
#line 968 "as.y"
{	yyval.y_valu = 0;}
break;
case 63:
#line 970 "as.y"
{	yyval.y_valu = yyvsp[0].y_valu;}
break;
case 64:
#line 974 "as.y"
{	yyval.y_valu = 0;}
break;
case 65:
#line 976 "as.y"
{	yyval.y_valu = yyvsp[0].y_valu;}
break;
case 68:
#line 995 "as.y"
{	emit1(yyvsp[0].y_word);}
break;
case 69:
#line 998 "as.y"
{	emit1(yyvsp[0].y_word);}
break;
case 70:
#line 1000 "as.y"
{	emit2(yyvsp[0].y_word);}
break;
case 71:
#line 1002 "as.y"
{	branch(yyvsp[-1].y_word,yyvsp[0].y_expr);}
break;
case 72:
#line 1004 "as.y"
{	pushop(yyvsp[-1].y_word);}
break;
case 73:
#line 1006 "as.y"
{	emit1(yyvsp[-1].y_word);

				newrelo(yyvsp[0].y_expr.typ, 1			);

				emit1(yyvsp[0].y_expr.val);
			}
break;
case 74:
#line 1013 "as.y"
{	if (yyvsp[0].y_word!=2) serror("register error");
				emit1(yyvsp[-1].y_word+010);
			}
break;
case 75:
#line 1017 "as.y"
{	addop(yyvsp[-1].y_word);}
break;
case 76:
#line 1019 "as.y"
{	rolop(yyvsp[-1].y_word);}
break;
case 77:
#line 1021 "as.y"
{	incop(yyvsp[-1].y_word);}
break;
case 78:
#line 1023 "as.y"
{	imul(yyvsp[-1].y_word);}
break;
case 79:
#line 1025 "as.y"
{	regsize(yyvsp[-1].y_word); emit1(0366|(yyvsp[-1].y_word&1)); ea_1(yyvsp[-1].y_word&070);}
break;
case 80:
#line 1027 "as.y"
{	regsize(yyvsp[-1].y_word); emit1(0366|(yyvsp[-1].y_word&1)); ea_1(yyvsp[-1].y_word&070);}
break;
case 81:
#line 1029 "as.y"
{	callop(yyvsp[-1].y_word&0xFFFF);}
break;
case 82:
#line 1031 "as.y"
{	emit1(yyvsp[-3].y_word>>8);

				newrelo(yyvsp[0].y_expr.typ, 2			);

				emit2(yyvsp[0].y_expr.val);

				newrelo(yyvsp[-2].y_expr.typ, 2			);

				emit2(yyvsp[-2].y_expr.val);
			}
break;
case 83:
#line 1042 "as.y"
{	emit1(0377); ea_2(yyvsp[-1].y_word&0xFF);}
break;
case 84:
#line 1044 "as.y"
{	if (!(((((yyvsp[-2].y_valu) + 0x8000L) & ~0xFFFFL) == 0))) nofit(); if (!(((((yyvsp[0].y_valu) + 0x80) & ~((int)0xFF)) == 0))) nofit();
				emit1(yyvsp[-3].y_word); emit2((int)yyvsp[-2].y_valu); emit1((int)yyvsp[0].y_valu);
			}
break;
case 85:
#line 1048 "as.y"
{	emit1(yyvsp[-3].y_word); ea_2(yyvsp[-2].y_word<<3);}
break;
case 86:
#line 1050 "as.y"
{	emit1(yyvsp[-3].y_word); ea_2(yyvsp[0].y_word<<3);}
break;
case 87:
#line 1052 "as.y"
{	emit1(0xF); emit1(yyvsp[-3].y_word);
				ea_2(yyvsp[-2].y_word<<3);
			}
break;
case 88:
#line 1056 "as.y"
{	regsize(1); emit1(0xF); emit1(yyvsp[-1].y_word&07); 
				ea_1(yyvsp[-1].y_word&070);
			}
break;
case 89:
#line 1060 "as.y"
{	if (!(((yyvsp[-2].y_valu & 077) == yyvsp[-2].y_valu))) nofit();
				emit1(0330 | yyvsp[-2].y_valu>>3);
				ea_2((yyvsp[-2].y_valu&7)<<3);
			}
break;
case 90:
#line 1065 "as.y"
{	if (yyvsp[0].y_valu==3)
					emit1(0314);
				else {
					emit1(0315); emit1(yyvsp[0].y_valu);
				}
			}
break;
case 91:
#line 1072 "as.y"
{	emit1(yyvsp[0].y_word);}
break;
case 92:
#line 1074 "as.y"
{	emit1(yyvsp[-1].y_word-1);

				newrelo(yyvsp[0].y_expr.typ, 2			);

				emit2(yyvsp[0].y_expr.val);
			}
break;
case 93:
#line 1081 "as.y"
{	xchg(yyvsp[-1].y_word);}
break;
case 94:
#line 1083 "as.y"
{	test(yyvsp[-1].y_word);}
break;
case 95:
#line 1085 "as.y"
{	mov(yyvsp[-1].y_word);}
break;
case 96:
#line 1106 "as.y"
{	if (!((yyvsp[-1].y_valu & 07) == yyvsp[-1].y_valu)) {
					serror("illegal index in FP stack");
				}
				yyval.y_valu = yyvsp[-1].y_valu;
			}
break;
case 97:
#line 1113 "as.y"
{	mrg_2 = 6; exp_2 = yyvsp[-1].y_expr;
				{rel_2 =  relonami;  relonami = 0;};
			}
break;
case 98:
#line 1117 "as.y"
{	exp_2.val = 0; exp_2.typ = 0x0001			; indexed();}
break;
case 99:
#line 1119 "as.y"
{	exp_2 = yyvsp[-1].y_expr; indexed();
				{rel_2 =  relonami;  relonami = 0;};
			}
break;
case 100:
#line 1124 "as.y"
{	mrg_2 = sr_m[yyvsp[-1].y_word];}
break;
case 101:
#line 1126 "as.y"
{	mrg_2 = dr_m[yyvsp[-4].y_word][yyvsp[-1].y_word];}
break;
case 103:
#line 1130 "as.y"
{	mrg_2 = yyvsp[0].y_word | 0300;}
break;
case 104:
#line 1132 "as.y"
{	mrg_2 = yyvsp[0].y_word | 0310;}
break;
case 105:
#line 1134 "as.y"
{	mrg_2 = yyvsp[0].y_word | 020;}
break;
case 106:
#line 1136 "as.y"
{	mrg_2 = 040; exp_2 = yyvsp[0].y_expr;
				{rel_2 =  relonami;  relonami = 0;};
			}
break;
case 107:
#line 1141 "as.y"
{	mrg_1 = mrg_2; exp_1 = exp_2;
				{rel_1 =  rel_2;  rel_2 = 0;};
			}
break;
#line 1848 "y.tab.c"
    }
    yyssp -= yym;
    yystate = *yyssp;
    yyvsp -= yym;
    yym = yylhs[yyn];
    if (yystate == 0 && yym == 0)
    {
#if YYDEBUG
        if (yydebug)
            printf("yydebug: after reduction, shifting from state 0 to\
 state %d\n", YYFINAL);
#endif
        yystate = YYFINAL;
        *++yyssp = YYFINAL;
        *++yyvsp = yyval;
        if (yychar < 0)
        {
            if ((yychar = yylex()) < 0) yychar = 0;
#if YYDEBUG
            if (yydebug)
            {
                yys = 0;
                if (yychar <= YYMAXTOKEN) yys = yyname[yychar];
                if (!yys) yys = "illegal-symbol";
                printf("yydebug: state %d, reading %d (%s)\n",
                        YYFINAL, yychar, yys);
            }
#endif
        }
        if (yychar == 0) goto yyaccept;
        goto yyloop;
    }
    if ((yyn = yygindex[yym]) && (yyn += yystate) >= 0 &&
            yyn <= YYTABLESIZE && yycheck[yyn] == yystate)
        yystate = yytable[yyn];
    else
        yystate = yydgoto[yym];
#if YYDEBUG
    if (yydebug)
        printf("yydebug: after reduction, shifting from state %d \
to state %d\n", *yyssp, yystate);
#endif
    if (yyssp >= yyss + yystacksize - 1)
    {
        goto yyoverflow;
    }
    *++yyssp = yystate;
    *++yyvsp = yyval;
    goto yyloop;
yyoverflow:
    yyerror("yacc stack overflow");
yyabort:
    return (1);
yyaccept:
    return (0);
}
