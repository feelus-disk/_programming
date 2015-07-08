function readPlot(xl,xh,yl,yh)
global hAxes 
global xmas ymas
global xxl xxh yyl yyh
xxl=xl;
yyl=yl;
xxh=xh;
yyh=yh;

xmas=[];
ymas=[];
hFig=figure; 
%{
hAxes=axes('Parent',hFig,'Color',[1 1 1], ... 
'Units','pixels', ... 
'XLimMode','manual', ... 
'YLimMode','manual', ... 
'ZLimMode','manual', ... 
'XLim',[xl xh],'YLim',[yl yh],'ZLim',[0 1], ... 
'ButtonDownFcn','MyButtonDownInAxes'); 
%}
hAxes=axes('Parent',hFig,'ButtonDownFcn','MyButtonDownInAxes');
axis([xl,xh,yl,yh]);
uicontrol(hFig,...
    'Style','pushbutton','Callback','backSpace',...
    'String','backSpace','Position',[0 0 300 35]);
end
