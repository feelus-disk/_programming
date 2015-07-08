;prg14_18.asm
MASM
MODEL	small
data	segment	word	public	;сегмент данных
	;обьявление внешних переменных
	extrn	value1:WORD
	extrn	value2:WORD
data	ends	;конец сегмента данных
.code
	assume	ds:data	;привязка ds к сегменту
			;данных программы на Pascal
main:
AddAsm	proc	near
PUBLIC	AddAsm	;внешняя
	mov	cx,ds:value1	;value1в cx
	mov	dx,ds:value2	; value2в dx
	add	cx,dx	;сложение
	mov	ax,cx	;результат в ax, так как - слово
	ret	;возврат из функции
AddAsm	endp	;конец функции
end	main	;конец программы

