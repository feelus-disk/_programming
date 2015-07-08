; dlldemo.asm
; Графическое приложение для win32, демонстрирующее работу с dllrus.dll
; выводит строку в KOI8 и затем в cp1251, перекодированную функией koi2wins
;
; Компиляция MASM
;  ml /c /coff /Cp /D_MASM_ dlldemo.asm
;  link dlldemo.obj /subsystem:windows
; (должен присутсвовать файл dllrus.lib, созданный при компиляции dllrus.dll)
;
; Компиляция TASM
;  tasm /m /ml /D_TASM_ dlldemo.asm
;  implib dllrus.lib dllrus.dll
;  tlink32 /Tpe /aa /x /c dlldemo.obj
;
; Компиляция WASM
;  wasm dlldemo.asm
;  wlib dllrus.lib dllrus.dll
;  wlink file dlldemo.obj form windows nt
;

include def32.inc
include user32.inc
include kernel32.inc

includelib dllrus.lib
ifndef _MASM_
	extrn	koi2win_asm:near
	extrn	koi2win:near
	extrn	koi2wins_asm:near
	extrn	koi2wins:near
else
	extrn __imp__koi2win_asm@0:dword
	extrn __imp__koi2win@4:dword
	extrn __imp__koi2wins_asm@0:dword
	extrn __imp__koi2wins@4:dword
 koi2win_asm	equ	__imp__koi2win_asm@0
 koi2win	equ	__imp__koi2win@4
 koi2wins_asm	equ	__imp__koi2wins_asm@0
 koi2wins	equ	__imp__koi2wins@4
endif

	.386
	.model flat
	.const
title_string1	db	'koi2win demo: string in KOI8',0
title_string2	db	'koi2win demo: string in cp1251',0
	.data
koi_string	db	'є╘╥╧╦┴ ╬┴ ыящ-8',0
	.code
_start:
	push	MB_OK
	push	offset title_string1	; title_string
	push	offset koi_string	; koi_string in koi8
	push	0
	call	MessageBox

	mov	eax,offset koi_string
	push	eax
	call	koi2wins

	push	MB_OK
	push	offset title_string2
	push	offset koi_string
	push	0
	call	MessageBox

	push	0		; код выхода
	call	ExitProcess	; конец программы
end	_start



