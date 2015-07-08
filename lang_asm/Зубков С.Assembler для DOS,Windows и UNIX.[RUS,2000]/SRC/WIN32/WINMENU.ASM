; winmenu.asm
; Графическое win32-приложение, демонстрирующее работу с меню
; звёздочками отмечены строки, скопированные из файла window.asm
;
; Компиляция MASM
;  ml /c /coff /Cp winmenu.asm
;  rc /r winmenu.rc
;  link winmenu.obj winmenu.res /subsystem:windows
;
; Компиляция TASM
;  tasm /m /ml /D_TASM_ winmenu.asm
;  brcc32 winmenu.rc
;  tlink32 /Tpe /aa /c /x winmenu.obj,,,,,winmenu.res
;
; Компиляция WASM
;  wasm winmenu.rc
;  wrc /r /bt=nt winmenu.rc
;  wlink file winmenu.obj res winmenu.res form windows nt
;


ZZZ_TEST equ 0		; сообщения от нашего меню
ZZZ_OPEN equ 1		; должны совпадать с определениями из winmenu.rc
ZZZ_SAVE equ 2		; кроме того в нашем примере их номера важны
ZZZ_EXIT equ 3		; потому что они используются как индекс для таблицы
			; переходов к обработчикам

include def32.inc				;*
include kernel32.inc				;*
include user32.inc				;*
	.386					;*
	.model flat				;*
	.data					;*
class_name	db 'window class 1',0		;*
window_name	db 'win32 assembly example',0	;*
menu_name	db 'ZZZ_Menu',0			; имя меню в файле ресурсов
test_msg	db 'You selected menu item TEST',0 ; строки для
open_msg	db 'You selected menu item OPEN',0 ; демонстрации работы
save_msg	db 'You selected menu item SAVE',0 ; меню
wc	WNDCLASSEX <4*12,CS_HREDRAW or CS_VREDRAW,offset win_proc,0,0,?,?,?,COLOR_WINDOW+1,0,offset class_name,0> ;*
	.data?					;*
msg_	MSG	<?,?,?,?,?,?>			;*
	.code					;*
_start:						;*
	xor	ebx,ebx				;*
	push	ebx		;*
	call	GetModuleHandle	;*
	mov	esi,eax		;*
	mov	dword ptr wc.hInstance,eax ;*
	push	IDI_APPLICATION	;*
	push	ebx		;*
	call	LoadIcon	;*
	mov	wc.hIcon,eax	;*
	push	IDC_ARROW	;*
	push	ebx		;*
	call	LoadCursor	;*
	mov	wc.hCursor,eax	;*
	push	offset wc	;*
	call	RegisterClassEx	;*

	push	offset menu_name	; имя меню
	push	esi			; наш идентификатор
	call	LoadMenu		; загрузим меню из ресурсов
	mov	ecx,CW_USEDEFAULT	;*
	push	ebx			;*
	push	esi			;*
	push	eax		; идентификатор меню или окна-потомка
	push	ebx			;*
	push	ecx			;*
	push	ecx			;*
	push	ecx			;*
	push	ecx			;*
	push	WS_OVERLAPPEDWINDOW	;*
	push	offset window_name	;*
	push	offset class_name	;*
	push	ebx			;*
	call	CreateWindowEx		;*
	push	eax			;*
	push	SW_SHOWNORMAL		;*
	push	eax			;*
	call	ShowWindow		;*
	call	UpdateWindow		;*
	mov	edi,offset msg_ 	;*
message_loop:				;*
	push	ebx			;*
	push	ebx			;*
	push	ebx			;*
	push	edi			;*
	call	GetMessage		;*
	test	eax,eax			;*
	jz	exit_msg_loop		;*
	push	edi			;*
	call	TranslateMessage	;*
	push	edi			;*
	call	DispatchMessage		;*
	jmp short message_loop		;*
exit_msg_loop:				;*
	push	ebx			;*
	call	ExitProcess		;*

; процедура win_proc
; вызывается окном каждый раз, когда окно получает какое-нибудь сообщение
; именно здесь будут происходить вся работа программы
;
; процедура не должна изменять регистры EBP,EDI,ESI и EBX !
win_proc proc						;*
	push	ebp					;*
	mov	ebp,esp					;*
		wp_hWnd equ dword ptr [ebp+08h]		;*
		wp_uMsg equ dword ptr [ebp+0Ch]		;*
		wp_wParam equ dword ptr [ebp+10h]	;*
		wp_lParam equ dword ptr [ebp+14h]	;*
	cmp	wp_uMsg,WM_DESTROY			;*
	jne	not_wm_destroy				;*
	push	0					;*
	call	PostQuitMessage				;*
	jmp short end_wm_check				;*
not_wm_destroy:						;*
	cmp	wp_uMsg,WM_COMMAND	; если мы получили WM_COMMAND
	jne	not_wm_command		; это от нашего меню
	mov	eax,wp_wParam		; и в wParam лежит наше под-сообщение
	jmp dword ptr menu_handlers[eax*4] ; косвенный переход
	; (в 32-битном режиме можно делать переход по любому регистру)

menu_handlers	dd	offset menu_test,offset menu_open
		dd	offset menu_save,offset menu_exit
; обработчики событий test, open и save выводят MessageBox
; обработчик exit выходит из программы
menu_test:
	mov	eax,offset test_msg	; сообщение для MessageBox
	jmp short show_msg
menu_open:
	mov	eax,offset open_msg	; сообщене для MessageBox
	jmp short show_msg
menu_save:
	mov	eax,offset save_msg	; сообщение для MessageBox
show_msg:
	push	MB_OK			; стиль для MessageBox
	push	offset menu_name	; заголовок
	push	eax			; сообщение
	push	wp_hWnd			; идентификатор окна-предка
	call	MessageBox		; вызов функции
	jmp short end_wm_check		; выход из win_proc
menu_exit:		; если выбрали пункт EXIT
	push	wp_hWnd
	call	DestroyWindow	; уничтожим наше окно

end_wm_check:	; здесь мы поменяли местами end_wm_check и
	leave			;*
	xor	eax,eax	; вернём 0 как результат работы процедуры
	ret 16			;*
not_wm_command:	; not_wm_command, чтобы избавиться от лишнего jmp
	leave			;*
	jmp	DefWindowProc	;*
win_proc endp			;*
        end _start		;*

