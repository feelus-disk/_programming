
;		TEST20.ASM - программа к Главе № 20
;		  Для экспериментов с заражениями.

CSEG segment
assume cs:CSEG, ds:CSEG, es:CSEG, ss:CSEG
org 100h

Begin:
       mov ah,9
       mov dx,offset Message
       int 21h

       ret

Message db 'Hello!$'

CSEG ends
end Begin