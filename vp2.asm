extrn x:Byte,y:Byte
public p2
Cseg segment para public 'code'
p2 proc near
  mov al,x
  imul x
  mov cl,al
  mov al,y
  mov bl,3
  imul y
  imul bl
  add cl,al
  add cl,1
  mov al,2
  imul x
  imul y
  add al,3
  add al,x
  cwd 
  idiv cl
  ret
p2 endp
Cseg ends
end