
;              TEST24.ASM - программа к Главе № 24
;                Для экспериментов с заражениями.

CSEG segment
assume cs:CSEG, ds:CSEG, es:CSEG, ss:CSEG
org 100h

Begin:
       mov ah,9
       mov dx,offset Message
       int 21h

       ret

Message db 'Приветствую Вас!',0Ah,0Dh,'$'

For_test db 35000 dup (0) ;!!! Наш файл увеличится на 35.000 байт !!!

CSEG ends
end Begin