.model small
.stack 100h
.data
  s1  DB 0dh, 0ah, "String 1$" 
  s2  DB 0dh, 0ah, "String 2$"
  s3  DB 0dh, 0ah, "String 3$"

  sarray   label word          ; массив, в котором хранятся адреса строк
      DW s1                    ; s1 и s2
      DW s2
      DW s3 
  num DW 0                     ; индекс в адресе перехода команды jmp
  label_array label word       ; массив адресов меток
      DW L1                    ; адрес метки L1
      DW L2                    ; адрес метки L2
      DW L3                    ; адрес метки L3
.code
 start:
  mov   AX, @data
  mov   DS, AX
  mov   ES, AX
  ;
  mov   CX, 3                  ; счетчик цикла -> CX
  lea   DI, label_array        ; адрес массива меток
next:
  mov   SI, DI
  mov   BX, num                ; индекс перехода -> BX
  shl   BX, 1                  ; умножить на 2 для правильной адресации
                               ; меток в массиве label_array 
  add   SI, BX                 ; сформировать адрес перехода
                               ; для команды jmp 
  jmp   word ptr [SI]          ; перейти по адресу, находящемуся
                               ; в регистре SI (L1 или L2)
wedge:
  inc   num                    ; инкремент индекса переходов
  loop  next                   ; повторить цикл
  ;
 L1:                           ; фрагмент кода при переходе на метку L1
  lea  DX, s1
  mov  AH, 9h
  int  21h
  jmp  wedge                   ; вернуться в цикл
 L2:                           ; фрагмент кода при переходе на метку L2
  lea  DX, s2
  mov  AH, 9h
  int  21h
  jmp  wedge
 L3:                           ; фрагмент кода при переходе на метку L3
  lea  DX, s3
  mov  AH, 9h
  int  21h
  ;
  mov  AH, 1h                  ; ожидать ввода любого символа
  int  21h
  ;
  mov  AX, 4c00h               ; завершение программы
  int  21h
  end  start
  end
