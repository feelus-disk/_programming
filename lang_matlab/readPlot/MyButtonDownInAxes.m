function MyButtonDownInAxes
global hAxes 
global h xmas ymas
global xxl xxh yyl yyh
v=get(hAxes,'CurrentPoint'); 
x=v(1,1); y=v(1,2); 

    xmas=[xmas x];
    ymas=[ymas y];
    
plot(xmas,ymas);
set(hAxes,'ButtonDownFcn','MyButtonDownInAxes');
axis([xxl xxh yyl yyh]);

end
