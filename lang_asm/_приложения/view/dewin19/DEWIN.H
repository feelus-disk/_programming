
typedef  unsigned int   uint;
typedef  unsigned short ushort;
typedef  unsigned long  ulong;
typedef  unsigned char  uchar;

   typedef struct {
	char sign[2];		// MZ
    int  pPage, totalPages;    // всего стpаниц в обpазе
	int  rCount;		// элементов в таблице ссылок
	int  hSize;		// pазмеp заголовка в 16-байтн. $
    int  minMemory, maxMemory;
    int  SSoffset, SPoffset;
    uint  chkSum, IP, CS, RitemOffset, ovlNumber;
    } EXEo;

   typedef struct {
	char sign[2];		// NE
    unsigned char linkVer, linkRev;  // веpсия LINK, revision of LINK
    uint  EToffset, ETlen;      // EntryTable offset & len from NewEXE
        ulong IchkSum;  // image chksum
	int  MFW;		// module flag word
	int  autoDATAsegNum;	// number of autoDATA seg's
	int  isLocHEAP;		// init size of local heap, added to autoDATA
	int  isStack;		// init size of stack, added to autoDATA
    int  winIP, winCS, winSP, winSS;
	int  SEGtableEnt;	// number of entries in segment table
	int  MODrefEnt;		// number of entries in module reference tbl
	int  NRtableLen;	// non-resident names table length
       uint  SEGtableOff;       // segment table offset from new exe
       uint  RStableOff;        // resource table offset
       uint  RnamesTableOff;    // offset of resident names table
       uint  MODrefOff;         // module ref table offset
       uint  IMPnamesTableOff;  // imported names table offset
        ulong  NRtableOff;      // non-resident names table offset
					// from file begin
	int  MEPcount;		// movable entry point counter
	int  AlignSC;		// alignment shift count (0 same as 9)
    char reserv[2], os, reserv_[7], win_rev, win_ver;
        } NEWheader;


// is used for the description of last part of PE .EXE header
typedef struct
{
   ulong rva, size;
} DATA_DIR;

  typedef struct {
        ulong signature; // 'PE',0,0
        uint  CPU; // тип процессора
        uint  obj; // количество секций (обьектов) в image
        ulong time; // time/date stamp
        ulong psymbol; // reserved
        ulong nsymbol; // reserved
        uint  optsize; // Win NT header size
        uint  flags;
        uint  reserved0;
        uchar lmajor, lminor; // Link version
        ulong reserved1[3];
        ulong EntryPoint; // program Entry point relative to base
        ulong reserved2[2];
        ulong ImageBase; // adress at which program must be loaded
        ulong ObjAlign; // alignment of object's
        ulong FileAlign; // for image pages, all other-> dword align
        uint OSmajor, OSminor, USERmajor, USERminor, SUBmajor, SUBminor;
        ulong reserved3;
        ulong ImageSize, HeaderSize, chksum;
        uint subsystem;
        uint DLLflags;
        ulong StackRsize, StackCommitSize;
        ulong HeapRsize, HeapCommitSize;
        ulong reserved4;
        ulong Interest; // number of data directories follows
        DATA_DIR ddir[16];
  } tyPE; // Portable Exe, flat model EXE header

#define PE_size (uint)&PE.reserved0-(uint)&PE.signature

// Directory Entries id
#define DIR_E_EXPORT         0   // Export Directory
#define DIR_E_IMPORT         1   // Import Directory
#define DIR_E_RESOURCE       2   // Resource Directory
#define DIR_E_EXCEPTION      3   // Exception Directory
#define DIR_E_SECURITY       4   // Security Directory
#define DIR_E_BASERELOC      5   // Base Relocation Table
#define DIR_E_DEBUG          6   // Debug Directory
#define DIR_E_COPYRIGHT      7   // Description String
#define DIR_E_GLOBALPTR      8   // Machine Value (MIPS GP)
#define DIR_E_TLS            9   // TLS Directory
#define DIR_E_LOAD_CONFIG   10   // Load Configuration Directory
#define DIR_E_BOUND_IMPORT  11   // Bound Import Directory in headers
#define DIR_E_IAT           12   // Import Address Table

/*
        ulong ExportRVA, ExpSize;
        ulong ImportRVA, ImpSize;
        ulong ResurRVA, ResurSize;
        ulong ExceptRVA, ExceptSize;
        ulong SecureRVA, SecureSize;
        ulong FixupRVA, FixupSize;
        ulong DebugRVA, DebugSize;
        ulong ImageDescRVA, ImageDescSize;
        ulong MachineSpecRVA, MachineSpecSize;
        ulong ThreadLSRVA, ThreadLSSize;
 */

