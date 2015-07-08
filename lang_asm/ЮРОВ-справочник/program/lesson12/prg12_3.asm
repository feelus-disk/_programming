;prg_12_3.asm
MASM
MODEL	small	;модель памяти
STACK	256	;размер стека
.data		;начало сегмента данных
N=5		;количество элементов массива
mas	db	5 dup (3 dup (0))
.code		;сегмент кода
main:		;точка входа в программу
	mov	ax,@data
	mov	ds,ax
	xor	ax,ax	;обнуление ax
	mov	si,0	;0 в si
	mov	cx,N	;N в cx
go:
	mov	dl,mas[si]	;первый байт поля в dl
	inc	dl	;увеличение dl на 1 (по условию)
	mov	mas[si],dl	;заслать обратно в массив
	add	si,3	;сдвиг на следующий элемент массива
	loop	go	;повтор цикла
	mov	si,0	;подготовка к выводу на экран
	mov	cx,N
show:			;вывод на экран содержимого
			;первых байт полей
	mov	dl,mas[si]
	add	dl,30h
	mov	ah,02h
	int	21h
	loop	show
exit:
	mov	ax,4c00h	;стандартный выход
	int	21h
end	main	;конец программы

