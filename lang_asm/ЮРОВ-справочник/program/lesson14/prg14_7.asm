;prg14_7.asm
;Вызываемый модуль
include	mac.inc
extrn	per1:byte,per2:byte
public	my_proc2
code	segment
my_proc2	proc	far
assume	cs:code
;вывод символов на экран
	mov	dl,per1
	OutChar
	mov	dl,per2
	OutChar
	ret
my_proc2	endp
code	ends
end

