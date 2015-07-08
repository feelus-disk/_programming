;prg14_9.asm
;Вызывающий модуль - тот же, что и для предыдущего варианта.

;Вызываемый модуль
include	mac.inc
extrn	per1:byte,per2:byte
public	my_proc2
data	segment	
per0	db	'0'
data	ends
code	segment
my_proc2	proc	far
assume	cs:code,ds:data
;вывод символов на экран
	mov	ax,data
	mov	ds,ax
	mov	dl,per0
	OutChar
	mov	ax,seg per1
	mov	es,ax
	mov	dl,es:per1
	OutChar
	mov	dl,es:per2
	OutChar
	mov	dl,per0
	OutChar
	ret
my_proc2 endp
code	ends
end

