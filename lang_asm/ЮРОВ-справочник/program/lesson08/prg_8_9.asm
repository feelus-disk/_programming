;prg_8_9.asm
masm
model	small
stack	256
.data		;сегмент данных
b	db	1,7	;неупакованное число 71
c	db	4,5	;неупакованное число 54
subs	db	2 dup (0)
.code
main:		;точка входа в программу
	mov	ax,@data	;связываем регистр dx с сегментом
	mov	ds,ax	;данных через регистр ax
 	xor	ax,ax	;очищаем ax
len	equ	2	;разрядность чисел
	xor	bx,bx
	mov	cx,len	;загрузка в cx счетчика цикла
m1:
	mov	al,b[bx]
	sbb	al,c[bx]
	aas
	mov	subs[bx],al
	inc	bx
	loop	m1
	jc	m2	;анализ флага заема
	jmp	exit
m2:	;...
exit:
	mov	ax,4c00h	;стандартный выход
	int	21h
end	main	;конец программы

