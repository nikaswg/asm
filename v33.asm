;Лабораторная работа №3 В-1 Колешко Кирилл
;1 ветка 6xy-4y, при x+y>9
;x=1, y=10
;y=20 
;2 ветка (2xy+3+x)/(x^2+3y^2+1) при x+y<-1
;x=2, y=-5   
;y=-0,18 (в программе будет просто 0)
;3 ветка 3x^2-2y+6 , при -1<=x+y<=9
;x=2 y=2
;y=14 hex=E (в программе 0E)
Dseg segment para public 'data'
  x db 2
  y db 2
  f db ?
  mes db 'The end$'
Dseg ends
Sseg segment para stack 'stack'
  dw 30 dup(0)
Sseg ends
public x,y
extrn p1:near, p2:near, p3:near
Cseg segment para public 'code'
osn proc near
assume cs:cseg, ds: dseg, ss:sseg
  mov ax, dseg
  mov ds,ax
  mov al,x
  add al,y
  cmp al,9
  jg m1
  cmp al,-1
  jl m2
  call p3
  jmp m3
m1: call p1
  jmp m3
m2: call p2
  jmp m3 
m3: mov f,al
  lea dx,mes
  mov ah,9
  int 21H
  mov ax,4c00h
  int 21H
osn endp
Cseg ends
end osn  