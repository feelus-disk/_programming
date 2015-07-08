.586P
.MODEL FLAT, stdcall
;константы
STD_OUTPUT_HANDLE equ -11
INVALID_HANDLE_VALUE  equ -1
;прототипы внешних процедур
EXTERN  GetStdHandle@4:NEAR
EXTERN  WriteConsoleA@20:NEAR
EXTERN  ExitProcess@4:NEAR
;директивы компоновщику для подключения библиотек
includelib f:\masm32\lib\user32.lib
includelib f:\masm32\lib\kernel32.lib
;------------------------------------------------
;сегмент данных
_DATA SEGMENT 
BUF DB  "Строка для вывода",0 
	LENS DWORD ? ;количество выведенных символов
HANDL DWORD ?
_DATA ENDS
;сегмент кода
_TEXT SEGMENT 
START:
;получить HANDLE вывода
	PUSH STD_OUTPUT_HANDLE
	CALL GetStdHandle@4
	CMP EAX,INVALID_HANDLE_VALUE
	JNE _EX
	MOV HANDL,EAX
;вывод строки
	PUSH 0
	PUSH OFFSET LENS
	PUSH 17
	PUSH OFFSET BUF
	PUSH HANDL
	CALL WriteConsoleA@20
_EX:
	PUSH 0
	CALL ExitProcess@4
_TEXT ENDS
END START
