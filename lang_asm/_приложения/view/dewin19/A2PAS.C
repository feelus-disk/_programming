#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <alloc.h>
#include <ctype.h>
#include <dos.h>
#include <process.h>

// компилиpовать в модели Compact !
typedef unsigned char uchar;
typedef unsigned int uint;
typedef unsigned long ulong;

#define MAX_RPL  128    // всего заменяемых фраз
#define MAX_FIND 16    // всего строк в одной заменяемой фразе

#define HASH_S 32      // size of string queue
typedef struct
{
   int  base;          // левый отступ
   int  fc;            // сколько строк искать
   char far *find[MAX_FIND]; // для поиска xx подряд идущих строк
   char far *repl;     // заменяем одной строкой
   long times;		// сколько раз вызван по всему тексту
   int  line_num;	// номер строки в скрипте
} RPL;

int rpl_total=-1;      // всего прочитано фраз для замены (индекс последнего)
RPL *rpl;

#define MaxChar 200     // символов в строке

static FILE *in, *out;         // входной и выходной файлы

char GetLine[MaxChar];  // буфер для чтения одной строки файла

int index;
int cur_line=0;

char Hash[HASH_S][MaxChar]; // контейнеры строк очереди
char pHash[HASH_S];         // номер контейнера строки
char pHashClass[HASH_S];    // класс строки, 0 если пустая, 1 если CR

char cut_string[120]; // строка для вырезания из входного потока

char tmpS[MaxChar];     // временный буфер строки

// возвращает число больше нуля, если строка содержит
// шестнадцатиричное или десятичное число
// результат-длина числа в символах
// само число помещается в &i
int xdigit( char far *s, uint *i )
{
   uchar c;
   int k=0;
   ulong n=0;
   while (isxdigit(c=toupper(*s)))
   {
      c-='0';
      if (c>9) c-= 'A'-'0'-10;
      n<<=4;
      n+=(ulong)c;
      k++; s++;
      if (k==1 && c>9) return 0; // первая должна быть цифра
   };
   if ( k )
   {
      if ( toupper(*s)=='H' ) { s++; k++; };
      *i = (uint)n;
   }
   return k;
}

// возвращает число больше нуля, если строка содержит
// десятичное число
// результат-длина числа в символах
// само число помещается в &i
// пропускает пробелы до и запятую после числа
int xdigit10( char far *s, uint *i )
{
   uchar c;
   int k=0, m=0;
   ulong n=0;
   while ( *s==0x20 )
   {
      s++; m++;
   }
   while (isdigit(c=toupper(*s)))
   {
      c-='0';
      n*=10;
      n+=(ulong)c;
      k++; s++;
   };
   if ( k )
   {
      if ( *s==',' ) { s++; k++; };
      *i = (uint)n;
      return k+m;
   }
   return 0;
}


// возвращает число больше нуля, если строка содержит
// строку ASCII-символов (только латинских букв, цифр и подчеркивания)
// результат-длина в символах
int astring( char far *s )
{
   uchar c;
   int k=0;
   while (isdigit(c=toupper(*s)) || isalpha(c) || c=='_')
   {
      k++; s++;
      if ((k==1) && isdigit(c)) return 0; // первая должна быть не цифра
   };
   return k;
}

char *XDIGIT="<xdigit>";
#define XD_LEN 8
char *ASTRING="<astring>";
#define AS_LEN 9

// сравнение двух участков памяти
int xmemcmp( uchar far *str, uchar far *templ, int len )
{
   uint i,k;
   while ( len ) // по всей длине
   {
      switch ( *templ )
      {
	case '?': break;
	case '*':
	    for ( k=0; k<16; k++ ) // недалеко должен быть следующий символ
	       if ( *(templ+1) == *(str+k) )
	       {
		  templ++; len--; str += k; goto a;
	       }
	    return 1; // не совпало
	case '<':
	    if (strstr(templ, XDIGIT )==templ)
	    {
	       if ((k=xdigit( str, &i )) == 0) return -1;
	       str+=k; len-=XD_LEN; templ+=XD_LEN;
	       continue;
	    }
	    if (strstr(templ, ASTRING )==templ)
	    {
	       if ((k=astring( str )) == 0) return -1;
	       str+=k; len-=AS_LEN; templ+=AS_LEN;
	       continue;
	    }
	default :
	    if ( *str != *templ) return *str - *templ;
      }
      templ++; str++; len--;
     a:
   };
   return 0; // сравнение успешно
};

