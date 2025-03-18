;Кущ Владислав ЛР-5 В-9
;(2*(a-4b)-5b)/2
;a=20 b=2 y=7
dseg segment para public 'data'
 a db 20
 b db 2
 y db ?
 mesa db 10,13,'a=$'
 mesb db 10,13,'b=$'
 mesy db 10,13,'y=$'
dseg ends
sseg segment para stack 'stack'
 db 256 dup (0)
sseg ends
 extrn disp:near
cseg segment para public 'code'
 main proc near
 assume cs:cseg, ds:dseg, ss:sseg
 mov ax,dseg
 mov ds,ax
 mov al,b ;al=b
 sal al,2 ;al=4b
 mov bl,al
 mov al,a
 sub al,bl
 sal al,1
 mov bl,al
 mov al,b
 mov cl,5
 imul cl
 mov cl,al
 mov al,bl
 sub al,cl
 sar al,1
 mov y,al ;y=al
 lea dx,mesa
 mov ax,0900H
 int 21H
 mov al,a
 cbw
 call disp
 lea dx,mesb
 mov ax,0900H
 int 21H
 mov al,b
 cbw
 call disp
 lea dx,mesy
 mov ax,0900H
 int 21H
 mov al,y
 cbw
 call disp
 mov ax,4C00H
 int 21H
main endp
cseg ends
end main 