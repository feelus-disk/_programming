.686
.model flat
option casemap:none
.data
  coeff DD 57.32           ; коэффициент для перевода значения
                           ; угла из радиан в градусы
                           ; и численно равный 180/pi
  res   DD 0
.code
 _arctg_demo proc
   push  EBP
   mov   EBP, ESP
   finit
   fld   dword ptr [EBP+8] ; значение тангенса угла
   fld1                    ; константа 1
; после предыдущих двух команд регистр st(0) содержит 1,
; а регистр st(1) – значение тангенса искомого угла
   fpatan                  ; вычислить угол
   fmul  dword ptr coeff   ; перевести значение угла в градусы
   fstp  dword ptr res     ; сохранить результат в переменной res
                           ; и вытолкнуть содержимое из вершины стека
   lea   EAX, res          ; адрес результата -> EAX
   pop   EBP
   ret
 _arctg_demo endp
 end
