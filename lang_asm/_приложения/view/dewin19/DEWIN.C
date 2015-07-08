#include <stdio.h>
#include <dos.h>
#include <stdlib.h>
#include <stdarg.h>
#include <string.h>
#include <ctype.h>
#include <alloc.h>
#include <dir.h>
#include <process.h>

#include "dewin.h"

extern unsigned _stklen=8*1024;

static char *jmem, *jcode, *jread, *INtable, *tempp;

char pathName[140],
     lkp_filename[80], // файл подстановок (lookup)
     cuserdef[80]; // custom "user definitions" file, like userdef.txt
                   // has the same name as currently disassembled file but
                   // extension .udf

int options;
int coff=0; // true if we are processing a COFF file

   FILE *in, *out, *bout;      // streams
        ulong    newExeOffset;
ulong app_file_size=0; // size of main application file

    uint Lshift;

    static char *resNAME[] = { "CURSOR", "BITMAP", "ICON", "MENU",
    "DIALOG", "STRING", "FONTDIR", "FONT",
    "ACCELERATOR", "RCDATA","?-(11)","GROUP CURSOR",
    "?-(13)","GROUP ICON","","VERSION INFO"};

    static char *osName[] = { "Unknown", "OS/2", "Windows",
    "MS-DOS 4.x", "Windows 386", "BOSS", "invalid" };


    static char mName[16][33];     // module names up to 32 char
    //static char nrName[MaxNRnames][33];    // non-resident names table
    char *nrName;
    static char oname[140];

EXEo o; // заголовок в старом формате
NEWheader NE; // в новом формате
tyPE PE; // 32-бит заголовок
tyObj Obj, // обьект (секция) из заголовка 32-бит приложения
      sec[16]; // all of sections from PE file

ExpDirectory ExpDir; // начало обьекта .edata в PE-приложении
ImpDirectory ImpDir;
ulong objheaders; // смещения заголовков секций PE файла

long minImpAdr=0x3FFFFFFFL, maxImpAdr=0;

segRECORD segR;
resRECORD res;
resDESCRIPTOR resD;

ENTRY entry[MaxEntry];

ulong flen( FILE *f )
{
    ulong len; fseek( f, 0, 2); len=ftell(f); fseek( f, 0, 0); return len;
}


void oTab( void )
{
    fputc( 0x09, out );
}

//------------------------- распознавание runtime -----------------
// на входе адрес фрагмента кода процедуры
// на выходе имя или NULL
char *which_rtl( uchar *cptr );
void unload_cfg(void);
// грузим .cfg с описаниями run-time
void load_cfg(char *cfg_name);


//------------------------- файловые функции ----------------------

void iseek( ulong i ) { fseek( in, i, 0 ); }

void iseekNE( ulong i ) { fseek( in, i+newExeOffset, 0 ); }

// TRUE if was read Ok
int getAt( ulong offset, uint size, void *where )
{
    if ( offset >= app_file_size ) return 0; // EOF
    fseek( in, offset, 0); fread( where, size, 1, in);
    return 1;
}

void go_back(signed int c)
{
 fseek(in, (signed long)-c, 1);
}

// сохраняет текущий файловый указатель
void save_pos( ulong *val)
{
    *val=ftell(in);
}

FILE *out_auto=NULL;
// упрощенный вывод в FILE *out_auto
void fp_auto(char *fmt, ...)
{
   va_list argptr;
   if ( out_auto==NULL )
   {
      out_auto = fopen("autodet.txt", "wt");
      if ( out_auto==NULL ) return;
      fprintf(out_auto, "Runtime autodetect results:\n");
   }
   va_start(argptr, fmt);
   vfprintf(out_auto, fmt, argptr);
   va_end(argptr);
}

// упрощенный вывод в FILE *out
void fp(char *fmt, ...)
{
   va_list argptr;
   va_start(argptr, fmt);
   vfprintf(out, fmt, argptr);
   va_end(argptr);
}

void ofprintfEND(void)
{
    fp( "End\n" );
}

// fill the name[] if fn()==num  was found in [section]
// return true
int find_by_num( int num, char *section, char *name );

// expands expression MODULE.FUNC to string
char *NameIt( char *module, int func )
{
    if ( find_by_num( func, module, oname ) ) return oname;

    sprintf( oname, "%d", func );
    return oname;
}




#define MAX_TREE 2048
unsigned int *tree; // store cross ref's chain in a tree
int tree_lev;       // size of tree

void tree_put( int adr, int ref )
{
        asm mov ax,tree_lev
        asm cmp ax,MAX_TREE*2
        asm jnc ex
        asm shl ax,1
        asm les bx,dword ptr tree
        asm add bx,ax
        asm mov ax,adr
        asm mov word ptr es:[bx],ax
        asm mov ax,ref
        asm mov word ptr es:[bx+2],ax
        asm add tree_lev,2
        ex: ;
}

// be careful ! RECURSIVE

int tree_get( int adr )
{
	int j, count = 0;
	if ( adr == 0 ) return 0;

        f:
	if ( count >= tree_lev ) return adr; // not found nothing

        j = tree[ count++ ]; // adres of caller

        if (( tree[ count++ ] == adr+1) &&
            (j!=adr)) return tree_get( j );
        else goto f;
}



char *INstring(int offset)
{
    char i;
    char *t;
    char k=0;
    if ( INtable != NULL )
    {   t=INtable;
        t += offset;
	i = *t++;
	if (i>40) i=35;
	while (i-- > 0) oname[k++] = *t++;
	oname[k] = 0;
	return oname;
    }
    sprintf( oname, "FuncName offs %04Xh", offset);
    return oname;
}

struct {
   ulong segAdd,    // добавка к текущему сегменту
         code_base; // начало образа сегмента кода в линейном
                    // адресном пространстве, часто 401000h
    char strb[128];
} x;

uint PsegAdd=0; // используется как копия приращения сегмента jcode
                // в пределах деассемблирования одного буфера < 640 K
long c_RVA=0;
void far pascal DESS(void);
// выполняет деассемблирование одной команды машинного кода
uint far decode( char far *code )
{
        asm { push ds;
              push ds; pop es; lea bx,x
              lds ax,[code]
              call far ptr DESS
              pop ds }
	return _AX;
}

FILE *aout; // ASCII output file
// аналог fprintf( aout, ...) для процедуры processSEG()
void afprintf( char *fmt, ... )
{
    char str[512]; // !!! stack
    va_list argptr;
    va_start(argptr, fmt);
    if (options & 4096) // two-pass:  macro-processor
    {
        vsprintf( str, fmt, argptr);
        amain_push( str );
    }
    else
    vfprintf( aout, fmt, argptr);
    va_end(argptr);
}

// вывод в файл одной строки relocation table
void relocPRINT( RELOC *rel)
{
    int module, func; // копии значений
    static char *f="\t; %s.%s";
    module= rel->module; func=rel->func;
   switch (rel->mode) {
    case 0: afprintf( f, mName[module], NameIt(mName[module], func) );
            break;
    case 1:
            if ( ((module)&0xFF) != 0xFF )
            {
               char *udf_name;
               // if user has defined this function byself in "userdef.txt"
               if ( get_imp_udf( module, func, &udf_name ))
                  afprintf("\t; UDF=%s\n", udf_name);
               else
                  afprintf("\t; to fixed seg %04X:%04Xh", module, func );
            }
            else afprintf("\t; to movable seg Entry #%04d. %s",
            func, entryNameGET(func) );
            break;
    case 2:
            afprintf( f, mName[module], INstring(func) );
            break;
   }
}

ENTRY ent;
void nameOfEntry(void)
{
    if (ent.name != 0) afprintf("\t %s", nrName+ent.name*33);
}

// нормализует указатель
void normalize( char far **pointer )
{
      asm les bx,[pointer]  // es:bx укажет на нормализуемую переменную-указатель
      asm mov ax,word ptr es:[bx]
      asm mov dx,ax
      asm shr dx,4 // пересчет в параграфы
      asm add word ptr es:[bx+2],dx
      asm and ax,0Fh
      asm mov word ptr es:[bx],ax
      ;
}

char far *dseg; // указатель на сегмент данных программы, if any
char far *rdseg; // указатель на сегмент .rdata программы, if any
char *get_imp( long addr );
int   get_imp_s( long addr, char **s );

void raw_dump_data( char far *consta )
{
   int i;
   if ( *consta )
   {
      afprintf("\t; \"");
      for ( i=0; i<120 && *consta; i++, consta++ )
      {
         afprintf("%c", *consta>31 ? *consta : '.');
      }
      afprintf("\"");
   }
}

char *get_exp( long addr );

// вычисляет линейный адрес segm*16+offs
long linear( long segm, int offs )
{
   long i;
   asm { mov ax,word ptr [segm]; mov dx,word ptr [segm+2];
        shl ax,1; rcl dx,1; shl ax,1; rcl dx,1;
        shl ax,1; rcl dx,1; shl ax,1; rcl dx,1; add ax, offs; adc dx,0;
         mov word ptr [i],ax; mov word ptr [i+2],dx };
   return i;
}

// нормализуем jcode (смещение = 0)
void normalize0( void )
{
    asm { mov ax,word ptr jcode; shr ax,4; add ax,word ptr jcode+2;
          inc ax; inc ax; mov word ptr jcode+2,ax;
          mov word ptr jcode,0 };
}

// поправка на сегмент
#define JUSTIFY() asm { sub word ptr jcode,0FF00h; sub off,0FF00h; \
                add word ptr jcode+2,0FF0h; add word ptr [x.segAdd],0FF0h; \
                adc word ptr [x.segAdd+2],0; add PsegAdd,0FF0h };

#define MSTACK 16
extern long LoadStringAdr; // адрес функции загрузки строкового ресурса
extern long LoadLibraryAdr; // адрес функции загрузки .DLL

long Pstack[MSTACK]; // эмулятор стека процессора приложения
void ePush(ulong x)
{
   int i;
   for ( i=MSTACK-1; i>0; i-- ) Pstack[i]=Pstack[i-1];
   Pstack[0]=x;
}

//--------------------------------------------------------------------------
// вернет TRUE если параметр похож на строку Pascal
// добавлено ограничение на интервал букв - только латинские
// так как это обычно имена ресурсов, диалогов и др.
// встречается в Delphi

int is_passtr( uchar *ps )
{
   uint t; // длина предполагаемой строки для проверки
   int c=1;
   uchar pas_len= *ps++; // предполагаемая длина Pascal-строки
   if (( options & 1024 ) || ( pas_len > 0x20 /* 0x54 */ )) return 0;
   while (c<6)
   {
      t=pas_len;
      while ( t ) // убедимся в отсутствии "левых" символов
      {
         if ( ps[t-1] > 'z' || ps[t-1] < ' ') return 0;
         t--;
      }
      // DEBUG break;

      if (( ps[pas_len] == 0x55 ) && // push bp
	  ( ps[pas_len+1] == 0x89 ) && // mov bp,sp
	  ( ps[pas_len+2] == 0xE5 )) goto ok;

      if (( ps[pas_len] == 0xC8 ) && // enter xx,0
          ( ps[pas_len+1] < 0x20 ) && // небольшой кадр стека
          ( ps[pas_len+2] == 0 ) && //
          ( ps[pas_len+3] == 0 )) goto ok;

      ps += pas_len;
      pas_len= *ps++;
      c++;
   }
   return 0; // начало следующей процедуры так и не найдено
   ok:
   return c;
}

int is_cstr( uchar *ps )
{
   int i;
   for ( i=0; i<8; i++ )
   {
      if ( !isalpha(ps[i]) && ps[i]!=' ' &&
            ps[i]!='%' && ps[i]!='|' && ps[i]!='-')
         return 0;
   }
   return 1;
}

// возвращает имя константы MSG WM_xxxx по номеру
struct
{  char *name; int id; } wmsg16[]=
{
   "WM_CREATE", 0x0001,
   "WM_DESTROY",  0x0002,
   "WM_MOVE",  0x0003,
   "WM_SIZE",  0x0005,
   "WM_ACTIVATE",  0x0006,
   "WM_SETFOCUS",  0x0007,
   "WM_KILLFOCUS",  0x0008,
   "WM_ENABLE",  0x000A,
   "WM_SETTEXT",  0x000C,
   "WM_GETTEXT",  0x000D,
   "WM_PAINT",  0x000F,
   "WM_CLOSE",  0x0010,
   "WM_QUIT",  0x0012,
   "WM_QUERYOPEN",  0x0013,
   "WM_ERASEBKGND",  0x0014,
   "WM_SHOWWINDOW",  0x0018,
   "WM_CANCELMODE",  0x001F,
   "WM_SETCURSOR",  0x0020,
   "WM_NEXTDLGCTL",  0x0028,
   "WM_DRAWITEM",  0x002B,
   "WM_QUERYDRAGICON",  0x0037,
   "WM_GETDLGCODE",  0x0087,
   "WM_KEYDOWN",  0x0100,
   "WM_KEYUP",  0x0101,
   "WM_CHAR",  0x0102,
   "WM_DEADCHAR",  0x0103,
   "WM_SYSKEYDOWN",  0x0104,
   "WM_SYSKEYUP",  0x0105,
   "WM_SYSCHAR",  0x0106,
   "WM_SYSDEADCHAR",  0x0107,
   "WM_INITDIALOG",  0x0110,
   "WM_COMMAND",  0x0111,
   "WM_SYSCOMMAND",  0x0112,
   "WM_TIMER",  0x0113,
   "WM_HSCROLL",  0x0114,
   "WM_VSCROLL",  0x0115,
   "WM_INITMENU",  0x0116,
   "WM_INITMENUPOPUP",  0x0117,
   "WM_ENTERIDLE",  0x0121,
   "WM_MOUSEMOVE",  0x0200,
   "WM_LBUTTONDOWN",  0x0201,
   "WM_LBUTTONUP",  0x0202,
   "WM_LBUTTONDBLCLK",  0x0203,
   "WM_RBUTTONDOWN",  0x0204,
   "WM_RBUTTONUP",  0x0205,
   "WM_RBUTTONDBLCLK",  0x0206,
   "WM_MBUTTONDOWN",  0x0207,
   "WM_MBUTTONUP",  0x0208,
   "WM_MBUTTONDBLCLK",  0x0209,
   "WM_PARENTNOTIFY",  0x0210,
   "WM_DROPFILES",  0x0233,
   "WM_QUERYENDSESSION",  0x0011,
   "WM_ENDSESSION",       0x0016
};

