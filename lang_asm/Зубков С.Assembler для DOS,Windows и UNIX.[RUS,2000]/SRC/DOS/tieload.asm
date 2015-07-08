; tieload.asm
; Пример полурезидентной программы - загрузчик, устраняющий проверку пароля 
; для игр компании Lucasarts:
; "X-Wing", "X-Wing: Imperial Pursuit", "B-Wing",
; "Tie Fighter", "Tie Fighter: Defender of the Empire"
;
; Компиляция:
; TASM:
;  tasm /m tieload.asm
;  tlink /t /x tieload.obj
; MASM:
;  ml /c tieload.asm
;  link tieload.obj,,NUL,,,
;  exe2bin tieload.exe tieload.com
; WASM:
;  wasm tieload.asm
;  wlink file tieload.obj form DOS COM
;

	.model	tiny
	.code
	.386			; для команды LSS
	org	100h		; COM-программа
start:
; освободить память после конца программы (+ стек)
	mov	sp,length_of_program	; перенести стек
	mov	ah,4Ah		; функция DOS 4Ah
	mov	bx,par_length	; размер в параграфах
	int	21h			; изменить размер выделенной памяти

; заполнить поля EPB, содержащие сегментные адреса
	mov	ax,cs
	mov	word ptr EPB+4,ax
	mov	word ptr EPB+8,ax
	mov	word ptr EPB+0Ch,ax
	
; загрузить программу без выполнения
	mov	bx,offset EPB		; ES:BX - EPB
	mov	dx,offset filename1	; DS:DX - имя файла (TIE.EXE)
	mov	ax,4B01h			; функция DOS 4B01h
	int	21h				; загрузить без выполнения
	jnc	program_loaded		; если TIE.EXE не найден,
	mov	byte ptr XWING,1		; установить флаг для find_passwd
	mov	ax,4B01h
	mov	dx,offset filename2	; и попробовать BWING.EXE,
	int	21h
	jnc	program_loaded		; если он не найден,
	mov	ax,4B01h
	mov	dx,offset filename3	; попробовать XWING.EXE,
	int	21h
	jc	error_exit		; если и он не найден (или не загружается 
		; по какой-нибудь другой причине) - выйти с сообщением об ошибке

program_loaded:
; Процедура проверки пароля не находится непосредственно в исполняемом файле 
; tie.exe, bwing.exe или xwing.exe, а подгружается позже из оверлея front.ovl, 
; bfront.ovl или frontend.ovl соответственно. Найти команды, выполняющие чтение 
; из этого оверлея, и установить на них наш обработчик find_passwd
	cld
	push	cs
	pop	ax
	add	ax,par_length
	mov	ds,ax
	xor	si,si		; DS:SI - первый параграф после конца нашей 
				; программы (то есть начало области, в которую 
				; была загружена модифицируемая программа)
	mov	di,offset read_file_code ; ES:DI - код для сравнения
	mov	cx,rf_code_l		; CX - его длина
	call	find_string		; поиск кода,
	jc	error_exit2		; если он не найден - выйти с сообщением 
					; об ошибке
; заменить 6 байтов из найденного кода командами call find_passwd и nop
	mov	byte ptr [si], 9Ah	; CALL (дальний)
	mov	word ptr [si+1], offset find_passwd
	mov	word ptr [si+3], cs
	mov	byte ptr [si+5],90h	; NOP

; запустить загруженную программу
; надо записать правильные начальные значения в регистры для EXE-программы и 
; заполнить некоторые поля ее PSP
	mov	ah,51h	; функция DOS 51h
	int	21h		; BX = PSP-сегмент загруженной программы
	mov	ds,bx		; поместить его в DS
	mov	es,bx		; и ES. Заполнить также поля PSP:
	mov	word ptr ds:[0Ah],offset exit_without_msg
	mov	word ptr ds:[0Ch],cs	; "адрес возврата" 
	mov	word ptr ds:[16h],cs	; и "адрес PSP предка"
	lss	sp,dword ptr cs:EPB_SSSP ; загрузить SS:SP
	jmp	dword ptr cs:EPB_CSIP	; и передать управление на 
					; точку входа программы

XWING	db	0	; 1/0: тип защиты X-wing/Tie-fighter

EPB	dw	0	; запускаемый файл получает среду DOS от tieload.com,
	dw	0080h,?	; и командную строку,
	dw	005Ch,?	; и первый FCB,
	dw	006Ch,?	; и второй FCB
EPB_SSSP	dd	?	; начальный SS:SP - заполняется DOS
EPB_CSIP	dd	?	; начальный CS:IP - заполняется DOS

filename1	db	'tie.exe',0	; сначала пробуем запустить этот файл,
filename2	db	'bwing.exe',0	; потом этот
filename3	db	'xwing.exe',0	; и потом этот

; сообщения об ошибках
error_msg	db	'ERROR: could not find TIE.EXE, BWING.EXE,'
		db	'or XWING.EXE',0Dh,0Ah,'$'
error_msg2	db	'ERROR: initial patch failed',0Dh,0Ah,'$'

; команды, выполняющие чтение оверлейного файла в tie.exe/bwing.exe/xwing.exe:
read_file_code:
	db	33h,0D2h	; xor dx,dx
	db	0B4h,3Fh	; mov ah,3Fh
	db	0CDh,21h	; int 21h
	db	72h		; jz (на разный адрес в xwing и tie)
