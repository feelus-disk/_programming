;prg_12_8.asm
masm
model	small
stack	256
iotest	record	i1:1,i2:2=11,i3:1,i4:2=11,i5:2=00
.data
flag	iotest	<>
.code
main:
	mov	ax,@data
	mov	ds,ax
	mov	al,flag
	mov 	bl,3
	setfield	i5 al,bl
	xor	bl,bl
	getfield	i5 bl,al
	mov	bl,1
	setfield	i4 al,bl
	setfield	i5 al,bl
exit:
	mov	ax,4c00h	;стандартный выход
	int	21h
end main			;конец программы

