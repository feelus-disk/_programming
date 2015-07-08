<1> ;prg_13_5.asm
<2> masm
<3> model	small
<4> stack	256
<5> def_tab_50	macro	len
<6> ifndef	len
<7> 	display	'size_m не определено, задайте значение 10<size_m<50'
<8> 	exitm
<9> else
<10> 	if	len GE 50
<11> 		GOTO exit
<12> 	endif
<13> 	if	len LT 10
<14> 	:exit
<15> 	EXITM
<16> 	endif
<17> 	rept	len
<18> 		db	0
<19> 	endm
<20> endif
<21> endm
<22> ;size_m=15
<23> .data
<24> def_tab_50	size_m
<25> 
<26> .code
<27> main:
<28> 	mov	ax,@data
<29> 	mov	ds,ax
<30> 	exit:
<31> 	mov	ax,4c00h
<32> 	int	21h
<33> end main

