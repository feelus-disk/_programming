;prg_9_2.asm
masm
model	small
stack	256
.data
len=4		;длина неупакованного BCD-числа
unpck_BCD	label	dword
dig_BCD	db	2,4,3,6	;неупакованное BCD-число 6342
pck_BCD	dd	0	; pck_BCD=00006342
.code
main:	;точка входа в программу
	mov	ax,@data
	mov	ds,ax
	xor	ax,ax
	mov	cx,len
.386			;это обязательно
	mov	eax,unpck_BCD
m1:
	shl	eax,4	;убираем нулевую тетраду
	shld	pck_BCD,eax,4	;тетраду с цифрой в поле pck_BCD
	shl	eax,4	;убираем тетраду с цифрой из eax
	loop	m1	;на цикл
	exit:		;pck_BCD=00006342
	mov	ax,4c00h
	int	21h
end	main

