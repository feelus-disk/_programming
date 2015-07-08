;pril_8.asm
;Демонстрация работы сo структурами: 
;1-добавление новой записи;
;2-поиск записи;
;3-удаление записи.
.386
MASM
MODEL	use16 small	;модель памяти
STACK	256	;размер стека
include	mac.inc	;подключение файла с макросами

worker	struc	;информацияао сотруднике
nam	db	30 dup (' ')	;фамилия, имя, отчество
sex	db	' '	;пол
position	db	30 dup (' ')	;должность
age	db	2 dup (' ')	;возраст
standing	db	2 dup (' ')	;стаж
salary	db	4 dup (' ')	;оклад в рублях
birthdate	db	8 dup (' ')	;дата рождения
worker	ends

.data
N=5			;размерность базы данных
;массив структур
StrWork	worker	<>	;рабочая структура для различных промежуточных манипуляций	
sotr	worker N DUP (<>)	;массив структур

mes1	db	10,13,10,13,'*************************************'
	db	10,13,'*Демонстрация работы со структурами:*'
	db	10,13,'*Режимы работы:                     *'
	db	10,13,'*1-добавление;                      *'
 	db	10,13,'*2-поиск;                           *'
 	db	10,13,'*3-удаление;                        *'
	db	10,13,'*0-выход.                           *'
	db	10,13,'*************************************'
	db	10,13,'Введите выбор : ','$'


mname	db	10,13,10,13,'Введите имя (не более 30 символов) - $'
msex	db	10,13,'Введите пол (''м'' или ''ж'') - $'
mposition	db	10,13,'Введите должность (не более 30 символов) - $'
mage	db	10,13,'Введите возраст (не более 2 символов) - $'
mstanding	db	10,13,'Введите стаж работы (не более 2 символов) - $'
msalary	db	10,13,'Введите оклад (не более 4 символов) - $'
mbirthdate	db	10,13,'Введите дату рожденияа (дд.мм.гг) - $'

findname	db	10,13,10,13,'Введите имя для поиска - $'
mes2	db	10,13,10,13,'Имя - '
mname1	db	30 dup (' ')
	db	10,13,'Пол - '
msex1	db	' '
	db	10,13,'Должность - '
mposition1	db	30 dup (' ')
	db	10,13,'Возраст - '
mage1	db	2 dup (' ')
	db	10,13,'Стаж - '
mstanding1	db	2 dup (' ')
	db	10,13,'Оклад - '
msalary1	db	4 dup (' ')
	db	10,13,'Дата рождения - '
mbirthdate1	db	8 dup (' '),'$'

mes3	db	10,13,10,13,'Запись успешно удалена!','$'
Err1	db	10,13,10,13,'Нет места в базе данных.','$'
Err2	db	10,13,10,13,'Такой записи нет в базе данных! Повторите запрос.','$'
Thanks	db	10,13,10,13,'Спасибо за внимание! Успехов в освоении ассемблера!','$'
Flag	db	0	;флаг для использования в процедуре delete

.code
	assume	ds:@data,es:@data
main:		;начало программы
	mov	ax,@data
	mov	ds,ax	
	xor	ax,ax
	push	ds
	pop	es
;выбор режима работы:
go:
	OutStr	mes1	;вывод строки mes1 на экран
	GetChar		;ввод и определение режима работы
	cmp	al,31h
	je	insert
	cmp	al,32h
	je	search
	cmp	al,33h
	je	delete
	cmp	al,30h
	je	exit
	jmp	go

Insert	proc
;добавление новой записи
;заполняем рабочую структуру
	OutStr	mname	
	GetStr	StrWork.nam,30
	OutStr	msex	
	GetStr	StrWork.sex,1
	OutStr	mposition	
	GetStr	StrWork.position,30
	OutStr	mage	
	GetStr	StrWork.age,2
	OutStr	mstanding	
	GetStr	StrWork.standing,2
	OutStr	msalary	
	GetStr	StrWork.salary,4
	OutStr	mbirthdate	
	GetStr	StrWork.birthdate,8
;поиск свободного элемента в массиве структур (в ней все поля пустые):
	lea	di,sotr
	mov	cx,N
cyc1:
	cmp	[di].sex,' '	;будем искать свободную запись по пустому полю sex
	je	m1
	add	di,type	worker
	loop	cyc1
	OutStr	Err1
	jmp	go
;копируем StrWork в свободную запись базы данных
m1:			
	lea	si,StrWork	;откуда - ds:si
;				;куда - es:di (уже загружены)
	mov	cx,type worker
rep	movsb
;заканчиваем и уходим на основное меню программы:
	jmp	go
Insert	endp

search	proc	near
;процедурa поиска записи в массиве и вывода на экран ее содержимого
	OutStr	findname
	GetStr	StrWork.nam,30
	push	ds
	pop	es	
	lea	bx,sotr
	mov	cx,N
cyc2:	
	push	cx
	mov	cx,30
	mov	di,bx	
	lea	si,StrWork
repe	cmpsb		;будем искать путем сравнения цепочек
	jcxz	m2	;если цепочки совпадают, то переход на m2
	add	bx,type	worker
	pop	cx
	loop	cyc2
	OutStr	Err2
	jmp	go
m2:
	pop	cx	;удалим из стека cx
	cmp	Flag,0
	je	m22
	ret
m22:
;выведем на экран содержимое найденной записи, ее адрес в bx	
	mov_string	mname1,[bx].nam,30
	mov_string	msex1,[bx].sex,1
	mov_string	mposition1,[bx].position,30
	mov_string	mage1,[bx].age,2
	mov_string	mstanding1,[bx].standing,2
	mov_string	msalary1,[bx].salary,4
	mov_string	mbirthdate1,[bx].birthdate,8
	OutStr	mes2
	jmp	go
search	endp	

delete	proc
;удаление - очистка полей структуры пробелами 
;сначала найдем нужную для удаления запись, для этого
;частично используем код процедуры search.
	mov	Flag,1	;указать на частичное использование кода search
	call	search
	mov	Flag,0	;сбросим Flag
;адрес удаляемой строки в bx
;очищаем поля записи, для чего используем макрокоманду null_string
	null_string	[bx].nam,30
	null_string	[bx].sex,1
	null_string	[bx].position,30
	null_string	[bx].age,2
	null_string	[bx].standing,2
	null_string	[bx].salary,4
	null_string	[bx].birthdate,8
	OutStr	mes3
	jmp	go
delete	endp

exit:
	OutStr	Thanks
	_Exit	;стандартный выход;
end	main		;конец программы;
