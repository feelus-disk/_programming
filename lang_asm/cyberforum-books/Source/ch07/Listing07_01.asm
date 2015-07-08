.model small
.data
  src   DB    "COPIED TEST STRING"
  len   EQU $-src
  dst   DB    len DUP (' ')
        DB    '$'
.code
start:
   mov  AX, @data  ; инициализация сегментных регистров
   mov  DS, AX
   mov  ES, AX
   cld             ; установим флаг направления DF для инкремента
   lea  SI, src    ; адрес источника -> DS:SI
   lea  DI, dst    ; адрес приемника -> ES:DI
   mov  CX, len    ; количество копируемых символов -> CX
   rep  movsb      ; копирование символов
   lea  DX, dst    ; отобразить скопированную строку на экране
   mov  AH, 9h
   int  21h
   mov  AX, 4c00h
   int  21h
   end  start
   end
