#include <windows.h>
#include <stdio.h>
HANDLE openf(char * );
DWORD getoffs(DWORD );
HANDLE hf;
DWORD n;
WORD m;
IMAGE_DOS_HEADER id;
IMAGE_NT_HEADERS iw; 
IMAGE_SECTION_HEADER is;
IMAGE_SECTION_HEADER ais[100];
IMAGE_IMPORT_DESCRIPTOR im[1000];
IMAGE_THUNK_DATA it[1000];
IMAGE_IMPORT_BY_NAME in;
IMAGE_EXPORT_DIRECTORY ex;
IMAGE_RESOURCE_DIRECTORY rd1;
IMAGE_RESOURCE_DIRECTORY_ENTRY rde1[30];
IMAGE_RESOURCE_DIRECTORY rd2;
IMAGE_RESOURCE_DIRECTORY_ENTRY rde2[500];
IMAGE_COFF_SYMBOLS_HEADER ih;
IMAGE_DEBUG_DIRECTORY idd;
char * subs[]={"Unknown subsystem\n","Subsystem driver\n","Subsystem GUI\n","Subsystem console\n","Subsystem ?\n","Subsystem ?\n","Subsystem OS/2\n","Subsystem Posix\n"};
char   buf[300],buf1[300];;
DWORD im_n=0, it_n=0;
DWORD exn[5000];
WORD exo[5000];
DWORD exa[5000];
//главная функция 
int main(int argc, char* argv[])
{
	int er=0,i;
	LARGE_INTEGER l;
//проверка наличия параметров
	if(argc<2){printf("No parameters!\n");er=1; goto _exit;};
//первый в списке - имя файла
	printf("File: %s\n",argv[1]);
	if((hf=openf(argv[1]))==INVALID_HANDLE_VALUE)
	{
		printf("No file!\n"); 
		er=2; 
		goto _exit;};
//определим длину файла
	GetFileSizeEx(hf,&l);
//прочитать заголовок DOS
	if(!ReadFile(hf,&id,sizeof(id),&n,NULL))
	{
		printf("Read DOS_HEADER error 1!\n"); 
		er=3; 
		goto _exit;};
	if(n<sizeof(id))
	{
		printf("Read DOS_HEADER error 2!\n"); 
		er=4; 
		goto _exit;};
//проверить сигнатуру DOS ('MZ')		
	if(id.e_magic!=IMAGE_DOS_SIGNATURE)
	{
		printf("No DOS signature!\n");
		er=5; 
		goto _exit;}
	printf("DOS signature is OK!\n");
	if(id.e_lfanew>l.QuadPart)
	{
		printf("No NT signature!\n");
		er=6;
		goto _exit;};
//в начале передвинем указатель
	SetFilePointer(hf,id.e_lfanew,NULL,FILE_BEGIN);
//прочитать заголовок NT
	if(!ReadFile(hf,&iw,sizeof(iw),&n,NULL))
	{
		printf("Read NT_HEADER error 1!\n"); 
		er=7; 
		goto _exit;};
	if(n<sizeof(iw))
	{
		printf("Read NT_HEADER error 2!\n"); 
		er=8; 
		goto _exit;};
//проверить сигнатуру NT ('PE')
	if(iw.Signature!=IMAGE_NT_SIGNATURE)
	{
		printf("No NT signature!\n");
		er=9; 
		goto _exit;}
	printf("NT signature is OK!\n");
//здесь поработаем над струкутрой
	printf("Number of sections %d\n",iw.FileHeader.NumberOfSections);  
	printf("Size of optional header %d\n",iw.FileHeader.SizeOfOptionalHeader);
	if((iw.FileHeader.Characteristics&0x2000)!=0)printf("DLL-modul\n");
	else
	{
		if(((iw.FileHeader.Characteristics&0x1000)!=0))printf("System modul\n");
		printf("EXE-modul\n");
	};
	if(iw.FileHeader.Machine ==0x014c)printf("Processor Intel\n");
	else printf("Unknown processor\n");
//теперь опционный заголовок
	printf("Linker version %d.%d\n",iw.OptionalHeader.MajorLinkerVersion,iw.OptionalHeader.MinorLinkerVersion);
	printf("Size of code %d\n",iw.OptionalHeader.SizeOfCode);
	printf("Size of initialized data %d\n",iw.OptionalHeader.SizeOfInitializedData);
	printf("Size of uninitialized data %d\n",iw.OptionalHeader.SizeOfUninitializedData);
	printf("Address Of Entry Point (RVA) %xh\n",iw.OptionalHeader.AddressOfEntryPoint);
	printf("Address of code (RVA) %xh\n",iw.OptionalHeader.BaseOfCode);
	printf("Address of data (RVA) %xh\n",iw.OptionalHeader.BaseOfData);
	printf("Image Base %xh\n",iw.OptionalHeader.ImageBase);
	printf("Size Of Image %xh\n",iw.OptionalHeader.SizeOfImage);
	printf("Size of Headers %xh\n",iw.OptionalHeader.SizeOfHeaders);
	printf("Section Alignment %xh\n",iw.OptionalHeader.SectionAlignment);
	printf("File Alignment %xh\n",iw.OptionalHeader.FileAlignment);
	printf("Size Of Stack Reserve %d\n",iw.OptionalHeader.SizeOfStackReserve);
	printf("Size Of Stack Commit %d\n",iw.OptionalHeader.SizeOfStackCommit);
	printf("Size Of Heap Reserve %d\n",iw.OptionalHeader.SizeOfHeapReserve);
	printf("Size Of Heap Commit %d\n",iw.OptionalHeader.SizeOfHeapCommit);
	printf("%s",subs[iw.OptionalHeader.Subsystem]);
//список секций
//виртуальные адреса таблицы некоторых таблиц PE
	DWORD vi=iw.OptionalHeader.DataDirectory[1].VirtualAddress;
	DWORD ve=iw.OptionalHeader.DataDirectory[0].VirtualAddress;
	DWORD vr=iw.OptionalHeader.DataDirectory[2].VirtualAddress;   
	DWORD vg=iw.OptionalHeader.DataDirectory[6].VirtualAddress;   
//
	printf("Sections:\n");
	printf("    Name   sizev    sizef     adrf     adrv\n");
	printf("-------------------------------------------\n");
	int j=0;
	for(i=0; i<iw.FileHeader.NumberOfSections; i++)
	{
		if(!ReadFile(hf,&is,sizeof(is),&n,NULL))
		{
			printf("IMAGE_SECTION_HEADER error!\n"); 
			er=10; 
			goto _exit;
		};
		printf("%8s %6xh  %6xh  %6xh  %6xh\n",is.Name,is.Misc.VirtualSize,is.SizeOfRawData,is.PointerToRawData,is.VirtualAddress);
		ais[i].VirtualAddress=is.VirtualAddress;
		ais[i].PointerToRawData=is.PointerToRawData;  
	};
	printf("-------------------------------------------\n");
	printf("\n");
//таблица импорта
	if(!vi)
	{
		printf("No import!\n");
	}else
	{
		printf("Import section offset %xh virtual %xh\n",getoffs(vi),vi);
//в начале передвинем указатель
		SetFilePointer(hf,getoffs(vi),NULL,FILE_BEGIN);
		while(TRUE)
		{
			if(!ReadFile(hf,&im[im_n],sizeof(im[im_n]),&n,NULL))
			{
				printf("IMAGE_IMPORT_DESCRIPTOR error!\n"); 
				er=11; 
				goto _exit;
			};
			if(im[im_n].Characteristics==0&&im[im_n].Name==0)break;
			im_n++;
		};
//библиотеки
		printf("Import objects:\n");
		for(i=0; i<(int)im_n; i++)
		{
		//в начале библиотеки DLL
			SetFilePointer(hf,getoffs(im[i].Name),NULL,FILE_BEGIN);
			ReadFile(hf,buf,100,&n,NULL);	
			printf("%s\n",buf);
		//теперь названия функций
			if(im[i].OriginalFirstThunk!=0)
			SetFilePointer(hf,getoffs(im[i].OriginalFirstThunk),NULL,FILE_BEGIN);
			else
			SetFilePointer(hf,getoffs(im[i].FirstThunk),NULL,FILE_BEGIN);
			it_n=0;
			printf("Offset of AdresImpArray %xh RVA of AdresImpArray %xh\n",getoffs(im[i].FirstThunk),im[i].FirstThunk);
			while(TRUE)
			{
				ReadFile(hf,&it[it_n],sizeof(it[it_n]),&n,NULL);
				if(it[it_n].u1.AddressOfData==0)break;
				it_n++;
			};
			for(j=0; j<(int)it_n; j++)
			{
				if((it[j].u1.AddressOfData&IMAGE_ORDINAL_FLAG32)==0)
				{
				SetFilePointer(hf,getoffs(it[j].u1.ForwarderString+2),NULL,FILE_BEGIN);
				ReadFile(hf,buf,100,&n,NULL);		
				printf("     %s %xh %xh\n",buf,getoffs(it[j].u1.ForwarderString+2),it[j].u1.ForwarderString+2);
				} else printf("   Ordinal %d\n",it[j].u1.AddressOfData&0x0000ffff);
			};
		};
	};
//таблица экспорта
	printf("\n");
	if(!ve)
	{
		printf("No export!\n");
	}else
	{
		printf("Export section offset %xh virtual %xh\n",getoffs(ve),ve);
		SetFilePointer(hf,getoffs(ve),NULL,FILE_BEGIN);
		if(!ReadFile(hf,&ex,sizeof(ex),&n,NULL))
		{
			printf("IMAGE_EXPORT_DIRECTORY error!\n"); 
			er=12; 
			goto _exit;
		};
		SetFilePointer(hf,getoffs(ex.Name),NULL,FILE_BEGIN);
		ReadFile(hf,buf,100,&n,NULL);
		printf("Export modul: %s\n",buf);
		printf("Number of functions: %d\n",ex.NumberOfFunctions);
		printf("Number of names: %d\n",ex.NumberOfNames);
		printf("Ordinal base %d\n",ex.Base);
//массив указателей на имена экспортируемых функций
		SetFilePointer(hf,getoffs(ex.AddressOfNames),NULL,FILE_BEGIN);
		for(i=0; i<ex.NumberOfNames; i++)
			ReadFile(hf,&exn[i],4,&n,NULL);
//массив указателей на ординалы экспортируемых функций
		SetFilePointer(hf,getoffs(ex.AddressOfNameOrdinals),NULL,FILE_BEGIN);
		for(i=0; i<ex.NumberOfNames; i++)
			ReadFile(hf,&exo[i],2,&n,NULL);
//массив указателей на адреса экспортируемых функций
		SetFilePointer(hf,getoffs(ex.AddressOfFunctions),NULL,FILE_BEGIN);
		for(i=0; i<ex.NumberOfFunctions; i++)
			ReadFile(hf,&exa[i],4,&n,NULL);
		printf("\n");
		printf("Name of function                Ord     VAdr\n");
		printf("---------------------------------------------\n");
//вывод имен экспортируемых функций
		for(i=0; i<ex.NumberOfNames; i++)
		{
			SetFilePointer(hf,getoffs(exn[i]),NULL,FILE_BEGIN);
			ReadFile(hf,buf,300,&n,NULL);
			printf("%30s %4d %8xh\n",buf,exo[i]+ex.Base,exa[exo[i]]);
		};
		printf("---------------------------------------------\n");
        		
	};
//работа с ресурсами
	printf("\n");
	if(!vr)
	{
		printf("No resource!\n");
	}else
	{
		DWORD offres=getoffs(vr);
		printf("Resource: offset %xh virtual %xh \n",offres,vr);
		SetFilePointer(hf,offres,NULL,FILE_BEGIN);
		ReadFile(hf,&rd1,sizeof(rd1),&n,NULL);
		//1-й уровень
		printf("Number of type %d \n",rd1.NumberOfIdEntries);
		//в начале пропустить rd.NumberOfNamedEntries записей
		for(i=0; i<rd1.NumberOfNamedEntries; i++)
			ReadFile(hf,&rde1[i],sizeof(rde1[i]),&n,NULL);		
		//перечень типов ресурсов запомнить в массиве
		for(i=0; i<rd1.NumberOfIdEntries; i++)
			ReadFile(hf,&rde1[i],sizeof(rde1[i]),&n,NULL);		
		//вывод типов ресурсов
		for(i=0; i<rd1.NumberOfIdEntries; i++)
			printf("Type identify: %d\n",rde1[i].Name);
		//2-й уровень
		printf("List of resource:\n");
		for(i=0; i<rd1.NumberOfIdEntries; i++)
		{
			SetFilePointer(hf,(rde1[i].OffsetToData & 0x7fffffff)+offres,NULL,FILE_BEGIN);
			ReadFile(hf,&rd2,sizeof(rd2),&n,NULL);
			printf("*Type of resource: %d\n",rde1[i].Id);
			for(j=0; j<rd2.NumberOfNamedEntries+rd2.NumberOfIdEntries; j++)
				ReadFile(hf,&rde2[j],sizeof(rde2[j]),&n,NULL);		
			for(j=0; j<rd2.NumberOfNamedEntries+rd2.NumberOfIdEntries; j++)
			{
				if(!(rde2[j].Name & 0x80000000))
				{
					printf(" -Resource identify %d\n",rde2[j].Name);
				}
				else
				{
					SetFilePointer(hf,(rde2[j].Name & 0x7fffffff)+offres,NULL,FILE_BEGIN);
					ReadFile(hf,&m,2,&n,NULL);		
					ReadFile(hf,buf,2*m,&n,NULL);		
					//перекодировка из Unicode
					WideCharToMultiByte(CP_UTF7,0,(LPCWSTR)(buf),m,buf1,300,NULL,NULL);
					printf(" -Name of resource: %s\n",buf1);
				}
			};
		};

	};
//проверим отладочную информацию
	printf("\n");
	if(!vg)
	{
		printf("No debug table!\n");
	}else
	{
		DWORD offdbg=getoffs(vg);
		printf("Debug table: offset %xh virtual %xh \n",offdbg,vg);
		SetFilePointer(hf,offdbg,NULL,FILE_BEGIN);
		ReadFile(hf,&idd,sizeof(idd),&n,NULL);
		printf("Type of debug information: %d\n",idd.Type);
		//для COFF информации
		if(idd.Type==1)
		{
			SetFilePointer(hf,idd.PointerToRawData,NULL,FILE_BEGIN);
			ReadFile(hf,&ih,sizeof(ih),&n,NULL);
			printf("RVA of first line number: %xh\n",idd.PointerToRawData+ih.LvaToFirstLinenumber);	
		}
	}
	if(!iw.FileHeader.PointerToSymbolTable )
	{
		printf("No symbol table!\n");
	}else
	{
		DWORD offsym=getoffs(iw.FileHeader.PointerToSymbolTable);
		printf("Symbol table: offset %xh virtual %xh \n",offsym,iw.FileHeader.PointerToSymbolTable);
	};
	
//закрыть дескриптор файла
_exit:
	CloseHandle(hf);
	return er;
};
//функция открывает файл для чтения
HANDLE openf(char * nf)
{	
	return CreateFile(nf,
		GENERIC_READ,
		FILE_SHARE_WRITE | FILE_SHARE_READ,
		NULL,
		OPEN_EXISTING,
		NULL,
		NULL);
};
//определение смещения в файле PE по относительному виртуальному адресу
DWORD getoffs(DWORD vsm)
{
	DWORD fi=0;
	if(vsm<ais[0].VirtualAddress)return fi;
	for(int i=0; i<iw.FileHeader.NumberOfSections; i++)
	{
		if(vsm<ais[i].VirtualAddress&&i>0){
			fi=ais[i-1].PointerToRawData+(vsm-ais[i-1].VirtualAddress);
			break;}; 
	};
	if(i==iw.FileHeader.NumberOfSections)
		fi=ais[i-1].PointerToRawData+(vsm-ais[i-1].VirtualAddress);
	return fi;	
};	