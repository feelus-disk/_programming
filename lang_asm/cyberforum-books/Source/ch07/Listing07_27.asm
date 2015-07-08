.model small
.data
  src   DB "123 456 789$"  ; строка, которую нужно реверсировать
   len  EQU $-src-1        ; размер строки за вычетом С$Т
   tmp  DB 11 DUP (20h)    ; временный буфер дл€ хранени€ данных
.code
  start:
    mov   AX, @data
    mov   DS, AX
    mov   ES, AX
    mov   CX, len
    std                     ; флаг DF Ц> 1, уменьшение адреса src
    lea   SI, src           ; адрес преобразуемой строки -> SI
    add   SI, len-1         ; установить указатель на адрес последнего
                            ; элемента строки src
    lea   DI, tmp           ; адрес временного буфера пам€ти -> DI
next:
    lodsb                   ; элемент строки src -> AL
    mov   byte ptr [DI], AL ; сохранить символ в буфере tmp
    inc   DI                ; перейти к следующему адресу в
                            ; буфере tmp (инкремент адреса)
    loop  next              ; следующа€ итераци€
    cld                     ; установить флаг DF в 0 дл€
                            ; увеличени€ адресов
    mov   CX, len           ; размер строки src Ц> CX
    lea   SI, tmp           ; адрес строки-источника -> SI
    lea   DI, src           ; адрес строки-приемника -> DI
    rep   movsb             ; копирование из tmp в src 
    lea   DX, src           ; вывод результата на экран
    mov   AH, 9h
    int   21h
    mov   AX, 4c00h
    int   21h
    end   start
    end
