. . .
.data
  iarray DD 10 dup (0)
  len  EQU $-iarray
.code
. . .
  mov  ECX, len            ; число элементов массива (в байтах) -> ECX
  lea  ESI, i1             ; адрес первого элемента массива -> ESI
  mov  EBX, 2              ; помещаем делитель 2 в регистр EBX для
                           ; определения, четный или нечетный элемент
next:
  mov  EAX, ECX            ; счетчик элементов -> EAX
  div  EBX                 ; определяем, четный или нечетный
                           ; порядковый номер у элемента массива
  cmp  EDX, 0
  jne  store_1             ; если нечетный, присваиваем элементу
                           ; значение 1
  mov  DWORD PTR [ESI], 0  ; если четный, присваиваем элементу значение 0
  jmp  next_addr
store_1:
  mov  DWORD PTR [ESI], 1
next_addr:                 ; адрес следующего элемента массива
  add  ESI, 4
  loop next
  . . .
