extrn x:Byte,y:Byte
public p3
Cseg segment para public 'code'
p3 proc near 
  mov al,x
  imul x
  mov bl,3
  imul bl 
  mov dl,al
  mov al,y
  mov bl,2
  imul bl
  sub dl,al
  mov al,dl
  add al,6
  ret
p3 endp
Cseg ends
end   