char *wm_msg16( int i)
{
   int k;
   static char s[30];
   for ( k=0; k<sizeof(wmsg16)/(sizeof(int)+sizeof(char*)); k++ )
   {
      if ( i==wmsg16[k].id ) return wmsg16[k].name;
   }
   sprintf( s, "WM_0x%04X", i);
   return s;
}
//--------------------------------------------------------------------------

// piece of code was written under
// ideas from mr. Sang Cho, assistant professor (1997)
// and Randy Kath(Microsoft Developmer Network Technology Group)
// in june 12, 1993.

// return file offset of given directory entry
// or -1 if failure
long DirectoryOffset ( int dir_e, int *num )
{
    int    i = 0;
    ulong  VAImageDir;

    if (dir_e >= PE.Interest) return -1; // outside the header

    // get relative virtual address
    if ((VAImageDir = PE.ddir[dir_e].rva)==0) return -1;

    while ( i++< PE.obj )
    {
        if ( sec[i].VirtAddr <= VAImageDir &&
            sec[i].VirtAddr + sec[i].RawSize > VAImageDir)
        break;
    }

    if (i > PE.obj ) return -1;

    *num = i;
    return ( VAImageDir - sec[i].VirtAddr + sec[i].RawOffset );
}

// return file offset of given RVA
// or -1 if failure
long rva_offset ( ulong rva )
{
    int    i = 0;

    while ( i++< PE.obj )
    {
        if ( sec[i].VirtAddr <= rva &&
            sec[i].VirtAddr + sec[i].RawSize > rva )
        break;
    }

    if (i > PE.obj ) return -1;

    return ( rva - sec[i].VirtAddr + sec[i].RawOffset );
}


//--------------------------------------------------------------------------


long dataObj; // адрес начала образа обьекта данных в памяти
long dataObjEnd; // конец образа обьекта данных в памяти
long rdataObj; // адрес начала образа обьекта .rdata в памяти
long rdataObjEnd; // конец образа обьекта .rdata в памяти

uchar flag32=0;

// autodetection of strcpy, memcpy, strlen, rand etc.
// by segment number:    segn
//    offset at segment: t
void autodetect_runtime(int segn, uint t)
{
       char *rtl_name = which_rtl( jcode );
       if ( rtl_name )
       {
	  if ( !flag32 )
	  fp_auto("%04X:%04X %s\n",
	  (int)segn, (uint)( linear( x.segAdd, t )), rtl_name);
	  else
	  fp_auto("%08lX %s\n",
	  (int)segn, linear( x.segAdd, t ), rtl_name);
	  afprintf("\t; auto-RTL %s\n", rtl_name);
       }
}

// skip some equal codes (NOP, INT3 etc.) after the RET
// instruction inserted by compiler for alignment
void skip_nops( uchar far **ps, uint *off, uchar code, char *name )
{
   int i,k;
   char s[80];
   for ( i=0, k=0; i<32; i++ )
   {
      if (( **ps == code ) && ( *((*ps)+1) == code ))
      { (*ps)++; (*off)++; k++; }
   }

   if ( k>1 && ((*off) & 1)==1 && **ps == code) // current code offset is odd
                                                // and alignment was detected
      { (*ps)++; (*off)++; k++; }

   if ( k )
   {
      sprintf( s, "\t; %d %s's skipped", k, name);
      strcat( x.strb, s );
   }
}

static char progname[100];

// creates deassembled code segment
ulong FileOffset; // смещение сегмента относительно начала файла на диске
int processSEG( char *name, int segn )
{
   long clen, clen_, full_len;  // длина сегмента кода
   int  cread; // размер части кода для одного чтения
   long fmem;  // свободно памяти для сегмента кода
   FILE *ain;      // streams
    char *cname;
    RELOC rel;
    uint off, t;
    int e, cmd_class;

   uchar pas_len; // предполагаемая длина Pascal-строки
   uchar far *ps;



    char far *pref; // pointer to segment prefix string, like a 'ES:'
    char pref_buf[90]; // temporary buffer
    char need_ins=0; // =1 if prefix string need to insert into command

    tree_lev = 0; // chain tree empty

   if ((ain = fopen(name, "rb"))  == NULL) return -1;
   full_len = clen = flen(ain);

   cname = strstr( name, ".seg" ); cname = strcpy( cname, ".sea" );

   if   ((aout = fopen( name, "wt")) == NULL) { fclose(ain); return -1; };

   if (options & 4096) // two-pass:  macro-processor
   {
      amain_begin( progname, aout );
   }

    fmem = farcoreleft(); printf( "Free mem: %lu\n", fmem );
    if ( clen > fmem- 8*1024 ) clen = fmem - 8*1024;

    full_len -= clen; // остаток, не поместившийся в память

    jcode = jmem = farmalloc( clen + 256); normalize0(); // нормализуем jcode
    if (jmem == NULL )
    {
       printf ( "Code seg not farmalloc()ed\n");
       fclose(ain); fclose(aout); return -1;
    };

   clen_=clen; // сохраним
   // читаем первый кусок сегмента кода
   while (clen)
   {
      cread= ((long)clen>16*1024L) ? 16*1024 : (int)clen;
      clen -= (long)cread;
      if (fread( jcode, 1, cread, ain)<cread)
      {
	 printf ( "Read error\n");
	 fclose(ain); fclose(aout); farfree(jmem); return -1;
      };
      normalize( &jcode );
      jcode += cread;
   };
   clen=clen_;
   jcode=jmem; normalize0(); // нормализуем jcode


// pass one: cross reference analyzer
   tempp = jcode; printf("Pass #1 \r"); off=0;
   if (!flag32) while ( linear( x.segAdd, off ) < clen)
   {
    t=off; off = decode( jcode );
    cmd_class = _DX; // class of deassembled command
    switch ( cmd_class )
    {
        case cmdRETURN:
           // при возврате из п/п возможно понадобится пропустить байт 0
	   if ( *((char far *)MK_FP( FP_SEG(jcode), off )) ==0) off++;
           break;
        case cmdCALLF:
           // следующее за КОП слово - адрес ссылки
           tree_put( t, *((ushort *)(jcode+1)));
           break;
    }

   // проверим конец сегмента
   asm { mov ax,off; mov word ptr jcode,ax; cmp ax,0FF00h; jc low }
       JUSTIFY();
   low: ;
   };
// pass one end

   off = 0; x.segAdd=0; PsegAdd=0;
   jcode = tempp; printf("Pass #2 \n");
  next_chunk:
   while ( linear( x.segAdd, off ) < clen)
   {
    t=off;
    // progress indicator
    if (( t & 0x007F) == 0x007F)
     printf("%3d%%\r", (uint)( linear( x.segAdd, off )*100L / clen));

    if (segn==NE.winCS)
    {
       if (t == NE.winIP )
       {
	   pr_entry: afprintf("\n; Program Entry point\n");
       }
       else if ( t+1==NE.winIP )
       {
	   t++; jcode++; goto pr_entry;
       }
    };
    off = decode( jcode );
    cmd_class = _DX; // class of deassembled command

    if ( options & 2048 ) // autodetect standart runtime libraries
       autodetect_runtime( segn, t );

    if (need_ins == 1) // we need to insert some prefix ( es: cs: etc.)
    {
	char far *ttc;
        ttc=strchr(x.strb, '[');
	if (ttc) *ttc= 0;
        pref= &( x.strb[6] ); if (flag32) pref+=4;
	afprintf("%s", pref); // command body
	afprintf("%s", pref_buf); // saved prefix
        if (ttc) {*ttc='['; afprintf("%s", ttc);}
	need_ins=0;
    }
    else
    if (cmd_class == cmdPREFIX)
    {
        pref= &( x.strb[5] ); if (flag32) pref+=4; *pref++ =0;
        strcpy( pref_buf, pref);
	afprintf("%s\t", x.strb);
	need_ins=1;
    }
    else
    {
        char s[80];
        int i;
        switch ( cmd_class )
        {
            case cmdRETURN:
                 ps = MK_FP( FP_SEG(jcode), off);
		 if (*ps == 0)
//                 { strcat( x.strb, "\t; db 0 skipped"); off++; }
                 skip_nops( &ps, &off, 0x00U, "db 0" );
		 else if ( *ps == 0x90U ) skip_nops( &ps, &off, 0x90U, "NOP" );
		 else if ( *ps == 0xCCU ) skip_nops( &ps, &off, 0xCCU, "INT3" );
                 else
                 {
                    // проверим, не строка ли это в стиле Pascal
                    i = is_passtr( ps );
                    if (i)
                    {
                       afprintf("%s", x.strb);
                       while (i--)
                       {
                          pas_len = *(ps++);
                          off += (pas_len+1);
                          afprintf("\t; follows by '");
                          while (pas_len--) afprintf("%c", *ps++ );
                          afprintf("'\n");
                       }
                       goto ex;
		    }
                    // autodetect enabled ?
                    if (( options & 2048 ) && is_cstr( ps ))
                    {
                        afprintf("%s\t; follows by '", x.strb);
                        // рекомендации
                        fp_auto("%08lX cstring\n",
                           x.code_base + linear( x.segAdd, off ));
                        while (*ps)
                        {
                           afprintf("%c", *ps++ );
                        }
                        afprintf("'\n");
                        goto ex;
                    }
                 }
            case cmdCALLF :
            case cmdCALLN :
		 if (( options & 128 )==0) // mark disk offset in .exe file
                 sprintf( s, "\t; disk offset %lXh\n",
			   linear( x.segAdd, off )+FileOffset );
                 strcat( x.strb, s );
                 break;
            case cmdPUSHP :
                 if ( flag32 )
                 {
                    if ( *((uchar *)jcode) == 0x68 ) // PUSH imm32
                    ePush( *((long *)(jcode+1)) ); // имитируем помещение в стек
                    else if (*((uchar *)jcode) == 0x6A) // PUSH imm8
                    ePush( *(jcode+1) ); // имитируем помещение в стек
                    else  ePush( 0 );
                 }
                 break;
        }
	afprintf("%s", x.strb);
        ex:
    }


   if ( !flag32 )
   {
      int dclass, dimension, as;
      uchar far *s = jcode;
      uint far *dws = (uint far *)jcode;
      ulong far *dds = (ulong far *)jcode;
      int firsttime=1; // чтобы не зациклиться
      dbl:
      // search for user-defined strings in code seg
      if (( dclass=get_typex_udf( segn, t, &dimension, &as ))>0 )
      {
          off = t; // значение счетчика команд до деассемблирования
                   // команды, которая описана в userdef.txt
          if ( !dimension ) dimension++;
          switch ( dclass )
          {
                case 1: // cstring
                   afprintf("\nUDF cstring \"");
                   while ( *s )
                   {
                      afprintf("%c", *s++);
		      off++;
                   }
                   afprintf("\"");
                   break;
                case 2: // pstring
                   break;
                case 3: // db
                   afprintf("\nUDF db[%u]=", dimension);
                   while ( dimension-- )
                   {
                      if (( dimension & 0xF )== 0x0F )
                          afprintf("\n\t ");
                      afprintf(" %02X", *s++);
                      off++;
                   }
                   break;
                case 4: // dw
                   afprintf("\nUDF dw[%u]=", dimension);
                   while ( dimension-- )
                   {
		      switch ( as )
                      {
                        case 1: // WM_MSG16
                           afprintf(" %s", wm_msg16( *dws++));
                           off += 2;
                           break;
                        default:
                           afprintf(" %04X", *dws++);
                           off += 2;
                           break;
                      }
                   }
                   break;
                case 5: // dd
                   afprintf("\nUDF dd[%u]=", dimension);
                   while ( dimension-- )
                   {
                      afprintf(" %08lX", *dds++);
                      off += 4;
                   }
		   break;
          }
          afprintf(";\n.%04X:\n", off );
          goto skip_detections;
      } else
      {
         // возможно, предыдущее деассемблирование создало
         // ситуацию, когда t < nn < off
         // то есть сейчас (t) рано делать UDF, но середина этой
         // команды процессора приходится как раз на UDF (nn), и после
         // нее (команды) смещение превысит UDF и оно не сработает
	 if ( as!=0 && dimension!=0)
	 {
	    if (((uint)as > (uint)t) && ((uint)as < (uint)off) &&
	       (firsttime != 0))
	    {
	       firsttime=0; t=as; goto dbl;
	    }
	 }
      }

      // если в reloc table имеется запись, описывающая эту машинную команду
      if (relocGET( t+1, &rel) == 0) relocPRINT( &rel );
      else if ((e = entryGET( segn,t, &ent)) > 0)
      {
         afprintf("\t\t; E=%d, %04X:%04Xh", e, ent.seg, ent.offset);
         nameOfEntry();
         if (( options & 128 )==0 ) // разрешено указывать смещения процедур
                                   // в файле .exe на диске
         afprintf("\n\t\t\t\t; disk offset %lXh",
         FileOffset+(ulong)ent.offset);
      }

      else if ((cmd_class == 3) && ( (t=tree_get(t)) > 0 ))
      {
         // если в reloc table имеется запись, описывающая эту машинную команду
         if (relocGET( t+1, &rel) == 0) relocPRINT( &rel );
         else if ((e = entryGET( segn,t, &ent)) > 0)
         {
            afprintf("\t\t; E=%d, %04X:%04Xh", e, ent.seg, ent.offset);
	    nameOfEntry();
         }
      }

      if ( *((uchar far *)jcode) == 0xBF ) // код команды mov di,xxxx
      {
        if ( *(int far *)(jcode+3) == 0x570E ) // и далее push cs; push di
        {
           raw_dump_data( MK_FP( FP_SEG(jcode), *(int far *)(jcode+1)));
        }
      }
      // просмотрим ссылки на строки в сегменте данных
      if ( *((int far *)jcode) == 0x681E ) // код команд push ds; push imm16
      {
         if ( dseg )
            raw_dump_data( &dseg[ *(int far *)(jcode+2) ] );
      }
      // просмотрим ссылки на строки в сегменте кода
      if ( *((int far *)jcode) == 0x680E ) // код команд push cs; push imm16
      {
	 raw_dump_data( MK_FP( FP_SEG(jcode), *(int far *)(jcode+2)));
      }
      // если текущая команда выглядит как push cs; calln 1234h
      // то попробуем найти имя процедуры в этом же сегменте
      if ( *((uint far *)jcode) == 0xE80E ) // код команд push cs; call near
      {
         // указатель на имя функции, определенной пользователем в "userdef.txt"
         char *udf_name;
         // адрес процедуры, которая будет вызвана
         int target = (*(int far *)(jcode+2)) + FP_OFF(jcode) + 4;
         // пропустим префикс CS: и укажем текущий сегмент
         if ((e = entryGET( segn, target, &ent)) > 0)
         {
            afprintf("\t\t; E=%d, %04X:%04Xh", e, ent.seg, ent.offset);
            nameOfEntry();
         } else
         if ( get_imp_udf( segn, target, &udf_name ))
            afprintf("\t; UDF=%s\n", udf_name);
      }
      // при обнаружении оператора case, сделанного как таблица
      // адресов перехода, вывести рекомендации в autodet.txt
      if (( *((uint far *)jcode) == 0xFF2E ) && // код команд
          (options & 2048)) // разрешен анализ
      {
	  if (( *(jcode+2) == 0x67U ) || // jmp CS:[bx+..]
	      ( (uchar)*(jcode+2) == 0xA7 ))
          // 67 или A7
          fp_auto("%04X:%04X found jmp CS:[bx+..]\n",
          segn, FP_OFF(jcode));
      }
   };

   if ( flag32 ) // UDF
   {
      int dclass, dimension, as;
      ulong segnO;
      uchar far *s = jcode;
      uint far *dws = (uint far *)jcode;
      ulong far *dds = (ulong far *)jcode;
      int firsttime=1; // чтобы не зациклиться
      dbl_:
      segnO = (ulong)x.code_base + linear( x.segAdd, t /* off */ );
      // search for user-defined strings in code seg
      if (( dclass=get_typex_udf( segnO>>16, /* t */ (int)segnO , &dimension, &as ))>0 )
      {
          off = t; // значение счетчика команд до деассемблирования
                   // команды, которая описана в userdef.txt
          if ( !dimension ) dimension++;
          switch ( dclass )
          {
                case 1: // cstring
                   afprintf("\nUDF cstring \"");
                   if ( *s )
                   while ( *s )
		   {
                      afprintf("%c", *s++);
                      off++;
                   }
                   else { s++; off++; afprintf("NULL"); }
                   afprintf("\"");
		   break;
                case 2: // pstring
                   break;
                case 3: // db
                   afprintf("\nUDF db[%u]=", dimension);
                   while ( dimension-- )
                   {
                      if (( dimension & 0xF )== 0x0F )
			  afprintf("\n\t ");
                      afprintf(" %02X", *s++);
                      off++;
                   }
                   break;
                case 4: // dw
                   afprintf("\nUDF dw[%u]=", dimension);
                   while ( dimension-- )
                   {
                      switch ( as )
                      {
                        case 1: // WM_MSG16
			   afprintf(" %s", wm_msg16( *dws++));
			   off += 2;
                           break;
                        default:
                           afprintf(" %04X", *dws++);
                           off += 2;
                           break;
                      }
                   }
                   break;
                case 5: // dd
                   afprintf("\nUDF dd[%u]=", dimension);
                   while ( dimension-- )
                   {
		      afprintf(" %08lX", *dds++);
                      off += 4;
                   }
                   break;
          }
          afprintf(";\n.%08lX:\n",
	  x.code_base + linear( x.segAdd, off ));

          goto skip_detections;
      } else
      {
         // возможно, предыдущее деассемблирование создало
         // ситуацию, когда t < nn < off
	 // то есть сейчас (t) рано делать UDF, но середина этой
	 // команды процессора приходится как раз на UDF (nn), и после
	 // нее (команды) смещение превысит UDF и оно не сработает
	 if ( as!=0 && dimension!=0)
	 {
	    if (((uint)as > (uint)t) && ((uint)as < (uint)off) &&
	       (firsttime != 0))
	    {
	       firsttime=0; t=as; goto dbl_;
	    }
	 }
      }

   };

   if ( flag32 )
   {

       if ( *((uchar *)jcode) == 0xE8 ) // call 01234567
       {
          uchar huge *s;
          long target= *((long *)(jcode+1))+5L;
          s=jcode;
          s+=target;
          if ( s[0]==0xFF && s[1]==0x25 )  // JMP [01234567]
          {
              afprintf("\t; --> %s", get_imp( *((long *)(s+2)) ));
              if (LoadStringAdr == *((long *)(s+2)) )
              afprintf(", string Id=%lX '%s'", Pstack[1],
                 get_resource_string(Pstack[1]) );
          }
          else // для процедур, имена которых определены пользователем
          {
	      char *s;
              if (get_imp_s( target+ x.code_base+
                             linear( x.segAdd, (uint) jcode ), &s ))
              afprintf("\t; user defined, %s", s );
          }
       } else
       if ( *((uint *)jcode) == 0x1D8B || // mov ebx,[01234567]
            *((uint *)jcode) == 0x358B || // mov esi,[01234567]
            *((uint *)jcode) == 0x3D8B || // mov edi,[01234567]
            *((uint *)jcode) == 0x0D8B || // mov ecx,[01234567]
            *((uint *)jcode) == 0x2D8B ) // mov ebp,[01234567]
       {
          long adr= *((long *)(jcode+2));
          if ( adr>= minImpAdr && adr<= maxImpAdr )
          afprintf("\t; --> %s", get_imp( adr ));
          if (LoadStringAdr == adr )
          afprintf(", id=%lX '%s'", Pstack[1],
                 get_resource_string(Pstack[1]) );
       } else
       if ( *((uint *)jcode) == 0x15FF ) // call [01234567]
       {
          afprintf("\t; --> %s", get_imp( *((long *)(jcode+2)) ));
          if (LoadStringAdr == *((long *)(jcode+2)) )
          afprintf(", id=%lX '%s'", Pstack[1],
                 get_resource_string(Pstack[1]) );
   /*       else
          if ((LoadLibraryAdr == *((long *)(jcode+2))) && dseg)
                 raw_dump_data( &dseg[ Pstack[0] ] );   */
       } else
       if ( get_exp( c_RVA+ (ulong)((uint)jcode)) )
       {
          afprintf("\n\nExported %s\n\n",
          get_exp( c_RVA+ (ulong)((uint)jcode)));
       };

       if ( dseg ) // если удалось загрузить сегмент данных
       {
          long o;
          uchar c= *jcode;
          if ( c==0x68 || c==0xB8 || c==0xBA ) // push imm32, mov e?x,imm32
	  {
            o = *(long far *)(jcode+1);
            if ( o>dataObj && o<dataObjEnd )
            {
               raw_dump_data( &dseg[ o-dataObj ] );
            }
          }
       }
       if ( rdseg ) // если удалось загрузить сегмент .rdata
       {
          long o;
          uchar c= *jcode;
          if ( c==0x68 || c==0xB8 || c==0xBA ) // push imm32, mov e?x,imm32
          {
            o = *(long far *)(jcode+1);
            if ( o>rdataObj && o<rdataObjEnd )
            {
               raw_dump_data( &rdseg[ o-rdataObj ] );
            }
          }
       }
   }

   if ( options & 512 ) // печатать байты команд процессора
   {
      int j;
      int i= off-(int)jcode;
      if ( i<0 || i>10 ) i=4;
      for ( j=0; j<i; j++ ) afprintf(" %02X", *(uchar *)(jcode+j));
   }

   if (need_ins == 0) afprintf( "\n");
   if (cmd_class == 1) afprintf( "\n");

   skip_detections:

   // проверим конец сегмента
   asm { mov ax,off; mov word ptr jcode,ax; cmp ax,0FF00h; jc low2 }
       JUSTIFY();
   low2: ;
   };

   if ( full_len )
   {
      char far *rd;
      // адрес следующей обрабатываемой команды (от начала файла)
      long ip=linear( x.segAdd, (uint) jcode );
      // фактический адрес от начала файла
      long z=ftell( ain );
      long s=linear( (ulong)PsegAdd, 0); // сколько можем считывать максимально
      printf("\n%lu bytes of CODE is left, loading now...\n", full_len );
      afprintf("\nLoading next chunk of code...\n");
      // сохранив смещение, вернемся ближе к началу буфера кода
      asm { mov ax,PsegAdd; sub word ptr jcode+2,ax; mov PsegAdd,0 };
      // скорректируем положение в файле
      z -= ip;
      fseek( ain, ip, 0 );
      full_len += z;

      if ( s>full_len ) s=full_len;
      rd = jcode;
      full_len -= s;
      clen     += s;
      while (s)
      {
         cread= ((long)s>16*1024L) ? 16*1024 : (int)s;
         s -= (long)cread;
         if (fread( rd, 1, cread, ain)<cread)
         {
            printf ( "Read error\n");
            fclose(ain); fclose(aout); farfree(jmem); return -1;
         };
         normalize( &rd );
         rd += cread;
      };
      goto next_chunk;
   }

   if (options & 4096) // two-pass:  macro-processor
   {
      amain_end(); // flush the queue
   }

   fclose(aout); fclose(ain);
   farfree(jmem);
   return 0;
}

