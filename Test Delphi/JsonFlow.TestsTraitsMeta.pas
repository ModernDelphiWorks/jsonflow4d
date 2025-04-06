unit JsonFlow.TestsTraitsMeta;

interface

uses
  IOUtils,
  SysUtils,
  DUnitX.TestFramework,
  JsonFlow.SchemaReader;

type
  [TestFixture]
  TMetaSchemaTests = class
  public
    [Test]
    procedure TestSimpleSchema;
    [Test]
    procedure TestDefinitions;
    [Test]
    procedure TestCombinators;
    [Test]
    procedure TestBooleanValues;
    [Test]
    procedure TestRecursiveRef;
    [Test]
    procedure TestMetaSchemaSnippet;
    [Test]
    procedure TestValidate_MetaSchema;
    [Test]
    procedure TestPropertiesConstraintsRef;
    [Test]
    procedure TestAnyOfWithRefAndTrue;
    [Test]
    procedure TestParseAndSaveMetaSchema;
  end;

implementation

uses
  JsonFlow.SchemaValidator,
  JsonFlow.Interfaces,
  JsonFlow.Writer;

procedure TMetaSchemaTests.TestSimpleSchema;
var
  LReader: TJSONSchemaReader;
begin
  LReader := TJSONSchemaReader.Create;
  try
    Assert.IsTrue(LReader.LoadFromString('{"type": "object", "properties": {"name": {"type": "string"}}}'),
      'Deveria carregar schema simples');
    Assert.IsTrue(LReader.Validate('{"name": "João"}'), 'Deveria validar JSON simples');
  finally
    LReader.Free;
  end;
end;

procedure TMetaSchemaTests.TestDefinitions;
var
  LReader: TJSONSchemaReader;
begin
  LReader := TJSONSchemaReader.Create;
  try
    Assert.IsTrue(LReader.LoadFromString('{"definitions": {"stringType": {"type": "string"}}, "type": "object", "properties": {"name": {"$ref": "#/definitions/stringType"}}}'),
      'Deveria carregar schema com definitions');
    Assert.IsTrue(LReader.Validate('{"name": "João"}'), 'Deveria validar com $ref em definitions');
  finally
    LReader.Free;
  end;
end;

procedure TMetaSchemaTests.TestCombinators;
var
  LReader: TJSONSchemaReader;
begin
  LReader := TJSONSchemaReader.Create;
  try
    Assert.IsTrue(LReader.LoadFromString('{"type": {"anyOf": [{"type": "string"}, {"type": "number"}]}}'),
      'Deveria carregar schema com anyOf');
    Assert.IsTrue(LReader.Validate('"João"'), 'Deveria validar string com anyOf');
    Assert.IsTrue(LReader.Validate('42'), 'Deveria validar número com anyOf');
    Assert.IsFalse(LReader.Validate('true'), 'Deveria falhar com booleano fora do anyOf');
  finally
    LReader.Free;
  end;
end;

procedure TMetaSchemaTests.TestBooleanValues;
var
  LReader: TJSONSchemaReader;
begin
  LReader := TJSONSchemaReader.Create;
  try
    Assert.IsTrue(LReader.LoadFromString('{"type": "array", "items": true, "default": true}'),
      'Deveria carregar schema com valores booleanos');
    Assert.IsTrue(LReader.Validate('[]'), 'Deveria validar array vazio com items true');
    Assert.IsTrue(LReader.Validate('[1, "a"]'), 'Deveria validar array com itens variados');
  finally
    LReader.Free;
  end;
end;

procedure TMetaSchemaTests.TestRecursiveRef;
var
  LReader: TJSONSchemaReader;
begin
  LReader := TJSONSchemaReader.Create;
  try
    Assert.IsTrue(LReader.LoadFromString('{"type": "object", "properties": {"ref": {"$ref": "#"}}}'),
      'Deveria carregar schema com $ref recursivo');
    Assert.IsTrue(LReader.Validate('{"ref": {"ref": {}}}'), 'Deveria validar objeto recursivo');
  finally
    LReader.Free;
  end;