// возвращает 1 если слово *what найдено в указанном месте where
int is( int where, int pos, char far *what)
{
   int i, s;
   if (pHashClass[where]<2) return 0; // в пустых строках нечего искать
   s=strlen(Hash[pHash[where]]); // длина подозреваемой строки
   if (pos>=s) return 0;         // когда строка заведомо короче
   i=strlen(what);
   return ((xmemcmp( &(Hash[pHash[where]][pos]), what, i )==0) ? 1 : 0);
};

// извлекает строку
void copy( int where, int pos, char far *to )
{
   int i, s;
   s=strlen(Hash[pHash[where]]);
   if (pos>s) { *to=0; return; }
   strcpy( to, &(Hash[pHash[where]][pos]));
};

char far *adr( int where, int pos )
{
   return &(Hash[pHash[where]][pos]);
};

void clean( int n )
{
   pHashClass[n]=0;
};

char repl_str[MaxChar]; // глобальный буфер для замены
int base;

static char *err_mid = "Ошибка в <mid >\n";
static char *err_out = "Ошибка в <out >\n";
static char *err_lookup = "Ошибка в <lookup >\n";

// выход в ДОС с сообщением об ошибке
static void err_exit( char *msg )
{
   printf(msg);
   exit(1);
};

extern char lkp_filename[]; // файл подстановок
static char lookup_str[40]; // строка по которой идет поиск в файле
                            // [имя_модуля].lkp

// ищет в текстовом файле строку, начинающуюся с lookup_str и
// если найдена, то остаток (не включая lookup_str) выдается
// через **sub
// возвращает 1 если найдено, иначе 0
static int lookup( char *lookup_str, int lk, char **sub )
{
   FILE *in;
   int len;
   char buf[90];
   static char val[90];

   if ((in=fopen( lkp_filename, "rt" ))==NULL) return 0;
   while ( fgets( buf, 80, in ))
   {
       if ((len=strlen(buf)) < lk ) continue; // негде искать
       if ( len )
       {
	  if ( buf[len-1]==0x0D || buf[len-1]==0x0A)
	  {
	     buf[len-1]=0; len--;
	  }
       }
       if ( !len || buf[0]==';' ) continue;

       if ( !memcmp( buf, lookup_str, lk ))
       {
          fclose(in);
          strcpy( val, &buf[lk] );
          *sub = val;
          return 1;
       }
   }
   fclose(in);
   return 0;
}

