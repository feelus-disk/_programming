
.sect .text
	push msg1
	call stringpr
	push msg2
	call stringpr
	add  sp,4
	push 0
	push 1
	sys

stringpr:
	push cx
	push si
	push di
	push bp
	mov  bp,sp
	mov  ax,0
	mov  di,10(bp)
	mov  si,di
	mov  cx,-1
	repnz scasb
	inc  cx
	not  cx
	mov  di,strpribf
	push cx
	push di
	push _STDOUT
	push _WRITE
	rep  movsb
	stosb
	sys
	mov  sp,bp
	pop  bp
	pop  di
	pop  si
	pop  cx
	ret

.sect .data

.sect .bss
strpribf:
	.space 88

.sect .data
msg1: .asciz "Kijk eens even\n"
msg2: .asciz "q\n"

_WRITE=4
_STDOUT=1
