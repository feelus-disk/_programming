; DLLENTRY.ASM
;
; Entry code for example Windows dynamic link library.  When Windows first
; loads the DLL, control comes here first.
;
; This module generates a code segment called INIT_TEXT.  It calls the API
; function LocalInit to initialize the local heap (if one exists), then calls 
; the API function UnlockSegment to unlock the heap segment.  (The call to
; to UnlockSegment is not necessary in protected mode.)  If successful,
; DLLEntry calls the DLL's data initialization routine, prototyped like this:
;
;                       BOOL FAR PASCAL LibMain( void );
;
; DLLEntry returns the result of all this to Windows:  TRUE if successful,
; FALSE otherwise.  Note DLLEntry differs from LibEntry of the Windows SDK in
; that it does not pass arguements to LibMain.
;
; Refer to Chapter 11 of the Programmer's Guide for further information.

.MODEL  small, pascal, farstack
.286

INCLUDE WIN.INC

LibMain PROTO FAR PASCAL

.CODE
DLLEntry        PROC FAR PASCAL PUBLIC          ; Entry point for DLL

; On entry, DS = data segment and CX = heap size
		jcxz    @F                      ; If no heap, skip
		INVOKE  LocalInit, ds, 0, cx    ; Else set up the heap
		.IF     ( ax )                  ; If successful,
		INVOKE  UnlockSegment, -1       ;   unlock the data segment
@@:             call    LibMain                 ; Call DLL's data init routine
		mov     ax, TRUE                ; Return AX = TRUE if okay,
		.ENDIF                          ;   else if LocalInit error,
		ret                             ;   return AX = FALSE

DLLEntry        ENDP

END             DLLEntry
