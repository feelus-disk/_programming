;prg_8_5.asm
masm
model	small
stack	256
.data	;сегмент данных
rez	label	word
rez_l	db	45 
rez_h	db	0
.code	;сегмент кода
main:	;точка входа в программу
	mov	ax,@data
	mov	ds,ax
;...
	xor	ax,ax
	mov	al,25
	mul	rez_l
	jnc	m1	;если нет переполнения, то на м1
	mov	rez_h,ah	;старшую часть результата в rez_h
m1:
	mov	rez_l,al	;младшую часть результата в rez_l
;...
	exit:
	mov	ax,4c00h	;стандартный выход
	int	21h
end	main		;конец программы

