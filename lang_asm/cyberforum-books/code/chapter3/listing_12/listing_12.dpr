program Project1;

{$APPTYPE CONSOLE}

uses
  SysUtils;

var
  s1:widestring;
  s2:string; {по умолчанию это AnsiString}
  s3:shortstring;

begin
  s1:='Hello world!';
  s2:='Hello progarammers!';
  s3:='Hello hackers!';
  writeln(s1);
  writeln(s2);
  writeln(s3);
end.

