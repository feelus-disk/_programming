{file
visit new file... - C-x C-f
open file...
open directory... - C-x d
insert file... - C-x i
----
Save - C-x C-s
Save as... - C-x C-v
revert buffer //? вернуть буфер
recover crashed session
----
print buffer
print region
postScript print buffer
postScript print region
postScript print buffer (B+W)
postScript print region (B+W)
----
split window - C-x 2
remove splits - C-x 1
new frame - C-x 5 2
new frame on display...
delete frame - C-x 5 0
----
quit - C-x C-c
}
{edit
undo - C-x u
cut - <cut>
copy - <copy>
paste - <paste>
{paste from kill menu
.........
}
clear
select all - C-x h
------
{search
string forward...
string backwards...
regexp forward...
regexp backwards...
------
repeat forward
repeat backwards
------
search tagged files...
continue tags search - M-,
{incremental search
forward string... - C-s
backward string... - C-r
forward regexp... - C-M-s
backward regexp... - C-M-r
}
}
{replace
replace string... - M-%
replace regexp... - C-M-%
------
replace in tagged files...
continue replace - M-,
}
{go to
goto line... - M-g g
goto buffer position...
goto beginning of buffer - M-<
goto end of buffer - M->
------
find tag... - M-.
find tag in other window... - C-x 4 .
find next tag
next tag in other window
tags apropos...
------
set tags file name...
}
{bookmarks
jump to bookmark... - C-x r b
set bookmark... - C-x r m
insert contents...
insert location...
reneme bookmark...
delete bookmark...
edit bookmark list - C-x r l
save bookmarks
save bookmarks as...
load a bookmark file
}
------
fill
{text properties
{face
default - M-o d
bold - M-o b
italic - M-o i
bold-italic - M-o l
underline - M-o u
other... - M-o o
}
{foreground color
other...
}
{background color
other...
}
{special properties
read-only
invisible
intangible
remove special
}
------
{justification //оправдание?
unfilled
right
left
full
center
}
{indentation //отступ
indent more
indent less
indent rigth more
indent right less
}
------
remove face properties
remove text properties
describe properties
display faces
display colors
}
}
{options
[*]active region highlighting
[ ]paren match highlighting
------
{line wrapping in thos buffer
(*)wrap at window adge
( )truncate long lines
( )word wrap (visual line mode)
}
[ ]autofill in text modes
[*]case-insensitive search
[ ]C-x/C-c/C-v cut and puste (CUA)
------
[ ]use directory names in buffer names
[ ]save place in files between sessions
------
[*]blinking cursor
------
[ ]enter debugger on error
[ ]enter debugger on Quit/C-g
------
{mule (multilingual envinronment)
{set language envinronment
default
{chinese
...
}
{cyrillic
...
}
{indian
...
}
{european
...
}
....
}
------
toggle input method - C-\
select input method... - C-x ret C-\
------
{set coding systems
for next command - C-x ret c
------
for saving this buffer - C-x ret f
for reverting this file now - C-x ret r
for file name - C-x ret F
------
for keyboard - C-x ret k
for terminal - C-x ret t
------
for X selections/clipboard - C-x ret x
for next X selection - C-x ret X
for I/O with subprocess - C-x ret p
}
show multi-lingual text - C-h h
------
describe laguage envinronment
describe input method... - C-h I
describe coding system... - C-h C
list character sets
show all of mule status
}
------
{show hide
[*]toolbar
[*]menubar
[*]tooltips
{scrollbar
( )none
( )on the left
(*)on the right
}
{fringe
( )none
( )on the left
( )on the right
(*)default
( )customize fringe
( )empty line indicators
( )buffer boundaroes
}
[ ]speedbar
------
[*]time, load and mail
[ ]battary status
------
[*]size indication
[*]line numbers
[*]coloumn numbers
}
set default font...
------
save options
{customize emacs
top level customization group
brouse customization groups
------
saved options
new options...
------
specific option...
specific face...
specific group...
------
settings matching regexp...
options matching regexp...
faces matching regexp...
groups matching regexp...
}
}
{buffers
список не всех буферов
------
если несколько окон
{frames
список окон
}
------
next buffer - C-x <C-right>
previous buffer - C-x <C-left>
select named buffer... - C-x b
list all buffers - C-x C-b
}
{tools

}
{help
emacs tutorial - C-h t
emacs tutorial (choose language)...
emacs FAQ - C-h C-f
emacs news - C-h n
emacs known problems - C-h C-p
send bug report...
emacs psychotheapist
------
{search documentation
}
{describe
describe buffer modes - C-h m
describe key or mous operation... - C-h k
describe function... - C-h f
describe variable... - C-h v
describe face...
describe display table
list key bindings - C-h b
}
read the emacs manual - C-h r
{more manuals
introducting to emacs lisp
emacs lisp reference
all other manuals (info)
lookup subject in all manuals...
ordering manuals - C-h ret
------
read man page
}
find emacs packages - C-h p
external packages
------
getting new versions - C-h C-o
copying conditions - C-h C-c
(non)warranty - C-h C-w
------
about emacs - C-h C-a
about gnu - C-h g
}
===================================
	funcall fun &rest args
	function arg
	nth n list
eval.c
	signal error-symbol data
	defmacro .......
	defun ........
	defvar ........
	quote arg
	let ......
	let* .......
	setq [sym val]...
	progn body
	prog1 first body... //вычисляет последовательно first , body, возвращает first
	apply fun &rest args
	and
	or
	if cond then else
	cond ....
	while test body//cycle
data.c
	fset SYMBOL DEFINITION//Set SYMBOL's function definition to DEFINITION, and return DEFINITION.
	defalias SYMBOL DEFINITION &optional DOCSTRING//устанавливает определение функции символа на definition
	eq x x//the same lisp object
	car x
	cdr x
	null x
	consp x//cons ячейка ли
	listp obj
	memq elt list//возвращает хвост списка, начинающийся с elt. сравнивает eq
	symbolp obj//символ ли он
	boundp symbol//связан ли он
	symbol-value symbol//значение символа, иначе ошибка
	bufferp obj//буфер ли
	indirect-function object &optional noerr
alloc.c
	cons car cdr
	list &rest objs
	make-symbol name//
fns.c
	eql x x//послабее eq для чисел с пл. точкой
	equal x x//одинаковая структура, содержание, тип, int!=float, 
	get symbol propname
	put symbol propname value
	make-hash-table &rest keyword-args
	puthash key value table
	define-hash-table-test name test-f hash-f//определяет новый хеш
	futures//list of futures
	provide future &optional subfuture
	require future &optional filename noerror
	futurep future &optional subfuture
buffer.c
	buffer-name &optional buffer//имя буффера(по умолчанию текущего)
editfns.c
	format string &rest objects
	message FORMAT-STRING &rest ARGS
lread.c
	load file &optional noerror
