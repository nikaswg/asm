;Кущ Владислав В-9 
;a=124, n=4
sseg segment para stack 'stack' 
 db 256 dup (0) 
sseg ends 
;сегмент данных 
dseg segment para public 'data' 
a dw 124 ;124=0000 0000 0111 1100
mes1 db 'Number of the first non-zero bit -->$' 
mes2 db 10,13,'Number of the last non-zero bit -->$' 
mes3 db 10,13,'The third bit is zero$' 
mes4 db 10,13,'The third bit is not zero$' 
mes5 db 10,13,'The third bit is equal to one-->$' 
mes6 db 10,13,'The fourth bit is zero$' 
mes7 db 10,13,'The fourth bit is not zero$' 
mes8 db 10,13,'The fourth bit is equal to zero-->$' 
mes9 db 10,13,'The two bit is zero$' 
mes10 db 10,13,'The two bit is not zero$' 
mes11 db 10,13,'The two bit is convert-->$' 
mes12 db 10,13,'Shift logical left-->$' 
mes13 db 10,13,'Shift logical right-->$' 
mes14 db 10,13,'Shift arithmetic left-->$' 
mes15 db 10,13,'Shift arithmetic left-->$' 
mes16 db 10,13,'Rotate left-->$' 
mes17 db 10,13,'Rotate right-->$' 
mes18 db 10,13,'Rotate through carry left-->$' 
mes19 db 10,13,'Rotate through carry right-->$' 
mes20 db 10,13,'Logical command or, and, xor:$' 
dseg ends 
 extrn disp:near 
;сегмент кода 
cseg segment para public 'code' 
 main proc near 
 assume cs:cseg,ds:dseg,ss:sseg 
 mov ax,dseg ;связываем регистр dx с сегментом 
 mov ds,ax ;данных через регистр ax 
.486 ;это обязательно! 
 mov ax,0002h 
 int 10h 
;сканирование бит вперед 
 mov ax,a 
 bsf bx,ax 
 lea dx,mes1 
 mov ax,0900h 
 int 21h 
 mov ax,bx 
 call disp 
;сканирование бит в обратном порядке 
 mov ax,a 
 bsr bx,ax 
 lea dx,mes2 
 mov ax,0900h 
 int 21h 
 mov ax,bx 
 call disp 
;проверка и установка четвертого бита 
 mov bx,a 
 mov ax,4 
 bts bx,ax 
 jc m1 ;переход, если бит равен 1 
 lea dx,mes3 
 mov ax,0900h 
 int 21h 
 jmp m2 
m1: lea dx,mes4 
 mov ax,0900h 
 int 21h 
m2: lea dx,mes5 
 mov ax,0900h 
 int 21h 
 mov ax,bx 
 call disp 
;проверка и сброс пятого бита 
 mov bx,a 
 mov ax,5
 btr bx,ax 
 jc m3 ;переход, если бит равен 1 
 lea dx,mes6 
 mov ax,0900h 
 int 21h 
 jmp m4 
m3: lea dx,mes7 
 mov ax,0900h 
 int 21h 
m4: lea dx,mes8 
 mov ax,0900h 
 int 21h 
 mov ax,bx 
 call disp 
;проверка и инвертирование третьего бита 
 mov bx,a 
 mov ax,3 
 btc bx,ax 
 jc m5 ;переход, если бит равен 1 
 lea dx,mes9 
 mov ax,0900h 
 int 21h 
 jmp m6 
m5: lea dx,mes10 
 mov ax,0900h 
 int 21h 
m6: lea dx,mes11 
 mov ax,0900h 
 int 21h 
 mov ax,bx 
 call disp 
;логический сдвиг влево 
 mov ax,a 
 shl ax,4 
 mov bx,ax 
 lea dx,mes12 
 mov ax,0900h 
 int 21h 
 mov ax,bx 
 call disp 
;логический сдвиг вправо 
 mov ax,a 
 shr ax,4
 mov bx,ax 
 lea dx,mes13 
 mov ax,0900h 
 int 21h 
 mov ax,bx 
 call disp 
;арифметический сдвиг влево 
 mov ax,a 
 sal ax,4 
 mov bx,ax 
 lea dx,mes14 
 mov ax,0900h 
 int 21h 
 mov ax,bx  
 call disp 
;арифметический сдвиг вправо 
 mov ax,a 
 sar ax,4 
 mov bx,ax 
 lea dx,mes15 
 mov ax,0900h 
 int 21h 
 mov ax,bx 
 call disp 
;циклический сдвиг влево 
 mov ax,a 
 rol ax,4 
 mov bx,ax 
 lea dx,mes16 
 mov ax,0900h 
 int 21h 
 mov ax,bx 
 call disp 
;циклический сдвиг вправо 
 mov ax,a 
 ror ax,4 
 mov bx,ax 
 lea dx,mes17 
 mov ax,0900h 
 int 21h 
 mov ax,bx 
 call disp 
;логические команды or,and,xor 
 lea dx,mes20 
 mov ax,0900h 
 int 21h 
;установка четвертого бита 
 mov ax,a 
 or ax,1000b 
 mov bx,ax 
 lea dx,mes5 
 mov ax,0900h 
 int 21h 
 mov ax,bx 
 call disp 
;сброс пятого бита 
 mov ax,a 
 and ax,111111111011111b  
 mov bx,ax 
 lea dx,mes8 
 mov ax,0900h 
 int 21h 
 mov ax,bx 
 call disp 
;инвертирование третьего бита 
 mov ax,a 
 xor ax,1000b 
 mov bx,ax 
 lea dx,mes11 
 mov ax,0900h 
 int 21h 
 mov ax,bx 
 call disp 
;завершение программы 
 mov ax,4c00h 
 int 21h 
main endp 
cseg ends 
end main 