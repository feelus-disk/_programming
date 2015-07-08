.586
.model flat
 option casemap:none
data1 segment
  src  DB   "Test STRING To Copy"
  len  EQU  $-src
data1  ends
data2  segment public
  dst  DB  len+1 DUP('+')
data2  ends
code segment
_seg_ex proc
 assume CS:FLAT,DS:FLAT, SS:FLAT, ES:FLAT, FS:ERROR, GS:ERROR
 mov    ESI, offset data1
 mov    EDI, offset data2
 cld
 mov    CX, len
 rep    movsb
 mov    EAX, offset data2
 ret
_seg_ex endp
code ends
end
