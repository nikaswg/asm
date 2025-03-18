unit charis;

interface

procedure Left;
procedure Lefts(Count:integer);
procedure Right;
procedure Rights(Count:integer);
procedure Up;
procedure Ups(Count:integer);
procedure Down;
procedure Downs(Count:integer);
procedure RightUp;
procedure RightUps(Count:integer);
procedure RightDown;
procedure RightDowns(Count:integer);
procedure LeftUp;
procedure LeftUps(Count:integer);
procedure LeftDown;
procedure LeftDowns(Count:integer);
{swap names}
procedure UpRight;
procedure UpRights(Count:integer);
procedure DownRight;
procedure DownRights(Count:integer);
procedure UpLeft;
procedure UpLefts(Count:integer);
procedure DownLeft;
procedure DownLefts(Count:integer);


procedure Circle;
procedure Bar;
procedure Jump;
procedure Jumps(Count:integer);
procedure JumpDown;
procedure JumpDowns(Count:integer);
procedure JumpZero;
procedure Worm;
procedure Turttle;
procedure Pause;
procedure Finish;
procedure Draw(s:string);
function getCRC:longint;
function getLen:longint;
procedure Turt;



procedure B;
procedure P;
procedure C;
procedure W;
procedure T;

procedure U;
procedure D;
procedure R;
procedure L;

procedure Us(Count:integer);
procedure Ds(Count:integer);
procedure Rs(Count:integer);
procedure Ls(Count:integer);

procedure J;
procedure Js(Count:integer);
procedure JD;
procedure JDs(Count:integer);
procedure JZ;


procedure UR;
procedure URs(Count:integer);
procedure DR;
procedure DRs(Count:integer);
procedure UL;
procedure ULs(Count:integer);
procedure DL;
procedure DLs(Count:integer);
procedure RU;
procedure RUs(Count:integer);
procedure RD;
procedure RDs(Count:integer);
procedure LU;
procedure LUs(Count:integer);
procedure LD;
procedure LDs(Count:integer);


var
  i,i1,i2,i3:longint;

function N:longint;
function M:longint;
















Type Proc = Procedure;

procedure F(pr:proc;counter:integer);
procedure ForN(pr:proc;counter:integer);


implementation


(*SRV*)

uses graph;

{ egavga is not needed under freepascal! }
{$L egavga.obj}
procedure EGAVGA;external;

(**)

procedure F(pr:proc;counter:integer);
begin
  ForN(pr,counter);
end;

procedure T;                      Begin Turttle;          End;
procedure W;                      Begin Worm;          End;
procedure C;                      Begin Circle;          End;
procedure P;                      Begin Bar;          End;
procedure B;                      Begin Bar;          End;


procedure U;                      Begin Up;          End;
procedure D;                      Begin Down;          End;
procedure R;                      Begin Right;          End;
procedure L;                      Begin Left;          End;

procedure Us(Count:integer);      Begin Ups(Count);  End;
procedure Ds(Count:integer);      Begin Downs(Count);  End;
procedure Rs(Count:integer);      Begin Rights(Count);  End;
procedure Ls(Count:integer);      Begin Lefts(Count);  End;


procedure UR;                      Begin RightUp;          End;
procedure URs(Count:integer);      Begin RightUps(Count);  End;
procedure DR;                      Begin RightDown;        End;
procedure DRs(Count:integer);      Begin RightDowns(Count) End;
procedure UL;                      Begin LeftUp;           End;
procedure ULs(Count:integer);       Begin LeftUps(Count);   End;
procedure DL;                      Begin LeftDown;         End;
procedure DLs(Count:integer);      Begin LeftDowns(Count); End;
procedure RU;                      Begin RightUp;          End;
procedure RUs(Count:integer);      Begin RightUps(Count);  End;
procedure RD;                      Begin RightDown;        End;
procedure RDs(Count:integer);      Begin RightDowns(Count) End;
procedure LU;                      Begin LeftUp;           End;
procedure LUs(Count:integer);       Begin LeftUps(Count);   End;
procedure LD;                      Begin LeftDown;         End;
procedure LDs(Count:integer);      Begin LeftDowns(Count); End;
procedure J;                       Begin Jump;           End;
procedure Js(Count:integer);       Begin Jumps(Count);   End;
procedure JD;                      Begin JumpDown;         End;
procedure JDs(Count:integer);      Begin JumpDowns(Count); End;
procedure JZ;                      Begin JumpZero;         End;






