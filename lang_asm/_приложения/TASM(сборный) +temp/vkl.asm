MASM
MODEL	Small
STACK 256
.code
vkl	proc	near
PUBLIC	vkl
	push	bp
	mov	bp,sp
go:	mov	al,0B6h	;10110110
	out	43h,al
	in	al,61h
	or	al,3
	out	61h,al
zagr:	mov	ax,[bp+6]
	out	42h,al
	xchg	ah,al
	out	42h,al
	mov	cx, [bp+4]
q:	mov	ax,cx
	mov	cx,0ffffh
z:	loop	z
	mov	cx,ax
	loop	q
	pop	bp
	ret	5
vkl	endp
end
