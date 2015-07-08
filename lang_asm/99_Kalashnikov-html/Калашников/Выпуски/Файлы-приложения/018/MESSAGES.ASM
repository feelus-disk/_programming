Mess_about db 0Ah, 0Dh, 'SuperShell - оболочка для DOS, написанная на Ассемблере.',0Ah, 0Dh
           db 'Книга "Ассемблер? Это просто! Учимся программировать под MS-DOS", Глава № 18',0Ah,0Dh
           db 'http://www.Kalashnikoff.ru. E-mail: Assembler@Kalashnikoff.ru',0Ah,0Dh,0Ah
           db '(C) Авторские права на файлы-приложения принадлежат автору книги.',0Ah, 0Dh, 0Ah
           db 9,9,'=== Россия, Москва, 2000 год ===',0Ah,0Dh,'$'

Mess_head db ' Super Shell, Версия 1.0 ',0
Mess_down db ' Россия, Москва, 2000 ',0

Mess_qup db ' Выход ',0
Mess_quit db ' Вы действительно хотите выйти в DOS (Y/N)?',0
Mess_quitl equ $-Mess_quit