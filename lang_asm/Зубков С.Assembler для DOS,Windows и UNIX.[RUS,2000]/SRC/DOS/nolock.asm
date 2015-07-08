; nolock.asm
; самая короткая программа для выключения NumLock, CapsLock и ScrollLock
; запускать без параметров
;
; Компиляция:
; TASM:
; tasm /m nolock.asm
; tlink /t /x nolock.obj
; MASM:
; ml /c nolock.asm
; link nolock.obj,,NUL,,,
; exe2bin nolock.exe nolock.com
; WASM:
; wasm nolock.asm
; wlink file nolock.obj form DOS COM
;

	.model	tiny
	.code
	org	100h	; COM-файл. AX при запуске COM-файла без параметров
			; в командой строке всегда равен 0
start:
	mov	ds,ax	; так что теперь DS = 0
	mov	byte ptr ds:0417h,al	; байт состояния клавиатуры 1 = 0
	ret		; выход из программы
	end	start
