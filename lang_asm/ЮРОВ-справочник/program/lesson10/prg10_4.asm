;prg_10_4.asm
model small
.stack	100h
.data
len equ	10	;количество элементов в mas
mas	db	1,0,9,8,0,7,8,0,2,0
message	db	'В поле mas нет элементов, равных нулю,$'
.code
start:
	mov	ax,@data
	mov	ds,ax
	mov	cx,len	;длину поля mas в cx
	xor	ax,ax
	xor si,si
	jcxz	exit	;проверка cx на 0, если 0, то на выход
	mov	si,-1	;готовим si к адресации элементов поля mas
cycl:
	inc	si
	cmp	mas[si],0	;сравнить очередной элемент mas с 0
	loopnz	cycl
	jz	exit	;почему вышли из цикла?
;вывод сообщения, если нет нулевых элементов в mas
 	mov	ah,9
	mov	dx,offset message
 	int	21h
exit:
	mov	ax,4c00h
	int	21h	;возврат управления операционной системе
end	start
