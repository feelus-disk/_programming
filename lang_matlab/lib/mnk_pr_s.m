function [a sa]=mnk_pr_s(x,y,sy)
if(length(x)~=length(y) | length(y)~=length(sy) | length(y)<2)
    error('bad size of x or y or sy');
end;
sxys=sum(x.*y./sy.^2);
sx2s=sum(x.^2./sy.^2);
a=sxys/sx2s;
sa=(1/sx2s)^0.5;

end
