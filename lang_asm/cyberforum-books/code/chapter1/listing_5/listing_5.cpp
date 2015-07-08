#include <windows.h>

BOOL WINAPI handler(DWORD);
void inputcons();
void print(char *);

HANDLE h1,h2;
char * s1 = "Error input!\n";
char s2[35];
char * s4 = "CTRL+C\n";
char * s5 = "CTRL+BREAK\n";
char * s6 = "CLOSE\n";
char * s7 = "LOGOFF\n";
char * s8 = "SHUTDOWN\n";
char * s9 = "CTRL\n";
char * s10="ALT\n";
char * s11="SHIFT\n";
char * s12=" \n";
char * s13="Code %d \n";
char * s14="CAPSLOCK \n";
char * s15="NUMLOCK \n";
char * s16="SCROLLOCK \n";
char * s17="Enhanced key (virtual code) %d \n";
char * s18="Function key (virtual code) %d \n";
char * s19="Left mouse button\n";
char * s20="Right mouse button\n";
char * s21="Double click\n";
char * s22="Wheel was rolled\n";
char * s23="Character '%c' \n";
char * s24="Location of cursor x=%d y=%d\n";

void main()
{
//инициализация консоли
	FreeConsole();
	AllocConsole();
//получить дескриптор вывода
	h1=GetStdHandle(STD_OUTPUT_HANDLE);
//получить дескриптор ввода
	h2=GetStdHandle(STD_INPUT_HANDLE);
//установить обработчик событий
	SetConsoleCtrlHandler(handler,TRUE);
//вызвать функцию с циклом обработки сообщений
	inputcons();
//удалить обработчик
	SetConsoleCtrlHandler(handler,FALSE);
//закрыть дескрипторы
	CloseHandle(h1); CloseHandle(h2);
//освободить консоль
	FreeConsole();
//выйти из программы
	ExitProcess(0);
};

//обработчик событий
BOOL WINAPI handler(DWORD ct)
{
//событие CTRL+C?
	if(ct==CTRL_C_EVENT) print(s4);
//событие CTRL+BREAK?
	if(ct==CTRL_BREAK_EVENT) print(s5);
//закрытие консоли?
	if(ct==CTRL_CLOSE_EVENT) 
	{
		print(s6);
		Sleep(2000);
		ExitProcess(0);
	};
//завершение сеанса?
	if(ct==CTRL_LOGOFF_EVENT) 
	{
		print(s7);
		Sleep(2000);
		ExitProcess(0);
	};
//завершение работы?
	if(ct==CTRL_SHUTDOWN_EVENT) 
	{
		print(s8);
		Sleep(2000);
		ExitProcess(0);
	};
	return TRUE;
};
//функция с циклом обработки сообщений консоли
void inputcons()
{
	DWORD n;
	INPUT_RECORD ir;
	while(ReadConsoleInput(h2,&ir,1,&n))
	{
//здесь обработка событий мыши
		if(ir.EventType==MOUSE_EVENT)
		{
//двойной щелчок
			if(ir.Event.MouseEvent.dwEventFlags==DOUBLE_CLICK)
				print(s21);
//движение мыши по консоли
			if(ir.Event.MouseEvent.dwEventFlags==MOUSE_MOVED)
			{
				wsprintf(s2,s24,ir.Event.MouseEvent.dwMousePosition.X,
					ir.Event.MouseEvent.dwMousePosition.Y);
				print(s2);
			};
//колесико мыши
			if(ir.Event.MouseEvent.dwEventFlags==MOUSE_WHEELED)
				print(s22);
//левая кнопка
if(ir.Event.MouseEvent.dwButtonState==FROM_LEFT_1ST_BUTTON_PRESSED)
		print(s19);
//правая кнопка
			if(ir.Event.MouseEvent.dwButtonState==RIGHTMOST_BUTTON_PRESSED)
				print(s20);
		};
		if(ir.EventType==KEY_EVENT)
		{
			if(ir.Event.KeyEvent.bKeyDown!=1)continue;
//расширенная клавиатура
			if(ir.Event.KeyEvent.dwControlKeyState==ENHANCED_KEY)
			{
				wsprintf(s2,s17,ir.Event.KeyEvent.wVirtualKeyCode);
				print(s2);
			};
//клавиша CAPS LOCK?
			if(ir.Event.KeyEvent.dwControlKeyState==CAPSLOCK_ON)
				print(s14);
//левый ALT?
			if(ir.Event.KeyEvent.dwControlKeyState==LEFT_ALT_PRESSED)
				print(s10);
//правый ALT?
			if(ir.Event.KeyEvent.dwControlKeyState==RIGHT_ALT_PRESSED)
				print(s10);
//левый CTRL?
			if(ir.Event.KeyEvent.dwControlKeyState==LEFT_CTRL_PRESSED)
				print(s9);
//правый CTRL?
			if(ir.Event.KeyEvent.dwControlKeyState==RIGHT_CTRL_PRESSED)
				print(s9);
//клавиша SHIFT?
			if(ir.Event.KeyEvent.dwControlKeyState==SHIFT_PRESSED)
				print(s11);
//клавиша NUM LOCK
			if(ir.Event.KeyEvent.dwControlKeyState==NUMLOCK_ON)
				print(s15);
//клавиша SCROLL LOCK
			if(ir.Event.KeyEvent.dwControlKeyState==SCROLLLOCK_ON)
				print(s16);
//обработка обычных клавиш
			if(ir.Event.KeyEvent.uChar.AsciiChar>=32)
			{
				wsprintf(s2,s23,ir.Event.KeyEvent.uChar.AsciiChar);
				print(s2);
			}else
			{
				if(ir.Event.KeyEvent.uChar.AsciiChar>0)
				{
//здесь клавиши с кодом >0 и <32
					wsprintf(s2,s13,ir.Event.KeyEvent.uChar.AsciiChar);
					print(s2);
				}else
				{
//назовем эти клавиши функциональными
					wsprintf(s2,s18,ir.Event.KeyEvent.wVirtualKeyCode);
					print(s2);
				};
			};
		};
	};
//сообщение об ошибке
	print(s1);
	Sleep(5000);
};
//функция вывода на консоль
void print(char *s)
{
	DWORD n;
	WriteConsole(h1,s,lstrlen(s),&n,NULL);
};
