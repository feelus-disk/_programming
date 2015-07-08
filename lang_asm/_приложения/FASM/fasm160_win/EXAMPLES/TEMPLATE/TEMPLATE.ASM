
; Template for program using standard Win32 headers

format PE GUI 4.0
entry start

include 'win32a.inc'

section '.data' data readable writeable

  _title db 'Win32 program template',0
  _class db 'FASMWIN32',0

  mainhwnd dd ?
  hinstance dd ?

  msg MSG
  wc WNDCLASS

section '.code' code readable executable

  start:

	invoke	GetModuleHandle,0
	mov	[hinstance],eax
	invoke	LoadIcon,0,IDI_APPLICATION
	mov	[wc.hIcon],eax
	invoke	LoadCursor,0,IDC_ARROW
	mov	[wc.hCursor],eax
	mov	[wc.style],0
	mov	[wc.lpfnWndProc],WindowProc
	mov	[wc.cbClsExtra],0
	mov	[wc.cbWndExtra],0
	mov	eax,[hinstance]
	mov	[wc.hInstance],eax
	mov	[wc.hbrBackground],COLOR_BTNFACE+1
	mov	[wc.lpszMenuName],0
	mov	[wc.lpszClassName],_class
	invoke	RegisterClass,wc

	invoke	CreateWindowEx,0,_class,_title,WS_VISIBLE+WS_DLGFRAME+WS_SYSMENU,128,128,192,192,NULL,NULL,[hinstance],NULL
	mov	[mainhwnd],eax

  msg_loop:
	invoke	GetMessage,msg,NULL,0,0
	or	eax,eax
	jz	end_loop
	invoke	TranslateMessage,msg
	invoke	DispatchMessage,msg
	jmp	msg_loop

  end_loop:
	invoke	ExitProcess,[msg.wParam]

proc WindowProc, hwnd,wmsg,wparam,lparam
	push	ebx esi edi
	cmp	[wmsg],WM_DESTROY
	je	wmdestroy
  defwndproc:
	invoke	DefWindowProc,[hwnd],[wmsg],[wparam],[lparam]
	jmp	finish
  wmdestroy:
	invoke	PostQuitMessage,0
	xor	eax,eax
  finish:
	pop	edi esi ebx
	return
endp

section '.idata' import data readable writeable

  library kernel32,'KERNEL32.DLL',\
	  user32,'USER32.DLL'

  include 'apia\kernel32.inc'
  include 'apia\user32.inc'
