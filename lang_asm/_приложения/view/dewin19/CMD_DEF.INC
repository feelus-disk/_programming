.code

locals @@

Get3btField macro
        mov     ax,[bx+1]
        and     ax,111000b
        shr     ax,3
endm

; однобайтовые команды-префиксы
cmdCOP_p proc near
        mov     cs:_Class,cmdPREFIX
endp
; однобайтовые команды
cmdCOP proc near
        mov     cs:was_opsize_prefix, 0
        call    printz
        retn
endp

cmdOpSize proc near
        mov     cs:was_opsize_prefix, 1
        call    printz
        retn
endp

; однобайтовые команды b/w
cmdCOPbw proc near
        mov     cs:was_opsize_prefix, 0
        call    printz
        call    BWmode
        retn
endp

; команды сдвига
cmdShift proc near
	mov	si,[bx+1]	; байт pежима
	and	si,111000b	; код команды сдвига
	shr	si,1
	add	si,offset Tshift
	call	Type4
	call	BWmode
	call	GetEAp

	mov	al,[bx]
	shr	al,1
	shr	al,1
        mov     al,'1'
	jnc	@@4
        putc    'c'
        mov     al,'l'
@@4:
	putc
	clc
	retn
Tshift  db      'rol',9
        db      'ror',9
        db      'rcl',9
        db      'rcr',9
        db      'shl',9
        db      'shr',9
        db      '...',9
        db      'sar',9
endp

; знаковое умножение, 286+
cmdIMUL proc near
        call    printz
	call	_regreg	; имя pегистpа
        putc    ','
	call	GetEAp
        mov     si,word ptr cs:CodeLen
        and     si, 0FFh
        add     si,bx
        mov     ax,word ptr [si]
        test    byte ptr [bx],2 ; слово или байт
        je      @@_word
	call	PnextByte2
	clc
	retn
@@_word:
	call	PnextWord2
	clc
	retn
T_Imul  db      'imul',9,0
endp

; обмен регистров
cmdXCHG proc near
        call    printz

	mov	al,[bx]
	and	ax,7
        call    word ptr cs:RegName16@32
	retn
T_xchg  db 'xchg',9,'ax,',0
T_xchg_ db 'xchg',9,0
endp

; mov reg8,imm8
cmdMOV_imm8 proc near
        call    printz
	mov	al,[bx]
        call    RegName8
        putc    ','
        call    PnextByte
	retn
T_mov   db 'mov',9,0
endp

; mov reg16/32, imm16/32
cmdMOV_imm proc near
        call    printz
	mov	al,[bx]
        call    word ptr cs:RegName16@32
        putc    ','
        cmp     cs:mode,32
        je      @@1
        call    PnextWord
	retn
@@1:
        cmp     cs:was_opsize_prefix,1
        je      @@2
        call    PnextDWord
	retn
@@2:
        mov     cs:was_opsize_prefix,0
        call    PnextWord
	retn
endp

; программные прерывания
cmdINT proc near
        call    printz
	call	PnextByte
	retn
T_int   db 'int',9,0
endp

; ввод из порта (номер в следующем байте)
cmdIN_PORT8 proc near
        call    printz
        test    byte ptr [bx],1
        mov     al,'l'
        jz      @@1
        mov     al,'x'
@@1:
        putc
        putc    ','
	call	PnextByte
	retn
T_inp8  db 'in',9,'a',0
endp

; вывод в порт
cmdOUT_PORT8 proc near
        call    printz
        test    byte ptr [bx],1
        mov     al,'l'
        jz      @@1
        mov     al,'x'
@@1:
        putc
        putc    ','
	call	PnextByte
	retn
T_out8  db 'out',9,'a',0
endp

; enter x,y
cmdENTER proc near
        call    printz
        call    PnextWord
        putc    ','
        mov     al,[bx+3]
        call    PnextByte2
	retn
T_enter db 'enter',9,0
endp

        ; DEBUG - must be revised !
cmdPUSH_imm16 proc near
        mov     cs:_Class,cmdPUSHP
        call    printz
        cmp     cs:mode,32
        je      @@1
        cmp     cs:was_opsize_prefix,1
        je      @@4
@@2:
        call    PnextWord
        mov     cs:was_opsize_prefix,0
	retn

@@1:
        cmp     cs:was_opsize_prefix,1
        je      @@3
@@4:
        call    PnextDWord
        mov     cs:was_opsize_prefix,0
        retn
@@3:
        mov     cs:was_opsize_prefix,0
        call    PnextWord
	retn
endp

cmdPUSH_imm8 proc near
        mov     cs:_Class,cmdPUSHP
        call    printz
        mov     al,[bx+1]
        cbw
        inc cs:CodeLen
        call  hexa_
        retn
endp

; mov r/m,seg
cmdMOV_RM_SEG proc near
        call    printz
	call	GetEA_16
        putc    ','
        Get3btField
        lea     si, TsegR
        add     si,ax
        add     si,ax
	call	Type2
	retn
endp

; mov seg,r/m
cmdMOV_SEG_RM proc near
        call    printz
        Get3btField
        lea     si, TsegR
        add     si,ax
        add     si,ax
	call	Type2
        putc    ','
	call	GetEA_16
	clc
	retn
endp

; retn/retf imm16
cmdRETi proc near
        call    printz
        putc    9
	call	PnextWord
        mov     cs:_Class,cmdRETURN
        retn
endp

cmdRET proc near
        call    printz
        mov     cs:_Class,cmdRETURN
        retn
endp

; lea les lds reg,mem
cmdLDS proc near
        call    printz
        Get3btField
        call    word ptr cs:RegName16@32
        putc    ','
	call	GetEA_16
        retn
T_lea    db 'lea',9,0
T_les    db 'les',9,0
T_lds    db 'lds',9,0
TsegR   db 'escsssdsfsgs'
endp

; mov mem,imm8/16
cmdMOV_MEMimm8 proc near
        call    printz
	call	GetEAp
	push	bx		; bx указывает на пеpвый байт команды
	add	bl,cs:CodeLen
	adc	bh,0
	dec	bx
        call    PnextByte
	pop	bx
	retn
endp

cmdMOV_MEMimm proc near
        call    printz
	call	GetEAp
	push	bx		; bx указывает на пеpвый байт команды
	add	bl,cs:CodeLen
	adc	bh,0
	dec	bx
        cmp     cs:mode,32
        je      @@1
        call    PnextWord
	pop	bx
	retn
@@1:
        cmp     cs:was_opsize_prefix,1
        je      @@2
        call    PnextDWord
        pop     bx
	retn
@@2:
        mov     cs:was_opsize_prefix,0
        call    PnextWord
        pop     bx
	retn
endp


; test mem,ax b/w
cmdTEST_MEM_AX proc near
        call    printz
	mov	dl,[bx]
	and	dl,1
	call	_immediate
	retn
