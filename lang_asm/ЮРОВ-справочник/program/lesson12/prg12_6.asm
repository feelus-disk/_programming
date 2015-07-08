;prg12_6.asm
masm
model	small
stack	256
.586P
pnt struc	;структура pnt, содержащая вложенное объединение
	union		;описание вложенного в структуру объединения
offs_16	dw	?
offs_32	dd	?
	ends		;конец описания объединения
segm	dw	?
	ends		;конец описания структуры
.data
point	union	;определение объединения,
;содержащего вложенную структуру
off_16	dw	?
off_32	dd	?
point_16	pnt	<>
point_32	pnt	<>
point	ends
tst	db	"Строка для тестирования"
adr_data	point	<>	;определение экземпляра объединения
.code	
main:	
	mov	ax,@data
	mov	ds,ax
	mov	ax,seg tst
;записать адрес сегмента строки tst в поле структуры adr_data
	mov	adr_data.point_16.segm,ax
;когда понадобится можно извлечь значение из этого поля обратно, к примеру, в регистр bx:
	mov	bx,adr_data.point_16.segm 
;формируем смещение в поле структуры adr_data
	mov	ax,offset tst	;смещение строки в ax
	mov	adr_data.point_16.offs_16,ax
;аналогично, когда понадобится, можно извлечь значение из этого поля:
	mov	bx,adr_data.point_16.offs_16
	exit:
	mov	ax,4c00h
	int	21h
end	main

