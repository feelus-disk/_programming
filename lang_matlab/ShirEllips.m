function rez=ShirEllips(a,b,pov);
gtr=pi/180;
ugt=(0:360).*gtr;
[h w]=(size(pov));
for i=1:w
r=ellips(ugt,a,b,pov(i));
pr=r.*cos(ugt);
rez(i)=max(pr);
end;
end