//------------------------------------------------------------------------
//
//                       символ-ограничитель ───┐
//                                              │
// макроподстановка строки замены <lookup 1, 2, 0>
//                                        │  │
//             номер строки 0.. ──────────┘  └── позиция от <base> вправо
char *XLOOKUP="<lookup ";
#define XL_LEN 8
//------------------------------------------------------------------------
//
//                    символ-ограничитель ───┐
//                                           │
// макроподстановка строки замены <mid 1, 2, 0>
//                                     │  │
//          номер строки 0.. ──────────┘  └── позиция от <base> вправо
char *XMID="<mid ";
#define XM_LEN 5
char *XOUT="<out ";
#define XO_LEN 5
void repl_mid( char *fmt, char *repl_str )
{
   int i, k;
   uint line, pos, lim;
   char limit, minus;
   char *sub;
   int lk;

   i=0;
   repl_str[0]=0;

   while ( *fmt )
   {
      if (!memcmp(fmt, XLOOKUP, XL_LEN )) // если найден макрос
      {
	 fmt+=XL_LEN;
	 k=xdigit10( fmt, &line );
	 if ( k==0 ) err_exit(err_lookup);
	 fmt+=k;
	 minus=0;
	 if (*fmt=='-') { fmt++; minus=1; };
	 k=xdigit10( fmt, &pos );
	 if ( k==0 ) err_exit(err_lookup);
	 if (minus) pos= -pos;
	 fmt+=k;
	 if (*fmt==0x27) // символ-ограничитель в кавычках 'x'
	 {
	    lim=( fmt[1] & 0x0FF );
	    if (lim!=0 && fmt[2]==0x27 ) k=3; else k=0;
	 }
	 else k=xdigit10( fmt, &lim ); // или как десятичный ASCII код
	 if ( k==0 ) err_exit(err_lookup);
	 fmt+=k;
	 if ( *fmt=='>' )
	 {
            lk=0;
	    fmt++;
	    limit=(char)lim;
	    sub=adr( line, pos+base );
	    while ( *sub && *sub != limit ) lookup_str[lk++]= *sub++;
            lookup_str[lk] = 0;
            if (lookup( lookup_str, lk, &sub ))
	    while ( *sub ) repl_str[i++]= *sub++;
            else
            {
               sub = lookup_str;
	       while ( *sub ) repl_str[i++]= *sub++;
            }
	 }
	 else err_exit("Ошибка: ожидается '>' в макро <lookup >\n"); 
	 continue;
      }
      else
      if (!memcmp(fmt, XMID, XM_LEN )) // если найден макрос
      {
	 fmt+=XM_LEN;
	 k=xdigit10( fmt, &line );
	 if ( k==0 ) err_exit(err_mid);
	 fmt+=k;
	 minus=0;
	 if (*fmt=='-') { fmt++; minus=1; };
	 k=xdigit10( fmt, &pos );
	 if ( k==0 ) err_exit(err_mid);
	 if (minus) pos= -pos;
	 fmt+=k;
	 if (*fmt==0x27) // символ-ограничитель в кавычках 'x'
	 {
	    lim=( fmt[1] & 0x0FF );
	    if (lim!=0 && fmt[2]==0x27 ) k=3; else k=0;
	 }
	 else k=xdigit10( fmt, &lim ); // или как десятичный ASCII код
	 if ( k==0 ) err_exit(err_mid);
	 fmt+=k;
	 if ( *fmt=='>' )
	 {
	    fmt++;
	    limit=(char)lim;
	    sub=adr( line, pos+base );
	    while ( *sub && *sub != limit ) repl_str[i++]= *sub++;
	 }
	 else err_exit("Ошибка: ожидается '>' в макро <mid >\n"); 
	 continue;
      }
      else
      if (!memcmp(fmt, XOUT, XO_LEN )) // если найден макрос
      {
	 fmt+=XO_LEN;
	 k=xdigit10( fmt, &line );
	 if ( k==0 ) err_exit(err_out);
	 fmt+=k;
	 minus=0;
	 if (*fmt=='-') { fmt++; minus=1; };
	 k=xdigit10( fmt, &pos );
	 if ( k==0 ) err_exit(err_out);
	 if (minus) pos= -pos;
	 fmt+=k;
	 if (*fmt==0x27) // символ-ограничитель в кавычках 'x'
	 {
	    lim=( fmt[1] & 0x0FF );
	    if (lim!=0 && fmt[2]==0x27 ) k=3; else k=0;
	 }
	 else k=xdigit10( fmt, &lim ); // или как десятичный ASCII код
	 if ( k==0 ) err_exit(err_out);
	 fmt+=k;
	 if ( *fmt=='>' )
	 {
	    fmt++;
	    limit=(char)lim;
	    sub=adr( line, pos+base );
	    while ( *sub != limit ) putchar( *sub++ );
	    printf("\n");
	 }
	 else err_exit("Ошибка: ожидается '>' в макро <out >\n");
	 continue;
      }
      else
      repl_str[i++]= *fmt++;
   }
   repl_str[i]=0;
};

//------------------------------------------------------------------------
//
// макроподстановка строки замены <dec 1, 2>   аналог val(left$(a$,b))
//                                     │  │
//          номер строки 0.. ──────────┘  └── позиция от <base> вправо
char *XDEC="<dec ";
#define XC_LEN 5
void repl_dec( char *fmt, char *repl_str )
{
   int i, k;
   uint line, pos, n;
   char *sub; char nbuf[20];

   i=0;
   repl_str[0]=0;

   while ( *fmt )
   {
      if (!memcmp(fmt, XDEC, XC_LEN )) // если найден макрос
      {
	 fmt+=XC_LEN;
	 k=xdigit10( fmt, &line );
	 if ( k==0 ) { printf("Ошибка в <dec >\n"); exit(1);};
	 fmt+=k;
	 k=xdigit10( fmt, &pos );
	 if ( k==0 ) { printf("Ошибка в <dec >\n"); exit(1);};
	 fmt+=k;
	 if ( *fmt=='>' )
	 {
	    fmt++;
	    sub=adr( line, pos+base );
	    k=xdigit( sub, &n );
	    if ( k==0 ) { printf("<dec > ссылается на строку, не содержащую HEX-число\n"); exit(1);};
	    sprintf( nbuf, "%u", n );
	    sub = nbuf;
	    while ( *sub ) repl_str[i++]= *sub++;
	 }
	 else { printf("Ошибка: ожидается '>' в макро <dec >\n"); exit(1);};
	 continue;
      }
      else repl_str[i++]= *fmt++;
   }
   repl_str[i]=0;
};

