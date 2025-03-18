;Колешко Кирилл В-20
;вычислить значение выражения y=(а+4b-2)/(1-2b)
;a=3, b=2, y=(-3) (в шестнадцатиричной FD)
dseg segment para public 'data'
a dw 3
b dw 2
y dw ?
mes db 'конец программы$'
dseg ends
sseg segment para stack 'stack'
db 30 dup (0)
sseg ends
cseg segment para public 'code'
osn proc near
assume cs:cseg,ds:dseg,ss:sseg
mov ax,dseg
mov ds,ax   
    mov ax,b
    mov bx,2
    imul bx
    mov cx,1
    sub cx,ax	
    mov ax,b
	mov bx,4
	imul bx
	add ax,a
	sub ax,2
	idiv cx
    mov y,ax
lea dx,mes ;вывод сообщения 'конец программы’
mov ax,0900H
int 21H
mov ax,4C00H ;завершение программы
int 21H
osn endp
cseg ends
end osn