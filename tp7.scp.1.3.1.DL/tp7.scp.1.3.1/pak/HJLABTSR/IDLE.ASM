; � ����� ����⮢�� �ᯮ�짮����� Noblink by V.Ostashev
; �ਭ樯 ����⢨�:
; �) ��ࠢ��� ���� DOSBox
; b) �।������ 宫��⮩ 横� � int 16h
;   (�����쭮 ���� ���筨� �࠭��� CPU)
; � �ਭ樯�, ����� �ᯮ�짮���� � ��� DOSBox. �� ���
; �⮣� �㦭� �������� flag2f �� 00 � ���ᮡ���.
; ����� �뫮 �� � � ��������� ��ப� ᤥ���� �ࠢ�����, �� �뫮
; ������. � ��� ⮣� 㯠ਫ��, ������ ���⠢��� BP.EXE
; ��뢠�� yield. ��� � �� 㤠����, ���⮬� BP.EXE ��뢠��
; int 16/ax=1680 ����� int 2f. ��� ����� �㭪樥� १�����
; ���� ��७��ࠢ����� ��⮣� yield (��� ������ ������).
; ���⮬� ����� ����� ��� �ᯮ�짮���� ��� १�����
; ᮢ���⭮ � BP.EXE ��� ��㣨�� �����ࠬ� (DOSEmu, NTVDM).
; ��� �� -- �� ᢮� ���� � ��.

.model tiny
.186
.code
.startup
          cr              equ  0Dh
          lf              equ  0Ah
          eom             equ  24h
          envir           equ  002Ch
          jmp init
flag2f    db 01h                      ; ��ࠢ���� �� ���� DOSBox?
                                      ; �᫨ �ᯮ�짮���� �� � DOSBox,
                                      ; ���� �������� �� 0
flag      db 01h                      ; ���� ��⨢����
old2fh    dd 00000000h                ; � ���������� ����� int 2fh
old16h    dd 00000000h                ; � ���������� ����� int 16h
int2fh    proc far
          cmp  ax,0A680h              ; ��� ����䥩�?
          je   l3
          cmp  byte ptr cs:flag2f, 01h  ; �᫨ ����⨢��, ����� �� �஢��塞
          jne  l1
          cmp  ax,01680h              ; Yield?
          je   l2                     ; �᫨ ��, ������ �� ᢮� ��ࠡ��稪
l1:       jmp  dword ptr cs:[old2fh]  ; � ����� ��룠�� �� ���� ��ࠡ��稪

l2:       sti                         ; ��砫� ��襣� ��ࠡ��稪�
          hlt                         ; ��㧠
          mov  al,00h                 ; Yield �����ন������
          iret

l3:       mov  ax,'hj'
          cmp  bh,01h
          jne  l4
          mov  byte ptr cs:flag,01h
          iret
l4:       cmp  bh,02h
          jne  l5
          mov  byte ptr cs:flag,00h
l5:       iret
int2fh    endp

int16h    proc far
          cmp  byte ptr cs:flag, 01h  ; �᫨ ����⨢��, ����� �� �஢��塞
          jne kbdjumpold

          cmp  ah,10h
          je   kbdex
          test ah,ah
          jz   kbdnorm
          cmp  ax,1680h        ; �����-� yield �� ��㣮� ���뢠���
                               ; �� ���� ���⠫� 㦥 �᪠��, ��� �
                               ; ����񭭮� ०��� �⤠�� ������:
                               ; int 2f ���墠�뢠���� ������� DPMI,
                               ; �, ����筮 ��, yield �� ᠬ �� 㬥��,
                               ; �� � �� ���� ����� TSR ��ࠡ����
                               ; hlt ⮦� �� ࠡ�⠥�, �ࠢ �� 墠⠥�
                               ; int 16 ��室�� �� TSR �ᯥ譮,
                               ; ���⮬� ᤥ���� �१ ��^Wint 16h
                               ; �᫨ �㯥�-�㯥� TSR �� ��⠭�����,
                               ; BP.EXE �㤥� ����� CPU, ��� � �०��
                               ; ��� NTVDM ��, ᪮॥ �ᥣ�, ࠡ����
                               ; �� �㤥� (� ����, BP.EXE ���������, ��
                               ; �� �㤥� ���� CPU).
          je   kbdyield
kbdjumpold:
          jmp  dword ptr cs:[old16h]  ; � ����� ��룠�� �� ���� ��ࠡ��稪

kbdnorm:
          mov  ah,01h
          pushf
          call dword ptr cs:[old16h]
          jz kbdnormhlt
          mov ah,00h
          jmp  dword ptr cs:[old16h] ; ah=01h ���� �஢���� ����稥;
                                     ; �⮡� ������� ������ �� ����,
                                     ; ���� �맢��� ah=00h
kbdnormhlt:
          push ax
          mov ax,1680h
          int 2fh
          pop ax
          jmp short kbdnorm

kbdex:
          mov  ah,11h
          pushf
          call dword ptr cs:[old16h]
          jz kbdexhlt
          mov ah,10h
          jmp  dword ptr cs:[old16h] ; ah=11h ���� �஢���� ����稥;
                                     ; �⮡� ������� ������ �� ����,
                                     ; ���� �맢��� ah=10h
kbdexhlt:
          push ax
          mov ax,1680h
          int 2fh
          pop ax
          jmp short kbdex

kbdyield: int 2fh
          iret

int16h    endp

mes       db   'IDLE for DOSBox by Humble Jedis',cr,lf
          db   'Use IDLE + for activate, IDLE - for deactivate',cr,lf,eom
errorm    db   'IDLE already installed',cr,lf,eom
activm    db   'IDLE activated',cr,lf,eom
deactivm  db   'IDLE deactivated',cr,lf,eom
init:     mov  ax,0A680h               ; �஢�ઠ ��⠭����
          xor  bh,bh
          int  2fh
          cmp  ax,'hj'                 ; �᫨ 㦥 ��⠭������
          jne  l8
          mov  ah, byte ptr cs:[0082h] ; �஢�ઠ ���祩 � ��������� ��ப�
          cmp  ah,'+'
          jne  l6
          mov  ax,0A680h               ; ��⨢�����
          mov  bh,01h
          int  2fh
          lea  dx,activm               ; �뢮� ᮮ�饭��
          mov  ah,09h
          int  21h
          int  20h
l6:       cmp  ah,'-'
          jne  l7
          mov  ax,0A680h               ; ����⨢���
          mov  bh,02h
          int  2fh
          lea  dx,deactivm             ; �뢮� ᮮ�饭��
          mov  ah,09h
          int  21h
          int  20h
l7:       lea  dx,errorm               ; �뢮� ᮮ�饭��
          mov  ah,09h                  ; �᫨ 㦥 ��⠭������ � ��� ����
          int  21h                     ; ��⨢�樨/����⨢�樨
          int  20h
l8:       lea  di,old2fh
          mov  ax,352fh
          int  21h                     ; ����祭�� �����
          mov  [di],bx                 ; ���࠭���� �����
          mov  [di+2],es

          lea  di,old16h
          mov  ax,3516h
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

          mov  ax,252fh                ; ��⠭���� �����
          lea  dx,int2fh
          int  21h

          mov  ax,2516h
          lea  dx,int16h
          int  21h

          pop  dx
          int  27h
          end