http://sijinjoseph.com/programmer-competency-matrix/
0 - nub
1 - newer
2 - intermediate
3 - profi
{computer science:1.1.1.
{data structures:1-2
/*linkedList - обычный список*/
{0	не знает разницы между массивом и списком}
{1	способен понимать и использовать массивы, списки, словари и.т.д. в задачах практического программирования}
>> tradeoffs - компромисы
{2	знает пространство и время компромиссов базовых структур данных, массивов и списков
	в состоянии объяснить, как могут быть реализованы хеш-таблицы, очереди с приоритетами и пути их реализации}
{3	знает сложные структуры данных, такие как b-деревья, бинарные и фибоначчивы кучи, AVL/красно-черные деревья
	Splay Trees, Skip Lists, tries etc.
}
}
{algorithms:1
{0	не в состоянии найти среднее чисел в массиве
	(мне и такие кандидаты встречались)
}
>> traversal - обход
>> retrieval - поиск
{1	базовые алгоритмы сортировки, поиска, обхода структур данных}
{2	деревья, графы, простые жадные и делящие и завоевывающие алгоритмы
	в состоянии объяснить релевантность уровней этой матрицы
}
{3	в состоянии распознать и закодить динамиески программируемое решение
	хорошее занние алгоритмов на графах, хорошее знание алгоритмов численных вычислений
	в состоянии идентифицировать NP-прблемы и т.д.
}
/*	работа с тем, кто имеет высокий уровень, будет неописуемой удачей*/
}
{system programming:1, немного 3
{0	не знает что такое компилятор, линкер, интерпретатор}
{1	базовое понимание компиляторов, линкера и интерпретатора
	понимание, что такое скомпилированный код, и как эти вещи работают на уровне железа
	некоторые познания в виртуальной памяти и страницах памяти}
{2	понимет kernel mode & user mode, многопоточность, примитивы синхронизации и как они реализуются
	в состоянии читать ассемблерный код. Понимает, как рабтают сети, 
	понимает сетевые протоколы и программирование уровня соккетов}
{3	понимание внутреннего программного стека, железа (ЦП+память+кешь+прерывания+микрокод), бинарного кода,
	ассемблера, статического и динамического связывания, компиляции, интерпретации, компиляции на лету,
	сборки мусора, кучи, стека, адресации памяти
}
}
}
{software engeneeging:1.2.0.
{source code version control:1
{0	папка резервного копирования по дате}
{1	VSS и начинающий пользователь CVS/SVN}
{2	профессионал в использовании возможностей CVS/SVN, знает, как ответвлять и сливать
	использовать патчи, настраивать свойства репозитория
}
{3	знает распределенные VCS системы. пробовал Bzr/Mercurial/Darcs/Git}
}
{build automation:2
{0	только знает, как собирать в IDE}
{1	знает, как собрать систему в командной строке}
{2	может создать скрипт для сборки базовой системы}
{3	может установить скрипт для сборки системы
	а также документации, установки, генерировать заметки выпуска(?) и добавлять код под контроль версий
}
}
{automated testing:0
{0	думает, что тестирование - работа тестера}
>> come up - придумать, начинать....
{1	писал автоматизированные модульные тесты
	и принимается за код, который будет написан, с хорошими случаями модульных тестов
}
{2	имеет код, написанный в манере TDD}
{3	понимает и в состоянии установить автоматизированные функциональные
	, загрузки/представления(?) и графического интерфейса тесты
}
}
}
{programming:2.2.2.2.2.2-3.2.1-2.2.1-2.1-2.2.1.0-1.....
>> decomposition - разложение
{problem decomposition:2
>> straight - прямо
>> reuse - re use
{0	(?)тупо копирует код для повторного использования}
{1	в состоянии разбить проблему на множество функций}
{2	в состоянии изобрести повторно используемые функции/объекты, которые решают всеобъемлющие проблемы}
{3	использует подходящие структуры данных и алгоритмы
	и изобретает общий/объектно-ориентированный код, инкапсулирующий аспекты проблемы, которую он решает
}
}
{systems decomposition:2
{0	не в состоянии думать более чем об одном файле/классе}
{1	в состоянии разбивать проблемное пространство и изобретать решения
	на столько же (?)долгие, как они реализованы в аналогичных платформах/технологиях
}
>> span - охватывать
{2	в состоянии разрабатывать системы, которые охватывают множество технологий/платформ}
{3	в состоянии визуализировать и разработать комплексную систему с (?)многими линиями продукта и интеграцией с нешними системами
	также должен ьбыть в состоянии разработать системы поддержки операций, таких как мониторинг, оповещение, fail overs и т.д.
}
}
{communication:2
>> express - выразить, экспресс, курьер
>> thought - мысль
>> peer - присматриваться, ровня
>> poor - бедный, плохой
>> spelling - орфорграфия, правописание
{0	не может выразить мысли коллег, плохая орфография и грамматика}
{1	коллеги могут понимать, что он говорит. Хорошая орфография и грамматика.}
{2	в состоянии эффективно взаимодействовать с коллегами}
{3	в состоянии понимать и общаться мыслями/дизайном/идеями/спецификациями в однозначной манере
	и регулировать коммуникацию в контексте(?)
}
/*
это часто не используемый, но очень критичный критерий для оценки программиста
с увеличением аутсорсинга програмистских задач в местах, где английский не является родным языком
эта пролема становится наиболее видной
я знаю несколько проэктов, которые провалились, потому что программисты не понимали цель обсуждения
*/
}
{code organization within a file:2
>> evidence - свидетельство, доказательство, данные, признаки
{0	(?)нет доказательства организации внутри файла}
{1	методы сгруппированы локально(?) или по доступности}
{2	код сгруппирован на регионы и хорошо откомментирован со ссылками на другие исходники}
{3	файл имеет заголовок лицензии, в общем хорошо отдокументирован, соответствующее использование пространства.
	файл ждолжен выглядеть крассиво
}
}
{code organization across files:2
{0	нет мыслей, дающих организацию кода между файлами}
{1	подходящие файлы группируются в папки}
{2	каждый физический файл имеет уникальную цель, например одна реализация класса, одна реализация фичи}
{3	организация кода на физическом уровне полностью соответствует дизайну, 
	и выглядит в именах файлов и распределении папок представлением идеи дизайна
}
}
{source tree organization:2
{0	все в одной папке}
{1	базовое разделение кода на (?)логические папки}
{2	нет циклических зависимостей, бинарники, библиотеки, сборка, третьисторонний код - все организовано по соответствующим папкам}
{3	физическая модель дерева исходников соответствует логической иерархии и организации
	имена директорий и организация представляет идею дизайна системы
}
/*
отличие между этим и предыдущим пунктом в шкале организации
организация дерева исходников соответствует внутреннему множеству артефактов, определяющему систему
*/
}
{code read-ability:2-3
>> syllable - слог, слово, звук
{0	одно-сложные имена}
{1	хорошие имена для файлов, переменных классов, методов и т.д.}
{2	недлинные функции, комментарии объясняют необычный код, баг-фиксы, допущения в коде}
{3	допущения в коде проверяются использованием ассертов, поток кода натуральный, нет глубоко вложенных условий или методов}
}
{defensive coding:2
{0	не понимает концепцию}
>> assumption - допущение
>> assert - утверждать, заявлять
{1	проверяет все аргументы и обозначает критические допущения в коде}
{2	уверенно использует проверку возвращаемого значения, или проверку исключений вокруг кода, который может упасть}
{3	имеет собственную библиотеку, помогающую в защищенном программировании
	пишет модульные тесты, которые симулируют неисправности
}
}
{error handling:1-2
{0	только коды счастливого случая(?)}
{1	базовая обработка ошибок вокруг кода, который может кидать исключения/генерировать ошибки}
{2	убеждается, что ошибка или исключение с которым завершается программа в хорошем состоянии
	ресурсы, соединения и память - все чисто очищено
}
{3	кодит, чтобы обнаружить по возможности исключение до(?)
	поддерживает соответствующую стратегию обработки исключений на всех уровнях кода
	придумывает, руководствуясь определенными принципами обработку исключений для всей системы
}
}
{IDE:2
{0	в основном использует IDE для редактирования кода}
{1	знает их(?) путь в обход интерфейса, в состоянии эффективно пользоваться IDE, используя меню}
{2	знает быстрые клавиши для наиболее часто используемых операций}
{3	имеет сообственные макросы}
}
{API:1-2
{0	часто нуждается в документации}
{1	наиболее часто пользуется API по памяти}
{2	огромные и глубокие познания API}
{3	имеет собственные библиотеки поверх API, для упрощения часто используемых задач и заполнения пробелов в API}
/*API может являться java-библиотека, .Net framework, или специальный API приложения*/
}
{frameworks:1-2
{0	не использует никаких фреймворков кроме основной платформы}
{1	слышал о популярных фреймворках, доступных для платформы, но не использует их}
{2	использовал больше чем один фреймворк в профессиональном опыте
	и хорошо осведомлен о возможностях фреймворков
}
{3	автор фреймворка}
}
{requirements:2
{0	принимает данные требования и кодит в соответствии со спецификацией(codes to spec)}
>> regarding - относительно, о
{1	придумывает вопросы об отсутствующих случаях в спецификации}
{2	понимает общую картину, и придумывает, что нужно для ускорения прог-и, зная внутренние области}
>> suggest - предложить
>> flow - течь, течение, поток
{3	в состоянии предложить лучшие альтернативы и потоки для данных требований, базируясь на опыте}
}
{scripting:1
{0	не имеет знаний о скриптовых средствах}
{1	Batch files/shell scripts}
{2	Perl/Python/Ruby/VBScript/Powershell}
{3	имеет написанный и опубликованный многократно используемый код}
}
{database:0-1.....
{0	думает, что excel - это база данных}
{1	знает базовые концепции баз данных, нормализацию, ACID, трансляцию, и может написать простой селектор}
{2	Able to design good and normalized database schemas keeping in mind the queries 
	that’ll have to be run, proficient in use of views, stored procedures, triggers and user defined types.
	Knows difference between clustered and non-clustered indexes. Proficient in use of ORM tools.
}
{3	Can do basic database administration, performance optimization, index optimization, write advanced select queries,
	able to replace cursor usage with relational sql, understands how data is stored internally,
	understands how indexes are stored internally, understands how databases can be mirrored, replicated etc.
	Understands how the two phase commit works
}
}
}
{experience:2.1.1.0-1
{languages with professional experience:0-2
{0	императивные или объектно-ориетированные}
>> inferred - предполагаемый
{1	иперативные, объектно-ориентированные и декларативные (SQL)
	добавляется бонус, если он понимает статическую и динамическую, слабю и сильную типизацию и статическую предполагаемую типизацию}
{2	функциональные
	добавляется бонус, если он понимает ленивые вычисления, карринг и замыкания}
{3	Concurrent (Erlang, Oz) and Logic (Prolog)}
}
{platforms with professional experince:1
{0	1}
{1	2-3}
{2	4-5}
{3	6+}
}
{yaers of professional experience:1
{0	1}
{1	2-5}
{2	6-9}
{3	10+}
}
>> domain knowledge - знания предметной области
{domain knowledge:0-1
{0	не имеет знаний в предметной области}
{1	имеет только один разработанный продукт в предметной области}
{2	имеет несколько разработанных продуктов в одной и той же предметной области}
{3	эксперт в своей области
	имеет разработанными и реализованными несколько продуктов/решений в одной и той же предметной области
	хорошо разбирается в стандартных терминах и протоколах в предметной области
}
}
}
{knowledge:1.2.?.1.1.1.
{tool knowledge:1
{0	ограничены в основном IDE (VS.NET, eclipse и т.д)}
{1	знает о некоторых альтернативах для популярных и стандартных средств}
{2	хорошие знания редакторов, дебаггеров, IDE, open-source альтернатив и т.д. и т.п.
	например некоторые из тех, кто хзнает большинство средств из списка мощных средств Скотта Ханселмана (Scott Hanselman)
	использовал ORM tools
}
{3	имеет актуальные, написанные средства и скрипты
	добавляется бонус, если они опубликованы
}
}
???>> languages exposes to - языки подвергаются
{languages exposes to:2,1-не все
{0	императивные или объектно-ориетированные}
! >> inferred - предполагаемый
{1	иперативные, объектно-ориентированные и декларативные (SQL)
	добавляется бонус, если он понимает статическую и динамическую, слабю и сильную типизацию и статическую предполагаемую типизацию}
{2	функциональные
	добавляется бонус, если он понимает ленивые вычисления, карринг и замыкания}
{3	Concurrent (Erlang, Oz) and Logic (Prolog)}
}
{codebase(?) knowledge:?
{0	никогда не видел codebase(?)}
{1	базовые знания о модели кода и как собрать систему}
{2	хорошие работающие знания базы кода, 
	имеет несколько реализованных баг-фиксов и может быть несколько маленьких фич}
{3	реализовал много больших фич в codebase
	и может просто визуализировать какие изменения требуются для большинства фич и баг-фиксов
}
}
>> upcoming - предстоящий, развивающийся
{knowledge of upcoming technologies:1
{0	не слышал развивающихся технологиях}
{1	слышал о развивающихся технология (?)в поле}
{2	скачивал alpha/ctp/beta/preview и читал некоторые статьи и мануалы}
{3	играл с preview и и что-то (?)актуально собирал этим
	как бонус: делился этим со всеми
}
}
{platform internals:1+-/*внутренности*/
{0	нулевые знания о внутренностях платформы}
{1	имеет базовые представления о том, как платформа работает внутри}
{2	глубокие познания внутренности платформы
	и способность визуализировать, как платформа берет программу и конвертирует ее в исполняемый код
}
>> enhance - повышать, усиливать
{3	писал средства для (?)повышени или предоставления информации о внутренностях платформы
	к примеру дизассемблеры, декомпиляторы, дебаггеры и т.д.
}
}
{books:1
>> leash - поводок, привязь
{0	развязанные серии, 21-дневные серии, 24-часовые серии, макетные серии}
{1	Совершенный код, Не заставляйте меня думать, Mastering Regular Expressions}
{2	Design Patterns, Peopleware, Programming Pearls, Algorithm Design Manual, Pragmatic Programmer, Mythical Man month}
{3	Structure and Interpretation of Computer Programs, Concepts Techniques, Models of Computer Programming
	Art of Computer Programming, Database systems , by C. J Date, Thinking Forth, Little Schemer}
}
{blogs:1
{0	слышал о таких, но не было времени}
{1	читает блоги об обучении/программировании/разработке ПО и регулярно слушет подкасты}
{2	поддерживает ссылочный блог с некоторой коллекцией полезных статей и средств, которые он нарыл}
>> insights - понимание, идея
{3	поддерживает shared блог с его собственными идеями и мыслями о программировании}
}
}