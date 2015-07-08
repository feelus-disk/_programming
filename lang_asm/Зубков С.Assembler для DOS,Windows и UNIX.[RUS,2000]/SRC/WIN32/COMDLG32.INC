; comdlg32.inc
; включаемый файл с определениями функций из comdlg32.dll
;
ifdef _TASM_
	includelib import32.lib
	; имена используемых функций
		extrn	GetOpenFileNameA:near
		extrn	GetSaveFileNameA:near
	; присваивания для облегчения читаемости кода
	GetOpenFileName	equ	GetOpenFileNameA
	GetSaveFileName	equ	GetSaveFileNameA
else
	includelib comdlg32.lib
	; истинные имена используемых функций
		extrn	__imp__GetOpenFileNameA@4:dword
		extrn	__imp__GetSaveFileNameA@4:dword
	; присваивания для облегчения читаемости кода
	GetOpenFileName	equ	__imp__GetOpenFileNameA@4
	GetSaveFileName	equ	__imp__GetSaveFileNameA@4
endif