T_test  db 'test',9,0
endp

; mov mem,ax b/w
cmdMOV_MEM_AX proc near
        call    printz
	mov	dl,[bx]
	and	dl,1
	call	P_al_ax
        putc    ','
        putc    '['
        cmp     cs:mode,32
        je      @@1
	call	PnextWord
        putc    ']'
        clc
	retn
@@1:
        call    PnextDWord
        putc    ']'
        clc
	retn
endp

cmdMOV_AX_MEM proc near
        call    printz
        putc    '['
        cmp     cs:mode,32
        je      @@1
	call	PnextWord
        putc    ']'
        putc    ','
	mov	dl,[bx]
	and	dl,1
	call	P_al_ax
	clc
	retn
@@1:
        call    PnextDWord
        putc    ']'
        putc    ','
	mov	dl,[bx]
	and	dl,1
	call	P_al_ax
	clc
	retn
endp

cmdAR_OP1 proc near
	call	GetCMDfield

	shr	ax,1
	lea	si,Tadd
	add	si,ax
	call	Type4
	call	BWmode
	call	GetEAp

	push	bx
	test	byte ptr [bx],1
	pushf
	test	byte ptr [bx],2	; пpовеpка для 83h
	je	@@nosmart
	mov	si,sp
	or	word ptr ss:[si],40h	; взводим флаг ZERO
@@nosmart:
	add	bl,cs:CodeLen
	adc	bh,0
	dec	bx

        cmp     cs:mode,32
        je      @@1

	popf
        call    PByteWord
	pop	bx
	clc
	retn
@@1:
        cmp     cs:was_opsize_prefix,1
        je      @@2
	popf
        call    PByteDWord
	pop	bx
	clc
	retn
@@2:
        mov     cs:was_opsize_prefix,0
	popf
        call    PByteWord
	pop	bx
	clc
	retn
endp

cmdTEST@XCHG proc near
        call    printz   ; имя команды
	mov	dl,[bx]
	mov	al,dl
	and	dl,1	; бит 0 =1 если слово =0 если байт
	jmp	short Entry_RM
endp

cmdADD_RM  proc near       ; r/m,r8/16
        GetCode
	and	ax,0F8h	; биты 3...7 задают код опеpации
	lea	si,Tadd
	shr	ax,1	; один бит дает сдвиг адpеса на 4
	add	si,ax
	call	Type4	; имя команды

	mov	dl,[bx]
	mov	al,dl
	and	dl,1	; бит 0 =1 если слово =0 если байт
	test	al,4
	jne	_immediate
Entry_RM:
	test	al,2
	jne	_order	; сначала pегистp

	call	GetEAp

_regreg:
        mov     cs:was_opsize_prefix, 0
        Get3btField
	call	TypeRegister
	retn
_order:
	call	_regreg	; имя pегистpа
        call    pGetEA  ; втоpой аpгумент
        mov     cs:was_opsize_prefix, 0
	clc
	retn
_immediate:		; сюда еще вход как в пpоцедуpу
	call	P_al_ax
        putc    ','
        cmp     cs:mode,32
        je      @@1
	or	dl,dl
	call	PByteWord
	retn
@@1:
        cmp     cs:was_opsize_prefix,1
        je      @@2
	or	dl,dl
        call    PByteDWord
	retn
@@2:
        mov     cs:was_opsize_prefix,0
	or	dl,dl
        call    PByteWord
	retn
Tadd    db 'add',9
        db 'or ',9
        db 'adc',9
        db 'sbb',9
        db 'and',9
        db 'sub',9
        db 'xor',9
        db 'cmp',9
Ttest   db 'test',9
endp

cmdINC@DEC_reg proc near
        call    printz
	mov	al,[bx]
        mov     ah,al
        and     ah,0F8h ; сбросим три правых бита
        cmp     ah,50h
        jne     @@no_push
        mov     cs:_Class,cmdPUSHP
@@no_push:
        call    word ptr cs:RegName16@32
	retn
T_inc   db 'inc',9,0
T_dec   db 'dec',9,0
T_push  db 'push',9,0
T_pop   db 'pop ',9,0
endp

cmdJMP_SHORT proc near
        call    printz
        lea     si,T_short
        call    printz
        jmp     short short_jmp
T_short db 'short ',0
endp
cmdLOOP proc near
        call    printz
        jmp     short short_jmp
T_loopne db 'loopne',9,0
T_loope  db 'loope',9,0
T_loop   db 'loop',9,0
T_jcxz   db 'jcxz',9,0
endp
cmdJCOND proc near
        putc    'j'

	mov	al,[bx]
	and	ax,0Fh
        shl     ax,1
	lea	si,Tjmp
        add     si,ax
        call    Type2
	push	ax
        putc    9
	pop	ax
endp
short_jmp proc near
	mov	al,[bx+1]	; pасстояние пеpехода
	cbw
        cmp     cs:mode,32
        je      @@1
	inc	ax
	inc	ax
	add	ax,bx
	inc	cs:CodeLen
	call	hexa_
	retn
@@1:
        cwd                     ; ?? для 32-бит
        add     ax,2
        adc     dx,0
	add	ax,bx
        adc     dx,0
        call    Put32addr
	inc	cs:CodeLen
	clc
	retn

Tjmp    db 'o '
        db 'no'
        db 'c '
        db 'nc'
        db 'z '
        db 'nz'
        db 'na'
        db 'a '
        db 's '
        db 'ns'
        db 'p '
        db 'np'
        db 'l '
        db 'nl'
        db 'ng'
        db 'g '
endp

cmdCALL_FAR proc near
        call    printz
        call    far_arg
        mov     cs:_Class,cmdCALLF
        retn
endp

cmdJMP_FAR proc near
        call    printz
endp
far_arg proc near
	lea	si,T_far
	call	Type4
	mov	ax,[bx+3]	; seg
	call	hexa_
        add     cs:CodeLen,2
        putc    ':'
        call    PnextWord       ; off
	retn
T_far   db 'far '
endp

cmdCALL_NEAR proc near
        call    printz
        call    diffHL
        mov     cs:_Class,cmdCALLN
        retn
endp

cmdJMP_NEAR proc near
        call    printz
endp
diffHL proc near
        cmp     cs:mode,32
        je      @@1
	mov	ax,[bx+1]	; diff L	diff H
	add	ax,bx
	add	ax,3
	inc	cs:CodeLen
	inc	cs:CodeLen
	call	hexa_
	retn
@@1:
        ; 32-bit offset
        mov     ax,[bx+1]
        mov     dx,[bx+3]
	add	ax,bx
        adc     dx,0
        add     ax,5 ; IP следующей команды
        adc     dx,0
        call    Put32addrPlus
	clc
	retn
endp

