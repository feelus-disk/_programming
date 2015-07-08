; wavdir.asm
; воспроизводит файл c:\windows\media\tada.wav, не используя DMA
; нормально работает только под DOS в реальном режиме
; (то есть не в окне DOS (Windows) и не под EMM386, QEMM или другими 
; подобными программами)
;
; Компиляция:
; TASM:
;  tasm /m wavdir.asm
;  tlink /t /x wavdir.obj
; MASM:
;  ml /c wavdir.asm
;  link wavdir.obj,,NUL,,,
;  exe2bin wavdir.exe wavdir.com
; WASM:
;  wasm wavdir.asm
;  wlink file wavdir.obj form DOS COM
;

FILESPEC equ 'c:\windows\media\tada.wav' ; имя файла tada.wav с 
			; полным путем (замените на c:\windows\tada.wav для 
			; старых версий Windows)
SBPORT equ 220h	; базовый порт звуковой платы (замените, если у вас он 
		; отличается)

	.model	tiny
	.code
	.186			; для pusha/popa 
org	100h		; COM-программа
start:
	call	dsp_reset	; сброс и инициализация DSP
	jc	no_blaster
	mov	bl,0D1h	; команда DSP D1h 
	call	dsp_write	; включить звук
	call	open_file	; открыть и прочитать tada.wav
	call	hook_int8	; перехватить прерывание таймера
	mov	bx,5		; делитель таймера для частоты 22 050 Hz
				; (на самом деле соответствует 23 867 Hz)
	call	reprogram_pit	; перепрограммировать таймер

main_loop:			; основной цикл
	cmp	byte ptr finished_flag,0
	je	main_loop	; выполняется, пока finished_flag равен нулю

	mov	bx,0FFFFh	; делитель таймера для частоты 18,2 Hz
	call	reprogram_pit	; перепрограммировать таймер
	call	restore_int8	; восстановить IRQ0
no_blaster:
	ret

buffer_addr	dw	offset buffer	; адрес текущего играемого байта
old_int08h	dd	?		; старый обработчик INT 08h (IRQ0)
finished_flag	db	0	; флаг завершения
filename	db	FILESPEC,0	; имя файла tada.wav с полным путем

; обработчик INT 08h (IRQ0)
; посылает байты из буфера в звуковую плату
int08h_handler	proc	far
	pusha			; сохранить регистры
	cmp	byte ptr cs:finished_flag,1 ; если флаг уже 1,
	je	exit_handler		; ничего не делать,
	mov	di,word ptr cs:buffer_addr ; иначе: DI = адрес текущего 
					; байта
	mov	bl,10h		; команда DSP 10h
	call	dsp_write		; непосредственный 8-битный вывод
	mov	bl,byte ptr cs:[di] ; BL = байт данных для вывода
	call	dsp_write
	inc	di			; DI = адрес следующего байта
	cmp	di,offset buffer+27459	; 27 459 - длина звука в tada.wav,
	jb	not_finished		; если весь буфер пройден,
	mov	byte ptr cs:finished_flag,1 ; установить флаг в 1,
not_finished:				; иначе:
	mov	word ptr cs:buffer_addr,di ; сохранить текущий адрес
exit_handler:
	mov	al,20h		; завершить обработчик аппаратного прерывания,
	out	20h,al		; послав неспецифичный EOI (см. гл. 1.2.10)
	popa			; восстановить регистры
	iret
int08h_handler	endp

; процедура dsp_reset
; сброс и инициализация DSP
dsp_reset proc near
	mov	dx,SBPORT+6 ; порт 226h - регистр сброса DSP
	mov	al,1	; запись единицы в него начинает инициализацию
	out	dx,al
	mov	cx,40	; небольшая пауза
dsploop:
	in	al,dx
	loop	dsploop
	mov	al,0	; запись нуля завершает инициализацию
	out	dx,al	; теперь DSP готов к работе
; проверить, есть ли DSP вообще
	add	dx,8	; порт 22Eh - состояние буфера чтения DSP
	mov	cx,100
