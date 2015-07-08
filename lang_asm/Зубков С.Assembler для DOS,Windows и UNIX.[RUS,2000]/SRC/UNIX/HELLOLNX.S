// hellolnx.s
// Пpогpамма, выводящая сообщение "Hello World" на Linux
// без использования libc
//
// Компиляция:
// as -o hellolnx.o hellolnx.s
// ld -s -o hellolnx hellolnx.o
//
	.text
	.globl	_start
_start:
// системный вызов #4 "write". параметры в Linux помещают, слева направо,
// в регистры %eax, %ebx, %ecx, %edx, %esi, %edi
	movl	$4,%eax
	xorl	%ebx,%ebx
	incl	%ebx
// %ebx = 1 (идентификатор stdout)
	movl	$message,%ecx
	movl	$message_l,%edx
// передача управления в ядро системы - прерывание с номером 80h
	int	$0x80

// системный вызов #1 "exit" (%eax=1, %ebx=0)
	xorl	%eax,%eax
	incl	%eax
	xorl	%ebx,%ebx
	int	$0x80
	hlt
	.data
message:
	.string	"Hello world\012"
message_l = .-message
