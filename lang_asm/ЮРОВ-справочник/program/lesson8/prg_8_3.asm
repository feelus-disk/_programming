;prg_8_3.asm
masm
model	small
stack	256
.data
a	db	254
.code	;сегмент кода
main:
	mov	ax,@data
	mov	ds,ax
;...
	xor	ax,ax
	add	al,17
	add	al,a
	jnc	m1	;если нет переноса, то перейти на m1
	adc	ah,0	;в ax сумма с учетом переноса
m1: ;...
	exit:
	mov	ax,4c00h	;стандартный выход
	int	21h
end main			;конец программы

