;prg_11_1.asm
MASM
MODEL	small
STACK	256
.data
source	db	'Тестируемая строка','$'	;строка-источник
dest	db	19 DUP (' ')	;строка-приёмник
.code
	assume	ds:@data,es:@data
main:			;точка входа в программу
	mov	ax,@data	;загрузка сегментных регистров
	mov	ds,ax	;настройка регистров DS и ES
			;на адрес сегмента данных
	mov	es,ax
	cld		;сброс флага DF - обработка
			;строки от начала к концу
	lea	si,source	;загрузка в si смещения
			;строки-источника
	lea	di,dest	;загрузка в DS смещения строки-приёмника
	mov	cx,20	;для префикса rep - счетчик
			;повторений (длина строки)
rep	movs	dest,source	;пересылка строки
	lea	dx,dest
	mov	ah,09h	;вывод на экран строки-приёмника
	int	21h
exit:
	mov	ax,4c00h
	int	21h
end	main

