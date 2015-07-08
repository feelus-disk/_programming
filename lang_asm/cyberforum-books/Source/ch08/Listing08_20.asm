.686
.model flat
option casemap:none
.data
  num1  DB '0737'
  len1  EQU $-num1
  num2  DB '0086'
  subs  DB 4 DUP (' ')
.code
 _sub_asc proc
   mov  ECX, len1
   clc
 again:
   mov  AL, byte ptr num1[ECX-1]
   sbb  AL, byte ptr num2[ECX-1]
   aas
   mov  byte ptr subs[ECX-1], AL
   loop again
   sbb  byte ptr subs[ECX-1], 0
   or   dword ptr subs, 30303030h
   lea  EAX, subs
   ret
 _sub_asc endp
 end
