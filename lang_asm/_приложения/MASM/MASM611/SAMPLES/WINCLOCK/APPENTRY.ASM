;-----------------------------------------------------------------------------;
; APPENTRY.ASM :Windows Application Startup Routine
;-----------------------------------------------------------------------------;
; From Microsoft Windows Software Developers Kit (c) Microsoft
; Chapter 22: Windows Application Startup
;-----------------------------------------------------------------------------;
;
; To create a Windows application, the WinMain function has to be called
; by some startup code contained in the executable file. This startup code is 
; in the APPENTRY.ASM file. Since INVOKE directives depend on the memory model
; in use, APPENTRY.ASM expects MODEL to be set with the memory model of
; the application. APPENTRY.OBJ is then created from APPENTRY.ASM.
;
; for example:    ml -c -DMODEL=small appentry.asm
; 
; In the link line, APPENTRY.OBJ has to be the first file in the chain,
; because the first 16 bytes of data in the DATA segment are reserved by 
; Windows. A run file name has to be specified to the linker, otherwise
; the linker will create an APPENTRY.EXE executable.
;
; for example:	link  appentry+winapp,winapp.exe,,libw,winapp
;
; For PWB, this amounts to selecting APPENTRY.ASM as the first entry in the
; list (put APPENTRY.ASM at the Top of List)
; Since MODEL is required, an IFNDEF handles the case in which it isn't
; defined, outputting an error and avoiding assembly of the rest.
;
;-----------------------------------------------------------------------------;


IFNDEF MODEL
	.ERR <MODEL hasn't been defined>
	EXTERNDEF  __astart:PROC
ELSE
	.model MODEL, pascal            ; set model to MODEL, language
					; to pascal (as required by Windows)
					; MODEL should be defined in ML
					; command line

; Numeric Equates

STACKSLOP = 256                         ; amount of stack slop space required
maxRsrvPtrs = 5                         ; number of Windows reserved pointers

; External/Public definitions

EXTERNDEF       rsrvptrs:WORD           ; pointers to Windows reserved pointers
PUBLIC          __astart                ; application startup routine

; Type definitions for functions used. 
; Faster and more efficient than including 'windows.inc'

UINT            TYPEDEF WORD
HINSTANCE       TYPEDEF UINT
HTASK           TYPEDEF UINT
LPSTR           TYPEDEF FAR PTR BYTE


; Prototypes for functions used

Dos3Call        PROTO FAR PASCAL
InitApp         PROTO FAR PASCAL,       :HTASK
WaitEvent       PROTO FAR PASCAL,       :HINSTANCE
InitTask        PROTO FAR PASCAL
WinMain         PROTO NEAR PASCAL,      :HINSTANCE, :HINSTANCE, :LPSTR, :UINT

	.data

	 DWORD  0                       ; Windows reserved data space.
rsrvptrs WORD   maxRsrvPtrs             ; 16 bytes at the top of the DATA seg.
	 WORD   maxRsrvPtrs DUP (0)     ; Do not alter

hPrev    WORD    0                      ; space to save WinMain parameters
hInst    WORD    0
lpszCmd  DWORD   0
cmdShow  WORD    0

	.code

__astart:
	xor bp,bp                       ; zero bp
	push bp
	INVOKE InitTask                 ; Initialize the stack
	or ax,ax
	jz noinit
	add cx,STACKSLOP                ; Add in stack slop space.
	jc noinit                       ; If overflow, return error.
	mov hPrev,si
	mov hInst,di
	mov word ptr lpszCmd,bx
	mov word ptr lpszCmd+2,es
	mov cmdShow,dx
	xor ax,ax                       ; Clear initial event that
	INVOKE WaitEvent, ax            ;   started this task.
	INVOKE InitApp, hInst           ; Initialize the queue.
	or ax,ax
	jz noinit

	INVOKE WinMain, hInst,hPrev,lpszCmd,cmdShow
ix:
	mov ah,4Ch
	INVOKE Dos3Call                 ; Exit with return code from app.
noinit:
	mov al,0FFh                     ; Exit with error code.
	jmp short ix
	
ENDIF                                   ; End of IFNDEF MODEL

	end __astart                    ; start address
