function y=obr_mas(x)
%[smth] obr_mas([smth])
%переворачивает одномерный массив задом наперед
l=length(x);
for i=1:floor(l/2)%floor - округляет в меньшую сторону
    temp=x(i);
    x(i)=x(l+1-i);
    x(l+1-i)=temp;
end;
y=x;
end