;prg8_10.asm
masm
model	small
stack	256
.data
b	db	6,7	;неупакованное число 76
c	db	4	;неупакованное число 4
proizv	db	4 dup (0)
.code
main:	;точка входа в программу
	mov	ax,@data
	mov	ds,ax
	xor	ax,ax
len	equ	2	;размерность сомножителя 1
	xor	bx,bx
	xor	si,si
	xor	di,di
	mov	cx,len	;в cx длина наибольшего сомножителя 1
m1:
	mov	al,b[si]
	mul	c
	aam		;коррекция умножения
	adc	al,dl	;учли предыдущий перенос
	aaa	;скорректировали результат сложения с переносом
	mov	dl,ah	; запомнили перенос
	mov	proizv[bx],al
	inc	si
	inc	bx
	loop m1
	mov	proizv[bx],dl	;учли последний перенос
	exit:
	mov	ax,4c00h
	int	21h
end	main

