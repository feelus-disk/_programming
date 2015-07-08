; shell.asm
; программа, выполняющая функции командного интерпретатора
; (вызывающая command.com для всех команд, кроме exit). Для краткости строка 
;
; Компиляция:
; TASM:
;  tasm /m shell.asm
;  tlink /t /x shell.obj
; MASM:
;  ml /c shell.asm
;  link shell.obj,,NUL,,,
;  exe2bin shell.exe shell.com
; WASM:
;  wasm shell.asm
;  wlink file shell.obj form DOS COM
;

	.model	tiny
	.code
	.186
	org	100h		; COM-программа

prompt_end	equ	'$'	; последний символ в приглашении к вводу

start:
	mov	sp,length_of_program+100h+200h ; перемещение стека на 200h
		; после конца программы (дополнительные 100h - для PSP)

	mov	ah,4Ah
stack_shift=length_of_program+100h+200h
	mov	bx,stack_shift shr 4+1
	int	21h	; освободим всю память после конца программы и стека

; заполним поля EPB, содержащие сегментные адреса
	mov	ax,cs
	mov	word ptr EPB+4,ax	; сегментный адрес командной строки
	mov	word ptr EPB+8,ax	; сегментный адрес первого FCB
	mov	word ptr EPB+0Ch,ax ; сегментный адрес второго FCB

main_loop:

; построение и вывод приглашения для ввода

	mov	ah,19h		; Функция DOS 19h
	int	21h			; определить текущий диск
	add	al,'A'		; теперь AL = ASCII-код диска (A, B, C...)
	mov	byte ptr drive_letter,al ; поместить его в строку
	mov	ah,47h		; Функция DOS 47h
	mov	dl,00
	mov	si,offset pwd_buffer
	int	21h			; определить текущую директорию
	mov	al,0			; найти ноль (конец текущей директории)
	mov	di,offset prompt_start	; в строке с приглашением
	mov	cx,prompt_l
	repne scasb
	dec	di			; DI - адрес байта с нулем

	mov	dx,offset prompt_start	; DS:DX - строка приглашения
	sub	di,dx			; DI - длина строки приглашения
	mov	cx,di
	mov	bx,1			; stdout
	mov	ah,40h
	int	21h			; вывод строки в файл или устройство
	mov	al,prompt_end
	int	29h		; вывод последнего символа в приглашении

; получить команду от пользователя
	mov	ah,0Ah		; Функция DOS 0Ah
	mov	dx,offset command_buffer
	int	21h			; буферированный ввод

	mov	al,0Dh		; вывод символа CR
	int	29h
	mov	al,0Ah		; вывод символа LF
	int	29h			; (CR и LF вместе - перевод строки)

	cmp	byte ptr command_buffer+1,0 ; если введена пустая строка,
	je	main_loop		; продолжить основной цикл

; проверить, является ли введенная команда командой 'exit'

	mov	di,offset command_buffer+2 ; адрес введенной строки
	mov	si,offset cmd_exit ; адрес эталонной строки 'exit',0Dh
	mov	cx,cmd_exit_l	; длина эталонной строки
	repe cmpsb			; сравнить строки
	jcxz	got_exit		; если строки идентичны - выполнить exit

; передать остальные команды интерпретатору DOS (COMMAND.COM)
	xor	cx,cx
	mov	si,offset command_buffer+2 ; адрес введенной строки
	mov	di,offset command_text	; параметры для command.com
	mov	cl,byte ptr command_buffer+1 ; размер введенной строки
	inc	cl			; учесть 0Dh в конце
	rep movsb			; скопировать строку
	mov	ax,4B00h		; функция DOS 4Bh
	mov	dx,offset command_com	; адрес ASCIZ-строки с адресом
	mov	bx,offset EPB
	int	21h			; исполнить программу

	jmp short main_loop	; продолжить основной цикл
got_exit:
	int	20h			; выход из программы (ret нельзя, потому 
					; что мы перемещали стек)

cmd_exit	db	'exit',0Dh	; команда 'exit'
cmd_exit_l	equ	$-cmd_exit	; ее длина

prompt_start	db	'tinyshell:'	; подсказка для ввода
drive_letter	db	'C:'
pwd_buffer	db	64 dup (?)	; буфер для текущей директории
prompt_l	equ $-prompt_start ; максимальная длина подсказки

command_com	db	'C:\COMMAND.COM',0	; имя файла

EPB		dw	0000	; использовать текущее окружение
		dw	offset commandline,0 ; адрес командной строки
		dw	005Ch,0,006Ch,0 ; адреса FCB, переданных DOS 
					; нашей программе при запуске (на самом деле
					; они не используются)

commandline	db	125		; максимальная длина командной строки
		db	' /C '	; ключ /C для COMMAND.COM
command_text	db	122 dup (?)	; буфер для командной строки

command_buffer	db 122	; здесь начинается буфер для ввода
length_of_program equ 124+$-start	; длина программы + длина 
					; буфера для ввода
	end	start