cmdPOP_RM proc near
	test	byte ptr [bx+1],111000b
	jne	@@2
        call    printz
	call	GetEA
	clc
	retn
@@2:
	stc
	retn
endp

cmdGRP1 proc near
	call	GetCMDfield
	cmp	al,1000b	; нет такой команды
	je	@@1

	push	ax
	shr	ax,1
	lea	si,Tgrp1
	add	si,ax
	call	Type4
	space
	call	BWmode
	call	GetEA
	pop	ax
	cmp	al,0	; для команды test
	jne	@@done
        putc    ','
	push	bx
	test	byte ptr [bx],1
	pushf
	add	bl,cs:CodeLen
	adc	bh,0
	dec	bx
	popf
        call    PByteWord
	pop	bx
@@done:
	clc
	retn
@@1:
        stc
	retn
Tgrp1   db 'Test    Not Neg Mul ImulDiv Idiv'
endp

cmdSHIFTop proc near
	call	GetCMDfield
	cmp	al,110000b	; нет такой команды
	je	@@not
	shr	ax,1
	lea	si,TshftOp
	add	si,ax
	call	Type4
	push	ax
	putc	9
	pop	ax
	call	BWmode
	call	GetEAp

	add	bl,cs:CodeLen
	adc	bh,0
	dec	bx
	call	PnextByte
	clc
	retn
@@not:
	stc
	retn
TshftOp db 'rol ror rcl rcr shl shr     sar '
endp

; AAD AAM
cmdAA proc near
        cmp     byte ptr [bx+1],0Ah
        jne     @@1
        inc     cs:CodeLen
        call    printz
        retn
@@1:
        stc
        retn
T_aad   db 'aad',0
T_aam   db 'aam',0
endp

cmdGRP23 proc near
	call	GetCMDfield
	cmp	al,110000b	; для втоpой гpуппы
        ja      @@2             ; <=110b
        cmp     al,10000b       ; inc 000, dec 001
	jc	@@inc
	test	byte ptr [bx],1
        je      @@2             ; push available for word ptr only
        cmp     al,110000b       ; push
        jne     @@grp2
        mov     cs:_Class,cmdPUSHP
@@grp2:
	push	ax	; чтобы pаспознать push
	shr	ax,1
	lea	si,Tgrp2
	add	si,ax
	call	Type4
	push	ax
	putc	9
	pop	ax
	pop	ax
	test	al,1000b
	je	@@near
	lea	si,T_far
	call	Type4
@@near:
	call	GetEA
	clc
	retn

@@inc:
	cmp	al,1000b	; для тpетьей гpуппы
        ja      @@2
	shr	ax,1
	lea	si,Tgrp2
	add	si,ax
	call	Type4
	call	BWmode
	call	GetEA
	clc
	retn
@@1:
@@2:
	stc
	retn
Tgrp2   db 'inc',9,'dec',9,'callcalljmp',9,'jmp',9,'push'
endp

jsuffix proc near
        mov     al,[bx+1]
	and	ax,0Fh
	lea	si,Tjmp
	add	si,ax
	add	si,ax
        call    Type2
        putc    9
        retn
endp

jump_0xF proc near
        inc     cs:CodeLen ; команда состоит из 2 байт КОП и 4 байта смещение
jump_0xF_ proc near
        putc    'j'
        call    jsuffix
        cmp     cs:mode,32
        je      @@o32
        ; 16-bit offset
        mov     ax,[bx+2]
	add	ax,bx
        add     ax,4 ; IP следующей команды
	inc	cs:CodeLen
	inc	cs:CodeLen
	call	hexa_
	retn
@@o32:
        ; 32-bit offset
        mov     ax,[bx+2]
        mov     dx,[bx+4]
	add	ax,bx
        adc     dx,0
        add     ax,6 ; IP следующей команды
        adc     dx,0
        call    Put32addrPlus
	clc
	retn
        retn
endp

;------------------------------------------------------------------------------
p_movzx:
p_movsx:
        mov     al,[bx+2]   ; 111000b       поле номера регистра
        shr     ax,3
        call    RegName32
        putc    ','
        call    GetEA_3   ; втоpой аpгумент команды - в третьем байте
        clc
        retn

p_lar:
        mov     al,[bx+2]
        and     ax,111000b      ; поле номера регистра
        shr     ax,3
        call    RegName16
        putc    ','

        inc     bx        ; втоpой аpгумент команды находится в третьем
        call    GetEA_16  ; байте, а процедура опирается на второй
        dec     bx        ; поэтому приходится так поступать

        clc
        retn

p_setcc:
        call    jsuffix
        call    GetEA_3   ; втоpой аpгумент команды - в третьем байте
        clc
        retn

p_movd:
        test    byte ptr [bx+1],10h
        jnz     @@1
        mov     al,[bx+2]   ; 111000b       поле номера регистра
        shr     ax,3
        call    RegNameMMX
        putc    ','
        call    GetEA_3   ; втоpой аpгумент команды - в третьем байте
        clc
        retn
@@1:
        call    GetEA_3   ; втоpой аpгумент команды - в третьем байте
        putc    ','
        mov     al,[bx+2]   ; 111000b       поле номера регистра
        shr     ax,3
        call    RegNameMMX
        clc
        retn

p_imul:
        mov     al,[bx+2]   ; 111000b       поле номера регистра
        shr     ax,3
        call    RegName32
        putc    ','
        call    GetEA_3   ; втоpой аpгумент команды - в третьем байте

p_cpuid:
p_rdtsc:
        clc
        retn

x macro _mask, _op, _name, _off
   db _mask, _op, _name
   dw _off
endm

; таблица кодов команд, начинающихся с байта 0x0F
Table_0x0F label byte

x 0FFh, 002h, 'lar  ', p_lar

t_size equ $-offset Table_0x0F

x 0FFh, 00Bh, 'ud2  ', p_rdtsc		; Pentium MMX and above: generate 'undefined opcode' exception
x 0FFh, 030h, 'wrmsr', p_rdtsc		; Pentium MMX and above: write model specific register
x 0FFh, 031h, 'rdtsc', p_rdtsc		; Pentium MMX and above: read time stamp counter to edx:eax
x 0FFh, 032h, 'rdmsr', p_rdtsc		; Pentium MMX and above: read model specific register
x 0FFh, 033h, 'rdpmc', p_rdtsc		; Pentium MMX and above: read performance-monitoring counter
x 0FFh, 077h, 'emms ', p_rdtsc		; Pentium MMX and above: empty MMX state
x 0FFh, 0A2h, 'cpuid', p_cpuid		; Pentium and above: read cpu id
x 0FFh, 0AAh, 'rsm  ', p_cpuid		; Pentium and above: resume from system management mode

