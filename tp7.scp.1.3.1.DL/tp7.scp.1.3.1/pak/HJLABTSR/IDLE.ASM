; В качесте заготовки использовался Noblink by V.Ostashev
; Принцип действия:
; а) исправить косяк DOSBox
; b) предотвратить холостой цикл в int 16h
;   (довольно частый источник транжира CPU)
; В принципе, можно использовать и без DOSBox. Но для
; этого нужно поменять flag2f на 00 и пересобрать.
; Можно было бы и с командной строки сделать управление, но было
; лениво. И без того упарился, пытаясь заставить BP.EXE
; вызывать yield. Так и не удалось, поэтому BP.EXE вызывает
; int 16/ax=1680 вместо int 2f. Ещё одной функцией резидента
; является перенаправление чистого yield (без нажатия клавиши).
; Поэтому может иметь смысл использовать этот резидент
; совместно с BP.EXE под другими эмуляторами (DOSEmu, NTVDM).
; Всё это -- на свой страх и риск.

.model tiny
.186
.code
.startup
          cr              equ  0Dh
          lf              equ  0Ah
          eom             equ  24h
          envir           equ  002Ch
          jmp init
flag2f    db 01h                      ; Исправлять ли косяк DOSBox?
                                      ; если использовать не в DOSBox,
                                      ; лучше поменять на 0
flag      db 01h                      ; Флаг активности
old2fh    dd 00000000h                ; Сюда запоминаем вектор int 2fh
old16h    dd 00000000h                ; Сюда запоминаем вектор int 16h
int2fh    proc far
          cmp  ax,0A680h              ; Наш интерфейс?
          je   l3
          cmp  byte ptr cs:flag2f, 01h  ; Если неактивны, дальше не проверяем
          jne  l1
          cmp  ax,01680h              ; Yield?
          je   l2                     ; Если да, пойдем на свой обработчик
l1:       jmp  dword ptr cs:[old2fh]  ; А здесь прыгаем на старый обработчик

l2:       sti                         ; Начало нашего обработчика
          hlt                         ; Пауза
          mov  al,00h                 ; Yield поддерживается
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
          cmp  byte ptr cs:flag, 01h  ; Если неактивны, дальше не проверяем
          jne kbdjumpold

          cmp  ah,10h
          je   kbdex
          test ah,ah
          jz   kbdnorm
          cmp  ax,1680h        ; Вообще-то yield на другом прерывании
                               ; ну просто достало уже искать, как в
                               ; защищённом режиме отдать процессор:
                               ; int 2f перехватывается долбаным DPMI,
                               ; и, конечно же, yield он сам не умеет,
                               ; но и не даёт моему TSR обработать
                               ; hlt тоже не работает, прав не хватает
                               ; int 16 доходит до TSR успешно,
                               ; поэтому сделано через за^Wint 16h
                               ; если супер-пупер TSR не установлен,
                               ; BP.EXE будет кушать CPU, как и прежде
                               ; Под NTVDM это, скорее всего, работать
                               ; не будет (то есть, BP.EXE запустится, но
                               ; но будет жрать CPU).
          je   kbdyield
kbdjumpold:
          jmp  dword ptr cs:[old16h]  ; А здесь прыгаем на старый обработчик

kbdnorm:
          mov  ah,01h
          pushf
          call dword ptr cs:[old16h]
          jz kbdnormhlt
          mov ah,00h
          jmp  dword ptr cs:[old16h] ; ah=01h просто проверяет наличие;
                                     ; чтобы клавишу вытащить из буфера,
                                     ; надо вызвать ah=00h
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
          jmp  dword ptr cs:[old16h] ; ah=11h просто проверяет наличие;
                                     ; чтобы клавишу вытащить из буфера,
                                     ; надо вызвать ah=10h
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
init:     mov  ax,0A680h               ; Проверка установки
          xor  bh,bh
          int  2fh
          cmp  ax,'hj'                 ; Если уже установлены
          jne  l8
          mov  ah, byte ptr cs:[0082h] ; Проверка ключей в командной строке
          cmp  ah,'+'
          jne  l6
          mov  ax,0A680h               ; Активизация
          mov  bh,01h
          int  2fh
          lea  dx,activm               ; Вывод сообщения
          mov  ah,09h
          int  21h
          int  20h
l6:       cmp  ah,'-'
          jne  l7
          mov  ax,0A680h               ; Деактивация
          mov  bh,02h
          int  2fh
          lea  dx,deactivm             ; Вывод сообщения
          mov  ah,09h
          int  21h
          int  20h
l7:       lea  dx,errorm               ; Вывод сообщения
          mov  ah,09h                  ; Если уже установлены и нет ключа
          int  21h                     ; активации/деактивации
          int  20h
l8:       lea  di,old2fh
          mov  ax,352fh
          int  21h                     ; Получение вектора
          mov  [di],bx                 ; Сохранение вектора
          mov  [di+2],es

          lea  di,old16h
          mov  ax,3516h
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

          mov  ax,252fh                ; Установка вектора
          lea  dx,int2fh
          int  21h

          mov  ax,2516h
          lea  dx,int16h
          int  21h

          pop  dx
          int  27h
          end