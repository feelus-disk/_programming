
;              Prog07.asm - программа к Главе № 07

; (С) Авторские права на файлы-приложения принадлежат автору книги
; "Ассемблер? Это просто! Учимся программировать под MS-DOS"
; Автор: Калашников Олег Александрович (e-mail: Assembler@Kalashnikoff.ru)
;	 http://www.Kalashnikoff.ru

; --- Ассемблирование (получение *.com файла) ---
;При использовании MASM 6.11 - 6.13:
;ML.EXE prog07.asm /AT

;При использовании TASM:
;TASM.EXE prog07.asm
;TLINK.EXE prog07.obj /t/x


CSEG segment
assume cs:CSEG, ds:CSEG, es:CSEG, ss:CSEG
org 100h

Begin:
	call Wait_key  ;Вызываем процедуру ожидания нажатия клавиши

	cmp al,27      ;Пользователь нажал ESC?
	je Quit_prog   ;Если так, то на метку Quit_prog 

	cmp al,0       ;Это расширенный код клавиши?
	je Begin       ;Если так, то ждем нажатия следующей клавиши 

	call Out_char  ;Иначе выводим символ на экран
	jmp Begin      ;И оджидаем нажатия следующей клавиши 


;Пользователь нажал ESC
Quit_prog:
	mov al,32      ;Иммитируем нажатие на "Пробел"
	call Out_char

	int 20h        ;Выходим из программы



; === Подпрограммы ===

; --- Wait_key ---
Wait_key proc
	mov ah,10h ;Функция 10h прерывания 16h - ожидание нажатия клавиши
	int 16h
	ret
Wait_key endp


; --- Out_char ---
Out_char proc
;Выводим символ на экран путем прямого отображения в видеобуфер

	push cx        ;Сохраним в стеке изменяемые данной процедурой регистры
	push ax
	push es

	push ax
	mov ax,0B800h  ;Готовим регистры к выводу символа на экран
	mov es,ax
	mov di,0
	mov cx,2000    ;Будем выводить 2000 раз (80 * 25 = 2000 - весь экран)
	pop ax
	mov ah,31      ;Атрибуты выводимого символа

Next_sym:
	mov es:[di],ax
	inc di         ;Увеличиваем указатель вывода символа на 2
	inc di
	loop Next_sym  ;Следующий символ 

	pop es         ;Восстановим сохраненные в стеке регистры
	pop ax
	pop cx
	ret
Out_char endp


CSEG ends
end Begin
