.model large
.data
 s1 DB "TEST STRING$"
.code
 mov AX, @data
 mov DS, AX
 lea DX, s1
 mov AH, 9h
 int 21h
 mov ax, 4c00h
 int 21h
end