procedure UpRight;                      Begin RightUp;          End;
procedure UpRights(Count:integer);      Begin RightUps(Count);  End;
procedure DownRight;                    Begin RightDown;        End;
procedure DownRights(Count:integer);    Begin RightDowns(Count) End;
procedure UpLeft;                       Begin LeftUp;           End;
procedure UpLefts(Count:integer);       Begin LeftUps(Count);   End;
procedure DownLeft;                     Begin LeftDown;         End;
procedure DownLefts(Count:integer);     Begin LeftDowns(Count); End;


var valN,valM:longint;


procedure readNM;
var ft:text;
begin
  assign(ft,'charis.in');reset(ft);
  if(not eof(ft)) then read(ft,valN);
  if(not eof(ft)) then read(ft,valM);
end;

function N:longint;
begin
  if(valN<0)then
(*SRV*)
  begin
    Writeln('Enter value N:'); ReadLn(valN);
  end;
    {
    readNM;
}
  N:=valN;
end;

function M:longint;
begin
  if(valM<0)then
(*SRV*)
  begin
    Writeln('Enter value M:'); ReadLn(valM);
  end;
    {
    readNM;
}
  M:=valM;
end;

var
dx,dy,maxx,maxy,barSizeX,barSizeY:integer;
Xpos,Ypos:integer;
prevXpos,prevYpos:integer;

crcWorm:longint;
crcTurttle:longint;

crcO:longint;

crc2:longint;

{flags for CRC turttle}
fl:array[0..11000] of byte;

{flags for CRC worm}
flwx:array[0..10000] of integer;
flwy:array[0..10000] of integer;
flwc:integer;


{array for store program}
s:array[0..10000] of byte;
scount:integer;

isWorm : integer;


procedure ForN(pr:proc;counter:integer);
var i:integer;
Begin
  for i:=1 to counter do pr;
end;


procedure redraw; forward;

procedure PrepareLine;
begin
  prevXpos := Xpos;
  prevYpos := Ypos;
end;

procedure FinishLine;
var a1,a2,i,j:longint;
begin

(*SRV*)
  setColor(Blue);

(**)
  a1 := prevxpos*100+prevypos;
  a2 := xpos*100+ypos;

  if(a2<a1) then
  begin
    i:=a1;
    a1:=a2;
    a2:=i;
  end;

  if(isWorm=0) then
  begin


    if a1<>a2 then
    begin
      j:=0;
      i:=1;
      while i<=flwc do
      begin
        if(flwx[i]=a1) and (flwy[i]=a2) then
        begin
          j:=j+1;
        end;
        i:=i+1;
      end;

      if(j=0) then
      begin
        crcWorm := crcWorm + (a1+7)*(a2+7)+a1+a2;
        crc2 :=  crc2 + a1 + a2;
        flwc:=flwc+1;
        flwx[flwc]:=a1;
        flwy[flwc]:=a2;

{        writeln((a1+7)*(a2+7)+a1+a2,' ',a1,' ',a2,'=',crcWorm);}



      end;
    end;

