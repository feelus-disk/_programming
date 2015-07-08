; def32.inc
; файл с определениями констант и типов для примеров под win32

; из winbase.h
STD_OUTPUT_HANDLE		equ	-11
OPEN_EXISTING	equ	3
CREATE_ALWAYS	equ	2
GMEM_MOVEABLE	equ	2
GMEM_ZEROINIT	equ	40h

; из windef.h
RECT	struc
	left	dd	?
	top	dd	?
	right	dd	?
	bottom	dd	?
RECT	ends

; из winerror.h
NO_ERROR			equ	0
ERROR_NO_MORE_ITEMS		equ	259

; из winnetwk.h
RESOURCEUSAGE_CONNECTABLE	equ 1
RESOURCETYPE_ANY		equ	0
RESOURCE_CONNECTED		equ	1
NTRESOURCE struc
	dwScope		dd	?
	dwType		dd	?
	dwDisplayType	dd	?
	dwUsage		dd	?
	lpLocalName	dd	?
	lpRemoteName	dd	?
	lpComment	dd	?
	lpProvider	dd	?
NTRESOURCE ends

; из winnt.h
GENERIC_READ		equ	80000000h
GENERIC_WRITE		equ	40000000h
FILE_SHARE_READ		equ	1
FILE_SHARE_WRITE	equ	2
FILE_ATTRIBUTE_ARCHIVE	equ	20h


; из winuser.h
MB_OK			equ	0
MB_ICONINFORMATION	equ	40h
IDC_ARROW		equ	32512
IDI_APPLICATION		equ	32512
WS_OVERLAPPEDWINDOW 	equ	0CF0000h
WM_DESTROY		equ	2
WM_COMMAND		equ	111h
WM_INITDIALOG	equ	110h
WM_CLOSE	equ	10h
CS_HREDRAW		equ	2
CS_VREDRAW		equ	1
CW_USEDEFAULT		equ	80000000h
SW_SHOWNORMAL		equ	1
COLOR_WINDOW		equ	5
BN_CLICKED	equ	0
WNDCLASSEX	struc
	cbSize		dd	?
	style		dd	?
	lpfnWndProc	dd	?
	cbClsExtra	dd	?
	cbWndExtra	dd	?
	hInstance	dd	?
	hIcon		dd	?
	hCursor		dd	?
	hbrBackground	dd	?
	lpszMenuName	dd	?
	lpszClassName	dd	?
	hIconSm		dd	?
WNDCLASSEX	ends
MSG	struc
	hwnd	dd	?
	message	dd	?
	wParam	dd	?
	lParam	dd	?
	time	dd	?
	pt	dd	?
MSG	ends




; из winuser.h
WM_CREATE	equ	1
WM_ACTIVATE	equ	6
WM_SETTEXT	equ	0Ch
WM_GETTEXT	equ	0Dh
WM_CUT		equ	300h
WM_COPY		equ	301h
WM_PASTE	equ	302h
WM_CLEAR	equ	303h
WM_UNDO		equ	304h
WM_SIZE		equ	5
WS_VISIBLE	equ	10000000h
WS_CHILD	equ	40000000h
WS_EX_CLIENTEDGE equ	200h
ES_LEFT		equ	0
ES_MULTILINE	equ	4
ES_AUTOHSCROLL	equ	80h
ES_AUTOVSCROLL	equ	40h
EM_GETHANDLE	equ	0BDh
EM_GETMODIFY	equ	0B8h
EM_SETMODIFY	equ	0B9h
EM_UNDO		equ	0C7h
EM_SETSEL	equ	0B1h
MB_YESNO	equ	4
MB_ICONWARNING	equ	30h
IDOK		equ	1
IDYES		equ	6


; из commdlg.h
OFN_PATHMUSTEXIST	equ	800h
OFN_FILEMUSTEXIST	equ	1000h
OFN_EXPLORER		equ	80000h
OFN_OVERWRITEPROMPT	equ	2
OPENFILENAME		struc
	lStructSize	dd	?
	hwndOwner	dd	?
	_hInstance	dd	?
	lpstrFilter	dd	?
	lpstrCustomFilter dd	?
	nMaxCustFilter	dd	?
	nFilterIndex	dd	?
	lpstrFile	dd	?
	nMaxFile	dd	?
	lpstrFileTitle	dd	?
	nMaxFileTitle	dd	?
	lpstrInitialDir	dd	?
	lpstrTitle	dd	?
	Flags		dd	?
	nFileOffset	dw	?
	nFileExtension	dw	?
	lpstrDefExt	dd	?
	lCustData	dd	?
	lpfnHook	dd	?
	lpTemplateName	dd	?
OPENFILENAME		ends



