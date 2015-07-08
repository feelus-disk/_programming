;prg_8_4.asm
masm
model	small
stack	256
.data
.code	;сегмент кода
main:	;точка входа в программу
	mov	ax,@data
	mov	ds,ax
;...
	xor	ax,ax
	mov	al,5
	sub	al,10
	jnc	m1	;нет переноса?
	neg al	;в al модуль результата
m1: ;...
	exit:
	mov	ax,4c00h	;стандартный выход
	int	21h
end main		;конец программы

