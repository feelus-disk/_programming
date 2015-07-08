function mm=left_mas(m,a)
%[smth] left_mas([smth] mas, int a)
%сдвигает массив влево на a
%если a>0 левая часть обрезается
%если a<0 пустая часть будет состоять из нулей
if(a>=1)
    for i=a:length(m)
        mm(i-a+1)=m(i);
    end;
else
    a=1-a;
    for i=1:length(m)
        mm(i+a-1)=m(i);
    end;
end;
end
