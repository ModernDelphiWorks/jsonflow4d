{$R+}

unit JsonFlow.TestsSerializer;

interface

uses
  DUnitX.TestFramework,
  SysUtils,
  JsonFlow.Interfaces,
  JsonFlow.Value,
  JsonFlow.Objects,
  JsonFlow.Arrays,
  JsonFlow.Serializer;

type
  TTestNestedArrayClass = class
  private
    FNestedScores: TArray<TArray<Double>>;
  public
    property NestedScores: TArray<TArray<Double>> read FNestedScores write FNestedScores;
  end;

  TTestSimpleClass = class
  private
    FName: String;
    FAge: Integer;
    FIsActive: Boolean;
    FScore: Double;
  public
    property Name: String read FName write FName;
    property Age: Integer read FAge write FAge;
    property IsActive: Boolean read FIsActive write FIsActive;
    property Score: Double read FScore write FScore;
  end;

  TTestNestedClass = class
  private
    FInner: TTestSimpleClass;
    FScores: TArray<Double>;
  public
    property Inner: TTestSimpleClass read FInner write FInner;
    property Scores: TArray<Double> read FScores write FScores;
  end;

  [TestFixture]
  TJSONSerializerTests = class
  public
    [Test]
    procedure TestSerializeSimpleObject;
    [Test]
    procedure TestDeserializeSimpleObject;
    [Test]
    procedure TestSerializeWithClassName;
    [Test]
    procedure TestSerializeNullObjectException;
    [Test]
    procedure TestDeserializeNullObjectException;
    [Test]
    procedure TestDeserializeNullElementException;
    [Test]
    procedure TestDeserializeInvalidElementException;
    [Test]
    procedure TestSerializeNestedObject;
    [Test]
    procedure TestDeserializeNestedObject;
    [Test]
    procedure TestSerializeArray;
    [Test]
    procedure TestDeserializeArray;
    [Test]
    procedure TestDeserializeNestedArray;
  end;

implementation

procedure TJSONSerializerTests.TestSerializeSimpleObject;
var
  LSerializer: TJSONSerializer;
  LObj: TTestSimpleClass;
  LJson: IJSONElement;
begin
  LSerializer := TJSONSerializer.Create;
  try
    LObj := TTestSimpleClass.Create;
    try
      LObj.Name := 'João';
      LObj.Age := 30;
      LObj.IsActive := True;
      LObj.Score := 95.5;
      LJson := LSerializer.FromObject(LObj);
      Assert.AreEqual('{"Name":"João","Age":30,"IsActive":true,"Score":95.5}', LJson.AsJSON);
    finally
      LObj.Free;
    end;
  finally
    LSerializer.Free;
  end;
end;

procedure TJSONSerializerTests.TestDeserializeSimpleObject;
var
  LSerializer: TJSONSerializer;
  LObj: TTestSimpleClass;
  LJson: IJSONObject;
  LExpected: Double;
begin
  LExpected := 95.5;
  LSerializer := TJSONSerializer.Create;
  try
    LObj := TTestSimpleClass.Create;
    try
      LJson := TJSONObject.Create;
      LJson.Add('Name', TJSONValueString.Create('João'));
      LJson.Add('Age', TJSONValueInteger.Create(30));
      LJson.Add('IsActive', TJSONValueBoolean.Create(True));
      LJson.Add('Score', TJSONValueFloat.Create(95.5));
      Assert.IsTrue(LSerializer.ToObject(LJson, LObj));
      Assert.AreEqual('João', LObj.Name);
      Assert.AreEqual(30, LObj.Age);
      Assert.IsTrue(LObj.IsActive);
      Assert.AreEqual(LExpected, LObj.Score);
    finally
      LObj.Free;
    end;
  finally
    LSerializer.Free;
  end;
end;

procedure TJSONSerializerTests.TestSerializeWithClassName;
var
  LSerializer: TJSONSerializer;
  LObj: TTestSimpleClass;
  LJson: IJSONElement;
