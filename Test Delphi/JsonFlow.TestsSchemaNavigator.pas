unit JsonFlow.TestsSchemaNavigator;

interface

uses
  DUnitX.TestFramework,
  JsonFlow.SchemaNavigator,
  JsonFlow.SchemaReader;

type
  [TestFixture]
  TJSONSchemaNavigatorTests = class
  private
    FNavigator: TJSONSchemaNavigator;
    FReader: TJSONSchemaReader;
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;
    [Test]
    procedure TestGetValue_SimplePath;
    [Test]
    procedure TestGetValue_NestedPath;
    [Test]
    procedure TestGetValue_ArrayIndex;
    [Test]
    procedure TestGetObject_ValidPath;
    [Test]
    procedure TestGetObject_InvalidPath;
    [Test]
    procedure TestGetArray_ValidPath;
    [Test]
    procedure TestGetArray_InvalidPath;
    [Test]
    procedure TestResolveRef_LocalDefs;
    [Test]
    procedure TestResolveRef_LocalAnchor;
    [Test]
    procedure TestResolveRef_ExternalFile;
    [Test]
    procedure TestGetValue_EscapeCharacters;
    [Test]
    procedure TestGetValue_InvalidPath;
  end;

implementation

uses
  SysUtils,
  Classes,
  IOUtils,
  JsonFlow.Interfaces;

procedure TJSONSchemaNavigatorTests.Setup;
begin
  FReader := TJSONSchemaReader.Create;
  FNavigator := nil;
end;

procedure TJSONSchemaNavigatorTests.TearDown;
begin
  FreeAndNil(FNavigator);
  FreeAndNil(FReader);
end;

procedure TJSONSchemaNavigatorTests.TestGetValue_SimplePath;
var
  LSchema: String;
  LElement: IJSONElement;
  LValue: IJSONValue;
begin
  LSchema := '{"type": "object", "properties": {"nome": {"type": "string"}}}';
  FReader.LoadFromString(LSchema);
  FNavigator := TJSONSchemaNavigator.Create(FReader.GetSchema);
  LElement := FNavigator.GetValue('/properties/nome/type');
  Assert.IsNotNull(LElement, 'Deveria encontrar o elemento no caminho');
  Assert.IsTrue(Supports(LElement, IJSONValue, LValue), 'Deveria ser um valor');
  Assert.AreEqual('string', LValue.AsString, 'Valor esperado no caminho');
end;

procedure TJSONSchemaNavigatorTests.TestGetValue_NestedPath;
var
  LSchema: String;
  LElement: IJSONElement;
  LValue: IJSONValue;
begin
  LSchema := '{"type": "object", "properties": {"pessoa": {"type": "object", "properties": {"idade": {"type": "integer"}}}}}';
  FReader.LoadFromString(LSchema);
  FNavigator := TJSONSchemaNavigator.Create(FReader.GetSchema);
  LElement := FNavigator.GetValue('/properties/pessoa/properties/idade/type');
  Assert.IsNotNull(LElement, 'Deveria encontrar o elemento no caminho aninhado');
  Assert.IsTrue(Supports(LElement, IJSONValue, LValue), 'Deveria ser um valor');
  Assert.AreEqual('integer', LValue.AsString, 'Valor esperado no caminho aninhado');
end;

procedure TJSONSchemaNavigatorTests.TestGetValue_ArrayIndex;
var
  LSchema: String;
  LElement: IJSONElement;
  LValue: IJSONValue;
begin
  LSchema := '{"type": "array", "items": [{"type": "string"}, {"type": "integer"}]}';
  FReader.LoadFromString(LSchema);
  FNavigator := TJSONSchemaNavigator.Create(FReader.GetSchema);
  LElement := FNavigator.GetValue('/items/1/type');
  Assert.IsNotNull(LElement, 'Deveria encontrar o elemento no índice do array');
  Assert.IsTrue(Supports(LElement, IJSONValue, LValue), 'Deveria ser um valor');
  Assert.AreEqual('integer', LValue.AsString, 'Valor esperado no índice 1');
end;

procedure TJSONSchemaNavigatorTests.TestGetObject_ValidPath;
var
  LSchema: String;
  LObj: IJSONObject;
begin
  LSchema := '{"type": "object", "properties": {"nome": {"type": "string"}}}';
  FReader.LoadFromString(LSchema);
  FNavigator := TJSONSchemaNavigator.Create(FReader.GetSchema);
  LObj := FNavigator.GetObject('/properties/nome');
  Assert.IsNotNull(LObj, 'Deveria retornar um objeto válido');
  Assert.AreEqual('string', (LObj.GetValue('type') as IJSONValue).AsString, 'Valor esperado no objeto');
end;

procedure TJSONSchemaNavigatorTests.TestGetObject_InvalidPath;
var
  LSchema: String;
  LObj: IJSONObject;
begin
  LSchema := '{"type": "object", "properties": {"nome": {"type": "string"}}}';
  FReader.LoadFromString(LSchema);
  FNavigator := TJSONSchemaNavigator.Create(FReader.GetSchema);
  LObj := FNavigator.GetObject('/properties/invalid');
  Assert.IsNull(LObj, 'Deveria retornar nil para um caminho inválido');
end;

procedure TJSONSchemaNavigatorTests.TestGetArray_ValidPath;
var
  LSchema: String;
  LArr: IJSONArray;
