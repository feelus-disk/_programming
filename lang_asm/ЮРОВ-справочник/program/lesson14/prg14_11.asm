;prg14_11.asm
;Вызываемый модуль
include	mac.inc
extrn	per1:byte,per2:byte
public	my_proc2,per0
data	segment	para public 'data'
per0	db	'0'
data	ends
code	segment
my_proc2	proc	far
assume	cs:code,ds:data
;ds загружать не надо, так как компоновщик его присоединит
;к сегменту данных первого модуля
;вывод символов на экран
	mov	dl,per0
	OutChar
	mov	dl,per1
	OutChar
	mov	dl,per2
	OutChar
	mov	dl,per0
	OutChar
	ret
my_proc2	endp
code	ends
	end

