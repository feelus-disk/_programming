;---------Prg_7_2.asm---------------
masm
model small
.data
str_1 db 'Ассемблер - базовый язык компьютера'
str_2 db 50 dup (' ')
full_pnt dd str_1
.code
start:
	mov	ax,@data	;связываем регистр ds с сегментом
	mov	ds,ax	;данных через регистр ax
	xor	ax,ax	;очищаем ax
	lea	si,str_1
	lea	di,str_2
	les	bx,full_pnt	;полный указатель на str1 в пару es:bx
	mov	cx,19	;количество повторений цикла в cx
m1:
	mov	al,[si]
	mov	[di],al
	inc	si
	inc	di
;цикл на метку m1 до пересылки всех символов
loop	cx
	exit:
	mov	ax,4c00h	;стандартный выход
	int	21h
end start

