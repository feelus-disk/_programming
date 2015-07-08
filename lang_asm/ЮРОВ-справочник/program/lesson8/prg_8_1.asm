;prg_8_1.asm
masm
model	small
stack	256
.data	;сегмент данных
per_1	db	23
per_2	dw	9856
per_3	dd	9875645
per_4	dw	29857
.code	;сегмент кода
main:	;точка входа в программу
	mov	ax,@data	;связываем регистр dx с сегментом
	mov	ds,ax	;данных через регистр ax
exit:		;посмотрите в отладчике дамп сегмента данных
	mov	ax,4c00h	;стандартный выход
	int	21h
end main			;конец программы

