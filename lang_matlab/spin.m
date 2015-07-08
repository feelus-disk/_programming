x=[
    1 0
    0 1
    i 0
    0 i
    -1 0
    0 -1
    -i 0
    0 -i
    1 1
    i i
    -1 -1
    -i -i
    1 -1
    -1 1
    i -i
    -i i
    1 i
    i -1
    -1 -i
    -i 1
    i 1
    -1 i
    -i -1
    1 -i
    ]; 
Sz=[1 0
    0 -1];
Sx=[0 1
    1 0];
Sy=[0 -i
    i 0];
x=x.';
%x(:,1)
S_x=[];
S_y=[];
S_z=[];
Sx2=[];
Sy2=[];
Sz2=[];
dSx=[];
dSy=[];
dSz=[];
tabl=[];
for ii=[1 length(x)]
    xx=x(ii);
    xx=xx./(abs(xx(1,1))^2+abs(xx(2,1))^2);
    S_xv=xx'*Sx*xx;
    S_yv=xx'*Sy*xx;
    S_zv=xx'*Sz*xx;
    Sx2v=xx'*Sx*Sx*xx;
    Sy2v=xx'*Sy*Sy*xx;
    Sz2v=xx'*Sz*Sz*xx;
    dSx=Sx2v-S_xv.^2;
    dSy=Sy2v-S_yv.^2;
    dSz=Sz2v-S_zv.^2;
    disp([xx(1) xx(2) S_xv S_yv S_zv dSx dSy dSz])
%    tabl=[tabl; [xx.' S_xv S_yv S_zv dSx dSy dSz]];
end;
disp(tabl)    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    