char temp_str[MaxChar];
// обрабатывает строку замены
void replace( char *fmt )
{
   repl_mid( fmt, temp_str );
   repl_dec( temp_str, repl_str );
};

// обрабатывает строки
void make(void)
{
   int i,j,next,fc;

   // по всем массивам фраз для замены
   for ( i=0; i < rpl_total; i++ )
   {
      base=rpl[i].base;
      fc=rpl[i].fc;
      // если даже первая не совпала, замену не делать
      if (!is(0, base, rpl[i].find[0])) goto skip;

      if ( fc>2 ) // если строк в образце много
      {
	 // то проверим последнюю
	 if (is(fc-1, base, rpl[i].find[fc-1])) fc--;
	 else goto skip;
      };

      // по всем искомым фразам (первую уже видели)
      for ( j=1; j < fc ; j++ )
      {
	 // если хотя бы одна не совпала, замену не делать
	 if (!is(j, base, rpl[i].find[j])) goto skip;
      };
      replace( rpl[i].repl );
      strcpy( adr( 0, base), repl_str);
      rpl[i].times++;

      // по всем фразам текста кроме первой - очистить
      for ( j=1; j < rpl[i].fc; j++ ) clean(j);

      return;
      skip:
   }
};

// преобразует пробелы в табуляторы, возвращает длину строки
int pack_spaces( char far *s )
{
   int out_pos, i, spaces;
   strcpy( tmpS, s );
   i=out_pos=spaces=0;
   while ( tmpS[i] ) // от начала до конца входной строки
   {
      if ( tmpS[i]!=0x20 ) // если не пробел
      {
	 s[out_pos++]=tmpS[i++];
	 spaces=0;
      }
      else
      {
	 s[out_pos++]=tmpS[i++]; spaces++;
	 if (( i % 8 )==0 )
	 {
	    out_pos-=spaces;
	    s[out_pos++]=0x09; // tab
            spaces=0;
         }
      };
   };
   s[out_pos]=0; // терминатор
   return out_pos;
};

// проталкивает строку из файла в конец очереди, при этом
// строка из начала очереди выгружается в файл на диск
int xCR=0x0A0D;
void push_queue(void)
{
   int i;
   char j,k;

   make(); // обработка строк

   // put out head of queue
   if ( pHashClass[0] != 0 )
   {
      if ( pHashClass[0] == 1 ) fputs( /* "\r\n" */ "\n",out);
      else
      {
	 fwrite( Hash[pHash[0]], pack_spaces(Hash[pHash[0]]), 1, out );
         // fwrite( &xCR, sizeof(int), 1, out );
         fputs( "\n", out );
      };
   }

   // pull down the queue
   j = pHash[0];
   for ( i=0; i<HASH_S-1; i++)
   {
      pHash[i] = pHash[i+1];
      pHashClass[i] = pHashClass[i+1];
   }
   pHash[HASH_S-1] = j;
   pHashClass[HASH_S-1] = 1;

   // place last string into queue
   if (GetLine[0] != 0)
   {
      strcpy( Hash[pHash[HASH_S-1]], GetLine);
      pHashClass[HASH_S-1] = 2;
   }
   else Hash[pHash[HASH_S-1]][0] = 0;
}

// срезает концевые ПС и ВК в строке
static void trunc( char * s)
{
   int j=strlen(s);
   while (j)
   if (s[j-1]==0x0D || s[j-1]==0x0A) { s[j-1]=0; j--; } else return;
};

