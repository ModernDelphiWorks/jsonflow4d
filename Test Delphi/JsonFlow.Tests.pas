unit JsonFlow.Tests;

interface

uses
  DUnitX.TestFramework,
  Rtti,
  Classes,
  SysUtils,
  DateUtils,
  Variants,
  JsonFlow,
  JsonFlow.Utils,
  JsonFlow.Interfaces,
  JsonFlow.Navigator,
  JsonFlow.MiddlewareDatatime,
  Generics.Collections;

type
  TTestClass = class
  private
    FName: string;
    FDate: TDateTime;
  public
    property Name: string read FName write FName;
    property Date: TDateTime read FDate write FDate;
  end;

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

  [TestFixture]
  TJsonFlowTests = class(TObject)
  public
    [Test]
    procedure TestParseSimpleJson;
    [Test]
    procedure TestParseNestedJson;
    [Test]
    procedure TestParseInvalidJsonRaisesException;
    [Test]
    procedure TestParseNullJsonRaisesException;
    [Test]
    procedure TestToJsonSimpleObject;
    [Test]
    procedure TestToJsonWithIndentation;
    [Test]
    procedure TestToJsonNullElement;
    [Test]
    procedure TestFromObjectSimple;
    [Test]
    procedure TestFromObjectWithClassName;
    [Test]
    procedure TestFromObjectNullRaisesException;
    [Test]
    procedure TestToObjectSimple;
    [Test]
    procedure TestToObjectNested;
    [Test]
    procedure TestToObjectNullElementRaisesException;
    [Test]
    procedure TestToObjectNullObjectRaisesException;
    [Test]
    procedure TestFullCycle;
    [Test]
    procedure TestObjectToJsonString;
    [Test]
    procedure TestObjectToJsonStringWithMiddleware;
    [Test]
    procedure TestJsonToObject;
    [Test]
    procedure TestJsonToObjectWithMiddleware;
    [Test]
    procedure TestObjectListToJsonString;
    [Test]
    procedure TestJsonToObjectList;
    [Test]
    procedure TestJsonToObjectWithTime;
  end;

implementation

procedure TJsonFlowTests.TestParseSimpleJson;
var
  LJsonFlow: TJsonFlow;
  LElement: IJSONElement;
begin
  LJsonFlow := TJsonFlow.Create;
  try
    LElement := LJsonFlow.Parse('{"nome":"João"}');
    Assert.IsNotNull(LElement, 'Elemento não deve ser nulo');
    Assert.IsTrue(Supports(LElement, IJSONObject), 'Tipo deve ser objeto');
    Assert.AreEqual('João', ((LElement as IJSONObject).GetValue('nome') as IJSONValue).AsString, 'Valor de "nome" incorreto');
  finally
    LJsonFlow.Free;
  end;
end;

procedure TJsonFlowTests.TestParseNestedJson;
var
  LJsonFlow: TJsonFlow;
  LElement: IJSONElement;
  LInnerObj: IJSONElement;
begin
  LJsonFlow := TJsonFlow.Create;
  try
    LElement := LJsonFlow.Parse('{"pessoa":{"nome":"João"}}');
    Assert.IsNotNull(LElement, 'Elemento não deve ser nulo');
    Assert.IsTrue(Supports(LElement, IJSONObject), 'Tipo deve ser objeto');
    LInnerObj := (LElement as IJSONObject).GetValue('pessoa');
    Assert.IsNotNull(LInnerObj, 'Objeto "pessoa" não deve ser nulo');
    Assert.IsTrue(Supports(LInnerObj, IJSONObject), 'Tipo deve ser objeto');
    Assert.AreEqual('João', ((LInnerObj as IJSONObject).GetValue('nome') as IJSONValue).AsString, 'Valor de "nome" incorreto');
  finally
    LJsonFlow.Free;
  end;
end;

procedure TJsonFlowTests.TestParseInvalidJsonRaisesException;
var
  LJsonFlow: TJsonFlow;
begin
  LJsonFlow := TJsonFlow.Create;
  try
    Assert.WillRaise(
      procedure
      begin
        LJsonFlow.Parse('{nome:"João"}'); // Chave sem aspas
      end,
      EInvalidOperation,
      'Deve lançar exceção para JSON inválido'
    );
  finally
    LJsonFlow.Free;
  end;
end;