void pString(ulong offset)
{
    char i;
    ulong curpos;
    save_pos(&curpos);
    getAt( offset, sizeof(i), &i );
    while (i-- > 0) fputc( fgetc(in), out);
    iseek( curpos );
}


int fgetW(void)
{
    int i;
    fread( &i, sizeof(i), 1, in);
    return i;
}

long fgetL(void)
{
    long i;
    fread( &i, sizeof(i), 1, in);
    return i;
}

// преобразует русские сообщения в UNICODE
char rusUni( int x )
{
    uchar c= x& 0xFF;
    if ( c>0x0F && c< 0x30 )
    {
       return c-0x10+'А';
    };
    if ( c<'0' || c>'O' ) return '.';
    c = c-'0'+'а';
    if ( c>175 /* 'п' */ ) c += 48; return c;
}

// возвращает количество прочитанных байт, включая слово-длину
uchar pString32buf[32];
int pString32(ulong offset)
{
    int i,j,k,n;
    ulong curpos;
    save_pos(&curpos);
    getAt( offset, sizeof(i), &i );
    j=i;
    fputc( 0x22, out);
    n=0;
    while (i-- > 0)
    {
       k=fgetW(); // распознаем русский Unicode
       pString32buf[n] = (( k & 0xFF00 )==0x400 ) ? rusUni( k ) : (k & 0xFF);
       fputc( pString32buf[n], out );
       if ( n<25 ) n++;
    }
    pString32buf[n] = 0;
    fputc( 0x22, out);
    iseek( curpos );
    return j*2+2;
}

static char fb[40];

char *pFlag( char flag )
{
    sprintf( fb, "%d.", flag>>2 );
    if (( flag & 0x1) != 0) strcat( fb, "\tExports");
    if (( flag & 0x2) != 0) strcat( fb, "\tUseSingleDATA");
    return fb;
}

void pETable(void)
{
    struct { char number, seg; } ETheader;
    struct { char flag; int offset; } fixed;
    struct { char flag, cd, _3f, number; int offset; } movable;
    int entry=1;
    entryINIT();

// напечатаем таблицу адpесов входов в модуль
    iseekNE( (ulong)NE.EToffset );
    fp("[Entry table]\n\tat\t%lXh, movable entries"\
             " %d.\n\t#\tFix/Mov\tseg:offset\t#parm\tflags\n",
             newExeOffset+(ulong)NE.EToffset, NE.MEPcount );

    for (;;)
    {
        fread( &ETheader, sizeof( ETheader ), 1, in);
        if (ETheader.number == 0) break; // конец таблицы
        if (ETheader.seg == 0) // пустышка, пpопустим
        { fp("\t%d.\tNull entry\n", entry++);
	  entryPUT( 0,0 );
        fread( &ETheader, sizeof( ETheader ), 1, in);
        if (ETheader.number == 0) break;
        };
        while (ETheader.number-- >0)
	{ if ((uchar)ETheader.seg != 0xFF)    // fixed seg entries
            { fread( &fixed, sizeof( fixed ), 1, in);
            fp("\t%d.\tF\t%04X:%04Xh\t%s\n",
            entry++, ETheader.seg, fixed.offset, pFlag(fixed.flag) );
            // entryPUT( 0xFF, fixed.offset );
            entryPUT( ETheader.seg, fixed.offset );
            }
        else
            { fread( &movable, sizeof( movable ), 1, in);
            fp("\t%d.\tM\t%04X:%04Xh\t%s\n",
            entry++, (int) movable.number, movable.offset,
            pFlag(movable.flag) );
            entryPUT( movable.number, movable.offset );
            };
	};
    }
}

char copyBuffer[1024];
void fileCopy( FILE *in, FILE *out, long len )
{
    int n;
    while ( len != 0) {
		n = (unsigned int)(( len > 1024 ) ? 1024 : len );
		fread ((char *)copyBuffer, 1, n, in);
                fwrite((char *)copyBuffer, 1, n, out);
		len -= n;
    }
}

// copies code segment from .dll to standalone file
void seg2file( ulong offset, ulong len, char *name)
{
    ulong curpos;
    int n;
    if ((bout = fopen(name, "wb"))  == NULL) return;
    save_pos(&curpos);
    iseek( offset );
    fileCopy( in, bout, len );
    iseek( curpos );
    fclose(bout);
}

// помечает битом 1 занятость адреса
int *nmbr;
void mark_a( uint num)
{
   int i,j;
   i=num;
   asm { shr word ptr [i],4; mov cx,num; and cl,0Fh; mov ax,1; shl ax,cl; mov j,ax }
   nmbr[i] |= j;
}

// проверяет занятость адреса
int is_mark( uint num)
{
   int i,j;
   i=num;
   asm { shr word ptr [i],4; mov cx,num; and cl,0Fh; mov ax,1; shl ax,cl; mov j,ax }
   return (nmbr[i] & j);
}

