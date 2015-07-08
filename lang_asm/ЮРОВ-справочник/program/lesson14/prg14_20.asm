;prg14_20.asm
MASM
MODEL small,C		;модель памяти и тип кода
STACK	256
.code
main:
asmproc	proc	c near ch:BYTE,x:WORD,y:WORD,kol:WORD
PUBLIC _asmproc	;символ подчеркивания обязателен
	mov	dh,y	;y-координата символа в dh
	mov	dl,x	;x-координата символа в dl
	mov	ah,02h	;номер службы BIOS
	int	10h	;вызов прерывания BIOS
	mov	ah,09h	;номер службы BIOS
	mov	cx,kol	;kol - количество "выводов" в cx
	mov	bl,07h	;маска вывода в bl
	xor	bh,bh
	mov	al,ch	;ch - символ в al
	int	10h	;вызов прерывания BIOS
	ret		;возврат из процедуры
asmproc	endp
end	main

