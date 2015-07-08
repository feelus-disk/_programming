;prg_12_2.asm
MASM
MODEL	small
STACK	256
.data			;начало сегмента данных
;тексты сообщений:
mes1	db	'не равен 0!$',0ah,0dh
mes2	db	'равен 0!$',0ah,0dh
mes3	db	0ah,0dh,'Элемент $'
mas	dw	2,7,0,0,1,9,3,6,0,8	;исходный массив
.code
.486			;это обязательно
main:
	mov	ax,@data
	mov	ds,ax	;связка ds с сегментом данных
	xor	ax,ax	;обнуление ax
prepare:
	mov	cx,10	;значение счетчика цикла в cx
	mov	esi,0	;индекс в esi
compare:
	mov	dx,mas[esi*2]	;первый элемент массива в dx
	cmp	dx,0	;сравнение dx c 0
	je	equal	;переход, если равно
not_equal:		;не равно
	mov	ah,09h	;вывод сообщения на экран
	lea	dx,mes3
	int	21h
	mov	ah,02h	;вывод номера элемента массива на экран
	mov	dx,si
	add	dl,30h
	int	21h
	mov	ah,09h
	lea	dx,mes1
	int	21h
	inc	esi	;на следующий элемент
	dec	cx	;условие для выхода из цикла
	jcxz	exit	;cx=0? Если да - на выход
	jmp	compare	;нет - повторить цикл
equal:		;равно 0
	mov	ah,09h	;вывод сообщения mes3 на экран
	lea	dx,mes3
	int	21h
	mov	ah,02h
	mov	dx,si
	add	dl,30h
	int	21h
	mov	ah,09h	;вывод сообщения mes2 на экран
	lea	dx,mes2
	int	21h
	inc	esi	;на следующий элемент
	dec	cx	;все элементы обработаны?
	jcxz	exit
	jmp	compare
exit:
	mov	ax,4c00h	;стандартный выход
	int	21h
end	main	;конец программы

