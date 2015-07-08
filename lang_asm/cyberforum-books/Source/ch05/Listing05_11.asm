. . .
.data
  src  DD 345, -65, 12, 99, 369, 267
  len  EQU $-src
  dst  DD 6 DUP (?)
.code
. . .
  mov ESI, src     ; адрес источника srcЦ> ESI
  mov EDI, dst     ; адрес приемника dst -> EDI
  mov ECX, len     ; значение счетчика байт -> ECX
  shr ECX, 2       ; перевести значение счетчика
                   ; в двойные слова
L1:
  mov EAX, [ESI]
  add ESI, 4
  mov [EDI], EAX
  add EDI, 4
  dec ECX
  jnz L1
. . .
