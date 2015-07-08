;  === DATA.ASM - данные оболочки ===

;               ==== ПЕРЕМЕННЫЕ ====

Num_attr db ? ;переменная для атрибутов

Num_DX dw ?

Video_page db 0 ;текущая видеостраница

Pos_cursor dw ? ;главная позиция курсора

Handle dw ? ;Номер файла

; --- Данные для процедуры Draw_frame ---
Height_X equ [bp+12] ;высота рамки
Width_Y  equ [bp+10] ;ширина рамки
Attr     equ [bp+8]  ;атрибуты рамки
Mess_up  equ [bp+6]  ;сообщение вверху рамки
Mess_dn  equ [bp+4]  ;сообщение внизу рамки
Mess_ins equ [bp+2]  ;сообщение внутри рамки
Other    equ [bp]    ;иная конфигурация окна
