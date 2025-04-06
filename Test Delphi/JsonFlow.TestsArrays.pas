unit JsonFlow.TestsArrays;

interface

uses
  SysUtils,
  Classes,
  DUnitX.TestFramework,
  JsonFlow.Interfaces,
  JsonFlow.Value,
  JsonFlow.Arrays;

type
  [TestFixture]
  TJSONArrayTests = class
  public
    [Test]
    procedure TestAddAndGetItem;
    [Test]
    procedure TestRemove;
    [Test]
    procedure TestAsJSON;
    [Test]
    procedure TestFilter;
    [Test]
    procedure TestMap;
    [Test]
    procedure TestDataType;
    [Test]
    procedure TestSaveToStream;
    [Test]
    procedure TestClone;
    [Test]
    procedure TestEmptyArray;
  end;

implementation

procedure TJSONArrayTests.TestAddAndGetItem;
var
  LArr: IJSONArray;
begin
  LArr := TJSONArray.Create;
  LArr.Add(TJSONValueString.Create('Test'));
  Assert.AreEqual('Test', (LArr.GetItem(0) as IJSONValue).AsString);
end;

procedure TJSONArrayTests.TestRemove;
var
  LArr: IJSONArray;
begin
  LArr := TJSONArray.Create;
  LArr.Add(TJSONValueString.Create('Test'));
  LArr.Remove(0);
  Assert.AreEqual(0, LArr.Count);
end;

procedure TJSONArrayTests.TestAsJSON;
var
  LArr: IJSONArray;
begin
  LArr := TJSONArray.Create;
  LArr.Add(TJSONValueInteger.Create(1));
  LArr.Add(TJSONValueString.Create('Test'));
  Assert.AreEqual('[1,"Test"]', LArr.AsJSON);
end;

procedure TJSONArrayTests.TestFilter;
var
  LArr, LFiltered: IJSONArray;
  LExpected: Int64;
begin
  LExpected := 2;
  LArr := TJSONArray.Create;
  LArr.Add(TJSONValueInteger.Create(1));
  LArr.Add(TJSONValueInteger.Create(2));
  LFiltered := LArr.Filter(
    function(AValue: IJSONElement): Boolean
    begin
      Result := (AValue as IJSONValue).AsInteger > 1;
    end);
  Assert.AreEqual(1, LFiltered.Count);
  Assert.AreEqual(LExpected, (LFiltered.GetItem(0) as IJSONValue).AsInteger);
end;

procedure TJSONArrayTests.TestMap;
var
  LArr, LMapped: IJSONArray;
  LExpected: Int64;
begin
  LExpected := 2;
  LArr := TJSONArray.Create;
  LArr.Add(TJSONValueInteger.Create(1));
  LMapped := LArr.Map(
    function(AValue: IJSONElement): IJSONElement
    begin
      Result := TJSONValueInteger.Create((AValue as IJSONValue).AsInteger + 1);
    end);
  Assert.AreEqual(LExpected, (LMapped.GetItem(0) as IJSONValue).AsInteger);
end;

procedure TJSONArrayTests.TestDataType;
var
  LArr: IJSONArray;
begin
  LArr := TJSONArray.Create;
  Assert.IsTrue(Supports(LArr, IJSONArray), 'Tipo deve ser array');
end;

procedure TJSONArrayTests.TestSaveToStream;
var
  LArr: IJSONArray;
  LStream: TStringStream;
begin
  LArr := TJSONArray.Create;
  LArr.Add(TJSONValueString.Create('Test'));
  LStream := TStringStream.Create('');
  try
    LArr.SaveToStream(LStream);
    Assert.AreEqual('["Test"]', LStream.DataString);
  finally
    LStream.Free;
  end;
end;

procedure TJSONArrayTests.TestClone;
var
  LArr, LClone: IJSONArray;
begin
  LArr := TJSONArray.Create;
  LArr.Add(TJSONValueString.Create('Original'));
  LClone := LArr.Clone as IJSONArray;
  Assert.AreEqual('Original', (LClone.GetItem(0) as IJSONValue).AsString);
  LClone.Add(TJSONValueString.Create('New'));
  Assert.AreEqual(1, LArr.Count);
end;

procedure TJSONArrayTests.TestEmptyArray;
var
  LArr: IJSONArray;
begin
  LArr := TJSONArray.Create;
  Assert.AreEqual(0, LArr.Count);
  Assert.AreEqual('[]', LArr.AsJSON);
end;

initialization
  TDUnitX.RegisterTestFixture(TJSONArrayTests);

end.
