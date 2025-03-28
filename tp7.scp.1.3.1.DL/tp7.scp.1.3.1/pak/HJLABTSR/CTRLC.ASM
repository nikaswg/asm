; � ����� ����⮢�� �ᯮ�짮����� Noblink by V.Ostashev
; �������� �ᯮ�짮���� CtrlC � DOSBox
; ����⠥� ����� ���⪮, 祬 � �����饬 DOS
; � �����饬 DOS CtrlC ����� �� ࠡ���� �
; �ணࠬ���, ��室����� � ���ﭨ�
; ��᪮��筮�� 横�� ��� �����-�뢮��.
; � �⨬ �ࠩ��஬ ⠪�� �����訥 �ணࠬ��
; ��� ࠢ�� ���� ��ࠡ��뢠����.

.model tiny
.186
.code
.startup
          cr              equ  0Dh
          lf              equ  0Ah
          eom             equ  24h
          envir           equ  002Ch
          jmp init
flag      db 01h                      ; ���� ��⨢����
old9h     dd 00000000h                ; � ���������� ����� int 9h
old16h    dd 00000000h                ; � ���������� ����� int 16h
int16h    proc far
          cmp  ax,0A681h              ; ��� ����䥩�?
          je   l3
l1:       jmp  dword ptr cs:[old16h]  ; � ����� ��룠�� �� ���� ��ࠡ��稪

l3:       mov  ax,'hj'
          cmp  bh,01h
          jne  l4
          mov  byte ptr cs:flag,01h
          iret
l4:       cmp  bh,02h
          jne  l5
          mov  byte ptr cs:flag,00h
l5:       iret
int16h    endp

ctrlpress:db 0                        ; ����� �� Ctrl
;cmes:     db '.',eom                 ; ��� �⫠���
;ctrlmes:  db '*',eom
;scanmes:  db '   ',eom
;digits:   db '0123456789abcdef'

int9h     proc far
          sti
          cmp  byte ptr cs:flag, 01h  ; �᫨ ����⨢��, ����� �� �஢��塞
          jne  kbdjumpold
          push ax
          push dx
          push ds
          in   al,60h
          cmp  al,2eh                 ; 2eh -> 'c'
          je   processc
          mov  ah,al
          and  al,7fh
          cmp  al,1dh                 ; 1dh -> Ctrl
          jne  popjmp
          shr  ah,7
          xor  ah,1
          mov  byte ptr cs:[offset ctrlpress],ah
          jmp  popjmp

processc: 
          ;mov  ax,cs
          ;mov  ds,ax
          ;mov  dx,offset cmes
          ;mov  ah,09h
          ;int  21h

          ;mov  ax,0040h
          ;mov  ds,ax
          ;mov  al,byte ptr ds:[17h]
          ;and  al,4                   ; Ctrl
          test byte ptr cs:[offset ctrlpress],1
          je   popjmp
          mov  al,20h
          out  20h,al
          sti
          int  23h
          pop  ds
          pop  dx
          pop  ax
          iret

popjmp:   pop  ds
          pop  dx
          pop  ax
kbdjumpold:
          jmp  dword ptr cs:[old9h]  ; � ����� ��룠�� �� ���� ��ࠡ��稪
int9h    endp

mes       db   'CtrlC for DOSBox by Humble Jedis',cr,lf
          db   'Use CTRLC + for activate, CTRLC - for deactivate',cr,lf,eom
errorm    db   'CtrlBreak already installed',cr,lf,eom
activm    db   'CtrlBreak activated',cr,lf,eom
deactivm  db   'CtrlBreak deactivated',cr,lf,eom
init:     mov  ax,0A681h               ; �஢�ઠ ��⠭����
          xor  bh,bh
          int  16h
          cmp  ax,'hj'                 ; �᫨ 㦥 ��⠭������
          jne  l8
          mov  ah, byte ptr cs:[0083h] ; �஢�ઠ ���祩 � ��������� ��ப�
          cmp  ah,'+'
          jne  l6
          mov  ax,0A681h               ; ��⨢�����
          mov  bh,01h
          int  16h
          lea  dx,activm               ; �뢮� ᮮ�饭��
          mov  ah,09h
          int  21h
          int  20h
l6:       cmp  ah,'-'
          jne  l7
          mov  ax,0A681h               ; ����⨢���
          mov  bh,02h
          int  16h
          lea  dx,deactivm             ; �뢮� ᮮ�饭��
          mov  ah,09h
          int  21h
          int  20h
l7:       lea  dx,errorm               ; �뢮� ᮮ�饭��
          mov  ah,09h                  ; �᫨ 㦥 ��⠭������ � ��� ����
          int  21h                     ; ��⨢�樨/����⨢�樨
          int  20h
l8:       lea  di,old16h
          mov  ax,3516h
          int  21h                     ; ����祭�� �����
          mov  [di],bx                 ; ���࠭���� �����
          mov  [di+2],es

          lea  di,old9h
          mov  ax,3509h
          int  21h
          mov  [di],bx
          mov  [di+2],es

          mov  ax,cs:[envir]           ; �᢮�������� ���㦥���
          mov  es,ax
          mov  ah,49h
          int  21h
          lea  dx,mes                  ; �뢮� ᮮ�饭��
          push dx
          mov  ah,09h
          int  21h

          mov  ax,2516h                ; ��⠭���� �����
          lea  dx,int16h
          int  21h

          mov  ax,2509h
          lea  dx,int9h
          int  21h

          pop  dx
          int  27h
          end