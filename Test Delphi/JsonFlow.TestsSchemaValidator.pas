unit JsonFlow.TestsSchemaValidator;

interface

uses
  Classes,
  IOUtils,
  StrUtils,
  DUnitX.TestFramework,
  JsonFlow.SchemaValidator,
  JsonFlow.SchemaReader;

type
  [TestFixture]
  TJSONSchemaValidatorTests = class
  private
    FReader: TJSONSchemaReader;
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;
//    [Test]
    procedure TestValidate_SimpleType;
//    [Test]
    procedure TestValidate_RequiredField;
//    [Test]
    procedure TestValidate_LocalDefs;
//    [Test]
    procedure TestValidate_LocalAnchor;
//    [Test]
    procedure TestValidate_DeepNestedProperties;
//    [Test]
    procedure TestValidate_ArrayItems;
//    [Test]
    procedure TestValidate_ObjectWithArray;
//    [Test]
    procedure TestValidate_ArrayWithObjects;
    [Test]
    procedure TestValidate_AdditionalProperties;
  end;

implementation

uses
  SysUtils,
  JsonFlow.Interfaces;

procedure TJSONSchemaValidatorTests.Setup;
begin
  FReader := TJSONSchemaReader.Create;
end;

procedure TJSONSchemaValidatorTests.TearDown;
begin
  FreeAndNil(FReader);
end;

procedure TJSONSchemaValidatorTests.TestValidate_SimpleType;
var
  LSchema: String;
  LJson: String;
begin
  LSchema := '{"type": "object", "properties": {"nome": {"type": "string"}}}';
  LJson := '{"nome": "Isaque"}';
  FReader.LoadFromString(LSchema);
  Assert.IsTrue(FReader.Validate(LJson), 'Deveria validar um tipo simples');
  Assert.AreEqual(0, Length(FReader.GetErrors), 'Não deveria haver erros');

  LJson := '{"nome": 123}';
  Assert.IsFalse(FReader.Validate(LJson), 'Deveria falhar com tipo errado');
  Assert.AreEqual(1, Length(FReader.GetErrors), 'Deveria ter um erro');
end;

procedure TJSONSchemaValidatorTests.TestValidate_RequiredField;
var
  LSchema: String;
  LJson: String;
begin
  LSchema := '{"type": "object", "properties": {"nome": {"type": "string"}}, "required": ["nome"]}';
  LJson := '{"nome": "Isaque"}';
  FReader.LoadFromString(LSchema);
  Assert.IsTrue(FReader.Validate(LJson), 'Deveria validar com campo requerido presente');

  LJson := '{}';
  Assert.IsFalse(FReader.Validate(LJson), 'Deveria falhar sem campo requerido');
  Assert.AreEqual(1, Length(FReader.GetErrors), 'Deveria ter um erro');
end;

procedure TJSONSchemaValidatorTests.TestValidate_LocalDefs;
var
  LSchema: String;
  LJson: String;
begin
  LSchema := '{"$defs": {"stringType": {"type": "string"}}, "properties": {"nome": {"$ref": "#/$defs/stringType"}}}';
  LJson := '{"nome": "Isaque"}';
  FReader.LoadFromString(LSchema);
  Assert.IsTrue(FReader.Validate(LJson), 'Deveria validar com $defs');

  LJson := '{"nome": 123}';
  Assert.IsFalse(FReader.Validate(LJson), 'Deveria falhar com tipo errado em $defs');
end;

procedure TJSONSchemaValidatorTests.TestValidate_LocalAnchor;
var
  LSchema: String;
  LJson: String;
begin
  LSchema := '{"properties": {"nome": {"$anchor": "nomeAnchor", "type": "string", "$ref": "#nomeAnchor"}}}';
  LJson := '{"nome": "Isaque"}';
  FReader.LoadFromString(LSchema);
  Assert.IsTrue(FReader.Validate(LJson), 'Deveria validar com $anchor');

  LJson := '{"nome": 123}';
  Assert.IsFalse(FReader.Validate(LJson), 'Deveria falhar com tipo errado em $anchor');
end;

procedure TJSONSchemaValidatorTests.TestValidate_DeepNestedProperties;
var
  LSchema: String;
  LJson: String;
begin
  LSchema := '{"properties": {"a": {"properties": {"b": {"properties": {"c": {"type": "string"}}}}}}}';

  Writeln('Loading schema: "' + LSchema + '"');
  Writeln('Schema length: ' + Length(LSchema).ToString);
  if FReader.LoadFromString(LSchema) then
    Writeln('LoadFromString returned TRUE')
  else
    Writeln('LoadFromString returned FALSE');

  LJson := '{"a": {"b": {"c": "teste"}}}';
  Writeln('Validating JSON: "' + LJson + '"');
  Assert.IsTrue(FReader.Validate(LJson), 'Deveria validar schema aninhado profundo');

  LJson := '{"a": {"b": {"c": 123}}}';
  Writeln('Validating JSON: "' + LJson + '"');
  Assert.IsFalse(FReader.Validate(LJson), 'Deveria falhar com tipo errado em aninhamento profundo');
end;

procedure TJSONSchemaValidatorTests.TestValidate_ArrayItems;
var
  LSchema: String;
  LJson: String;
begin
  LSchema := '{"type": "array", "items": {"type": "string"}}';
  FReader.LoadFromString(LSchema);
  LJson := '["a", "b", "c"]';
  Assert.IsTrue(FReader.Validate(LJson), 'Deveria validar array com strings');

  LJson := '["a", 123, "c"]';
  Assert.IsFalse(FReader.Validate(LJson), 'Deveria falhar com tipo errado em array');
end;

procedure TJSONSchemaValidatorTests.TestValidate_ObjectWithArray;
var
  LSchema: String;
  LJson: String;
begin
  LSchema := '{"type": "object", "properties": {"data": {"type": "array", "items": {"type": "string"}}}}';
  FReader.LoadFromString(LSchema);
  LJson := '{"data": ["a", "b", "c"]}';
  Assert.IsTrue(FReader.Validate(LJson), 'Deveria validar objeto com array de strings');

  LJson := '{"data": ["a", 123, "c"]}';
  Assert.IsFalse(FReader.Validate(LJson), 'Deveria falhar com tipo errado no array');
end;

procedure TJSONSchemaValidatorTests.TestValidate_ArrayWithObjects;
var
  LSchema: String;
  LJson: String;
begin
  LSchema := '{"type": "array", "items": {"type": "object", "properties": {"id": {"type": "integer"}}}}';
  FReader.LoadFromString(LSchema);
  LJson := '[{"id": 1}, {"id": 2}]';
  Assert.IsTrue(FReader.Validate(LJson), 'Deveria validar array de objetos com IDs inteiros');

  LJson := '[{"id": 1}, {"id": "dois"}]';
  Assert.IsFalse(FReader.Validate(LJson), 'Deveria falhar com tipo errado no ID');
end;

procedure TJSONSchemaValidatorTests.TestValidate_AdditionalProperties;
var
  LSchema: String;
  LJson: String;
begin
  LSchema := '{"type": "object", "properties": {"name": {"type": "string"}}, "additionalProperties": false}';
  FReader.LoadFromString(LSchema);
  LJson := '{"name": "Isaque"}';
  Assert.IsTrue(FReader.Validate(LJson), 'Deveria validar objeto sem propriedades extras');

  LJson := '{"name": "Isaque", "age": 30}';
  Assert.IsFalse(FReader.Validate(LJson), 'Deveria falhar com propriedade extra');
end;

initialization
  TDUnitX.RegisterTestFixture(TJSONSchemaValidatorTests);

end.
