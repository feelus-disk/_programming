.686
.model flat
option casemap: none
.data
  a1       DD 45.2, -3.14, -88.4, 5.6, -11.34, 0, 1.33
  len      EQU $-op1
  pos_num  DB "Number is positive",0
  neg_num  DB "Number is negative",0
  other    DB "Other meaning", 0 
  err_parm DB "Incorrect value of parameter!",0
.code
fxam_demo proc
  push  EBP
  mov   EBP, ESP
  mov   ECX, dword ptr [EBP+8]
  cmp   ECX, 6
  jg    wrong_param
  shl   ECX, 2
  lea   ESI, a1
  finit
  fld   dword ptr [ESI][ECX]
  fxam
  fstsw AX
  and   AH, 7h
  cmp   AH, 4h
  je    pos_correct
  cmp   AH, 6h
  je    neg_correct
  lea   EAX, other
  jmp   exit
pos_correct:
  lea   EAX, pos_num
  jmp   exit
neg_correct:
  lea   EAX, neg_num
  jmp   exit
wrong_param:
  lea   EAX, err_parm
exit:
  pop   EBP
  ret
fxam_demo endp
end
