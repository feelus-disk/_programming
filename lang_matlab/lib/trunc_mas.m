function mm=trunc_mas(m,a,b)
%[smth] trunc_mas([smth] mas, int a, int b)
%обрезает одномерный массив, оставляет позиции от a до b
x=right_mas(m,b);
mm=left_mas(x,a);
end
