.686
.model flat
option casemap: none
.data
  a1   DD 34, -93, 95, 13, 7, 1
  len  EQU $-a1
  g50  DB ?
  l100 DB ?
.code
 find_num  proc
   lea   ESI, a1
   mov   ECX, len
   shr   ECX, 2
next:
   cmp   dword ptr [ESI], 50
   setge g50
   cmp   dword ptr [ESI], 100
   setle l100
   mov   AL, g50
   cmp   AL, l100
   cmove EAX, [ESI]
   je    exit
   add   ESI, 4
   dec   ECX
   jnz   next
   mov   EAX, 0
exit:
   ret
 find_num endp
 end