end;

procedure TMetaSchemaTests.TestMetaSchemaSnippet;
var
  LReader: TJSONSchemaReader;
begin
  LReader := TJSONSchemaReader.Create;
  try
    Assert.IsTrue(LReader.LoadFromString('{"definitions": {"x": {"type": "string"}}, "anyOf": [{"$ref": "#/definitions/x"}, true]}'),
      'Deveria carregar schema com $ref e anyOf');
    Assert.IsTrue(LReader.Validate('"teste"'), 'Deveria validar string');
    Assert.IsTrue(LReader.Validate('42'), 'Deveria validar qualquer coisa por true');
  finally
    LReader.Free;
  end;
end;

procedure TMetaSchemaTests.TestValidate_MetaSchema;
var
  LReader: TJSONSchemaReader;
  LSchemaText: String;
begin
  LReader := TJSONSchemaReader.Create;
  try
    LSchemaText := TFile.ReadAllText('json-schema.json'); // Ajusta o caminho pro teu arquivo
    Assert.IsTrue(LReader.LoadFromString(LSchemaText), 'Deveria carregar o meta-schema Draft 7');
    Assert.IsTrue(LReader.Validate('{"type": "string"}'), 'Deveria validar um schema simples');
  finally
    LReader.Free;
  end;
end;

procedure TMetaSchemaTests.TestParseAndSaveMetaSchema;
var
  LReader: TJSONSchemaReader;
  LSchemaText: String;
  LSchemaElement: IJSONElement;
  LWriter: TJSONWriter;
  LParsedFile: String;
begin
  LReader := TJSONSchemaReader.Create;
  try
    LSchemaText := TFile.ReadAllText('json-schema.json');
    Assert.IsTrue(LReader.LoadFromString(LSchemaText), 'Deveria carregar o meta-schema Draft 7');
    LSchemaElement := LReader.GetSchema;
    LWriter := TJSONWriter.Create;
    try
      LParsedFile := 'parsed_schema.json';
      TFile.WriteAllText(LParsedFile, LWriter.Write(LSchemaElement, True));
//      AddLog('Schema parseado salvo em: ' + LParsedFile);
    finally
      LWriter.Free;
    end;
  finally
    LReader.Free;
  end;
end;

procedure TMetaSchemaTests.TestPropertiesConstraintsRef;
var
  LReader: TJSONSchemaReader;
begin
  LReader := TJSONSchemaReader.Create;
  try
    // Schema mínimo com $ref auto-referencial
    Assert.IsTrue(LReader.LoadFromString('{"type": "object", "properties": {"ref": {"$ref": "#"}}}'));

    // Valida um JSON simples que usa o schema
    Assert.IsTrue(LReader.Validate('{"ref": {"ref": {}}}'), 'Deveria validar schema com $ref');
  finally
    LReader.Free;
  end;
end;

procedure TMetaSchemaTests.TestAnyOfWithRefAndTrue;
var
  LValidator: TJSONSchemaValidator;
  LSchema, LJson: string;
begin
  LSchema := '{' +
    '"$schema": "http://json-schema.org/draft-07/schema#",' +
    '"definitions": {' +
    '  "stringType": {"type": "string"},' +
    '  "schemaArray": {"type": "array", "items": {"$ref": "#"}}' +
    '},' +
    '"type": "object",' +
    '"properties": {' +
    '  "items": {' +
    '    "anyOf": [' +
    '      {"$ref": "#"},' +
    '      {"$ref": "#/definitions/schemaArray"},' +
    '      true' +
    '    ],' +
    '    "default": true' +
    '  }' +
    '}' +
  '}';
  LJson := '{"items": ["test"]}';

  LValidator := TJSONSchemaValidator.Create(jsvDraft7);
  try
    Assert.IsTrue(LValidator.Validate(LJson, LSchema), 'Validation should succeed');
  finally
    LValidator.Free;
  end;
end;

initialization
  TDUnitX.RegisterTestFixture(TMetaSchemaTests);

end.

