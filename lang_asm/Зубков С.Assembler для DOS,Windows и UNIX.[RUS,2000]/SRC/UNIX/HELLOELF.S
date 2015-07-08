// helloelf.s
// Минимальная пpогpамма, выводящая сообщение "Hello world"
// Для компиляции в фоpмат ELF
//
// Компиляция:
// as -o helloelf.o helloelf.s
// Компоновка:
// (пути к файлу crt1.o могут отличаться на других системах)
// Solaris с SunPro C
//  ld -s -o helloelf.sol helloelf.o /opt/SUNWspro/SC4.2/lib/crt1.o -lc
// Solaris с GNU C
//  ld -s -o helloelf.gso helloelf.o /opt/gnu/lib/gcc-lib/i586-cubbi-solaris2.5.1/2.7.2.3.f.1/crt1.o -lc
// Linux
//  ld -s -m elf_i386 -o helloelf.lnx /usr/lib/crt1.o /usr/lib/crti.o -L/usr/lib/gcc-lib/i586-cubbi-linuxlibc1/2.7.2 helloelf.o -lc -lgcc /usr/lib/crtn.o
//
	.text
// код, находящийся в файлах crt*.o передаст управление на процедуру main
// после настройки всех параметров
	.globl	main
main:
// поместим параметр (адрес строки message) в стек
	pushl	$message
// вызовем функцию puts(message)
	call	puts
// очистим стек от параметров
	popl	%ebx
// завершим программу
	ret

	.data
message:
	.string	"Hello world\0"

