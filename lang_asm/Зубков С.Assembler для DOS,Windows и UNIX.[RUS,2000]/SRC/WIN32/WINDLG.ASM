; windlg.asm
; Графическое win32-приложение, демонстрирующее работу с диалогом
;
; Компиляция MASM
;  ml /c /coff /Cp windlg.asm
;  rc /r windlg.rc
;  link windlg.obj windlg.res /subsystem:windows
;
; Компиляция TASM
;  tasm /m /ml /D_TASM_ windlg.asm
;  brcc32 windlg.rc
;  tlink32 /Tpe /aa /c /x windlg.obj,,,,,windlg.res
;
; Компиляция WASM
;  wasm windlg.asm
;  wrc /r /bt=nt windlg.rc
;  wlink file windlg.obj res windlg.res form windows nt op c

; идентификаторы контролов (элементов диалога)
IDC_EDIT        equ  0
IDC_BUTTON      equ  1
IDC_EXIT        equ  2
; идентификаторы элементов меню
IDM_GETTEXT     equ 10
IDM_CLEAR       equ 11
IDM_EXIT        equ 12

include def32.inc
include kernel32.inc
include user32.inc

	.386
	.model flat
	.data
dialog_name	db	"ZZZ_Dialog",0 ; имя диалога в ресурсах
	.data?
buffer		db	512 dup(?)	; буфер для введённого текста
	.code
_start:
	xor	ebx,ebx		; в EBX будет 0 для команд push 0 (короче в 2 раза)
; определим идентификатор нашей программы
	push	ebx
	call	GetModuleHandle
; запустим диалог
	push	ebx		; значение, которое перейдёт как параметр WM_INITDIALOG
	push	offset dialog_proc ; адрес процедуры типа DialogProc
	push	ebx		; идентификатор окна-предка (0 - ничей диалог)
	push	offset dialog_name ; адрес имени диалога в ресурсах
	push	eax		; идентификатор программы, в ресурсах которой
				; находится диалог (наш идентификатор в EAX)
	call	DialogBoxParam
; выход из программы
	push	ebx
	call	ExitProcess
;
; процедура dialog_proc
; вызывается диалогом каждый раз, когда в нём что-нибудь происходит
; именно здесь будут происходить вся работа программы
;
; процедура не должна изменять регистры EBP,EDI,ESI и EBX !
;
dialog_proc	proc	near
; так как мы получаем параметры в стеке, построим стековый кадр
	push	ebp
	mov	ebp,esp
; процедура типа DialogProc вызывается со следующими параметрами
		dp_hWnd equ dword ptr [ebp+08h]	; идентификатор диалога
		dp_uMsg equ dword ptr [ebp+0Ch]	; номер сообщения
		dp_wParam equ dword ptr [ebp+10h]	; первый параметр
		dp_lParam equ dword ptr [ebp+14h]	; второй параметр
	mov	ecx,dp_hWnd	; ECX будет хранить идентификатор диалога
	mov	eax,dp_uMsg	; а EAX - номер сообщения
	cmp	eax,WM_INITDIALOG	; если мы получили WM_INITDIALOG
	jne	not_initdialog
	push	IDC_EDIT
	push	dp_hWnd
	call	GetDlgItem		; определим идентификатор
	push	eax			; окошка редактирования текста
	call	SetFocus		; и передадим ему фокус
not_initdialog:
	cmp	eax,WM_CLOSE		; если мы получили WM_CLOSE
	jne	not_close
	push	0
	push	ecx
	call	EndDialog		; закрыть диалог
not_close:
	cmp	eax,WM_COMMAND	; если мы получили WM_COMMAND
	jne	not_command
	mov	eax,dp_wParam	; EAX = wParam (номер сообщения)
	cmp	dp_lParam,0	; если lparam ноль - сообщение от меню
	jne	lParam_not_0
	cmp	ax,IDM_GETTEXT	; если это пункт меню Get Text
	jne	not_gettext
	push	512			; размер буфера
	push	offset buffer		; адрес буфера
	push	IDC_EDIT		; номер конрола редактирования
	push	ecx
	call	GetDlgItemText		; считаем текст в buffer
	push	MB_OK
	push	offset dialog_name
	push	offset buffer
	push	dp_hWnd
	call	MessageBox		; и покажем его в MessageBox
not_gettext:
	cmp	eax,IDM_CLEAR	; если это пункт меню Clear
	jne	not_clear
	push	0			; NULL
	push	IDC_EDIT		; номер контрола
	push	ecx
	call	SetDlgItemText		; установим новый текст
not_clear:
	cmp	eax,IDM_EXIT	; если это пункт меню Exit
	jne	not_exit
	push	0			; код возврата
	push	ecx			; идентификатор диалога
	call	EndDialog		; закрыть диалог
lParam_not_0:			; lParam не ноль - сообщение от контрола
	cmp	eax,IDC_EXIT	; если сообщение от кнопки Exit
	jne	not_exit
	shr	eax,16
	cmp	eax,BN_CLICKED	; если её нажали
	push	0			; код возврата
	push	ecx			; идентификатор диалога
	call	EndDialog		; закрыть диалог
not_exit:
	xor	eax,eax		; после обработки команды
	inc	eax		; DialogProc должен возвращать TRUE (eax=1)
	leave
	ret	16		; конец процедуры
not_command:		; сюда передаётся управление если мы получили
			; какое-то незнакомое сообщение
	xor	eax,eax	; код возврата FALSE (eax=0)
	leave
	ret	16	; конец процедуры
dialog_proc endp
       end _start

