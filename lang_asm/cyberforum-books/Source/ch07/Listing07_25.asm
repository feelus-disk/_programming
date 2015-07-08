.model small
option casemap:none
.data
  s1    DB " test string 1 "
  len   EQU $-s1
        DB  '$'
.code
start:
  mov   AX, @data
  mov   DS, AX
  mov   ES, AX
  cld             ; установить флаг направлени€ в сторону увеличени€
                  ; адресов
  mov   CX, len   ; размер строки s1 -> CX
  lea   SI, s1    ; адрес первого элемента строки Ц> SI
  mov   DI, SI    ; тот же адрес -> DI
next:
  lodsb           ; загрузить символ строки s1 в регистр AL
  cmp   AL, 97    ; AL < СaТ?
  jb    skip      ; нет, вне диапазона, пропустить
  cmp   AL, 122   ; AL > СzТ?
  ja    skip      ; нет, вне диапазона, пропустить
  sub   AL, 32    ; преобразовать символ из диапазона СaТ Ц СzТ
                  ; в символ из диапазона СAТ Ц СZТ
skip:
  stosb           ; запомнить символ по тому же адресу
  loop  next      ; переход к следующему символу
  jmp   exit
exit:
 lea    DX, s1    ; отобразить преобразованную строку
 mov    AH, 9h
 int    21h
 mov    AX, 4C00h
 int    21h
end     start
