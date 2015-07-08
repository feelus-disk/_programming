











%{





























































































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
%}



%union {
	short			y_word;
	long	y_valu;
	expr_t	y_expr;
	item_t	*y_item;

};


%token STRING
%token <y_item> IDENT
%token <y_item> FBSYM
%token <y_valu> CODE1
%token <y_valu> CODE2
%token <y_valu> CODE4
%token NUMBER0		
%token NUMBER1
%token NUMBER2
%token NUMBER3
%token <y_valu> NUMBER
%token DOT
%token EXTERN
%token <y_word> DATA
%token <y_word> ASCII
%token SECTION
%token COMMON
%token BASE
%token SYMB
%token SYMD
%token ALIGN
%token ASSERT
%token SPACE
%token <y_word> LINE
%token FILe
%token <y_word> LIST
%token OP_EQ
%token OP_NE
%token OP_LE
%token OP_GE
%token OP_LL
%token OP_RR
%token OP_OO
%token OP_AA

%left OP_OO
%left OP_AA
%left '|'
%left '^'
%left '&'
%left OP_EQ OP_NE
%left '<' '>' OP_LE OP_GE
%left OP_LL OP_RR
%left '+' '-'
%left '*' '/' '%' 
%nonassoc '~'

%type <y_valu> absexp optabs1 optabs2
%type <y_expr> expr
%type <y_item> id_fb














%token <y_word> R16
%token <y_word> R8
%token <y_word> RSEG
%token <y_word> PREFIX
%token <y_word> NOOP_1
%token <y_word> NOOP_2
%token <y_word> JOP
%token <y_word> PUSHOP
%token <y_word> IOOP
%token <y_word> ADDOP
%token <y_word> ROLOP
%token <y_word> INCOP
%token <y_word> NOTOP
%token <y_word> CALLOP
%token <y_word> CALFOP
%token <y_word> LEAOP
%token <y_word> ARPLOP
%token <y_word> ESC
%token <y_word> INT
%token <y_word> RET
%token <y_word> XCHG
%token <y_word> TEST
%token <y_word> MOV


%token <y_word> IMUL
%token <y_word> ENTER
%token <y_word> EXTOP
%token <y_word> EXTOP1







%token <y_word> ST

%type <y_valu> st_i

%%











program	:	

	|	program IDENT ':'
			{	newident($2, DOTTYP); newlabel($2);}
	|	program NUMBER ':'
			{	if ($2 < 0 || $2 > 9) {
					serror("bad f/b label");
					$2 = 0;
				}
				newlabel(fb_shift((int)$2));
			}
	|	program CODE1
			{	emit1((int)$2); if (listflag) listline(0);  			else if (listtemp) { listflag = listtemp; listeoln = 1; };}
	|	program CODE2
			{	emit2((int)$2); if (listflag) listline(0);  			else if (listtemp) { listflag = listtemp; listeoln = 1; };}
	|	program CODE4
			{	emit4((long)$2); if (listflag) listline(0);  			else if (listtemp) { listflag = listtemp; listeoln = 1; };}
	|	program operation ';'
	|	program operation '\n'
			{	lineno++; if (listflag) listline(1);  			else if (listtemp) { listflag = listtemp; listeoln = 1; }; {if (!(relonami == 0)) assert2("/home/ceriel/evert/comm2.y", 129);};}
	|	program '#' NUMBER STRING '\n'
			{	lineno = $3;
				if (modulename) strncpy(modulename, stringbuf, 200	-1);
				if (listflag) listline(1);  			else if (listtemp) { listflag = listtemp; listeoln = 1; }; {if (!(relonami == 0)) assert2("/home/ceriel/evert/comm2.y", 133);};
			}
	|	program error '\n'
			{	serror("syntax error"); yyerrok;
				lineno++; if (listflag) listline(1);  			else if (listtemp) { listflag = listtemp; listeoln = 1; }; {if (!(relonami == 0)) assert2("/home/ceriel/evert/comm2.y", 137);};
			}
	;