// преобразует табуляторы в пробелы, возвращает длину строки
int expand_tabs( char far *s )
{
   int out_pos, i;
   strcpy( tmpS, s );
   i=out_pos=0;
   while ( tmpS[i] ) // от начала до конца входной строки
   {
      if ( tmpS[i]!=0x09 ) // если не табулятор
      {
	 s[out_pos++]=tmpS[i];
      }
      else do s[out_pos++]=' '; while ( out_pos % 8 );
      i++;
   };
   s[out_pos]=0; // терминатор
   return out_pos;
};

// проверяет, начинается ли строка с заданного слова
int begin( char far *s)
{
   return (strstr( GetLine, s )==GetLine) ? 1 : 0;
};

// обработчик ошибок сценария
void script_error(int line, char *msg)
{
   printf("Script error, line %u, %s\n", line, msg );
   fclose(in); exit(1);
};

#define ON(x) if (begin((x)))

void check(int mode)
{
   if ( mode==1 ) script_error( cur_line,
	"Раздел <find..> не имеет своего <repl>");
   if ( ++rpl_total==MAX_RPL ) script_error( cur_line,
	"Слишком много разделов <find..>");
}

void load_script( char *progname )
{
   char *cfg, mode;
   int i, fc;

   // приоритет в текущем каталоге
   if ((in = fopen( "dewin.mac", "rb"))  != NULL) goto local_script;
   cfg=strstr(strupr(progname), ".EXE");
   if ( cfg )
   {
      strcpy( cfg, ".mac" );
      if ((in = fopen( progname, "rb"))  == NULL)
      {
	 printf("Can not open script '%s'\n", progname); exit(1);
      }
   local_script:
      rpl = farmalloc( sizeof( RPL ) * (MAX_RPL+1));
      if ( rpl==NULL )
      {
	 printf("No memory for rpl[]\n"); exit(1);
      }
      for ( i=0; i<MAX_RPL; i++ )
      {
	 rpl[i].base=0;
         rpl[i].fc  =0;
         rpl[i].repl=NULL;
	 rpl[i].times=0L;
	 rpl[i].line_num=0;
      }
      mode=0;
      cur_line=0;
      while (fgets( GetLine, MaxChar-2, in))
      {
          trunc( GetLine ); cur_line++; // truncate \r \n
          if ( GetLine[0]==0 ) continue; // пустые строки не берем
          if ( begin(";;") ) continue; // комментарии игнорируем

	  ON("<end>")
          {
	     if (mode!=2) script_error( cur_line, "Неожиданный <end>");
             break;
          };
          ON("<find>")
          {
	     check(mode);
             if ( rpl_total>0 ) rpl[rpl_total].base = rpl[rpl_total-1].base;
             mode=1; rpl[rpl_total].line_num=cur_line; continue;
          }
	  ON("<base>")
	  {
	     if ( mode!=1 ) script_error( cur_line,
		 "Параметр <base>[xx] должен быть в разделе <find>");
	     rpl[rpl_total].base=atoi(&GetLine[6]);
	     continue;
	  }
	  ON("<repl>")
          {
             if ( mode!=1 ) script_error( cur_line,
                    "Раздел <repl> должен следовать за <find>");
	     mode=2; continue;
	  }
	  fc=rpl[rpl_total].fc;
	  switch ( mode )
	  {
	       case 1:
		  if ( fc==MAX_FIND )
		     script_error( cur_line,
		    "Слишком много строк в разделе <find>");
		  if ((rpl[rpl_total].find[fc]=
		       malloc(strlen(GetLine)+2))==NULL)
		     script_error( cur_line,
		    "Нет памяти для строки раздела <find>");
		  strcpy( rpl[rpl_total].find[fc], GetLine );
		  rpl[rpl_total].fc++;
		  break;
	       case 2:
		  if ((rpl[rpl_total].repl=
		       malloc(strlen(GetLine)+2))==NULL)
		     script_error( cur_line,
		    "Нет памяти для строки раздела <find>");
		  strcpy( rpl[rpl_total].repl, GetLine );
		  break;
	       default:
	       ;
	  };
      };
      fclose(in);
      rpl_total++; // реальное количество разделов
   }
}

