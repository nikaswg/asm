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
	a db 10 dup (?)
    kol db ?
	two db 2
	zero db 0
	product db ?
	kol_n db ?
	kol_m db ?
	kol_k db ?
    mes1 db 'Vvedite razmernosti vectorov=$'
    mes2 db 'mas[$'
    mes3 db ']=$'
    mes4 db 'Perviy Vector$'
	mes4_4 db 'Vtoroy Vector$'
    mes5 db 10, 13, '$' ; переход на новую строку
    mes6 db ' $' ; пробел
    mes7 db 'kol=$'
    mes8 db 'Vvedite elementi pervogo vectora$'
	mes10 db 'Vvedite elementi vtorogo vectora$'
    mes9 db 'Sort vector$'
    mes11 db 'V vectore 1 element.$'
	mes12 db 'Vector pust kak bytilka iz pod shampanskogo;).$'
	mes13 db 'Product of elements (<>0) and (div 2 <>0)=$'
	mes14 db 'Nety takix elements.$'
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
mov ax,n
cmp ax,0
;ввод элементов вектора
out_str mes8
out_str mes5
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
mov ax,n
cmp ax,0
;ввод элементов вектора
out_str mes10
out_str mes5
mov cx,n
mov si,0
cikl1:
out_str mes2 
mov ax,si
call disp
out_str mes3
call vvod
mov a[si],bl
inc si
loop cikl1
;очистка экрана
mov ax,0002h
int 10h
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
out_str mes5
out_str mes4_4
out_str mes5
mov cx,n
mov si,0
cikl2:
mov al, a[si]
cbw
call disp
out_str mes6

inc si
loop cikl2
out_str mes5
mov cx,n
mov si,0
mov bl,0
c1:
  inc bl
  inc si
loop c1
mov kol,bl
mov cx,n ;cx=n
mov si,0
mov bl,0
c3:
mov al, mas[si]
cmp al, a[si]
jne m1
inc bl
m1:
inc si
loop c3
out_str mes7
mov al,bl
cbw
call disp
jmp m3
m3:exit
osn endp
Cseg ends
end osn