gcc -c -m32 as.c
gcc -c -m32 bigkeywh.c
gcc -c -m32 comm3.c
gcc -c -m32 comm4.c
gcc -c -m32 comm5.c
gcc -c -m32 comm6.c
gcc -c -m32 comm7.c
gcc -c -m32 comm8.c
gcc -c -m32 wr.c
gcc -c -m32 wr_bytes.c
gcc -c -m32 wr_putc.c
gcc -m32 as.o bigkeywh.o comm3.o comm4.o comm5.o comm6.o comm7.o comm8.o wr.o wr_bytes.o wr_putc.o
copy a.exe ..\bin\as88.exe
copy a.exe ..\examples\as88.exe
copy a.exe ..\exercise\as88.exe
del *.o a.out a.exe
