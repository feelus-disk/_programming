; kbdext.asm
; драйвер символьного устройства, увеличивающий буфер клавиатуры до BUF_SIZE 
; (256 по умолчанию) символов
;
; Компиляция:
; TASM:
; tasm /m kbdext.asm
; tlink /x kbdext.obj
; exe2bin kbdext.exe kbdext.sys
; MASM:
; ml /c kbdext.asm
; link kbdext.obj,,NUL,,,
; exe2bin kbdext.exe kbdext.sys
; WASM:
; wasm kbdext.asm
; wlink file kbdext.obj name kbdext.sys form DOS com
;
BUF_SIZE	equ	256		; новый размер буфера

	.model	tiny
	.186			; для сдвигов и push 0040h
	.code
	org	0		; драйвер начинается с CS:0000
start:
; заголовок драйвера
	dd	-1		; адрес следующего драйвера - FFFFh:FFFFh
				; для последнего
	dw	8000h		; атрибуты: символьное устройство, ничего не 
				; поддерживает
	dw	offset strategy	; адрес процедуры стратегии
	dw	offset interrupt	; адрес процедуры прерывания
	db	'$$KBDEXT'	; имя устройства (не должно совпадать с 
				; каким-нибудь именем файла)

request	dd	?	; здесь процедура стратегии сохраняет адрес 
			; буфера запроса 
buffer	db	BUF_SIZE*2 dup (?) ; а это - наш новый буфер 
				; клавиатуры размером BUF_SIZE символов (два 
				; байта на символ)

; процедура стратегии
; на входе ES:BX = адрес буфера запроса
strategy	proc	far
	mov	cs:word ptr request,bx		; сохранить этот адрес для
	mov	cs:word ptr request+2,es	; процедуры прерывания
	ret
strategy	endp

; процедура прерывания
interrupt	proc	far
	push	ds			; сохранить регистры
	push	bx
	push	ax
	lds	bx,dword ptr cs:request ; DS:BX - адрес запроса
	mov	ah,byte ptr [bx+2]	; прочитать номер команды,
	or	ah,ah			; если команда 00h (инициализация),
	jnz	exit
	call	init			; обслужить ее,
					; иначе:
exit:	mov	ax,100h			; установить бит 8 (команда обслужена)
	mov	word ptr [bx+3],ax	; в слове состояния драйвера
	pop	ax			; и восстановить регистры
	pop	bx
	pop	ds
	ret
interrupt	endp


; процедура инициализации
; вызывается только раз при загрузке драйвера
init	proc	near
	push	cx
	push	dx

	mov	ax,offset buffer
	mov	cx,cs		; CX:AX - адрес нашего буфера клавиатуры
	cmp	cx,1000h	; если CX слишком велик,
	jnc	too_big	; не надо загружаться,
	shl	cx,4		; иначе: умножить сегментный адрес на 16,
	add	cx,ax		; добавить смещение - получился линейный адрес
	sub	cx,400h	; вычесть линейный адрес начала данных BIOS

	push	0040h
	pop	ds
	mov	bx,1Ah			; DS:BX = 0040h:001Ah - адрес головы
	mov	word ptr [bx],cx	; записать новый адрес головой буфера
	mov	word ptr [bx+2],cx	; он же новый адрес хвоста
	mov	bl,80h			; DS:BX = 0040h:0080h - адрес начала буфера
	mov	word ptr [bx],cx	; записать новый адрес начала
	add	cx,BUF_SIZE*2		; добавить размер
	mov	word ptr [bx+2],cx	; и записать новый адрес конца

	mov	ah,9			; функция DOS 09h
	mov	dx,offset succ_msg	; DS:DX - адрес строки
	push	cs			; с сообщением об успешной установке
	pop	ds
	int	21h			; вывод строки на экран

	lds	bx,dword ptr cs:request	; DS:BX - адрес запроса
	mov	ax,offset init
	mov	word ptr [bx+0Eh],ax	; CS:AX - следующий байт после
	mov	word ptr [bx+10h],cs	; конца резидентной части
	jmp short done			; конец процедуры инициализации

; сюда передается управление, если мы загружены слишком низко в памяти
too_big:
	mov	ah,9			; функция DOS 09h
	mov	dx,offset fail_msg	; DS:DX - адрес строки
	push	cs			; с сообщением о неуспешной
	pop	ds			; установке
	int	21h			; вывод строки на экран

	lds	bx,dword ptr cs:request	; DS:BX - адрес запроса
	mov	word ptr [bx+0Eh],0	; записать адрес начала драйвера
	mov	word ptr [bx+10h],cs	; в поле "адрес первого 
					; освобождаемого байта"
done:	pop	dx
	pop	cx
	ret
init	endp
; сообщение об успешной установке
succ_msg	db	'Keyboard extender loaded',0Dh,0Ah,'$'
; сообщение о неуспешной установке
fail_msg	db	'Too many drivers in memory - '
		db	'put kbdext.sys first '
		db	'in config.sys',0Dh,0Ah,'$'
	end	start
