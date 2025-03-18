extrn x:Byte,y:Byte
public p1
Cseg segment para public 'code'
p1 proc near
  mov al,4
  imul y
  mov bl,al
  mov al,6
  imul x
  imul y
  sub al,bl
  ret 
p1 endp
Cseg ends
end 