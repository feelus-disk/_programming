%function upr4

%sredn=100;
%happens=1000000;
%kkl=happens/sredn;

%otr=zeros(1,kkl);
%for i=1:happens
%    q=floor(rand*kkl)+1;
%    otr(q)=otr(q)+1;
%end

maxdistr=max(otr)+1;
distr=zeros(1,maxdistr);
for i=1:kkl
    distr(otr(i)+1)=distr(otr(i)+1)+1;
end
%clear otr
scale=(1:maxdistr)-1;
plot(scale,distr)
%export scale distr maxdist
clear happens sredn kkl i q