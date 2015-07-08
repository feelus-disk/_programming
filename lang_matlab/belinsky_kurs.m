%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%матлаб - говно, хотябы потому, что здесь нет меток и оператора goto
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%(c)FeelUs

function brlinsky_kurs;
disp('----------------------------------');%поехали
hold on;%разрешить рисовать много графиков на одном
grid on;%показать координатную сетку

%{
%поиск стационарных состояний из разных точек
for re=-400:100:400
    for im=-400:100:400
        paint(re+im*1i);
    end;
end;
%}
paint(1+1i);

%{
%2-х стационарное состояние
%bl=0.002
[z,ap,a]=integrate(1,0,1000,780);
plot3(z,real(a),imag(a));
plot3(z,real(ap),imag(ap),'r');
[z,ap,a]=integrate(1,0,1000,540);
plot3(z,real(a),imag(a));
plot3(z,real(ap),imag(ap),'r');
%}

%{
%вывод графиков из разных точек
for re=-400:100:400
    for im=-400:100:400
        [z,ap,a]=integrate(1,0,1000,re+im*1i);
        plot3(z,real(a),imag(a));
    end;
end;
view([90 0]);
%}
%([угол по горизонтали, угол по вертикали])
hold off;
end%of function

%по стартовой позиции ищет стационарное состояние
%выводит путь при z==0 к этому состоянию
%ну и само это состояние
%а также красным - амплитуду накачки
function paint(Astart);
%физические константы задачи
R=0.95;%0.7*exp(0.8i);    %0.36844;%
ApStart=1000;
%параметры попадания в стационарное
maloe=0.001;
numSovp=100;
%т.е. вокруг стационарной точки в радиусе maloe
%должно последовательно оказаться NumSovp точек
%----------------------------
i=1;
A(i)=Astart;
z(i)=0;%просто для графика
i=i+1;
count=1;
flag=1;
while(i<100000 & flag)
    [zz,Ap,AA]=integrate(0,0,ApStart,A(end));%end==i-1
    %получили конечную точку AA из начальной (для данной итерации) A(end)
    A(i)=AA*R;
    z(i)=0;
    i=i+1;
    %проверяем попадание в стационарное
    if(abs(A(end)-A(end-count))<maloe)
        if(count==numSovp)
            flag=0;
        else
            count=count+1;
        end;
    else
        if(count>1)
            count=1;
        end;
    end;
end;
%если попали в стационарное, то flag==0
%иначе прошлись 10000 точек и не попали и флаг==1
disp(i);%выводим число итераций
%, потребовавшихся для попадания в стационарное состояние

plot3(z,real(A),imag(A),'.-');
%нарисовали путь к стационарному
if(~flag)
    [z,Ap,A]=integrate(1,0,ApStart,A(end));
    %получили массив стационарного состояния
    plot3(z,real(A),imag(A));
    %нарисовали A
    plot3(z,real(Ap),imag(Ap),'r');
    %нарисовали Ap
    disp('A(0)');
    disp(A(1));
    disp('A(1)');
    disp(A(end));
    disp('Ap(0)');
    disp(Ap(1));
    disp('Ap(1)');
    disp(Ap(end));
else
    disp('не попали');
end;

end%of function


%берет начальную точку
%если флаг!=0, возвращает массив для графика
%иначе возвращает только конечную точку
function [z,Ap,A]=integrate(flag,zStart,ApStart,Astart);
%разбиение z
dz=0.002;%разбиение при интегрировании
lengthz=0.99999;%понятно по имени
numz=lengthz/dz;%число точек интегрирования
NumPaintPoint=100;%число точек, выводимых на графике для одной линии
PaintNum=fix(numz/NumPaintPoint);%fix - целая часть числа
if(PaintNum==0)
    PaintNum=1;
end;
%константы уравнения%
bl=0.000052;
bpl=bl;%0.001;
%----------------------
if(flag)
    %записываем в массив начальную точку
    countmas=1;
    z(countmas)=zStart;
    Ap(countmas)=ApStart;
    A(countmas)=Astart;
    %инициализируем текущие (cur)
    zcur=0;
    Apcur=ApStart;
    Acur=Astart;
    for i=1:numz
        dA= dz* bl*Apcur*conj(Acur) ;%conj - комплексное сопряжение
        dAp=dz* (-bpl)*Acur^2;
        Acur=Acur+dA;
        Apcur=Apcur+dAp;
            %disp(Acur);
        zcur=zcur+dz;%в данном ур-е нужна только для графиков
        if(mod(i,PaintNum)==0)    %mod - остаток от деления i/PaintNum
            %то записываем в массив
            countmas=countmas+1;
            z(countmas)=zcur;
            Ap(countmas)=Apcur;
            A(countmas)=Acur;
        end;
    end;
    %последнюю точку тоже записываем
    countmas=countmas+1;
    z(countmas)=zcur;
    Ap(countmas)=Apcur;
    A(countmas)=Acur;
else
    %инициализируем текущие (cur)
    zcur=0;
    Apcur=ApStart;
    Acur=Astart;
    for i=1:numz
        dA= dz* bl*Apcur*conj(Acur) ;%conj - комплексное сопряжение
        dAp=dz* (-bpl)*Acur^2;
        Acur=Acur+dA;
        Apcur=Apcur+dAp;
    end;
    %последнюю точку все же записываем
    z=dz*numz;
    Ap=Apcur;
    A=Acur;
end;    
end%of function
