{old3 Файлы инициализации и выходные файлы
3.1 нахождение ввода configure
!	AC_INIT(unique-file-in-source-dir)
	AC_CONFIG_AUX_DIR(dir)
3.2 создание выходных файлов
!	AC_OUTPUT([file...[,extra-cmds[,init-cmds]]])
!	AC_OUTPUT_COMMANDS(extra-cmds[,init-cmds])
	AC_PROG_MAKE_SET
3.3 подстановки в Makefile-ах
	...........
3.4 Заголовочные файлы конфигурации
!	AC_CONFIG_HEADER(header-to-creste ...)
	.......
3.5 настройка других пакетов в подкаталогах
	AC_CONFIG_SUBDIRS(dir ...)
3.6 префикс по умолчанию
	AC_PREFIX_DEFAULT(prefix)
	AC_PREFIX_PROGRAM(program)
3.7 номера версий
	AC_PREREQ(version)
	AC_REVISION(revision-info)
}
{new4 Файлы инициализации и выходные файлы
4.1 инициализация configure
	AC_INIT(package,version,[bug-report],[tarname],[url])
4.2 версии autoconf
	AC_PREREQ(version)
	AC_AUTOCONF_VERSION
4.3 заметки в configure
	AC_COPYRIGHT(copyright-notice)
	AC_REVISION(revision-info)
4.4 нахождение ввода configure
	AC_CONFIG_SRCDIR(unique-file-in-source-dir)
	AC_CONFIG_AUX_DIR(dir)
	AC_REQUIRE_AUX_FILE(file)
	AC_CONFIG_MACRO_DIR(dir)
4.5 выходные файлы
	AC_OUTPUT
	AC_PROG_MAKE_SET
4.6 представление конфигурационных действий
	..........
4.7 создание конфигурационных файлов
	AC_CONFIG_FILES(file...,[cmds],[init-cmds])
4.8 подстановки в Makefile-ах
	.............
4.9 header-ы конфигурации
	AC_CONFIG_HEADERS(header ...,[cmds],[init-cmds])
	AH_HEADER
	4.9.1 AC_CHECK_HEADERS(...)
	.......
	4.9.3 макросы autoheader
	AH_TEMPLATE(key, description)
	AH_VERBATIM(key,template)
	AH_TOP(text)
	AH_BOTTOM(text)
4.10 запуск произвольных конфигурационных команд
	AC_CONFIG_COMMANDS(tag...,[cmds],[init-cmds])
	AC_CONFIG_COMMANDS_PRE(cmds)
	AC_CONFIG_COMMANDS_POST(cmds)
4.11 создание конфигурационных ссылок
	AC_CONFIG_LINKS(dest:source...,[cmds],[init-cmds])
4.12 настройка других пакетов в подкаталогах
	AC_CONFIG_SUBDIRS(dir ...)
4.13 префикс по умолчанию
	AC_PREFIX_DEFAULT(prefix)
	AC_PREFIX_PROGRAM(program)
}
{old4 существующие тесты
{+5.1 общее поведение
5.1.1 стандартные символы
	...
5.1.2 default includes
	AC_INCLUDES_DEFAULT([include-directives])
}
{4,1 альтернативные программы
4.1.1 проверка отдельных программ
<-	AC_PROG_CC
<-	AC_PROG_CC_C_O
<-	AC_PROG_CPP
<-	AC_PROG_CXX
<-	AC_PROG_CXXCPP
<-	AC_PROG_F77
<-	AC_PROG_F77_C_O
<-	AC_PROG_GCC_TRADITIONAL
-	AC_DECL_YYTEXT
	AC_PROG_AWK
+	AC_PROG_GREP
+	AC_PROG_EGREP
+	AC_PROG_FGREP
	AC_PROG_INSTALL
+	AC_PROG_MKDIR_P
	AC_PROG_LEX
	AC_PROG_LN_S
	AC_PROG_RANLIB
+	AC_PROG_SED
	AC_PROG_YACC
4.1.2 общие программы и проверкии файлов
<-	AC_CHECK_FILE(file[, action-if-founbf[, action-if-not-found]])
<-	AC_CHECK_FILES(files[, action-if-founbf[, action-if-not-found]])
+	path -> path=$PATH
	AC_CHECK_PROG(variable, prog-to-check-for, value-if-found 
		   [, value-if-not-found [, path , [ reject ]]])
	AC_CHECK_PROGS(variable, progs-to-check-for
						[, value-if-not-found [, path]])
+	AC_CHECK_TARGET_TOOL(variable, prog-to-check-for,
						[value-if-not-found], [path])
	AC_CHECK_TOOL(variable, prog-to-check-for
						[, value-if-not-found [, path]])
+	AC_CHECK_TARGET_TOOLS(variable, prog-to-check-for,
						[value-if-not-found], [path])
+	AC_CHECK_TOOLS(variable, prog-to-check-for
						[, value-if-not-found [, path]])
	AC_PATH_PROG(variable, prog-to-check-for
						[, value-if-not-found [, path]])
	AC_PATH_PROGS(variable, progs-to-check-for
						[, value-if-not-found [, path]])
+	AC_PATH_PROGS_FUTURE_CHECK(variable, progs-to-check-for, feature-test
						[, value-if-not-found [, path]])
+	AC_PATH_TARGET_TOOL(variable, prog-to-check-for
						[, value-if-not-found [, path]])
+	AC_PATH_TOOL(variable, prog-to-check-for
						[, value-if-not-found [, path]])
}
{5.3 файлы
->	AC_CHECK_FILE(file[, action-if-founbf[, action-if-not-found]])
->	AC_CHECK_FILES(files[, action-if-founbf[, action-if-not-found]])
}
{4.2 файлы библиотек
	AC_CHECK_LIB(library, function [, action-if-found 
					[, action-if-not-found [, other-libraries]]])
-	AC_HAVE_LIBRARY(library, [, action-if-found
					[, action-if-not-found [, other-libraries]]])
	AC_SEARCH_LIBS(function, search-libs [, action-if-found 
					[, action-if-not-found [, other-libraries]]])
-	AC_SEARCH_LIBS(function, search-libs [, action-if-found
					[, action-if-not-found]])
}
{4.3 библиотечные функции
+5.5.1 портабельность сишных функций
	.....
4.3.1 проверка отдельных функций
	AC_FUNC_ALLOCA
+	AC_FUNC_CHOWN
	AC_FUNC_CLOSEDIR_VOID
+	AC_FUNC_ERROR_AT_LINE
	AC_FUNC_FNMATCH
+	AC_FUNC_FNMATCH_GNU
+	AC_FUNC_FORK
+	AC_FUNC_FSEEKO
+	AC_FINC_GETGROUPS
	AC_FUNC_GETLOADAVG
	AC_FUNC_GETMNTENT
	AC_FUNC_GETPGRP
+	AC_FUNC_LSTAT_FOLLOWS_SLASHED_SYMLINK
+	AC_FUNC_MALLOC
+	AC_FUNC_MBRTOWC
	AC_FUNC_MEMCMP
+	AC_FUNC_MKTIME
	AC_FUNC_MMAP
	AC_FUNC_SELECT_ARGTYPES
	AC_FUNC_SETPGRP
	AC_FUNC_SETVBUF_RESERVED
	AC_FUNC_STRCOLL
	AC_FUNC_STRFTIME
	AC_FUNC_UTIME_NULL
	AC_FUNK_VFORK
	AC_FUNC_VPRINTF
	AC_FUNC_WAIT3
4.3.2 проверка базовых функций
	AC_CHECK_FUNC(function, [action-if-found [, action-if-not-found]])
	AC_CHECK_FUNCS(function... [, action-if-found 
				   [, action-if-not-found]])
	AC_REPLACE_FUNCS(function... )
}
{4.4 заголовочные файлы
4.4.1 проверка отдельных заголовочных файлов
	AC_DECL_SYS_SIGLIST
	AC_DIR_HEADER
	AC_HEADER_DIRENT
	AC_HEADER_MAJOR
	AC_HEADER_STDC
	AC_HEADER_SYS_WAIT
	AC_MEMORY_H
	AAC_UNISTD_H
	AC_USG
4.4.2 базовые проверки заголовочных файлов
	AC CHECK HEADER(header-file, [action-if-found 
				   [, action-if-not-found]])
	AC_CHECK_HEADERS(header-file ... [, action-if-found 
					 [, action-if-not-found]])
}
{4.5 структуры
	AC_HEADER_STAT
	AC_HEADER_TIME
	AC_STRUCT_ST_BLKSIZE
	AC_STRUCT_ST_BLOCKS
	AC_STRUCT_ST_RDEV
	AC_STRUCT_TM
	AC_STRUCT_TIMEZONE
}
{4.6 объявления типов
4.6.1 проверка отдельных объявлений типов
	AC_TYPE_GETGROUPS
	AC_TYPE_MODE_T
	AC_TYPE_OFF_T
	AC_TYPE_PID_T
	AC_TYPE_SIGNAL
	AC_TYPE_SIZE_T
	AC_TYPE_UID_T
4.6.2 базовые проверки объявления типов
	AC_CHECK_TYPE(type, default)
}
{4.7 характеристики компилятора СИ
	AC_C_BIGENDIAN
	AC_C_INLINE
	AC_C_CHAR_UNSIGNED
	AC_C_LONG_DOUBLE
	AC_C_STRINGSIZE
	AC_CHECK_SIZEOF(type [, cross-size])
	AC_INT_16_BITS
	AC_LOLONG_64_BITS
}
{4.8 характеристики компилятора fortran77
	AC_F77_LIBRARY_LDFLAGS
}
{4.9 системные сервисы
	AC_CYGWIN
	AC_EXEEXT
	AC_OBJEXT
	AC_MINGW32
	AC_PATH_X
	AC_PATH_XTRA
	AC_SYS_INTERPRETER
	AC_SYS_LONG_FILE_NAMES
	AC_SYS_RESTARTABLE_SYSCALLS
}
{4.10 варианты UNIX
	AC_AIX
	AC_DYNIX_SEQ
	AC_IRIX_SUN
	AC_ISC_POSIX
	AC_MINIX
	AC_SCO_INTL
	AC_XENIX_DIR
}
}
.