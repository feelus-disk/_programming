.model small
.data
  num1    DB '18'
  num2    DB '2'
  res     DB  ?
.code
start:
  mov  AX, @data
  mov  DS, AX
  clc
  mov  AX, word ptr num1  ; поместить делимое в AX
  xchg AH, AL             ; установить правильный пор€док байтов
  and  AX, 0F0Fh          ; преобразовать число в AX в неупакованное
                          ; двоично-дес€тичное (AX = 0306h)
  mov  CL, num2           ; поместить второе число в CL
  and  CL, 0Fh            ; преобразовать число в CX в неупакованное
                          ; двоично-дес€тичное (CL = 02h)
  aad                     ; выполнить коррекцию AX перед делением
                          ; (AX = 1Ch)
  div  CL
  or   AL, 30h            ; преобразовать результат в символьное
                          ; ASCII-представление (AL = 34h)
  mov  DL, AL             ; вывод символа на экран
                          ; (в DL Ц выводимый символ)
  mov AH, 2h
  int 21h
  mov ax, 4c00h
  int 21h
end start
end
