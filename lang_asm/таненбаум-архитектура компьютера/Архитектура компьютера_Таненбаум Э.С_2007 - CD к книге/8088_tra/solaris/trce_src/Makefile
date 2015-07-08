CC=gcc
CP=cp
TARGET: all
all: s88 t88
 
88.o: 88.h var.h macro.h 88.c
	$(CC) -c -O 88.c 
 
table.o: 88.h var.h macro.h  table.c
	$(CC) -c -O table.c 
 
adr.o: 88.h var.h macro.h  adr.c
	$(CC) -c -O adr.c 
 
cond.o: 88.h var.h macro.h cond.c
	$(CC) -c -O cond.c 
 
store.o: 88.h var.h macro.h  store.c
	$(CC) -c -O store.c 
 
main.o: 88.h var.h macro.h main.c
	$(CC) -c -O main.c 
 
mains.o: 88.h var.h macro.h mains.c
	$(CC) -c -O mains.c 
 
doscurs.o: doscurs.c 
	$(CC) -c -O doscurs.c 
 
t88: 88.o table.o adr.o cond.o store.o main.o doscurs.o Makefile 
	$(CC) -O -o t88 88.o table.o adr.o cond.o store.o main.o doscurs.o; \
	$(CP) t88 ../exercise/t88; $(CP) t88 ../examples/t88; $(CP) t88 ../bin/t88;
 
s88: 88.o table.o adr.o cond.o store.o mains.o doscurs.o Makefile 
	$(CC) -O -o s88 88.o table.o adr.o cond.o store.o mains.o doscurs.o; \
	$(CP) s88 ../exercise/s88; $(CP) s88 ../examples/s88; $(CP) s88 ../bin/s88;
