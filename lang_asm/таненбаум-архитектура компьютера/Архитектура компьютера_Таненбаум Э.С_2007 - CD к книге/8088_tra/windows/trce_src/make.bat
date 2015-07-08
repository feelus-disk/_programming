gcc -c -m32 88.c
gcc -c -m32 adr.c
gcc -c -m32 cond.c
gcc -c -m32 doscurs.c
gcc -c -m32 main.c
gcc -c -m32 mains.c
gcc -c -m32 store.c
gcc -c -m32 table.c
gcc -m32 88.o adr.o cond.o doscurs.o main.o store.o table.o
move a.exe t88.exe
copy t88.exe ..\bin\t88.exe
copy t88.exe ..\examples\t88.exe
copy t88.exe ..\exercise\t88.exe
gcc 88.o adr.o cond.o doscurs.o mains.o store.o table.o
move a.exe s88.exe
copy s88.exe ..\bin\s88.exe
copy s88.exe ..\examples\s88.exe
copy s88.exe ..\exercise\s88.exe
del *.o s88.exe t88.exe a.out ..\bin\t88 ..\bin\s88 ..\bin\as88
