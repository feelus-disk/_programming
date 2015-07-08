
; extended Win32 programming headers with parameters count checking (ASCII)

format PE GUI 4.0

addr equ
ADDR equ
invoke equ

macro allow_nesting
{ macro pushd arg
  _%
     if arg eq
     else if  _##arg  eq _invoke arg
      arg
     else
      pushd arg
     end if %_
  macro invoke proc,[arg]
  _% _common_
      allow_nesting
      _local_ ..count
      ..count = 0
      if ~ arg eq
     _forward_ ..count = ..count + 1
     _common_
      end if
      if defined proc##%
       if ..count <> proc##%
	invalid_count proc
       end if
      end if
     _reverse_ pushd <arg>
     _common_ call [proc]
	      push eax
	      purge pushd
	      purge invoke %_ }

include 'win32w.inc'

macro pushd first,[more]
{ common local ..continue,..opcode,..address
  if ~ more eq
   call ..continue
   du first,more,0
   ..continue:
  else if _ # first in <_addr first,_ADDR first>
   virtual at 0
    label ..address at first
    mov eax,dword [..address]
    load ..opcode from 0
   end virtual
   if ..opcode = 0A1h
    push first
   else
    lea edx,[..address]
    push edx
   end if
  else if first eqtype ''
   call ..continue
   du first,0
   ..continue:
  else
   push first
  end if }

allow_nesting

macro invoke proc,[arg]
{ common local ..count
   ..count = 0
   if ~ arg eq
  forward ..count = ..count + 1
  common
   end if
   if defined proc#%
    if ..count <> proc#%
     invalid_count proc
    end if
   end if
  reverse pushd <arg>
  common call [proc] }

macro invalid_count proc
 { display "Error: invalid count of parameters for ",`proc,".",0Dh,0Ah
   local halt
   halt }

include 'macro/if.inc'

include 'pcount/kernel32.inc'
include 'pcount/user32.inc'
include 'pcount/gdi32.inc'
include 'pcount/advapi32.inc'
include 'pcount/comctl32.inc'
include 'pcount/comdlg32.inc'
include 'pcount/shell32.inc'
include 'pcount/wsock32.inc'

macro import lib,[functions]
 { common macro import_#lib _@ import lib,functions @_ }

_@ fix {
@_ fix }

include 'apiw/kernel32.inc'
include 'apiw/user32.inc'
include 'apiw/gdi32.inc'
include 'apiw/advapi32.inc'
include 'apiw/comctl32.inc'
include 'apiw/comdlg32.inc'
include 'apiw/shell32.inc'
include 'apiw/wsock32.inc'

purge import

macro .data { section '.data' data readable writeable }

macro .code { section '.text' code readable executable }

macro .end label
 {
   entry label

   section '.idata' import data readable writeable

     library kernel32,'KERNEL32.DLL',\
	     user32,'USER32.DLL',\
	     gdi32,'GDI32.DLL',\
	     advapi32,'ADVAPI32.DLL',\
	     comctl32,'COMCTL32.DLL',\
	     comdlg32,'COMDLG32.DLL',\
	     shell32,'SHELL32.DLL',\
	     wsock32,'WSOCK32.DLL'

     import_kernel32
     import_user32
     import_gdi32
     import_advapi32
     import_comctl32
     import_comdlg32
     import_shell32
     import_wsock32
 }
