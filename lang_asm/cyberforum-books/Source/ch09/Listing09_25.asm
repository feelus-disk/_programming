.686
.model flat
option casemap: none
.data
 mask_rc   label word
      DW   0F3FFh  ; rc = mode 00
      DW   0F7FFh  ; rc = mode 01
      DW   0FBFFh  ; rc = mode 10
      DW   0FFFFh  ; rc = mode 11
 tmp  DW 0
 res  DD 0
.code
 _frndint_ex proc
   push  EBP
   mov   EBP,ESP
   mov   ECX, dword ptr [EBP+16]
   shl   ECX, 1
   lea   ESI, mask_rc
   add   ESI, ECX
   mov   DX, word ptr [ESI]
   finit
   fstcw tmp
   or    tmp, 0C00h
   and   tmp, DX
   fldcw tmp
   fld   dword ptr [EBP+12]
   fadd  dword ptr [EBP+8]
   frndint
   fstp  dword ptr res
   lea   EAX, res
   pop   EBP
   ret
 _frndint_ex endp
 end
