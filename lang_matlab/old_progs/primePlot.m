function ret = primePlot(m);


pr=primes(m);
pos=1;

for i=1:(pr(end));
    if i>=(pr(pos));
        pos=pos+1;
    end;
    ret(i)=pos-1;
end;
for i=(pr(end)+1):m;
    ret(i)=pos-1;
end;
