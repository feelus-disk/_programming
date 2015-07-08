function go
global stopvar
stopvar=0;
count =0;
while (stopvar==0 & count<100)
    count=count+1;
    disp(count);
    pause(0.5);
end;
end