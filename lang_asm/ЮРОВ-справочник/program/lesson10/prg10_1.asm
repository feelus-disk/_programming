;prg_10_1.asm
model	small
.stack	100h
.data
n	equ	10
stroka	db	'acvfgrndup'
.code
start:
	mov	ax,@data
	mov	ds,ax
	xor	ax,ax
	mov	cx,n
	lea	bx,stroka	;адрес stroka в bx
m1:	mov	al,[bx]	;очередной символ из stroka в al
	cmp	al,61h	;проверить, что код символа не меньше 61h
	jb	next	;если меньше, то не обрабатывать и на следующий символ
	cmp	al,7ah	;проверить, что код символа не больше 7аh
	ja	next	;если больше, то не обрабатывать и на следующий символ
	and	al,11011111b	;инвертировать 5-й бит
	mov	[bx],al	;символ на место в stroka
next:
	inc	bx	;адресовать следующий символ
	dec	cx	;уменьшить значение счетчика в cx
	jnz	m1	;если cx не 0, то переход на m1
exit:
	mov	ax,4c00h
	int	21h	;возврат управления операционной системе
end	start

