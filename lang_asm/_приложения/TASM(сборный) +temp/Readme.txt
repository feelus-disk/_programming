Подробный мануал по использованию ТрубоАссемблера
..........................................
0. Закидываем файлы tasm.exe и tlink.exe в папку C:\Documents and Settings\Имя_пользователя\
1. Набиваем исходник программы в тектовом редакторе
2. Сохраняем его в папке C:\Documents and Settings\Имя_пользователя\ с расширением *.asm (необязательно, можно и *.txt), например, Go_Baby.asm, 
3. Запускаем командную стороку (Пуск-Выполнить-cmd)

Видим

Microsoft Windows XP [Версия 5.1.2600]
(?) 1985-2001.

C:\Documents and Settings\Имя_пользователя>

4. Создаём объектный файл Go_Baby.obj.

Пишем

tasm Go_Baby.asm

Видим

C:\Documents and Settings\Имя_пользователя\tasm Go_Baby.asm
Turbo Assembler  Version 4.1  Copyright (c) 1988, 1996 Borland International	{Реклама}

Assembling file:   Go_Baby.asm                {имя исходного файла}
Error messages:    None			      {сообщения о ошибках}
Warning messages:  None                       {предупреждения}
Passes:            1 			      {число проходов}
Remaining memory:  445k

C:\Documents and Settings\Имя_пользователя>

Если полезли ошибки, то возвращаемся в текстовый редактор, правим исходник и заново ассемблируем

5. Создаём исполняемый файл из объектного файла 

tlink.exe Go_Baby.obj /t

Видим

Turbo Link  Version 7.1.30.1. Copyright (c) 1987, 1996 Borland International   {Реклама}

Ключ /t показывает, что создается com-программа, при его отсутствии генерируется exe-программа

6. Запускаем программу

Go_Baby