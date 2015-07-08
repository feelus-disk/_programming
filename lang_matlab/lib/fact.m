function nf=fact(n)
%[int] fact([int])
%вычисляет факториал массива целых чисел


nf=ones(size(n));
n==ones(size(n));
n=max(ones(size(n)),n);

while ~min(n==ones(size(n)))
    nf=nf.*n;
    %ones(size(n))
    %n-ones(size(n))
    n=max(ones(size(n)),n-ones(size(n)));
    %[0 0 0]
end;
%{
for i=1:n
    nf=nf.*i;
end;
%}
end