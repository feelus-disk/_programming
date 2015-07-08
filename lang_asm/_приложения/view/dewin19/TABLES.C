#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include <alloc.h>
#include "dewin.h"

// обработка списков имен функций и таблиц для dewin.c



extern char *nrName;
extern ENTRY entry[MaxEntry];

int entryTOTAL;

void entryINIT(void) // clear an array of entry table ref's
{
    memset( entry, 0, MaxEntry*sizeof( ENTRY ));
    entryTOTAL = 0;
}

void entryPUT( char seg, int offset)
{
    if (entryTOTAL == MaxEntry) return;
    entry[entryTOTAL].seg=seg;
    entry[entryTOTAL].offset=offset;
    entryTOTAL++;
}

int entryGET( char seg, int where, ENTRY *to)
{
    int i=entryTOTAL;
xe:
    if (i==0) return -1;
    i--;
    if (where==entry[i].offset && seg==entry[i].seg )
    {
       to->seg   = seg;
       to->offset= where;
       to->name  = entry[i].name;
       return ++i;
    } else goto xe;
}

// возвращает имя точки входа (movable seg entry point) по ее номеру
char *entryNameGET( int n)
{
    static char s=0;
    if ( n-- > entryTOTAL ) return &s;
    if (entry[n].name==0) return &s;
    return nrName+entry[n].name*33;
}

RELOC reloc[MaxEntry];
int relocTOTAL;

void relocINIT(void) // clear an array of module ref's for current .seg
{
    memset( reloc, 0, MaxEntry*sizeof( RELOC ));
    relocTOTAL = 0;
}

void relocPUT( int offset, int module, int func, char mode)
{
    if (relocTOTAL == MaxEntry) return;
    reloc[relocTOTAL].mode   = mode;
    reloc[relocTOTAL].offset = offset;
    reloc[relocTOTAL].module = module;
    reloc[relocTOTAL].func   = func;
    relocTOTAL++;
}

// fill out an structure offset:module.function contain the same offset
int relocGET( int where, RELOC *to)
{
    int i=relocTOTAL;
xe:
    if (i==0) return -1;
    i--;
    if (reloc[i].offset==where)
    {
       memcpy( to, &reloc[i], sizeof( RELOC ));
       return 0;
    } else goto xe;
}

int imp_tbl_size=0;
#define MAX_IMPT 512
IMP_TBL far *impt=NULL;

int has_msg=0;
char nLoadString[]="LoadString";
long LoadStringAdr=0; // addr of LoadStringA() function, if any
char nLoadLibrary[]="LoadLibrary";
long LoadLibraryAdr=0; // addr of LoadLibraryA() function, if any

// adds the new entry to [Import table] of 32-bit application
// also used for user-defined entries for 16-bit application
// in form add_imp_tbl( (seg<<16) + offset, char *name );
//
void add_imp_tbl( long fix, char *name )
{
   if ( impt==NULL )
   {
      impt = (IMP_TBL far *) malloc( MAX_IMPT * sizeof( IMP_TBL ));
      imp_tbl_size=0;
   }
   if ( impt==NULL ) return;
   if ( imp_tbl_size==MAX_IMPT )
   {
      if (!has_msg) fp("\nMaximum of size of import table reached\n\n");
      has_msg=1;
      return;
   }
   impt[imp_tbl_size].addr = fix;
   memcpy( impt[imp_tbl_size].name, name, 31 );
   if ( !memcmp( name, nLoadString, 10 ))
   {
      LoadStringAdr=fix; // запомним адрес, если это LoadStringA
   }
   else
   if ( !memcmp( name, nLoadLibrary, 11 ))
   {
      LoadLibraryAdr=fix; // запомним адрес, если это LoadLibrary
   }
   impt[imp_tbl_size++].name[31] = 0;
}

int has_msg2=0;
int typex_tbl_size=0;
#define MAX_TYPEX 64
TYPEX_TBL far *typex=NULL;

// data type definition table
void add_type_tbl( long fix, int typeX, int dim, int as )
{
   if ( typex==NULL )
   {
      typex = (TYPEX_TBL far *) malloc( MAX_TYPEX * sizeof( TYPEX_TBL ));
      typex_tbl_size=0;
   }
   if ( typex==NULL ) return;
   if ( typex_tbl_size==MAX_TYPEX )
   {
      if (!has_msg2) fp("\nMaximum of size of userdef type table reached\n\n");
      has_msg2=1;
      return;
   }
   typex[typex_tbl_size].addr = fix;
   typex[typex_tbl_size].dim  = dim;
   typex[typex_tbl_size].as   = as;
   typex[typex_tbl_size++].t = typeX;
}

