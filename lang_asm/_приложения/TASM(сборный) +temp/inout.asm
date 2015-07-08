masm
model small
stack 100h
.data
.code
main:	mov	ax,@data
	mov	ds,ax
go:	mov	al,0B6h	;10110110
	out	43h,al
	in	al,61h
	or	al,3
	out	61h,al
zagr:	mov	ax,2705
	out	42h,al
	xchg	ah,al
	out	42h,al
	mov	cx,0ffffh
q:	mov	ax,cx
	mov	cx,0ffffh
z:	loop	z
	mov	cx,ax
	loop	q
exit:	mov	ax,4c00h
	int	21h
end main