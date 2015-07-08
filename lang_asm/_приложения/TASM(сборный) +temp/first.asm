;dl:=шестнадцетиричное число
masm;
data segment para public "data"
message	db "Ведите две шестнадцетиричные цифры,$"
data ends
stk segment stack
	db 256 dup("?")
stk ends
code segment para public "code"
main	proc
assume cs:code,ds:data,ss:stk;
	mov ax,data;
	mov ds,ax;
	mov ah,9;
	mov dx,offset message;
	int 21h;
	xor ax,ax;
	mov ah,1;
	int 21h;
	mov dl,al;
	sub dl,30h;
	cmp dl,9h;
	jle M1;
	sub dl,7h;
M1:	mov cl,4h;
	shl dl,cl;
	int 21h;
	sub al,30h;
	cmp al,9h;
	jle M2;
	sub al,7h;
M2:	add dl,al;
	mov ax,4C00h;
	int 21h;
main endp
code ends
end main