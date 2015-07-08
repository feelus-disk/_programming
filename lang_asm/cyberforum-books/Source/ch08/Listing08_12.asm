.686
.model flat
option casemap: none
.data
  op_byte        DB -31
  op_dword       DD 750
  op_imul_mixed  DQ 0
 .code
  _imul_mixed proc
    movsx  AX, op_byte
    movsx  EAX, AX
    mov    EBX, op_dword
    imul   EBX
    mov    dword ptr op_imul_mixed, EAX
    mov    dword ptr op_imul_mixed+4, EDX
    lea    EAX, op_imul_mixed
    ret
 _imul_mixed endp
  end
