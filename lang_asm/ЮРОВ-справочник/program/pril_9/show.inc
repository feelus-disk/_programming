;;show.inc
;;макроопределение для визуализации регистров al, ah, ax, eax
;;на входе:
;;arg_n - имя одного из регистров al,ah,ax,eax
;;n_poz - номер позиции на экране, по умолчанию - 1000
Show	MACRO	arg_n,n_poz:=<1000>
LOCAL	main_part,disp,pause,template,VideoBuffer,p_mode,m1,m2
;;переход на начало блока команд,
;;чтобы избежать выполнения данных
	jmp	main_part
;;некоторые константы и переменные
FALSE	equ	0	;;ложь
TRUE	equ	0ffffh	;;истина
?reg8bit=false	;;флаг того, что передан регистр ah или al
?reg16bit=false	;;флаг того, что передан регистр ax
?reg32bit=false	;;флаг того, что передан регистр eax
;;таблица-шаблон для xlat
template	db	'0123456789ABCDEF'
;;адрес видеобуфера - для прямого вывода на экран
VideoBuffer	dw	0b800h

main_part:		;;начало блока команд
;;сохранение в стеке используемых регистров:
;;eax, ebx, ecx, edx, edi, ds, es
	push	eax
	push	ebx
	push	ecx
	push	edx
	push	edi
	push	ds
	push	es
	push	cs
	pop	ds
;;в bx - адрес таблицы-шаблона (для xlat)
	lea	bx,cs:template
	xor	cx,cx	;очистка cx
;;начало блока определения того,
;;какой регистр был передан макросу
IFIDNI	<al>,<&arg_n>	;;если аргумент=al или AL,
?reg8bit=TRUE		;;установка флага 8-битового регистра
	mov	ah,al
ENDIF
;;передан не al или AL
IFIDNI	<ah>,<&arg_n>	;;если аргумент=ah или AH,
?reg8bit=TRUE		;;установка флага 8-битового регистра
ENDIF
;;передан не AH или ah
IFIDNI	<ax>,<&arg_n>	;;если аргумент равен ax или AX,
?reg16bit=TRUE		;;установка флага 16-битового регистра
ENDIF
;;передан не ah, AH ,ax или AX
IFIDNI	<eax>,<&arg_n>	;;если аргумент равен eax или EAX,
?reg32bit=TRUE		;;установка флага 32-битового регистра
ENDIF
;;обработка содержимого регистров al, ah, ax, eax
IF	(?reg8bit)	;;если передан al или ah
	push	eax
	and	ah,0f0h	;;обращение к старшей четвёрке битов ah
	shr	ax,12	;;сдвиг битов в начало (16-4=12)
	xlat		;;трансляция таблицы-шаблона
;;помещение символа из al в edi
	mov	di,ax
	shl	di,8
	inc	cx
	pop	eax
	and	ax,0f00h	;;обращение к младшей тетраде ah
	shr	ax,8	;;сдвиг битов в начало (16-(4+4)=8)
	xlat		;;трансляция таблицы-шаблона
	or	di,ax	;;помещение очередного символа в di
	shl	edi,16
	inc	cx
ENDIF
IF	(?reg16bit)	;;если передан ax или ax
;;начало обработки значения регистра ax
	push	eax
;;обращение к старшей четвёрке битов ax
	and	ax,0f000h
	shr	ax,12	;;сдвиг битов в начало (16-4=12)
	xlat		;;трансляция таблицы-шаблона
;;помещение символа из al в старшую
;;тетраду старшей половины edi
	mov	di,ax
	shl	edi,8
	inc	cx
	pop	eax
	push	eax
;;обращение ко второй четвёрке битов ax
	and	ax,0f00h
	shr	ax,8	;;сдвиг битов в начало (16-(4+4)=8)
	xlat		;;трансляция таблицы-шаблона
;;помещение очередного символа в младшую
;;тетраду старшей половины edi
	or	di,ax
	shl	edi,8
	inc	cx
	pop	eax
	push	eax
	and	ax,0f0h	;;обращение к третьей четвёрке битов в ax
	shr	ax,4	;;сдвиг битов в начало (16-(4+4+4)=4)
	xlat		;;трансляция таблицы-шаблона
	or	di,ax	;;помещение очередного символа в edi
	shl	edi,8
	inc	cx
	pop	eax
	and	ax,0fh	;;обращение к младшей четвёрке битов ax
	xlat		;;трансляция таблицы-шаблона
	or	di,ax	;;помещение очередного символа в edi
	inc	cx
ENDIF
IF	(?reg32bit)	;;если передан eax или EAX
;;начало обработки значения регистра eax
	push	eax
;;обращение к старшей четвёрке битов eax
	and	eax,0f0000000h
	shr	eax,28	;;сдвиг битов в начало (32-4=28)
	xlat		;;трансляция таблицы-шаблона
;;помещение символа из al в старшую
;;тетраду старшей половины edx
	mov	dh,al
	shl	edx,8
	pop	eax
	push	eax
	inc	cx
	pop	eax
	push	eax
;;обращение к следующей четвёрке битов eax
	and	eax,0f000000h
	shr	eax,24	;;сдвиг битов в начало (32-(4+4)=24)
	xlat		;;трансляция таблицы-шаблона
;;помещение очередного символа из al в младшую
;;тетраду старшей половины edx
	mov	dh,al
	shl	edx,8
	inc	cx
	pop	eax
	push	eax
	and	eax,0f00000h
	shr	eax,20
	xlat
	mov	dh,al
	inc	cx
	pop	eax
	push	eax
	and	eax,0f0000h
	shr	eax,16
	xlat
	mov	dl,al
	inc	cx
	pop	eax
	push	eax
	and	eax,0f000h
	shr	eax,12
	xlat
	or	di,ax
	shl	edi,8
	inc	cx
	pop	eax
	push	eax
	and	eax,0f00h
	shr	eax,8
	xlat
	or	di,ax
	shl	edi,8
	pop	eax
	push	eax
	inc	cx
	and	eax,0f0h
	shr	eax,4
	xlat
	or	di,ax
	shl	edi,8
	inc	cx
	pop	eax
	push	eax
	and	eax,0fh
	xlat
	or	di,ax
	inc	cx
	ENDIF
;;вывод на экран результата
;;результат в паре edx:ebx, количество цифр в cx
;;проверим режим работы микропроцессора
	mov	eax,cr0
	test	eax,00000001h
	jnz	p_mode
;;для реального режима
;;загружаем в es адрес видеопамяти
	mov	ax,cs:VideoBuffer
	mov	es,ax
p_mode:
;;для реального и защищенного режимов
;;количество циклов в cx
	cld		;;просмотр вперед - для stosw
	xchg	edi,ebx
	mov	di,n_poz	;;начальная позиция для
			;;вывода на экран
disp:
	cmp	ecx,4
	jle	m1	;переход, если ecx<=4
	shld	eax,edx,8
	shl	edx,8
	jmp	m2
m1:
	shld	eax,ebx,8
	shl	ebx,8
m2:
	mov	ah,71h	;;байт-атрибут
	stosw		;;копирование значения ax
			;;в es:di (видеобуфер)
	loop	disp	;;повтор цикла cx раз
	mov	cx,65535	;;задержка
pause:	loop	pause
;;переопределение/восстановление из стека
;;используемых регистров
	pop	es
	pop	ds
	pop	edi
	pop	edx
	pop	ecx
	pop	ebx
	pop	eax
ENDM