void fineSegSRC( char *name )
{
   long clen, cclen;
   FILE *ain, *aout;      // streams
    int j, adr;
    char c, d, e;

    nmbr = (int *)malloc( (4096+1)*2 );
    if ( nmbr == NULL ) { printf("label check failed, no heap\n");
	return; }

    for ( j=0; j<4096; j++ ) nmbr[j] = 0;

   if ((ain = fopen(name, "rb"))  == NULL) {
        free( nmbr );
	return; // name of .sea
   }
   cclen = clen = flen(ain);

   adr = 0;
   while ( clen-- >0 )
   {
        c = fgetc(ain);
	if ( isxdigit(c) )
	{
		adr *= 16;
		if ( c < 65 ) adr += (c-48);
		else adr += (c-65+10);
	}
	else  // ":" ends the addres label
        {
                if ( c != 58 ) mark_a(adr);
                adr = 0;
	}
   }
   fseek( ain,0,0 );

   printf(" search done, ");
   strcpy( strstr( name, ".sea" ), ".asm" );

   if ((aout = fopen(name, "wb"))  == NULL) {
        fclose( ain );
        free( nmbr );
	return; // name of .asm
   }

   clen = cclen;

   while ( clen-- >0 )
   {
        c = fgetc(ain);
        if ( c != 0x0A ) fputc( c, aout );
        else
	{
               fputc( c, aout );
               adr = 0;
               j = 0;                   // count of fgetc()

               rr:
                c = fgetc(ain); j++;

                if ( isxdigit(c) )
                {
                        adr *= 16;
                        if ( c < 65 ) adr += (c-48);
                        else adr += (c-65+10);
                        if ( j < 7 ) goto rr;
		}

		    fgetc(ain);   // skip Tab
		d = fgetc(ain);   // get 'C' if Call
		e = fgetc(ain);   // get 'a' if Call
		fseek( ain, (signed long)(-3), 1 );


                if (( is_mark(adr) != 0 ) ||
		    ( j != 5 ) ||
                    (( d == 0x43) && ( e == 0x61) && ( is_mark(adr+1) != 0 ))
                    )
                {
			fseek( ain, (signed long)(-j), 1 );     // go back
                }
		else clen -= j;


        }
   }

   fclose(ain);
   fclose(aout);
   free(nmbr);
}

// загружаем в память сегмент данных, NULL если неудачно
char far *load_dseg( char *name, long max )
{
   long clen;  // длина сегмента
   int  cread; // размер части кода для одного чтения
   FILE *ain;      // streams
   char far *dsega;
   char far *dseg; // LOCAL !!!


   dseg=NULL;
   if ((ain = fopen(name, "rb"))  == NULL) return NULL;
   clen = flen(ain);

   if ( max ) { if ( clen>max ) clen=max; }

   dseg = farmalloc( clen + 2);
   if (dseg == NULL )
   {
      printf ( "Data seg not preloaded\n");
      fclose(ain); return NULL;
   };

   dsega=dseg;
   while (clen)
   {
      cread= clen>16*1024L ? 16*1024 : (int)clen;
      clen -= (long)cread;
      if (fread( dsega, 1, cread, ain)<cread)
      {
	 printf ( "Read error\n");
         fclose(ain); farfree(dseg); return NULL;
      };
      dsega += cread;
      normalize( &dsega );
   };
   fclose(ain);
   return dseg;
}

void pSegment(void)
{
    uchar IsCode; // признак типа сегмента: =1 код, =0 данные
    int count = NE.SEGtableEnt, cname = 1;
    char name[40];

    iseekNE( (ulong)NE.SEGtableOff );

    fp("[Segment table] at %lXh, %d. entries\n",
             newExeOffset+(ulong)NE.SEGtableOff, NE.SEGtableEnt );

    fp("\tnote:\tFS means \'fixed segment\'\n\t\tMSE means "\
       "\'movable Seg Entry\'\n"\
       "\tOffset\tLength\tFLAGS\tAllocSize\tType\n");

    // делаем первый проход по сегментам чтобы найти сегмент данных
    while (count-- >0)
    {   fread( &segR, sizeof( segR ), 1, in);
        if (( segR.FlagWord & 0x1) != 0) IsCode=0; else IsCode=1;
        FileOffset=(ulong)segR.Offset*Lshift;

	sprintf( name, "%04d.seg", cname++);
        seg2file( FileOffset, (ulong)segR.Length, name);
        if (!IsCode )
	{
                if ((dseg=load_dseg(name,0))!=NULL)
                printf("DATA %s preloaded Ok\n",name);
                unlink( name );
        }
    }

    count = NE.SEGtableEnt; cname = 1;
    iseekNE( (ulong)NE.SEGtableOff );
    while (count-- >0)
    {   fread( &segR, sizeof( segR ), 1, in);
        if (( segR.FlagWord & 0x1) != 0) IsCode=0; else IsCode=1;
        FileOffset=(ulong)segR.Offset*Lshift;
        fp("\t%lXh\t%Xh\t%Xh\t%Xh",
        FileOffset, segR.Length, segR.FlagWord, segR.AllocSize);
        if (IsCode) fp("\t\tCODE %04d.seg\n", cname);
        else fp("\t\tDATA %04d.seg\n", cname);
	sprintf( name, "%04d.seg", cname++);
        seg2file( FileOffset, (ulong)segR.Length, name);
	relocINIT();
        if (( segR.FlagWord & 0x0100) != 0) if (( options & 0x8) == 0)
        {
	    int rcount;
	    struct { char adr_type, rel_type; int offset; } h;
            struct { int module, func; } imp;
            ulong curpos;
            save_pos(&curpos);

            fp("   ■■ Relocations for this segment:\n");
        getAt( FileOffset + segR.Length, sizeof( rcount ), &rcount);
            while ( rcount-- > 0 )
            {   fread( &h, sizeof( h ), 1, in);
                switch ( h.adr_type) {
                    case 1: fp("\tOff"); break;
                    case 2: fp("\tSeg"); break;
                    case 3: fp("\tO+S"); break;
                    case 5: fp("\tOFFS"); break;
                    default: fp("\tUnkn");
                }
                fp( "\t%04Xh", h.offset);
                fread( &imp, sizeof( imp ), 1, in);
                switch ( h.rel_type & 0x03) {
                    case 0: if (( imp.module & 0xFF) != 0xFF ) fp(
			    "\tto FS %04X:%04Xh\n",
			    imp.module, imp.func );
                            else fp(
			    "\tto MSE #%04d.\n", imp.func );
			    relocPUT( h.offset, imp.module, imp.func, 1);
			    break;
		    case 1:
			    if ( imp.module < 15 ) {
                            fp( "\t%s.%s\n",
			    mName[imp.module],
			    NameIt(mName[imp.module], imp.func) );
			    relocPUT( h.offset, imp.module, imp.func,0);
			    }
			    else
                            fp( "\tModule #%d.\tFunc %d.\n",
			    imp.module, imp.func ); break;
		    case 2:
			    if ( imp.module < 15 ) {
                            fp( "\tin %s. %s\n",
			    mName[imp.module], INstring(imp.func) );
			    relocPUT( h.offset, imp.module, imp.func,2);}
			    else
                            fp( "\tModule #%d.\t%s\n",
			    imp.module, INstring(imp.func) ); break;
		    default:
                            fp("\t?? %02Xh %04Xh %04Xh\n",
                               h.rel_type, imp.module, imp.func);
		    } // end case
	    }; // end while (rcount
	    iseek( curpos );
	}; // end if(
        if (IsCode && (( options & 0x1) == 0))
	{
		processSEG( name, cname-1 );   // create .sea
		printf("%s created, ",name);

            if (options & 4096) // two-pass:  macro-processor
            {
                /*
                printf("macro post-processor ");
                amain( progname, name, "$pass.two");
                strcpy( strstr( name, "." ), ".sea" );
                unlink( name );                // delete .sea
                rename( "$pass.two", name );
                printf("done.\n");
                */
            }

            if ((options&0x100)==0)
            {
                fineSegSRC( name );
		printf("%s\n",name);
                strcpy( strstr( name, "." ), ".sea" );
                unlink( name );                // delete .sea
            } else printf("\n");
        }
    else printf("%s\t\r", name);
    if (IsCode && ((options & 0x0004) == 0))
    {
      strcpy( strstr( name, "." ), ".seg" );
      unlink( name );                             // delete .seg for CODE
    }
    }
}

void putPascalStr(int o)
{
    fp("\x27");
    pString( newExeOffset+(ulong)NE.RStableOff+(ulong)o );
    fp("\x27\n");
}


// structures for BITMAP resource save
struct BMPheader {

// BitMapFileHeader
    int       bfType;             // BM
    long int  bfSize;                // file size
    int       bfReserved1;
    int       bfReserved2;
    long int  bfOffBits;             // offset BITMAP from begin of file
} BMPfileH;

struct BMPinfo {
// BitMapInfoHeader
    long int    biSize;         // header partial size, 40./12. bytes
    long int    biWidth;
    long int    biHeight;
    int         biPlanes;
    int         biBitCount;
} BMPheader;

struct {                        // only if biSize is 40. bytes
    long int    biCompression;
    long int    biSizeImage;
    long int    biXPelsPerMeter;
    long int    biYPelsPerMeter;
    long int    biClrUsed;
    long int    biClrImportant;
} h40;


FILE *createDIB( char *name, int *count) // create an .ICO .BMP .CUR file
{
    char BMPname[24];
    sprintf( BMPname, name, (*count)++);
    return fopen(BMPname, "wb");
}

int BMPcount=1;
void putBITMAP( long off )
{
    FILE *b;
    long count;
    ulong curpos;
    save_pos(&curpos);
    if (( options & 0x0002 ) == 0) return;

    if ((b = createDIB( "rc\\bmp%04d.bmp", &BMPcount )) == NULL) return;

	getAt( off, sizeof(BMPheader), &BMPheader );

    BMPfileH.bfType = 0x4D42;   		// 'BM'
    count = 4L << (BMPheader.biBitCount);       // RGBquad[] size
    BMPfileH.bfOffBits=             		// offs BITMAP from begin of file
    BMPheader.biSize+((long)sizeof( BMPfileH )) + count;
    BMPfileH.bfSize =                   	// .BMP file size
    BMPfileH.bfOffBits +
    BMPheader.biWidth*BMPheader.biHeight*(long)(BMPheader.biBitCount)/8 ;

    BMPfileH.bfReserved1=BMPfileH.bfReserved2=0;

    fwrite( &BMPfileH, sizeof(BMPfileH), 1, b);
    iseek(off);
    count = BMPfileH.bfSize-sizeof(BMPfileH);
    fileCopy( in, b, count );
    fclose(b);
    iseek(curpos);
}

struct {              // ICOfileHeader
    int       reserved;
    int       type;           // icon/cursor file signature 8-)
    int       count;          // 1 icon per file
//--------------------------- IcoDirEntry ------------
    char        biWidth;
    char        biHeight;
    char        biColorCount;
    char        reserved_;
    int         res1, res2;
    long        dwBytesInRes;
    long        dwImageOffset;
} ICOfile;

int ICOcount=1;
void putICON( long off )
{
    FILE *b;
    long count;
    ulong curpos;
    save_pos(&curpos);
    if (( options & 0x0002 ) == 0) return;

    if ((b = createDIB( "rc\\ico%04d.ico", &ICOcount )) == NULL) return;

	getAt( off, sizeof(BMPheader), &BMPheader );

    ICOfile.reserved=0;
    ICOfile.type=1;           // icon/cursor file signature 8-)
    ICOfile.count=1;          // 1 icon per file
    ICOfile.biWidth=(unsigned char)BMPheader.biWidth;
    ICOfile.biHeight=(unsigned char)(BMPheader.biHeight>>1);
    ICOfile.biColorCount=(unsigned char)(1<<BMPheader.biBitCount);
    ICOfile.reserved_=0;
    ICOfile.res1=ICOfile.res2=0;
    count = ((ulong)ICOfile.biWidth)*((ulong)ICOfile.biHeight);
    ICOfile.dwBytesInRes=BMPheader.biSize+4L*ICOfile.biColorCount+
    count*(ulong)(BMPheader.biBitCount)/8+count/8;
    ICOfile.dwImageOffset=sizeof(ICOfile);

    fwrite( &ICOfile, sizeof(ICOfile), 1, b);
    iseek(off);
    count = ICOfile.dwBytesInRes;
    fileCopy( in, b, count );
    fclose(b);
    iseek(curpos);
}


int CURcount=1;
void putCUR( long off )
{
    FILE *b;
    long count, temp;
    ulong curpos;
    save_pos(&curpos);
    if (( options & 0x0002 ) == 0) return;

    if ((b = createDIB( "rc\\cur%04d.cur", &CURcount )) == NULL) return;

    getAt( off, 2, &(ICOfile.res1));  // hot spot X
    getAt( off+2, 2, &(ICOfile.res2));  // hot spot Y
	getAt( off+4, sizeof(BMPheader), &BMPheader );
    fread( &temp, 4, 1, in);

    ICOfile.reserved=0;
    ICOfile.type=2;           // icon/cursor file signature 8-)
    ICOfile.count=1;          // 1 icon per file
    ICOfile.biWidth=(unsigned char)BMPheader.biWidth;
    ICOfile.biHeight=(unsigned char)(BMPheader.biHeight>>1);
    ICOfile.biColorCount=(unsigned char)(1<<BMPheader.biBitCount);
    ICOfile.reserved_=0;
    count = ((long)ICOfile.biWidth)*((long)ICOfile.biHeight);
    ICOfile.dwBytesInRes=BMPheader.biSize+4L*ICOfile.biColorCount+
    count*(long)(BMPheader.biBitCount)/8+count/8;
    ICOfile.dwImageOffset=sizeof(ICOfile);

    fwrite( &ICOfile, sizeof(ICOfile), 1, b);
    iseek(off+4);
    count = ICOfile.dwBytesInRes;
    fileCopy( in, b, count );
    fclose(b);
    iseek(curpos);
}

void spaces( int count )
{
    int space;
    oTab();
    for ( space=0; space < count*3; space++ ) fputc( 0x20, out);
}