// return the type of passed memory object, or 0 if not defined
// into dim places minimum near address, into as maximum, zero if none
int get_typex_udf( int seg, uint offset, int *dim, int *as )
{
   int i;
   ulong maxi=0x3FFFFFFL, mini=0x1L; // ближайшие адреса
   ulong addr= (((ulong)seg)<<16) + ((ulong)offset);
   for ( i=0; i<typex_tbl_size; i++ )
   {
      if ( typex[i].addr==addr )
      { *dim =typex[i].dim; *as =typex[i].as; return typex[i].t; }

      if ( typex[i].addr>addr )
      {
         if ( typex[i].addr<maxi ) maxi = typex[i].addr;
      }
      else
    //  if ( typex[i].addr<addr )
      {
         if ( typex[i].addr>mini ) mini = typex[i].addr;
      }
   }
   // если близкие адреса найдены в этом же сегменте
   if ( (maxi>>16)==seg && (mini>>16)==seg )
   {
      *dim = (int)mini;
      *as  = (int)maxi;
   }
   else
   {
      *dim = 0;
      *as  = 0;
   }
   return 0;
}

// имя .DLL функции которой не следует включать в таблицу имен
int exclude_d=0;
char exclude_dll[ MAX_EX_DLL  ][90];

char udfn16[]="[User defined names-16]";
char uddat16[]="[User defined data-16]";
char udfn32[]="[User defined names-32]";
char uddat32[]="[User defined data-32]";
char udopt[]="[User defined options]";

extern char RCdataName[];
extern char DATAdataName[];

// loads the name's definition file from current dir, if exist
// ; remark
// [section]
// 0004:1A9C MyProcName
//
// return 1 if loaded, 0 otherwise
int load_userdef(char *file)
{
   FILE *in;
   int len, flag, dim, as;
   char buf[90], opt[90], val[90], *eptr, *s;

   ulong seg, offset;

   flag=0;
   if ((in=fopen( file, "rt" ))==NULL) return 0;
   while ( fgets( buf, 80, in ))
   {
       len=strlen(buf);
       if ( len )
       {
	  if ( buf[len-1]==0x0D || buf[len-1]==0x0A)
	  {
	     buf[len-1]=0; len--;
	  }
       }
       if ( !len || buf[0]==';' ) continue;

       if ( !memcmp( buf, udfn16, sizeof(udfn16)-1 ))
       { flag=1; continue; }
       if ( !memcmp( buf, uddat16, sizeof(uddat16)-1 ))
       { flag=2; continue; }
       if ( !memcmp( buf, udopt, sizeof(udopt)-1 ))
       { flag=3; continue; }
       if ( !memcmp( buf, udfn32, sizeof(udfn16)-1 ))
       { flag=4; continue; }
       if ( !memcmp( buf, uddat32, sizeof(uddat16)-1 ))
       { flag=5; continue; }

       as=0; // способ интерпретации данных - default
       switch ( flag )
       {
        case 1: // user-defined function as     seg:off name
	  seg = strtol( buf, &eptr, 16 );
	  if ( *eptr++ != ':' ) continue;
	  offset = strtol( eptr, &s, 16 );
	  if ( *s++ != ' ' ) continue;
          add_imp_tbl( (seg<<16) + offset, s );
	  break;
        case 5: // user-defined data type 32
          offset = strtol( buf, &s, 16 );
	  if ( *s++ != ' ' ) continue;
          seg = (offset >> 16);
          offset &= 0x0FFFFL;
          goto ud;
        case 2: // user-defined data type 16
	  seg = strtol( buf, &eptr, 16 );
	  if ( *eptr++ != ':' ) continue;
	  offset = strtol( eptr, &s, 16 );
	  if ( *s++ != ' ' ) continue;
        ud:
	  if ( !memcmp( s, "cstring", 7 ))
          {
             add_type_tbl( (seg<<16) + offset, 1, 0, as );
             break;
          }
	  if ( !memcmp( s, "pstring", 7 ))
          {
             add_type_tbl( (seg<<16) + offset, 2, 0, as );
             break;
          }
          if ( !memcmp( s, "db", 2 ))
          {
             if ( s[2]=='[' ) dim = atoi( &s[3] );
             else dim=0;
             add_type_tbl( (seg<<16) + offset, 3, dim, as );
             break;
          }
          if ( !memcmp( s, "dw", 2 ))
          {
             char *eptr = &s[2];
             if ( s[2]=='[' ) dim = (int)strtol( &s[3], &eptr, 10 );
             else dim=0;
             if ( *eptr == ']' ) eptr++;
             if ( !memcmp( eptr, " as ", 4 )) // интерпретация
             {
                if ( !memcmp( eptr+4, "WM_MSG16", 8 )) as=1;
             }
             add_type_tbl( (seg<<16) + offset, 4, dim, as );
             break;
          }
          if ( !memcmp( s, "dd", 2 ))
          {
             if ( s[2]=='[' ) dim = atoi( &s[3] );
             else dim=0;
             add_type_tbl( (seg<<16) + offset, 5, dim, as );
             break;
          }
	  break;
	case 3:
	  opt[0]=0; val[0]=0;
	  strcpy( opt, strtok( buf, ",=")); // имя параметра
	  strcpy( val, strtok( NULL, ",=" )); // значение
	  // имя .dll функции которой не загружать
	  // в таблицу внешних имен (обычно msvcrt42.dll и т.п.)
	  if ( !stricmp(opt, "ImportedNamesExcludeDLL"))
	  {
             if (exclude_d < MAX_EX_DLL )
                strcpy( exclude_dll[ exclude_d++], val);
          }
          // имя секции .rcdata в файле PE (Win32)
	  if ( !stricmp(opt, "RCdataName"))
	  {
             if (strlen(val) < 10 ) // обычно до восьми символов
                strcpy( RCdataName, val);
          }
          // имя секции .data в файле PE (Win32)
	  if ( !stricmp(opt, "DATAdataName"))
	  {
             if (strlen(val) < 10 ) // обычно до восьми символов
                strcpy( DATAdataName, val);
          }
          break;
        case 4: // user-defined function as     offset name
          offset = strtol( buf, &eptr, 16 );
          if ( *eptr++ != ' ' ) continue;
          add_imp_tbl( offset, eptr );
          break;
	default:
	  break;
       }
   }
   fclose(in);
   return 1;
}

