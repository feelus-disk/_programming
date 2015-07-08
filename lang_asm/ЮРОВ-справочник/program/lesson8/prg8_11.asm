;prg8_11.asm
masm
model	small
stack	256
.data	;сегмент данных
b	db	1,7	;неупакованное BCD-число 71
c	db	4	;
ch	db	2 dup (0)
.code	;сегмент кода
main:	;точка входа в программу
	mov	ax,@data
	mov	ds,ax
	xor	ax,ax
	mov	al,b
	aad	;коррекция перед делением
	div	c	;в al BCD-частное, в ah BCD-остаток
;...
	exit:
	mov	ax,4c00h
	int	21h
end	main