begin
  LSerializer := TJSONSerializer.Create;
  try
    LObj := TTestSimpleClass.Create;
    try
      LObj.Name := 'João';
      LJson := LSerializer.FromObject(LObj, True);
      Assert.AreEqual('{"$class":"TTestSimpleClass","Name":"João","Age":0,"IsActive":false,"Score":0}', LJson.AsJSON);
    finally
      LObj.Free;
    end;
  finally
    LSerializer.Free;
  end;
end;

procedure TJSONSerializerTests.TestSerializeNullObjectException;
var
  LSerializer: TJSONSerializer;
begin
  LSerializer := TJSONSerializer.Create;
  try
    Assert.WillRaise(
      procedure
      begin
        LSerializer.FromObject(nil);
      end, EArgumentNilException);
  finally
    LSerializer.Free;
  end;
end;

procedure TJSONSerializerTests.TestDeserializeNullObjectException;
var
  LSerializer: TJSONSerializer;
  LJson: IJSONObject;
begin
  LSerializer := TJSONSerializer.Create;
  try
    LJson := TJSONObject.Create;
    Assert.WillRaise(
      procedure
      begin
        LSerializer.ToObject(LJson, nil);
      end, EArgumentNilException);
  finally
    LSerializer.Free;
  end;
end;

procedure TJSONSerializerTests.TestDeserializeNullElementException;
var
  LSerializer: TJSONSerializer;
  LObj: TTestSimpleClass;
begin
  LSerializer := TJSONSerializer.Create;
  try
    LObj := TTestSimpleClass.Create;
    try
      Assert.WillRaise(
        procedure
        begin
          LSerializer.ToObject(nil, LObj);
        end, EArgumentNilException);
    finally
      LObj.Free;
    end;
  finally
    LSerializer.Free;
  end;
end;

procedure TJSONSerializerTests.TestDeserializeInvalidElementException;
var
  LSerializer: TJSONSerializer;
  LObj: TTestSimpleClass;
  LInvalidElement: IJSONElement;
begin
  LSerializer := TJSONSerializer.Create;
  try
    LObj := TTestSimpleClass.Create;
    try
      LInvalidElement := TJSONValueString.Create('not an object');
      Assert.WillRaise(
        procedure
        begin
          LSerializer.ToObject(LInvalidElement, LObj);
        end, EArgumentException);
    finally
      LObj.Free;
    end;
  finally
    LSerializer.Free;
  end;
end;

procedure TJSONSerializerTests.TestSerializeNestedObject;
var
  LSerializer: TJSONSerializer;
  LObj: TTestNestedClass;
  LJson: IJSONElement;
begin
  LSerializer := TJSONSerializer.Create;
  try
    LObj := TTestNestedClass.Create;
    try
      LObj.Inner := TTestSimpleClass.Create;
      LObj.Inner.Name := 'João';
      LObj.Inner.Age := 30;
      LJson := LSerializer.FromObject(LObj);
      Assert.AreEqual('{"Inner":{"Name":"João","Age":30,"IsActive":false,"Score":0},"Scores":[]}', LJson.AsJSON);
    finally
      LObj.Inner.Free;
      LObj.Free;
    end;
  finally
    LSerializer.Free;
  end;
end;

procedure TJSONSerializerTests.TestDeserializeNestedObject;
var
  LSerializer: TJSONSerializer;
  LObj: TTestNestedClass;
  LJson: IJSONObject;
  LInnerJson: IJSONObject;
begin
  LSerializer := TJSONSerializer.Create;
  try
    LObj := TTestNestedClass.Create;
    try
      LObj.Inner := TTestSimpleClass.Create;
      LJson := TJSONObject.Create;
      LInnerJson := TJSONObject.Create;
      LInnerJson.Add('Name', TJSONValueString.Create('João'));
      LInnerJson.Add('Age', TJSONValueInteger.Create(30));
      LJson.Add('Inner', LInnerJson);
      LJson.Add('Scores', TJSONArray.Create);
      Assert.IsTrue(LSerializer.ToObject(LJson, LObj));
      Assert.AreEqual('João', LObj.Inner.Name);
      Assert.AreEqual(30, LObj.Inner.Age);
    finally
      LObj.Inner.Free;
      LObj.Free;
    end;
  finally
    LSerializer.Free;
  end;
