;prg_11_5.asm
MASM
MODEL	small
STACK	256
.data
;сообщения 
fnd	db	0ah,0dh,'Символ найден','$'
nochar	db	0ah,0dh,'Символ не найден.','$'
mes1	db	0ah,0dh,'Исходная строка:','$'
string	db	'Поиск символа в этой строке.',0ah,0dh,'$' ;строка для поиска
mes2	db	0ah,0dh,'Введите символ, на который следует заменить найденный'
	db	0ah,0dh,'$'
mes3	db	0ah,0dh,'Новая строка: ','$'
.code
	assume	ds:@data,es:@data	;привязка ds и es
			;к сегменту данных
main:		;точка входа в программу
	mov	ax,@data	;загрузка сегментных регистров
	mov	ds,ax
	mov	es,ax	;настройка es на ds
	mov	ah,09h
	lea	dx,mes1
	int	21h	;вывод сообщения mes1
	lea	dx,string
	int	21h	;вывод string
	mov	al,'а'	;символ для поиска- `а`(кириллица)
	cld		;сброс флага df
	lea	di,string	;загрузка в di смещения string
	mov	cx,29	;для префикса repne - длина строки
;поиск в строке string до тех пор, пока
;символ в al и очередной символ в строке
;не равны: выход- при первом совпадении
cycl:
repne	scas	string
	je	found	;если элемент найден то переход на found
failed:		;иначе, если не найден, то вывод сообщения nochar
	mov	ah,09h
	lea	dx,nochar
	int	21h
	jmp	exit	;переход на выход
found:
	mov	ah,09h
	lea	dx,fnd
	int	21h	;вывод сообщения об обнаружении символа
;корректируем di для получения значения
;действительной позиции совпавшего элемента
;в строке и регистре al
	dec	di
new_char:		;блок замены символа
	mov	ah,09h
	lea	dx,mes2
	int	21h	;вывод сообщения mes2
;ввод символа с клавиатуры
	mov	ah,01h
	int	21h	;в al - введённый символ 
	stos	string	;сохраним введённый символ
			;(из al) в строке
			;string в позиции старого символа
	mov	ah,09h
	lea	dx,mes3
	int	21h	;вывод сообщения mes3
	lea	dx,string
	int	21h	;вывод сообщения string
;переход на поиск следующего символа 'а' в строке
	inc	di	;указатель в строке string на следующий,
			;после совпавшего, символ
	jmp	cycl	;на продолжение просмотра string
exit:		;выход
	mov	ax,4c00h
	int	21h
end	main	;конец программы