x 010h, 06Eh, 'movd ', p_movd           ; MMX movd mmxreg, r/m
x 0FFh, 0AFh, 'imul ', p_imul
x 0FEh, 0BEh, 'movsx', p_movsx          ; movsx r16,r/m8
x 0FEh, 0B6h, 'movzx', p_movzx          ; movzx r16,r/m8
x 0F0h, 090h, 'set  ', p_setcc
x 0F0h, 080h, '     ', jump_0xF_	; 0x0F 0x8? near 386+ jumps

Table_0x0F_end label byte


; распознает расширения пространства команд
Detect0x0F proc near
        lea	si, Table_0x0F
@@1:
	cmp	si, offset Table_0x0F_end
	je	@@not_found

        mov     al,byte ptr [bx+1]
        and	al,byte ptr cs:[si]
	cmp	al,byte ptr cs:[si+1]
        je	@@found
        add	si, t_size
	jmp	short @@1

@@found:
        inc     cs:CodeLen
        push	si cx
        add	si, 2
	mov	cx, 5
@@p:
        mov	al, byte ptr cs:[si]
	cmp	al,' '
	je	@@done
	putc
	inc	si
        loop	@@p
@@done:
	pop	cx si

        mov	si, word ptr cs:[si+7]
; when JMP or SETcc we don't need spaces after COP body
	cmp	si, offset p_setcc
	je	@@2
	cmp	si, offset jump_0xF_
	je	@@2
	putc	9
@@2:
        call	si
	retn

@@not_found:
	lea	si, T_unknown
        call    cmdUNKNOWN
        retn
endp
endp


 WORD_PTR  equ 0
DWORD_PTR  equ 1
QWORD_PTR  equ 2
TBYTE_PTR  equ 3

@_WORD_PTR db 'word ptr',0
@DWORD_PTR db 'dword ptr',0
@QWORD_PTR db 'qword ptr',0
@TBYTE_PTR db 'tbyte ptr',0

T_ptrs dw @_WORD_PTR, @DWORD_PTR, @QWORD_PTR, @TBYTE_PTR

$if	macro	num, to, val
        local	a
        cmp	al, num
        jne	a
        mov	to, val
a:
endm

; копирование до символа '\0' включительно
; возвращает адрес последнего символа (нуля)
strcpy proc PASCAL near uses ds es si di, to : DWORD, from : DWORD
        les     di, to
        lds     si, from
@@while:
        mov     al, byte ptr ds:[si]
        mov     byte ptr es:[di], al

        cmp     byte ptr ds:[si],0
        je      @@endwhile

        inc     di
        inc     si
        jmp     short @@while
@@endwhile:
        mov     ax,di
        ret
endp

; возвращает длину строки
strlen proc PASCAL near uses ds si, from : DWORD
        lds     si, from
        xor	ax, ax
@@while:
        cmp     byte ptr ds:[si],0
        je      @@endwhile

        inc     si
        inc	ax
        jmp     short @@while

@@endwhile:
        ret
endp

Tfnop	db 'fnop',0
Tfucompp db 'fucompp',0
Tfcompp db 'fcompp',0
Tfstsw	db 'fstsw',0
Tfxch	db 'fxch',0
T_ax	db 'ax',0

opcod87	db 20 dup ('87')
oper87  db 20 dup ('87')

; declares a label
lab macro i
  T_f_&i label byte
endm

; references a label
alab macro j
        dw T_f_&j
endm

i = 0
irp str, < "fchs", "fabs", "", "", "ftst", "fxam", "", "" >
        lab %i
	db str, 0
        i = i + 1
endm
irp str, < "fld1", "fldl2t", "fldl2e", "fldpi", "fldlg2", "fldln2", "fldz", "" >
        lab %i
	db str, 0
        i = i + 1
endm
irp str, < "f2xm1"  , "fyl2x"  , "fptan"  , "fpatan" >
        lab %i
	db str, 0
        i = i + 1
endm
irp str, < "fxtract", "fprem1" , "fdecstp", "fincstp" >
        lab %i
	db str, 0
        i = i + 1
endm
irp str, < "fprem", "fyl2xp1", "fsqrt", "fsincos", "frndint", "fscale", "fsin", "fcos" >
        lab %i
	db str, 0
        i = i + 1
endm

esc_0x0X label word
j = 0
rept i
	alab %j
        j = j + 1
endm

;;--------------------------------------------------------------------------

; declares a label
labb macro i
  T_f1_&i label byte
endm

; references a label
blab macro j
        dw T_f1_&j
endm

i = 0
irp str, < "fneni", "fndisi", "fnclex", "fninit", "", "", "", "" >
        labb %i
	db str, 0
        i = i + 1
endm

esc_0x1C label word
j = 0
rept i
	blab %j
        j = j + 1
endm

;---------------------------------------------------------------------------

; declares a label
labc macro i
  T_f2_&i label byte
endm

; references a label
clab macro j
        dw T_f2_&j
endm

i = 0
irp str, < "fadd", "fmul", "fcom", "fcomp", "fsub", "fsubr", "fdiv", "fdivr", "fld", "", "fst" >
        labc %i
	db str, 0
        i = i + 1
endm
irp str, < "fstp", "fldenv", "fldcw", "fnstenv", "fnstcw", "fiadd" >
        labc %i
	db str, 0
        i = i + 1
endm
irp str, < "fimul", "ficom", "ficomp", "fisub", "fisubr", "fidiv", "fidivr", "fild" >
        labc %i
	db str, 0
        i = i + 1
endm
irp str, < "", "fist", "fistp", "", "fld", "", "fstp", "fadd", "fmul", "fcom", "fcomp" >
        labc %i
	db str, 0
        i = i + 1
endm
irp str, < "fsub", "fsubr", "fdiv", "fdivr", "fld", "", "fst", "fstp", "frstor", "" >
        labc %i
	db str, 0
        i = i + 1
endm
irp str, < "fnsave", "fnstsw", "fiadd", "fimul", "ficom", "ficomp", "fisub", "fisubr" >
        labc %i
	db str, 0
        i = i + 1
endm
irp str, < "fidiv", "fidivr", "fild", "", "fist", "fistp", "fbld", "fild", "fbstp", "fistp" >
        labc %i
	db str, 0
        i = i + 1
endm

esc_inst label word
j = 0
rept i
        clab %j
        j = j + 1
endm


; print out register num as "(%d)"
pnum proc PASCAL near uses ds si, to:DWORD, reg:WORD
        lds	si, to
        mov	byte ptr ds:[si],'('
        mov	al, byte ptr reg
        add	al, '0'
        mov	byte ptr ds:[si+1], al
        mov	byte ptr ds:[si+2],')'
        mov	byte ptr ds:[si+3],0
	ret
endp



; two-byte special case of 80x87 cmd
esc_special proc PASCAL near uses si, esc:WORD, reg:WORD
        LOCAL	elem:WORD

        mov	cs:opcod87, 0
        mov	cs:oper87, 0

        cmp	esc, 0Ah
        jne	@@1
        cmp	reg, 0
        jne	@@2
        call	strcpy PASCAL, cs offset opcod87, cs offset Tfnop
