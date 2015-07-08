.586P
.MODEL FLAT,STDCALL
TEXT SEGMENT 
START:
;явный вызов
	CALL PR1
	LEA  EAX,PR1
;косвенный вызов
	CALL EAX
	PUSH OFFSET L1
;адрес возврата в стеке
	JMP  EAX
L1:	
	PUSH OFFSET L2
	PUSH EAX
;теперь на вершине стека как раз адрес процедуры,
;а следующим в стеке лежит адрес возврата из процедуры
	RETN ;вызов при помощи RET
L2:	
	RETN   
PR1 PROC
	RETN	
PR1 ENDP  
TEXT ENDS
END START
