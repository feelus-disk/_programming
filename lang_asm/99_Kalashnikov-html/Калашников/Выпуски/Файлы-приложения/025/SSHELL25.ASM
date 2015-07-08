
;              Sshell25.ASM - программа к Главе № 25

; (С) Авторские права на файлы-приложения принадлежат автору книги
; "Ассемблер? Это просто! Учимся программировать под MS-DOS"
; Автор: Калашников Олег Александрович (e-mail: Assembler@Kalashnikoff.ru)
;	 http://www.Kalashnikoff.ru

; --- Ассемблирование (получение *.com файла) ---
;При использовании MASM 6.11 - 6.13:
;ML.EXE sshell25.asm /AT

;При использовании TASM:
;TASM.EXE sshell25.asm
;TLINK.EXE sshell25.obj /t/x


.386 ;Будем использовать регистры и команды 80386 процессора,
.287 ;А также команды 80287 сопроцессора
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
        call Check_video ;проверим видеорежим и текущую страницу

        mov ah,9
        mov dx,offset Mess_about
        int 21h ;выводим сообщение с приветствием

        call Main_proc ;головная процедура

; Выходим в DOS
        int 20h

Finish equ $    ;Это финиш!

CSEG ends
end Start