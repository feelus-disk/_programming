hold on;

t=0:1.5:15;
c=[
    0.01
    0.007561
    0.005917
    0.004765
    0.003906
    0.003265
    0.00277
    0.00238
    0.002066
    0.001811
    0.0016
];
plot(t,c,'.');
l=length(c);

for i=2:l-1
    w(i)=(c(i-1)-c(i+1))/3;
end;
w(1)=0;
w(l)=0;
w=w';

tt=trunc_mas(t,2,l-1);
cc=trunc_mas(c,2,l-1);
ww=trunc_mas(w,2,l-1);
ll=l-2;

disp(ww);
%plot(tt,ww,'.-')
for i=1:ll
    for j=1:ll
        lw(i,j)=log(w(i)/w(j))/log(c(i)/c(j));
    end;
end;
disp(lw);

n=1.5;
%plot(cc.^n,ww,'.');

k=ww(1)/cc(1).^n;
k=2;
disp(k);

t2=0:0.1:15;
c0=c(1);
c2=((n-1).*k.*t2+c0^(1-n)).^(1/(1-n));
plot(t2,c2);


















