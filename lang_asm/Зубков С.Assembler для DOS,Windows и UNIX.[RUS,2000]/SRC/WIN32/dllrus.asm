; dllrus.asm
; DLL для win32 - перекодировщик из koi8 в cp1251
;
; Компиляция
; MASM:
;  ml /c /coff /Cp /D_MASM_ dllrus.asm
;  link dllrus.obj @dllrus.lnk
; содержимое dllrus.lnk:
;	/DLL
;	/entry:start
;	/subsystem:windows
;	/export:koi2win_asm
;	/export:koi2win
;	/export:koi2wins_asm
;	/export:koi2wins
;
; TASM:
;  tasm /m /ml /D_TASM_ dllrus.asm
;  tlink32 -Tpd -c dllrus.obj,,,,dllrus.def
; содержимое файла dllrus.def:
;	EXPORTS koi2win_asm koi2win koi2wins koi2wins_asm
;
; WASM:
;  wasm dllrus.asm
;  wlink @dllrus.dir
; содержимое файла dllrus.dir:
;	file dllrus.obj
;	form windows nt DLL
;	exp koi2win_asm,koi2win,koi2wins_asm,koi2wins
;


		.386
		.model flat
; функции, определяемые в этом DLL
ifdef _MASM_
	 public _koi2win_asm@0	; koi2win_asm - перекодирует символ в AL
	 public _koi2win@4	; CHAR WINAPI koi2win(CHAR symbol)
	 public _koi2wins_asm@0	; koi2wins_asm - перекодирует строку в [EAX]
	 public _koi2wins@4	; VOID WINAPI koi2win(CHAR * string)
else
	 public koi2win_asm	; те же функции для TASM и WASM
	 public koi2win
	 public koi2wins_asm
	 public koi2wins
endif

		.const
; таблица для перевода символа из кодировки KOI8-r (RFC1489)
; в кодировку Windows (cp1251)
; таблица только для символов 80h - FFh
; (то есть надо будет вычесть 80h из символа, преобразовать его командой xlat
; и снова добавить 80h)
k2w_tbl		db	16 dup(0)	; символы, не существующие в cp1251, 
		db	16 dup(0)	; перекодируются в 80h
		db	00h, 00h, 00h, 38h, 00h, 00h, 00h, 00h
		db	00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h
		db	00h, 00h, 00h, 28h, 00h, 00h, 00h, 00h
		db	00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h
		db	7Eh, 60h, 61h, 76h, 64h, 65h, 74h, 63h
		db	75h, 68h, 69h, 6Ah, 6Bh, 6Ch, 6Dh, 6Eh
		db	6Fh, 7Fh, 70h, 71h, 72h, 73h, 66h, 62h
		db	7Ch, 7Bh, 67h, 78h, 7Dh, 79h, 77h, 7Ah
		db	5Eh, 40h, 41h, 56h, 44h, 45h, 54h, 43h
		db	55h, 48h, 49h, 4Ah, 4Bh, 4Ch, 4Dh, 4Eh
		db	4Fh, 5Fh, 50h, 51h, 52h, 53h, 46h, 42h
		db	5Ch, 5Bh, 47h, 58h, 5Dh, 59h, 57h, 5Ah

		.code
; процедура DLLEntry. Получает три параметра - идентификатор, причину вызова
; и зарезервированный параметр. Нам не нужен ни один из них
_start@12:
		mov	al,1	; надо вернуть ненулевое число в EAX
		ret	12

; процедура BYTE WINAPI koi2win(BYTE symbol) -
; точка входа для вызова из C
ifdef _MASM_
_koi2win@4	proc
else
 koi2win	proc
endif
		pop	ecx	; обратный адрес в ECX
		pop	eax	; параметр в ECX (теперь стек очищен от параметров!)
		push	ecx	; обратный адрес вернуть в стек для RET
; здесь нет команды RET - управление передается следующей процедуре
ifdef _MASM_
_koi2win@4	endp
else
 koi2win	endp
endif
; процедура koi2win_asm
; точка входа для вызова из ассемблерных программ
; ввод: AL - код символа в KOI
; вывод: AL - код этого же символа в WIN
ifdef _MASM_
_koi2win_asm@0	proc
else
 koi2win_asm	proc
endif
		test	al,80h		; если символ меньше 80h (старший бит 0),
		jz	dont_decode		; не перекодировать,
		push	ebx			; иначе - 
		mov	ebx,offset k2w_tbl
		sub	al,80h		; вычесть 80h,
		xlat				; перекодировать
		add	al,80h		; и прибавить 80h,
		pop	ebx
dont_decode:
		ret				; выйти
ifdef _MASM_
_koi2win_asm@0	endp
else
 koi2win_asm	endp
endif

; VOID koi2wins(BYTE * koistring) -
; точка входа для вызова из C
ifdef _MASM_
_koi2wins@4	proc
else
 koi2wins	proc
endif
		pop	ecx	; адрес возврата из стека
		pop	eax	; параметр в EAX
		push	ecx	; адрес возврата в стек
ifdef _MASM_
_koi2wins@4	endp
else
 koi2wins	endp
endif
; точка входа для вызова из ассемблера:
; ввод: EAX - адрес строки, которую надо преобразовать из KOI в WIN
; 
ifdef _MASM_
_koi2wins_asm@0 proc
else
 koi2wins_asm	proc
endif
		push	esi	; сохранить регистры, которые нельзя изменять
		push	edi
		push	ebx
		mov	esi,eax	; приемник строк
		mov	edi,eax	; и источник совпадают
		mov	ebx,offset k2w_tbl
decode_string:
		lodsb				; прочитать байт,
		test	al,80h		; если старший бит 0,
		jz	dont_decode2	; не перекодировать,
		sub	al,80h		; иначе - вычесть 80h,
		xlat				; перекодировать
		add	al,80h		; и добавить 80h
dont_decode2:
		stosb			; вернуть байт на место,
		test	al,al		; если байт - не ноль,
		jnz	decode_string	; продолжить
		pop	ebx
		pop	edi
		pop	esi
		ret
ifdef _MASM_
_koi2wins_asm@0 endp
else
 koi2wins_asm	endp
endif
		end	_start@12
