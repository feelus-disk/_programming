<1> ;prg_13_4.asm
<2> masm
<3> model	small
<4> stack	256
<5> def_tab_50	macro	len
<6> if	len GE 50
<7> GOTO	exit
<8> endif
<9> if	len LT 10
<10> :exit
<11> EXITM
<12> endif
<13> rept	len
<14> 	db	0
<15> endm
<16> endm
<17> .data
<18> def_tab_50	15
<19> def_tab_50	5
<20> .code
<21> main:
<22> 	mov	ax,@data
<23> 	mov	ds,ax
<24> 	exit:
<25> 	mov	ax,4c00h
<26> 	int	21h
<27> end	main

