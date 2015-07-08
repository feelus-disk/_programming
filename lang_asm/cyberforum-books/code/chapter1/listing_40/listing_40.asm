.586P
.MODEL FLAT,STDCALL
includelib f:\masm32\lib\user32.lib
EXTERN MessageBoxA@16:NEAR
;------------------------------------------------
_DATA SEGMENT
TEXT1 DB 'Я в стеке!',0
TEXT2 DB 'Сообщение из стека',0
_DATA ENDS
_TEXT SEGMENT 
START:
;подготовить стек
;MOV EDX,ESP
MOV  EBP,ESP
MOV ECX,OFFSET L1
SUB ECX,PROC1
;выделяем место в стеке
SUB ESP,ECX
;скопировать код
MOV EDI,ESP
LEA ESI,PROC1
CLD
REP MOVSB
;вызвать процедуру из стека
CALL ESP
;восстановить стек
MOV  ESP,EBP
;MOV ESP,EDX 
RETN
ALIGN 4
PROC1 PROC
PUSH 0
PUSH OFFSET TEXT2
PUSH OFFSET TEXT1
PUSH 0
LEA EBX,MessageBoxA@16
CALL EBX 
RETN
PROC1 ENDP
ALIGN 4
L1:
_TEXT ENDS
END START
