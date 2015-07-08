; cat.asm
; копирует объединенное содержимое всех файлов, указанных в командной строке, в 
; стандартный вывод. Можно как указывать список файлов, так и использовать маски 
; (символы "*" и "?") в одном или нескольких параметрах,
; например:
; cat header *.txt footer > all-texts помещает содержимое файла
; header, всех файлов с расширением .txt в текущей директории, и файла 
; footer в файл all-texts
; длинные имена файлов не используются, ошибки игнорируются
;
; Компиляция:
; TASM:
; tasm /m cat.asm
; tlink /t /x cat.obj
; MASM:
; ml /c cat.asm
; link cat.obj,,NUL,,,
; exe2bin cat.exe cat.com
; WASM:
; wasm cat.asm
; wlink file cat.obj form DOS COM
;


		.model tiny
		.code
		org 80h			; по смещению 80h от начала PSP находятся:
cmd_length	db ?			; длина командной строки
cmd_line	db ?			; и сама командная строка
		org 100h		; начало COM-программы - 100h от начала PSP
start:
		cld			; для команд строковой обработки
		mov	bp,sp		; сохраним текущую вершину стека в BP
		mov	cl,cmd_length
		cmp	cl,1		; если командная строка пуста -
		jle	show_usage	; вывести информацию о программе и выйти

		mov	ah,1Ah	; функция DOS 1Ah
		mov	dx,offset DTA
		int	21h		; переместить DTA (по умолчанию она совпадает
					; с командной строкой PSP)

; преобразовать список параметров в PSP:81h следующим образом:
; каждый параметр заканчивается нулем (ASCIZ-строка)
; адреса всех параметров помещаются в стек в порядке обнаружения
; в переменную argc записывается число параметров

		mov	cx,-1		; для команд работы со строками
		mov	di,offset cmd_line ; начало командной строки в ES:DI

find_param:
		mov	al,' '		; искать первый символ,
		repz scasb		; не являющийся пробелом
		dec	di		; DI - адрес начала очередного параметра
		push	di		; поместить его в стек
		inc	word ptr argc	; и увеличить argc на один
		mov	si,di		; SI = DI для следующей команды lodsb
scan_params:
		lodsb			; прочитать следующий символ из параметра,
		cmp	al,0Dh	; если это 0Dh - это был последний параметр
		je	params_ended	; и он кончился,
		cmp	al,20h	; если это 20h - этот параметр кончился,
		jne	scan_params	; но могут быть еще

		dec	si		; SI - первый байт после конца параметра
		mov	byte ptr [si],0	; запишем в него 0
		mov	di,si		; DI = SI для команды scasb
		inc	di		; DI - следующий после нуля символ
		jmp short find_param	; продолжим разбор командной строки

params_ended:
		dec	si		; SI - первый байт после конца последнего
		mov	byte ptr [si],0	; параметра - записать в него 0


; каждый параметр воспринимается как файл или маска для поиска файлов
; все найденные файлы выводятся на stdout. Если параметр - не имя файла, то 
; ошибка игнорируется

		mov	si,word ptr argc ; SI - число оставшихся параметров
next_file_from_param:
		dec	bp
		dec	bp		; BP - адрес следующего адреса параметра
	
		dec	si		; уменьшить число оставшихся параметров,
		js	no_more_params	; если оно стало отрицательным - все

		mov	dx,word ptr [bp] ; DS:DX - адрес очередного параметра

		mov	ah,4Eh		; Функция DOS 4Eh
		mov	cx,0100111b	; искать все файлы, кроме директорий и меток тома
		int	21h		; найти первый файл
		jc	next_file_from_param ; если произошла ошибка - файла нет

		call	output_found	; вывести найденный файл на stdout

find_next:
		mov	ah,4Fh		; Функция DOS 4Fh
		mov	dx,offset DTA	; адрес нашей области DTA
		int	21h		; найти следующий файл
		jc	next_file_from_param	; если ошибка - файлы кончились
	
		call	output_found	; вывести найденный файл на stdout

		jmp short find_next	; продолжить поиск файлов

no_more_params:
		mov	ax,word ptr argc
		shl	ax,1
		add	sp,ax		; удалить из стека 2 * argc байтов
					; (то есть весь список адресов
					; параметров командной строки)
		ret			; конец программы


; процедура show_usage
; выводит информацию о программе
;
show_usage:
		mov	ah,9		; Функция DOS 09h
		mov	dx,offset usage
		int	21h		; вывести строку на экран
		ret			; выход из процедуры

; процедура output_found
; выводит в stdout файл, имя которого находится в области DTA

output_found:
		mov	dx,offset DTA+1Eh ; адрес ASCIZ-строки с именем файла
		mov	ax,3D00h	; Функция DOS 3Dh
		int	21h		; открыть файл (al = 0 - только на чтение),
		jc	skip_file	; если ошибка - не трогать этот файл
		mov	bx,ax		; идентификатор файла - в BX
		mov	di,1		; DI будет хранить идентификатор STDOUT
do_output:
		mov	cx,1024	; размер блока для чтения файла
		mov	dx,offset DTA+45 ; буфер для чтения/записи располагается за 
					; концом DTA
		mov	ah,3Fh	; Функция DOS 3Fh
		int	21h		; прочитать 1024 из файла,
		jc	file_done	; если ошибка - закрыть файл
		mov	cx,ax		; число реально прочитанных байтов в CX,
		jcxz	file_done	; если это не ноль - закрыть файл

		mov	ah,40h		; Функция DOS 40h
		xchg	bx,di		; BX = 1 - устройство STDOUT
		int	21h		; вывод прочитанного числа байтов в STDOUT
		xchg	di,bx		; вернуть идентификатор файла в BX
		jc	file_done	; если ошибка - закрыть файл
		jmp short do_output	; продолжить вывод файла
file_done:
		mov	ah,3Eh		; Функция DOS 3Eh
		int	21h		; закрыть файл
skip_file:
		ret			; конец процедуры output_found

usage		db	'cat.asm v1.0',0Dh,0Ah
		db	'concatenate and print files to stdout',0Dh,0Ah
		db	'usage: cat filename.ext, ...',0Dh,0Ah
		db	'(filenames can contain wildcards)',0Dh,0Ah,'$'

argc		dw	0		; число параметров (должен быть 0 при старте 
					; программы!)

DTA:				; область DTA начинается сразу за концом файла, а 
				; сразу за областью DTA начинается 
				; 1024-байтный буфер для чтения файла
		end start
