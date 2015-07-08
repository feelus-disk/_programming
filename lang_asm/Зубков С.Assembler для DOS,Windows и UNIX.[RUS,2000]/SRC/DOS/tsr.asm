; tsr.asm
; Пример пассивной резидентной программы
; Запрещает удаление файлов на диске, указанном в командной строке, всем 
; программам, использующим средства DOS
;
; Компиляция:
; TASM:
;  tasm /m tsr.asm
;  tlink /t /x tsr.obj
; MASM:
;  ml /c tsr.asm
;  link tsr.obj,,NUL,,,
;  exe2bin tsr.exe tsr.com
; WASM:
;  wasm tsr.asm
;  wlink file tsr.obj form DOS COM


	.model	tiny
	.code
	org	2Ch
envseg	dw	?	; сегментный адрес копии окружения DOS
	org	80h
cmd_len	db	?	; длина командной строки
cmd_line	db	?	; начало командной строки
	org	100h		; COM-программа

start:
old_int21h:
	jmp short initialize ; эта команда занимает 2 байта, так что
	dw	0		; вместе с этими двумя байтами получим
				; old_int21h dd ?
int21h_handler	proc	far	; обработчик прерывания 21h
	pushf			; сохранить флаги
	cmp	ah,41h	; Если вызвали функцию 41h (удалить 
	je	fn41h	; файл)
	cmp	ax,7141h ; или 7141h (удалить файл с длинным именем)
	je	fn41h		; начать наш обработчик,
	jmp short not_fn41h	; иначе - передать управление 
				; предыдущему обработчику
fn41h:
	push	ax		; сохранить модифицируемые
	push	bx		; регистры
	mov	bx,dx
	cmp	byte ptr ds:[bx+1],':' ; если второй символ
				; ASCIZ-строки, переданной INT 21h,
				; двоеточие - первый символ должен быть 
				; именем диска,
	je	full_spec
	mov	ah,19h	; иначе: 
	int	21h		; функция DOS 19h - определить текущий 
				; диск
	add	al,'A'	; преобразовать номер диска к заглавной 
			; букве
	jmp short compare	; перейти к сравнению
full_spec:
	mov	al,byte ptr [bx] ; AL = имя диска из ASCIZ-строки
	and	al,11011111b ; преобразовать к заглавной букве
compare:
	cmp	al,byte ptr cs:cmd_line[1] ; если диски
	je	access_denied	; совпадают - запретить доступ,
	pop	bx			; иначе: восстановить
	pop	ax			; регистры
not_fn41h:
	popf				; и флаги
	jmp	dword ptr cs:old_int21h	; и передать управление 
					; предыдущему обработчику INT 21h
access_denied:
	pop	bx		; восстановить регистры
	pop	ax
	popf
	push	bp
	mov	bp,sp
	or	word ptr [bp+6],1	; установить флаг переноса
			; (бит 0) в регистре флагов, который поместила 
			; команда INT в стек перед адресом возврата
	pop	bp
	mov	ax,5		; возвратить код ошибки
				; "доступ запрещен"
	iret			; вернуться в программу
int21h_handler	endp

initialize	proc near
	cmp	byte ptr cmd_len,3 ; проверить размер командной строки
	jne	not_install	; (должно быть 3 - пробел, диск, двоеточие)
	cmp	byte ptr cmd_line[2],':' ; проверить третий символ 
	jne	not_install	; командной строки (должно быть двоеточие)
	mov	al,byte ptr cmd_line[1]
	and	al,11011111b	; преобразовать второй
				; символ к заглавной букве
	cmp	al,'A'		; проверить, что это не
	jb	not_install		; меньше 'A' и не больше
	cmp	al,'Z'		; 'Z'
	ja	not_install		; если хоть одно из этих условий
	; не выполняется - выдать информацию о программе и выйти,
	; иначе - начать процедуру инициализации

	mov	ax,3521h		; AH = 35h, AL = номер прерывания
	int	21h			; получить адрес обработчика INT 21h
	mov	word ptr old_int21h,bx	; и поместить его в old_int21h
	mov	word ptr old_int21h+2,es

	mov	ax,2521h		; AH = 25h, AL = номер прерывания
	mov	dx,offset int21h_handler ; DS:DX - адрес нашего 
					; обработчика
	int	21h			; установить обработчик INT 21h

	mov	ah,49h		; AH = 49h
	mov	es,word ptr envseg ; ES = сегментный адрес блока с нашей 
				; копией окружения DOS
	int	21h			; освободить память из-под окружения

	mov	dx,offset initialize ; DX - адрес первого байта за концом
					; резидентной части программы
	int	27h			; завершить выполнение, оставшись 
					; резидентом

not_install:
	mov	ah,9			; AH = 09h
	mov	dx,offset usage	; DS:DX = адрес строки с информацией об 
					; использовании программы
	int	21h			; вывод строки на экран
	ret				; нормальное завершение программы

; текст, который выдает программа при запуске с неправильной командной строкой:
usage	db	'Usage: tsr.com D:',0Dh,0Ah
	db	'Denies delete on drive D:',0Dh,0Ah
	db	'$'

initialize	endp
	end	start
