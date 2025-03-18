; В качесте заготовки использовался Noblink by V.Ostashev
; Принцип действия:
; Перехватывается int 21h/ax=3d00h или ax=3d02h
; Анализируется ds:dx
; Если файл имеет расширение .BGI или .CHR,
; будет попробован обычный способ открытия файла
; старым обработчиком прерывания
; Если у старого не получилось, пробуется
; найти этот файл в X:\BP

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
old21h    dd 00000000h                ; Сюда запоминаем вектор int 21h

int21h    proc far
          cmp  ax,0A680h              ; Наш интерфейс?
          jne  nol3
          jmp  l3
nol3:
          cmp  byte ptr cs:flag, 01h  ; Если неактивны, дальше не проверяем
          jne  l1

          cmp  ah,03dh                ; Открыть файл?
          je   l2                     ; Если да, пойдем на свой обработчик
l1:       jmp  dword ptr cs:[old21h]  ; А здесь прыгаем на старый обработчик

maxsize   equ  260                    ; В Borland всё равно не больше 255
bufsize   equ  19                     ; X:\BP\12345678.123
buffer:   db   bufsize dup (0)        ; 1234567890123456789

l2:       push si                     ; Измерить длину
          push cx
          mov  cx,maxsize
          mov  si,dx
check0:   cmp  byte ptr ds:[si],0
          jz   lenfound
          inc  si
          loop check0
popjmp:   pop  cx                     ; В bufsize байтах не было найдено #0
          pop  si                     ; Это не Borland; jmp старый обработчик
          jmp dword ptr cs:[old21h]

lenfound: sub  cx,maxsize             ; cx := maxsize - cx, = -(cx - maxsize)
          neg  cx                     ; В cx теперь длина
          cmp  cx,5                   ; Length('1.BGI') = Length('2.CHR') = 5
          jl   popjmp                 ; Точно не наш случай, jmp на старый

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
          jmp  popjmp2                ; Точно не .BGI и не .CHR=>не наш случай
matchgi:  mov  ax,word ptr ds:[si-2]
          cmp  al,'G'
          je   matchi
          cmp  al,'g'
          je   matchi
          jmp  popjmp2
matchi:   cmp  ah,'I'                 ; .BGI или .BGT
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
          call dword ptr cs:[old21h]  ; Сначала пробуем старым
          jc   problem
          pop  dx                     ; Всё OK, возвращаемся
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

                                      ; Слишком длинное имя, выходим
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
          mov  ax,3d00h               ; Открытие файла только на чтение
          pushf
          call dword ptr cs:[old21h]
          jc problem2
          pop  ds
          pop  dx
          pop  di                     ; ax не затираем, в нём handle
          pop  di
          mov  si,sp
          and  byte ptr ss:[si+6],0feh; CF := 0
          pop  si
          iret

problem2: pop  ds                     ; Возвращаться будет код ошибки
          pop  dx                     ; от первого вызова
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
init:     mov  ax,0A680h               ; Проверка установки
          xor  bh,bh
          int  21h
          cmp  ax,'hj'                 ; Если уже установлены
          jne  l8
          mov  ah, byte ptr cs:[0083h] ; Проверка ключей в командной строке
          cmp  ah,'+'
          jne  l6
          mov  ax,0A680h               ; Активизация
          mov  bh,01h
          int  21h
          lea  dx,activm               ; Вывод сообщения
          mov  ah,09h
          int  21h
          int  20h
l6:       cmp  ah,'-'
          jne  l7
          mov  ax,0A680h               ; Деактивация
          mov  bh,02h
          int  21h
          lea  dx,deactivm             ; Вывод сообщения
          mov  ah,09h
          int  21h
          int  20h
l7:       lea  dx,errorm               ; Вывод сообщения
          mov  ah,09h                  ; Если уже установлены и нет ключа
          int  21h                     ; активации/деактивации
          int  20h
l8:       lea  di,old21h
          mov  ax,3521h
          int  21h                     ; Получение вектора
          mov  [di],bx                 ; Сохранение вектора
          mov  [di+2],es
          mov  ax,cs:[envir]           ; Освобождение окружения
          mov  es,ax
          mov  ah,49h
          int  21h
          lea  dx,mes                  ; Вывод сообщения
          push dx
          mov  ah,09h
          int  21h
          mov  ax,2521h                ; Установка вектора
          lea  dx,int21h
          int  21h
          pop  dx
          int  27h
          end