@@2:
	ret
@@1:
        cmp	esc, 0Bh
        jne	@@3
        ret
@@3:
        cmp	esc, 0Ch
        jc	@@4
        cmp	esc, 0Fh
        ja	@@4
        mov	si, esc
        sub	si, 0Ch
        shl	si, 3
        add	si, reg		; element = (esc_byte - 0x0C) * 8 + reg;
        shl	si, 1
        mov	ax, cs:esc_0x0X[si]
        call	strcpy PASCAL, cs offset opcod87, cs ax
        ret
@@4:
        cmp	esc, 10h	; if ( esc_byte >= 0x10 && esc_byte <= 0x1F )
        jc	@@5
        cmp	esc, 1Fh
        ja	@@5

        cmp	esc, 15h	; if ( esc_byte == 0x15 && reg == 0x01 )
				;    strcpy( opcode, "fucompp" );
        jne	@@6
        cmp	reg, 01h
        jne	@@6
        call	strcpy PASCAL, cs offset opcod87, cs offset Tfucompp
@@6:
        cmp	esc, 01Ch	; if ( esc_byte == 0x1C ) strcpy( opcode, esc_0x1C[reg] );
        jne	@@7
        mov	si, reg
        shl	si, 1
        mov	ax, cs:esc_0x1C[si]
        call	strcpy PASCAL, cs offset opcod87, cs ax
@@7:
	ret
@@5:
        mov	ax, esc
        irp	num, < 22h, 23h, 29h, 2Ch, 2Dh, 2Eh, 2Fh, 32h, 38h, 3Ah, 39h, 3Bh, 3Dh, 3Eh, 3Fh >
           	cmp al, num
                je  @@7
        endm

        cmp	esc, 33h	; if ( esc_byte == 0x33 ) {
        jne	@@8             ;     if ( reg == 0x01 ) strcpy( opcode, "fcompp" );
        cmp	reg, 01h        ;     return;
        jne	@@9             ; }
        call	strcpy PASCAL, cs offset opcod87, cs offset Tfcompp
@@9:
        ret
@@8:

        cmp	esc, 3Ch	; if ( esc_byte == 0x3C ) {
        jne	@@10            ;     if ( reg == 0x00 ) {
        cmp	reg, 00h        ;         strcpy( opcode, "fstsw" );
        jne	@@11            ;         strcpy( operand, "ax" );
                                ;     }
                                ;     return;
                                ; }
        call	strcpy PASCAL, cs offset opcod87, cs offset Tfstsw
        call	strcpy PASCAL, cs offset oper87, cs offset T_ax
@@11:
        ret
@@10:

        ; element = esc_byte & 0x0F;
        ; if (    element == 0x02 || element == 0x03 || element == 0x08
        ;      || element == 0x09 || element == 0x0A || element == 0x0B )
        ;     sprintf( operand, "st(%d)", reg );

        mov	ax, esc
        and	ax, 0Fh
        mov	elem, ax

        irp	num1, <>
        	cmp	al, num1
                je	@@12
        endm

        ; else
        ; {
        ;     if ( esc_byte >= 0x10 ) {
        ;         sprintf( operand, "st(%d),st", reg );
        ;     } else {
        ;         sprintf( operand, "st,st(%d)", reg );
        ;     }
        ; }

        cmp	esc, 10h
        jc	@@14
        ;         sprintf( operand, "st(%d),st", reg );
        mov	word ptr cs:oper87,'ts'
        call	pnum PASCAL, cs offset oper87+2, reg
        mov	byte ptr cs:oper87+5,','
        mov	word ptr cs:oper87+6,'ts'
        mov	byte ptr cs:oper87+8,0
        jmp	short @@13

@@14:
        ;         sprintf( operand, "st,st(%d)", reg );
        mov	word ptr cs:oper87,'ts'
        mov	byte ptr cs:oper87+2,','
        mov	word ptr cs:oper87+3,'ts'
        call	pnum PASCAL, cs offset oper87+5, reg
     	jmp	short @@13
@@12:
        ;     sprintf( operand, "st(%d)", reg );
        mov	word ptr cs:oper87,'ts'
        call	pnum PASCAL, cs offset oper87+2, reg
@@13:

        mov	ax, esc	; if (( esc_byte & ( ~0x12 )) == 0x24 ) element++;
        and	ax, not 12h
        cmp	ax, 24h
        jne	@@15
        inc	elem
@@15:
        cmp	ax, 25h ; if (( esc_byte & ( ~0x12 )) == 0x25 ) --element;
        jne	@@16
        dec	elem
@@16:

        mov	si, elem ; strcpy( opcode, ( esc_byte == 0x09 ) ? "fxch" : esc_inst[element] );
        shl	si, 1
        mov	ax, cs:esc_inst[si]
        cmp	esc, 09h
        jne	@@17
        mov	ax, offset Tfxch
@@17:
        call	strcpy PASCAL, cs offset opcod87, cs ax
    
        cmp	esc, 30h ; if ( esc_byte >= 0x30 ) strcat( opcode, "p" );
        jc	@@18
        call	strlen PASCAL, cs offset opcod87
        mov	si, ax
        mov	word ptr cs:opcod87[si], 'p'
@@18:
        ret
endp

; 80x87
cmdMATH proc PASCAL near
	uses	ax
        LOCAL	mod:BYTE, r_m:BYTE, lll:BYTE, ttt:BYTE, mod_reg:DWORD
        LOCAL   esc_byte:BYTE, size_need:WORD, typ:BYTE
.386
        mov     eax, [bx+1] ; next COP byte and SIB/disp
        mov	mod_reg,eax
.286

        mov	dx, ax		; mod = (uchar)(((int)mod_reg & 0xC0) >> 6);
        and	dx, 0C0h
        shr	dx, 6
        mov	mod, dl

        mov	dx, ax		; lll = (uchar)(((int)mod_reg & 0x38) >> 3);
        and	dx, 038h
        shr	dx, 3
        mov	lll, dl

        mov	dx, ax		; r_m = (uchar)(((int)mod_reg & 0x07) >> 0);
        and	dx, 007h
        shr	dx, 0
        mov	r_m, dl

        mov	al, [bx]	; ttt = (uchar)(byte & 0x07);
        and	al, 7
        mov	ttt, al

        shl	al, 3
        add	al, lll
        mov	esc_byte, al	; esc_byte = (uchar)(ttt << 3) + lll;

        cmp	mod, 3
        jne     @@1

        xor	ax,ax
        mov	dx,ax
        mov	al, esc_byte
        mov	dl, r_m
        call	esc_special PASCAL, ax, dx
        jmp	@@2
