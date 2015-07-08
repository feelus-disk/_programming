@echo off
rem @bcc -1 -IF:\BC\INC -Etasm -c -B -mc -K -O -Z dewin.c 
rem tcc -1 -ID:\TC\INC -c -mc -K -O -Z -S dewin.c 
rem @tlink /x f:\bc\lib\c0c.obj dewin dess_l dess_32, dewin.exe,, f:\bc\lib\cc.lib
rem del dewin.obj

make -fdewin.mak
copy /b dewin.exe c:\dos\tools
