.model small
.data
  src    DB "STRING 32X"
  dst    DB "STRING 32X"
  len    EQU $-dst
  eql    DB 0dh, 0ah, "Strings are equal$"
  neq    DB 0dh, 0ah, "String are different$"
  less   DB 0dh, 0ah, "Src less than Dst$"
  great  DB 0dh, 0ah, "Src great than Dst$"
  .code
  start:
  mov  AX, @data
  mov  DS, AX
  mov  ES, AX
  cld
  lea  SI, src
  lea  DI, dst
  mov  CX, len
  repe cmpsb
  je   s_eq
  jne  not_eq
  jmp  ex
s_eq:
  lea   DX, eql
  jmp  show
src_less:
  lea   DX, less
  jmp   show
src_gr:
  lea   DX, great
  jmp   show
not_eq:
  lea   DX, neq
  mov   AH, 9h
  int   21h
  jb    src_less
  ja    src_gr
  jmp   ex
show:
  mov   AH, 9h
  int   21h
ex:
  mov   AX, 4c00h
  int   21h
  end   start
  end