check_port:
	in	al,dx		; прочитать состояние буфера
	and	al,80h	; проверить бит 7
	jz	port_not_ready	; если ноль - порт еще не готов
	sub	dx,4	; иначе: порт 22Ah - чтение данных из DSP
	in	al,dx
	add	dx,4	; и снова порт 22Eh, 
	cmp	al,0AAh	; если прочиталось число AAh - DSP присутствует
			; и действительно готов к работе,
	je	good_reset
port_not_ready:
	loop	check_port ; если нет - повторить проверку 100 раз
bad_reset:
	stc		; и сдаться
	ret		; выход с CF = 1,
good_reset:
	clc		; если инициализация прошла успешно
	ret		; выход с CF = 0
dsp_reset endp

; процедура dsp_write
; посылает байт из BL в DSP
dsp_write proc near
	mov	dx,SBPORT+0Ch ; порт 22Ch - ввод данных/команд DSP
write_loop:		; подождать готовности буфера записи DSP
	in	al,dx		; прочитать порт 22Ch
	and	al,80h	; и проверить бит 7,
	jnz	write_loop ; если он не ноль - подождать еще,
	mov	al,bl		; иначе:
	out	dx,al		; послать данные
	ret
dsp_write endp

; процедура reprogram_pit
; перепрограммирует канал 0 системного таймера на новую частоту
; Ввод: BX = делитель частоты
reprogram_pit	proc	near
	cli		; запретить прерывания
	mov	al,00110110b ; канал 0, запись младшего и старшего байтов,
				; режим работы 3, формат счетчика - двоичный
	out	43h,al	; послать это в регистр команд первого таймера
	mov	al,bl		; младший байт делителя -
	out	40h,al	; в регистр данных канала 0
	mov	al,bh		; и старший байт -
	out	40h,al	; туда же
	sti		; теперь IRQ0 вызывается с частотой 1 193 180/BX Hz
	ret
reprogram_pit	endp

; процедура hook_int8
; перехватывает прерывание INT 08h (IRQ0)
hook_int8 proc	near
	mov	ax,3508h	; AH = 35h, AL = номер прерывания
	int	21h		; получить адрес старого обработчика
	mov	word ptr old_int08h,bx	; сохранить его в old_int08h
	mov	word ptr old_int08h+2,es
	mov	ax,2508h	; AH = 25h, AL = номер прерывания
	mov	dx,offset int08h_handler ; DS:DX - адрес обработчика
	int	21h		; установить обработчик
	ret
hook_int8 endp

; процедура restore_int8
; восстанавливает прерывание INT 08h (IRQ0)
restore_int8	proc near
	mov	ax,2508h	; AH = 25h, AL = номер прерывания
	lds	dx,dword ptr old_int08h ; DS:DX - адрес обработчика
	int	21h		; установить старый обработчик
	ret
restore_int8	endp

; процедура open_file
; открывает файл filename и копирует звуковые данные из него, считая его файлом 
; tada.wav, в буфер buffer
open_file proc near
	mov	ax,3D00h	; AH = 3Dh, AL = 00
	mov	dx,offset filename ; DS:DX - ASCIZ-имя файла с путем
	int	21h		; открыть файл для чтения,
	jc	error_exit	; если не удалось открыть файл - выйти
	mov	bx,ax		; идентификатор файла в BX
	mov	ax,4200h	; AH = 42h, AL = 0
	mov	cx,0		; CX:DX - новое значение указателя
	mov	dx,38h ; по этому адресу начинаются данные в tada.wav
	int	21h		; переместить файловый указатель
	mov	ah,3Fh	; AH = 3Fh
	mov	cx,27459 ; это - длина звуковых данных в файле tada.wav
	mov	dx,offset buffer ; DS:DX - адрес буфера
	int	21h		; чтение файла
	ret
error_exit:			; если не удалось открыть файл
	mov	ah,9		; AH = 09h
	mov	dx,offset notopenmsg ; DS:DX = сообщение об ошибке
	int	21h		; открыть файл для чтения
	int	20h		; конец программы
notopenmsg	db	'Could not open file',0Dh,0Ah
		db	'Exiting',0Dh,0Ah,'$'
open_file endp

buffer:		; здесь начинается буфер длиной 27 459 байтов
	end	start
