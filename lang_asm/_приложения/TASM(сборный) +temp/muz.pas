program muz;
{$D+}
uses wincrt;
procedure vkl(x:word);     external;
{$L D:\compilators\Assembler\TASM\vkl.obj}
begin
while true
do vkl(2705);
end.