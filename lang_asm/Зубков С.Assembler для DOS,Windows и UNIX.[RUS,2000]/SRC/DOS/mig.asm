; mig.asm
; циклически переключает светодиоды клавиатуры
;
; Компиляция:
; TASM:
; tasm /m mig.asm
; tlink /t /x mig.obj
; MASM:
; ml /c mig.asm
; link mig.obj,,NUL,,,
; exe2bin mig.exe mig.com
; WASM:
; wasm mig.asm
; wlink file mig.obj form DOS COM
;


	.model	tiny
	.code
org	100h		; COM-программа

start	proc near
	mov	ah,2		; функция 02 прерывания 1Ah
	int	1Ah		; получить текущее время
	mov	ch,dh		; сохранить текущую секунду в CH
	mov	cl,0100b	; CL = состояние светодиодов клавиатуры

main_loop:
	call	change_LEDs	; установить светодиоды в соответствии с CL

	shl	cl,1		; следующий светодиод,
	test	cl,1000b	; если единица вышла в бит 3,
	jz	continue
	mov	cl,0001b		; вернуть ее в бит 0,
continue:
	mov	ah,1		; проверить, не была ли нажата клавиша,
	int	16h
	jnz	exit_loop	; если да - выйти из программы
	push	cx
	mov	ah,2		; функция 02 прерывания 1Ah
	int	1Ah		; получить текущее время
	pop	cx
	cmp	ch,dh		; сравнить текущую секунду в DH с CH
	mov	ch,dh		; скопировать ее в любом случае,
	je	continue	; если это была та же самая секунда - не 
; переключать светодиоды,
	jmp short main_loop	; иначе - переключить светодиоды

exit_loop:
	mov	ah,0		; выход из цикла - была нажата клавиша
	int	16h		; считать ее
	ret			; и завершить программу
start	endp

; процедура change_LEDs
; устанавливает состояние светодиодов клавиатуры в соответствии с числом в CL
change_LEDs	proc	near
	call	wait_KBin	; ожидание возможности посылки команды
	mov	al,0EDh
	out	60h,al	; команда клавиатуры EDh
	call	wait_KBin	; ожидание возможности посылки команды 
	mov	al,cl
	out	60h,al	; новое состояние светодиодов
	ret
change_LEDs	endp

; процедура wait_KBin
; ожидание возможности ввода команды для клавиатуры
wait_KBin	proc	near
	in	al,64h	; прочитать слово состояния
	test	al,0010b	; бит 1 равен 1?
	jnz	wait_KBin	; если нет - ждать,
	ret			; если да - выйти
wait_KBin	endp
	end	start
