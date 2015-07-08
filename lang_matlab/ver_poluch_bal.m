function temp
%{
v - вероятность
z - сколько решил сам правильно
o - сколько ответил правильно
%}
z=0:18;
o=0:18;
[Z,O]=meshgrid(z,o);
for i=1:length(z)
    for j=1:length(o)
        if(j+Z(j,i)<=length(o))
            v(j+Z(j,i),i)=ver(O(j,i),18-Z(j,i));
        end;
    end;
end;
hold on;
plot3(Z,O,v);
%plot3(Z',O',v');
%plot(z,v(12,:));
end

function v=ver(a,b)
if(a>b)
    v=0;
else
    v=(0.25.^a).*(0.75.^(b-a)).*(factorial(b)./(factorial(a))./(factorial(b-a)));
end;
end