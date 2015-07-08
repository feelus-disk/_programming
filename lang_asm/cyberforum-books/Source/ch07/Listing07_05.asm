.586
.model flat
option casemap:none
.data
  i1           DD 23, 44, 8
  copy_area    DD 4 DUP (0)
  i2           DD -56, 7, -3, 89
  len          EQU $-i2
.code
 _concat_dd proc
   mov   ECX, len
   shr   ECX, 2
   lea   EDI, copy_area
   lea   ESI, i2
   cld
   rep   movsd
   lea   EAX, i1
   ret
 _concat_dd endp
 end
