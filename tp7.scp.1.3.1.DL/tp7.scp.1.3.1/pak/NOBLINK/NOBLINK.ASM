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
old10h    dd 00000000h                ; Сюда запоминаем вектор int 10h
int10h    proc far
          cmp  ax,0EFFFh              ; Наш интерфейс?
          je   l3
          cmp  byte ptr cs:flag, 01h  ; Если неактивны, дальше не проверяем
          jne  l1
          cmp  ah,00h                 ; Установка режима?
          je   l2                     ; Если да, пойдем на свой обработчик
          cmp  ax,1003h               ; Установка мерцания/яркости?
          jne  l1
          mov  bl,00h                 ; Если да - обламываем
l1:       jmp  dword ptr cs:[old10h]  ; А здесь прыгаем на старый обработчик
l2:       sti                         ; Начало нашего обработчика
          pushf
          call dword ptr cs:[old10h]  ; Для начала вызовем старый обработчик
          push ax                     ; Сохраним все, что будем менять, мы
          push bx                     ; должны вернуть все, что вернул старый
          pushf                       ; обработчик
          mov  ax,1003h               ; А теперь вызываем старый обработчик
          mov  bl,00h                 ; для установки яркости
          pushf
          call dword ptr cs:[old10h]
          popf                        ; Восстановим все, что меняли
          pop  bx
          pop  ax
          retf 2                      ; А если поставить iret, вернем не те флаги
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
init:     mov  ax,0EFFFh               ; Проверка установки
          xor  bh,bh
          int  10h
          cmp  ax,'VO'                 ; Если уже установлены
          jne  l8
          mov  ah, byte ptr cs:[0082h] ; Проверка ключей в командной строке
          cmp  ah,'+'
          jne  l6
          mov  ax,0EFFFh               ; Активизация
          mov  bh,01h
          int  10h
          lea  dx,activm               ; Вывод сообщения
          mov  ah,09h
          int  21h
          mov  ax,1003h
          mov  bl,00h
          int  10h
          int  20h
l6:       cmp  ah,'-'
          jne  l7
          mov  ax,0EFFFh               ; Деактивация
          mov  bh,02h
          int  10h
          lea  dx,deactivm             ; Вывод сообщения
          mov  ah,09h
          int  21h
          mov  ax,1003h
          mov  bl,01h
          int  10h
          int  20h
l7:       lea  dx,errorm               ; Вывод сообщения
          mov  ah,09h                  ; Если уже установлены и нет ключа
          int  21h                     ; активации/деактивации
          int  20h
l8:       lea  di,old10h
          mov  ax,3510h
          int  21h                     ; Получение вектора
          mov  [di],bx                 ; Сохранение вектора
          mov  [di+2],es
          mov  ax,cs:[envir]           ; Освобождение окружения
          mov  es,ax
          mov  ah,49h
          int  21h
          mov  ax,1003h                ; Сделаем яркий фон
          mov  bl,00h
          int  10h
          lea  dx,mes                  ; Вывод сообщения
          push dx
          mov  ah,09h
          int  21h
          mov  ax,2510h                ; Установка вектора
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