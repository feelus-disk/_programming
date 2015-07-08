.686
.model flat
option casemap: none
.data
  op1_word     DW 37
  op2_word     DW 24
  op1_mul_op2  DD 0
  op_byte      DB 34
  op_word      DW 198
  op_mul_mixed DD 0
 .code
 _mul_words proc
   mov AX, op1_word
   mov BX, op2_word
   mul BX
   mov word ptr op1_mul_op2, AX
   mov word ptr op1_mul_op2+2, DX
   lea EAX, op1_mul_op2
   ret
  _mul_words endp
 _mul_mixed proc
   movzx AX, op_byte
   mov   BX, op_word
   mul   BX
   mov   word ptr op_mul_mixed, AX
   mov   word ptr op_mul_mixed+2, DX
   lea   EAX, op_mul_mixed
   ret
 _mul_mixed endp
  end
