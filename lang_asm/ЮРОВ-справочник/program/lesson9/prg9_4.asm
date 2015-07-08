;prg_9_4.asm
masm
model	small
stack	256
.data
bit_str	dd	11ffff11h	;строка для извлечения
.code
main:	;точка входа в программу
	mov	ax,@data
	mov	ds,ax
	xor	ax,ax
.386			;это обязательно
;левый край места извлечения циклически переместить к левому краю
;строки bit_str (сохранение левого контекста)
	rol	bit_str,8
	mov	ebx,bit_str	;подготовленную строку в ebx
	shld	eax,ebx,16	;вставить извлекаемые 16 бит
	;в регистр eax
	ror	bit_str,8	;восстановить старшие 8 бит
;...
	exit:		;eax=0000ffff
	mov	ax,4c00h
	int	21h
end	main

