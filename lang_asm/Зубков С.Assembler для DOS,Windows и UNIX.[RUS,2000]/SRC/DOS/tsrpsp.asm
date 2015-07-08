; tsr.asm
; Пример пассивной резидентной программы с переносом кода в PSP.
; Запрещает удаление файлов на диске, указанном в командной строке всем
; программам, использующим средства DOS
; Резидентная программа занимает в памяти 208 байт
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
;
	.model	tiny
	.code
	org	2Ch
envseg	dw	?		; сегментный адрес копии окружения DOS
	org	80h
cmd_len	db	?		; длина командной строки
cmd_line db	?		; начало командной строки
	org	100h		; COM-программа

start:
	jmp short initialize	; переход инициализирующую часть

int21h_handler	proc	far	; обработчик прерывания 21h
                pushf		; сохраним флаги
		cmp	ah,41h	; если вызвали функцию 41h (удалить файл)
		je	fn41h
		cmp	ax,7141h ; или 7141h (удалить файл с длинным именем)
		je	fn41h	 ; начать наш обработчик
		jmp short not_fn41h ; иначе - передать управление в DOS
fn41h:
		push	ax		; сохраним модифицируемый регистр
		push bx
		mov bx,dx
		cmp	byte ptr [bx+1],':'	; если второй символ
					; ASCIZ-строки, переданной INT 21h
					; двоеточие - значит первый символ -
					; - имя диска.
		je	full_spec
		mov	ah,19h		; иначе: 
		int	21h		; Функция DOS 19h - определить текущий диск
		add	al,'A'		; преобразовать номер диска к заглавной букве
		jmp short compare	; перейти к сравнению
full_spec:
		mov	al,byte ptr [bx] ; AL=имя диска из ASCIZ-строки
		and	al,11011111b	; преобразовать к заглавной букве
compare:
		db	3Ch	; CMP AL, (начало кода команды cmp al,число)
drive_letter	db	'D'	; сюда процедура инициализации запишет нужную
				; букву
		pop	bx
		pop	ax	; AX больше не потребуется
						; если диски совпадают
		je	access_denied		; запретить удаление
not_fn41h:		
		popf				; и флаги
		; и передать управление предыдущему обработчику INT 21h:
		db	0EAh	; JMP FAR (начало кода команды дальнего перехода)
old_int21h	dd	0	; сюда процедура инициализации запишет адрес
				; предыдущего обработчика INT 21h
access_denied:
						; восстановить
		popf				; флаги
		push	bp
		mov	bp,sp
		or	word ptr [bp+6],1	; установить флаг переноса
			; (бит 1) в регистре флагов, который поместила команда
			; INT 21h в стек перед адресом возврата
		pop	bp
		mov	ax,5		; возвратить код ошибки
					; "доступ запрещён"
		iret			; вернуться в программу
int21h_handler	endp

tsr_length equ $-int21h_handler

initialize	proc near
	cmp	byte ptr cmd_len,3 ; проверить размер командной строки
	jne	not_install	; должно быть 3 (пробел, диск, двоеточие)
	cmp	byte ptr cmd_line[2],':' ; проверить третий символ командной
				; строки (должно быть двоеточие)
	jne	not_install
	mov	al, byte ptr cmd_line[1]
	and	al,11011111b	; преобразовать второй символ
						; к заглавной букве
	cmp	al,'A'	; проверить что это не
	jb	not_install			; меньше 'A' и не больше
	cmp	al,'Z'	; 'Z'
	ja	not_install			; если хоть одно из этих
	; условий не выполняется - выдать информацию о программе и выйти
	; иначе - начать процедуру инициализации
	mov	byte ptr drive_letter,al	; передать AL в тело
						; резидента
	push	es
	mov	ax,3521h		; AH=35h, AL=номер прерывания
	int	21h			; получить адрес обработчика INT 21h
	mov	word ptr old_int21h,bx	; и поместить его в тело резидента
	mov	word ptr old_int21h+2,es ;
	pop	es

	cld				; перенос кода резидента
	mov	si,offset int21h_handler ;начиная с этого адреса
	mov	di,80h			; в PSP:0080h
	mov	cx,tsr_length
	rep movsb

	mov	ax,2521h		; AH = 25h, AL=номер прерывания
	mov	dx,80h			; DS:DX - адрес нашего обработчика
					; (который после переноса - PSP:80h)
	int	21h			; установить его

	mov	ah,49h			; AH=49h
	mov	es,word ptr envseg	; ES=сегментный адрес блока с копией
				; переменных среды DOS
	int	21h		; освободить память, используемую этим блоком

	mov	dx,80h+tsr_length	; DX - адрес первого байта за концом
					; резидентной программы
	int	27h			; завершить выполнение, оставшись
					; резидентом

not_install:
	mov	ah,9			; AH=09h
	mov	dx,offset usage		; DS:DX=адрес строки с информацией об
					; использовании программы
	int	21h			; вывод строки на экран
	ret				; обычное завершение программы

; текст, который выдаёт программа при запуске с неправильной командной
; строкой
usage	db	'Usage: tsr.com D:',0Dh,0Ah
	db	'Denies delete on drive D:',0Dh,0Ah
	db	'$'

initialize	endp
	end	start
