function rez=summas(m)
%float summas([float])
%суммирует все элементы трехмерного массива
[a,b,c]=size(m);
rez=0;
for i=1:a
    for j=1:b
        for k=1:c
            rez=rez+m(i,j,k);
        end;
    end;
end;
end