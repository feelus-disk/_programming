;---------Prg_5_2.asm----------------------------------------------------------------------------
; Пример использования директив резервирования и инициализации данных.
;-----------------------------------------------------------------------------------------------------
masm
model small
.stack 100h
.data
message db 'Запустите эту программу в отладчике','$'
perem_1	db	0ffh
perem_2	dw	3a7fh
perem_3	dd	0f54d567ah
mas	db	10 dup (' ')
pole_1	db	5 dup (?)
adr	dw	perem_3
adr_full	dd	perem_3
fin	db	'Конец сегмента данных программы $'
.code
start:
	mov	ax,@data
	mov	ds,ax
	mov	ah,09h
	mov	dx,offset message
	int		21h
	mov	ax,4c00h
	int	21h
end	start

