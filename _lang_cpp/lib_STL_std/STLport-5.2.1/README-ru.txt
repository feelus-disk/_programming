**********************************************************************
* 	README file for STLport 5.0                                      *
*                                                                    *
**********************************************************************

This directory contains the STLport-5.0 release.

What's inside :

README           - Этот файл
INSTALL          - инструкции по установке

bin              - директория установки для юнит-тестов STLport;
                   она может содержать больше поддиректорий, если вы используете кросскомпиляцию
lib              - директория установки для библиотеки STLport (если вы используете
                   STLport iostreams и/или locale только);
                   it may contain more subdirs, if you use
                   crosscompilation
build/lib        - директория сборки для библиотеки STLport (если вы используете
                   STLport iostreams и/или locale только)
build/test/unit  - директория сборки для регрессивных (модульных) тестов
build/test/eh    - директория сборки для обработки тестов исключений
stlport          - главная include директория STLport
src              - исходники для реализации iostreamsи других частей
                   которые не являются чисто шаблонным кодом
test/unit        - unit (regression) tests
test/eh          - exception handling test using STLport iostreams
etc              - разные файлы (ChangeLog, TODO, scripts, etc.) 

GETTING STLPORT

To download the latest version of STLport, please be sure to visit
https://sourceforge.net/project/showfiles.php?group_id=146814

LEGALESE

This software is being distributed under the following terms:

 *
 *
 * Copyright (c) 1994
 * Hewlett-Packard Company
 *
 * Copyright (c) 1996-1999
 * Silicon Graphics Computer Systems, Inc.
 *
 * Copyright (c) 1997
 * Moscow Center for SPARC Technology
 *
 * Copyright (c) 1999-2003
 * Boris Fomitchev
 *
 * This material is provided "as is", with absolutely no warranty expressed
 * or implied. Any use is at your own risk.
 *
 * Permission to use or copy this software for any purpose is hereby granted 
 * without fee, provided the above notices are retained on all copies.
 * Permission to modify the code and to distribute modified code is granted,
 * provided the above notices are retained, and a notice that the code was
 * modified is included with the above copyright notice.
 *

**********************************************************************
