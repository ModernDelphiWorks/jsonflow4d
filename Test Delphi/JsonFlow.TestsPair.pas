unit JsonFlow.TestsPair;

interface

uses
  SysUtils,
  DUnitX.TestFramework,
  JsonFlow.Interfaces,
  JsonFlow.Value,
  JsonFlow.Pair;

type
  [TestFixture]
  TJSONPairTests = class
  public
    [Test]
    procedure TestCreateAndGet;
    [Test]
    procedure TestSetKey;
    [Test]
    procedure TestSetValue;
    [Test]
    procedure TestAsJSON;
    [Test]
    procedure TestAsJSONWithIndent;
    [Test]
    procedure TestNullValue;
    [Test]
    procedure TestEmptyKeyException;
  end;

implementation

procedure TJSONPairTests.TestCreateAndGet;
var
  LPair: IJSONPair;
begin
  LPair := TJSONPair.Create('name', TJSONValueString.Create('João'));
  Assert.AreEqual('name', LPair.Key);
  Assert.AreEqual('João', (LPair.Value as IJSONValue).AsString);
end;

procedure TJSONPairTests.TestSetKey;
var
  LPair: IJSONPair;
begin
  LPair := TJSONPair.Create('name', TJSONValueString.Create('João'));
  LPair.Key := 'newName';
  Assert.AreEqual('newName', LPair.Key);
end;

procedure TJSONPairTests.TestSetValue;
var
  LPair: IJSONPair;
begin
  LPair := TJSONPair.Create('name', TJSONValueString.Create('João'));
  LPair.Value := TJSONValueString.Create('Maria');
  Assert.AreEqual('Maria', (LPair.Value as IJSONValue).AsString);
end;

procedure TJSONPairTests.TestAsJSON;
var
  LPair: IJSONPair;
begin
  LPair := TJSONPair.Create('name', TJSONValueString.Create('João'));
  Assert.AreEqual('"name":"João"', LPair.AsJSON);
end;

procedure TJSONPairTests.TestAsJSONWithIndent;
var
  LPair: IJSONPair;
begin
  LPair := TJSONPair.Create('name', TJSONValueString.Create('João'));
  Assert.AreEqual('"name": "João"', LPair.AsJSON(True));
end;

procedure TJSONPairTests.TestNullValue;
var
  LPair: IJSONPair;
begin
  LPair := TJSONPair.Create('key', nil);
  Assert.AreEqual('"key":null', LPair.AsJSON);
end;

procedure TJSONPairTests.TestEmptyKeyException;
var
  LPair: IJSONPair;
  LValue: IJSONElement;
begin
  LValue := TJSONValueString.Create('value');
  Assert.WillRaise(
    procedure
    begin
      LPair := TJSONPair.Create('', LValue);
    end, EArgumentException);

  LPair := TJSONPair.Create('key', TJSONValueString.Create('value'));
  Assert.WillRaise(
    procedure
    begin
      LPair.Key := '';
    end, EArgumentException);
end;

initialization
  TDUnitX.RegisterTestFixture(TJSONPairTests);

end.
