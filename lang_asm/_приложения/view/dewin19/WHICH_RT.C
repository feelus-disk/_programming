#include <stdlib.h>
#include <stdio.h>
#include <dos.h>
#include <string.h>

/*-----------------04.07.98 10:11-------------------
 модуль автоматического распознавания стандартных
 библиотечных функций runtime C++ и Pascal
 (C) Milukov Alexander
--------------------------------------------------*/

typedef  unsigned int uint;
typedef  unsigned long ulong;
typedef  unsigned char uchar;

// на входе адрес фрагмента кода процедуры
// на выходе имя или NULL
char *which_rtl( uchar *cptr );

// =1 если EOLN
int skip_space( char far **s)
{
    if ( **s == 0) return 1;
    while (( **s == 0x20 ) || ( **s == 0x9 )) (*s)++;
    return 0;
}

// пропускает пробелы
void skip_space2( char **s )
{
   char *t;
   t=*s;
   while (( *t==0x09 ) || ( *t==0x20 )) t++;
   *s=t;
}


/*-----------------11.07.98 14:48-------------------
 добавлена работа со словами в кавычках
 в этом случае пробелы и табуляция не считаются
 разделителем, а входят в слово
--------------------------------------------------*/

// извлекает n-ое слово из строки
char *nword( char *s, int n )
{
   static char wordn[64];
   int i=0;

   skip_space2( &s );      // пропустим лидирующие пробелы
   while ( n-- )           // и несколько первых "лишних" слов
   {
      if ( *s == '"' )     // если слово начинается с кавычки
      {
         s++; // левую кавычку пропускаем
         while (( *s !=0) && (*s!= '"')) s++; // ищем правую
         if ( *s == '"' ) s++; // нашли - пропустим
      }
      else
      while (( *s !=0) && (*s!=0x09) && (*s!=0x20)) s++;
      skip_space2( &s );
   }

   if ( *s == '"' )     // если слово начинается с кавычки
   {
      s++; // левую кавычку пропускаем
      while (( *s !=0) && (*s!= '"') && (i<60)) // до правой кавычки
         { wordn[i++]= *s++; };
   }
   else
      while (( *s !=0) && (*s!=0x09) && (*s!=0x20) && (i<60))
            { wordn[i++]= *s++; };

   wordn[i]=0;
   return wordn;
}

uchar dbuf[128];
// срезает концевые переводы строки
int trunc(void)
{
   int len=strlen( dbuf );
   while ( len )
   {
      if (( dbuf[len-1] ==0x0D) || ( dbuf[len-1] ==0x0A))
      {
	 dbuf[len-1]=0; len--;
      }
      else break;
   };
   return len;
}

// наибольшая длина сигнатуры
#define SGN_MAX 240
// максимальное количество именованных дочерних вызовов на одну
// распознаваемую процедуру
#define MAX_CHILD 4
// строка поиска стандартной runtime
typedef struct
{
   uint len;  // размер сигнатуры
   uint *s; // байты кода, если >255 то не влияет на сравнение
   char *name; // строка названия процедуры
   char *child[MAX_CHILD]; // строки названий других runtime процедур,
                           // вызываемых из данной, или NULL
} RTL;

uint rtlc=0; // номер (количество) загруженных в память сигнатур
#define RTL_MAX 96
RTL rtl[RTL_MAX];

#define ON(x) if ( !strcmp(nword(dbuf,i),(x)))

// сюда читаются байты сигнатуры, поскольку их количество
// заранее неизвестно
static uint s[SGN_MAX]; // байты кода, если >255 то не влияет на сравнение
                        // и рассматривается как особый случай

void unload_cfg(void)
{
    int i;
    while ( rtlc )
    {
        rtlc--;
        if ( rtl[rtlc].s     != NULL ) free(rtl[rtlc].s);
        if ( rtl[rtlc].name  != NULL ) free(rtl[rtlc].name);
        for ( i=0; i<MAX_CHILD; i++ )
           if ( rtl[rtlc].child[i] != NULL ) free( rtl[rtlc].child[i] );
    }
}

