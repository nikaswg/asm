program HiewStub;
{$M $4000,0,0 } {$I-}
uses Dos, Strings, Crt;

procedure WriteHexWord(w: Word);
const
  hexChars: array [0..$F] of Char =
    '0123456789ABCDEF';
begin
  Write(hexChars[Hi(w) shr 4],
        hexChars[Hi(w) and $F],
        hexChars[Lo(w) shr 4],
        hexChars[Lo(w) and $F]);
end;

procedure RunWpView(P : string);
begin
  Exec('X:\NC50\WPVIEW.EXE', P);
end;

procedure RunHiew(P : string);
begin
  Exec('X:\HIEW_611\_HIEW.EXE', '/INI=Y:\SCHOOL.PAK\HIEW.INI ' + P);
end;

function NoPseudo : Boolean;
var F : File;
    My_Byte : Byte;
    Res : Word;
begin
  NoPseudo := False;
  Assign(F, 'Y:\SCHOOL.PAK\NC.INI');
  Reset(F, 1);
  if IOResult > 0 then
    Exit;
  Seek(F, $0529);
  if IOResult > 0 then
  begin
    Close(F);
    Exit;
  end;
  BlockRead(F, My_Byte, 1, Res);
  if Res < 1 then
  begin
    Close(F);
    Exit;
  end;
  if My_Byte = 0 then NoPseudo := True;
  Close(F);
end;

var I : Integer;
    Address : String;
    Addr_Int : LongInt;
    Code : Integer;
    Info : Pointer;
    Info_Seg, Info_Ofs : Word;
begin
  {for I := 1 to ParamCount do
    Writeln(ParamStr(I));
  ReadLn;}

  if (not NoPseudo) and ((LastMode and Font8x8) = 0) then
  begin
    RunWpView(ParamStr(1) + ' ' + ParamStr(2));
  end else
  if (ParamCount = 1) and (Copy(ParamStr(1), 1, 4) = '/MEM') then
  begin
    Address := Copy(ParamStr(1), 5, 10);
    Val(Address, Addr_Int, Code);
    if Code <> 0 then
    begin
      {ExitCode := 1;}
      RunWpView(ParamStr(1));
      Exit;
    end;
    LongInt(Info) := Addr_Int;
    {WriteHexWord(Seg(Info^));
    Write(':');
    WriteHexWord(Ofs(Info^));
    WriteLn;
    ReadLn;}
    Info_Seg := Seg(Info^);
    Info_Ofs := Ofs(Info^);
    for I := 1 to 257{13} do
      if Mem[Info_Seg : Info_Ofs + I] = 0 then
      begin
        if Mem[Info_Seg : Info_Ofs + I + 15] = 0 then
        begin
          RunHiew(StrPas(PChar(Info) + 1));
          Exit;
        end else
        begin
          RunWpView(ParamStr(1));
          Exit;
        end;
      end;
    RunWpView(ParamStr(1));
  end else
  begin
    RunHiew(ParamStr(1));
  end;
end.