; fidoh.asm
; заменяет русские "Н" на латинские "H" во всех файлах с расширением .TXT в 
; текущей директории
;
; Компиляция:
; TASM:
; tasm /m fidoh.asm
; tlink /t /x fidoh.obj
; MASM:
; ml /c fidoh.asm
; link fidoh.obj,,NUL,,,
; exe2bin fidoh.exe fidoh.com
; WASM:
; wasm fidoh.asm
; wlink file fidoh.obj form DOS COM
;

	.model tiny
	.code
	org	100h		; COM-файл
start:
	mov	ah,4Eh	; поиск первого файла
	xor	cx,cx		; не системный, не директория и т. д.
	mov	dx,offset filespec ; маска для поиска в DS:DX
file_open:
	int	21h
	jc	no_more_files	; если CF = 1 - файлы кончились

	mov	ax,3D02h	; открыть файл для чтения и записи
	mov	dx,80h+1Eh	; смещение DTA + смещение имени файла
	int	21h		; от начала DTA
	jc	find_next	; если файл не открылся - перейти к 
				; следующему

	mov	bx,ax		; идентификатор файла в BX
	mov	cx,1		; считывать один байт
	mov	dx,offset buffer ; начало буфера - в DX
read_next:
	mov	ah,3Fh	; чтение файла
	int	21h
	jc	find_next	; если ошибка - перейти к следующему
	dec	ax		; если AX = 0 - файл кончился -
	js	find_next	; перейти к следующему
	cmp	byte ptr buffer,8Dh ; если не считана русская "Н",
	jne	read_next	; считать следующий байт,
	mov	byte ptr buffer,48h ; иначе - записать в буфер 
				; латинскую букву "H"

	mov	ax,4201h	; переместить указатель файла от текущей
	dec	cx		; позиции назад на 1
	dec	cx		; CX = FFFFh
	mov	dx,cx		; DX = FFFFh
	int	21h

	mov	ah,40h	; записать в файл
	inc	cx
	inc	cx		; один байт (CX = 1)
	mov	dx,offset buffer ; из буфера в DS:DX
	int	21h
	jmp short read_next	; считать следующий байт

find_next:
	mov	ah,3Eh	; закрыть предыдущий файл
	int	21h

	mov	ah,4Fh	; найти следующий файл
	mov	dx,80h	; смещение DTA от начала PSP
	jmp short file_open

no_more_files:			; если файлы кончились,
	ret			; выйти из программы

filespec	db	'*.txt',0	; маска для поиска
buffer label byte			; буфер для чтения/записи - за концом 
					; программы
	end	start
