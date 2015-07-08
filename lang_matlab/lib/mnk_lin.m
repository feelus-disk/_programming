function [a sa b sb]=mnk_lin(x,y)
%[a sa b sb]=mnk_lin(x,y)
%y=ax+b
%see also my_lib_help
if(length(x)~=length(y) | length(y)<2)
    error('bad size of x or y');
end;
n=length(x);    %disp('n:');disp(n);
xs=sum(x)/n;    %disp('xs:');disp(xs);
ys=sum(y)/n;    %disp('ys:');disp(ys);
sx=(sum((x-xs).^2)/(n-1))^0.5;      %disp('sx:');disp(sx);
sy=(sum((y-xs).^2)/(n-1))^0.5;      %disp('sy:');disp(sy);
r=sum((x-xs).*(y-ys))/(n-1)/sx/sy;  %disp('r:');disp(r);
a=r*sy/sx;                          %disp('a:');disp(a);
b=ys-a*xs;                          %disp('b:');disp(b);
sa=((1-r^2)/(n-2))^0.5*sy/sx;       %disp('sa:');disp(sa);   %????????????
sb=sa*(((n-1)*sx^2+n*xs^2)/n)^0.5;  %disp('sb:');disp(sb);   %????????????
end
