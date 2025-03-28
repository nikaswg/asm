; � ����� ����⮢�� �ᯮ�짮����� Noblink by V.Ostashev
; �ਭ樯 ����⢨�:
; ���墠�뢠���� int 21h/ax=3d00h ��� ax=3d02h
; ������������ ds:dx
; �᫨ 䠩� ����� ���७�� .BGI ��� .CHR,
; �㤥� ���஡���� ����� ᯮᮡ ������ 䠩��
; ���� ��ࠡ��稪�� ���뢠���
; �᫨ � ��ண� �� ����稫���, �஡����
; ���� ��� 䠩� � X:\BP

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
old21h    dd 00000000h                ; � ���������� ����� int 21h

int21h    proc far
          cmp  ax,0A680h              ; ��� ����䥩�?
          jne  nol3
          jmp  l3
nol3:
          cmp  byte ptr cs:flag, 01h  ; �᫨ ����⨢��, ����� �� �஢��塞
          jne  l1

          cmp  ah,03dh                ; ������ 䠩�?
          je   l2                     ; �᫨ ��, ������ �� ᢮� ��ࠡ��稪
l1:       jmp  dword ptr cs:[old21h]  ; � ����� ��룠�� �� ���� ��ࠡ��稪

maxsize   equ  260                    ; � Borland ��� ࠢ�� �� ����� 255
bufsize   equ  19                     ; X:\BP\12345678.123
buffer:   db   bufsize dup (0)        ; 1234567890123456789

l2:       push si                     ; ������� �����
          push cx
          mov  cx,maxsize
          mov  si,dx
check0:   cmp  byte ptr ds:[si],0
          jz   lenfound
          inc  si
          loop check0
popjmp:   pop  cx                     ; � bufsize ����� �� �뫮 ������� #0
          pop  si                     ; �� �� Borland; jmp ���� ��ࠡ��稪
          jmp dword ptr cs:[old21h]

lenfound: sub  cx,maxsize             ; cx := maxsize - cx, = -(cx - maxsize)
          neg  cx                     ; � cx ⥯��� �����
          cmp  cx,5                   ; Length('1.BGI') = Length('2.CHR') = 5
          jl   popjmp                 ; ��筮 �� ��� ��砩, jmp �� ����

          push ax
          mov  ax,word ptr ds:[si-4]
          cmp  al,'.'
          je   match
popjmp2:  pop  ax
          pop  cx
          pop  si
          jmp  dword ptr cs:[old21h]
match:    cmp  ah,'B'
          je   matchgi
          cmp  ah,'b'
          je   matchgi
          cmp  ah,'C'
          je   matchhr
          cmp  ah,'c'
          je   matchhr
          jmp  popjmp2                ; ��筮 �� .BGI � �� .CHR=>�� ��� ��砩
matchgi:  mov  ax,word ptr ds:[si-2]
          cmp  al,'G'
          je   matchi
          cmp  al,'g'
          je   matchi
          jmp  popjmp2
matchi:   cmp  ah,'I'                 ; .BGI ��� .BGT
          je   matched
          cmp  ah,'T'
          je   matched
          cmp  ah,'i'
          je   matched
          cmp  ah,'t'
          je   matched
          jmp  popjmp2
matchhr:  mov  ax,word ptr ds:[si-2]
          cmp  al,'H'
          je   matchr
          cmp  al,'h'
          je   matchr
          jmp  popjmp2
matchr:   cmp  ah,'R'
          je   matched
          cmp  ah,'r'
          je   matched
          jmp  popjmp2
matched:  pop  ax
          pop  cx
          push dx
          pushf
          call dword ptr cs:[old21h]  ; ���砫� �஡㥬 ����
          jc   problem
          pop  dx                     ; ��� OK, �����頥���
          mov  si,sp
          and  byte ptr ss:[si+6],0feh; CF := 0
          ;pop  cx
          pop  si
          iret

problem:  pop  dx
          push di
          mov  di,si
          sub  si,13                  ;+12345678.BGI+
