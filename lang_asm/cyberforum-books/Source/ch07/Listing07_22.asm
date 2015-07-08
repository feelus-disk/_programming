.586
.model flat
option casemap:none
.code
_scas_dd proc
 push   EBP
 mov    EBP, ESP
 mov    ECX, dword ptr [EBP+12] ; размер массива -> ECX
 mov    EDI, dword ptr [EBP+8]  ; адрес первого элемента -> EDI
 mov    EAX, 100                ; сравниваемое значение
 cld                            ; установить флаг направлени€ в сторону
                                ; увеличени€ адресов
next:
 scasd                          ; сравниваем элементы массива с
                                ; содержимым EAX
 jg    change                   ; число в EAX больше текущего элемента?
                                ; если нет, следующа€ итераци€
 loop  next
 jmp   exit
change:                         ; элемент массива меньше числа в EAX
 mov   dword ptr [EDI-4], 0     ; заменить содержимое €чейки пам€ти на 0
 dec   ECX                      ; декремент счетчика
 jmp   next
exit:
 pop   EBP
 ret
_scas_dd endp
end
