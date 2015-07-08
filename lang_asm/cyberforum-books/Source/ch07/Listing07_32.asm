.model small
.data
   s1   DB "ABCDEFG$"
   len  EQU $-s1-1         ; в константе len не учитываетс€ последний
                           ; элемент (С$Т), поскольку он остаетс€ на
                           ; месте
.code
 start:
  mov    AX, @data
  mov    DS, AX
  mov    ES, AX
  lea    SI, s1            ; адрес первого
                           ; элемента -> SI (пр€мой указатель)
  lea    DI, s1+len-1      ; адрес символа СGТ -> DI (обратный
                           ; указатель)
next:
  mov    AL, byte ptr [SI] ; здесь выполн€етс€ обмен элементов строки,
  xchg   AL, byte ptr [DI] ; наход€щихс€ в €чейках пам€ти с адресами
  mov    byte ptr [SI], AL ; в регистрах SI и DI
  inc    SI                ; продвинуть вперед пр€мой указатель
  dec    DI                ; уменьшить обратный указатель
  cmp    SI, DI            ; сравнить адреса
  jb     next              ; адрес в SI все еще меньше адреса в DI
                           ; повторить цикл
  lea    DX, s1            ; преобразование закончено, вывод результата
  mov    AH, 9h
  int    21h
  mov    AX, 4C00h
  int    21h
  end    start
  end
