// hellobsd.s
// Пpогpамма, выводящая сообщение "Hello World" на FreeBSD
// без использования libc
//
// Компиляция:
// as -o hellobsd.o hellobsd.s
// ld -s -o hellobsd hellobsd.o
//
	.text
	.globl	_start
_start:
// системная функция 4 "write"
// в FreeBSD номер вызова помещают в %eax, а параметры - в стек
// справа налево, плюс одно двойное слово
	pushl	$message_l
// параметр 4 - длина буфера
	pushl	$message
// параметр 3 - адрес буфера
	pushl	$1
// параметр 2 - идентификатор устройства
	movl	$4,%eax
// параметр 1 - номер функции в eax
	pushl	%eax
// в стек надо поместить любое двойное слово, но мы поместим номер вызова
// для совместимости с Solaris и другими строгими операционными системами
// lcall $7,$0 - ассемблер для FreeBSD не поддерживает эту команду
	.byte	0x9a
	.long	0
	.word	7
// восстановим стек
	addl	$12,%esp

// системный вызов 1 "exit"
	xorl	%eax,%eax
	pushl	%eax
	incl	%eax
	pushl	%eax
// lcall $7,$0
	.byte	0x9A
	.long	0
	.word	7
	hlt
	.data
message:
	.ascii	"Hello World\012"
message_l = .-message