// implies an Windows 1250 code page support
uchar decodeMS( uchar c )
{
    static char sourceMS[] = "█└┴┬├─┼╞╟╚╔╩╦╠═╬╧╨╤╥╙╘╒╓╫╪┘▄▌▐▀рстуфхцчшщъыьэюяЁёЄєЇїЎў°∙№¤■√\377";
    static char destMS[]   = "ЫАБВГДЕЖЗИЙКЛМНОПPСТУФХЦЧШЩЬЭЮЯабвгдежзийклмнопpстуфхцчшщьэюыя";
    unsigned int i=0;
    if ( options & 64 ) return c;
    while ( sourceMS[i] )
    {
      if (sourceMS[i]==c)
      {
	  c=destMS[i];
          return c;
      };
      i++;
    }
    return c;
}

void putASCIIZ( void )
{
    char c;
    fputc( 0x22, out); while (( c = fgetc(in)) != 0) fputc(decodeMS(c), out);
    fputc( 0x22, out);
}

void putASCIIZ32( void )
{
    int c;
    fputc( 0x22, out);
    fread( &c, sizeof(c), 1, in); // в кодировке UNICODE
    while ( c )
    {
       if (( c & 0xFF00 )==0x400) fputc( rusUni( c ), out);
       else                       fputc(  c , out);
       c=fgetW();
    }
    fputc( 0x22, out);
}

void putMENU( long off )
{
    long count; ulong curpos;
    unsigned int flag, menuID;
    char c;
    int indent = 1;
    char endflag[32]; char level = 0;
    save_pos(&curpos);

    if ( options & 0x0010 ) return;

    getAt( off, 4, &count );  // empty header
    fp( "\n\tBegin\n" );

    read:
    fread( &flag, sizeof(flag), 1, in);
    spaces(indent);

    if (( flag & 0x0010) == 0 ) // normal menu item
    {
    fread( &menuID, sizeof(menuID), 1, in);
    fp( "MenuItem " ); putASCIIZ(); fp( ", %u\n", menuID);
    if (( flag & 0x0080) != 0 )  // End
    {
        indent--;
        spaces(indent); ofprintfEND();
        while (( endflag[level] ) && (level))
        {
        indent--; level--;
        spaces(indent); ofprintfEND();
        }
        if ( indent <= 0 ) { iseek(curpos); return; }
    }
    }
    else                        // pop-up menu item
    {
    fp( "POPUP " ); putASCIIZ(); fp("\n");
    spaces(indent); fp("Begin\n");
    indent++; level++;
    if (( flag & 0x0080) != 0 )  // End
      endflag[level] = 1;
    else endflag[level] = 0;
    }

    goto read;
}

char *class[6] = { "button","edit","static","listbox","scrollbar","combobox" };
void putDLG( long off )
{
    long style; ulong curpos;
    unsigned int flag, menuID, j;
    unsigned int i[4];
    unsigned char count, c, len, name[64];
    save_pos(&curpos);

    if ( options & 0x0010 ) return;

    getAt( off, 4, &style );                    // dialog style
    fread( &count, sizeof(count), 1, in);       // controls

    fread( &(i[0]), sizeof(i), 1, in);
    fp( "\nDIALOG %u, %u, %u, %u\n",
			 i[0],i[1],i[2],i[3] ); // coordinates

    if ((c=fgetc(in)) != 0) {
        fp("menu ");
        if ( c == 0xFF )                // dialog has a menu, numeric label
        {
            fread( &j, sizeof(j), 1, in);
            fp( "%u", j );
        }
        else { go_back(1); putASCIIZ(); } // string labeled menu
        fp("\n");
    }

    if ((c=fgetc(in)) != 0) {
    fp("class "); go_back(1); putASCIIZ(); }

    fp( " STYLE 0x%08lXL\n", style );

    fp( "CAPTION " ); putASCIIZ(); fp( "\n" ); // caption
    if ( style & 0x0040L )
    {
            fread( &j, sizeof(j), 1, in);
            fp( "FONT %u, ", j );
            putASCIIZ(); fp( "\n" ); // font name
    }
    fp( "Begin\n" );
    while (count-- > 0)
    {
       fread( &(i[0]), sizeof(i), 1, in);    // rectangle
       fread( &j, sizeof(j), 1, in);         // itemID
       fread( &style, sizeof(style), 1, in); // style
       c = fgetc(in);
       if(c < 0x80 || c > 0x85)   /* non standard class, Andreas Gruen*/
       {
           name[0]=0;
           if ( c )
           {
              len=0;
              go_back(1);
              while (( len<60 ) && (( name[len] = fgetc(in)) != 0)) len++;
              name[len] = 0;
           }
       }
       else strcpy( name, class[c & 0x7] );
       fp( "  Control "); putASCIIZ(); fgetc(in);
       fp( ",\n%5d, \"%s\",\t0x%08lXL, %u, %u, %u, %u\n",
       j, name, style, i[0],i[1],i[2],i[3] );
    }
    ofprintfEND();
    iseek(curpos);
}

//----------------------------- RT_DIALOGEX ------------------------
struct
{
   ulong style, eXstyle;
   uint count;        // controls per dialog
   uint x,y,x1,y1;
} d32;

struct
{
   ulong mark, zero;
   ulong eXstyle, style;
   uint count;        // controls per dialog
   uint x,y,x1,y1;
} d32ex;

struct
{
   ulong style, eXstyle;
   uint x,y,x1,y1, id;
} c32;

struct
{
   ulong mark; // uint zero;
   ulong style;
   ulong eXstyle;
   uint x,y,x1,y1;
   ulong id;
} c32ex;

void clsid(char *s)
{
   int c;
   c=fgetW();
   switch (c)
   {
      case 0: break;
      case -1: fp( "%s id %u\n", s, fgetW() ); // numeric ID
         break;
      default:
         fp( "%s ", s ); go_back(2);
         putASCIIZ32(); fp("\n"); // string labeled
   }
}

void fntid(long style)
{
   if ( style & 0x0040L )
   {
      fp( "FONT %u, ", fgetW() );
      fgetW(); fgetW();
      putASCIIZ32(); fp( "\n" ); // font name
   }
}

void ctlid(void)
{
   int c, j;
   c=fgetW(); // control class
   if (c==-1)
   {
       j=fgetW();
       if (j < 0x080 || j > 0x085)
       fp( "class id %u\n", j ); // numeric ID
       else fp( "%s ", class[j & 0x7] );
   }
   else
   {
       fp( "class "); go_back(2); putASCIIZ32(); fp("\n"); // string labeled
   }
}

void ctltext(void)
{
    int c;
    c=fgetW(); // control text
    if (c==-1)
       fp( " %u ", fgetW() ); // numeric ID
    else
    {
       go_back(2); putASCIIZ32(); fp("\n"); // string labeled
    }
}

void putDLG32( long off )
{
    ulong curpos, cp, style;
    unsigned int flag, menuID, j;
    uint len, i[4];
    int c;
    char name[64];


    if ( options & 0x0010 ) return; save_pos(&curpos);

    getAt( off, sizeof(d32), &d32 );
    if ( d32.style==0xFFFF0001 )         // DIALOGEX
    {
        getAt( off, sizeof(d32ex), &d32ex );
        fp( "\nDIALOGEX %u, %u, %u, %u\n",
                         d32ex.x, d32ex.y, d32ex.x1, d32ex.y1 ); // coordinates
            clsid("menu"); // menuID
            clsid("class"); // dialog wnd class

            fp( " STYLE 0x%08lXL\nCAPTION ", d32ex.style );
            putASCIIZ32(); fp( "\n" ); // caption
            fntid( d32ex.style );
            fp( "Begin\n" );

            if ( d32ex.count > 10 )
            { fp("controls count reduced\n"); d32ex.count = 10; }

            while (d32ex.count-- > 0)
            {
               cp = ftell(in);
               if ( cp & 3 ) fgetW(); // выравнивание
               // fp("offset %lX\n", cp);
               fread( &c32ex, sizeof(c32ex), 1, in);    // rectangle
               fp( "  Control ");

               ctlid(); // control class
               ctltext(); // control text

               fp( "\t0x%lX, %u, %u, %u, %u, id 0x%lX\n",
                c32ex.style, c32ex.x, c32ex.y, c32ex.x1, c32ex.y1, c32ex.id );
            }
            ofprintfEND();
        iseek(curpos);
        return;
    }
    fp( "\nDIALOG %u, %u, %u, %u\n",
			 d32.x, d32.y, d32.x1, d32.y1 ); // coordinates

    clsid("menu"); // menuID
    clsid("class"); // dialog wnd class
    fp( " STYLE 0x%08lXL\nCAPTION ", d32.style );

    putASCIIZ32(); fp( "\n" ); // caption
    fntid( d32.style );

    fp( "Begin\n" );
    while (d32.count-- > 0)
    {
       cp = ftell(in);
       if ( cp & 3 ) fgetW(); // выравнивание
       if ( fgetL() ) go_back(4); // лишнее нулевое слово ?
       // fp("offset %lX\n", cp);
       fread( &c32, sizeof(c32), 1, in);    // rectangle
       fp( "  Control ");

       ctlid(); // control class
       ctltext(); // control text

       fp( "\t0x%08lXL, %u, %u, %u, %u, id 0x%X\n",
        c32.style, c32.x, c32.y, c32.x1, c32.y1, c32.id );
    }
    ofprintfEND();

    iseek(curpos);
}

void pResFlag( int i )
{
	if ( i & 0x0010 != 0 ) fp("MOVEABLE");
        else                   fp("FIXED");
        if ( i & 0x0020 != 0 ) fp(", PURE");
        if ( i & 0x1000 != 0 ) fp(", DISCARDABLE");
        if ( i & 0x0040 != 0 ) fp(", PRELOAD");
        else                   fp(", LOADONCALL");
        fp("\n");
}


void pResource(void)
{
    int RScount, count, rType;
    long boff;

    if (options & 2) // -b extract bitmaps
      mkdir("rc"); // каталог для ресурсов

    fp("[Resource table]\n\toffset (file) %lXh\n",
    newExeOffset+(ulong)NE.RStableOff );
    getAt( newExeOffset+(ulong)NE.RStableOff, 2, &RScount);

    // смещения измеpены в 1^RScount байт
    fread( &res, sizeof( res ), 1, in); // read resource header

    while ( res.resType != 0 ) // 0 if last resource
    {
       fp("\n\n");
       rType= res.resType & 0x7FFF;
       if ( rType>15 ) // неизвестный тип ресурса
       {
          fp("\tType = %04Xh\n");
       }
       else
       {
       if ((res.resType & 0x8000) != 0) // номеp < 0 это индекс в таблице имен
       fp("\t%s\n", resNAME[rType-1] );
       // иначе это стpока в стиле Паскаль
       else putPascalStr(res.resType);
       };

    count = res.resCount;
    // для всех pесуpсов этого типа
    fp("Offset\tLength\tFLAGS\n");
    while (count-- > 0)
    {
       fread( &resD, sizeof( resD ), 1, in);
       boff = ((ulong) resD.resOffset) << ((long)RScount);
       fp("\n%lX\t%d.\t%Xh\t",
       boff, resD.resLen, resD.resFLAG);
       pResFlag(resD.resFLAG);
       fp("res.name\t");
       if (rType == 1) putCUR( boff );
       if (rType == 2) putBITMAP( boff );
       if (rType == 3) putICON( boff );

       // if below than 0 it's name index, else PASCAL-style string
       if ((resD.resName & 0x8000) != 0) fp("%d.\n", (resD.resName & 0x7FFF));
       // else putPascalStr(res.resType);
       else putPascalStr(resD.resName);

       if (rType == 4) putMENU( boff );
       if (rType == 5) putDLG( boff );

       if (rType == 6) {           // stringtable
        int block;
        unsigned char c;
        ulong curpos;
        save_pos(&curpos);
        fseek( in, boff, 0);
        fp("\tBegin\n");
        for ( block=0; block<16; block++ )
        {
	    if ((c=fgetc(in)) != 0) {               // Pascal-style strlen
                fp( "\t%5u, \x22", block+
                ((resD.resName & 0x7FFF)-1)*16 );
                while (c-- > 0) fputc( decodeMS(fgetc(in)), out);
                fp("\x22\n");
            }
        }
        oTab(); ofprintfEND();
        iseek( curpos );
        }
    };
    // пpочитаем следующий тип pесуpса
      fread( &res, sizeof( res ), 1, in);
    }
}

void pNames(long where)
{
    char i;
    int ref;
    iseek( where );
    lo:
    fread( &i, sizeof(i), 1, in);
    if (i==0) return;
    oTab();
    fileCopy( in, out, (ulong)i );
    fread( &ref, sizeof(ref), 1, in);
    fp( "\t%4d.\n", ref);
    goto lo;
}

long len;

char far *pname;

void ChkName(char *a)
{
   if (( pname=strstr(strupr(a),".EXE")) != NULL ) goto o;
   if (( pname=strstr(strupr(a),".DLL")) != NULL ) goto o;
   if (( pname=strstr(strupr(a),".DRV")) != NULL ) goto o;
   if (( pname=strstr(strupr(a),".OBJ")) != NULL ) goto o;

   fprintf(stderr, "Input file extension is not {exe|dll|drv|obj}\n"); exit(1);

   o:
   if ((in = fopen(a, "rb"))  == NULL)
   {
      fprintf(stderr, "Can`t open input file.\n"); exit(1);
   }
}

void PrintOldHeader(void)
{
fp("[DOS]\n\tFile Size\t%ld.\tLoad Image Size\t%Xh\n",
       len, o.totalPages*512 );
fp("\tRelocation Table: entries %d. address %Xh\n",
       o.rCount, o.RitemOffset );
fp("\tSize of header (in paragraphs) %Xh\n", o.hSize );
fp("\tMemory Requirement (in paragraphs): min %Xh max %Xh\n",
            o.minMemory, o.maxMemory );
fp("\tFile load checksum\t\t%Xh\n\tOverlay #\t\t\t%Xh\n",
             o.chkSum, o.ovlNumber );
fp("\tStack Segment (SS:SP)\t\t%04X:%04X\n",
            o.SSoffset, o.SPoffset );
fp("\tProgram Entry Point (CS:IP)\t%04X:%04X\n",
            o.CS, o.IP );
}


