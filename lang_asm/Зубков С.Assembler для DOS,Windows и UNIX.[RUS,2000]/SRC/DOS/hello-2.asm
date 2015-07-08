; hello-2.asm
; Выводит на экран сообщение "Hello World!" и завершается
;
; Компиляция:
; TASM:
; tasm /m hello-2.asm
; tlink /x hello-2.obj
; MASM:
; ml /c hello-2.asm
; link hello-2.obj
; WASM:
; wasm hello-2.asm
; wlink file hello-2.obj form DOS
;
	.model	small	; модель памяти, используемая для EXE
	.stack	100h	; сегмент стека размером в 256 байтов
	.code
start:	mov	ax,DGROUP	; сегментный адрес строки message
	mov	ds,ax		; помещается в DS
	mov	dx,offset message
	mov	ah,9
	int	21h		; функция DOS "вывод строки"
	mov	ax,4C00h
	int	21h		; функция DOS "завершить программу"
	.data
message	db	'Hello World!',0Dh,0Ah,'$'
	end	start

