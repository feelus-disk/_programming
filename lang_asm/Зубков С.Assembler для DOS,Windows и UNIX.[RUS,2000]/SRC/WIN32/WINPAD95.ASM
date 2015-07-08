; winpad95.asm
; Графическое win32-приложение - текстовый редактор
;
; Компиляция MASM
;  ml /c /coff /Cp winpad95.asm
;  rc /r winpad95.rc
;  link winpad95.obj winpad95.res /subsystem:windows
;
; Компиляция TASM
;  tasm /m /ml /D_TASM_ winpad95.asm
;  brcc32 winpad95.rc
;  tlink32 /Tpe /aa /c /x winpad95.obj,,,,,winpad95.res
;
; Компиляция WASM
;  wasm winpad95.rc
;  wrc /r /bt=nt winpad95.rc
;  wlink file winpad95.obj res winpad95.res form windows nt
;
include def32.inc
include user32.inc
include kernel32.inc
include comdlg32.inc

ID_MENU		equ	700h
ID_ACCEL	equ	701h
ID_ABOUT	equ	702h

MAXSIZE equ 260		; максимальное имя файла
MEMSIZE	equ 65535	; максимальный размер временного буфера в памяти

EditID	equ 1

	.386
	.model flat
	.const
c_w_name	db 'Asmpad95',0	; это и имя класса и имя основного окна
edit_class	db 'edit',0	; предопределённое имя класса для редактора
changes_msg	db 'Save changes?',0
filter_string	db 'All Files',0,'*.*',0	; маски для Get*FileName
		db 'Text Files',0,'*.txt',0,0
	.data
; структура, использующаяся Get*FileName
ofn	OPENFILENAME <SIZE ofn,?,?,offset filter_string,?,?,?,offset buffer,MAXSIZE,0,?,?,?,?,?,?,0,?,?,?>
; стурктура, описывающая наш основной класс
wc	WNDCLASSEX <SIZE WNDCLASSEX,CS_HREDRAW or CS_VREDRAW,offset win_proc,0,0,?,?,?,COLOR_WINDOW+1,ID_MENU,offset c_w_name,0>
flag_untitled	db	1	; = 1 если имя файла не определено (новый файл)

	.data?
h_editwindow	dd	?	; идентификатор окна редактора
h_accel		dd	?	; идентификатор массива акселераторов
p_memory	dd	?	; адрес буфера в памяти
SizeReadWrite	dd	?
msg_		MSG	<>
rec		RECT	<>
buffer		db	MAXSIZE dup(?)	; имя файла
window_title	db	MAXSIZE dup(?), 12 dup(?)

	.code
_start:
	call	GetCommandLine		; получим нашу командную строку
	mov	edi,eax
	mov	al,' '
	mov	ecx,MAXSIZE
	repne  scasb			; найдём конец имени нашей программы
	cmp	byte ptr [edi],0
	je	cmdline_empty
	mov	esi,edi
	mov	edi,offset buffer
	rep movsb
	mov flag_untitled,0
cmdline_empty:
; подготовим и зарегистрируем класс
	xor	ebx,ebx
	call	GetModuleHandle		; определим наш идентификатор
	mov	esi,eax
	mov	wc.hInstance,eax	; и сохраним его в wc.hInstance
	mov	ofn._hInstance,eax
	push	IDI_APPLICATION	 ; или IDI_ICON если иконка есть в ресурсах
	push	ebx		; или esi если иконка есть в ресурсах
	call	LoadIcon
	mov	wc.hIcon,eax
	push	IDC_ARROW	; предопределённый курсор (стрелка)
	push	ebx
	call	LoadCursor
	mov	wc.hCursor,eax
	push	offset wc
	call	RegisterClassEx
; создадим основное окно
	push	ebx
	push	esi
	push	ebx
	push	ebx
	push	200
	push	300
	push	CW_USEDEFAULT
	push	CW_USEDEFAULT
	push	WS_OVERLAPPEDWINDOW
	push	offset c_w_name
	push	offset c_w_name
	push	WS_EX_CLIENTEDGE
	call	CreateWindowEx
	push	eax			; для pop esi перед message_loop
	push	eax
	push	SW_SHOWNORMAL
	push	eax
	call	ShowWindow
	call	UpdateWindow
; инициализируем акселераторы
	push	ID_ACCEL
	push	esi
	call	LoadAccelerators
	mov	h_accel,eax
