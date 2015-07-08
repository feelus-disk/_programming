;prg_11_2.asm
MODEL	small
STACK	256
.data
match	db	0ah,0dh,'Строки совпадают.','$'
failed	db	0ah,0dh,'Строки не совпадают','$'
string1	db	'0123456789',0ah,0dh,'$';исследуемые строки
string2	db	'0123406789','$'
.code
ASSUME	ds:@data,es:@data	;привязка DS и ES к сегменту данных
main:
	mov	ax,@data	;загрузка сегментных регистров
	mov	ds,ax
	mov	es,ax	;настройка ES на DS
;вывод на экран исходных строк string1 и string2
	mov	ah,09h
	lea	dx,string1
	int	21h
	lea	dx,string2
	int	21h
;сброс флага DF - сравнение в направлении возрастания адресов
	cld		
	lea	si,string1	;загрузка в si смещения string1
	lea	di,string2	;загрузка в di смещения string2
	mov	cx,10	;длина строки для префикса repe
;сравнение строк (пока сравниваемые элементы строк равны)
;выход при обнаружении не совпавшего элемента
cycl:
	repe	cmps	string1,string2
	jcxz	equal	;cx=0, то есть строки совпадают
	jne	not_match	;если не равны - переход на not_match
equal:			;иначе, если совпадают, то
	mov	ah,09h	;вывод сообщения
	lea	dx,match
	int	21h
	jmp	exit		;выход
not_match:			;не совпали
	mov	ah,09h
	lea	dx,failed
	int	21h	;вывод сообщения
;теперь, чтобы обработать не совпавший элемент в строке, необходимо  уменьшить значения регистров si и di
	dec	si
	dec	di
;сейчас в ds:si и es:di адреса несовпавших элементов
;здесь вставить код по обработке несовпавшего элемента
после этого продолжить поиск в строке:
	inc	si
	inc	di
	jmp	cycl
exit:			;выход
	mov	ax,4c00h
	int	21h
end	main		;конец программы

