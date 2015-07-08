;prg_12_5.asm
MASM
MODEL	small
STACK	256
.data
mes1	db	0ah,0dh,'Исходный массив - $',0ah,0dh
;некоторые сообщения
mes2	db	0ah,0dh,'Отсортированный массив - $',0ah,0dh
n	equ	9	;количество элементов в массиве, считая с 0
mas	dw	2,7,4,0,1,9,3,6,5,8	;исходный массив
tmp	dw	0	;переменные для работы с массивом
i	dw	0
j	dw	0
.code
main:
	mov	ax,@data
	mov	ds,ax
	xor	ax,ax
;вывод на экран исходного массива
	mov	ah,09h
	lea	dx,mes1
	int	21h	;вывод сообщения mes1
	mov	cx,10
	mov	si,0
show_primary:	;вывод значения элементов
		;исходного массива на экран
	mov	dx,mas[si]
	add	dl,30h
	mov	ah,02h
	int	21h
	add	si,2
	loop	show_primary

;строки 40-85 программы эквивалентны следующему коду на языке С:
;for (i=0;i<9;i++)
;	for (j=9;j>i;j--)
;		if (mas[i]>mas[j])
;		{tmp=mas[i];
;		mas[i]=mas[j];
;		mas[j]=tmp;}
	mov	i,0	;инициализация i
;внутренний цикл по j
internal:
	mov	j,9	;инициализация j
	jmp	cycl_j	;переход на тело цикла
exchange:		
	mov	bx,i	;bx=i
	shl	bx,1
	mov	ax,mas[bx]	;ax=mas[i]
	mov	bx,j	;bx=j
	shl	bx,1
	cmp	ax,mas[bx]	;mas[i] ? mas[j] - сравнение элементов
	jle	lesser	;если mas[i] меньше, то обмен не нужен и ;переход на продвижение далее по массиву
;иначе tmp=mas[i], mas[i]=mas[j], mas[j]=tmp:
;tmp=mas[i]
	mov	bx,i	;bx=i
	shl	bx,1	;умножаем на 2, так как элементы - слова
	mov	tmp,ax	;tmp=mas[i]

;mas[i]=mas[j]
	mov	bx,j	;bx=j
	shl	bx,1	;умножаем на 2, так как элементы - слова
	mov	ax,mas[bx]	;ax=mas[j]
	mov	bx,i		;bx=i
	shl	bx,1	;умножаем на 2, так как элементы - слова
	mov	mas[bx],ax	;mas[i]=mas[j]

;mas[j]=tmp
	mov	bx,j		;bx=j
	shl	bx,1	;умножаем на 2, так как элементы - слова
	mov	ax,tmp		;ax=tmp
	mov	mas[bx],ax	;mas[j]=tmp
lesser:	;продвижение далее по массиву во внутреннем цикле
	dec	j	;j--
;тело цикла по j
cycl_j:
	mov	ax,j	;ax=j
	cmp	ax,i	; сравнить j ? i
	jg	exchange	;если j>i, то переход на обмен
;иначе на внешний цикл по i
	inc	i	;i++
	cmp	i,n		;сравнить i ? n - прошли до конца массива
	jl	internal	;если i<n продолжение обработки

;вывод отсортированного массива
	mov	ah,09h
	lea	dx,mes2
	int	21h
prepare:
	mov	cx,10
	mov	si,0
show:		;вывод значения элемента на экран
	mov	dx,mas[si]
	add	dl,30h
	mov	ah,02h
	int	21h
	add	si,2
	loop	show
exit:
	mov	ax,4c00h	;стандартный выход
	int	21h
end	main		;конец программы

