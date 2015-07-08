;prg_10_5.asm
model small
.stack	100h
.data
mas	db	1,0,9,8,0,7,8,0,2,0
	db	1,0,9,8,0,7,8,0,2,0
	db	1,0,9,8,0,7,8,0,2,0
	db	1,0,9,8,0,7,8,0,2,0
	db	1,0,9,8,0,7,8,0,2,0
.code
start:
	mov	ax,@data
	mov	ds,ax
	xor	ax,ax
	lea	bx,mas
	mov	cx,5
cycl_1:
	push	cx
	xor	si,si
	mov	cx,10
cycl_2:
	cmp	byte ptr [bx+si],0
	jne	no_zero
	mov	byte ptr [bx+si],0ffh
no_zero:
	inc	si
	loop	cycl_2
	pop	cx
	add	bx,10
	loop	cycl_1
exit:
	mov	ax,4c00h
	int	21h	;возврат управления операционной системе
end	start

