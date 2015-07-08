.686
.model flat
option casemap: none
.code
 _rev32 proc
   push  EBP
   mov   EBP, ESP
   mov   ECX, dword ptr [EBP+12] ; помещаем размер массива
                                 ; в двойных словах в регистр ECX
   dec   ECX                     ; вычисляем смещение последнего элемента
   shl   ECX, 2                  ; преобразуем смещение в байты
   mov   ESI, dword ptr [EBP+8]  ; address of array
   mov   EDI, ESI
   add   EDI, ECX       
next:
   mov   EAX, [ESI]
   xchg  EAX, [EDI]
   mov   [ESI], EAX
   add   ESI, 4
   sub   EDI, 4
   cmp   ESI, EDI
   jb    next
   pop   EBP
   ret
 _rev32  endp
  end
