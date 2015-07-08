.586
.model flat
option casemap: none
.data
 a1  DD 312, -45, 91, -16, -377  ; сканируемый массив
 len EQU $-a1                    ; размер массива в байтах
.code
_loopd_ex proc
  mov   ECX, len                 ; размер массива в байтах -> ECX
  shr   ECX, 2                   ; преобразовать размер в двойные слова
  lea   ESI, a1                  ; адрес первого элемента -> ESI
  mov   EAX, -100                ; шаблон для сравнения -> EAX
next:
  cmp   EAX, [ESI]               ; сравнить элемент массива
                                 ; с содержимым регистра EAX
  jge   found                    ; число в массиве меньше -100,
                                 ; закончить программу
  add   ESI, 4                   ; число больше -100, перейти
                                 ; к следующему элементу массива
  loopd next                     ; следующая итерация
  jmp   not_found                ; массив проверен, чисел меньше -100 нет
found:  
  mov   EAX, [ESI]               ; значение элемента массива -> EAX
  jmp   exit                     ; выйти из процедуры 
not_found:
  mov   EAX, 0                   ; при неудачном поиске в регистр EAX
                                 ; помещается 0
exit:
  ret
 _loopd_ex endp
 end
