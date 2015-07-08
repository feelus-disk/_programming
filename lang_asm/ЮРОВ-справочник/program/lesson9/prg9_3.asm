;prg_9_3.asm
masm
model	small
stack	256
.data
bit_str	dd	11010111h	;строка для вставки
p_str	dd	0ffff0000h	;вставляемая подстрока 0ffffh
.code
main:	;точка входа в программу
	mov	ax,@data
	mov	ds,ax
	xor	ax,ax
.386			;это обязательно
	mov	eax,p_str
;правый край места вставки циклически переместить к краю
;строки bit_str (сохранение правого контекста):
	ror	bit_str,8
	shr	bit_str,16	;сдвинуть строку вправо на длину подстроки (16 бит)
	shld	bit_str,eax,16	;сдвинуть 16 бит
	rol	bit_str,8	;восстановить младшие 8 бит
;...
	exit:		;bit_str=11ffff11
	mov	ax,4c00h
	int	21h
end	main

