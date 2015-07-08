; mpr.inc
; включаемый файл с определениями функций из mpr.dll
;

ifdef _TASM_
	includelib import32.lib
	; имена используемых функций
		extrn	WNetGetUserA:near
		extrn	WNetOpenEnumA:near
		extrn	WNetEnumResourceA:near
		extrn	WNetCloseEnum:near
	; присваивания для облегчения читаемости кода
	WNetGetUser	equ	WNetGetUserA
	WNetOpenEnum	equ	WNetOpenEnumA
	WNetEnumResource equ	WNetEnumResourceA
else
	includelib mpr.lib
	; истинные имена используемых функций
		extrn	__imp__WNetGetUserA@12:dword
		extrn	__imp__WNetOpenEnumA@20:dword
		extrn	__imp__WNetEnumResourceA@16:dword
		extrn	__imp__WNetCloseEnum@4:dword
	; присваивания для облегчения читаемости кода
	WNetGetUser	equ	__imp__WNetGetUserA@12
	WNetOpenEnum	equ	__imp__WNetOpenEnumA@20
	WNetEnumResource equ	__imp__WNetEnumResourceA@16
	WNetCloseEnum	equ	__imp__WNetCloseEnum@4
endif


