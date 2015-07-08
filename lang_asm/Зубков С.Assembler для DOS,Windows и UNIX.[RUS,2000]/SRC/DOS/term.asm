; term.asm
; Простая терминальная программа для модема на COM2. Выход по alt-X
;
; Компиляция:
; TASM:
;  tasm /m term.asm
;  tlink /t /x term.obj
; MASM:
;  ml /c term.asm
;  link term.obj,,NUL,,,
;  exe2bin term.exe term.com
; WASM:
;  wasm term.asm
;  wlink file term.obj form DOS COM
;


	.model	tiny
	.code
	org 100h	; Начало COM-файла
start:
	mov	ah,0			; инициализировать порт
	mov	al,11100011b	; 9600/8n1
	mov	dx,1			; порт COM2
	int	14h

main_loop:
	mov	ah,2
	int	14h		; получить байт от модема
	test	ah,ah		; если что-нибудь получено,
	jnz	no_input
	int	29h		; вывести его на экран
no_input:			; иначе:
	mov	ah,1
	int	16h		; проверить, была ли нажата клавиша,
	jz	main_loop	; если да:
	mov	ah,8
	int	21h		; считать ее код (без отображения на экране),
	test	al,al		; если это нерасширенный ASCII-код,
	jnz	send_char	; перейти к посылке его в модем,
	int	21h		; иначе - получить расширенный ASCII-код,
	cmp	al,2Dh	; если это alt-X,
	jne	send_char
	ret			; завершить программу
send_char:
	mov	ah,1
	int	14h		; послать введенный символ в модем
	jmp short main_loop	; продолжить основной цикл

	end start