operation
	:	
	|	IDENT '=' expr
			{

				if (listflag & 1)
					listcolm += printx(4, $3.val);

				newequate($1, $3.typ);
				store($1, $3.val);
			}

	|	LIST
			{	if ($1)
					listtemp = listmode;
				else if ((dflag & 01000) == 0)
					listtemp = 0;
			}

	| 	SECTION IDENT
			{	newsect($2);}
	|	COMMON IDENT ',' absexp
			{	newcomm($2, $4);}
	|	BASE absexp
			{	if (pass == 0) newbase($2);}
	|	ASSERT expr
			{	if ($2.val == 0 && pass == 2)
					warning("assertion failed");
			}
	|	SYMB STRING ',' expr	{ o_it = last_it; }
		optabs2 optabs2
			{	if ((sflag & 010	) && (pass != 0)) {

					if (
						pass == 2
						&&
						($4.typ & 0x007F			) == 0x0000			
					   ) {
						serror("expression undefined");
						relonami = -1;
					}
					if (
						(pass != 0)
						&&
						($4.typ & 0x1000			)
					   ) {
						




						$4.typ = 0x007F						;
						$4.val = new_string(o_it->i_name);
						relonami = 0;
					}

					    
					newsymb(
						*stringbuf ? stringbuf : (char *) 0,
						(short)(
							($4.typ & (0x0080			|0x007F			))
							|
							((unsigned short)$6<<8)
						),
						(short)$7,
						$4.val
					);
				}
			}
	|	SYMD STRING ','  absexp ',' absexp
			{	if ((sflag & 010	) && (pass != 0)) {
					newsymb(
						*stringbuf ? stringbuf : (char *) 0,
						(short)(
							(DOTTYP & (0x0080			|0x007F			))
							|
							((unsigned short)$4<<8)
						),
						(short)$6,
						(long)DOTVAL
					);
				}
			}
	|	LINE optabs1
			{	if ((sflag & 020	) && (pass != 0)) {
					if ($2)
						hllino = (short)$2;
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
	|	FILe STRING
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
	|	EXTERN externlist
	|	ALIGN optabs1
			{	align($2);}
	|	SPACE absexp
			{	if (DOTSCT == NULL)
					nosect();
				DOTVAL += $2;
				DOTSCT->s_zero += $2;
			}
	|	DATA datalist
	|	ASCII STRING
			{	emitstr($1);}
	;
externlist
	:	IDENT
			{	$1->i_type |= 0x0080			;}
	|	externlist ',' IDENT
			{	$3->i_type |= 0x0080			;}
	;
datalist
	:	expr
			{

				if (1 != 0 && (pass != 0))
					newrelo($1.typ, (int)$<y_word>0|(0));

				emitx($1.val, (int)$<y_word>0);
			}
	|	datalist ',' expr
			{

				if (1 != 0 && (pass != 0))
					newrelo($3.typ, (int)$<y_word>0|(0));

				emitx($3.val, (int)$<y_word>0);
			}
	;
expr	:	error
			{	serror("expr syntax err");
				$$.val = 0; $$.typ = 0x0000			;
			}
	|	NUMBER
			{	$$.val = $1; $$.typ = 0x0001			;}
	|	id_fb
			{	$$.val = load($1); 
				last_it = $1;
				$$.typ = $1->i_type & ~0x0080			;
			}
	|	STRING
			{	if (stringlen != 1)
					serror("too many chars");
				$$.val = stringbuf[0];
				$$.typ = 0x0001			;
			}
	|	'[' expr ']'
			{	$$ = $2;}
	|	expr OP_OO expr
			{	$$.val = ($1.val || $3.val);
				$$.typ = combine($1.typ, $3.typ, 0);
			}
	|	expr OP_AA expr
			{	$$.val = ($1.val && $3.val);
				$$.typ = combine($1.typ, $3.typ, 0);
			}
	|	expr '|' expr
			{	$$.val = ($1.val | $3.val);
				$$.typ = combine($1.typ, $3.typ, 0);
			}
	|	expr '^' expr
			{	$$.val = ($1.val ^ $3.val);
				$$.typ = combine($1.typ, $3.typ, 0);
			}
	|	expr '&' expr
			{	$$.val = ($1.val & $3.val);
				$$.typ = combine($1.typ, $3.typ, 0);
			}
	|	expr OP_EQ expr
			{	$$.val = ($1.val == $3.val);
				$$.typ = combine($1.typ, $3.typ, '>');
			}
	|	expr OP_NE expr
			{	$$.val = ($1.val != $3.val);
				$$.typ = combine($1.typ, $3.typ, '>');
			}
	|	expr '<' expr
			{	$$.val = ($1.val < $3.val);
				$$.typ = combine($1.typ, $3.typ, '>');
			}
	|	expr '>' expr
			{	$$.val = ($1.val > $3.val);
				$$.typ = combine($1.typ, $3.typ, '>');
			}
	|	expr OP_LE expr
			{	$$.val = ($1.val <= $3.val);
				$$.typ = combine($1.typ, $3.typ, '>');
			}
	|	expr OP_GE expr
			{	$$.val = ($1.val >= $3.val);
				$$.typ = combine($1.typ, $3.typ, '>');
			}
	|	expr OP_RR expr
			{	$$.val = ($1.val >> $3.val);
				$$.typ = combine($1.typ, $3.typ, 0);
			}
	|	expr OP_LL expr
			{	$$.val = ($1.val << $3.val);
				$$.typ = combine($1.typ, $3.typ, 0);
			}
	|	expr '+' expr
			{	$$.val = ($1.val + $3.val);
				$$.typ = combine($1.typ, $3.typ, '+');
			}
	|	expr '-' expr
			{	$$.val = ($1.val - $3.val);
				$$.typ = combine($1.typ, $3.typ, '-');
			}
	|	expr '*' expr
			{	$$.val = ($1.val * $3.val);
				$$.typ = combine($1.typ, $3.typ, 0);
			}
	|	expr '/' expr
			{	if ($3.val == 0) {
					if (pass == 2)
						serror("divide by zero");
					$$.val = 0;
				} else
					$$.val = ($1.val / $3.val);
				$$.typ = combine($1.typ, $3.typ, 0);
			}
	|	expr '%' expr
			{	if ($3.val == 0) {
					if (pass == 2)
						serror("divide by zero");
					$$.val = 0;
				} else
					$$.val = ($1.val % $3.val);
				$$.typ = combine($1.typ, $3.typ, 0);
			}
	|	'+' expr %prec '*'
			{	$$.val = $2.val;
				$$.typ = combine(0x0001			, $2.typ, 0);
			}
	|	'-' expr %prec '*'
			{	$$.val = -$2.val;
				$$.typ = combine(0x0001			, $2.typ, 0);
			}
	|	'~' expr
			{	$$.val = ~$2.val;
				$$.typ = combine(0x0001			, $2.typ, 0);
			}
	|	DOT
			{	$$.val = DOTVAL;
				$$.typ = DOTTYP|0x0400;
			}
	;
id_fb	:	IDENT
	|	FBSYM
	;
absexp	:	expr
			{	if (($1.typ & ~0x0080			) != 0x0001			)
					serror("must be absolute");
				$$ = $1.val;
			}
	;
optabs1
	:	
			{	$$ = 0;}
	|	absexp
			{	$$ = $1;}
	;
optabs2
	:	
			{	$$ = 0;}
	|	',' absexp
			{	$$ = $2;}
	;












operation
	:	prefix oper
	;
prefix	:	
	|	prefix PREFIX
			{	emit1($2);}
	;
oper	:	NOOP_1
			{	emit1($1);}
	|	NOOP_2
			{	emit2($1);}
	|	JOP expr
			{	branch($1,$2);}
	|	PUSHOP ea_1
			{	pushop($1);}
	|	IOOP expr
			{	emit1($1);

				newrelo($2.typ, 1			);

				emit1($2.val);
			}
	|	IOOP R16
			{	if ($2!=2) serror("register error");
				emit1($1+010);
			}
	|	ADDOP ea_ea
			{	addop($1);}
	|	ROLOP ea_ea
			{	rolop($1);}
	|	INCOP ea_1
			{	incop($1);}
	|	IMUL ea_ea
			{	imul($1);}
	|	IMUL ea_1
			{	regsize($1); emit1(0366|($1&1)); ea_1($1&070);}
	|	NOTOP ea_1
			{	regsize($1); emit1(0366|($1&1)); ea_1($1&070);}
	|	CALLOP ea_1
			{	callop($1&0xFFFF);}
	|	CALFOP expr ':' expr
			{	emit1($1>>8);

				newrelo($4.typ, 2			);

				emit2($4.val);

				newrelo($2.typ, 2			);

				emit2($2.val);
			}
	|	CALFOP mem
			{	emit1(0377); ea_2($1&0xFF);}
	|	ENTER absexp ',' absexp
			{	if (!((((($2) + 0x8000L) & ~0xFFFFL) == 0))) nofit(); if (!((((($4) + 0x80) & ~((int)0xFF)) == 0))) nofit();
				emit1($1); emit2((int)$2); emit1((int)$4);
			}
	|	LEAOP R16 ',' mem
			{	emit1($1); ea_2($2<<3);}
	|	ARPLOP mem ',' R16
			{	emit1($1); ea_2($4<<3);}
	|	EXTOP	R16 ',' ea_2
			{	emit1(0xF); emit1($1);
				ea_2($2<<3);
			}
	|	EXTOP1	ea_1
			{	regsize(1); emit1(0xF); emit1($1&07); 
				ea_1($1&070);
			}
	|	ESC absexp ',' mem
			{	if (!((($2 & 077) == $2))) nofit();
				emit1(0330 | $2>>3);
				ea_2(($2&7)<<3);
			}
	|	INT absexp
			{	if ($2==3)
					emit1(0314);
				else {
					emit1(0315); emit1($2);
				}
			}
	|	RET
			{	emit1($1);}
	|	RET expr
			{	emit1($1-1);

				newrelo($2.typ, 2			);

				emit2($2.val);
			}
	|	XCHG ea_ea
			{	xchg($1);}
	|	TEST ea_ea
			{	test($1);}
	|	MOV ea_ea
			{	mov($1);}

















	;

st_i	:	ST '(' absexp ')'
			{	if (!(($3 & 07) == $3)) {
					serror("illegal index in FP stack");
				}
				$$ = $3;
			}
	;
mem	:	'(' expr ')'
			{	mrg_2 = 6; exp_2 = $2;
				{rel_2 =  relonami;  relonami = 0;};
			}
	|	bases
			{	exp_2.val = 0; exp_2.typ = 0x0001			; indexed();}
	|	expr bases
			{	exp_2 = $1; indexed();
				{rel_2 =  relonami;  relonami = 0;};
			}
	;
bases	:	'(' R16 ')'
			{	mrg_2 = sr_m[$2];}
	|	'(' R16 ')' '(' R16 ')'
			{	mrg_2 = dr_m[$2][$5];}
	;
ea_2	:	mem
	|	R8
			{	mrg_2 = $1 | 0300;}
	|	R16
			{	mrg_2 = $1 | 0310;}
	|	RSEG
			{	mrg_2 = $1 | 020;}
	|	expr
			{	mrg_2 = 040; exp_2 = $1;
				{rel_2 =  relonami;  relonami = 0;};
			}
	;
ea_1	:	ea_2
			{	mrg_1 = mrg_2; exp_1 = exp_2;
				{rel_1 =  rel_2;  rel_2 = 0;};
			}
	;
ea_ea	:	ea_1 ',' ea_2
	;

%%