trysep:   cmp  byte ptr ds:[di],'\'
          je   sepfound
          cmp  byte ptr ds:[di],':'
          je   sepfound
          dec  di
          cmp  di,dx
          jl   sepfound
          cmp  di,si
          jnl  trysep

                                      ; ���誮� ������� ���, ��室��
          pop  di
          mov  si,sp
          or   byte ptr ss:[si+6],1   ; CF := 1
          pop  si
          iret
sepfound:
          mov  word ptr cs:[buffer],':X'
          mov  word ptr cs:[buffer+2],'B\'
          mov  word ptr cs:[buffer+4],'\P'
          add  si,13
          inc  di
          push bx
          mov  bx,offset buffer+6
          push ax
copychar: mov  al,byte ptr ds:[di]
          mov  byte ptr cs:[bx],al
          cmp  al,0
          je   endcploop
          inc  di
          inc  bx
          jmp  copychar
endcploop:pop  ax
          pop  bx
          push ax
          push dx
          push ds
          mov  ax,cs
          mov  ds,ax
          mov  dx,offset buffer
          mov  ax,3d00h               ; ����⨥ 䠩�� ⮫쪮 �� �⥭��
          pushf
          call dword ptr cs:[old21h]
          jc problem2
          pop  ds
          pop  dx
          pop  di                     ; ax �� ���ࠥ�, � �� handle
          pop  di
          mov  si,sp
          and  byte ptr ss:[si+6],0feh; CF := 0
          pop  si
          iret

problem2: pop  ds                     ; ���������� �㤥� ��� �訡��
          pop  dx                     ; �� ��ࢮ�� �맮��
          pop  ax
          pop  di
          ;pop  cx
          mov  si,sp
          or   byte ptr ss:[si+6],1   ; CF := 1
          pop  si
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
int21h    endp

mes       db   'InitGraph Everywhere for School Pak by Humble Jedis',cr,lf
          db   'Use GRAPH + for activate, GRAPH - for deactivate',cr,lf,eom
errorm    db   'GRAPH already installed',cr,lf,eom
activm    db   'GRAPH activated',cr,lf,eom
deactivm  db   'GRAPH deactivated',cr,lf,eom
init:     mov  ax,0A680h               ; �஢�ઠ ��⠭����
          xor  bh,bh
          int  21h
          cmp  ax,'hj'                 ; �᫨ 㦥 ��⠭������
          jne  l8
          mov  ah, byte ptr cs:[0083h] ; �஢�ઠ ���祩 � ��������� ��ப�
          cmp  ah,'+'
          jne  l6
          mov  ax,0A680h               ; ��⨢�����
          mov  bh,01h
          int  21h
          lea  dx,activm               ; �뢮� ᮮ�饭��
          mov  ah,09h
          int  21h
          int  20h
l6:       cmp  ah,'-'
          jne  l7
          mov  ax,0A680h               ; ����⨢���
          mov  bh,02h
          int  21h
          lea  dx,deactivm             ; �뢮� ᮮ�饭��
          mov  ah,09h
          int  21h
          int  20h
l7:       lea  dx,errorm               ; �뢮� ᮮ�饭��
          mov  ah,09h                  ; �᫨ 㦥 ��⠭������ � ��� ����
          int  21h                     ; ��⨢�樨/����⨢�樨
          int  20h
l8:       lea  di,old21h
          mov  ax,3521h
          int  21h                     ; ����祭�� �����
          mov  [di],bx                 ; ���࠭���� �����
          mov  [di+2],es
          mov  ax,cs:[envir]           ; �᢮�������� ���㦥���
          mov  es,ax
          mov  ah,49h
          int  21h
          lea  dx,mes                  ; �뢮� ᮮ�饭��
          push dx
          mov  ah,09h
          int  21h
          mov  ax,2521h                ; ��⠭���� �����
          lea  dx,int21h
          int  21h
          pop  dx
          int  27h
          end
