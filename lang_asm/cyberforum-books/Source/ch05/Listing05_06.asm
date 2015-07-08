.686
.model flat
option casemap: none
.data
  a1   DD 34, -53, 88, 13, 67
  len  EQU $-a1
.code
 find_num  proc
  lea   ESI, a1               ; адрес массива -> ESI
  mov   ECX, len              ; размер массива в байтах -> ECX
  shr   ECX, 2                ; преобразовать в количество двойных слов
next:
  cmp   dword ptr [ESI], 100  ; элемент массива меньше или равен 100 ?
  jle   next1                 ; да, выполним следующую проверку
  jmp   next_addr             ; число больше 100, перейти
                              ; к следующему адресу
next1:
  cmp   dword ptr [ESI], 50   ; элемент массива больше или равен 50 ?
  jge   found                 ; да, элемент обнаружен, поместить его в
                              ; регистр EAX и выйти из процедуры
next_addr:                    ; перейти к следующему элементу массива
  add   ESI, 4
  dec   ECX                   ; декремент счетчика
  jnz   next                  ; если содержимое ECX не равно 0,
                              ; перейти к следующей итерации 
  mov   EAX, 0                ; цикл завершен, требуемый элемент
                              ; отсутствует, помещаем в EAX значение 0
  jmp   exit
found:
  mov   EAX, [ESI]            ; найденный элемент -> EAX
exit:
  ret 
find_num endp  
end
