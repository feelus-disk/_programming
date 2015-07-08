;prg_12_1.asm
MASM
MODEL	small
STACK	256
.data
mes	db	0ah,0dh,'Массив- ','$'
mas	db	10 dup (?)	;исходный массив
i	db	0
.code
main:
	mov	ax,@data
	mov	ds,ax
	xor	ax,ax	;обнуление ax
	mov	cx,10	;значение счетчика цикла в cx
	mov	si,0	;индекс начального элемента в cx
go:		;цикл инициализации
	mov	bh,i	;i в bh
	mov	mas[si],bh	;запись в массив i
	inc	i	;инкремент i
	inc	si	;продвижение к следующему
			;элементу массива
	loop	go	;повторить цикл
;вывод на экран получившегося массива
	mov	cx,10
	mov	si,0
	mov	ah,09h
	lea	dx,mes
	int	21h
show:
	mov	ah,02h	;функция вывода значения из al на экран
	mov	dl,mas[si]
	add	dl,30h	;преобразование числа в символ
	int	21h
	inc	si
	loop	show
exit:
	mov	ax,4c00h	;стандартный выход
	int	21h
end	main		;конец программы