void pModuleName(void)
{
    int c=NE.MODrefEnt;
    int o=0;
    char m; // module #
    ulong curpos;
    save_pos(&curpos);
    for (m=0; m<16; m++) mName[m][0] = 0;
    m=1;
    fp("[Module reference table]\n\toffset\t%Xh,",
             newExeOffset + NE.MODrefOff );
    fp(" entries: %d.\n", NE.MODrefEnt);
    fp("[Imported names table]\n\toffset\t%04Xh\n",
             newExeOffset + NE.IMPnamesTableOff );
    iseekNE( (ulong)NE.MODrefOff );
    while (c-->0) {
    fread( &o, sizeof( o ), 1, in);
    oTab();
    {
    char i,k=0;
    ulong curpos_;
    save_pos(&curpos_);
    getAt( (ulong) newExeOffset + NE.IMPnamesTableOff + o, sizeof(i), &i);
    k = (char) fread( mName[m], 1, i, in);
    fwrite( mName[m], 1, i, out);
    mName[m][k] = 0;
    if ( m < 15 ) m++;
    iseek( curpos_ );
    }
    fp("\n");
    }
    if ( INtable != NULL )
    {   iseekNE( (ulong) NE.IMPnamesTableOff );
        fread( INtable, NE.EToffset - NE.IMPnamesTableOff, 1, in );}
    iseek( curpos );
}

void pNRnames(void)
{
    uchar i,j;
    uint k, ref;
    char *n;
    ulong old;
    save_pos(&old);
    fp("[Resident names table]\n\toffset\t%Xh\n",
    NE.RnamesTableOff );
    pNames( newExeOffset+(ulong)NE.RnamesTableOff);

    fp("[Non-resident names table]\n\toffset\t%lXh\tlength %Xh\n"\
	 "\tName\t\tIndex into Entry table\n",
         NE.NRtableOff, NE.NRtableLen );
    k=0;
    iseek( NE.NRtableOff);
    lo:
    if ((i=fgetc(in))==0) { iseek( old ); return;}

    n=nrName+k*33;
    if (i>32)
    {
        fp("  (>32) "); fileCopy( in, out, (ulong)i );
        goto pri;
    };

    if (( options & 32 ) == 0) oTab();
    j = (char) fread( n, 1, i, in);
    if (( options & 32 ) == 0) fwrite( n, 1, i, out);
    nrName[j+k*33] = 0;

    pri:
    fread( &ref, sizeof(ref), 1, in);
    if ((ref!=0)&&(k!=0)&&(i<=32)) entry[ref-1].name=k;

    if (( options & 32 )== 0) fp( "\t% 4d.\n", ref);
    else
    {
        fp( "%d\t", ref);
        if ( i<=32 ) fwrite( n, 1, i, out);
        fp( "\n" );
    };

    if (k<MaxNRnames-2) k++; else
    {
       fp("\t...skipped because more than %u names\n",
       MaxNRnames );
       iseek( old ); return;
    };
    goto lo;
}

void NE_flag( uint mask, uchar *str)
{
  if ((NE.MFW & mask) != 0) fp(str);
}

void PrintNewHeader(void)
{
   fp("\tLink version\t%d.%d\n", NE.linkVer, NE.linkRev );
   fp("\tLength of ET\t%d.\n\tImage chkSum\t%lXh\n",
      NE.ETlen, NE.IchkSum );
   fp("[Module flag word]\n\t%Xh\n", NE.MFW );
   if ((NE.MFW & 0x8000) != 0) // библиотека
   {
      fp("\tLibrary module\n");
      if ((NE.MFW & 0x0001) != 0) fp("\tSINGLEDATA\n");
      else fp("\tNOAUTODATA\n");
   }
   else
   {
      fp("\tProgram module\n");
      NE_flag( 0x0002, "\tMULTIPLEDATA\n");
   }
   // нет ноpмального стека ?
   NE_flag( 0x4000, "\tValid stack is not maintained\n");
   NE_flag( 0x0004, "\tRuns in real mode\n");
   NE_flag( 0x0008, "\tRuns in protected mode\n");

   fp("\t # of autoDATA seg's %d.\n", NE.autoDATAsegNum );
   fp("\tInit size of local heap/stack, + to autoDATA %d. / %d.\n",
        NE.isLocHEAP, NE.isStack );

   fp("Win program entry  %04X:%04X\nInit stack pointer %04X:%04X\n",
              NE.winCS, NE.winIP, NE.winSS, NE.winSP );
   fp("Alignment shift count (0 same as 9) %d.\n", NE.AlignSC );
   if (NE.os < 6 )
   fp("[Operating System]\n\t%s\n", osName[NE.os] );
   fp("[Expected Windows Version]\n\t%d.%d\n",
             NE.win_ver, NE.win_rev );


   pETable();

   INtable = NULL; // "imported names table" buffer
   INtable = malloc( NE.EToffset - NE.IMPnamesTableOff + 1 );

   pModuleName();
   pNRnames();
   pSegment();

   if (INtable != NULL ) free( INtable );

   if ( NE.RStableOff != NE.RnamesTableOff ) pResource();

}


uchar cstring[128];
// имя .DLL функции которой не следует включать в таблицу имен
extern int exclude_d;
extern char exclude_dll[ MAX_EX_DLL ][90];

// DumpPEImports gets import table from a PE format file (32-bit)
void DumpPEImports(void)
{
   uint i, hint;
   ulong off, entry, fixup;
   ulong o=0L;
   int exclude=0;
   next:
   getAt( Obj.RawOffset+o, sizeof(ImpDir), &ImpDir); // для первой из .DLL
   getAt( Obj.RawOffset-Obj.VirtAddr+ImpDir.Name, sizeof(cstring), cstring);
   if ( ImpDir.Name==0L ) return; // найдено NULL entry

   fp("%s\n", cstring );
   exclude=0;
   for ( i=0; i< exclude_d; i++ ) // по всем строкам списка
   {
      if (!stricmp(cstring, exclude_dll[i] ))
      {
        fp("Warning: the proc names aren't to be collected.\n");
        exclude=1;
        break;
      }
   }
   fp("addr\tname\tlookup\n");
   fp("%08lX %08lX %08lX\n",
       ImpDir.impAdr, // addr table RVA
       ImpDir.Name, // relative virtual adr of name of .DLL
       ImpDir.impLookup); // lookup table RVA
   fp("%08lX %08lX %08lX (disk offset's)\n",
       Obj.RawOffset-Obj.VirtAddr+ImpDir.impAdr, // addr table RVA
       Obj.RawOffset-Obj.VirtAddr+ImpDir.Name, // relative virtual adr of name
       Obj.RawOffset-Obj.VirtAddr+ImpDir.impLookup); // lookup table RVA

   // адрес импортируемой процедуры в загруженном в память имидже
   fixup=ImpDir.impLookup+PE.ImageBase;

   if ( ImpDir.impAdr )
   {
      // смещение в файле до таблицы смещений
      off=Obj.RawOffset-Obj.VirtAddr+ImpDir.impAdr;
   } else off=Obj.RawOffset-Obj.VirtAddr+ImpDir.impLookup;

   // каждый элемент таблицы (long) entry является указателем
   // на строку-имя импортируемой функции
   getAt( off, sizeof(entry), &entry); // возьмем эл-т таблицы
   while ( entry )
   {
      if ( entry & 0x80000000L ) // задано не именем (строкой), а числом
      {
	 hint=0;
	 sprintf( cstring, "%lXh", entry & (~0x80000000L));
      }
      else
      {
	 getAt( Obj.RawOffset-Obj.VirtAddr+entry, sizeof(hint), &hint);
	 getAt( Obj.RawOffset-Obj.VirtAddr+entry+2, sizeof(cstring), cstring);
      }
      fp("\t[%08lX] %-32s \t(%04X)\n", fixup, cstring, hint );
      if ( minImpAdr > fixup ) minImpAdr = fixup;
      if ( maxImpAdr < fixup ) maxImpAdr = fixup;

      if (!exclude)
      add_imp_tbl( fixup, cstring ); // запомним для ссылок из .ASM
      off+=4; // следующий
      fixup+=4;
      getAt( off, sizeof(entry), &entry); // возьмем эл-т таблицы
   }
   fp("\n");
   o += sizeof(ImpDir);
   if ( ImpDir.Name ) goto next;
}

// DumpPEImports gets import table from a PE format file (32-bit)
void DumpPEImports2(long raw_o)
{
   uint i, hint;
   ulong off, entry, fixup;
   ulong o=0L;
   int exclude=0;
   next:
   getAt( raw_o +o, sizeof(ImpDir), &ImpDir); // для первой из .DLL
   getAt( rva_offset( ImpDir.Name ), sizeof(cstring), cstring);
   if ( ImpDir.Name==0L ) return; // найдено NULL entry

   fp("%s\n", cstring );
   exclude=0;
   for ( i=0; i< exclude_d; i++ ) // по всем строкам списка
   {
      if (!stricmp(cstring, exclude_dll[i] ))
      {
        fp("Warning: the proc names aren't to be collected.\n");
        exclude=1;
        break;
      }
   }
   fp("addr\tname\tlookup\n");
   fp("%08lX %08lX %08lX\n",
       ImpDir.impAdr, // addr table RVA
       ImpDir.Name, // relative virtual adr of name of .DLL
       ImpDir.impLookup); // lookup table RVA

   // адрес импортируемой процедуры в загруженном в память имидже
   fixup=ImpDir.impLookup+PE.ImageBase;

   if ( ImpDir.impAdr )
   {
      // смещение в файле до таблицы смещений
      off= rva_offset( ImpDir.impAdr );
   } else off= rva_offset( ImpDir.impLookup );

   // каждый элемент таблицы (long) entry является указателем
   // на строку-имя импортируемой функции
   getAt( off, sizeof(entry), &entry); // возьмем эл-т таблицы
   while ( entry )
   {
      if ( entry & 0x80000000L ) // задано не именем (строкой), а числом
      {
	 hint=0;
	 sprintf( cstring, "%lXh", entry & (~0x80000000L));
      }
      else
      {
         getAt( rva_offset( entry ), sizeof(hint), &hint);
         getAt( rva_offset( entry )+2, sizeof(cstring), cstring);
      }
      fp("\t[%08lX] %-32s \t(%04X)\n", fixup, cstring, hint );
      if ( minImpAdr > fixup ) minImpAdr = fixup;
      if ( maxImpAdr < fixup ) maxImpAdr = fixup;

      if (!exclude)
      add_imp_tbl( fixup, cstring ); // запомним для ссылок из .ASM
      off+=4; // следующий
      fixup+=4;
      getAt( off, sizeof(entry), &entry); // возьмем эл-т таблицы
   }
   fp("\n");
   o += sizeof(ImpDir);
   if ( ImpDir.Name ) goto next;
}

int export32_done=0; // признак, что обработка была выполнена
// DumpPEexports gets export table from a PE format file (32-bit)
void DumpPEExports(void)
{
    ulong   RawOffset, VirtAddr, NumNames, Names, Ordinals, Base;
    ulong   fn; // RVA таблицы смещений (адресов) точек входа
    ulong   eaddr;
    uint j;

    uint  icon, treelevel, ordinal;
   uint ushortval;
   ulong ulongval;

   export32_done=1;
   RawOffset = Obj.RawOffset;
   VirtAddr = Obj.VirtAddr;
   getAt( RawOffset, sizeof(ExpDir), &ExpDir);
   NumNames = ExpDir.NumNames;
   Names    = ExpDir.AddrNames;
   fn       = ExpDir.AddrFuncs;
   Ordinals = ExpDir.AddrOrds;
   Base     = ExpDir.Base;
   getAt( RawOffset-VirtAddr+ExpDir.Name, sizeof(cstring), cstring);
   treelevel = 1;
   icon = 1;
   ordinal = 0;
   fp( "%s %u %u %u\n", cstring, treelevel, icon, ordinal);
   treelevel = 2;
   icon = 0;
   for (j = 0; j<NumNames; j++ )
   {
      getAt( RawOffset-VirtAddr+Names+j*4, 4,&ulongval);
      getAt( RawOffset-VirtAddr+ulongval, sizeof(cstring), cstring);
      getAt( RawOffset-VirtAddr+Ordinals+j*2, 2, &ushortval);
      ordinal = ushortval+Base;
      getAt( RawOffset-VirtAddr+fn+ushortval*4, 4, &eaddr);
      fp( "%-35s %4u %4u %4u 0x%08lX\n",
          cstring, treelevel, icon, ordinal, eaddr);
      add_exp_tbl( eaddr, cstring );
   }
}

void DumpPEExports2(long ofs)
{
    struct
    {
       ulong a,b,c, dllName, ordBase, byNum, byName;
    } ExpDir;

    ulong   RawOffset, VirtAddr, NumNames, Names, Ordinals, Base;
    ulong   eaddr;
    uint j;

    uint  icon, treelevel, ordinal, ushortval;
   ulong ulongval;

   export32_done=1;
   RawOffset = ofs;
   VirtAddr = 0x1400;

   getAt( ofs, sizeof(ExpDir), &ExpDir);
   getAt( RawOffset-VirtAddr*2+ExpDir.dllName, sizeof(cstring), cstring);
   fp("Exports from %s:\n", cstring );

   printf("%lX %lX %lX %lX %lX %lX %lX\n",
       ExpDir.a,ExpDir.b,ExpDir.c, ExpDir.dllName,ExpDir.ordBase,
       ExpDir.byNum, ExpDir.byName );
      // bioskey(0);
       return;

   for (j = 0; j<ExpDir.byName; j++ )
   {
      getAt( RawOffset-VirtAddr+ExpDir.dllName+j*4, 4,&ulongval);
      getAt( RawOffset-VirtAddr+ulongval, sizeof(cstring), cstring);
    //  getAt( RawOffset-VirtAddr+Ordinals+j*2, 2, &ushortval);
    //  ordinal = ushortval+Base;
    //  getAt( RawOffset-VirtAddr+fn+ushortval*4, 4, &eaddr);
      fp( "%-35s %4u %4u %4u 0x%08lX\n",
          cstring, treelevel, icon, ordinal, eaddr);
      add_exp_tbl( eaddr, cstring );
   }
}

