.586P
.MODEL FLAT,STDCALL
PROCESS_VM_OPERATION	=	0008H  
PROCESS_VM_WRITE	=	0020H  
PROCESS_VM_OW		=	PROCESS_VM_OPERATION OR PROCESS_VM_WRITE

includelib f:\masm32\lib\user32.lib
includelib f:\masm32\lib\kernel32.lib
EXTERN OpenProcess@12:NEAR
EXTERN WriteProcessMemory@20:NEAR
EXTERN GetCurrentProcessId@0:NEAR
;------------------------------------------------
_DATA SEGMENT
OPC	DB 0C3H	
_DATA ENDS
_TEXT SEGMENT 
START:
	CALL GetCurrentProcessId@0 	
;в EAX идентификатор текущего процесса
	PUSH EAX
	PUSH 1
	PUSH PROCESS_VM_OW
	CALL OpenProcess@12
;в EAX дескриптор открытого процесса
	PUSH 0
	PUSH 1
	PUSH OFFSET OPC
	PUSH OFFSET RETE
	PUSH EAX
	CALL WriteProcessMemory@20	
RETE:
	JMP  RETE		
	RETN
_TEXT ENDS
END START
