.686
.model flat
option casemap: none
.data
  tbl label  dword
      DD sub1
      DD sub2
  i1  DD -39
  i2  DD 41
  res DD 2 DUP(0)
.code
_far_demo32 proc
  lea   ESI, tbl
  mov  [ESI], offset sub1
  mov  [ESI+4], offset sub2
  call  dword ptr [ESI]
  call  dword ptr [ESI+4]
  lea   EAX, res
  ret
_far_demo32 endp
sub1 proc
 clc
 mov EAX, i1
 adc EAX, i2
 mov res, EAX
 ret
sub1 endp
sub2 proc
 clc
 mov EAX, i1
 sbb EAX, i2
 mov res+4, EAX
 ret
sub2 endp
end
