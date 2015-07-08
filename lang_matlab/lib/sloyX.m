function fout=sloyX(f,xp)
[szy szx szz]=size(f);
for yp=1:szy
    for zp=1:szz
        fout(zp,yp)=f(yp,xp,zp);
    end;
end;
end
