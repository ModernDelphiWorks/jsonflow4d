unit JsonFlow.TestsValue;

interface

uses
  SysUtils,
  Classes,
  DUnitX.TestFramework,
  JsonFlow.Interfaces,
  JsonFlow.Value;

type
  [TestFixture]
  TJSONValueTests = class
  public
    [Test]
    procedure TestCreateInteger;
    [Test]
    procedure TestCreateFloat;
    [Test]
    procedure TestCreateString;
    [Test]
    procedure TestCreateBoolean;
    [Test]
    procedure TestCreateNull;
    [Test]
    procedure TestAsJSON;
    [Test]
    procedure TestInvalidConversion;
    [Test]
    procedure TestStringEscaping;
    [Test]
    procedure TestClone;
    [Test]
    procedure TestSaveToStream;
    [Test]
    procedure TestSetProperties;
    [Test]
    procedure TestTypeConversions;
  end;

implementation

procedure TJSONValueTests.TestCreateInteger;
var
  LValue: IJSONValue;
begin
  LValue := TJSONValueInteger.Create(42);
  Assert.IsTrue(LValue is TJSONValueInteger, 'Tipo deve ser inteiro');
  Assert.AreEqual<Int64>(42, LValue.AsInteger);
end;

procedure TJSONValueTests.TestCreateFloat;
var
  LValue: IJSONValue;
  LExpected: Double;
begin
  LExpected := 3.14;
  LValue := TJSONValueFloat.Create(LExpected);
  Assert.IsTrue(LValue is TJSONValueFloat, 'Tipo deve ser float');
  Assert.AreEqual(LExpected, LValue.AsFloat);
end;

procedure TJSONValueTests.TestCreateString;
var
  LValue: IJSONValue;
begin
  LValue := TJSONValueString.Create('Test');
  Assert.IsTrue(LValue is TJSONValueString, 'Tipo deve ser string');
  Assert.AreEqual('Test', LValue.AsString);
end;

procedure TJSONValueTests.TestCreateBoolean;
var
  LValue: IJSONValue;
begin
  LValue := TJSONValueBoolean.Create(True);
  Assert.IsTrue(LValue is TJSONValueBoolean, 'Tipo deve ser boolean');
  Assert.IsTrue(LValue.AsBoolean);
end;

procedure TJSONValueTests.TestCreateNull;
var
  LValue: IJSONElement;
begin
  LValue := TJSONValueNull.Create;
  Assert.IsTrue(LValue is TJSONValueNull, 'Tipo deve ser null');
end;

procedure TJSONValueTests.TestAsJSON;
var
  LValue: IJSONValue;
begin
  LValue := TJSONValueInteger.Create(42);
  Assert.AreEqual('42', LValue.AsJSON);
  LValue := TJSONValueString.Create('Test');
  Assert.AreEqual('"Test"', LValue.AsJSON);
  LValue := TJSONValueBoolean.Create(True);
  Assert.AreEqual('true', LValue.AsJSON);
  LValue := TJSONValueNull.Create;
  Assert.AreEqual('null', LValue.AsJSON);
end;

procedure TJSONValueTests.TestStringEscaping;
var
  LValue: IJSONValue;
begin
  LValue := TJSONValueString.Create('Test "quote" \ backslash'#13#10);
  Assert.AreEqual('"Test \"quote\" \\ backslash\r\n"', LValue.AsJSON);
end;

procedure TJSONValueTests.TestInvalidConversion;
var
  LValue: IJSONValue;
begin
  LValue := TJSONValueNull.Create;
  Assert.WillRaise(
    procedure
    begin
      LValue.AsInteger;
    end, EConvertError);
end;

procedure TJSONValueTests.TestSetProperties;
var
  LValue: IJSONValue;
  DExpected: Double;
begin
  DExpected := 3.14;
  LValue := TJSONValueString.Create('');
  LValue.AsInteger := 42;
  Assert.AreEqual<Int64>(42, LValue.AsInteger);
  LValue.AsFloat := 3.14;
  Assert.AreEqual(DExpected, LValue.AsFloat);
  LValue.AsString := 'Test';
  Assert.AreEqual('Test', LValue.AsString);
  LValue.AsBoolean := True;
  Assert.IsTrue(LValue.AsBoolean);
end;

procedure TJSONValueTests.TestTypeConversions;
var
  LValue: IJSONValue;
  SExpected: String;
  DExpected: Double;
begin
  SExpected := '42';
  DExpected := 1.0;
  LValue := TJSONValueString.Create('123');
  Assert.AreEqual<Int64>(123, LValue.AsInteger);
  LValue := TJSONValueBoolean.Create(True);
  Assert.AreEqual(DExpected, LValue.AsFloat);
  LValue := TJSONValueInteger.Create(42);
  Assert.AreEqual(SExpected, LValue.AsString);
end;

procedure TJSONValueTests.TestSaveToStream;
var
  LValue: IJSONValue;
  LStream: TStringStream;
begin
  LValue := TJSONValueString.Create('Test');
  LStream := TStringStream.Create('');
  try
    LValue.SaveToStream(LStream);
    Assert.AreEqual('"Test"', LStream.DataString);
  finally
    LStream.Free;
  end;
end;

procedure TJSONValueTests.TestClone;
var
  LValue, LClone: IJSONValue;
begin
  LValue := TJSONValueString.Create('Original');
  LClone := LValue.Clone as IJSONValue;
  Assert.AreEqual('Original', LClone.AsString);
  LClone.AsString := 'Modified';
  Assert.AreEqual('Original', LValue.AsString);
end;

initialization
  TDUnitX.RegisterTestFixture(TJSONValueTests);

end.
