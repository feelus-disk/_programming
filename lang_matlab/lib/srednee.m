function [sr,c]=srednee(mas);
%[float sr, c] srednee([float])
%вычисляет среднее и стандартное отклонение
%по введенному набору чисел
%(так, как нас учил Митин на первом курсе)
l=length(mas);
sr=0;
for i=1:l
    sr=sr+mas(i);
end;
sr=sr/l;
D=0;
for i=1:l
    D=D+(mas(i)-sr)^2;
end;
D=D/l;
c=D^0.5;
end