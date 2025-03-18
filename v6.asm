;Колешко Кирилл
;(4a-2b+7c)/4           a = 4 b = 2 c = 12
masm
model small
.data
 len equ 2 ;разрядность числа
 a db 4,0 ;неупакованное число 4
 b db 2,0 ;неупакованное число 2
 c db 2,1 ;неупакованное число 12
 four db 4
 seven db 7
 two db 2
 ten db 10
 prod1 db 3 dup(0) ;4a = 16
 prod2 db 3 dup(0) ;2b = 4
 sub1 db 3 dup (0) ;4a-2b = 12
 prod3 db 3 dup(0) ;7c = 84
 sum1 db 3 dup(0)  ;4a-2b+c = 96
 rez db 2 dup (0)  ;частное (4a-2b+7c)/4 = 24 
.stack
 db 256 dup (0)
.code
main proc near
 mov ax,@data
 mov ds, ax
xor ax,ax ;произведение 4a = 16
len equ 2 ;размерность сомножителя 1
xor bx,bx
xor si,si
xor di,di
mov cx,len ;в cx длина наибольшего сомножителя 1
m1: mov al,a[si]
mul four
aam ;коррекция умножения
adc al,dl ;учли предыдущий перенос
aaa ;скорректировали результат сложения с переносом
mov dl,ah ;запомнили перенос
mov prod1[bx],al
inc si
inc bx
loop m1
mov prod1[bx],dl
xor ax,ax ;произведение 2b = 4
len equ 2 ;размерность сомножителя 1
xor bx,bx
xor si,si
xor di,di
mov cx,len ;в cx длина наибольшего сомножителя 1
m2: mov al,b[si]
mul two
aam ;коррекция умножения
adc al,dl ;учли предыдущий перенос
aaa ;скорректировали результат сложения с переносом
mov dl,ah ;запомнили перенос
mov prod2[bx],al
inc si
inc bx
loop m2
mov prod2[bx],dl
xor ax,ax ;вычитание 4a-2b
xor bx,bx
mov cx,2 ;загрузка в сх счетчика цикла
m3: mov al,prod1[bx]
sbb al,prod2[bx]
aas
mov sub1[bx],al
inc bx
loop m3 
xor ax,ax ;произведение 7c = 84
len equ 2 ;размерность сомножителя 1
xor bx,bx
xor si,si
xor di,di
mov cx,len ;в cx длина наибольшего сомножителя 1
m4: mov al,c[si]
mul seven
aam ;коррекция умножения
adc al,dl ;учли предыдущий перенос
aaa ;скорректировали результат сложения с переносом
mov dl,ah ;запомнили перенос
mov prod3[bx],al
inc si
inc bx
loop m4
mov prod3[bx],dl
xor bx,bx ;сложение 4a-2b+7c = 96
mov cx,3
m5: mov al,sub1[bx]
adc al,prod3[bx]
aaa
mov sum1[bx],al
inc bx
loop m5
adc sum1[bx],0
xor ax,ax ;деление 
mov si,1
mov al,sum1[si]
imul ten ;умножаем первую цифру числа на 10
dec si
add al,sum1[si] ;прибавляем вторую цифру числа
div four ;делим: в al BCD-частное, в ah BCD-остаток
;формируем результат в виде BCD-числа
mov bl,al ;запоминаем частное
mov ah,0 ;убираем остаток
div ten ;выделяем цифры числа
mov di,0
mov rez[di],ah ;запоминаем вторую цифру числа
inc di
mov rez[di],al ;запоминаем первую цифру числа
mov ax,4c00h
int 21h
main endp
end main
