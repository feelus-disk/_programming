;prg_8.6.asm
masm
model	small
stack	256
.data
del_b	label	byte
del	dw	29876
delt	db	45
.code	;сегмент кода
main:	;точка входа в программу
	mov	ax,@data
	mov	ds,ax
;...
	xor	ax,ax
;последующие две команды можно заменить одной mov ax,del
	mov	ah,del_b	;старший байт делимого в ah
	mov	al,del_b+1	;младший байт делимого в al
	div	delt	;в al - частное, в ah - остаток
;...
 	exit:
	mov	ax,4c00h	;стандартный выход
	int	21h
end	main		;конец программы