end;

procedure TJSONSerializerTests.TestSerializeArray;
var
  LSerializer: TJSONSerializer;
  LObj: TTestNestedClass;
  LJson: IJSONElement;
  LScores: TArray<Double>;
begin
  LSerializer := TJSONSerializer.Create;
  try
    LObj := TTestNestedClass.Create;
    try
      SetLength(LScores, 2);
      LScores[0] := 95.5;
      LScores[1] := 88.0;
      LObj.Scores := LScores;
      LJson := LSerializer.FromObject(LObj);
      Assert.AreEqual('{"Inner":null,"Scores":[95.5,88]}', LJson.AsJSON);
    finally
      LObj.Free;
    end;
  finally
    LSerializer.Free;
  end;
end;

procedure TJSONSerializerTests.TestDeserializeArray;
var
  LSerializer: TJSONSerializer;
  LObj: TTestNestedClass;
  LJson: IJSONObject;
  LArr: IJSONArray;
  LExpected0: Double;
  LExpected1: Double;
begin
  LExpected0 := 95.5;
  LExpected1 := 88.0;
  LSerializer := TJSONSerializer.Create;
  try
    LObj := TTestNestedClass.Create;
    try
      LArr := TJSONArray.Create;
      LArr.Add(TJSONValueFloat.Create(95.5));
      LArr.Add(TJSONValueFloat.Create(88.0));
      LJson := TJSONObject.Create;
      LJson.Add('Scores', LArr);
      Assert.IsTrue(LSerializer.ToObject(LJson, LObj));
      Assert.AreEqual(2, Length(LObj.Scores));
      Assert.AreEqual(LExpected0, LObj.Scores[0]);
      Assert.AreEqual(LExpected1, LObj.Scores[1]);
    finally
      LObj.Free;
    end;
  finally
    LSerializer.Free;
  end;
end;

procedure TJSONSerializerTests.TestDeserializeNestedArray;
var
  LSerializer: TJSONSerializer;
  LObj: TTestNestedArrayClass;
  LJson: IJSONObject;
  LOuterArr, LInnerArr1, LInnerArr2: IJSONArray;
  LExpected: Double;
begin
  LSerializer := TJSONSerializer.Create;
  LSerializer.OnLog(procedure(AMessage: string)
                    begin
                      Writeln('LOG: ' + AMessage);
                    end);
  try
    LObj := TTestNestedArrayClass.Create;
    try
      LOuterArr := TJSONArray.Create;
      LInnerArr1 := TJSONArray.Create;
      LInnerArr1.Add(TJSONValueFloat.Create(95.5));
      LInnerArr1.Add(TJSONValueFloat.Create(88.0));
      LInnerArr2 := TJSONArray.Create;
      LInnerArr2.Add(TJSONValueFloat.Create(75.0));
      LInnerArr2.Add(TJSONValueFloat.Create(82.5));
      LOuterArr.Add(LInnerArr1);
      LOuterArr.Add(LInnerArr2);
      LJson := TJSONObject.Create;
      LJson.Add('NestedScores', LOuterArr);
      Assert.IsTrue(LSerializer.ToObject(LJson, LObj));
      Assert.AreEqual(2, Length(LObj.NestedScores));
      Assert.AreEqual(2, Length(LObj.NestedScores[0]));
      LExpected := 95.5;
      Assert.AreEqual(LExpected, LObj.NestedScores[0][0]);
      LExpected := 88.0;
      Assert.AreEqual(LExpected, LObj.NestedScores[0][1]);
      LExpected := 75.0;
      Assert.AreEqual(LExpected, LObj.NestedScores[1][0]);
      LExpected := 82.5;
      Assert.AreEqual(LExpected, LObj.NestedScores[1][1]);
    finally
      LObj.Free;
    end;
  finally
    LSerializer.Free;
  end;
end;

initialization
  TDUnitX.RegisterTestFixture(TJSONSerializerTests);

end.
