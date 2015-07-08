; user32.inc
; включаемый файл с определениями функций из user32.dll
;
ifdef _TASM_
	includelib import32.lib
	; имена используемых функций
		extrn	MessageBoxA:near
		extrn	DispatchMessageA:near
		extrn	TranslateMessage:near
		extrn	GetMessageA:near
		extrn	LoadIconA:near
		extrn	UpdateWindow:near
		extrn	ShowWindow:near
		extrn	CreateWindowExA:near
		extrn	DefWindowProcA:near
		extrn	PostQuitMessage:near
		extrn	RegisterClassExA:near
		extrn	LoadCursorA:near
		extrn	LoadMenuA:near
		extrn	DestroyWindow:near
		extrn	DialogBoxParamA:near
		extrn	GetDlgItem:near
		extrn	SetFocus:near
		extrn	GetDlgItemTextA:near
		extrn	SetDlgItemTextA:near
		extrn	EndDialog:near
		extrn	LoadAcceleratorsA:near
		extrn	TranslateAccelerator:near
		extrn	SendMessageA:near
		extrn	SetWindowTextA:near
		extrn	MoveWindow:near
		extrn	GetClientRect:near
		extrn	GlobalUnlock:near
	; присваивания для облегчения читаемости кода
	MessageBox	equ	MessageBoxA
	DispatchMessage	equ	DispatchMessageA
	GetMessage	equ	GetMessageA
	LoadIcon	equ	LoadIconA
	CreateWindowEx	equ	CreateWindowExA
	DefWindowProc	equ	DefWindowProcA
	RegisterClassEx	equ	RegisterClassExA
	LoadCursor	equ	LoadCursorA
	LoadMenu	equ	LoadMenuA
	DialogBoxParam	equ	DialogBoxParamA
	GetDlgItemText	equ	GetDlgItemTextA
	SetDlgItemText	equ	SetDlgItemTextA
	LoadAccelerators equ	LoadAcceleratorsA
	SendMessage	equ	SendMessageA
	SetWindowText	equ	SetWindowTextA
else
	includelib user32.lib
	; истинные имена используемых функций
		extrn	__imp__MessageBoxA@16:dword
		extrn	__imp__DispatchMessageA@4:dword
		extrn	__imp__TranslateMessage@4:dword
		extrn	__imp__GetMessageA@16:dword
		extrn	__imp__LoadIconA@8:dword
		extrn	__imp__UpdateWindow@4:dword
		extrn	__imp__ShowWindow@8:dword
		extrn	__imp__CreateWindowExA@48:dword
		extrn	__imp__DefWindowProcA@16:dword
		extrn	__imp__PostQuitMessage@4:dword
		extrn	__imp__RegisterClassExA@4:dword
		extrn	__imp__LoadCursorA@8:dword
		extrn	__imp__LoadMenuA@8:dword
		extrn	__imp__DestroyWindow@4:dword
		extrn	__imp__DialogBoxParamA@20:dword
		extrn	__imp__GetDlgItem@8:dword
		extrn	__imp__SetFocus@4:dword
		extrn	__imp__GetDlgItemTextA@16:dword
		extrn	__imp__SetDlgItemTextA@12:dword
		extrn	__imp__EndDialog@8:dword
		extrn	__imp__LoadAcceleratorsA@8:dword
		extrn	__imp__TranslateAccelerator@12:dword
		extrn	__imp__SendMessageA@16:dword
		extrn	__imp__SetWindowTextA@8:dword
		extrn	__imp__MoveWindow@24:dword
		extrn	__imp__GetClientRect@8:dword
		extrn	__imp__GlobalUnlock@4:dword
	; присваивания для облегчения читаемости кода
	MessageBox	equ	__imp__MessageBoxA@16
	DispatchMessage	equ	__imp__DispatchMessageA@4
	TranslateMessage equ	__imp__TranslateMessage@4
	GetMessage	equ	__imp__GetMessageA@16
	LoadIcon	equ	__imp__LoadIconA@8
	UpdateWindow	equ	__imp__UpdateWindow@4
	ShowWindow	equ	__imp__ShowWindow@8
	CreateWindowEx	equ	__imp__CreateWindowExA@48
	DefWindowProc	equ	__imp__DefWindowProcA@16
	PostQuitMessage	equ	__imp__PostQuitMessage@4
	RegisterClassEx	equ	__imp__RegisterClassExA@4
	LoadCursor	equ	__imp__LoadCursorA@8
	LoadMenu	equ	__imp__LoadMenuA@8
	DestroyWindow	equ	__imp__DestroyWindow@4
	DialogBoxParam	equ	__imp__DialogBoxParamA@20
	GetDlgItem	equ	__imp__GetDlgItem@8
	SetFocus	equ	__imp__SetFocus@4
	GetDlgItemText	equ	__imp__GetDlgItemTextA@16
	SetDlgItemText	equ	__imp__SetDlgItemTextA@12
	EndDialog	equ	__imp__EndDialog@8
	LoadAccelerators equ	__imp__LoadAcceleratorsA@8
	TranslateAccelerator equ __imp__TranslateAccelerator@12
	SendMessage	equ	__imp__SendMessageA@16
	SetWindowText	equ	__imp__SetWindowTextA@8
	MoveWindow	equ	__imp__MoveWindow@24
	GetClientRect	equ	__imp__GetClientRect@8
	GlobalUnlock	equ	__imp__GlobalUnlock@4
endif