uchar *PE_cpu_name(void)
{
   switch ( PE.CPU )
   {
        case 0x14C: return "80386";
        case 0x14D: return "80486";
        case 0x14E: return "80586";
        case 0x162: return "MIPS Mark I (R2000, R3000)";
        case 0x163: return "MIPS Mark II (R6000)";
        case 0x166: return "MIPS Mark III (R4000)";
   }
   return "unknown";
}

uchar *PE_sys_name(void)
{
   switch ( PE.subsystem )
   {
        case 0x1: return "native";
        case 0x2: return "Windows GUI";
        case 0x3: return "Windows Character";
        case 0x5: return "OS/2 Character";
        case 0x7: return "Posix Character";
   }
   return "unknown";
}

void PE_image_flags(void)
{
   if ( PE.flags & 0x2 ) fp("[Flags]\n\tExecutable\n");
   else fp("[Flags]\n\tThere was linker Error(s)\n");
   if ( PE.flags & 0x200 ) fp("\tFixed (Load only at ImageBase)\n");
   if ( PE.flags & 0x2000 ) fp("\tLibrary image\n");
}

uint seg_class; // класс сегмента 32-бит образа
uint PE_obj_flags(void)
{
   seg_class=0;
   if ( Obj.flags & 0x20L ) { fp("\t\tCode\n"); seg_class=1; }
   if ( Obj.flags & 0x40L ) fp("\t\tInitData\n");
   if ( Obj.flags & 0x80L ) fp("\t\tUninitData\n");
   if ( Obj.flags & 0x40000000L ) fp("\t\tObj must not be cached\n");
   if ( Obj.flags & 0x80000000L ) fp("\t\tObj is not pageable\n");
   if ( Obj.flags & 0x100000000L ) fp("\t\tObj is shared\n");
   if ( Obj.flags & 0x200000000L ) fp("\t\tExecutable\n");
   if ( Obj.flags & 0x400000000L ) fp("\t\tReadable\n");
   if ( Obj.flags & 0x800000000L ) fp("\t\tWriteable\n");
   return seg_class;
}

typedef struct
{
   ulong flag, timestamp;
   uint  major, minor;
   uint Names, IDs;
} resourceDirTable; // only for PE

resourceDirTable PEdir, PEdir1; // для корня и первого подуровня

typedef struct
{
   ulong ID; // name RVA or integer ID of resource
   ulong entry; // data entry RVA or subdir RVA
} resourceDirEntry; // only for PE

typedef struct
{
   ulong rva;
   ulong size;
   ulong codepage;
   ulong reserved;
} resDataEntry; // лист дерева ресурсов PE формата

int dir_level=0;
void rc_tab(void)
{
    int i;
    for ( i=0; i<dir_level; i++ )
    {
       fp("    ");
    }
}

char PE_resType;
// выводит данные одного "листа" дерева ресурсов
// иногда использует ID предыдущего (parent) узла дерева
void list_data(ulong off, ulong prev_id )
{
   ulong curpos, at_file;
   int s, o, idx;
   resDataEntry d;
   char res_name[20];
   save_pos(&curpos);
   getAt( (ulong)Obj.RawOffset+off, sizeof(d), &d);
   at_file=d.rva-Obj.VirtAddr+Obj.RawOffset;
   rc_tab();

   // RVA %08lX
   fp("(%lX at file), size %08lX, codepage %lX %lX\n",
       /* d.rva, */ at_file, d.size, d.codepage, d.reserved);
   if (options & 2) // извлекать ресурсы
   {
      if ( PE_resType==3 ) putICON( at_file );            // ICON
      else
      {
	 sprintf(res_name,"%08lX.rec", at_file);
	 seg2file( at_file, d.size, res_name);
      };
   };
   if ( PE_resType==5 ) putDLG32( at_file );            // DIALOG
   if ( PE_resType==6 )                                 // Unicode string
   {
      s=0;
      idx=(long)((prev_id-1)<<4);
      a:
      rc_tab(); fp("%X, ", idx++ );
      o=pString32(at_file+s); s += o; fp("\n");

      add_resource_string( idx-1, pString32buf ); // поместим в список строк

      if ( d.size> s ) goto a;
   }
   iseek(curpos);
}

char *PE_res_type[]=
{
   "RT_CURSOR",
   "RT_BITMAP",
   "RT_ICON",
   "RT_MENU",
   "RT_DIALOG",
   "RT_STRING",
   "RT_FONTDIR",
   "RT_FONT",
   "RT_ACCELERATOR",
   "RT_RCDATA",
   "RT_MESSAGETABLE",
   "RT_GROUP_CURSOR",
   "unkn. 13",
   "RT_GROUP_ICON",
   "unkn. 15",
   "RT_VERSION",
   "RT_DLGINCLUDE"
};

char *PE_res_type2[]=
{
   "RT_BITMAPEX",
   "??",
   "RT_MENUEX",
   "RT_DIALOGEX"
};

void pe32_rcname( ulong id )
{
   if ( id<18 ) fp("%s\n", PE_res_type[id-1] );
   else
   if (( id & (~0x2000)) < 6 ) fp("%s\n", PE_res_type2[id-2] );
   PE_resType=id; // тип ресурса, для правильного вывода в файл
}

// RECURSIVE !!!!!!!!
void list_rc(ulong off, ulong oID)
{
   int i;
   ulong curpos;
   resourceDirTable PEdir;
   resourceDirEntry de; // указатель на данные или подкаталог ресурсов
   save_pos(&curpos);
   // подкаталог первого уровня
   getAt( (ulong)Obj.RawOffset+(off & 0x7FFFFFFFL),
	  sizeof(PEdir), &PEdir );
   rc_tab();
   fp("listed by name %d, by ID %d\n",
       PEdir.Names, PEdir.IDs );


   for ( i=0; i<PEdir.Names; i++ ) // читаем все элементы каталога по именам
   {
       fread( &de, 1, sizeof(de), in );
       if ( dir_level==0 && de.ID!=0) pe32_rcname( de.ID ); rc_tab();
       fp("id=%lXh (%lu), entry=%lXh\n", de.ID, de.ID, de.entry );
       if ( de.entry & 0x80000000L )
       {
          dir_level++; list_rc(de.entry, de.ID); dir_level--;
       }
       else list_data(de.entry, oID);
   }
   for ( i=0; i<PEdir.IDs; i++ ) // читаем все элементы каталога по номерам
   {
       fread( &de, 1, sizeof(de), in );
       if ( dir_level==0 && de.ID!=0) pe32_rcname( de.ID ); rc_tab();
       fp("id=%lXh (%lu), entry=%lXh\n", de.ID, de.ID, de.entry );
       if ( de.entry & 0x80000000L )
       {
          dir_level++; list_rc(de.entry, de.ID); dir_level--;
       }
       else list_data(de.entry, oID);
   }
   iseek(curpos);
}


typedef struct
{
   unsigned short   f_magic;  /* magic number */
   unsigned short   f_nscns;  /* number of section */
   long             f_timdat; /* time and date stamp */
   long             f_symptr; /* file ptr to symbol table */
   long             f_nsyms;  /* number entries in the symbol table */
   unsigned short   f_opthdr; /* size of optional header */
   unsigned short   f_flags;  /* flags */
} coff_filehdr;

coff_filehdr cofhdr;

#define F_RELFLG     0x0001  /* Relocation information stripped from the file */
#define F_EXEC       0x0002  /* File is executable (i.e., no unresolved external references) */
#define F_LNNO       0x0004  /* Line numbers stripped from the file */
#define F_LSYMS      0x0008  /* Local symbols stripped from the file */
#define F_AR16WR     0x0080  /* 16-bit byte reversed word */
#define F_AR32WR     0x0100  /* 32-bit byte reversed word */

#define	I386MAGIC	0x14c
#define I386AIXMAGIC	0x175

typedef struct
{
  unsigned short 	magic;		/* type of file				*/
  unsigned short	vstamp;		/* version stamp			*/
  unsigned long	tsize;		/* text size in bytes, padded to FW bdry*/
  unsigned long	dsize;		/* initialized data "  "		*/
  unsigned long	bsize;		/* uninitialized data "   "		*/
  unsigned long	entry;		/* entry pt.				*/
  unsigned long 	text_start;	/* base of text used for this file */
  unsigned long 	data_start;	/* base of data used for this file */
} AOUTHDR;

AOUTHDR aouthdr;


/*  s_flags:
 STYP_REG       0x00   Regular section (allocated,
                       relocated, loaded)
 STYP_DSECT     0x01   Dummy section (not allocated,
                       relocated, not loaded)
 STYP_NOLOAD    0x02   Noload section (allocated,
                       relocated, not loaded)
 STYP_GROUP     0x04   Grouped section (formed from
                       input sections)
 STYP_PAD       0x08   Padding section (not
                       allocated, not relocated,
                       loaded)
 STYP_COPY      0x10   Copy section (for a decision
                       function used in updating
                       fields; not allocated, not
                       relocated, loaded, relocation
                       and line number entries
                       processed normally)
 STYP_TEXT      0x20   Section contains executable
                       text
 STYP_DATA      0x40   Section contains initialized
                       data
 STYP_BSS       0x80   Section contains only
                       uninitialized data
 STYP_INFO     0x200   Comment section (not
                       allocated, not relocated, not
                       loaded)
 STYP_OVER     0x400   Overlay section (relocated,
                       not allocated, not loaded)
 STYP_LIB      0x800   For .lib section (treated like
                       STYP_INFO)    */

typedef struct {
   char     s_name[8];      /* section name                 */
   ulong    s_paddr;        /* physical address, aliased s_nlib */
   ulong    s_vaddr;        /* virtual address              */
   ulong    s_size;         /* section size                 */
   ulong    s_scnptr;       /* file ptr to raw data for section */
   ulong    s_relptr;       /* file ptr to relocation       */
   ulong    s_lnnoptr;      /* file ptr to line numbers     */
   ushort   s_nreloc;       /* number of relocation entries */
   ushort   s_nlnno;        /* number of line number entries*/
   ulong    s_flags;        /* flags                        */
} coff_scnhdr;

coff_scnhdr coff_s;

uchar name[128];
void far pascal INIT32(void);
char RCdataName[12]=".rsrc";
char DATAdataName[12]="DATA";

// loads the Win16 name's definition file
// ; remark
// [module_name]
// 12 MyProcName1
// 35 MyProcName2
void load_explain(char *fname);

