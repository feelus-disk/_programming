.model small
.data
  src  DB  "STRING 1"
  lens EQU $-src
  dst  DB  "STRING 1"
  lend EQU $-dst
  eql  DB 0dh, 0ah, "Strings are equal ! $"
  neq  DB 0dh, 0ah, "Strings are different !$"
  diff_len DB "Strings have a different length!$"
 .code
  start:
   mov  AX, @data
   mov  DS, AX
   mov  ES, AX
   cld
   mov  AX, lens
   cmp  AX, lend
   je   go_compare
   lea  DX, diff_len
   jmp  show
go_compare:
   lea  SI, src
   lea  DI, dst
   mov  CX, lens
   repe cmpsb
   je   s_eq
   lea  DX, neq
show:
   mov   AH, 9h
   int   21h
   jmp   ex
s_eq:
   lea   DX, eql
   jmp  show
ex:
   mov   AX, 4c00h
   int   21h
   end   start
   end
