; rot13.asm
; Драйвер символьного устройства, выводящий посылаемые ему символы на экран
; после выполнения над ними преобразования ROT13.
; (каждая буква английского алфавита смещается на 13 позиций)
; Реализованы только функции записи в устройство
; 
; Пример использования:
; copy encrypted.txt $rot13
;
; Компиляция:
; TASM:
;  tasm /m rot13.asm
;  tlink /x rot13.obj
; MASM:
;  ml /c rot13.asm
;  link rot13.obj
; WASM:
;  wasm rot13.asm
;  wlink file rot13.obj form DOS
;
;
; загрузка - из CONFIG.SYS
; DEVICE=c:\rot13.exe
; если rot13.exe находится в директории C:\
;
	.model small	; модель для EXE-файла
	.code
	.186		; для pusha/popa
	org	0	; код драйвера начинается с CS:0000
	dd	-1	; адрес следующего драйвера
	dw	0A800h	; атрибуты нашего устройства
	dw	offset strategy	; адрес процедуры стратегии 
	dw	offset interrupt	; адрес процедуры прерывания
	db	'$ROT13',20h,20h	; имя устройства, дополненное 
					; пробелами до восьми символов

request	dd	?	; сюда процедура стратегии будет писать адрес 
			; буфера запроса

; таблица адресов обработчиков для всех команд
command_table	dw	offset init			; 00h
		dw	3 dup(offset unsupported)	; 01, 02, 03
		dw	2 dup(offset read)		; 04, 05
		dw	2 dup(offset unsupported)	; 06, 07
		dw	2 dup(offset write)		; 08h, 09h
		dw	6 dup(offset unsupported)	; 0Ah, 0Bh, 0Ch, 0Dh, 0Eh, 0Fh
		dw	offset write			; 10h
		dw	2 dup(offset invalid)		; 11h, 12h
		dw	offset unsupported 		; 13h
		dw	3 dup(offset invalid)		; 14h, 15h, 16h
		dw	3 dup(offset unsupported)	; 17h, 18h, 19h

; процедура стратегии - одна и та же для всех драйверов
strategy proc far
	mov	word ptr cs:request,bx
	mov	word ptr cs:request+2,es
	ret
strategy endp

; процедура прерывания
interrupt	proc	far
	pushf
	pusha			; сохранить регистры
	push	ds		; и на всякий случай флаги
	push	es

	push	cs
	pop	ds		; DS = наш сегментный адрес
	les	si,dword ptr request	; ES:SI = адрес буфера запроса
	xor	bx,bx
	mov	bl,byte ptr es:[si+2]	; BX = номер функции
	cmp	bl,19h	; проверить, что команда в пределах 00 - 19h,
	jbe	command_ok
	call	invalid	; если нет - выйти с ошибкой
	jmp short interrupt_end
command_ok:			; если команда находится в пределах 00 - 19h,
	shl	bx,1		; умножить ее на 2, чтобы получить смещение в 
; таблице слов command_table,
	call	word ptr command_table[bx]	; и вызвать обработчик
interrupt_end:
	cmp	al,0		; AL = 0, если не было ошибок,
	je	no_error
	or	ah,80h	; если была ошибка - установить бит 15 в AX,
no_error:
	or	ah,01h	; в любом случае установить бит 8
	mov	word ptr es:[si+3],ax	; и записать слово состояния 
	pop	es
	pop	ds
	popa
	popf
	ret
interrupt	endp

; обработчик команд, предназначенных для блочных устройств
unsupported	proc	near
	xor	ax,ax	; не возвращать никаких ошибок
	ret
unsupported	endp

; обработчик команд чтения
read	proc	near
	mov	al,0Bh	; общая ошибка чтения
	ret
read	endp

; обработчик несуществующих команд
invalid	proc	near
	mov	ax,03h	; ошибка "неизвестная команда"
	ret
invalid	endp

; обработчик функций записи
write	proc	near
	push	si
	mov	cx,word ptr es:[si+12h]	; длина буфера в CX,
	jcxz	write_finished	; если это 0 - нам делать нечего
	lds	si,dword ptr es:[si+0Eh] ; адрес буфера в DS:SI

; выполнить ROT13-преобразование над буфером
	cld
rot13_loop:			; цикл по всем символам буфера
	lodsb			; AL = следующий символ из буфера в ES:SI

	cmp	al,'A'		; если он меньше 'A',
	jl	rot13_done		; это не буква,
	cmp	al,'Z'		; если он больше 'Z',
	jg	rot13_low		; может быть, это маленькая буква,
	cmp	al,('A'+13)		; иначе: если он больше 'A' + 13,
	jge	rot13_dec		; вычесть из него 13,
	jmp short rot13_inc	; 	а иначе - добавлять
rot13_low:
	cmp	al,'a'		; если символ меньше 'a',
	jl	rot13_done		; это не буква,
	cmp	al,'z'		; если символ больше 'z',
	jg	rot13_done		; то же самое,
	cmp	al,('a'+13)		; иначе: если он больше 'a' + 13,
	jge	rot13_dec		; вычесть из него 13, иначе:
rot13_inc:
	add	al,13		; добавить 13 к коду символа,
	jmp short rot13_done
rot13_dec:
	sub	al,13		; вычесть 13 из кода символа,
rot13_done:
	int	29h		; вывести символ на экран
	loop	rot13_loop	; и повторить для всех символов

write_finished:
	xor	ax,ax		; сообщить, что ошибок не было
	pop	si
	ret
write	endp

; процедура инициализации драйвера
init	proc	near
	mov	ah,9		; функция DOS 09h
	mov	dx,offset load_msg ; DS:DX - сообщение об установке
	int	21h		; вывод строки на экран
	mov	word ptr es:[si+0Eh],offset init ; записать адрес
	mov	word ptr es:[si+10h],cs	; конца резидентной части
	xor	ax,ax		; ошибок не произошло
	ret
init	endp

; сообщение об установке драйвера
load_msg db	'ROT13 device driver loaded',0Dh,0Ah,'$'

start:			; точка входа EXE-программы
	push	cs
	pop	ds
	mov	dx,offset exe_msg	; DS:DX - адрес строки
	mov	ah,9		; функция DOS
	int	21h		; вывод строки на экран
	mov	ah,4Ch	; функция DOS 4Ch
	int	21h		; завершение EXE-программы
; строка, которая выводится при запуске не из CONFIG.SYS
exe_msg	db	'This file is loaded as a device driver from CONFIG.SYS'
	db	0Dh,0Ah,'$'

	.stack

	end	start
