clc;

s=[
    0.01
    0.002
    0.001
    0.0005
    0.00033
];
w=[
    1.17
    0.99
    0.79
    0.62
    0.5
];
w=w.*(10^(6));
ww=1./w;
ss=1./s;
ws=w./s;
disp('w');
disp(w);
disp('s');
disp(s);
disp('1/w');
disp(ww);
disp('1/s');
disp(ss);
disp('w/s');
disp(ws);


%plot(ss,ww,'.-');
[k sk a sa]=mnk_lin(ss,ww);
disp(k);
disp(a);
disp(k/a);
disp(1/a)
%plot(ws,w,'.-');
wmax1=1/a;
km1=k/a;
[k sk a sa]=mnk_lin(ws,w);
disp(k)
disp(a)
wmax2=a;
km2=-k;

st=0:0.0001:0.011;
wt1=st.*wmax1./(st+km1);
wt2=st.*wmax2./(st+km2);
hold on;
plot(s,w,'.');
plot(st,wt1,'r');
plot(st,wt2,'g');
