function fout=sloyY(f,yp)
%[smth] sloyY([smth] f, int yp)
%eq f(yp,:,:)
%превращает трехмерный массив в двумерный
fout=f(yp,:,:);
%{
[szy szx szz]=size(f);
for xp=1:szx
    for zp=1:szz
        fout(zp,xp)=f(yp,xp,zp);
    end;
end;
%}
end
