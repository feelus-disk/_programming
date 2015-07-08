.686
.model flat
option casemap: none
.data
  supSSE DB 1
.code
_ssesupport proc
  mov  EAX, 1
  cpuid
  test EDX, 2000000h
  jnz  exit
  mov  supSSE, 0
exit:
  xor  EAX, EAX
  mov  AL, supSSE
  ret
_ssesupport endp
end
