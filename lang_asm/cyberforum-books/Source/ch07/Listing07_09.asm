.model small
.stack
.data
  src     DB    "FIRST sTRING 1"
  lsrc    EQU   $-src
  dst     DB    "FIRST STRING 1"
  equal   DB    "Strings are equal", '$'
  non_eq  DB    "Strings are not equal", '$'
.code
start:
   mov  AX, @data   ; инициализация сегментных регистров
   mov  DS, AX
   mov  ES, AX
   cld              ; установка флага напрвления DF для
                    ; инкремента адресов
   lea  SI, src     ; адрес источника -> DS:SI
   lea  DI, dst     ; адрес приемника -> ES:DI
   mov  CX, lsrc    ; количество сравниваемых байтов -> CX
   repe cmpsb       ; попарное сравнение байтов 
   je   yes         ; строки одинаковы?
   lea  DX, non_eq  ; нет, отобразить соответствующее сообщение
   jmp  output
yes:                ; да, отобразить сообщение
   lea  DX, equal
output:
   mov  AH, 9h
   int  21h
   mov  AX, 4c00h
   int  21h
   end  start
   end