; цикл ожидания сообщения
	pop	esi		; ESI - идентификатор основного окна
	mov	edi,offset msg_	; EDI - структура с сообщением от него
message_loop:
	push	ebx
	push	ebx
	push	ebx
	push	edi
	call	GetMessage		; получим сообщение
	test	eax,eax			; если это WM_QUIT
	jz	exit_msg_loop		; выйти из цикла
	push	edi
	push	h_accel
	push	esi			; hWnd
	call	TranslateAccelerator	; преобразуем акселераторы в IDM*
	test	eax,eax
	jnz	message_loop
	push	edi
	call	TranslateMessage	; преобразуем сообщения от клавиш
	push	edi
	call	DispatchMessage		; и отошлём обратно
	jmp short message_loop
exit_msg_loop:
	push	msg_.wParam
	call	ExitProcess		; конец программы

; процедура win_proc
; 
; процедура не должна изменять регистры EBP,EDI,ESI и EBX !
win_proc proc near
; параметры (с учётом push ebp)
 wp_hWnd equ dword ptr [ebp+08h]
 wp_uMsg equ dword ptr [ebp+0Ch]
 wp_wParam equ dword ptr [ebp+10h]
 wp_lParam equ dword ptr [ebp+14h]
; инициализируем стековый кадр
	push	ebp
	mov	ebp,esp		; создадим стековый кадр
	pusha			; сохраним все регистры
	xor	ebx,ebx		; 0 для команд push 0
	mov	esi,wp_hWnd	; для команд push hWnd
	mov	eax,wp_uMsg
; обработаем пришедшее сообщение
	cmp	eax,WM_CREATE
	je	h_wm_create
	cmp	eax,WM_SIZE
	je	h_wm_size
	cmp	eax,WM_DESTROY
	je	h_wm_destroy
	cmp	eax,WM_COMMAND
	je	h_wm_command
	cmp	eax,WM_ACTIVATE
	je	h_wm_activate
	cmp	eax,WM_CLOSE
	je	h_wm_close
def_proc:
	popa
	leave			; если это ненужное сообщение
	jmp	DefWindowProc	; оставить его обработчику по умолчанию

;
; обработчик WM_CLOSE
; если нужно, спрашивает, сохранить ли файл
h_wm_close:
	call	save_contents
	jmp short def_proc

;
; обработчик WM_CREATE
;
h_wm_create:
; здесь также можно создать toolbar и statusbar
; создадим окно редактора
	push	ebx
	push	wc.hInstance	; идентификатор основной программы
	push	EditID
	push	esi		; hWnd
	push	ebx		; 0
	push	ebx		; 0
	push	ebx		; 0
	push	ebx		; 0
	push	WS_VISIBLE or WS_CHILD or ES_LEFT or ES_MULTILINE or ES_AUTOHSCROLL or ES_AUTOVSCROLL
	push	ebx		; 0
	push	offset edit_class
	push	ebx		; 0
	call	CreateWindowEx
	mov	h_editwindow,eax
; передадим ему фокус
	push	eax
	call	SetFocus
	cmp	flag_untitled,1
	je	continue_create
	call	skip_getopen	; откроем файл, указанный в командной строке
continue_create:
	call	set_title
	jmp end_wm_check

;
; обработчик WM_COMMAND
;
h_wm_command:
	mov	eax,wp_wParam
	cwde			; low word contains IDM_*
	sub	eax,100h
	jb	def_proc
; обработаем сообщения от пунктов меню
	call dword ptr menu_handlers[eax*4]
	jmp end_wm_check

menu_handlers	dd offset h_idm_new,offset h_idm_open,offset h_idm_save
		dd offset h_idm_saveas,offset h_idm_exit,offset h_idm_about
		dd offset h_idm_undo, offset h_idm_cut, offset h_idm_copy
		dd offset h_idm_paste, offset h_idm_clear, offset h_idm_setsel
; сообщения от пунктов меню должны быть описаны в win95pad.rc именно в таком
; порядке - от IDM_NEW 100h до IDM_CLEAR 10Ah

h_idm_setsel:
	push	-1		; -1
	push	ebx		; 0 
	push	EM_SETSEL	; выделить весь текст
	push	h_editwindow
	call	SendMessage
	ret

