unit IdTestObjs;

interface

uses
  IdSys,
  IdTest,
  IdGlobal,
  IdObjs;

type

  TIdTestNativeComponent = class(TIdTest)
  published
    procedure TestOwner;
  end;

  TIdTestStringList = class(TIdTest)
  published
    procedure TestBasic;
  end;

  TIdTestStringStream = class(TIdTest)
  published
    procedure TestStream;
  end;

  TIdTestMemoryStream = class(TIdTest)
  published
    procedure TestStream;
  end;

implementation

procedure TIdTestStringStream.TestStream;
var
 aStream:TIdStringStream;
const
 cStr='123';
 cStr2='abc';
begin
 aStream:=TIdStringStream.Create(cStr);
 try
   //check initial value
   Assert(aStream.DataString=cStr);

   //check reset
   aStream.Size:=0;
   Assert(aStream.DataString='');

   //check write
   aStream.WriteString(cStr);
   Assert(aStream.DataString=cStr);
   //check append
   aStream.WriteString(cStr);
   Assert(aStream.DataString=cStr+cStr);

   //check overwrite
   //win32 replaces the entire string
   aStream.Position:=0;
   aStream.WriteString(cStr2);
   Assert(aStream.Position = Length(cStr2), Sys.IntToStr(aStream.Position));
   Assert(aStream.DataString=cStr2, AStream.DataString);

 finally
   Sys.FreeAndNil(aStream);
 end;

end;

procedure TIdTestMemoryStream.TestStream;
var
 aStream:TIdMemoryStream;
 TempBuff: TIdBytes;
const
 cStr='123';
 cStr2='abc';
begin
 aStream:=TIdMemoryStream.Create();
 try
   //check write
   TempBuff := ToBytes(cStr);
   aStream.Write(TempBuff, 0, Length(TempBuff));
   Assert(aStream.Size = 3, Sys.IntToStr(aStream.Size));
   //check append
   aStream.Write(TempBuff, 0, Length(TempBuff));
   Assert(aStream.Size = 6, Sys.IntToStr(aStream.Size));

   //check overwrite
   //win32 replaces the entire string
   aStream.Position:=0;
   TempBuff := ToBytes(cStr2);
   aStream.Write(TempBuff, 0, Length(TempBuff));
   Assert(aStream.Position = Length(cStr2), Sys.IntToStr(aStream.Position));
   Assert(AStream.Size = Length(cStr2) + Length(cStr), Sys.IntToStr(AStream.Size));

 finally
   Sys.FreeAndNil(aStream);
 end;

end;

procedure TIdTestNativeComponent.TestOwner;
//eg used to cause stack overflow in .net
//also want to test when owner<>nil. eg add a c2.
begin
{var
 c,o:TIdNativeComponent;
begin
 c:=TIdNativeComponent.Create;
 try
 o:=c.Owner;
 Assert(o=nil);
 finally
 sys.FreeAndNil(c);
 end;}
end;

procedure TIdTestStringList.TestBasic;
var
  l:TIdStringList;
  s:string;
const
  cStr='123';
  cComma='1,2,3';
  cMulti='1'+#13#10+'2'+#13#10+'3';
begin
  l:=TIdStringList.Create;
  try
    l.Text:=cStr;
    s:=l.CommaText;
    Assert(s=cStr);

    l.Text:=cMulti;
    s:=l.CommaText;
    Assert(s=cComma);

    l.CommaText:=cComma;
    s:=l.Text;
    Assert(s=cMulti+#13#10);
  finally
    Sys.FreeAndNil(l);
  end;
end;

initialization

  TIdTest.RegisterTest(TIdTestStringList);
  //TIdTest.RegisterTest(TIdTestNativeComponent);
  TIdTest.RegisterTest(TIdTestMemoryStream);
  TIdTest.RegisterTest(TIdTestStringStream);

end.
