.model large
data segment
 tbl label  dword
     DD subr1                       ; дальний адрес процедуры subr1
     DD subr2                       ; дальний адрес процедуры subr2
     DD subr3                       ; дальний адрес процедуры subr3
 s1  DB 0dh, 0ah, "FAR INDIRECT CALL subr1 DEMO !$"
 s2  DB 0dh, 0ah, "FAR INDIRECT CALL subr2 DEMO !$"
 s3  DB 0dh, 0ah, "FAR INDIRECT CALL subr3 DEMO !$"
data ends
code0 segment
assume CS:code0, DS:data
 main proc
  mov  AX, data
  mov  DS, AX
  lea  SI, tbl                    ; адрес таблицы адресов процедур -> SI
  push SI                         ; сохраним дл€ дальнейшего
                                  ; использовани€
; заполн€ем таблицу адресов дл€ каждой из процедур subr1, subr2 и subr3
  mov  word ptr [SI], offset subr1 ; смещение процедуры subr1 Ц> первое
                                   ; слово двухсловной €чейки пам€ти
  mov  AX, code1                   ; адрес сегмента, где находитс€
                                   ; процедура subr1 Ц> AX
  mov  word ptr [SI+2], AX         ; содержимое AX -> второе слово
; переход к следующему элементу таблицы и сохранение дальнего адреса
; процедуры subr2 во втором двойном слове
  add  SI, 4
  mov  word ptr [SI], offset subr2
  mov  AX, code2
  mov  word ptr [SI+2], AX
; переход к следующему элементу таблицы и сохранение дальнего адреса
; процедуры subr3 в третьем двойном слове
  add  SI, 4
  mov  word ptr [SI], offset subr3
  mov  AX, code3
  mov  word ptr [SI+2], AX
  pop  SI                          ; восстанавливаем начальный адрес
                                   ; таблицы tbl
  xor  BX, BX                      ; подготавливаем регистр BX, который
                                   ; будет использован дл€ индексации
                                   ; таблицы
  mov  CX, 3                       ; значение счетчика -> CX
next:
  call dword ptr [BX][SI]          ; дальний косвенный вызов процедур
                                   ; subr1, subr2 и subr3
  add  BX, 4                       ; переход к адресу следующей процедуры
                                   ; в таблице tbl
  dec  CX                          ; уменьшить счетчик на 1
  jnz  next                        ; следующа€ итераци€, если
                                   ; CX не равен 0
  mov  AX, 4C00h
  int  21h
 main  endp
code1  segment
assume CS:code1
subr1  proc far                    ; объ€вление процедуры subr1
  lea  DX, s1
  mov  AH, 9h
  int  21h
  ret
subr1  endp
code1  ends
code2  segment
assume CS:code2
subr2  proc far                    ; объ€вление процедуры subr2
  lea  DX, s2
  mov  AH, 9h
  int  21h
  ret
subr2  endp
code2  ends
code3  segment
assume CS:code3
subr3  proc far                     ; объ€вление процедуры subr3
  lea  DX, s3
  mov  AH, 9h
  int  21h
  ret
subr3  endp
code3  ends
end main
end