; обработчики сообщений из меню EDIT:
h_idm_clear:
	mov	eax,WM_CLEAR
	jmp short send_to_editor
h_idm_paste:
	mov	eax,WM_PASTE
	jmp short send_to_editor
h_idm_copy:
	mov	eax,WM_COPY
	jmp short send_to_editor
h_idm_cut:
	mov	eax,WM_CUT
	jmp short send_to_editor
h_idm_undo:
	mov	eax,EM_UNDO
send_to_editor:
	push	ebx	; 0
	push	ebx	; 0
	push	eax
	push	h_editwindow
	call	SendMessage
	ret

; обработчик IDM_NEW
h_idm_new:
	call	save_contents	; запишем файл если нужно
	mov	byte ptr flag_untitled,1
	call	set_title	; отметим что файл не назван
	push	ebx
	push	ebx
	push	WM_SETTEXT
	push	h_editwindow
	call	SendMessage	; пошлём пустой WM_SETTEXT редактору
	ret

; обработчик IDM_ABOUT
h_idm_about:
	push	ebx		; 0
	push	offset about_proc
	push	esi		; hWnd
	push	ID_ABOUT
	push	wc.hInstance
	call	DialogBoxParam
	ret

; обработчик IDM_SAVEAS и IDM_SAVE
h_idm_save:
	cmp	flag_untitled,1	; если файл назван
	jne	skip_getsave	; пропустим вызов GetSaveFileName
h_idm_saveas:
; спросим имя файла
	mov	ofn.Flags,OFN_EXPLORER or OFN_OVERWRITEPROMPT
	push	offset ofn
	call	GetSaveFileName
	test	eax,eax
	jz	file_save_failed
skip_getsave:
; создадим его
	push	ebx
	push	FILE_ATTRIBUTE_ARCHIVE
	push	CREATE_ALWAYS
	push	ebx
	push	FILE_SHARE_READ or FILE_SHARE_WRITE
	push	GENERIC_READ or GENERIC_WRITE
	push	offset buffer
	call	CreateFile
	mov	edi,eax
; выделим память
	push	MEMSIZE
	push	GMEM_MOVEABLE or GMEM_ZEROINIT
	call	GlobalAlloc
	push	eax		; hMemory для GlobalFree
	push	eax		; hMemory для GlobalLock
	call	GlobalLock
	mov	esi,eax		; адрес буфера в ESI
; заберём текст из редактора
	push	esi
	push	MEMSIZE-1
	push	WM_GETTEXT
	push	h_editwindow
	call	SendMessage
; запишем в файл
	push	esi		; pMemory
	call	lstrlen	
	push	ebx
	push	offset SizeReadWrite
	push	eax		; размер буфера
	push	esi		; адрес буфера
	push	edi		; идентификатор файла
	call	WriteFile
	push	esi		; pMemory
	call	GlobalUnlock
	call	GlobalFree	; hMemory уже в стеке
	push	edi		; идентификатор файла
	call	CloseHandle
; сбросим флаг модификации в редакторе
	push	ebx
	push	ebx
	push	EM_SETMODIFY
	push	h_editwindow
	call	SendMessage
	mov	byte ptr flag_untitled,0
	call	set_title
file_save_failed:
	push	h_editwindow
	call	SetFocus
	ret

; обработчик IDM_OPEN
h_idm_open:
	call	save_contents
; вызовем стандартный диалог выбора имени файла
	mov	ofn.Flags, OFN_FILEMUSTEXIST or OFN_PATHMUSTEXIST or OFN_EXPLORER
	push	offset ofn
	call	GetOpenFileName
	test	eax,eax
	jz	file_open_failed
skip_getopen:
; откроем выбранный файл
	push	ebx
	push	FILE_ATTRIBUTE_ARCHIVE
	push	OPEN_EXISTING
	push	ebx
	push	FILE_SHARE_READ or FILE_SHARE_WRITE
	push	GENERIC_READ or GENERIC_WRITE
	push	offset buffer
	call	CreateFile
	mov	edi,eax		; идентификатор для ReadFile
; выделим память
	push	MEMSIZE
	push	GMEM_MOVEABLE or GMEM_ZEROINIT
	call	GlobalAlloc
	push	eax		; hMemory для GlobalFree
	push	eax		; hMemory для GlobalLock
	call	GlobalLock		; получим адрес выделенной памяти
	push	eax		; pMemory для GlobalUnlock
	push	eax		; pMemory для SendMessage