(*SRV*)
    SetLineStyle(0,0,3);
    moveto((prevxpos+0)*barsizex+dx,(prevypos+0)*barsizey+dy);
    lineto((xpos+0)*barsizex+dx,(ypos+0)*barsizey+dy);


    moveto((prevxpos+0)*barsizex+dx-1,(prevypos+0)*barsizey+dy-1);
    lineto((xpos+0)*barsizex+dx    -1,(ypos+0)*barsizey+dy    -1);

    moveto((prevxpos+0)*barsizex+dx+1,(prevypos+0)*barsizey+dy+1);
    lineto((xpos+0)*barsizex+dx    +1,(ypos+0)*barsizey+dy    +1);

    moveto((prevxpos+0)*barsizex+dx+1,(prevypos+0)*barsizey+dy-1);
    lineto((xpos+0)*barsizex+dx    +1,(ypos+0)*barsizey+dy    -1);

    moveto((prevxpos+0)*barsizex+dx-1,(prevypos+0)*barsizey+dy+1);
    lineto((xpos+0)*barsizex+dx    -1,(ypos+0)*barsizey+dy    +1);
(**)
  end
  else
  begin

    if fl[a1]=0 then begin crcTurttle:=crcTurttle+31*(a1+7); crc2:=crc2 + a1; end;
    fl[a1]:=1;
    if fl[a2]=0 then begin crcTurttle:=crcTurttle+31*(a2+7); crc2:=crc2 + a2; end;
    fl[a2]:=1;



(*SRV*)
    setfillstyle(0,blue);

    graph.bar((prevxpos+0)*barsizex+dx+1,(prevypos+0)*barsizey+dy+1,
        (prevxpos+1)*barsizex+dx-1,(prevypos+1)*barsizey+dy-1);
    graph.bar((xpos+0)*barsizex+dx+1,(ypos+0)*barsizey+dy+1,
        (xpos+1)*barsizex+dx-1,(ypos+1)*barsizey+dy-1);
(**)
  end


end;

function getLen:longint;
var i,j:longint;
begin
  j:=0;
  for i:=1 to scount do
    if (s[i]=0)or(s[i]=11)or(s[i]=12) then else j:=j+1;
  getLen := j;
end;

function getCRC2:longint;
var i,j:longint;
begin
  getCRC2 := ((crcTurttle+crcWorm+crcO + crc2) mod 10000000+47)*31;
end;


procedure checkSize(i:integer);
var out:text;
begin
  scount:= scount + 1;
  if(scount>sizeof(s)-2) then halt;
  s[scount] := i;

(*SRV*)
  if(xpos+isWorm>maxx) or (ypos+isWorm>maxy) then redraw;
  {
  assign(out,'charis.out');rewrite(out);
  writeln(out,getCrc2);
  close(out);
  assign(out,'charsize.out');rewrite(out);
  writeln(out,getCrc2,' ',getLen);
  close(out);
  }
end;


procedure Left;
begin
  prepareLine;
  xpos:=xpos-1;
  finishLine;

  checkSize(2);

end;

procedure Lefts(Count:integer);
var i:integer;
begin
  for i:=1 to count do left;
end;

procedure Right;
begin
  prepareLine;
  xpos:=xpos+1;
  finishLine;

  checkSize(1);

end;

procedure Rights(Count:integer);
var i:integer;
begin
  for i:=1 to count do Right;
end;

procedure Up;
begin
  prepareLine;
  ypos:=ypos-1;
  finishLine;

  checkSize(3);
end;

procedure Ups(Count:integer);
var i:integer;
begin
  for i:=1 to count do Up;
end;

procedure Down;
begin
  prepareLine;
  ypos:=ypos+1;
  finishLine;

  checkSize(4);
end;

procedure Downs(Count:integer);
var i:integer;
begin
  for i:=1 to count do Down;
end;

procedure RightUp;
begin
  prepareLine;
  ypos:=ypos-1;
  xpos:=xpos+1;
  finishLine;

  checkSize(5);
end;

procedure RightUps(Count:integer);
var i:integer;
begin
  for i:=1 to count do RightUp;
end;

procedure RightDown;
begin
  prepareLine;
  ypos:=ypos+1;
  xpos:=xpos+1;
  finishLine;

  checkSize(6);

