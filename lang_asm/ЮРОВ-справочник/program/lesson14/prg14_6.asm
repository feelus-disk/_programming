;prg14_6.asm
;Вызывающий модуль
include	mac.inc
extrn	my_proc2:far
public	per1,per2
stk	segment	stack
	db	256 dup (0)
stk	ends
data	segment	
per1	db	'1'
per2	db	'2'
data	ends
code	segment
main	proc	far
assume	cs:code,ds:data,ss:stk
	mov	ax,data
	mov	ds,ax
	call	my_proc2
	exit
main	endp
code	ends
end	main

