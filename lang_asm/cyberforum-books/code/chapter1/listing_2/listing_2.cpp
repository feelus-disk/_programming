#include <windows.h>
char * s="Example of console program.\n\0";
char buf[100];
DWORD d;
void main()
{
//освободить консоль, если она унаследована
	FreeConsole();
//создать консоль
	AllocConsole();
//получить дескриптор вывода на консоль
	HANDLE ho=GetStdHandle(STD_OUTPUT_HANDLE);	
//получить дескриптор ввода с консоли
	HANDLE hi=GetStdHandle(STD_INPUT_HANDLE);	
//вывести строку на консоль
	WriteConsole(ho,s,lstrlen(s),&d,NULL);
//использовать ReadConsole для просмотра экрана консоли
	ReadConsole(hi,(void*)buf,100,&d,NULL);
//закрыть дескрипторы
	CloseHandle(ho);
	CloseHandle(hi);
//освободить консоль
	FreeConsole();
}
