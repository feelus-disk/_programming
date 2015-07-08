.686
.model flat
.data
  s1  DB "It's a String s1",0
  s2  DB "Here is String s2",0
  s3  DB "String s3 is placed here",0
  saddr   label dword
      DD  s1
      DD  s2
      DD  s3
 .code
 _sarray proc
   push EBP
   mov  EBP, ESP
   mov  ECX, dword ptr [EBP+8] ; индекс строки -> ECX
   shl  ECX, 2                 ; преобразовать в двойное слово
   lea  ESI, saddr             ; адрес массива строк saddr –> ESI
   add  ESI, ECX               ; адрес двойного слова, содержащего
                               ; адрес строки -> ESI
   mov  EAX, [ESI]             ; адрес искомой строки -> EAX
   pop  EBP
   ret
 _sarray endp
 end