end;

procedure RightDowns(Count:integer);
var i:integer;
begin
  for i:=1 to count do RightDown;
end;



procedure LeftUp;
begin
  prepareLine;
  ypos:=ypos-1;
  xpos:=xpos-1;
  finishLine;

  checkSize(7);
end;

procedure LeftUps(Count:integer);
var i:integer;
begin
  for i:=1 to count do LeftUp;
end;

procedure LeftDown;
begin
  prepareLine;
  ypos:=ypos+1;
  xpos:=xpos-1;
  finishLine;

  checkSize(8);
end;

procedure LeftDowns(Count:integer);
var i:integer;
begin
  for i:=1 to count do LeftDown;
end;

procedure Circle;
var a1,a2:longint;
begin
  prepareLine;
  finishLine;

  a1 := prevxpos*100+prevypos;
  a2 := xpos*100+ypos;

  crcO := crcO + (a1+7)*(a2+7)+a1+a2+1;

(*SRV*)
  graph.circle((prevxpos+0)*barsizex+dx+barsizex div 2,(prevypos+0)*barsizey+dy+barsizey div 2,barsizex div 3);
(**)

  checkSize(9);
end;

procedure Bar;
var a2:longint;
begin

(*SRV*)
    graph.bar((xpos+0)*barsizex+dx+1,(ypos+0)*barsizey+dy+1,
        (xpos+1)*barsizex+dx-1,(ypos+1)*barsizey+dy-1);
(**)
    a2 := xpos*100+ypos;
    if fl[a2]=0 then begin crcTurttle:=crcTurttle+31*(a2+7); crc2:=crc2+a2; end;
    fl[a2]:=1;


  checkSize(13);
end;







procedure Jump;
var i:integer;
begin

  i:=isWorm;

  isWorm:=0;
  prepareLine;
  finishLine;
  isWorm:=i;
  xpos:=xpos+1;

  checkSize(10);
end;

procedure Jumps(Count:integer);
var i:integer;
begin
  for i:=1 to count do Jump;
end;

procedure JumpDown;
var i:integer;
begin

  i:=isWorm;

  isWorm:=0;
  prepareLine;
  finishLine;
  isWorm:=i;
  ypos:=ypos+1;

  checkSize(14);
end;

procedure JumpZero;
var i:integer;
begin

  i:=isWorm;

  isWorm:=0;
  prepareLine;
  finishLine;
  isWorm:=i;
  ypos:=0;
  xpos:=0;

  checkSize(15);
end;

procedure JumpDowns(Count:integer);
var i:integer;
begin
  for i:=1 to count do JumpDown;
end;


procedure Worm;
begin
  checkSize(11);
  isWorm:=0;
end;

procedure Turttle;
begin
  checkSize(12);
  isWorm:=1;
end;

procedure Turt;
begin
  Turttle;
end;

procedure Finish;
begin
  Pause;
end;

procedure Pause;
begin

(*SRV*)
  readln;
  closegraph;
(**)
  checksize(0);
end;

procedure grid;
var i,j,gm,gd:integer;
begin
  isWorm := 0;

  xpos := 0;
  ypos := 0;

  barSizex := 3;
  barSizey := 3;

(*SRV*)
  barSizex := (getmaxy-dy-dy) div (maxy);

  i := (getmaxX-dx-dx) div (maxx);

  if(i<barSizeX) then barSizeX := i;

  barsizey := barsizex;

  i:=getmaxy;

  if(getmaxx=639) and(getmaxy=479) then barSizex:=longint(barSizeX)*1000 div 1200;

  setcolor(white);
  SetLineStyle(0,0,1);
  for i:=0 to getmaxx do
  begin
    moveto(i,0);
    lineto(i, getmaxy);
  end;

  setcolor(lightgray);
  for i:=0 to maxx-1 do
  for j:=0 to maxy-1 do
  begin
    moveto((i+0)*barsizex+dx,(j+0)*barsizey+dy);
    lineto((i+0)*barsizex+dx,(j+1)*barsizey+dy);
    lineto((i+1)*barsizex+dx,(j+1)*barsizey+dy);
    lineto((i+1)*barsizex+dx,(j+0)*barsizey+dy);
    lineto((i+0)*barsizex+dx,(j+0)*barsizey+dy);
  end;