procedure TJsonFlowTests.TestParseNullJsonRaisesException;
var
  LJsonFlow: TJsonFlow;
begin
  LJsonFlow := TJsonFlow.Create;
  try
    Assert.WillRaise(
      procedure
      begin
        LJsonFlow.Parse(''); // String vazia
      end,
      EInvalidOperation,
      'Deve lançar exceção para JSON vazio'
    );
  finally
    LJsonFlow.Free;
  end;
end;

procedure TJsonFlowTests.TestToJsonSimpleObject;
var
  LJsonFlow: TJsonFlow;
  LElement: IJSONElement;
  LJson: string;
begin
  LJsonFlow := TJsonFlow.Create;
  try
    LElement := LJsonFlow.Parse('{"nome":"João"}');
    LJson := LJsonFlow.ToJson(LElement);
    Assert.AreEqual('{"nome":"João"}', LJson, 'JSON gerado incorreto');
  finally
    LJsonFlow.Free;
  end;
end;

procedure TJsonFlowTests.TestToJsonWithIndentation;
var
  LJsonFlow: TJsonFlow;
  LElement: IJSONElement;
  LJson: string;
begin
  LJsonFlow := TJsonFlow.Create;
  try
    LElement := LJsonFlow.Parse('{"nome":"João"}');
    LJson := LJsonFlow.ToJson(LElement, True);
    Assert.AreEqual('{'#13#10'  "nome": "João"'#13#10'}', LJson, 'JSON indentado incorreto');
  finally
    LJsonFlow.Free;
  end;
end;

procedure TJsonFlowTests.TestToJsonNullElement;
var
  LJsonFlow: TJsonFlow;
  LJson: string;
begin
  LJsonFlow := TJsonFlow.Create;
  try
    LJson := LJsonFlow.ToJson(nil);
    Assert.AreEqual('null', LJson, 'JSON para elemento nulo deve ser "null"');
  finally
    LJsonFlow.Free;
  end;
end;

procedure TJsonFlowTests.TestFromObjectSimple;
var
  LJsonFlow: TJsonFlow;
  LObj: TTestSimpleClass;
  LElement: IJSONElement;
begin
  LJsonFlow := TJsonFlow.Create;
  try
    LObj := TTestSimpleClass.Create;
    try
      LObj.Name := 'João';
      LObj.Age := 30;
      LElement := LJsonFlow.FromObject(LObj);
      Assert.IsNotNull(LElement, 'Elemento não deve ser nulo');
      Assert.IsTrue(Supports(LElement, IJSONObject), 'Tipo deve ser objeto');
      Assert.AreEqual('João', ((LElement as IJSONObject).GetValue('Name') as IJSONValue).AsString, 'Valor de "Name" incorreto');
      Assert.AreEqual(Int64(30), ((LElement as IJSONObject).GetValue('Age') as IJSONValue).AsInteger, 'Valor de "Age" incorreto');
    finally
      LObj.Free;
    end;
  finally
    LJsonFlow.Free;
  end;
end;

procedure TJsonFlowTests.TestFromObjectWithClassName;
var
  LJsonFlow: TJsonFlow;
  LObj: TTestSimpleClass;
  LElement: IJSONElement;
begin
  LJsonFlow := TJsonFlow.Create;
  try
    LObj := TTestSimpleClass.Create;
    try
      LObj.Name := 'João';
      LElement := LJsonFlow.FromObject(LObj, True);
      Assert.IsNotNull(LElement, 'Elemento não deve ser nulo');
      Assert.IsTrue(Supports(LElement, IJSONObject), 'Tipo deve ser objeto');
      Assert.AreEqual('TTestSimpleClass', ((LElement as IJSONObject).GetValue('$class') as IJSONValue).AsString, 'Nome da classe incorreto');
      Assert.AreEqual('João', ((LElement as IJSONObject).GetValue('Name') as IJSONValue).AsString, 'Valor de "Name" incorreto');
    finally
      LObj.Free;
    end;
  finally
    LJsonFlow.Free;
  end;
end;

procedure TJsonFlowTests.TestFromObjectNullRaisesException;
var
  LJsonFlow: TJsonFlow;
begin
  LJsonFlow := TJsonFlow.Create;
  try
    Assert.WillRaise(
      procedure
      begin
        LJsonFlow.FromObject(nil);
      end,
      EArgumentNilException,
      'Deve lançar exceção para objeto nulo'
    );
  finally
    LJsonFlow.Free;
  end;
end;

procedure TJsonFlowTests.TestToObjectSimple;
var
  LJsonFlow: TJsonFlow;
  LObj: TTestSimpleClass;
  LElement: IJSONElement;
begin
  LJsonFlow := TJsonFlow.Create;
  try
    LObj := TTestSimpleClass.Create;
    try
      LElement := LJsonFlow.Parse('{"Name":"João","Age":30}');
      Assert.IsTrue(LJsonFlow.ToObject(LElement, LObj), 'ToObject deve retornar True');
      Assert.AreEqual('João', LObj.Name, 'Nome desserializado incorreto');
      Assert.AreEqual(30, LObj.Age, 'Idade desserializada incorreta');
    finally
      LObj.Free;
    end;
  finally
    LJsonFlow.Free;
  end;
end;

procedure TJsonFlowTests.TestToObjectNested;
var
  LJsonFlow: TJsonFlow;
  LObj: TTestNestedArrayClass;
  LElement: IJSONElement;
begin
  LObj := TTestNestedArrayClass.Create;
  try
    LJsonFlow := TJsonFlow.Create;
    try
      LJsonFlow.OnLog(procedure(AMessage: string)
        begin
          Writeln('LOG: ' + AMessage);
        end);
      LElement := LJsonFlow.Parse('{"NestedScores":[[95.5,88.0],[75.0,82.5]]}');
      Assert.IsTrue(LJsonFlow.ToObject(LElement, LObj), 'ToObject deve retornar True');
      Assert.AreEqual(2, Length(LObj.NestedScores), 'Tamanho do array externo NestedScores incorreto');
      Assert.AreEqual(2, Length(LObj.NestedScores[0]), 'Tamanho do array interno NestedScores[0] incorreto');
      Assert.AreEqual(Double(95.5), LObj.NestedScores[0][0], 'NestedScores[0][0] desserializado incorreto');
      Assert.AreEqual(Double(88.0), LObj.NestedScores[0][1], 'NestedScores[0][1] desserializado incorreto');
      Assert.AreEqual(Double(75.0), LObj.NestedScores[1][0], 'NestedScores[1][0] desserializado incorreto');
      Assert.AreEqual(Double(82.5), LObj.NestedScores[1][1], 'NestedScores[1][1] desserializado incorreto');
    finally
      LJsonFlow.Free;
    end;
  finally
    LObj.Free;
  end;
end;

procedure TJsonFlowTests.TestToObjectNullElementRaisesException;
var
  LJsonFlow: TJsonFlow;
  LObj: TTestSimpleClass;
begin
  LJsonFlow := TJsonFlow.Create;
  try
    LObj := TTestSimpleClass.Create;
    try
      Assert.WillRaise(
        procedure
        begin
          LJsonFlow.ToObject(nil, LObj);
        end,
        EArgumentNilException,
        'Deve lançar exceção para elemento nulo'
      );
    finally
      LObj.Free;
    end;
  finally
    LJsonFlow.Free;
  end;
end;

procedure TJsonFlowTests.TestToObjectNullObjectRaisesException;
var
  LJsonFlow: TJsonFlow;
  LElement: IJSONElement;
begin
  LJsonFlow := TJsonFlow.Create;
  try
    LElement := LJsonFlow.Parse('{"Name":"João"}');
    Assert.WillRaise(
      procedure
      begin
        LJsonFlow.ToObject(LElement, nil);
      end,
      EArgumentNilException,
      'Deve lançar exceção para objeto nulo'
    );
  finally
    LJsonFlow.Free;
  end;
end;

procedure TJsonFlowTests.TestFullCycle;
var
  LJsonFlow: TJsonFlow;
  LObjIn, LObjOut: TTestSimpleClass;
  LElement: IJSONElement;
  LJson: string;
begin
  LJsonFlow := TJsonFlow.Create;
  try
    LObjIn := TTestSimpleClass.Create;
    LObjOut := TTestSimpleClass.Create;
    try
      LObjIn.Name := 'João';
      LObjIn.Age := 30;
      LElement := LJsonFlow.FromObject(LObjIn);
      LJson := LJsonFlow.ToJson(LElement);
      LElement := LJsonFlow.Parse(LJson);
      Assert.IsTrue(LJsonFlow.ToObject(LElement, LObjOut), 'ToObject deve retornar True');
      Assert.AreEqual(LObjIn.Name, LObjOut.Name, 'Nome não preservado no ciclo');
      Assert.AreEqual(LObjIn.Age, LObjOut.Age, 'Idade não preservada no ciclo');
    finally
      LObjOut.Free;
      LObjIn.Free;
    end;
  finally
    LJsonFlow.Free;
  end;
end;

procedure TJsonFlowTests.TestJsonToObject;
var
  LObj: TTestClass;
begin
  LObj := TJsonFlow.JsonToObject<TTestClass>('{"Name":"João","Date":"2025-03-08"}');
  try
    Assert.AreEqual('João', LObj.Name);
    Assert.AreEqual(EncodeDate(2025, 3, 8), LObj.Date);
  finally
    LObj.Free;
  end;
end;

procedure TJsonFlowTests.TestJsonToObjectList;
var
  LList: TObjectList<TTestClass>;
begin
  LList := TJsonFlow.JsonToObjectList<TTestClass>('[{"Name":"João"},{"Name":"Maria"}]');
  try
    Assert.AreEqual(2, LList.Count);
    Assert.AreEqual('João', LList[0].Name);
    Assert.AreEqual('Maria', LList[1].Name);
  finally
    LList.Free;
  end;
end;

procedure TJsonFlowTests.TestJsonToObjectWithMiddleware;
var
  LObj: TTestClass;
begin
  TJsonFlow.AddMiddleware(TMiddlewareDateTime.Create(TJsonFlow.FormatSettings));
  LObj := TJsonFlow.JsonToObject<TTestClass>('{"Name":"João","Date":"2025-03-08"}');
  try
    Assert.AreEqual('João', LObj.Name);
    Assert.AreEqual(EncodeDate(2025, 3, 8), LObj.Date);
  finally
    LObj.Free;
    TJsonFlow.ClearMiddlewares;
  end;
end;

procedure TJsonFlowTests.TestObjectListToJsonString;
const
  CJSON = '[{"Name":"João","Date":"2025-03-09"},{"Name":"Maria","Date":""}]';
var
  LList: TObjectList<TTestClass>;
begin
  LList := TObjectList<TTestClass>.Create(True);
  try
    var LObj1 := TTestClass.Create;
    LObj1.Name := 'João';
    LObj1.Date := StrToDate('09/03/2025');
    LList.Add(LObj1);

    var LObj2 := TTestClass.Create;
    LObj2.Name := 'Maria';
    LList.Add(LObj2);

    Assert.AreEqual(CJSON, TJsonFlow.ObjectListToJsonString(TObjectList<TObject>(LList)));
  finally
    LList.Free;
  end;
end;

procedure TJsonFlowTests.TestObjectToJsonString;
var
  LObj: TTestClass;
begin
  LObj := TTestClass.Create;
  try
    LObj.Name := 'João';
    Assert.AreEqual('{"Name":"João","Date":""}', TJsonFlow.ObjectToJsonString(LObj));
  finally
    LObj.Free;
  end;
end;

procedure TJsonFlowTests.TestObjectToJsonStringWithMiddleware;
var
  LObj: TTestClass;
begin
  TJsonFlow.AddMiddleware(TMiddlewareDateTime.Create(TJsonFlow.FormatSettings));
  LObj := TTestClass.Create;
  try
    LObj.Name := 'João';
    LObj.Date := EncodeDate(2025, 3, 8);
    Assert.AreEqual('{"Name":"João","Date":"2025-03-08"}', TJsonFlow.ObjectToJsonString(LObj));
  finally
    LObj.Free;
    TJsonFlow.ClearMiddlewares;
  end;
end;

procedure TJsonFlowTests.TestJsonToObjectWithTime;
var
  LObj: TTestClass;
begin
  TJsonFlow.AddMiddleware(TMiddlewareDateTime.Create(TJsonFlow.FormatSettings));
  LObj := TJsonFlow.JsonToObject<TTestClass>('{"Name":"João","Date":"2025-03-08T14:30:00"}');
  try
    Assert.AreEqual('João', LObj.Name);
    Assert.AreEqual(EncodeDateTime(2025, 3, 8, 14, 30, 0, 0), LObj.Date);
  finally
    LObj.Free;
  end;
end;

initialization
  TDUnitX.RegisterTestFixture(TJsonFlowTests);

end.
