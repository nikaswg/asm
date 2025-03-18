uses crt;
var
  x,y,f: shortint;
function p1(x,y: shortint): shortint; assembler;
asm
  mov al,4
  imul y
  mov bl,al
  mov al,6
  imul x
  imul y
  sub al,bl
end;

function p2(x,y: shortint):shortint; assembler;
asm
  mov al,x
  imul x
  mov cl,al
  mov al,y
  mov bl,3
  imul y
  imul bl
  add cl,al
  add cl,1
  mov dl,cl
  mov al,2
  imul x
  imul y
  add al,3
  add al,x
  cwd
  idiv dl
  mov al,0
end;

function p3(x,y: shortint): shortint; assembler;
asm
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
end;
begin
  clrscr;
  write('Введите x,y -->');
  readln(x,y);
  if x+y>9 then
    f:=p1(x,y)
  else if x+y<-1 then
    f:=p2(x,y)
  else
    f:=p3(x,y);
  writeln('f=',f);
  readln;
end.

