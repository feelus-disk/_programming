hold on;
grid on;
dz=0.001;

R=0.7*exp(0.8i);
    %0.36844;%
bl=0.001;
bpl=0.001;
Ap0=1000;
A(1)=250+600i;
disp('----------------------------------');
for main_i=1:10
    if main_i~=1
        A(1)=A(end)*R;
        %disp(A(1));
    end;
    Ap(1)=Ap0;
        
    len=1/dz;
    z(1)=0;
    for i=2:len
        dA=bl*Ap(i-1)*conj(A(i-1))  *dz;%комплексное сопряжение
        dAp=-bpl*A(i-1)*A(i-1)      *dz;
        A(i)=A(i-1)+dA;
        Ap(i)=Ap(i-1)+dAp;
        z(i)=z(i-1)+dz;%для графиков
    end;
    %if mod(main_i,10)==0
        %plot(z,log(abs(A))./log(10));
        %plot(z,angle(A));
        plot3(z,real(A),imag(A))
        %disp(main_i);
    %end;
    %plot(z,abs(A));
    %disp(A(end));
    %disp('---------------');
end;



hold off;