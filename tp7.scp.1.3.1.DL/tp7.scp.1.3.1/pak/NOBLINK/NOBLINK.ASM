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
old10h    dd 00000000h                ; � ���������� ����� int 10h
int10h    proc far
          cmp  ax,0EFFFh              ; ��� ����䥩�?
          je   l3
          cmp  byte ptr cs:flag, 01h  ; �᫨ ����⨢��, ����� �� �஢��塞
          jne  l1
          cmp  ah,00h                 ; ��⠭���� ०���?
          je   l2                     ; �᫨ ��, ������ �� ᢮� ��ࠡ��稪
          cmp  ax,1003h               ; ��⠭���� ���栭��/�મ��?
          jne  l1
          mov  bl,00h                 ; �᫨ �� - �����뢠��
l1:       jmp  dword ptr cs:[old10h]  ; � ����� ��룠�� �� ���� ��ࠡ��稪
l2:       sti                         ; ��砫� ��襣� ��ࠡ��稪�
          pushf
          call dword ptr cs:[old10h]  ; ��� ��砫� �맮��� ���� ��ࠡ��稪
          push ax                     ; ���࠭�� ��, �� �㤥� ������, ��
          push bx                     ; ������ ������ ��, �� ���� ����
          pushf                       ; ��ࠡ��稪
          mov  ax,1003h               ; � ⥯��� ��뢠�� ���� ��ࠡ��稪
          mov  bl,00h                 ; ��� ��⠭���� �મ��
          pushf
          call dword ptr cs:[old10h]
          popf                        ; ����⠭���� ��, �� ���﫨
          pop  bx
          pop  ax
          retf 2                      ; � �᫨ ���⠢��� iret, ��୥� �� � 䫠��
l3:       mov  ax,'VO'
          cmp  bh,01h
          jne  l4
          mov  byte ptr cs:flag,01h
          iret
l4:       cmp  bh,02h
          jne  l5
          mov  byte ptr cs:flag,00h
l5:       iret
int10h    endp

mes       db   'Noblink by V.Ostashev stays resident',cr,lf
          db   'Use Noblink + for activate, Noblink - for deactivate',cr,lf,eom
errorm    db   'Noblink already installed',cr,lf,eom
activm    db   'Noblink activated',cr,lf,eom
deactivm  db   'Noblink deactivated',cr,lf,eom
init:     mov  ax,0EFFFh               ; �஢�ઠ ��⠭����
          xor  bh,bh
          int  10h
          cmp  ax,'VO'                 ; �᫨ 㦥 ��⠭������
          jne  l8
          mov  ah, byte ptr cs:[0082h] ; �஢�ઠ ���祩 � ��������� ��ப�
          cmp  ah,'+'
          jne  l6
          mov  ax,0EFFFh               ; ��⨢�����
          mov  bh,01h
          int  10h
          lea  dx,activm               ; �뢮� ᮮ�饭��
          mov  ah,09h
          int  21h
          mov  ax,1003h
          mov  bl,00h
          int  10h
          int  20h
l6:       cmp  ah,'-'
          jne  l7
          mov  ax,0EFFFh               ; ����⨢���
          mov  bh,02h
          int  10h
          lea  dx,deactivm             ; �뢮� ᮮ�饭��
          mov  ah,09h
          int  21h
          mov  ax,1003h
          mov  bl,01h
          int  10h
          int  20h
l7:       lea  dx,errorm               ; �뢮� ᮮ�饭��
          mov  ah,09h                  ; �᫨ 㦥 ��⠭������ � ��� ����
          int  21h                     ; ��⨢�樨/����⨢�樨
          int  20h
l8:       lea  di,old10h
          mov  ax,3510h
          int  21h                     ; ����祭�� �����
          mov  [di],bx                 ; ���࠭���� �����
          mov  [di+2],es
          mov  ax,cs:[envir]           ; �᢮�������� ���㦥���
          mov  es,ax
          mov  ah,49h
          int  21h
          mov  ax,1003h                ; ������� �ન� 䮭
          mov  bl,00h
          int  10h
          lea  dx,mes                  ; �뢮� ᮮ�饭��
          push dx
          mov  ah,09h
          int  21h
          mov  ax,2510h                ; ��⠭���� �����
          lea  dx,int10h
          int  21h
          mov  ah,0Fh
          int  10h
          xor  ah,ah
          or   al,80H
          int  10h
          pop  dx
          int  27h
          db   'Copyright (c) V.Ostashev,1996'
          end