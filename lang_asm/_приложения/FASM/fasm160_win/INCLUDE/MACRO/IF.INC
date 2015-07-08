
; macroinstructions for HLL-style conditional operations

macro .if v1,c,v2
{
  __IF equ
  local ..endif
  __ENDIF equ ..endif
  local ..else
  __ELSE equ ..else
  if v2 eq & c eq
   cmp v1,0
   je __ELSE
  else
   cmp v1,v2
   jn#c __ELSE
  end if
}

macro .else
{
  jmp __ENDIF
  __ELSE:
  restore __IF
  __IF equ ,
}

macro .elseif v1,c,v2
{
  local ..else
  jmp __ENDIF
  __ELSE:
  restore __ELSE
  __ELSE equ ..else
  if v2 eq & c eq
   cmp v1,0
   je __ELSE
  else
   cmp v1,v2
   jn#c __ELSE
  end if
}

macro .endif
{
  if __IF eq
   __ELSE:
  end if
  __ENDIF:
  restore __ELSE
  restore __ENDIF
  restore __IF
}

macro .while v1,c,v2
{
  local ..while
  __WHILE equ ..while
  local ..endw
  __ENDW equ ..endw
  __WHILE:
  if v2 eq & c eq
   cmp v1,0
   je __ENDW
  else
   cmp v1,v2
   jn#c __ENDW
  end if
}

macro .endw
{
  jmp __WHILE
  __ENDW:
  restore __ENDW
  restore __WHILE
}

macro .repeat
{
  local ..repeat
  __REPEAT equ ..repeat
  __REPEAT:
}

macro .until v1,c,v2
{
  if v2 eq & c eq
   cmp v1,0
   je __REPEAT
  else
   cmp v1,v2
   jn#c __REPEAT
  end if
  restore __REPEAT
}

jnne equ je
jnna equ ja
jnnb equ jb
jnng equ jg
jnnl equ jl
jnnae equ jae
jnnbe equ jbe
jnnge equ jge
jnnle equ jle
