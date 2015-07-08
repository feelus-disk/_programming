;prg_13_7.asm
MASM
MODEL	small
STACK	256
.486p
include	show.inc
.data
pole	dd	3cdf436fh
.code
main:
	mov	ax,@data
	mov	ds,ax
	xor	ax,ax
	mov	ax,1f0fh
	show	al,0
	show	ah,160
	show	ax,320
	mov	eax,pole
	show	eax,480
	exit:
	mov	ax,4c00h
	int	21h
end	main

