.model small
.data
 src        DB  "STRING 11", 0
 dst        DB  "STRING 117", 0
 s_eq       DB "Strings are equal$"
 s_ne       DB "Strings are not equal$"
 size_diff  DB "Strings have different size !$"
.code
start:
  mov  AX, @data
  mov  DS, AX
  mov  ES, AX
  lea  SI, src       ; начальный адрес строки-источника -> SI
  mov  DX, SI        ; сохранить начальный адрес в регистре DX
  mov  AL, 0         ; символ для сравнения -> AL
src_again:
  cmp  AL, [SI]      ; достигнут конец строки?
  je   check_dst     ; да, проверить строку-приемник
  inc  SI            ; нет, конец строки не обнаружен, перейти
                     ; к следующему адресу
  jmp  src_again
check_dst:
  lea  DI, dst       ; начальный адрес строки-приемника -> DI
  mov  BX, DI        ; сохранить начальный адрес в регистре BX
dst_again:
  cmp  AL, [DI]      ; достигнут конец строки?
  je   check_size    ; да, сравнить размеры строк
  inc  DI            ; нет, конец строки не обнаружен, перейти
                     ; к следующему адресу
  jmp  dst_again
check_size:
  mov  CX, SI        ; конечный адрес строки-источника -> CX
  sub  CX, DX        ; вычислить размер строки-источника как разность
                     ; конечного и начального адресов
  mov  AX, DI        ; конечный адрес строки-приемника -> AX
  sub  AX, BX        ; вычислить размер строки-источника как разность
  sub  AX, BX        ; конечного и начального адресов
  cmp  AX, CX        ; размеры строк равны?
  je   compare       ; да, сравним строки
  lea  DX, size_diff ; нет, отобразить сообщение
  jmp  show
compare:
  cld                ; установить флаг направления для инкремента адресов
  mov  SI, DX        ; начальный адрес строки-источника -> SI
  mov  DI, BX        ; начальный адрес строки-приемника -> DI
  repe cmpsb         ; сравнить строки
  je   equal         ; строки равны?
  lea  DX, s_ne      ; нет, отобразить соответствующее сообщение
  jmp  show
equal:
  lea  DX, s_eq      ; да, отобразить соответствующее сообщение
show:
  mov  AH, 9h
  int  21h
  mov  AX, 4c00h
  int  21h
  end start
  end
