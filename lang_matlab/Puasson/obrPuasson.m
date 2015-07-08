%function doupr4
disp('-----------')
sredn=0;
summ=0;
for val=1:maxdistr
    sredn=sredn+scale(val)*distr(val);
    summ=summ+distr(val);
end;
disp('sredn:')
sredn=sredn/summ

D=0;
summ=0;
for val=1:maxdistr
    D=D+distr(val)*(scale(val)-sredn)^2;
    summ=summ+distr(val);
end
%summ
disp('D; cigma')
D=D/summ
c=sqrt(D)
mainsum=summ;

sum=0;
for val=round(sredn-c):round(sredn+c)
    sum=sum+distr(val);%*scale(val);
end
disp('one cigma')
%sum
sum/mainsum

sum=0;
for val=round(sredn-2*c):round(sredn+2*c)
    sum=sum+distr(val);%*scale(val);
end
disp('two cigma')
%sum
sum/mainsum

sum=0;
for val=round(sredn-3*c):round(sredn+3*c)
    sum=sum+distr(val);%*scale(val);
end
disp('three cigma')
sum/mainsum

