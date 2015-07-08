;prg_8_8.asm
masm
model	small
stack	256
.data 
len	equ	2	;разрядность числа
b	db	1,7	;неупакованное число 71
c	db	4,5	;неупакованное число 54
sum	db	3 dup (0)
.code
main:	;точка входа в программу
	mov	ax,@data
	mov	ds,ax
;...
	xor	bx,bx
	mov	cx,len
m1:
	mov	al,b[bx]
	adс	al,c[bx]
	aaa
	mov	sum[bx],al
	inc	bx
	loop	m1
	adc	sum[bx],0
;...
	exit:
	mov	ax,4c00h	;стандартный выход
	int	21h
end main		;конец программы

