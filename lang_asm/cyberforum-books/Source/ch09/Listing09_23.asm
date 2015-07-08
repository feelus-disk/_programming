.686
.model flat
option casemap: none
.data
  res         label qword
  significand DD 0
  exponent    DD 0
.code
_fxtract_ex proc
  push  EBP
  mov   EBP, ESP
  fld   dword ptr [EBP+8]      ; число -> st(0)
  fxtract
  fstp  dword ptr significand  ; st(0) -> significand (mantissa)
  fstp  dword ptr exponent     ; st(1) -> exponent
  lea   EAX, qword ptr res
  pop   EBP
  ret
_fxtract_ex endp
end
