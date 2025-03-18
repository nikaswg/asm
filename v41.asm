init_ds macro 
mov ax,dseg
mov ds,ax
endm                         
out_str_bx macro str,rg
push ax
mov ah,09h
mov dx,offset str
int 21h
mov ax,rg
call disp
pop ax
endm
out_str macro str 
push ax
mov ah,09h
mov dx,offset str
int 21h
pop ax
endm
exit macro 
mov ax,4c00h
int 21h
endm

extrn vvod:near, disp:near
Dseg segment para public 'data'
    mas db 10 dup (?)
	two db 2
    mes1 db 'Enter n=$'
    mes2 db 'mas[$'
    mes3 db ']=$'
    mes4 db 'Start vector$'
    mes5 db 10, 13, '$' ; переход на новую строку
    mes6 db ' $' ; пробел
    mes9 db 'Sort vector$'
    mes10 db 'Posledniy element chetniy$'
	mes11 db 'Posledniy element nechetniy$'
	n dw ?
Dseg ends

Sseg segment para stack 'stack'
    db 30 dup(0)
Sseg ends

Cseg segment para public 'code'
osn proc near
assume cs:cseg, ds:dseg, ss:sseg
init_ds
;очистка экрана
mov ax,0002h
int 10h
;ввод размерности вектора n
out_str mes1
call vvod
mov n,bx
;ввод элементов вектора
mov cx,n
mov si,0
zikl1:
out_str mes2 
mov ax,si
call disp
out_str mes3
call vvod
mov mas[si],bl
inc si
loop zikl1
;вывод вектора
out_str mes4 
out_str mes5
mov cx,n
mov si,0
zikl2:
mov al, mas[si]
cbw
call disp
out_str mes6

inc si
loop zikl2

; Проверка последнего элемента на четность
mov si, n
dec si
mov al, mas[si]
cbw
idiv two
cmp ah, 0
je Sort
out_str mes5
out_str mes11
jmp m3

; Если последний элемент четный, выполняем сортировку
Sort: 
out_str mes5
out_str mes10
out_str mes5
;сортировка 
mov cx,n
Cikl2: push cx
mov cx, n
dec cx
mov si,0 ;si=j
cikl1: mov di,si
inc di ;di=j+1
mov al, mas[si]
mov bl, mas[di]
cmp al,bl
jle met1
mov mas[si],bl
mov mas[di],al
met1: inc si
loop cikl1
pop cx
loop cikl2
; вывод отсортированного вектора
out_str mes9
out_str mes5
mov cx, n
mov si, 0
l4:
    mov al, mas[si]
    cbw
    call disp
    out_str mes6
    inc si
    loop l4
m3: exit
osn endp
Cseg ends
end osn