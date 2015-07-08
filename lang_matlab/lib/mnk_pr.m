function [a sa]=mnk_pr(x,y)
%[a sa]=mnk_pr(x,y)
%y=ax
%see also my_lib_help
if(length(x)~=length(y) | length(y)<2)
    error('bad size of x or y');
end;
sxy=sum(x.*y);
sx2=sum(x.^2);
sy2=sum(y.^2);
a=sxy/sx2;
sa=((sx2*sy2-sxy^2)/(length(y)-1)/sx2^2)^0.5;

end
