
;               SShell18.asm - �ணࠬ�� � ����� � 18

; (�) ����᪨� �ࠢ� �� 䠩��-�ਫ������ �ਭ������� ����� �����
; "��ᥬ����? �� ����! �稬�� �ணࠬ��஢��� ��� MS-DOS"
; ����: ����譨��� ���� ����ᠭ�஢�� (e-mail: Assembler@Kalashnikoff.ru)
;	 http://www.Kalashnikoff.ru

; --- ��ᥬ���஢���� (����祭�� *.com 䠩��) ---
;�� �ᯮ�짮����� MASM 6.11 - 6.13:
;ML.EXE sshell18.asm /AT

;�� �ᯮ�짮����� TASM:
;TASM.EXE sshell18.asm
;TLINK.EXE sshell18.obj /t/x


.286 ;�㤥� �ᯮ�짮���� ������� "������"
CSEG segment
assume cs:CSEG, ds:CSEG, es:CSEG, ss:CSEG
org 100h

Start:
        jmp Begin

; ======= ��楤��� =========
; ��������
include main.asm

; ����� � ��ᯫ���
include display.asm

; ����� � 䠩����
include files.asm

; ����� � ��������ன
include keyboard.asm

; ����饭��
include messages.asm

; ��६����
include data.asm

; ��砫� �ணࠬ��
Begin:
        call Check_video ;�஢�ਬ �����०�� � ⥪���� ��࠭���

        mov ah,9
        mov dx,offset Mess_about
        int 21h ;�뢥��� ᮮ�饭�� � �ਢ���⢨��

        call Main_proc ;��뢥� �������� ��楤���

; � �� ������� ⮫�� � ⮬ ��砥, �᫨ ���짮��⥫� �訫 ��� � DOS
        int 20h

CSEG ends
end Start