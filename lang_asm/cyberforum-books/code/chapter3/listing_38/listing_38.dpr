program Project1;
var
a:integer;
procedure proc1(a1:integer);
var  b,g,d,e:integer;
  procedure proc2(a1:integer);
  var c:integer;
  begin
    c:=30;
    writeln(a1,b,c,d,e,g);
  end;
begin
   b:=20; g:=30; d:=40; e:=50;
   proc2(a1);
end;
begin
  a:=10;
  proc1(a);
end.

