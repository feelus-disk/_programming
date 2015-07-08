;prg14_8.asm
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
 	push	ds	;сохранили ds
 	mov	ax,seg per1	;сегментный адрес per1 в ds
 	mov	ds,ax
 	mov	dl,per1
 	OutChar		;вывод per1
 	mov	dl,per2
 	OutChar		;вывод per2
 	pop	ds	;восстановили ds
 	mov	dl,per0
 	OutChar		;и еще раз per0
 	ret
 my_proc2 endp
 code	ends
 end

