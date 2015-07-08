;prg8_12.asm
masm
model	small
stack	256
.data	;сегмент данных
b	db	17h	;упакованное число 17h
c	db	45h		;упакованное число 45
sum	db	2 dup (0)
.code	;сегмент кода
main:	;точка входа в программу
	mov	ax,@data
	mov	ds,ax
	xor	ax,ax
	mov	al,b
	add	al,c
	daa
	jnc	$+6	;переход через команду, если результат <= 99
	mov	sum+1,ah	;учет переноса при сложении (результат > 99)
	mov	sum,al	;младшие упакованные цифры результата
exit:
	mov	ax,4c00h
	int	21h
end	main