// грузим .cfg с описаниями run-time
void load_cfg(char *cfg_name)
{
    FILE *cfg;
    int len, i, j, k, line;
    char *st; // временный указатель

    static char cchild[MAX_CHILD][80]; // временно хранит имя вызываемых п/п

    if ((cfg = fopen( cfg_name, "rb"))  == NULL) return;
    printf("Loading %s ", cfg_name);

    line=0; k=0;
    for ( i=0; i<MAX_CHILD; i++ ) cchild[i][0] = 0;

    while (fgets( dbuf, 120, cfg ))
    {
       line++;
       printf("%3d\b\b\b", line);
       if ( !trunc() ) continue;
       if ( dbuf[0]==';') continue; // строки начинающиеся с ';' пропускаем

       i=0;
       j=0;
       while ( strcmp(nword(dbuf,i), "proc") ) // до слова 'proc'
       {
          // байт "любой"
          ON("??") { s[j] = 0x0FF00; goto signIt; };  // rtl[rtlc].

          ON("\\") // будет продолжение в следующей строке
          {
            more:
             if (!fgets( dbuf, 120, cfg ))
             { printf("\nthe rest of %d line not found\n", line); goto done; }
             line++;
             printf("%3d\b\b\b", line);
             trunc();
             if ( dbuf[0]==';') goto more;
             i=0; continue;
          };

          // переход в near процедуру
          ON("->") { s[j] = 0x0F100; goto signIt; };
          // возврат в caller или от абсолютного адреса
          ON("<-") { s[j] = 0x0F200; goto signIt; };
          // переход по абсолютному адресу
          ON("-]") { s[j] = 0x0F300; goto signIt; };
          // вызов другой runtime по имени
          ON("calln")
          {
              s[j] = 0x0F400;
              if ( k<MAX_CHILD )
              {
                 strcpy( cchild[k++], nword(dbuf,i+1)); i++; goto signIt;
              }
              else { printf("\nlist of 'calln' names is full at line %u,\n"
			"the rest of %s ignored.\n", line, cfg_name );
                 goto done; }
          };

          sscanf( nword(dbuf,i), "%2X", &s[j] );
          s[j] &= 0x0FF;

       signIt:
	  if (j<SGN_MAX) j++;
	  else { printf("\nSignature is too large at line %u,\n"
			"the rest of %s ignored.\n", line, cfg_name );
		 goto done; }
	  i++;
       }
       if ( rtlc==RTL_MAX ) { printf("\nRTL_MAX reached\n"); continue; }
       // копируем из временного буфера
       if ((rtl[rtlc].s = malloc( (j+1)*sizeof(int))) != NULL )
          memcpy( rtl[rtlc].s, s, (j+1)*sizeof(int));
       else { printf("\nMalloc() failed at line %u,\n"
			"the rest of %s ignored.\n", line, cfg_name );
                 goto done; }

       st = strstr(dbuf,"proc")+4;
       skip_space2( &st );
       if ( *st )
       rtl[rtlc].name = strdup( st );
       else
       rtl[rtlc].name = strdup( "?" ); // после proc не указано имя
       rtl[rtlc].len=j;

       for ( k=0; k<MAX_CHILD; k++ )
       {
          if ( cchild[k][0] )
             rtl[rtlc].child[k] = strdup( cchild[k] );
          else
             rtl[rtlc].child[k] = NULL;
          cchild[k][0] = 0;
       }
       k=0;

       if ( j ) rtlc++;
    };
  done:
    printf("\n");
    fclose(cfg);
}

// стек адресов возврата и его вершина
uchar far * tstack[16];
int ttop;

// сохраняет в стеке текущее положение указателя на код
void pushT( uchar far * t)
{
   if (ttop<16) tstack[ttop++]=t;
}

// извлекает из стека предыдущее положение указателя на код
uchar far *popT(void)
{
   if (ttop>0) return tstack[--ttop]; else return NULL;
}

// на входе адрес кода
// на выходе имя или NULL
char *which_rtl( uchar *cptr )
{
   int i,j,c;
   uchar far *t;
   uchar far *t_child;
   uchar action;

   i=0; // номер сигнатуры runtime
   while ( i<rtlc )
   {
      ttop=0; // очистим стек вложенных процедур
      t= cptr; // указатель на реальный код процедуры
      c = 0; // номер имени одной из дочерних процедур
      for ( j=0; j<rtl[i].len; j++ ) // по всем байтам
      {
	 action= (rtl[i].s[j] >> 8) & 0x0FF;
	 switch (action)
	 {
	    case 0xFF:
	       continue; // пропустим коды '??'
	    case 0xF1:
	       pushT( &t[2+j] ); // запомним адрес команды
			       // следующей за E8 xx xx
	       t += (*((int *)(t+j))+2+j); // здесь ОБЯЗАТЕЛЬНО НЕ ДОЛЖНА
				     // выполняться нормализация указателя
	       t -= (j+1); // поскольку сравнение продолжится на
			   // следующей итерации
	       continue;
	    case 0xF2:
	       t=popT(); // вернемся на следующую за CALL xxxx команду
	       t -= (j+1); // поскольку сравнение продолжится на
			   // следующей итерации
	       continue;
            case 0xF3:
	       pushT( &t[2+j] ); // запомним адрес команды
	       FP_OFF(t) = (*((int *)(t+j))); // здесь ОБЯЗАТЕЛЬНО НЕ ДОЛЖНА
				     // выполняться нормализация указателя
	       t -= (j+1); // поскольку сравнение продолжится на
			   // следующей итерации
	       continue;
            case 0xF4:
               if (*(t+j) != 0xE8) goto failed;
               // определим адрес точки входа
               // здесь ОБЯЗАТЕЛЬНО НЕ ДОЛЖНА
               // выполняться нормализация указателя
               t_child = t + *((int *)(t+j+1))+3+j;
               // если имя не совпало
               if ( strcmp( which_rtl( t_child ), rtl[i].child[c] ))
                 goto failed;
               t += (3-1); // 3 длина кода, 1 длина нашего макроса
               c++; // имя уже было использовано
	       continue;
	    case 0:
               if (( rtl[i].s[j] & 0x0FF) != t[j] )
                 goto failed;
	 }
      }
      return rtl[i].name;

    failed:
      i++;
   }
   return NULL;
}
