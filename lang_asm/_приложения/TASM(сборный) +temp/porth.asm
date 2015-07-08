
MASM
MODEL	small
STACK	256
.code
porth proc near
PUBLIC	porth
push	bp
mov	bp,sp
mov	dx,[bp+4]
mov	ax,dx
;in 	eax,dx
;shr	eax,16
pop	bp
ret	3
porth endp
end