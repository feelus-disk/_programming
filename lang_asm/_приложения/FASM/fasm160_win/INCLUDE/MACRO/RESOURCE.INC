
; macroinstructions for making resource section

macro directory [type,label]
 { common
    resource_count = 0
    resource_max = 0
   forward
    resource_count = resource_count + 1
    if type > resource_max
    resource_max = type
    end if
   common
    resource_root dd 0,%t,0,resource_count shl 16
    repeat resource_max
   forward
    if % = type
    dd type,80000000h+label-resource_root
    end if
   common
    end repeat }

macro resource dir,[id,lang,label]
 { common
    dir:
   forward
    resource_min = id
    resource_max = id
   common
    resource_count = 0
   forward
    local resource_label
    resource_count = resource_count + 1
    if id < resource_min
    resource_min = id
    else if id > resource_max
    resource_max = id
    end if
   common
    dd 0,%t,0,resource_count shl 16
    repeat resource_max-resource_min+1
   forward
    if resource_min+%-1 = id
    dd id,80000000h+resource_label-resource_root
    end if
   common
    end repeat
   forward
    label#.resid = id
    resource_label dd 0,%t,0,10000h,lang,label-resource_root }

macro bitmap label,bitmap_file
 { local data,size
   label dd RVA data,size,0,0
   data file bitmap_file:0Eh
   size = $ - data
   align 4 }

macro icon group,[label,icon_file]
 { common local count
    count = 0
   forward local data,size,position
    label dd RVA data,size,0,0
    virtual at 0
     file icon_file:6,16
     load size dword from 8
     load position dword from 12
    end virtual
    data file icon_file:position,size
    count = count+1
   common local header
    align 4
    group dd RVA header,6+count*14,0,0
    header dw 0,1,count
   forward
    file icon_file:6,12
    dw label#.resid
   common
    align 4 }

macro fileres label,file_name
{ local data,size
  label dd RVA data,size,0,0
  data = $
  file file_name
  size = $ - data
  align 4 }

macro menu label
 { local data,size
   label dd RVA data,size,0,0
   data dw 1,4,0,0
   menu_size equ size = $ - data
   menu_level = 1 }

macro menuitem string,id,resinfo,type,status
 { dd type+MFT_STRING,status+0,id
   dw resinfo
   du string,0
   align 4
   if resinfo and MFR_END <> 0
   menu_level = menu_level - 1
   end if
   if resinfo and MFR_POPUP <> 0
   menu_level = menu_level + 1
   dd 0
   end if
   if menu_level = 0
   menu_size
   end if }

macro menuseparator resinfo,status
 { dd MFT_SEPARATOR,status+0,0
   dw resinfo+0,0
   if resinfo+0 and MFR_END <> 0
   menu_level = menu_level - 1
   end if
   if menu_level = 0
   menu_size
   end if }

macro dialog label,title,x,y,cx,cy,style,menu,exstyle,fontname,fontsize
 { local data,size,items
   label dd RVA data,size,0,0
   data dd style or DS_SETFONT,exstyle +0
   dw items,x,y,cx,cy
   if menu+0 <> 0
   dw 0FFFFh
   end if
   du menu+0,0,title,0
   if fontname eq
   du 8,'MS Sans Serif',0
   else
   du fontsize+0,fontname,0
   end if
   align 4
   dialog_size equ size = $ - data
   dialog_items equ items = dialog_items_counter
   dialog_items_counter = 0
 }

macro dialogitem class,title,id,x,y,cx,cy,style,exstyle
 { dd style or WS_CHILD,exstyle +0
   dw x,y,cx,cy,id
   if class eq 'BUTTON'
   dw 0FFFFh,80h
   else if class eq 'EDIT'
   dw 0FFFFh,81h
   else if class eq 'STATIC'
   dw 0FFFFh,82h
   else if class eq 'LISTBOX'
   dw 0FFFFh,83h
   else if class eq 'SCROLLBAR'
   dw 0FFFFh,84h
   else if class eq 'COMBOBOX'
   dw 0FFFFh,85h
   else
   du class,0
   end if
   if title eqtype 0
   dw 0FFFFh,title
   else
   du title,0
   end if
   dw 0
   align 4
   dialog_items_counter = dialog_items_counter + 1 }

macro enddialog
 { dialog_items
   dialog_size }

macro accelerator label,[fvirt,key,cmd]
 { common
    local data,size
    label dd RVA data,size,0,0
    data:
    accel_count = 0
   forward
    accel_count = accel_count + 1
   common
    size = accel_count * 8
   forward
    accel_count = accel_count - 1
    if accel_count = 0
    dw fvirt or 80h,key
    else
    dw fvirt,key
    end if
    dd cmd }

macro version label,fileos,filetype,filesubtype,lang,cp,[name,value]
 { common
    local data,size,vivalue,visize
    label dd RVA data,size,0,0
    data dw size,visize,0
    du 'VS_VERSION_INFO',0,0
    vivalue dd 0FEEF04BDh,00010000h
    local version,shift,char,filever,productver
    filever = 0
    productver = 0
   forward
    if name eq 'FileVersion' | name eq 'ProductVersion'
     virtual at 0
      db value
      count = $
     end virtual
     version = 0
     shift = 16
     repeat count
      virtual at 0
       db value
       load char from %-1
      end virtual
      if char='.'
       if shift mod 32 <> 0
        shift = shift-16
       else
        shift = shift+32+16
       end if
      else
       version = (version and not (0FFFFh shl shift)) or ((version shr shift and 0FFFFh)*10+char-'0') shl shift
      end if
     end repeat
     if name eq 'FileVersion'
      filever = version
     else if name eq 'ProductVersion'
      productver = version
     end if
    end if
   common
    dq filever,productver
    dd 0,0,fileos,filetype+0,filesubtype+0,0,0
    visize = $ - vivalue
    local sfi_data,sfi_size
    sfi_data dd sfi_size
    du 1,'StringFileInfo',0
    local str_data,str_size
    str_data dd str_size
    du 1,'040904E4',0
   forward
    local vs_data,vs_size,value_data,value_size
    align 4
    vs_data dw vs_size,value_size/2
    du 1,name,0
    align 4
    value_data du value,0
    value_size = $ - value_data
    vs_size = $ - vs_data
   common
    align 4
    str_size = $ - str_data
    sfi_size = $ - sfi_data
    local vfi_data,vfi_size,var_data,var_size
    vfi_data dd vfi_size
    du 1,'VarFileInfo',0,0
    var_data dw var_size,4
    du 0,'Translation',0,0
    dw lang,cp+0
    var_size = $ - var_data
    vfi_size = $ - vfi_data
    size = $ - data }
