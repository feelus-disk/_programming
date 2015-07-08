.586
.model flat
option casemap:none
.data
 not_equal DB "NOT equal"
           DB 0
 equal     DB "Equal"
           DB 0
.code
 _compare_strings proc
   push EBP
   mov  EBP, ESP
   mov  EDI, dword ptr [EBP+16] ; адрес первой строки -> EDI
   mov  ESI, dword ptr [EBP+12] ; адрес второй строки -> ESI
   mov  ECX, dword ptr [EBP+8]  ; размер строки -> ECX 
   cld                          ; установить флаг направления
                                ; для инкремента адресов
   repe cmpsb                   ; сравнение элементов строк
   je   s_equals
   lea  EAX, not_equal
   jmp  exit
 s_equals:
   lea  EAX, equal
 exit:
   pop  EBP
   ret
  _compare_strings endp
  end
