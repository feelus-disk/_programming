.686
.model flat
option casemap: none
.data
 a1  DD -162.31
 a2  DD -117.03
 res DD 0
.code
max proc
  finit
  fld   dword ptr a1
  fld   dword ptr a2
  fcom
  fstsw AX
  sahf
  jnc   store
  fxch  st(1)
store:
  fstp  res
  fwait
  lea   EAX, res
  ret
 max endp
 end