char noot_found[]="not found";
// возвращает строку-имя импортируемой функции по ее fixup адресу
char *get_imp( long addr )
{
   int i;
   for ( i=0; i<imp_tbl_size; i++ )
   {
      if ( impt[i].addr==addr ) return impt[i].name;
   }
   return noot_found;
}

// возвращает строку-имя импортируемой функции по ее fixup адресу
// 0 если функция не найдена
int get_imp_s( long addr, char **s )
{
   int i;
   for ( i=0; i<imp_tbl_size; i++ )
   {
      if ( impt[i].addr==addr ) { *s = impt[i].name; return 1; }
   }
   return 0;
}

int get_imp_udf( int seg, int offset, char **name )
{
   int i;
   ulong addr= (((ulong)seg)<<16) + ((ulong)offset);
   for ( i=0; i<imp_tbl_size; i++ )
   {
      if ( impt[i].addr==addr ) { *name = impt[i].name; return 1; }
   }
   return 0;
}


int exp_tbl_size=0;
#define MAX_EXPT 64
IMP_TBL far *expt=NULL;

int has_msg3=0;

// добавляет элемент в таблицу экспорта 32-бит приложения
void add_exp_tbl( long fix, char *name )
{
   if ( expt==NULL )
   {
      expt = (IMP_TBL far *) malloc( MAX_EXPT * sizeof( IMP_TBL ));
      exp_tbl_size=0;
   }
   if ( expt==NULL ) return;
   if ( exp_tbl_size==MAX_EXPT )
   {
      if (!has_msg3) fp("\nMaximum of size of export table reached\n\n");
      has_msg3=1;
      return;
   }
   expt[exp_tbl_size].addr = fix;
   memcpy( expt[exp_tbl_size].name, name, 31 );
   expt[exp_tbl_size++].name[31] = 0;
}

// возвращает строку-имя экспортируемой функции по ее fixup адресу
char *get_exp( long addr )
{
   int i;
   for ( i=0; i<exp_tbl_size; i++ )
   {
      if ( expt[i].addr==addr ) return expt[i].name;
   }
   return NULL;
}

struct
{
   long id;
   char far *str;
} StrRES[100];
int str_res=0; // количество строк в списке

