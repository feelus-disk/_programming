;prg_11_4.asm
MASM
MODEL	small
STACK	256
.data
;строки для сравнения
string1	db	'Поиск символа в этой строке.',0ah,0dh,'$'
string2	db	'Поиск символа не в этой строке.',0ah,0dh,'$'
mes_eq	db	'Строки совпадают.',0ah,0dh,'$'
fnd	db	'Несовпавший элемент в регистре al',0ah,0dh,'$'
.code
;привязка ds и es к сегменту данных
assume ds:@data,es:@data
main:
	mov	ax,@data	;загрузка сегментных регистров
	mov	ds,ax
	mov	es,ax		;настройка es на ds
	mov	ah,09h
	lea	dx,string1
	int	21h	;вывод string1
	lea	dx,string2
	int	21h	;вывод string2
	cld		;сброс флага df
	lea	di,string1	;загрузка в es:di смещения
;строки string1
	lea	si,string2	;загрузка в ds:si смещения
;строки string2
	mov	cx,29	;для префикса repe - длина строки
;поиск в строке (пока нужный символ и символ в строке не равны)
;выход - при первом несовпавшем
repe	cmps	string1,string2
	jcxz	eql	;если равны - переход на eql
	jmp	no_eq	;если не равны - переход на no_eq
eql:		;выводим сообщение о совпадении строк
	mov	ah,09h
	lea	dx,mes_eq
	int	21h	;вывод сообщения mes_eq
	jmp	exit		;на выход
no_eq:		;обработка несовпадения элементов
	mov	ah,09h
	lea	dx,fnd
	int	21h	;вывод сообщения fnd
;теперь, чтобы извлечь несовпавший элемент из строки
;в регистр-аккумулятор,
;уменьшаем значение регистра si и тем самым перемещаемся
;к действительной позиции элемента в строке
	dec	si	;команда lods использует ds:si-адресацию
;теперь ds:si указывает на позицию в string2
	lods	string2	;загрузим элемент из строки в AL
;нетрудно догадаться, что в нашем примере это символ - "н"
exit:		;выход
	mov	ax,4c00h
	int	21h
end	main

