function rez=square32(x1,y1,x2,y2,x3,y3)
v1x=x2-x1;
v1y=y2-y1;
v2x=x3-x1;
v2y=y3-y1;
rez=det([v1x v1y; v2x v2y]);
rez=abs(rez/2);
end