(**)

  {for set line style}
  prepareLine;
  finishLine;

end;

procedure redraw;
var i,j:integer;
begin

  while (xPos>=maxX) do maxX:=maxX+8;
  while (yPos>=maxy) do maxY:=maxY+8;

  grid;
  isWorm := 0;

  j := scount;
  scount := 0;

  crcO:=0;
  crcWorm:=0;
  crcTurttle:=0;

  for i:=0 to sizeof(fl) do fl[i]:=0;
  for i:=0 to sizeof(flwx) div sizeof(integer) do flwx[i]:=0;
  for i:=0 to sizeof(flwy) div sizeof(integer) do flwy[i]:=0;
  flwc:=0;



  for i:=1 to j do
  case s[i] of
    1: Right;
    2: Left;
    3: Up;
    4: Down;
    5: RightUp;
    6: RightDown;
    7: LeftUp;
    8: LeftDown;
    9: Circle;
    10: Jump;
    11: Worm;
    12: Turttle;
    13: Bar;
    14: JumpDown;
    15: JumpZero;
  end;
end;

procedure prepareSpace;
var i,j,gm,gd:integer;
begin

  scount := 0;
  crcO:=0;
  crcWorm:=0;
  crcTurttle:=0;

  dx := 10;
  dy := 10;

(*SRV*)
{ egavga is not needed under freepascal! }
  If RegisterBGIDriver(@EGAVGA) < 0 Then
  Begin
    Writeln('Error openning graphics:', GraphErrorMsg(GraphResult));
    Halt(1);
  End;

  gd := detect;
  initgraph(gd,gm,'');


  maxx := 8;
  maxy := 8;

  grid;
  {
  maxx := 50;
  maxy := 50;

}
end;


procedure Draw(s:string);
var d:string;
    count:integer;
begin
  d:='';
  while(length(s)>0) do
  begin
    count := 1;
    d:=s[1];
    if(d='(') and (length(s)>3) and (s[4]=')') then
    begin
      d := copy(s,2,2);
      delete(s,1,4);
    end
    else
    begin
      delete(s,1,1);
    end;
    if(length(s)>0) and (s[1]>'0') and (s[1]<='9') then
    begin
      count := byte(s[1])-byte('0');
      delete(s,1,1);
    end;

    if(d='C') then Circle;
    if(d='J') then Jumps(count);
    if(d='R') then Rights(count);
    if(d='L') then Lefts(count);
    if(d='U') then Ups(count);
    if(d='D') then Downs(count);
    if(d='RU') then RightUps(count);
    if(d='RD') then RightDowns(count);
    if(d='LU') then LeftUps(count);
    if(d='LD') then LeftDowns(count);
    if(d='UR') then RightUps(count);
    if(d='DR') then RightDowns(count);
    if(d='UL') then LeftUps(count);
    if(d='DL') then LeftDowns(count);
    if(d='W') then Worm;
    if(d='T') then Turttle;
    if(d='P') then Bar;
    if(d='B') then Bar;

    if(d='JD') then JumpDowns(count);
    if(d='JZ') then JumpZero;



  end;
end;

function getCRC:longint;
var i,j:longint;
begin
  i := ((crcTurttle+crcWorm) mod 90000) + 10000;

{  writeln(i);
  writeln(crco);
}
  j:= ((i+crcO) mod 9)+1;
  if(crcO=0) then  j := i mod 10;

  i := (i div 10)*10 + j;

  getCRC := i;

end;

begin
  valN:=-1;
  valM:=-1;
  PrepareSpace;
end.
