.model small
.data
 src        DB "ADDED CHARACHTERS$"   ; строка src, которая будет
                                      ; добавлена к dst
 len_src    EQU $-src                 ; размер строки src
 dst        DB "ORIGINAL CHARACHTERS" ; строка-приемник, в конец которой
                                      ; будут добавлены
                                      ; символы строки src
 len_dst    EQU $-dst                 ; размер строки dst
 suppl      DB len_src+1 DUP(' ')     ; зарезервированная область памяти
                                      ; для размещения символов из строки
                                      ; src и символа пробела для
                                      ; разделения строк
.code
  start:
   mov    AX, @data
   mov    DS, AX
   mov    ES, AX
   cld
   lea    SI, src
   lea    DI, dst+len_dst+1
   mov    CX, len_src
   rep    movsb
   lea    DX, dst
   mov    AH, 9h
   int    21h
   mov    AX, 4c00h
   int    21h
   end    start
   end
