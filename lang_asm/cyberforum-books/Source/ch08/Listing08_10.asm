.686
.model flat
option casemap:none
.data
  op1          DQ  15751
  len          EQU $-op1
  op2_dd       DD  97106
  op2          DQ  0
  substract    DQ  0
.code
 _sub_8bytes proc
  push EBX
  mov  ECX, len
  mov EAX, op2_dd        ; здесь выполняется преобразование двойного
                         ; слова op2_dd в учетверенное слово в op2 с
                         ; помощью команды cdq
  cdq
  mov dword ptr op2, EAX
  mov dword ptr op2+4, EDX
  xor  EAX, EAX
  clc
  lea  ESI, byte ptr op1
  lea  EDI, byte ptr op2
  lea  EBX, byte ptr substract
next_byte:
  mov  AL, [ESI]
  sbb  AL, [EDI]
  mov  byte ptr [EBX], AL
  inc  ESI
  inc  EDI
  inc  EBX
  loop next_byte
  lea  EAX, substract
  pop  EBX
  ret
 _sub_8bytes endp
 end
