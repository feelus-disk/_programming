.586
.model flat
option casemap: none
.data
  iarray  DQ  9234764129, -16097233481, -7565902112, 39094647921
  len     EQU $-iarray
  sum     DQ  0
.code
 _sum_64 proc
   mov ECX, len    ; размер массива iarray (в байтах) -> ECX
   shr ECX, 3      ; преобразовать размер в количество учетверенных слов
   lea ESI, iarray ; адрес массива -> ESI
   lea EDI, sum    ; адрес переменной sum -> EDI
   clc
 next:
   mov EAX, dword ptr [ESI]    ; младшее двойное слово элемента
                               ; массива-> EAX
   add dword ptr [EDI],EAX     ; прибавить к младшему двойному слову
                               ; общей суммы
   mov EDX, dword ptr [ESI+4]  ; старшее двойное слово элемента
                               ; массива -> EDX
   adc dword ptr [EDI+4], EDX  ; прибавить к старшему двойному слову
                               ; общей суммы с учетом переноса
   add ESI, 8                  ; переход к следующему элементу массива
   clc                         ; очистить флаг переноса
   loop next                   ; следующая итерация
   lea  EAX, sum               ; адрес переменной sum -> EAX
   ret
 _sum_64 endp
  end
