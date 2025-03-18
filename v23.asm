;Кущ Владислав В-9
;вычислить значение выражения y=((3a-b)+3a)/(b-4)
;a=4, b=6, y=9
masm
model small
.data
a db 4
b db 6
y db ?
mes db 'конец программы$'
.stack
db 30 dup (0)
.code
osn proc near
mov ax,@data 
mov ds,ax                
	mov al,b
	sub al,4
	mov cl,al
    mov al,a
	mov bl,3
	imul bl
	mov dl,al
	sub al,b
	add al,dl
	cwd
	idiv cl
	mov y,al

lea dx,mes ;вывод сообщения 'конец программы’
mov ax,0900H
int 21H
mov ax,4C00H ;завершение программы
int 21H
osn endp
end osn