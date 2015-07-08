function backSpace
global xmas ymas hAxes
global xxl xxh yyl yyh

if length(xmas)>1
l=length(xmas)-1;
    for i=1:l
        mm(i)=xmas(i);
    end;
xmas=mm;
    for i=1:l
        mm(i)=ymas(i);
    end;
ymas=mm;
else
    xmas=[];
    ymas=[];
end;

plot(xmas,ymas);
set(hAxes,'ButtonDownFcn','MyButtonDownInAxes');
axis([xxl xxh yyl yyh]);

end