// добавляет строку-ресурс в список
void add_resource_string( long id, char *str )
{
   if (str_res<99 && strlen(str) )
   {
   StrRES[ str_res ].id = id;
   StrRES[ str_res ].str = strdup(str);
   if ( StrRES[ str_res ].str ) str_res++;
   }
}

char *get_resource_string( long id )
{
   int i;
   for (i=0; i<str_res; i++ )

   if ( StrRES[ i ].id == id ) return StrRES[ i ].str;
   return NULL;
}

typedef struct
{
   int num;
   char *name;
} DEFS;

typedef struct
{
   char *name;
   int  total, index;
   DEFS *def;
} SECTION;

#define MAX_SECT 16
SECTION sect[MAX_SECT+1];
int sect_total=0;

// create empty section with name
int begin_section( char *name)
{
   if ( sect_total == MAX_SECT) return 0;

   sect[sect_total].total=0;
   sect[sect_total].index=0;
   sect[sect_total].name=strdup(name);
   sect[sect_total].def=NULL;

   sect_total++;
   return 1;
}

void add_to_section( int num, char *name )
{
   DEFS *def;

   if ( !sect_total ) return;

   if (sect[sect_total-1].index == sect[sect_total-1].total) return;

   if ( !sect[sect_total-1].def )
   {
      sect[sect_total-1].def =
      farmalloc( sect[sect_total-1].total * sizeof(DEFS));
   }
   def = sect[sect_total-1].def;
   if ( !def ) return;

   def += sect[sect_total-1].index;
   sect[sect_total-1].index++;

   def->num = num;
   def->name=strdup(name);
}

void enlarge_section(void)
{
   if ( !sect_total ) return;
   if (sect[sect_total-1].total < 2000 ) sect[sect_total-1].total++;
}

// fill the name[] if fn()==num  was found in [section]
// return true
int find_by_num( int num, char *section, char *name )
{
   int i, j;

   for ( i=0; i<sect_total; i++ )
   {
      if ( strcmpi( sect[i].name, section)==0 )
      {
         for ( j=0; j<sect[i].total; j++ )
         {
             if ( sect[i].def[j].num==num )
             {
                strcpy( name, sect[i].def[j].name );
                return 1;
             }
         }
      }
   }
   return 0;
}

// loads the Win16 name's definition file
// ; remark
// [module_name]
// 12 MyProcName1
// 35 MyProcName2
void load_explain(char *fname)
{
   FILE *in;
   int len, flag, num;
   char buf[90], opt[90], val[90], *eptr, *s;

   ulong seg, offset;
   long last_line= -1L; // special value

   flag=1; // 0=scan number of lines per section
	   // 1=load lines of just scanned section

   /*-----------------10.12.98 06:46-------------------
    file MUST begin with [section], newline or remark ";"
    to prevent loading these lines into 1st definition
    area
   --------------------------------------------------*/

   if ((in=fopen( fname, "rb" ))==NULL) return;
   while (1)
   {
       if (fgets( buf, sizeof(buf)-5, in )==NULL) // found EOF
       {
          if ( flag ) break; // loading of section stops
          else if (last_line != -1L)
          {
             fseek( in, last_line, 0 );
             flag=1;
             continue;
          }
          else break;
       }
       len=strlen(buf);
       while ( len )
       {
          if ( buf[len-1]==0x0D ||
               buf[len-1]==0x0A ||
               buf[len-1]==0x09 ||
               buf[len-1]==0x20
               )
	  {
	     buf[len-1]=0; len--;
	  }
          else break;
       }
       if ( !len || buf[0]==';' ) continue;

       if ( buf[0]=='[' )
       {
          if ( flag==0 ) // we are scanning ? so, next [section] reached
          {
             if (last_line != -1L)
             {
                fseek( in, last_line, 0 ); // go back and load it
                flag=1;
                continue;
             } else break;
          }
	  else
          {
             last_line=ftell(in); // remember where [section] starts
             if ( buf[ strlen(buf)-1 ] == ']')
             {
                buf[ strlen(buf)-1 ]=0;
             }
             if (!begin_section( &buf[1] )) break;
             flag=0;
             continue;
          }
       }

       switch ( flag )
       {
        case 1: // defined function as     num name
	  num = (int)strtol( buf, &eptr, 10 );
          if ( *eptr != ' ' && *eptr != 0x09) continue;
          while ( *eptr == ' ' || *eptr == 0x09) eptr++;
          add_to_section( num, eptr );
	  break;
        case 0: // don't load, count only
          enlarge_section();
          break;
       }
   }
   fclose(in);
}
