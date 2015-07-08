{prg14_15.pas}
{Программа, вызывающая процедуру на ассемблере}
program my_pas;
{$D+} {включение полной информации для отладчика}
uses crt;
procedure asmproc(ch:char;x,y,kol:integer); external;
{процедура asmproc обьявлена как внешняя}
{$L c:\bp\work\prg14_12.obj}
BEGIN
	clrscr;	{очистка экрана}
	asmproc('a',1,4,5);
	asmproc('s',9,2,7);
END.

