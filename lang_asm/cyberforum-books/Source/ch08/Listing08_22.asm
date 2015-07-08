.686
.model flat
option casemap: none
.data
 i_asc   DB  '5749'
 len     EQU $-i_asc        ; определ€ем размер ASCII-числа в байтах
 i_bin   DD 3772
.code
 _asc_bin proc
   clc                      ; очистка флага переноса
   lea   ESI, i_asc         ; помещаем адрес i_asc в ESI
   mov   ECX, len           ; сохран€ем размер числа в ECX
   xor   EAX, EAX
   mov   BX,  10            ; помещаем множитель в регистр BX
 again:
   mul   BX                 ; AX * BX
   mov   DL, byte ptr [ESI] ; загружаем очередную цифру ASCII-числа в DL
   and   DL, 0Fh            ; очищаем левый полубайт
   movzx DX, DL             ; расшир€ем DL до DX дл€ последующего
                            ; сложени€
   add   AX, DX             ; сложение частичной суммы и преобразованной
                            ; ASCII-цифры
   inc   ESI                ; переход к следующему байту ASCII-числа
   loop  again              ; следующа€ итераци€
   movzx EAX, AX            ; расширение AX до EAX дл€ выполнени€
                            ; 32-разр€дного сложени€
   add   EAX, i_bin         ; вычисление суммы i_asc + i_bin
                            ; и сохранение ее EAX
   ret
 _asc_bin endp
  end
