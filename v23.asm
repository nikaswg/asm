;Колешко Кирилл В-20
;вычислить значение выражения y=(а+4b-2)/(1-2b)
;a=3, b=2, y=(-3) (в шестнадцатиричной FD)
masm
model small
.data
a db 3
b db 2
y db ?
mes db 'конец программы$'
.stack
db 30 dup (0)
.code
osn proc near
mov ax,@data 
mov ds,ax                
    mov al,b
    mov bl,2
    imul bl
    mov cl,1
    sub cl,al	
    mov al,b
	mov bl,4
	imul bl
	add al,a
	sub al,2
	idiv cl
    mov y,al

lea dx,mes ;вывод сообщения 'конец программы’
mov ax,0900H
int 21H
mov ax,4C00H ;завершение программы
int 21H
osn endp
end osn