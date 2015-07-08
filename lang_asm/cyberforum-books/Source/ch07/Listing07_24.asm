.686
.model flat
option casemap:none
.data
  iarray DD 23, -49, 65, 98, 133, 82 ; исходные значения элементов
                                     ; массива
  len    DD $-iarray                 ; размер массива в байтах
.code
_scas_dd proc
 mov    ECX, len                     ; размер массива -> ECX
 shr    ECX, 2                       ; преобразовать в количество
                                     ; двойных слов
 lea    EDI, iarray                  ; адрес массива -> EDI
 mov    EAX, 100                     ; шаблон для сравнения -> EAX
 xor    EDX, EDX                     ; подготовка регистра EDX
 cld                                 ; установить флаг направления
                                     ; для увеличения адреса
next:
 mov    EBX, dword ptr [EDI]         ; элемент массива -> EBX
 scasd                               ; сравнить EAX с элементом массива
 cmovl  EBX, EDX                     ; если элемент массива больше 100,
 mov    dword ptr [EDI-4], EBX       ; обнулить его. Поскольку указатель
                                     ; адреса после выполнения команды
                                     ; scasd продвинулся на 4, необходимо
                                     ; это учесть в команде mov
 loop  next
exit:
 lea   EAX, iarray                   ; адрес массива -> EAX
 ret
_scas_dd endp
end
