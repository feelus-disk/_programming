{prg14_17.pas}
program	prg14101;
{внешние обьявления}
function	AddAsm:word; external;
{$L prg14_18.obj}
var
	value1:	word;	{здесь как внешние}
	value2:	word;
	rez:	word;
begin
	value1:=2;
	value2:=3;
{вызов функции}
	rez:=AddAsm;
	writeln('Результат: ',rez);
end.

