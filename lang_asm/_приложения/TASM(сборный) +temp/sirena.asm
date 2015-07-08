;программа сирена
;---------------------
;
;
;
;
;
masm;
model small;
stack 100h;
;delay macro time
;
;
;	local ext,iter
;	push cx;
;	mov cx,time;
;ext:	
;	push cx;
;	mov cx,5000;
;iter:	
;	loop iter;
;	pop cx;
;	loop ext;
;	pop cx;
;endm
.data
tonelow	dw	2651;
cnt	db	0;
temp	dw	?;
.code
main:	
	mov ax,@data;
	mov ds,ax;
	mov ax,0;
go:	
;
	mov al,0BH;B6h
	out 43h,al;
	in al,61h;
	or al,3;
	out 61h,al;
	mov cx,2083;
musicup:
;
	mov ax,tonelow;
	out 42h,al;
	xchg al,ah;
	out 42h,al;
	add tonelow,1;
;	delay 1;
	push cx;
	mov cx,10;time
ext1:	
	push cx;
	mov cx,5000;
iter1:	
	loop iter1;
	pop cx;
	loop ext1;
	pop cx;

	mov dx,tonelow;
	mov temp,dx;
	loop musicup;
	mov cx,2083;
musicdown:
	mov ax,temp;
	out 42h,al;
	mov al,ah;
	out 42h,al;
	sub temp,1;
;	delay 1;
	push cx;
	mov cx,10;time;
ext:	
	push cx;
	mov cx,5000;
iter:	
	loop iter;
	pop cx;
	loop ext;
	pop cx;

	loop musicdown;
nosound:
	in al,61h;
	and al,0FCh;
	out 61h,al;
	mov dx,2651;
	mov tonelow,dx;
	inc cnt;
;
	cmp cnt,5;
	jne go;
exit:
	mov ax,4C00h;
	int 21h;
end main;