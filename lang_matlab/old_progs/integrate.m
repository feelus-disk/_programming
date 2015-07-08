function ret=integrate(x,dx)

ret=x(1);
for i=2:length(x);
    q=ret(end);
    ret=[ret,q+x(i).*dx];
end;
