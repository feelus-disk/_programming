PUSH CS
;регистр данных совпадает с регистром кода
POP DS		
MOV DX,OFFSET MSG
MOV AH,9
;вывод текстовой строки MSG
INT 21H		
MOV AX,4C01H
;выход из программы с кодом 1
INT 21H		
MSG DB ? This program cannot be run in DOS mode $?
