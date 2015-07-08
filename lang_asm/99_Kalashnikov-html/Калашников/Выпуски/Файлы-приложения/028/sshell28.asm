
;              Sshell28.ASM - программа к Главе № 28

; (С) Авторские права на файлы-приложения принадлежат автору книги
; "Ассемблер? Это просто! Учимся программировать под MS-DOS"
; Автор: Калашников Олег Александрович (e-mail: Assembler@Kalashnikoff.ru)
;	 http://www.Kalashnikoff.ru

; --- Ассемблирование (получение *.com файла) ---
;При использовании MASM 6.11 - 6.13:
;ML.EXE sshell28.asm /AT

;При использовании TASM:
;TASM.EXE sshell28.asm
;TLINK.EXE sshell28.obj /t/x


.386
.287
CSEG segment use16
assume cs:CSEG, ds:CSEG, es:CSEG, ss:CSEG
org 100h

Start:
        jmp Begin

; ======= Процедуры =========
; Головная
include main.asm

; Работа с дисплеем
include display.asm

; Работа с файлами
include files.asm

; Работа с клавиатурой
include keyboard.asm

; Сообщения
include messages.asm

; Переменные
include data.asm

; Начало программы
Begin:
        call Check_video ;Проверим видеорежим и текущую страницу

        mov ah,9
        mov dx,offset Mess_about
        int 21h ;выводим сообщение с приветствием

        call Main_proc ; === Головная процедура ===

; Выходим в DOS
        int 20h

Current_dir equ $              ;Область хранения текущего каталога

Temp_files equ Current_dir+300 ;Временное хранение найденного файла

Finish equ Temp_files+320      ;Это финиш!

CSEG ends
end Start