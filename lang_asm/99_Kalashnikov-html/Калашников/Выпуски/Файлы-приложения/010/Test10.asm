
; Перед выполнением данной программы, Резидент Prog10.com должен быть
;                       уже загружен в память!

CSEG segment
assume CS:CSEG, DS:CSEG, ES:CSEG, SS:CSEG
org 100h

Begin:
	mov ah,9
	mov dx,offset String
	int 21h

	int 20h

String db 'My string.$'  ;Пробуем вывести это строку

CSEG ends
end Begin