@@1:
        mov	size_need, 1
        mov	al, [bx]
        shr	al, 1
        and	al, 3		; 'mf' field of 1st byte

        mov	typ, -1         ; special case

        $if	0, typ, DWORD_PTR
        $if	1, typ, DWORD_PTR
        $if	2, typ, QWORD_PTR
        $if	3, typ, WORD_PTR

;; There are always exceptions to the rule (Thank you, Intel)

	mov	al, esc_byte
        $if	1Dh, typ, TBYTE_PTR
        $if	3Ch, typ, TBYTE_PTR
        $if	1Fh, typ, TBYTE_PTR
        $if	3Eh, typ, TBYTE_PTR

        $if	2Fh, typ, WORD_PTR

        $if	3Dh, typ, DWORD_PTR
        $if	3Fh, typ, DWORD_PTR

        cmp	al, 0Ch		; if (esc_byte >= 0x0C && esc_byte <= 0x0F)
        jc	@@3
        cmp	al, 0Fh
        ja	@@3
        mov	size_need, 0
@@3:
        $if	2Ch, size_need, 0
        $if	2Eh, size_need, 0

;;        sprintf( line, "" );
        mov	cs:oper87,0

        ; additional = do_mod_rm( line, mod, r_m, type, size_needed, ref_mode );
        ; if ( additional == -1 ) {           /* Error in 'do_mod_rm' */
        ;     return( 0 );
        ; }
        ; strcpy( temp, esc_inst[esc_byte] );

        push	si
        mov	si, word ptr esc_byte
        and 	si, 0FFh
        shl	si, 1
        mov	ax, cs:esc_inst[si]
        call	strcpy PASCAL, cs offset opcod87, cs ax
        pop	si
;--------------------------------
        cmp	cs:opcod87,0
        je	@@2	; @@unkn

        lea	si, opcod87
        call    printz
        putc	9
        cmp	typ, -1
        je	@@skip
        mov	si, word ptr typ
        and	si, 0FFh
        add	si, si
        mov	si, cs:T_ptrs[si]
        call    printz
        putc	' '
@@skip:
       	call	GetEA_16
        ret

@@2:
        inc 	cs:CodeLen      ; two bytes = minimal length of 87 instructions
        cmp	cs:opcod87,0
        je	@@unkn

        lea	si, opcod87
        call    printz
        putc	9
        lea	si, oper87
        call    printz
        ret

@@unkn:
        call    printz
	call	PnextByte
        ret
endp

cmdUNKNOWN proc near
        call    printz
        stc
        retn
endp

T_unknown db 'unknown ',0

comment $
Описания команд процессора 286+

Адрес строки КОП  │ Адрес процедуры-обработчика

$

