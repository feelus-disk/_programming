;prg14_15.asm
MASM
MODEL	large,pascal
STACK	256
.code
main:
asmproc	proc	near chr:BYTE,x:WORD,y:WORD,kol:WORD
PUBLIC	asmproc
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
	ret
asmproc	endp	;конец процедуры
end	main	;конец программы

