;prg_9_1.asm
masm
model	small
stack	256
.data	;сегмент данных
.code	;сегмент кода
main:	;точка входа в программу
	mov	ax,@data	;связываем регистр dx с сегментом
	mov	ds,ax	;данных через регистр ax
 	xor	ax,ax	;очищаем ax
;...
.486		;это обязательно
	xor	ax,ax
	mov	al,02h
	bsf	bx,ax	;bx=1
	jz	m1	;переход, если al=00h
	bsr	bx,ax
m1:
;...
	mov	ax,4c00h	;стандартный выход
	int	21h
end	main