; прочитаем файл
	push	ebx
	push	offset SizeReadWrite
	push	MEMSIZE-1
	push	eax		; pMemory для ReadFile
	push	edi
	call	ReadFile
; пошлём окну редактора сообщение wm_settext чтобы он забрал текст из буфера
	push	ebx		; pMemory уже в стеке
	push	WM_SETTEXT
	push	h_editwindow
	call	SendMessage
; а теперь можно закрыть файл и освободить память
	call	GlobalUnlock	; pMemory уже в стеке
	call	GlobalFree	; hMemory уже в стеке
	push	edi		; hFile
	call	CloseHandle	;
	mov	byte ptr flag_untitled,0
	call	set_title
file_open_failed:
	push	h_editwindow
	call	SetFocus
	ret

; обработчик IDM_EXIT
h_idm_exit:
	call	save_contents
	push	esi		; hWnd
	call	DestroyWindow	; уничтожить наше окно
	ret

;
; обработчик WM_SIZE
;
h_wm_size:
; здесь также надо послать WM_SIZE окнам toolbar и statusbar
; изменим размер окна редактора так чтобы оно по-прежнему было на всё окно
	push	offset rec
	push	esi		; hWnd
	call	GetClientRect
	push	1		; true
	push	rec.bottom	; height
	push	rec.right	; width
	push	ebx		; y
	push	ebx		; x
	push	h_editwindow
	call	MoveWindow
	jmp short end_wm_check

;
; обработчик WM_ACTIVATE
;
h_wm_activate:
	push	h_editwindow
	call	SetFocus
	jmp short end_wm_check
;
; обработчик WM_DESTROY
;
h_wm_destroy:
	push	ebx
	call	PostQuitMessage	; послать WM_QUIT основной программе

end_wm_check:
	popa
        xor    eax,eax	; вернуть 0
	leave
	ret	16

; процедура set_title
; устанавливает новый заголовок для основного окна
set_title:
	push	esi
	push	edi
	mov	edi,offset window_title
	cmp	byte ptr flag_untitled,1	; если у файла нет имени
	je	untitled			; использовать Untitled
	mov	esi,ofn.lpstrFile	; [ESI] - имя файла с путём
	movzx	eax,ofn.nFileOffset	; eax - начало имени файла
	add	esi,eax
copy_filename:
	lodsb		; скопирем файл побайтово в название окна
	test	al,al
	jz	add_progname	; пока не встретится ноль
	stosb
	jmp short copy_filename
add_progname:
	mov	dword ptr [edi],'  - '	; припишем минус
	add	edi,3
	mov	esi,offset c_w_name
	mov	ecx,9			; и название программы
	rep movsb
	pop	edi
	pop	esi
	push	offset window_title
	push	esi		; идентификатор окна
	call	SetWindowText
	ret

untitled:
	mov	dword ptr [edi],'itnU'	; допишем "Unti"
	mov	dword ptr [edi+4],'delt' ; допишем "tled"
	add	edi,8
	jmp short add_progname


; процедура save_contents
; EBX=0, ESI=hWnd
save_contents:
; спросим редактор, изменялся ли текст
	push	ebx
	push	ebx
	push	EM_GETMODIFY
	push	h_editwindow
	call	SendMessage
	test	eax,eax
	jz	not_modified
; спросим пользователя, сохранять ли его
	push	MB_YESNO + MB_ICONWARNING
	push	offset c_w_name
	push	offset changes_msg
	push	esi
	call	MessageBox
	cmp	eax,IDYES
	jne	not_modified
; сохраним его
	call	h_idm_save
not_modified:
	ret

win_proc endp

about_proc proc near
; параметры (с учётом push ebp)
 ap_hDlg equ dword ptr [ebp+08h]
 ap_uMsg equ dword ptr [ebp+0Ch]
 ap_wParam equ dword ptr [ebp+10h]
 ap_lParam equ dword ptr [ebp+14h]
	push	ebp
	mov	ebp,esp		; создадим стековый кадр
	cmp	ap_uMsg,WM_COMMAND
	jne	dont_proceed
	cmp	ap_wParam,IDOK
	jne	dont_proceed
	push	1
	push	ap_hDlg
	call	EndDialog
dont_proceed:
	xor	eax,eax	; not processed
	leave
	ret 16
about_proc endp

	end	_start
