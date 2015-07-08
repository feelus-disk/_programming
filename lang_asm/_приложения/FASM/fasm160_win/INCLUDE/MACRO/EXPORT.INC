
; macroinstruction for making export section

macro export dllname,[label,string]
 { common
    local module,addresses,names,ordinal,count
    count = 0
   forward
    count = count+1
   common
    dd 0,0,0,RVA module,1
    dd count,count,RVA addresses,RVA names,RVA ordinal
    addresses:
   forward
    dd RVA label
   common
    names:
   forward
    local name
    dd RVA name
   common
    ordinal: count = 0
   forward
    dw count
    count = count+1
   common
    module db dllname,0
    local maxstrlen,curstr,minstr,str1,str2,v1,v2
    maxstrlen = 0
   forward
    name db string,0
    if $-name > maxstrlen
     maxstrlen = $-name
    end if
   common
    repeat count-1			; sort the list by name strings
     curstr = %-1
     minstr = curstr
     repeat count-%
      load v1 dword from names+minstr*4
      str1=($-RVA $)+v1
      load v2 dword from names+(curstr+%)*4
      str2=($-RVA $)+v2
      cmpstr = 0
      repeat maxstrlen
       if ~ cmpstr
	load v1 from str1+%-1
	load v2 from str2+%-1
	if v1>v2
	 cmpstr = 1
	else if v1<v2
	 cmpstr = -1
	end if
       end if
      end repeat
      if cmpstr = 1
       minstr = curstr+%
      end if
     end repeat
     if minstr <> curstr
      load v1 dword from names+minstr*4
      load v2 dword from names+curstr*4
      store dword v1 at names+curstr*4
      store dword v2 at names+minstr*4
      load v1 word from ordinal+minstr*2
      load v2 word from ordinal+curstr*2
      store word v1 at ordinal+curstr*2
      store word v2 at ordinal+minstr*2
     end if
    end repeat }