void main(int argc, char *argv[])    // входные паpаметpы
{
	char far *pnam;
	int pnameLen, s, tiH, tiL;


	int eseg = peek( _psp, 0x002C ); pname = MK_FP( eseg, 0 );

	tiL = peek( 0, 0x046C );
	tiH = peek( 0, 0x046E );

        strcpy(progname, argv[0] );

	x.code_base = 0;
	x.segAdd    = 0;

	scan:
	while (*pname++ != 0) ;
	if (*pname != 0) goto scan;

	pname += 3;
	sprintf( pathName, "%s", pname );
	pnam = pname = pathName;

	pnameLen = strlen( pname );
	pnam += pnameLen;

	while (( pname != pnam ) && ( *pnam != 0x5C )) pnam-- ;
	pnam++; *pnam = 0;

    if (argc < 2)
    {
       printf("\nDeWin: dump for MS Windows executable ('NE' & 'PE' type) and COFF .obj\n"
              "\tver. %s  (c) 1995-98 Milukov A.V. АО \'Царицыно\'\n", __DATE__);
       printf("usage: DeWin [-options] Infile.exe [Outfile]\n\n"
        "options: -1 one pass, don't make .asm (.sea only)\n"
        "\t-2 force two-pass mode (postprocessing macros)\n"
        "\t-a autodetect standard BC++ or TP runtime code, save to autodet.txt\n"
        "\t-d always disable .asm code creating\n"
        "\t-b extract bitmaps, icons, cursor & binary PE resrc\n"
        "\t-c don't delete .seg file(s) contain CODE segment\n"
        "\t-e write [Resident Names Table] in Explain format\n"
        "\t-i use old method of .idata (IMPORT) processing\n"
        "\t-m don't put menu & dialog source into [Outfile]\n"
        "\t-o don't put disk file offset(s) for proc entries\n"
        "\t-p disable PASCAL-style strings-in-code search (Delphi etc.)\n"
        "\t-r don't process relocations table(s), debug purpose\n"
        "\t-t disable 1250 Code Page string conversion\n"
        "\t-v verbose code bytes, debug purpose\n"
        "Example: DeWin -tbd calendar.exe calendar.def\n"
        "\tCreates an header-info file calendar.def\n"
        "\tprevent string resource changes in it\n"
        "\tand extract all DIB images from .exe\n");
        exit(1);
    }

    s = 0;
    options = 0;
    if ( argv[1][0] == 0x2D ) // -x means option 'x'
    {
        s = 1;
        if ( strchr( argv[1], '1')) options |= 256; // -1 one pass
        if ( strchr( argv[1], '2')) options |=4096; // -2 force post-processing
        if ( strchr( argv[1], 'a')) options |=2048; // -a enable autodetect RTL
        if ( strchr( argv[1], 'd')) options |=   1; // -d disable code dizasm
        if ( strchr( argv[1], 'b')) options |=   2; // -b extract bitmaps
        if ( strchr( argv[1], 'c')) options |=   4; // -c don't delete code seg
        if ( strchr( argv[1], 'e')) options |=  32; // -e resident names in .ex fmt
        if ( strchr( argv[1], 'i')) options |=8192; // -i use old .idata method
        if ( strchr( argv[1], 'm')) options |=  16; // -m don't put menu
        if ( strchr( argv[1], 'o')) options |= 128; // -o don't disk offsets
        if ( strchr( argv[1], 'p')) options |=1024; // -p no Pascal strings
        if ( strchr( argv[1], 'r')) options |=   8; // -r don't relocations
        if ( strchr( argv[1], 't')) options |=  64; // -t don't xlat russian
        if ( strchr( argv[1], 'v')) options |= 512; // -v verbose code bytes
    }

   if (( nrName = calloc( MaxNRnames, 33)) == NULL)
   {
      printf( "calloc() for Names Table failure\n");
      exit(1);
   };

    ChkName(argv[1+s]); // open main application file, pname->extension
    sprintf( pname, ".def" ); // default output filename
    if ((out = fopen(argv[2+s], "wt")) == NULL) // if no output name given
    if ((out = fopen(argv[1+s], "wt")) == NULL) // and default not open'd
         out = stdout;                          // then put to screen

    sprintf( pname, ".udf"); // custom userdef (.udf) file
    strcpy( cuserdef, argv[1+s] );
    sprintf( pname, ".lkp"); // custom lookup (.lkp) file
    strcpy( lkp_filename, argv[1+s] );
    sprintf( pname, ".def" ); // default output filename
            
    len = flen( in );
    app_file_size = len; // длина файла приложения на диске

   fread( &o, sizeof(o), 1, in);    // считать заголовок

   if ((o.sign[0] != 'M') || (o.sign[1] != 'Z'))
   {
        int i;
        fseek(in,0,0);
        fread( &cofhdr, sizeof(cofhdr), 1, in);
        if ( cofhdr.f_magic == I386MAGIC )
        {
           if (!load_userdef(cuserdef))
           load_userdef("userdef.txt"); // get if exist in current dir
           flag32=1;
           INIT32(); // включим альтернативный дизассемблер

           fp("COFF file header:\nf_magic=0x%04X\n"
              "f_nscns=0x%04X\nf_timdat=0x%08lX\n"
              "f_symptr=0x%08lX\nf_nsyms=0x%08lX\n"
              "f_opthdr=0x%04X\nf_flags=0x%04X\n",
              cofhdr.f_magic,
	      cofhdr.f_nscns, cofhdr.f_timdat, cofhdr.f_symptr,
	      cofhdr.f_nsyms, cofhdr.f_opthdr, cofhdr.f_flags );
           if ( cofhdr.f_opthdr == sizeof(aouthdr))
           {
              fread( &aouthdr, sizeof(aouthdr), 1, in);
              fp("AOUT header:\nmagic=0x%04X\nvstamp=0x%04X\n",
                  aouthdr.magic, aouthdr.vstamp );
           }
	   else if ( cofhdr.f_opthdr ) fp("Unknown optional header found\n");

           x.code_base = 0; // смещение всех адресов дизассемблера

           if (( tree = malloc(( MAX_TREE+2)*4 )) == NULL)
           { printf("Tree not malloc()ed\n"); exit(1); }

           for ( i=0; i<cofhdr.f_nscns; i++ )
           {
              fread( &coff_s, sizeof(coff_s), 1, in);
              fp("\nSection %s\ns_paddr=0x%08lX\n"
                 "s_vaddr=0x%08lX\ns_size=0x%08lX\n"
                 "s_scnptr=0x%08lX\ns_relptr=0x%08lX\n"
                 "s_lnnoptr=0x%08lX\ns_nreloc=0x%04X\n"
		 "s_nlnno=0x%04X\ns_flags=0x%08lX\n",
                 coff_s.s_name, coff_s.s_paddr, coff_s.s_vaddr,
                 coff_s.s_size, coff_s.s_scnptr, coff_s.s_relptr,
                 coff_s.s_lnnoptr, coff_s.s_nreloc,
                 coff_s.s_nlnno, coff_s.s_flags );
              if (( coff_s.s_flags & 0x20 )==0) // есть флажок 'CODE' ?
              continue;

              PE.ImageBase = 0;
              Obj.VirtAddr  = coff_s.s_vaddr;
              Obj.RawSize   = coff_s.s_size;
              Obj.RawOffset = coff_s.s_scnptr;

              sprintf( name, "%04d.seg", i);

              x.code_base= /* PE.ImageBase + */ Obj.VirtAddr;
              c_RVA=Obj.VirtAddr;
              relocINIT();
              if (( options & 1)==0 ) // -d disable
              {
                 seg2file( Obj.RawOffset, Obj.RawSize, name);
                 FileOffset=Obj.RawOffset;
                 processSEG( name, i );   // create .sea
                 printf("%s created\n",name);
              }

           }
        }
        fp("Not found 'MZ'\n");
        fclose(in); fclose(out);
        exit(1);
   }

   if (!coff) PrintOldHeader();

   getAt( (ulong) 0x3c , sizeof( newExeOffset ), &newExeOffset );

    if ( options & 2048 ) // autodetect runtime
    {
        strcpy( pnam, "dewin.rtl" );
        load_cfg(pathName); // описания стандартных процедур
    }

   if ( newExeOffset != 0L )
   {
   fp( "[NewExe header]\n\tfound at:\t%08lXh\n", newExeOffset );
   if (!getAt( newExeOffset , sizeof( NE ), &NE ))
   {
      fp("ERROR: bad or illegal NewEXE header offset\n");
      exit(1);
   }

   if ( *((int *)NE.sign)==0x4550 ) // PE signature
   {

       int i;
       if (!load_userdef(cuserdef))
       load_userdef("userdef.txt"); // get if exist in current dir

       flag32=1;
       INIT32(); // включим альтернативный дизассемблер
       fp( "'PE' signature found (flat 32-bit executable)\n");
       getAt( newExeOffset , sizeof( PE ), &PE );
       fp("CPU type %s\n", PE_cpu_name());
       PE_image_flags();
       fp("Linker %u.%u\n", PE.lmajor, PE.lminor );
       fp("Program Entry point %8lXh from Base\n"
          "Image base          %8lXh\n"
          "Object align        %8lXh\n"
          "File   align        %8lXh\n",
         PE.EntryPoint, PE.ImageBase, PE.ObjAlign, PE.FileAlign);

       fp("OS version %u.%u\nUser version %u.%u\n",
           PE.OSmajor, PE.OSminor, PE.USERmajor, PE.USERminor );

       fp("Subsystem version %u.%u type '%s'\n",
           PE.SUBmajor, PE.SUBminor, PE_sys_name());

       fp("Interesting RVA's %ld\n", PE.Interest );

       fp("  Export      %8lX %8lX\n", PE.ddir[DIR_E_EXPORT      ].rva, PE.ddir[DIR_E_EXPORT      ].size);
       fp("  Import      %8lX %8lX\n", PE.ddir[DIR_E_IMPORT      ].rva, PE.ddir[DIR_E_IMPORT      ].size);
       fp("  Resurs      %8lX %8lX\n", PE.ddir[DIR_E_RESOURCE    ].rva, PE.ddir[DIR_E_RESOURCE    ].size);
       fp("  Except      %8lX %8lX\n", PE.ddir[DIR_E_EXCEPTION   ].rva, PE.ddir[DIR_E_EXCEPTION   ].size);
       fp("  Secure      %8lX %8lX\n", PE.ddir[DIR_E_SECURITY    ].rva, PE.ddir[DIR_E_SECURITY    ].size);
       fp("  Fixup       %8lX %8lX\n", PE.ddir[DIR_E_BASERELOC   ].rva, PE.ddir[DIR_E_BASERELOC   ].size);
       fp("  Debug       %8lX %8lX\n", PE.ddir[DIR_E_DEBUG       ].rva, PE.ddir[DIR_E_DEBUG       ].size);
       fp("  ImageDesc   %8lX %8lX\n", PE.ddir[DIR_E_COPYRIGHT   ].rva, PE.ddir[DIR_E_COPYRIGHT   ].size);
       fp("  MachineSpec %8lX %8lX\n", PE.ddir[DIR_E_GLOBALPTR   ].rva, PE.ddir[DIR_E_GLOBALPTR   ].size);
       fp("  ThreadLS    %8lX %8lX\n", PE.ddir[DIR_E_TLS         ].rva, PE.ddir[DIR_E_TLS         ].size);
       fp("  LoadConfig  %8lX %8lX\n", PE.ddir[DIR_E_LOAD_CONFIG ].rva, PE.ddir[DIR_E_LOAD_CONFIG ].size);
       fp("  BoundImport %8lX %8lX\n", PE.ddir[DIR_E_BOUND_IMPORT].rva, PE.ddir[DIR_E_BOUND_IMPORT].size);
       fp("  IAT         %8lX %8lX\n", PE.ddir[DIR_E_IAT         ].rva, PE.ddir[DIR_E_IAT         ].size);

       fp("\n");

       x.code_base = PE.ImageBase; // смещение всех адресов

       if (( tree = malloc(( MAX_TREE+2)*4 )) == NULL)
       { printf("Tree not malloc()ed\n"); exit(1); }

       fp("Pass #1: building the Object Information table\n");
       objheaders = PE.optsize+newExeOffset+PE_size;
       fp("Name\tVSize\tVAddr\tRawSize\tRawOffs\tflag\n");

       // read all the PE sections
       getAt( objheaders , sizeof( Obj )*16, &sec[0] );

       if (( options & 8192 )==0 )
       if ( DirectoryOffset( DIR_E_IMPORT, &i ) > -1)
       {
          memcpy( &Obj, &sec[i], sizeof( Obj ));
          DumpPEImports2(DirectoryOffset( DIR_E_IMPORT, &i ));
       }

       for (s=0; s<PE.obj; s++) // for all object's of image
       {
	 getAt( objheaders , sizeof( Obj ), &Obj );
	 objheaders += sizeof(Obj);
	 fp("%s\t%lX\t%lX\t%lX\t%lX\t%lX\n",
	 //\t%lX\t%lX\t%X\t%X
	 Obj.ObjName,
	 Obj.VirtSize,
	 Obj.VirtAddr,
	 Obj.RawSize,
	 Obj.RawOffset,
     //    Obj.Reloc,
     //    Obj.LineNum,
     //    Obj.RelCount,
     //    Obj.LineCount,
	 Obj.flags);
	 seg_class=PE_obj_flags(); sprintf( name, "%04d.seg", (int)s);

         if (!strcmp(Obj.ObjName,".edata")) DumpPEExports();
         if (!strcmp(Obj.ObjName,".idata"))
         if ( options & 8192 ) DumpPEImports();
         if (!strcmp(Obj.ObjName, RCdataName))
         {
           // прочитаем корневой заголовок ресурсов
           dir_level=0;
           list_rc(0,0);
         }
         if (!strcmp(Obj.ObjName,DATAdataName) ||
             (!strcmp(Obj.ObjName,".data") && Obj.flags==0xC0000040L ))
         {
	    seg2file( Obj.RawOffset, Obj.RawSize, name);
            if ((dseg=load_dseg(name,40*1024L))!=NULL)
            {
               printf("[DATA] or [.data] object '%s' preloaded Ok\n",name);
               unlink( name );
            }
            dataObj = Obj.VirtAddr+PE.ImageBase; // где начало в памяти
            dataObjEnd = Obj.VirtSize+dataObj;
         }
         if (!strcmp(Obj.ObjName,".rdata"))
         {
	    seg2file( Obj.RawOffset, Obj.RawSize, name);
            if ((rdseg=load_dseg(name,40*1024L))!=NULL)
            {
               printf("[.rdata] object '%s' preloaded Ok\n",name);
               unlink( name );
            }
            rdataObj = Obj.VirtAddr+PE.ImageBase; // где начало в памяти
            rdataObjEnd = Obj.VirtSize+rdataObj;
         }
       };

       if ( !export32_done ) // если в перечне обьектов не было .edata
       {
	  DumpPEExports2(PE.ddir[DIR_E_EXPORT].rva);
       }

       fp("\nPass #2: processing Code Segment\n");
       objheaders = PE.optsize+newExeOffset+PE_size;
       fp("Name\tVSize\tVAddr\tRawSize\tRawOffs\tflag\n");
       for (s=0; s<PE.obj; s++) // for all object's of image
       {
	 getAt( objheaders , sizeof( Obj ), &Obj );
	 objheaders += sizeof(Obj);

	 if ( Obj.flags & 0x20L ) // есть флажок 'CODE'
	 {
	    fp("%s\t%lX\t%lX\t%lX\t%lX\t%lX\n",
	    //\t%lX\t%lX\t%X\t%X
	    Obj.ObjName,    Obj.VirtSize,
	    Obj.VirtAddr,    Obj.RawSize,
	    Obj.RawOffset,
	//    Obj.Reloc,
	//    Obj.LineNum,
	//    Obj.RelCount,
	//    Obj.LineCount,
	    Obj.flags);
	    seg_class=PE_obj_flags();

	    sprintf( name, "%04d.seg", (int)s);

            x.code_base=PE.ImageBase + Obj.VirtAddr;
            c_RVA=Obj.VirtAddr;
	    relocINIT();
            if (( options & 1)==0 ) // -d disable
            {
               seg2file( Obj.RawOffset, Obj.RawSize, name);
               FileOffset=Obj.RawOffset;
               processSEG( name, (int)s );   // create .sea
               printf("%s created\n",name);
            }
	 }
       };
       fclose(in); fclose(out);
       if ( options & 2048 ) // autodetect runtime
           unload_cfg(); // описания стандартных процедур
       if ( out_auto ) fclose(out_auto);
       exit(0);
   };

   strcpy( pnam, "win16dll.ex" );
   load_explain( pathName );

   if (( tree = malloc(( MAX_TREE+2)*4 )) == NULL)
   { printf("Tree not malloc()ed\n"); exit(1); }

   if (!load_userdef(cuserdef))
   load_userdef("userdef.txt"); // get if exist in current dir

   Lshift = 1<<NE.AlignSC;
   PrintNewHeader();
   free(tree);
   };

   fclose(in); fclose(out);
   if ( out_auto ) fclose(out_auto);
   free( nrName );
   if ( dseg ) farfree(dseg);
   if ( options & 2048 ) // autodetect runtime
       unload_cfg(); // описания стандартных процедур

        asm mov ax,[tiL]
        asm mov dx,[tiH]
	asm push ax
	asm push dx
        tiL = peek( 0, 0x046C );
        tiH = peek( 0, 0x046E );
	asm pop dx
	asm pop ax
        asm sub [tiL],ax
        asm sbb [tiH],dx

        len = (ulong)tiL+((ulong)tiH << 16L);
	newExeOffset = len/1092;
	s = (len-newExeOffset*1092L)/18;
	printf("Elapsed time %d:%02d\n", (int)newExeOffset, s );

   exit(0);
}
