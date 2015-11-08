REM 				mingw-get				установщик

REM 				mingw32-make			make
REM gcc		mingw32-gcc	mingw32-gcc-4.8.1	
REM cpp										препроцессор
REM cc				mingw32-cc				с compiler
REM c++				mingw32-c++				
REM g++				mingw32-g++
REM gfortran		mingw32-gfortran		фортран-компилятор
REM as				mingw32-as				ассемблер

REM gdb										отладчик
REM gdbserver
REM gprof			mingw32-gprof			для сбора статистики времени выполнения
REM gcov									

REM ld				mingw32-ld				компоновщик
REM ld.bfd			mingw32-ld.bfd			???
REM objcopy			mingw32-objcopy			вытягивает разные секции объектных и исполняемых файлов
REM nm	mingw32-nm	gcc-nm	mingw32-gcc-nm	список символов(имен) из объектных файлов
REM objdump			mingw32-objdump			детальная информация по внутренностям объетного файла
REM readelf			mingw32-readelf			информация по внутренностям объектного файла
REM strip			mingw32-strip			удаляет из объектного или исполняемого файла символы определенного типа, например отладочные
REM elfedit			mingw32-elfedit			позволяет модифицировать некоторые поля в заголовке ELF файла
REM size			mingw32-size			показывает размер секций

REM ar	mingw32-ar	gcc-ar	mingw32-gcc-ar	архиватор объектников в статические библиотеки
REM ranlib	mingw32-ranlib	gcc-ranlib	mingw32-gcc-ranlib	индексирует содержимое архива

REM strings			mingw32-strings			примитивный способ вытаскивать строковые константы
REM addr2line		mingw32-addr2line		по адресу в бинарнике выдает строку в исходнике
REM c++filt			mingw32-c++filt			по раскодирует имена с++

REM dlltool			mingw32-dlltool			создание DLL для Windows
REM dllwrap			mingw32-dllwrap
REM windmc			mingw32-windmc			генерация ресурсов сообщений Windows
REM windres			mingw32-windres			компилятор файлов ресурсов Windows

mingw-get		 --help > 	get.txt
				
mingw32-make	 --help > 	make.txt
				
cpp				 --help > 	cpp.txt

cc				 --help > 	cc.txt
mingw32-cc		 --help >> 	cc.txt

c++				 --help > 	c++.txt
mingw32-c++		 --help >> 	c++.txt

c++filt			 --help > 	c++filt.txt
mingw32-c++filt --help >> 	c++filt.txt

gcc				 --help > 	gcc.txt
mingw32-gcc		 --help > 	gcc.txt
mingw32-gcc-4.8.1 --help >>	gcc.txt

g++				 --help > 	g++.txt
mingw32-g++		 --help >> 	g++.txt

gfortran		 --help > 	gfortran.txt
mingw32-gfortran --help >> 	gfortran.txt

ar				 --help > 	ar.txt
mingw32-ar		 --help >> 	ar.txt
gcc-ar			 --help >> 	ar.txt
mingw32-gcc-ar	 --help >> 	ar.txt

as				 --help > 	as.txt
mingw32-as		 --help >> 	as.txt

ld				 --help > 	ld.txt
mingw32-ld		 --help >> 	ld.txt

ld.bfd			 --help > 	ld.bfd.txt
mingw32-ld.bfd	 --help >> 	ld.bfd.txt

nm				 --help > 	nm.txt
mingw32-nm		 --help >> 	nm.txt
gcc-nm			 --help >> 	nm.txt
mingw32-gcc-nm	 --help >> 	nm.txt

gdb				 --help > 	gdb.txt

gdbserver		 --help > 	gdbserver.txt

gprof			 --help > 	gprof.txt
mingw32-gprof	 --help >> 	gprof.txt

gcov			 --help > 	gcov.txt

ranlib			 --help > 	ranlib.txt
mingw32-ranlib	 --help >> 	ranlib.txt
gcc-ranlib		 --help >> 	ranlib.txt
mingw32-gcc-ranlib --help >>ranlib.txt

size			 --help > 	size.txt
mingw32-size	 --help >> 	size.txt

strings			 --help > 	strings.txt
mingw32-strings	 --help >> 	strings.txt

strip			 --help > 	strip.txt
mingw32-strip	 --help >> 	strip.txt

objcopy			 --help > 	objcopy.txt
mingw32-objcopy	 --help >> 	objcopy.txt

objdump			 --help > 	objdump.txt
mingw32-objdump	 --help >> 	objdump.txt

dlltool			 --help > 	dlltool.txt
mingw32-dlltool	 --help >> 	dlltool.txt

dllwrap			 --help > 	dllwrap.txt
mingw32-dllwrap	 --help >> 	dllwrap.txt

elfedit			 --help > 	elfedit.txt
mingw32-elfedit	 --help >> 	elfedit.txt

readelf			 --help > 	readelf.txt
mingw32-readelf	 --help >> 	readelf.txt

addr2line		 --help > 	addr2line.txt
mingw32-addr2line --help >> addr2line.txt

windmc			 --help > 	windmc.txt
mingw32-windmc	 --help >> 	windmc.txt

windres			 --help > 	windres.txt
mingw32-windres	 --help >> 	windres.txt

REM cpp.exe
REM cc.exe
REM c++.exe
REM c++filt.exe
REM gcc.exe
REM g++.exe
REM gfortran.exe
REM dlltool.exe
REM dllwrap.exe
REM elfedit.exe
REM gdb.exe
REM gdbserver.exe
REM gprof.exe
REM gcov.exe
REM addr2line.exe
REM mingw32-addr2line.exe
REM ar.exe
REM as.exe
REM ld.bfd.exe
REM ld.exe
REM nm.exe
REM objcopy.exe
REM objdump.exe
REM ranlib.exe
REM readelf.exe
REM size.exe
REM strings.exe
REM strip.exe
REM windmc.exe
REM windres.exe
REM gcc-ar.exe
REM gcc-nm.exe
REM gcc-ranlib.exe
REM mingw32-ar.exe
REM mingw32-as.exe
REM mingw32-c++.exe
REM mingw32-c++filt.exe
REM mingw32-cc.exe
REM mingw32-dlltool.exe
REM mingw32-dllwrap.exe
REM mingw32-elfedit.exe
REM mingw32-g++.exe
REM mingw32-gcc-4.8.1.exe
REM mingw32-gcc.exe
REM mingw32-gcc-ar.exe
REM mingw32-gcc-nm.exe
REM mingw32-gcc-ranlib.exe
REM mingw32-gfortran.exe
REM mingw32-gprof.exe
REM mingw32-ld.bfd.exe
REM mingw32-ld.exe
REM mingw32-make.exe
REM mingw32-nm.exe
REM mingw32-objcopy.exe
REM mingw32-objdump.exe
REM mingw32-ranlib.exe
REM mingw32-readelf.exe
REM mingw32-size.exe
REM mingw32-strings.exe
REM mingw32-strip.exe
REM mingw32-windmc.exe
REM mingw32-windres.exe
REM mingw-get.exe