rf_code_l = $-read_file_code

; команды, вызывающие процедуру проверки пароля.
; Аналогичный набор команд встречается и в других местах, поэтому find_passwd 
; будет выполнять дополнительные проверки
passwd_code:
	db	89h,46h,0FCh	; mov [bp-4],ax
	db	89h,56h,0FEh	; mov [bp-2],dx
	db	52h			; push dx
	db	50h			; push ax
	db	9Ah			; call far
passwd_l = $-passwd_code

error_exit:
	mov	dx,offset error_msg ; вывод сообщения об ошибке 1
	jmp short exit_with_msg
error_exit2:
	mov	dx,offset error_msg2 ; вывод сообщения об ошибке 2
exit_with_msg:
	mov	ah,9		; Функция DOS 09h
	int	21h		; вывести строку на экран
exit_without_msg:		; сюда также передается управление после 
; завершения загруженной программы (этот адрес был вписан в 
; поле PSP "адрес возврата")
	mov	ah,4Ch		; Функция DOS 4Ch
	int	21h		; конец программы


; эту процедуру вызывает программа tie.exe/bwing.exe/xwing.exe каждый раз, когда 
; она выполняет чтение из оверлейного файла
find_passwd	proc	far
; выполнить три команды, которые мы заменили на call find_passwd
	xor dx,dx
	mov ah,3Fh	; функция DOS 3Fh
	int 21h	; чтение из файла или устройства

deactivation_point: ; по этому адресу мы запишем код команды RETF, 
; когда наша задача будет выполнена
	pushf		; сохраним флаги
	push	ds	; и регистры
	push	es
	pusha

	push	cs
	pop	es
	mov	si,dx	; DS:DX - начало только что прочитанного участка 
			; оверлейного файла
	mov	di,offset passwd_code ; ES:DI - код для сравнения
	dec	si		; очень скоро мы его увеличим обратно
search_for_pwd:	; в этом цикле найденные вхождения эталонного кода 
		; проверяются на точное соответствие коду проверки пароля
	inc	si	; процедура find_string возвращает DS:SI указывающим на 
			; начало найденного кода - чтобы искать дальше, надо 
			; увеличить SI хотя бы на 1
	mov	cx,passwd_l	; длина эталонного кода
	call	find_string	; поиск его в памяти,
	jc	pwd_not_found	; если он не найден - выйти
; find_string нашла очередное вхождение нашего эталонного кода вызова 
; процедуры - проверим, точно ли это вызов процедуры проверки пароля
	cmp	byte ptr [si+10],00h	; этот байт должен быть 00
	jne	search_for_pwd
	cmp	byte ptr cs:XWING,1	; в случае X-wing/B-wing
	jne	check_for_tie
	cmp	word ptr [si+53],0774h	; команда je должна быть здесь,
	jne	search_for_pwd
	jmp short pwd_found
check_for_tie:				; а в случае Tie Fighter - 
	cmp	word ptr [si+42],0774h	; здесь
	jne	search_for_pwd
pwd_found:	; итак, вызов процедуры проверки пароля найден - отключить его
	mov	word ptr ds:[si+8],9090h	; NOP NOP
	mov	word ptr ds:[si+10],9090h	; NOP NOP
	mov	byte ptr ds:[si+12],90h		; NOP
; и деактивировать нашу процедуру find_passwd
	mov	byte ptr cs:deactivation_point,0CBh	; RETF

pwd_not_found:
	popa		; восстановить регистры
	pop	es
	pop	ds
	popf		; и флаги
	ret		; и вернуть управление в программу
find_passwd	endp

; процедура find_string
; выполняет поиск строки от заданного адреса до конца всей общей памяти
; ввод: ES:DI - адрес эталонной строки
; 	CX - ее длина
; 	DS:SI - адрес, с которого начинать поиск
; вывод: CF = 1, если строка не найдена,
; иначе: CF = 0 и DS:SI - адрес, с которого начинается найденная строка

find_string	proc	near
	push	ax
	push	bx
	push	dx	; сохранить регистры

do_cmp: mov	dx,1000h	; поиск блоками по 1000h (4096 байтов)
cmp_loop:
	push	di
	push	si
	push	cx
	repe cmpsb		; сравнить DS:SI со строкой
	pop	cx
	pop	si
	pop	di
	je	found_code	; если совпадение - выйти с CF = 0,
	inc	si		; иначе - увеличить DS:SI на 1
	dec	dx		; уменьшить счетчик в DX
	jne	cmp_loop	; и, если он не ноль, продолжить
; пройден очередной 4-килобайтный блок
	sub	si,1000h	; уменьшить SI на 1000h
	mov	ax,ds
	inc	ah		; и увеличить DS на 1
	mov	ds,ax
	cmp	ax,9000h	; если мы добрались до 
	jb	do_cmp	; сегментного адреса 9000h - 

	pop	dx		; восстановить регистры
	pop	bx
	pop	ax
	stc			; установить CF = 1
	ret			; и выйти
; сюда передается управление, если строка найдена
found_code:
	pop	dx	; восстановить регистры
	pop	bx
	pop	ax
	clc			; установить CF = 0
	ret			; и выйти
find_string	endp

end_of_program:
length_of_program = $-start+100h+100h ; длина программы в байтах
par_length = length_of_program + 0Fh
par_length = par_length/16		; длина программы в параграфах
	end start
