function func

global R L C
global w0 alpha wc

C=1e-6;
L=5;

ww=[];

R=100:50:500;

w0=(L.*C).^(-0.5);
alpha=R./(2*L);
wc=(w0.^2-alpha.^2).^0.5;

hold on;

for i=1:length(R)

    data=[R(i) alpha(i) wc(i) ];
    
    w=400:0.1:500;
    Rw=(w.*L-(w.*C).^(-1)).^2 + R(i).^2;
    plot(w,Rw);

    %2*R.*ones(1,length(w));
    %plot(w, abs(Rw-2*R.^2.*ones(1,length(w))));
    disp(w(minimums(abs(Rw-2*R(i).^2.*ones(1,length(w))))));
    disp([(w0.^2+alpha(i).^2).^0.5-alpha(i) , (w0.^2+alpha(i).^2).^0.5+alpha(i)] );
    disp('----');
    

    ww=[ww; data];
end

end

function ret=minimums(mas)

ret=[];
for i = 2 : length(mas)-1
    if mas(i-1)>mas(i) & mas(i)<mas(i+1)
        ret=[ret,i];
    end
end

end

