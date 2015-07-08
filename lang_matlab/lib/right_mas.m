function mm=right_mas(m,b)
%[smth] right_mas([smth] mas, int b)
%для одномерного масмива
%дописывает нули или обрезает вконце,
%чтобы размер массива стал равен b
if(b>length(m))
    mm=m;
    for i=length(m)+1:b
        mm(i)=0;
    end;
else
    for i=1:b
        mm(i)=m(i);
    end;
end;
end