// objHeader describes a object in a PE file
  typedef struct {
        uchar ObjName[8]; // name of object
        ulong VirtSize;  // or Physical address!
        ulong VirtAddr;
        ulong RawSize;
        ulong RawOffset;     // file pointer
        ulong Reloc;         // file pointer
        ulong LineNum;       // file pointer
        uint  RelCount;    // # of relocations
        uint  LineCount;   // # of line numbers
        ulong flags;
  } tyObj;

// ExpDirectory is at start of a .edata object in a PE file
   typedef struct {
     ulong      flag; // export flags
     ulong      stamp;
     uint       Major; // user acceptable
     uint       Minor;
     ulong      Name; // relative virtual adr of name
     ulong      Base; // ordinal base
     ulong      NumFuncs; // count of entries
     ulong      NumNames; // count of pointers to funcnames
     ulong      AddrFuncs; // adres table relative virtual adr
     ulong      AddrNames; // names table relative virtual adr
     ulong      AddrOrds;  // ordinal table relative virtual adr
   } ExpDirectory;

   // import names table etc.
   typedef struct  {
     ulong      impAdr; // addr (names list) table RVA
     ulong      stamp; // date/time
     uint       Major; // version of referenced .DLL
     uint       Minor;
     ulong      Name; // relative virtual adr of .DLL name
     ulong      impLookup; // lookup (adress list) table RVA
   } ImpDirectory;

    typedef struct {
    uint Offset, Length;
    uint FlagWord, AllocSize;
    } segRECORD;

    typedef struct {
    uint resType, resCount;
    ulong resResvd;
    } resRECORD;

    typedef struct {
    uint resOffset, resLen, resFLAG, resName;
    ulong resResvd;
    } resDESCRIPTOR;

// ------------------------------------------------------------------

#define MaxNRnames 1800 // максимальный размер массива имен
#define MaxEntry 2800   // размер таблицы точек входа

// структуры для хранения таблиц адресов функций 16-бит приложения
typedef struct { char seg; uint offset; uint name; } ENTRY ;
typedef struct { int offset, module, func; char mode; } RELOC ;

// элемент таблицы имен, создаваемой для деассемлирования 32-бит кода
typedef struct
{
   ulong addr; // адрес fixup в загруженном в память image
   char name[32]; // имя вызываемой функции
} IMP_TBL;

// элемент таблицы адресов и типов данных
typedef struct
{
   ulong addr; // адрес fixup в загруженном в память image
   int   t;   // тип данных: db dw dd
   int   dim; // for array's definition like dw[120];
   int   as;  // >0 особая интерпретация: как WM_MSG16 и др.
} TYPEX_TBL;


// упрощенный вывод в FILE *out
void fp(char *fmt, ...);

// fill out an structure offset:module.function contain the same offset
int relocGET( int where, RELOC *to);

void relocINIT(void); // clear an array of module ref's for current .seg
void relocPUT( int offset, int module, int func, char mode);
void entryINIT(void); // clear an array of entry table ref's
void entryPUT( char seg, int offset);
int entryGET( char seg, int where, ENTRY *to);

// возвращает имя точки входа (movable seg entry point) по ее номеру
char *entryNameGET( int n);

// добавляет элемент в таблицу импорта 32-бит приложения
void add_imp_tbl( long fix, char *name );

// добавляет элемент в таблицу экспорта 32-бит приложения
void add_exp_tbl( long fix, char *name );

// добавляет строку-ресурс в список
void add_resource_string( long id, char *str );
char *get_resource_string( long id );

// loads "userdef.txt" file as function definition
// return 1 if Ok, 0 otherwise
int load_userdef(char *file);

// return true if user-defined name of function at seg:offset was found
int get_imp_udf( int seg, int offset, char **name );

// return the type of passed memory object, or 0 if not defined
int get_typex_udf( int seg, uint offset, int *dim, int *as );

// data type definition table
void add_type_tbl( long fix, int typeX, int dim, int as );

// maximum .DLL names to exclude from import list
#define MAX_EX_DLL 5


// классы команд во вpемя дизассемблиpования
// должны совпадать с определенными в DESS_X.ASM
#define cmdRETURN  1
#define cmdPREFIX  2
#define cmdCALLF   3
#define cmdCALLN   4
#define cmdPUSHP   5
