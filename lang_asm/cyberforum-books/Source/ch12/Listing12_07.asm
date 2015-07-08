.data
 a1  DW 21609, -13104, -30011, -9081, 31209, 12056, 21305
 a2  DW 27791, -5959, -3290, 1544,  -4407, -32099, -7901
 len EQU $-a2
 res DW 7 dup (0)
.code
 . . .
 lea   ESI, a1
 lea   EDI, a2
 lea   EBX, res
 . . .
 movq  MM0, qword ptr [ESI]
 movq  MM1, qword ptr [EDI]
 paddsw MM0, MM1
 movq  qword ptr [EBX], MM0
 . . .
