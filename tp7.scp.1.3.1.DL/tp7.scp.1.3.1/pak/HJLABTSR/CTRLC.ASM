; В качесте заготовки использовался Noblink by V.Ostashev
; Позволяет использовать CtrlC в DOSBox
; Работает более жёстко, чем в настоящем DOS
; В настоящем DOS CtrlC может не работать в
; программах, находящихся в состоянии
; бесконечного цикла без ввода-вывода.
; С этим драйвером такие зависшие программы
; всё равно будут обрабатываться.

.model tiny
.186
.code
.startup
          cr              equ  0Dh
          lf              equ  0Ah
          eom             equ  24h
          envir           equ  002Ch
          jmp init
flag      db 01h                      ; Флаг активности
old9h     dd 00000000h                ; Сюда запоминаем вектор int 9h
old16h    dd 00000000h                ; Сюда запоминаем вектор int 16h
int16h    proc far
          cmp  ax,0A681h              ; Наш интерфейс?
          je   l3
l1:       jmp  dword ptr cs:[old16h]  ; А здесь прыгаем на старый обработчик

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

ctrlpress:db 0                        ; Нажат ли Ctrl
;cmes:     db '.',eom                 ; Для отладки
;ctrlmes:  db '*',eom
;scanmes:  db '   ',eom
;digits:   db '0123456789abcdef'

int9h     proc far
          sti
          cmp  byte ptr cs:flag, 01h  ; Если неактивны, дальше не проверяем
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
          jmp  dword ptr cs:[old9h]  ; А здесь прыгаем на старый обработчик
int9h    endp

mes       db   'CtrlC for DOSBox by Humble Jedis',cr,lf
          db   'Use CTRLC + for activate, CTRLC - for deactivate',cr,lf,eom
errorm    db   'CtrlBreak already installed',cr,lf,eom
activm    db   'CtrlBreak activated',cr,lf,eom
deactivm  db   'CtrlBreak deactivated',cr,lf,eom
init:     mov  ax,0A681h               ; Проверка установки
          xor  bh,bh
          int  16h
          cmp  ax,'hj'                 ; Если уже установлены
          jne  l8
          mov  ah, byte ptr cs:[0083h] ; Проверка ключей в командной строке
          cmp  ah,'+'
          jne  l6
          mov  ax,0A681h               ; Активизация
          mov  bh,01h
          int  16h
          lea  dx,activm               ; Вывод сообщения
          mov  ah,09h
          int  21h
          int  20h
l6:       cmp  ah,'-'
          jne  l7
          mov  ax,0A681h               ; Деактивация
          mov  bh,02h
          int  16h
          lea  dx,deactivm             ; Вывод сообщения
          mov  ah,09h
          int  21h
          int  20h
l7:       lea  dx,errorm               ; Вывод сообщения
          mov  ah,09h                  ; Если уже установлены и нет ключа
          int  21h                     ; активации/деактивации
          int  20h
l8:       lea  di,old16h
          mov  ax,3516h
          int  21h                     ; Получение вектора
          mov  [di],bx                 ; Сохранение вектора
          mov  [di+2],es

          lea  di,old9h
          mov  ax,3509h
          int  21h
          mov  [di],bx
          mov  [di+2],es

          mov  ax,cs:[envir]           ; Освобождение окружения
          mov  es,ax
          mov  ah,49h
          int  21h
          lea  dx,mes                  ; Вывод сообщения
          push dx
          mov  ah,09h
          int  21h

          mov  ax,2516h                ; Установка вектора
          lea  dx,int16h
          int  21h

          mov  ax,2509h
          lea  dx,int9h
          int  21h

          pop  dx
          int  27h
          end