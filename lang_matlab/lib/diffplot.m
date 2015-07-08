function [x_ dy]=diffplot(x,y)
%[float x_, dy] diffplot([float] x, [float] y)
%численно вычисляет производную по точкам
%как следствие точек на одну меньше
x_=[];
dy=[];
%{
for i=1:length(x)-1
    a=(y(i+1)-y(i))/(x(i+1)-x(i));
    dy=[dy a a];
    x_=[x_ x(i) x(i+1)];
end;
%}
for i=1:length(x)-1
    a=(y(i+1)-y(i))/(x(i+1)-x(i));
    dy=[dy a];
    x_=[x_ (x(i)+x(i+1))/2];
end;
end