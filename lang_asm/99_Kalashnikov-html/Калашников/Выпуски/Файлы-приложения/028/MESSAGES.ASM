;   === MESSAGES.ASM - Конфигурационный файл ===

Mess_about db 0Ah, 0Dh, 'SuperShell - оболочка для DOS, написанная на Ассемблере.',0Ah, 0Dh
           db 'Книга "Ассемблер? Это просто! Учимся программировать под MS-DOS", Глава № 28',0Ah,0Dh
           db 'http://www.Kalashnikoff.ru. E-mail: Assembler@Kalashnikoff.ru',0Ah,0Dh,0Ah
           db '(C) Авторские права на файлы-приложения принадлежат автору книги.',0Ah, 0Dh, 0Ah
           db 9,9,'=== Россия, Москва, 2001 год ===',0Ah,0Dh,'$'

Main_color dw 1F00h
Mess_head db 1Eh, ' Super Shell, Версия 1.0 ',0
Mess_down db 1Dh, ' Россия, Москва, 2001 ',0

Mess_qup db 4Eh, ' Выход ',0
Mess_quit db 4Bh, ' Вы действительно хотите выйти в DOS (Y/N)?',0
Mess_quitl equ $-Mess_quit-1 ;Один байт занимает код цвета (4Bh)