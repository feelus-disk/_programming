;prg_12_7.asm
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
	mov	al,mask i2
	shr	al,i2	;биты i2 в начале ax
	and	al,0fch	;обнулили i2
;помещаем i2 на место
	shl	al,i2
	mov	bl,[flag]
	xor	bl,mask i2	;сбросили i2
	or	bl,al		;наложили
	exit:
	mov	ax,4c00h	;стандартный выход
	int	21h
end main		;конец программы

