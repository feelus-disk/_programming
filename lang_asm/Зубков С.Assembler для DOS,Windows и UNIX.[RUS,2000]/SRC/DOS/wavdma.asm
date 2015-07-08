; wavdma.asm
; Пpимеp пpогpаммы, пpоигpывающей файл C:\WINDOWS\MEDIA\TADA.WAV
; на звуковой каpте пpи помощи DMA
;
; Комниляция:
; TASM:
;  tasm /m wavdma.asm
;  tlink /t /x wavdma.obj
; MASM:
;  ml /c wavdma.asm
;  link wavdma.obj,,NUL,,,
;  exe2bin wavdma.exe wavdma.com
; WASM:
;  wasm wavdma.asm
;  wlink file wavdma.obj form DOS COM
;
FILESPEC equ 'c:\windows\media\tada.wav' ; замените на c:\windows\tada.wav
					 ; для старых версий windows
SBPORT	equ 220h
; SBDMA	equ 1		; процедура program_dma расчитана только на канал 1
SBIRQ	equ 5		; только IRQ0-IRQ7
	.model	tiny
	.code
	.186
	org	100h		; COM-программа
start:
	call	dsp_reset	; инициализация DSP
	jc	no_blaster
	mov	bl,0D1h		; команда 0D1h
	call	dsp_write	; включить звук
	call	open_file	; прочитать файл в буфер
	call	hook_sbirq	; перехватить прерывание
	mov	bl,40h		; команда 40h
	call	dsp_write	; установка скорости передачи
	mov	bl,0B2h		; константа для 11025Hz/Stereo
	call	dsp_write
	call	program_dma	; начнём DMA-передачу данных

main_loop:			; основной цикл
	cmp	byte ptr finished_flag,0
	je	main_loop	; выход когда байт finished_flag = 1

	call	restore_sbirq	; восстановить прерывание
no_blaster:
	ret

old_sbirq	dd	?	; адрес старого обработчика
finished_flag	db	0	; флаг окончания работы
filename	db	FILESPEC,0	; имя файла

; обработчик прерывания звуковой карты
; устанавливает флаг finished_flag в 1
sbirq_handler	proc	far
	push	ax
	mov	byte ptr cs:finished_flag,1	; установить флаг
	mov	al,20h		; послать команду EOI
	out	20h,al		; в контроллер прерываний
	pop	ax
	iret
sbirq_handler	endp

; процедура dsp_reset
; сброс и инициализация DSP
dsp_reset proc near
	mov	dx,SBPORT+6 ; порт 226h - регистр сброса DSP
	mov	al,1	; запись в него единицы запускает инициализацию
	out	dx,al
	mov	cx,40	; небольшая пауза
dsploop:
	in	al,dx
	loop	dsploop
	mov	al,0	; запись нуля завершает инициализацию
	out	dx,al	; теперь DSP готов к работе

	add	dx,8	; порт 22Eh - бит 7 при чтении указывает на занятость
	mov	cx,100	; буфера записи DSP
check_port:
	in	al,dx	; прочитаем состояние буфера записи
	and	al,80h	; если бит 7 ноль
	jz	port_not_ready	; порт ещё не готов
	sub	dx,4	; иначе: порт 22Ah - чтение данных из DSP
	in	al,dx
	add	dx,4	; порт снова 22Eh 
	cmp	al,0AAh	; проверим, что DSP возвращает 0AAh при чтении - 
			; это сигнал его готовности к работе
	je	good_reset
port_not_ready:
	loop	check_port ; повторить проверку на 0AAh 100 раз 
bad_reset:
	stc		; если Sound Blaster не откликается
	ret		; вернуться с CF=1
good_reset:
	clc		; если инициализация прошла успешно
	ret		; вернуться с CF=0
dsp_reset endp

; процедура dsp_write
; посылает байт из BL в DSP
dsp_write proc near
	mov	dx,SBPORT+0Ch ; порт 22Ch - ввод данных/команд DSP
write_loop:		; подождём готовности буфера записи DSP
	in	al,dx	; прочитаем порт 22Ch
	and	al,80h	; и проверим бит 7
	jnz	write_loop ; если он не ноль - подождём ещё
	mov	al,bl	; иначе:
	out	dx,al	; пошлём данные
	ret