CMD_TABLE label word
dw T_NULL     , cmdADD_RM          ;       00
dw T_NULL     , cmdADD_RM          ;       01
dw T_NULL     , cmdADD_RM          ;       02
dw T_NULL     , cmdADD_RM          ;       03
dw T_NULL     , cmdADD_RM          ;       04
dw T_NULL     , cmdADD_RM          ;       05
dw T_Push_ES  , cmdCOP             ;       06
dw T_Pop_ES   , cmdCOP             ;       07
dw T_NULL     , cmdADD_RM          ;       08
dw T_NULL     , cmdADD_RM          ;       09
dw T_NULL     , cmdADD_RM          ;       0A
dw T_NULL     , cmdADD_RM          ;       0B
dw T_NULL     , cmdADD_RM          ;       0C
dw T_NULL     , cmdADD_RM          ;       0D
dw T_Push_CS  , cmdCOP             ;       0E
dw T_unknown  , Detect0x0F         ;       0F
dw T_NULL     , cmdADD_RM          ;       10
dw T_NULL     , cmdADD_RM          ;       11
dw T_NULL     , cmdADD_RM          ;       12
dw T_NULL     , cmdADD_RM          ;       13
dw T_NULL     , cmdADD_RM          ;       14
dw T_NULL     , cmdADD_RM          ;       15
dw T_Push_SS  , cmdCOP             ;       16
dw T_Pop_SS   , cmdCOP             ;       17
dw T_NULL     , cmdADD_RM          ;       18
dw T_NULL     , cmdADD_RM          ;       19
dw T_NULL     , cmdADD_RM          ;       1A
dw T_NULL     , cmdADD_RM          ;       1B
dw T_NULL     , cmdADD_RM          ;       1C
dw T_NULL     , cmdADD_RM          ;       1D
dw T_Push_DS  , cmdCOP             ;       1E
dw T_Pop_DS   , cmdCOP             ;       1F
dw T_NULL     , cmdADD_RM          ;       20
dw T_NULL     , cmdADD_RM          ;       21
dw T_NULL     , cmdADD_RM          ;       22
dw T_NULL     , cmdADD_RM          ;       23
dw T_NULL     , cmdADD_RM          ;       24
dw T_NULL     , cmdADD_RM          ;       25
dw T_ES       , cmdCOP_p           ;       26
dw T_Daa      , cmdCOP             ;       27
dw T_NULL     , cmdADD_RM          ;       28
dw T_NULL     , cmdADD_RM          ;       29
dw T_NULL     , cmdADD_RM          ;       2A
dw T_NULL     , cmdADD_RM          ;       2B
dw T_NULL     , cmdADD_RM          ;       2C
dw T_NULL     , cmdADD_RM          ;       2D
dw T_CS       , cmdCOP_p           ;       2E
dw T_Das      , cmdCOP             ;       2F
dw T_NULL     , cmdADD_RM          ;       30
dw T_NULL     , cmdADD_RM          ;       31
dw T_NULL     , cmdADD_RM          ;       32
dw T_NULL     , cmdADD_RM          ;       33
dw T_NULL     , cmdADD_RM          ;       34
dw T_NULL     , cmdADD_RM          ;       35
dw T_SS       , cmdCOP_p           ;       36
dw T_Aaa      , cmdCOP             ;       37
dw T_NULL     , cmdADD_RM          ;       38
dw T_NULL     , cmdADD_RM          ;       39
dw T_NULL     , cmdADD_RM          ;       3A
dw T_NULL     , cmdADD_RM          ;       3B
dw T_NULL     , cmdADD_RM          ;       3C
dw T_NULL     , cmdADD_RM          ;       3D
dw T_DS       , cmdCOP_p           ;       3E
dw T_Aas      , cmdCOP             ;       3F
dw T_inc      , cmdINC@DEC_reg     ;       40
dw T_inc      , cmdINC@DEC_reg     ;       41
dw T_inc      , cmdINC@DEC_reg     ;       42
dw T_inc      , cmdINC@DEC_reg     ;       43
dw T_inc      , cmdINC@DEC_reg     ;       44
dw T_inc      , cmdINC@DEC_reg     ;       45
dw T_inc      , cmdINC@DEC_reg     ;       46
dw T_inc      , cmdINC@DEC_reg     ;       47
dw T_dec      , cmdINC@DEC_reg     ;       48
dw T_dec      , cmdINC@DEC_reg     ;       49
dw T_dec      , cmdINC@DEC_reg     ;       4A
dw T_dec      , cmdINC@DEC_reg     ;       4B
dw T_dec      , cmdINC@DEC_reg     ;       4C
dw T_dec      , cmdINC@DEC_reg     ;       4D
dw T_dec      , cmdINC@DEC_reg     ;       4E
dw T_dec      , cmdINC@DEC_reg     ;       4F
dw T_push     , cmdINC@DEC_reg     ;       50
dw T_push     , cmdINC@DEC_reg     ;       51
dw T_push     , cmdINC@DEC_reg     ;       52
dw T_push     , cmdINC@DEC_reg     ;       53
dw T_push     , cmdINC@DEC_reg     ;       54
dw T_push     , cmdINC@DEC_reg     ;       55
dw T_push     , cmdINC@DEC_reg     ;       56
dw T_push     , cmdINC@DEC_reg     ;       57
dw T_pop      , cmdINC@DEC_reg     ;       58
dw T_pop      , cmdINC@DEC_reg     ;       59
dw T_pop      , cmdINC@DEC_reg     ;       5A
dw T_pop      , cmdINC@DEC_reg     ;       5B
dw T_pop      , cmdINC@DEC_reg     ;       5C
dw T_pop      , cmdINC@DEC_reg     ;       5D
dw T_pop      , cmdINC@DEC_reg     ;       5E
dw T_pop      , cmdINC@DEC_reg     ;       5F
dw T_Pusha    , cmdCOP             ;       60
dw T_Popa     , cmdCOP             ;       61
dw T_Bound    , cmdCOP             ;       62
dw T_Arpl     , cmdCOP             ;       63
dw T_FS       , cmdCOP_p           ;       64
dw T_GS       , cmdCOP_p           ;       65
dw T_opsize   , cmdOpSize          ;       66
dw T_adrsize  , cmdCOP             ;       67
dw T_push     , cmdPUSH_imm16      ;       68
dw T_Imul     , cmdIMUL            ;       69
dw T_push     , cmdPUSH_imm8       ;       6A
dw T_Imul     , cmdIMUL            ;       6B
dw T_Ins      , cmdCOPbw           ;       6C
dw T_Ins      , cmdCOPbw           ;       6D
dw T_Outs     , cmdCOPbw           ;       6E
dw T_Outs     , cmdCOPbw           ;       6F
dw T_NULL     , cmdJCOND           ;       70
dw T_NULL     , cmdJCOND           ;       71
dw T_NULL     , cmdJCOND           ;       72
dw T_NULL     , cmdJCOND           ;       73
dw T_NULL     , cmdJCOND           ;       74
dw T_NULL     , cmdJCOND           ;       75
dw T_NULL     , cmdJCOND           ;       76
dw T_NULL     , cmdJCOND           ;       77
dw T_NULL     , cmdJCOND           ;       78
dw T_NULL     , cmdJCOND           ;       79
dw T_NULL     , cmdJCOND           ;       7A
dw T_NULL     , cmdJCOND           ;       7B
dw T_NULL     , cmdJCOND           ;       7C
dw T_NULL     , cmdJCOND           ;       7D
dw T_NULL     , cmdJCOND           ;       7E
dw T_NULL     , cmdJCOND           ;       7F
dw T_NULL     , cmdAR_OP1          ;       80
dw T_NULL     , cmdAR_OP1          ;       81
dw T_unknown  , cmdUNKNOWN         ;       82
dw T_NULL     , cmdAR_OP1          ;       83
dw T_test     , cmdTEST@XCHG       ;       84
dw T_test     , cmdTEST@XCHG       ;       85
dw T_xchg_    , cmdTEST@XCHG       ;       86
dw T_xchg_    , cmdTEST@XCHG       ;       87
dw T_mov      , cmdTEST@XCHG       ;       88
dw T_mov      , cmdTEST@XCHG       ;       89
dw T_mov      , cmdTEST@XCHG       ;       8A
dw T_mov      , cmdTEST@XCHG       ;       8B
dw T_mov      , cmdMOV_RM_SEG      ;       8C
dw T_lea      , cmdLDS             ;       8D
dw T_mov      , cmdMOV_SEG_RM      ;       8E
dw T_pop      , cmdPOP_RM          ;       8F
dw T_Nop      , cmdCOP             ;       90
dw T_xchg     , cmdXCHG            ;       91
dw T_xchg     , cmdXCHG            ;       92
dw T_xchg     , cmdXCHG            ;       93
dw T_xchg     , cmdXCHG            ;       94
dw T_xchg     , cmdXCHG            ;       95
dw T_xchg     , cmdXCHG            ;       96
dw T_xchg     , cmdXCHG            ;       97
dw T_Cbw      , cmdCOP             ;       98
dw T_Cwd      , cmdCOP             ;       99
dw T_call     , cmdCALL_FAR        ;       9A
dw T_Wait     , cmdCOP             ;       9B
dw T_Pushf    , cmdCOP             ;       9C
dw T_Popf     , cmdCOP             ;       9D
dw T_Sahf     , cmdCOP             ;       9E
dw T_Lahf     , cmdCOP             ;       9F
dw T_mov      , cmdMOV_MEM_AX      ;       A0
dw T_mov      , cmdMOV_MEM_AX      ;       A1
dw T_mov      , cmdMOV_AX_MEM      ;       A2
dw T_mov      , cmdMOV_AX_MEM      ;       A3
dw T_Movs     , cmdCOPbw           ;       A4
dw T_Movs     , cmdCOPbw           ;       A5
dw T_Cmps     , cmdCOPbw           ;       A6
dw T_Cmps     , cmdCOPbw           ;       A7
dw T_test     , cmdTEST_MEM_AX     ;       A8
dw T_test     , cmdTEST_MEM_AX     ;       A9
dw T_Stos     , cmdCOPbw           ;       AA
dw T_Stos     , cmdCOPbw           ;       AB
dw T_Lods     , cmdCOPbw           ;       AC
dw T_Lods     , cmdCOPbw           ;       AD
dw T_Scas     , cmdCOPbw           ;       AE
dw T_Scas     , cmdCOPbw           ;       AF
dw T_mov      , cmdMOV_imm8        ;       B0
dw T_mov      , cmdMOV_imm8        ;       B1
dw T_mov      , cmdMOV_imm8        ;       B2
dw T_mov      , cmdMOV_imm8        ;       B3
dw T_mov      , cmdMOV_imm8        ;       B4
dw T_mov      , cmdMOV_imm8        ;       B5
dw T_mov      , cmdMOV_imm8        ;       B6
dw T_mov      , cmdMOV_imm8        ;       B7
dw T_mov      , cmdMOV_imm         ;       B8
dw T_mov      , cmdMOV_imm         ;       B9
dw T_mov      , cmdMOV_imm         ;       BA
dw T_mov      , cmdMOV_imm         ;       BB
dw T_mov      , cmdMOV_imm         ;       BC
dw T_mov      , cmdMOV_imm         ;       BD
dw T_mov      , cmdMOV_imm         ;       BE
dw T_mov      , cmdMOV_imm         ;       BF
dw T_NULL     , cmdSHIFTop         ;       C0
dw T_NULL     , cmdSHIFTop         ;       C1
dw T_Retn     , cmdRETi            ;       C2
dw T_Retn     , cmdRET             ;       C3
dw T_les      , cmdLDS             ;       C4
dw T_lds      , cmdLDS             ;       C5
dw T_mov      , cmdMOV_MEMimm8     ;       C6
dw T_mov      , cmdMOV_MEMimm      ;       C7
dw T_enter    , cmdENTER           ;       C8
dw T_Leave    , cmdCOP             ;       C9
dw T_Retf     , cmdRETi            ;       CA
dw T_Retf     , cmdRET             ;       CB
dw T_Int3     , cmdCOP             ;       CC
dw T_int      , cmdINT             ;       CD
dw T_Into     , cmdCOP             ;       CE
dw T_Iret     , cmdCOP             ;       CF
dw T_NULL     , cmdShift           ;       D0
dw T_NULL     , cmdShift           ;       D1
dw T_NULL     , cmdShift           ;       D2
dw T_NULL     , cmdShift           ;       D3
dw T_aam      , cmdAA              ;       D4
dw T_aad      , cmdAA              ;       D5
dw T_unknown  , cmdUNKNOWN         ;       D6
dw T_Xlat     , cmdCOP             ;       D7
dw T_math     , cmdMATH            ;       D8
dw T_math     , cmdMATH            ;       D9
dw T_math     , cmdMATH            ;       DA
dw T_math     , cmdMATH            ;       DB
dw T_math     , cmdMATH            ;       DC
dw T_math     , cmdMATH            ;       DD
dw T_math     , cmdMATH            ;       DE
dw T_math     , cmdMATH            ;       DF
dw T_loopne   , cmdLOOP            ;       E0
dw T_loope    , cmdLOOP            ;       E1
dw T_loop     , cmdLOOP            ;       E2
dw T_jcxz     , cmdLOOP            ;       E3
dw T_inp8     , cmdIN_PORT8        ;       E4
dw T_inp8     , cmdIN_PORT8        ;       E5
dw T_out8     , cmdOUT_PORT8       ;       E6
dw T_out8     , cmdOUT_PORT8       ;       E7
dw T_call     , cmdCALL_NEAR       ;       E8
dw T_jmp      , cmdJMP_NEAR        ;       E9
dw T_jmp      , cmdJMP_FAR         ;       EA
dw T_jmp      , cmdJMP_SHORT       ;       EB
dw T_In_Al_Dx , cmdCOP             ;       EC
dw T_In_Ax_Dx , cmdCOP             ;       ED
dw T_Out_DX_AL, cmdCOP             ;       EE
dw T_Out_DX_AX, cmdCOP             ;       EF
dw T_Lock     , cmdCOP             ;       F0
dw T_unknown  , cmdUNKNOWN         ;       F1
dw T_Repne    , cmdCOP             ;       F2
dw T_Rep      , cmdCOP             ;       F3
dw T_Halt     , cmdCOP             ;       F4
dw T_Cmc      , cmdCOP             ;       F5
dw T_NULL     , cmdGRP1            ;       F6
dw T_NULL     , cmdGRP1            ;       F7
dw T_Clc      , cmdCOP             ;       F8
dw T_Stc      , cmdCOP             ;       F9
dw T_Cli      , cmdCOP             ;       FA
dw T_Sti      , cmdCOP             ;       FB
dw T_Cld      , cmdCOP             ;       FC
dw T_Std      , cmdCOP             ;       FD
dw T_NULL     , cmdGRP23           ;       FE
dw T_NULL     , cmdGRP23           ;       FF

