;prg_13_2.asm
init_ds	macro
;макрос настройки ds на сегмент данных
	mov	ax,data
	mov	ds,ax
	xor	ax,ax
	endm
out_str	macro	str
;макрос вывода строки на экран.
;На входе - выводимая строка.
;На выходе - сообщение на экране.
	push	ax
	mov	ah,09h
	mov	dx,offset str
	int	21h
	pop	ax
	endm
exit	macro
;макрос конца программы
	mov	ax,4c00h
	int 21h
	endm
num_char	macro	message
	local	m1,elem,num,err_mes,find,num_exit
;макрос подсчета количества символов в строке.
;Длина строки - не более 99 символов.
;Вход: message - адрес строки символов, ограниченной '$'
;Выход: в al - количество символов в строке message
;и вывод сообщения
	jmp	m1
elem	db	'Строка &message содержит '
num	db	2 dup (0)	;число символов в строке
			;message в коде ASCII
	db	' символов',10,13,'$'	;конец строки
			;для вывода функцией 09h
err_mes	db	'Строка &message не содержит символа конца строки',10,13,'$'
m1:
;сохраняем используемые в макросе регистры
	push	es
	push	cx
	push	ax
	push	di
	push	ds
	pop	es	;настройка es на ds
	mov	al,'$'	;символ для поиска - `$`
	cld		;сброс флага df
	lea	di,message	;загрузка в es:di смещения
			;строки message
	push	di	;запомним di - адрес начала строки
	mov	cx,99	;для префикса repne - максимальная
			;длина строки
;поиск в строке (пока нужный символ
;и символ в строке не равны)
;выход - при первом совпавшем
repne	scasb
	je	find	;если символ найден -переход на обработку
;вывод сообщения о том, что символ не найден
	push	ds
;подставляем cs вместо ds для функции 09h (int21h)
	push	cs
	pop	ds
	out_str	err_mes
	pop	ds
	jmp	num_exit	;выход из макроса
find:		;совпали
;считаем количество символов в строке:
	pop	ax	;восстановим адрес начала строки
	sub	di,ax	;(di)=(di)-(ax)
	xchg	di,ax	;(di) <-> (ax)
	sub	al,3	;корректировка на служебные
			;символы - 10, 13, '$'
	aam		;в al две упакованные BCD-цифры
			;результата подсчета
	or	ax,3030h	;преобразование результата
			;в код ASCII
	mov	cs:num,ah
	mov	cs:num+1,al
;вывести elem на экран
	push	ds
;подставляем cs вместо ds для функции 09h (int21h)
	push	cs
	pop	ds
	out_str	elem
	pop	ds
num_exit:
	push	di
	push	ax
	push	cx
	push	es
	endm

data	segment para public 'data'
msg_1	db	'Строка_1 для испытания',10,13,'$'
msg_2	db	'Строка_2 для второго испытания',10,13,'$'
data	ends

stk	segment stack
	db	256 dup('?')
stk	ends

code	segment para public 'code'
	assume	cs:code,ds:data,ss:stk
main	proc
	init_ds
	out_str	msg_1
	num_char	msg_1
	out_str	msg_2
	num_char	msg_2
	exit
main	endp
code	ends
end	main

