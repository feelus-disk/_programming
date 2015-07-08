;prg14_14.asm
MASM
MODEL	small
STACK	256
.code
main:
asmproc	proc	near
;обьявление аргументов:
arg	kol:WORD,y:WORD,x:WORD,chr:BYTE=a_size
PUBLIC	asmproc
	push	bp	;сохранение указателя базы
	mov	bp,sp	;настройка bp на стек через sp
	mov	dh,byte ptr y	; y в dh
	mov	dl,byte ptr x	; x в dl
	mov	ah,02h	;номер службы BIOS
	int	10h	;вызов прерывания BIOS
	mov	ah,09h	;номер службы BIOS
	mov	al,chr	;символ - в al
	mov	bl,07h	;маска вывода символа
	xor	bh,bh
	mov	cx,kol	;kol в cx
	int	10h	;вызов прерывания BIOS
	pop	bp	;эпилог
	ret	a_size	;будет ret 8 и выход из процедуры
asmproc	endp	;конец процедуры
end	main	;конец программы