dsp_write endp

; процедура hook_sbirq
; перехватывает прерывание звуковой карты и разрешает его
hook_sbirq proc	near
	mov	ax,3508h+SBIRQ	; AH=35h, AL=номер прерывания
	int	21h		; получим адрес старого обработчика
	mov	word ptr old_sbirq,bx	; и сохраним его
	mov	word ptr old_sbirq+2,es
	mov	ax,2508h+SBIRQ	; AH=25h, AL=номер прерывания
	mov	dx,offset sbirq_handler	; установим новый обработчик
	int	21h
	mov	cl,1
	shl	cl,SBIRQ
	not	cl		; построим битовую маску
	in	al,21h		; прочитаем OCW1
	and	al,cl		; разрешим прерывание
	out	21h,al		; запишем OCW1
	ret
hook_sbirq endp

; процедура restore_sbirq
; восстановим обработчик и запретим прерывание
restore_sbirq	proc near
	mov	ax,3508h+SBIRQ	; AH=25h AL=номер прерывания
	lds	dx,dword ptr old_sbirq
	int	21h		; восстановим обработчик
	mov	cl,1
	shl	cl,SBIRQ	; построим битовую маску
	in	al,21h		; прочитаем OCW1
	or	al,cl		; запретим прерывание
	out	21h,al		; запишем OCW1
	ret
restore_sbirq	endp

; процедура open_file
; открывает файл filename и копирует звуковые данные из него, считая что
; это - tada.wav, в буфер buffer
open_file proc near
	mov	ax,3D00h	; AH=3Dh AL=00
	mov	dx,offset filename	; DS:DX - ASCIZ-строка с именем файла
	int	21h		; открыть файл для чтения
	jc	error_exit	; если не удалось открыть файл - выйти
	mov	bx,ax		; идентификатор файла в BX
	mov	ax,4200h	; AH=42h, AL=0
	mov	cx,0		; CX:DX - новое значение указателя
	mov	dx,38h	; по этому адресу начинаются данные в tada.wav
	int	21h		; переместим файловый указатель
	mov	ah,3Fh		; AH=3Fh
	mov	cx,27459 ; это - длина данных в файле tada.wav
	push	ds
	mov	dx,ds
	and	dx,0F000h	; выровняем буфер на границу 4K-страницы
	add	dx,1000h	; для DMA
	mov	ds,dx
	mov	dx,0		; DS:DX - адрес буфера
	int	21h		; чтение файла
	pop	ds
	ret
error_exit:			; если не удалось открыть файл
	mov	ah,9		; AH=09h
	mov	dx,offset notopenmsg	; DS:DX = адрес сообщения об ошибке
	int	21h		; вывод строки на экран
	int	20h		; конец программы
notopenmsg	db	'Could not open file',0Dh,0Ah	; сообщение об ошибке
		db	'Exiting',0Dh,0Ah,'$'
open_file endp

; процедура program_dma
; настраивает канал 1 DMA
program_dma proc near
	mov	al,5	; замаскируем канал 1
	out	0Ah,al
	xor	al,al	; обнулим счётчик
	out	0Ch,al
	mov	al,49h	; установим режим передачи
			; (используйте 59h для автоинициализации)
	out	0Bh,al

	push	cs
	pop	dx
	and	dh,0F0h
	add	dh,10h	; вычислим адрес буфера

	xor	ax,ax
	out	02h,al	; запишем младшие 8 бит
	out	02h,al	; запишем следующие 8 бит
	mov	al,dh
	shr	al,4
	out	83h,al	; запишем старшие 4 бита

	mov	ax,27459	; длина данных в tada.wav
	dec	ax		; DMA требует длину-1
	out	03h,al		; запишем младшие 8 бит длины
	mov	al,ah
	out	03h,al		; запишем старшие 8 бит длины
	mov	al,1
	out	0Ah,al		; снимем маску с канала 1

	mov	bl,14h		; команда 14h
	call	dsp_write	; 8-битное простое DMA-воспроизведение
	mov	bx,27459	; размер данных в tada.wav
	dec	bx		; минус 1
	call	dsp_write	; запишем в DSP младшие 8 бит длины
	mov	bl,bh
	call	dsp_write	; и старшие
	ret
program_dma endp
	end	start
