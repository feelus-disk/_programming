;prg_10_2.asm
model small
.stack	100h
.data
len equ	10	;количество элементов в mas
mas	db	1,0,9,8,0,7,8,0,2,0
.code
start:
	mov	ax,@data
	mov	ds,ax
	mov	cx,len	;длину поля mas в cx
	xor	ax,ax
	xor si,si
cycl:
	jcxz	exit	;проверка cx на 0, если 0, то на выход
	cmp	mas[si],0	;сравнить очередной элемент mas с 0
	jne m1	;если не равно, то на m1
	inc	al	;в al счетчик нулевых элементов
m1:
	inc	si	;перейти к следующему элементу
	dec	cx	;уменьшить cx на 1;
	jmp cycl
exit:
	mov	ax,4c00h
	int	21h	;возврат управления операционной системе
end	start

