; netenum.asm
; Консольное приложение для win32, перечисляющее сетевые ресурсы
;
; Компиляция MASM
;  ml /c /coff /Cp netenum.asm
;  link netenum.obj /subsystem:console
;
; Компиляция TASM
;  tasm /m /x /ml /D_TASM_ netenum.asm
;  tlink32 -Tpe -ap -c netenum.obj
;
; Компиляция WASM
; wasm netenum.asm
; wlink file netenum.obj form windows nt runtime console
;

include def32.inc
include kernel32.inc
include mpr.inc

	.386
	.model flat
	.const
greet_message	db	'Example win32 console program',0Dh,0Ah,0Dh,0Ah,0
error1_message	db	0Dh,0Ah,'Could not get current user name',0Dh,0Ah,0
error2_message	db	0Dh,0Ah,'Could not enumerate',0Dh,0Ah,0
good_exit_msg	db	0Dh,0Ah,0Dh,0Ah,'Normal termination',0Dh,0Ah,0
enum_msg1	db	0Dh,0Ah,'Local ',0
enum_msg2	db	' remote - ',0
	.data
user_name	db	'List of connected resources for user '
user_buff	db	64 dup (?)	; буфер для WNetGetUser
user_buff_l	dd	$-user_buff	; размер буфера для WNetGetUser
enum_buf_l	dd	1056	; длина enum_buf в байтах
enum_entries	dd	1	; число ресурсов, которое в нём помещаются
	.data?
enum_buf	NTRESOURCE <?,?,?,?,?,?,?,?>	; буфер для WNetEnumResource
		dd	256 dup (?)		; 1024 байт для строк
message_l	dd	?		; переменная для WriteConsole
enum_handle	dd	?		; идентификатор для WNetEnumResource
	.code
_start:
; получим от системы одентификатор буфера вывода stdout
	push	STD_OUTPUT_HANDLE
	call	GetStdHandle	; возвращает идентификатор STDOUT в eax
	mov	ebx,eax		; а мы будем хранить его в EBX
; выведем строку greet_message на экран
	mov	esi,offset greet_message
	call	output_string
; определим имя пользователя, которому принадлежит наш процесс
	mov	esi,offset user_buff
	push	offset user_buff_l	; адрес переменной с длиной буфера
	push	esi			; адрес буфера
	push	0			; NULL
	call	WNetGetUser
	cmp	eax,NO_ERROR		; если произошла ошибка
	jne	error_exit1		; выйти
	mov	esi,offset user_name	; иначе - выведем строку на экран
	call	output_string

; начнём перечисление сетевых ресурсов
	push	offset enum_handle	; идентификатор для WNetEnumResource
	push	0
	push	RESOURCEUSAGE_CONNECTABLE ; все присоединяемые ресурсы
	push	RESOURCETYPE_ANY	; ресурсы любого типа
	push	RESOURCE_CONNECTED	; только присоединённые сейчас
	call	WNetOpenEnum		; начать перечисление
	cmp	eax,NO_ERROR		; если произошла ошибка
	jne	error_exit2		; выйти
; цикл перечисления ресурсов
enumeration_loop:
	push	offset enum_buf_l	; длина буфера в байтах
	push	offset enum_buf		; адрес буфера
	push	offset enum_entries	; число ресурсов
	push	dword ptr enum_handle	; идентификатор от WNetOpenEnum
	call	WNetEnumResource
	cmp	eax,ERROR_NO_MORE_ITEMS	; если они закончились
	je	end_enumeration		; завершить перечисление
	cmp	eax,NO_ERROR		; если произошла ошибка
	jne	error_exit2		; выйти с сообщением об ошибке
; вывод информации ресурсе на экран
	mov	esi,offset enum_msg1	; первая часть строки
	call	output_string		; на консоль
	mov	esi,dword ptr enum_buf.lpLocalName ; локальное имя устройства
	call	output_string		; на консоль
	mov	esi,offset enum_msg2	; вторая часть строки
	call	output_string		; на консоль
	mov	esi,dword ptr enum_buf.lpRemoteName ; удалённое имя устройства
	call	output_string		; туда же

	jmp short enumeration_loop	; продолжим перечисление
; конец цикла
end_enumeration:
	push	dword ptr enum_handle
	call	WNetCloseEnum		; конец перечисления

	mov	esi,offset good_exit_msg
exit_program:
	call	output_string		; выведем строку
	push	0		; код выхода
	call	ExitProcess	; конец программы
; выходы после ошибок
error_exit1:
	mov	esi,offset error1_message
	jmp short exit_program
error_exit2:
	mov	esi,offset error2_message
	jmp	short exit_program


; процедрура output_string
; выводит на экран строку
; ввод: esi - адрес строки
;	ebx - идентификатор stdout или другого консольного буфера
output_string proc near
; определим длину строки
	cld
	xor	eax,eax
	mov	edi,esi
	repne	scasb
	dec	edi
	sub	edi,esi
; пошлём её на консоль
	push	0
	push	offset message_l ; сколько байт выведено на консоль
	push	edi		 ; сколько байт надо вывести на консоль
	push	esi		; адрес строки для вывода на консоль
	push	ebx		; идентификатор буфера вывода
	call	WriteConsole	; WriteConsole(hConsoleOutput,lpvBuffer,cchToWrite,lpcchWritten,lpvReserved)
	ret
output_string endp

end	_start



