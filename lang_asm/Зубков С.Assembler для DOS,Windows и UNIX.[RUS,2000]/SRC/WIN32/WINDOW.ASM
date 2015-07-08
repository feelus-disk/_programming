; window.asm
; Графическое win32-приложение, демонстрирующее базовый вывод окна
;
; Компиляция MASM
;  ml /c /coff /Cp window.asm
;  link window.obj /subsystem:windows
;
; Компиляция TASM
;  tasm /m /ml /D_TASM_ window.asm
;  tlink32 /Tpe /aa /c /x window.obj
;
; Компиляция WASM
;  wasm window.asm
;  wlink form window.obj form windows nt
;
include def32.inc
include kernel32.inc
include user32.inc
	.386
	.model flat
	.data
class_name	db 'window class 1',0
window_name	db 'win32 assembly example',0
; структура, описывающая класс окна.
wc	WNDCLASSEX <4*12,CS_HREDRAW or CS_VREDRAW,offset win_proc,0,0,?,?,?,COLOR_WINDOW+1,0,offset class_name,0>
	; здесь находятся следующие поля
	; wc.cbSize = 4*12 - размер этой структуры
	; wc.style - стиль окна (перерисовывать при изменении размера)
	; wc.lpfnWndProc - обработчик событий окна (win_proc)
	; wc.cbClsExtra - число дополнительных байтов после структуры (0)
	; wc.cbWndExtra - число дополнительных байтов после окна (0)
	; wc.hInstance - идентификатор нашего процесса (?)
	; wc.hIcon - идентификатор иконки (?)
	; wc.hCursor - идентификатор курсора (?)
	; wc.hbrBackground - идентификатор кисти или цвет фона+1 (COLOR_WINDOW+1)
	; wc.lpszMenuName - ресурс с основным меню (в этом примере - 0)
	; wc.lpszClassName - имя класса (строка class_name)
	; wc.hIconSm - идентификатор маленькой иконки (только в windows 95, для NT должен быть 0)

	.data?
msg_	MSG	<?,?,?,?,?,?>	; а это - структура, в которой возвращается
				; сообщение после GetMessage
	.code
_start:
	xor	ebx,ebx		; в EBX будет 0 для команд push 0 (короче в 2 раза)
; определим идентификатор нашей программы
	push	ebx
	call	GetModuleHandle
	mov	esi,eax		; и сохраним его в ESI
; заполним и зарегестрируем класс
	mov	dword ptr wc.hInstance,eax ; идентификатор предка
  ; выберем иконку
	push	IDI_APPLICATION	; стандартная иконка приложения
	push	ebx		; идентификатор модуля с иконкой
	call	LoadIcon
	mov	wc.hIcon,eax	; идентификатор иконки для нашего класса
  ; выберем форму курсора
	push	IDC_ARROW	; стандартная стрелка
	push	ebx		; идентификатор модуля с курсором
	call	LoadCursor
	mov	wc.hCursor,eax	; идентификатор курсора для нашего класса
	push	offset wc
	call	RegisterClassEx	; зарегистрируем класс
; создадим окно
	mov	ecx,CW_USEDEFAULT	; push ecx короче push N в пять раз
	push	ebx		; адрес структуры CREATESTRUCT (здесь NULL)
	push	esi		; идентификатор процесса, который будет получать
				; сообщения от окна (то есть, наш)
	push	ebx		; идентификатор меню или окна-потомка
	push	ebx		; идентификатор окна-предка
	push	ecx		; высота (CW_USEDEFAULT - по умолчанию)
	push	ecx		; ширина (по умолчанию)
	push	ecx		; y-координата (по умолчанию)
	push	ecx		; x-координата (по умолчанию)
	push	WS_OVERLAPPEDWINDOW	; стиль окна
	push	offset window_name	; заголовок окна
	push	offset class_name	; любой зарегистрированный класс
	push	ebx		; дополнительный стиль
	call	CreateWindowEx	; создать окно (eax - идентификатор окна)
	push	eax		; идентификатор для UpdateWindow
	push	SW_SHOWNORMAL	; тип показа для для ShowWindow
	push	eax		; идентификатор для ShowWindow
; больше идентификатор окна нам не потребуется
	call	ShowWindow	; показать окно
	call	UpdateWindow	; и послать ему сообщение WM_PAINT

; основной цикл - проверка сообщений от окна и выход по WM_QUIT
	mov	edi,offset msg_ ; push edi короче push N в 5 раз
message_loop:
	push	ebx		; последнее сообщение
	push	ebx		; первое сообщение
	push	ebx		; идентификатор окна (0 - любое наше окно)
	push	edi		; адрес структуры MSG
	call	GetMessage	; получить сообщение от окна с ожиданием
				; - не забывайте использовать PeekMessage
				; если нужно в этом цикле что-то выполнять
	test	eax,eax		; если получено WM_QUIT
	jz	exit_msg_loop	; выйти
	push	edi		; иначе - преобразовать сообщения типа
	call	TranslateMessage ; WM_KEYUP в сообщения типа WM_CHAR
	push	edi
	call	DispatchMessage	; и послать их процедуре окна (иначе его просто
				; нельзя будет закрыть)
	jmp short message_loop	; продолжить цикл 
exit_msg_loop:
; выход из программы
	push	ebx
	call	ExitProcess

;
; процедура win_proc
; вызывается окном каждый раз, когда окно получает какое-нибудь сообщение
; именно здесь будут происходить вся работа программы
;
; процедура не должна изменять регистры EBP,EDI,ESI и EBX !
;
win_proc proc
; так как мы получаем параметры в стеке, построим стековый кадр
	push	ebp
	mov	ebp,esp
; процедура типа WindowProc вызывается со следующими параметрами
		wp_hWnd equ dword ptr [ebp+08h]	; идентификатор окна
		wp_uMsg equ dword ptr [ebp+0Ch]	; номер сообщения
		wp_wParam equ dword ptr [ebp+10h]	; первый параметр
		wp_lParam equ dword ptr [ebp+14h]	; второй параметр
; если мы получили сообщение WM_DESTROY (оно означает что окно уже удалили
; с экрана, нажав alt-F4 или кнопку в верхнем правом углу)
; то пошлём основной программе сообщение WM_QUIT
	cmp	wp_uMsg,WM_DESTROY
	jne	not_wm_destroy
	push	0		; код выхода
	call	PostQuitMessage	; послать WM_QUIT
	jmp short end_wm_check	; и выйти из процедуры
not_wm_destroy:
; если мы получили другое сообщение - вызовем его обработчик по умолчанию
	leave		; восстановим ebp
	jmp	DefWindowProc	; и вызовем DefWindowProc с нашими параметрами
				; и адресом возврата в стеке
end_wm_check:
	leave		; восстановим ebp
	ret 16		; и вернёмся сами, очистив стек от параметров
win_proc endp
        end _start