begin
  LSchema := '{"type": "array", "items": [{"type": "string"}, {"type": "integer"}]}';
  FReader.LoadFromString(LSchema);
  FNavigator := TJSONSchemaNavigator.Create(FReader.GetSchema);
  LArr := FNavigator.GetArray('/items');
  Assert.IsNotNull(LArr, 'Deveria retornar um array válido');
  Assert.AreEqual(2, LArr.Count, 'Array deveria ter 2 itens');
end;

procedure TJSONSchemaNavigatorTests.TestGetArray_InvalidPath;
var
  LSchema: String;
  LArr: IJSONArray;
begin
  LSchema := '{"type": "object", "properties": {"nome": {"type": "string"}}}';
  FReader.LoadFromString(LSchema);
  FNavigator := TJSONSchemaNavigator.Create(FReader.GetSchema);
  LArr := FNavigator.GetArray('/properties/nome');
  Assert.IsNull(LArr, 'Deveria retornar nil para um caminho que não é array');
end;

procedure TJSONSchemaNavigatorTests.TestResolveRef_LocalDefs;
var
  LSchema: String;
  LElement: IJSONElement;
  LObj: IJSONObject;
begin
  LSchema := '{"$defs": {"stringType": {"type": "string"}}, "properties": {"nome": {"$ref": "#/$defs/stringType"}}}';
  FReader.LoadFromString(LSchema);
  FNavigator := TJSONSchemaNavigator.Create(FReader.GetSchema);
  LElement := FNavigator.ResolveReference('#/$defs/stringType');
  Assert.IsNotNull(LElement, 'Deveria resolver a referência local em $defs');
  Assert.IsTrue(Supports(LElement, IJSONObject, LObj), 'Deveria ser um objeto');
  Assert.AreEqual('string', (LObj.GetValue('type') as IJSONValue).AsString, 'Valor esperado na referência');
end;

procedure TJSONSchemaNavigatorTests.TestResolveRef_LocalAnchor;
var
  LSchema: String;
  LElement: IJSONElement;
  LObj: IJSONObject;
begin
  LSchema := '{"properties": {"nome": {"$anchor": "nomeAnchor", "type": "string"}}}';
  FReader.LoadFromString(LSchema);
  FNavigator := TJSONSchemaNavigator.Create(FReader.GetSchema);
  LElement := FNavigator.ResolveReference('#nomeAnchor');
  Assert.IsNotNull(LElement, 'Deveria resolver a referência local em $anchor');
  Assert.IsTrue(Supports(LElement, IJSONObject, LObj), 'Deveria ser um objeto');
  Assert.AreEqual('string', (LObj.GetValue('type') as IJSONValue).AsString, 'Valor esperado na referência');
end;

procedure TJSONSchemaNavigatorTests.TestResolveRef_ExternalFile;
var
  LSchema: String;
  LExternalSchema: String;
  LFileName: String;
  LElement: IJSONElement;
  LObj: IJSONObject; // Declarado aqui
begin
  LFileName := TPath.GetTempFileName;
  LSchema := '{"properties": {"nome": {"$ref": "' + TPath.GetFileName(LFileName) + '#/"}}}';
  LExternalSchema := '{"type": "string"}';
  try
    TFile.WriteAllText(LFileName, LExternalSchema);
    FReader.LoadFromString(LSchema);
    FNavigator := TJSONSchemaNavigator.Create(FReader.GetSchema);
    LElement := FNavigator.ResolveReference(TPath.GetFileName(LFileName) + '#/', LFileName);
    Assert.IsNotNull(LElement, 'Deveria resolver a referência externa');
    Assert.IsTrue(Supports(LElement, IJSONObject, LObj), 'Deveria ser um objeto');
    Assert.AreEqual('string', (LObj.GetValue('type') as IJSONValue).AsString, 'Valor esperado na referência externa');
  finally
    TFile.Delete(LFileName);
  end;
end;

procedure TJSONSchemaNavigatorTests.TestGetValue_EscapeCharacters;
var
  LSchema: String;
  LElement: IJSONElement;
  LValue: IJSONValue;
begin
  LSchema := '{"properties": {"nome~til": {"type": "string"}}}';
  FReader.LoadFromString(LSchema);
  FNavigator := TJSONSchemaNavigator.Create(FReader.GetSchema);
  LElement := FNavigator.GetValue('/properties/nome~0til/type');
  Assert.IsNotNull(LElement, 'Deveria resolver o caminho com escape ~0');
  Assert.IsTrue(Supports(LElement, IJSONValue, LValue), 'Deveria ser um valor');
  Assert.AreEqual('string', LValue.AsString, 'Valor esperado com escape');
end;

procedure TJSONSchemaNavigatorTests.TestGetValue_InvalidPath;
var
  LSchema: String;
  LElement: IJSONElement;
begin
  LSchema := '{"type": "object", "properties": {"nome": {"type": "string"}}}';
  FReader.LoadFromString(LSchema);
  FNavigator := TJSONSchemaNavigator.Create(FReader.GetSchema);
  LElement := FNavigator.GetValue('/invalid/path');
  Assert.IsNull(LElement, 'Deveria retornar nil para um caminho inválido');
end;

initialization
  TDUnitX.RegisterTestFixture(TJSONSchemaNavigatorTests);

end.
