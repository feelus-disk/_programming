
; Win32 programming headers (WIDE)

include 'macro/stdcall.inc'
include 'macro/cdecl.inc'
include 'macro/com.inc'
include 'macro/import.inc'
include 'macro/export.inc'
include 'macro/resource.inc'
include 'macro/struct.inc'
include 'macro/fixes.inc'

struc CHAR count { rw count }

include 'equates/kernel32.inc'
include 'equates/user32.inc'
include 'equates/gdi32.inc'
include 'equates/comctl32.inc'
include 'equates/comdlg32.inc'
include 'equates/shell32.inc'
include 'equates/wsock32.inc'
