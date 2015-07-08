// hellosol.s
// Пpогpамма, выводящая сообщение "Hello World" на Solaris/x86
// без использования libc
//
// Компиляция:
// as -o hellosol.o hellosol.s
// ld -s -o hellosol hellosol.o
//
	.text
	.globl	_start
_start:
// комментарии - см hellobsd.s
	pushl	$message_l
	pushl	$message
	movl	$4,%eax
	pushl	%eax
	lcall	$7,$0
	addl	$16,%esp

	xorl	%eax,%eax
	pushl	%eax
	incl	%eax
	pushl	%eax
	lcall	$7,$0
	hlt
	.data
message:
	.string	"Hello World\012"
message_l = .-message

