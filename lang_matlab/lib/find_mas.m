function p=find_mas(mas,x)
%int find_mas([float] mas, float x)
%в отсортированном одномерном массиве
%ищет позицию х или куда его можно вставить
%чтобы массив остался отсортированным
%required obr_mas()
if(x<mas(1))
    p=0;
else
for p=obr_mas(1:length(mas))
    if(mas(p)<=x)
        break;
    end;
end;
end;
end