; фиктивная строка названия команды
T_NULL          db  0

T_math          db  'esc',0

T_jmp           db  'jmp',9,0
T_call          db  'call',9,0


T_opsize        db  'operand size',0
T_adrsize       db  'address size',0

; команды, состоящие из одного байта-кода операции

T_FS            db  'FS:',0
T_GS            db  'GS:',0
T_ES            db  'ES:',0
T_DS            db  'DS:',0
T_CS            db  'CS:',0
T_SS            db  'SS:',0
T_Clc           db  'clc',0
T_Cmc           db  'cmc',0
T_Stc           db  'stc',0
T_Cld           db  'cld',0
T_Std           db  'std',0
T_Cli           db  'cli',0
T_Sti           db  'sti',0
T_Nop           db  'nop',0
T_Cbw           db  'cbw',0
T_Cwd           db  'cwd',0
T_Aaa           db  'aaa',0
T_Aas           db  'aas',0
T_Das           db  'das',0
T_Daa           db  'daa',0
T_Rep           db  'rep',0

T_Retn          db  'retn',0
T_Retf          db  'retf',0
T_Iret          db  'iret',0
T_Halt          db  'halt',0
T_Wait          db  'wait',0
T_Into          db  'into',0
T_Int3          db  'int3',0
T_Popf          db  'popf',0
T_Popa          db  'popa',0
T_Lahf          db  'lahf',0
T_Sahf          db  'sahf',0
T_Xlat          db  'xlat',0
T_Arpl          db  'arpl',0
T_Lock          db  'lock',0

T_Pushf         db  'pushf',0
T_Pusha         db  'pusha',0
T_Leave         db  'leave',0
T_Bound         db  'bound',0
T_Push_CS       db  'push',9,'cs',0
T_Push_SS       db  'push',9,'ss',0
T_Pop_ES        db  'pop ',9,'es',0
T_Push_ES       db  'push',9,'es',0
T_Pop_DS        db  'pop ',9,'ds',0
T_Push_DS       db  'push',9,'ds',0
T_Pop_SS        db  'pop ',9,'ss',0
T_Repne         db  'repne',9,0

T_In_Al_Dx      db  'in',9,'al,dx',0
T_In_Ax_Dx      db  'in',9,'ax,dx',0
T_Out_DX_AL     db  'out',9,'dx,al',0
T_Out_DX_AX     db  'out',9,'dx,ax',0



T_Cmps          db  'cmps',0
T_Lods          db  'lods',0
T_Movs          db  'movs',0
T_Stos          db  'stos',0
T_Scas          db  'scas',0
T_Ins           db  'ins',0
T_Outs          db  'outs',0

