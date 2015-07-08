
; macroinstructions for defining and invoking stdcall HLL procedures

macro proc name,[arg]			; define procedure
 { common
    if used name
    name:
    all@args fix arg
    virtual at ebp+8
    if ~ arg eq
   reverse
    first@args fix arg
   forward
     local ..arg
     ..arg dd ?
     arg equ ..arg
   common
     end if
     ..ret = $ - (ebp+8)
    end virtual
    local ..data,..size
    if defined ..size
     virtual at ebp - ..size
    else
     if ..ret
      push ebp
      mov ebp,esp
     end if
    end if
     ..data:
    macro enter size,level
     _% if size eq & level eq
	 rb (4 - ($-..data) and 11b) and 11b
	 if defined ..size
	  ..size = $ - ..data
	  end virtual
	 else
	  ..size = $ - ..data
	 end if
	 if ..ret | defined ..size
	  push ebp
	  mov ebp,esp
	  if ..size
	   sub esp,..size
	  end if
	 end if
	else
	 enter size,level
	end if %_
    macro return
     _% if ..ret | defined ..size
	  leave
	end if
	if ..ret
	 retn ..ret
	else
	 retn
	end if %_ }

macro rstargs [arg]
 { restore arg }

macro endp				; end procedure definition
 { purge return
   purge enter
   macro rstargs#first@args _% %_
   rstargs all@args
   purge rstargs#first@args
   end if }

macro stdcall proc,[arg]		; call procedure
 { reverse
    pushd arg
   common
    call proc }

macro invoke proc,[arg] 		; invoke procedure (indirect)
 { common
    if ~ arg eq
   reverse
     pushd arg
   common
     call [proc]
    else
     call [proc]
    end if }