int script_was_loaded=0;
void amain( char *progname, char *file, char *ofile)
{
   long ttime;
   int i, t;

   if (!script_was_loaded)
   {
       load_script( progname );
       script_was_loaded=1;
   }

   cur_line=0;
   if ((in = fopen( file, "rb"))  == NULL)
   {
      printf("Can not open '%s'\n", file); exit(1);
   }


   for( index=0; index<HASH_S; index++)
   {
     Hash[index][0]=pHashClass[index]=0;
     pHash[index]=index;
   }
   index = 0;

   if   ((out = fopen(ofile, "wb")) == NULL) out=stdout;

   ttime = *((long *)MK_FP(0,0x46C));

   while (fgets( GetLine, MaxChar-2, in))
   {
	trunc( GetLine ); // truncate \r \n
        i=expand_tabs( GetLine ); // tabs -> spaces
        if ( cut_string[0] )
        {
           if ( i )
           {
              if ( strstr( GetLine, cut_string )) goto skip;
           }
        }
	if (i) push_queue(); // accept line and push it into queue
      skip:
	cur_line++;
   };

   push_queue();
   GetLine[0] = 0;

   for ( i=1; i<HASH_S; i++ ) push_queue(); // сливаем остаток очереди
   fclose(in);

   if (out != stdout ) fclose(out);

   ttime -= *((long *)MK_FP(0,0x46C));
   if ( ttime<0 ) ttime=-ttime;
   printf("elapsed %lu.%u sec\n", ttime/18L, (int)((ttime % 18)/2));
   printf("%u macros:\n", rpl_total);

   t=0;
   for ( i=0; i < rpl_total; i++ )
   {
      if ( !rpl[i].times )
      {
         if ( !t ) { printf("Not used at line "); t=1; }
         printf("%5u ", rpl[i].line_num );
      }
   };
   if ( t ) printf("\n\n");

   for ( i=0; i < rpl_total; i++ )
   {
      if ( rpl[i].times )
      printf("line %5u - %6lu times\n", rpl[i].line_num, rpl[i].times );
   };
}


/*-----------------08.01.99 20:40-------------------
 initialize macro post-processor
--------------------------------------------------*/
static int str_pos; // output string collector position
void amain_begin( char *progname, FILE *ou )
{
   if (!script_was_loaded)
   {
       load_script( progname );
       script_was_loaded=1;
   }

   cur_line=0;

   for( index=0; index<HASH_S; index++)
   {
     Hash[index][0]=pHashClass[index]=0;
     pHash[index]=index;
   }
   index = 0;

   out=ou; // must be an opened FILE ptr
   str_pos=0; // none chars were written to GetLine
}

/*-----------------08.01.99 20:45-------------------
 pushes one ASCIIZ string into postprocessor queue
--------------------------------------------------*/
void amain_push( char *s )
{
   int i;

                        // while (fgets( GetLine, MaxChar-2, in))
   while ( *s )
   {
        // copy the part of passed string upto \r\n (or EOLN)
        while ( str_pos < MaxChar-2 )
        {
            if (( *s == 0x0D ) || ( *s == 0x0A )) { s++; break; }
            if ( *s == 0) return;
            GetLine[str_pos++] = *s++;
        }

        GetLine[str_pos]=0; // eoln
        if ( !str_pos ) continue;

        str_pos=0;
        i=expand_tabs( GetLine ); // tabs -> spaces
        if ( cut_string[0] )
        {
           if ( i )
           {
              if ( strstr( GetLine, cut_string )) goto skip;
           }
        }
	if (i) push_queue(); // accept line and push it into queue
      skip:
	cur_line++;
   };
}

/*-----------------08.01.99 20:47-------------------
 flushes the post-processor queue
 print out statistics
--------------------------------------------------*/
void amain_end( void )
{
   int i, t;
   push_queue();
   GetLine[0] = 0;

   for ( i=1; i<HASH_S; i++ ) push_queue(); // сливаем остаток очереди

   printf("%u macros:\n", rpl_total);

   t=0;
   for ( i=0; i < rpl_total; i++ )
   {
      if ( !rpl[i].times )
      {
         if ( !t ) { printf("Not used at line "); t=1; }
         printf("%5u ", rpl[i].line_num );
      }
   };
   if ( t ) printf("\n\n");

   for ( i=0; i < rpl_total; i++ )
   {
      if ( rpl[i].times )
      printf("line %5u - %6lu times\n", rpl[i].line_num, rpl[i].times );
   };
}
