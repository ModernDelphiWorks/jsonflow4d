unit JsonFlow.TestsSchemaReader;

interface

uses
  DUnitX.TestFramework,
  JsonFlow.Interfaces,
  JsonFlow.SchemaReader;

type
  [TestFixture]
  TJSONSchemaReaderTests = class
  private
    FReader: TJSONSchemaReader;
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;
    [Test]
    procedure TestLoadFromString_ValidSchema;
    [Test]
    procedure TestLoadFromString_InvalidJSON;
    [Test]
    procedure TestLoadFromFile_ValidFile;
    [Test]
    procedure TestValidate_ValidInstance;
    [Test]
    procedure TestValidate_InvalidInstance;
    [Test]
    procedure TestDetectVersion_Draft7;
    [Test]
    procedure TestDetectVersion_Draft201909;
    [Test]
    procedure TestDetectVersion_Unknown;
    [Test]
    procedure TestValidateWithSchemaString;
    [Test]
    procedure TestGetErrors;
  end;

implementation

uses
  SysUtils,
  Classes,
  IOUtils;

procedure TJSONSchemaReaderTests.Setup;
begin
  FReader := TJSONSchemaReader.Create;
end;

procedure TJSONSchemaReaderTests.TearDown;
begin
  FreeAndNil(FReader);
end;

procedure TJSONSchemaReaderTests.TestLoadFromString_ValidSchema;
var
  LSchema: String;
  LResult: Boolean;
begin
  LSchema := '{"type": "object", "properties": {"nome": {"type": "string"}}}';
  LResult := FReader.LoadFromString(LSchema);
  Assert.IsTrue(LResult, 'LoadFromString deveria retornar True para um schema válido');
  Assert.IsNotNull(FReader.GetVersion, 'Versão deveria ser detectada');
end;

procedure TJSONSchemaReaderTests.TestLoadFromString_InvalidJSON;
var
  LSchema: String;
  LResult: Boolean;
begin
  LSchema := '{type: "object"'; // JSON inválido (falta fechar chaves)
  LResult := FReader.LoadFromString(LSchema);
  Assert.IsFalse(LResult, 'LoadFromString deveria retornar False para JSON inválido');
  Assert.AreEqual(1, Length(FReader.GetErrors), 'Deveria haver um erro registrado');
  Assert.Contains(FReader.GetErrors[0].Message, 'Failed to load schema', 'Mensagem de erro esperada');
end;

procedure TJSONSchemaReaderTests.TestLoadFromFile_ValidFile;
var
  LFileName: String;
  LResult: Boolean;
begin
  LFileName := TPath.GetTempFileName;
  try
    TFile.WriteAllText(LFileName, '{"type": "object", "properties": {"idade": {"type": "integer"}}}');
    LResult := FReader.LoadFromFile(LFileName);
    Assert.IsTrue(LResult, 'LoadFromFile deveria retornar True para um arquivo válido');
  finally
    TFile.Delete(LFileName);
  end;
end;

procedure TJSONSchemaReaderTests.TestValidate_ValidInstance;
var
  LSchema: String;
  LJson: String;
  LResult: Boolean;
begin
  LSchema := '{"type": "object", "properties": {"nome": {"type": "string"}}}';
  LJson := '{"nome": "Isaque"}';
  FReader.LoadFromString(LSchema);
  LResult := FReader.Validate(LJson);
  Assert.IsTrue(LResult, 'Validate deveria retornar True para uma instância válida');
  Assert.AreEqual(0, Length(FReader.GetErrors), 'Não deveria haver erros');
end;

procedure TJSONSchemaReaderTests.TestValidate_InvalidInstance;
var
  LSchema: String;
  LJson: String;
  LResult: Boolean;
begin
  LSchema := '{"type": "object", "properties": {"nome": {"type": "string"}}}';
  LJson := '{"nome": 123}';
  FReader.LoadFromString(LSchema);
  LResult := FReader.Validate(LJson);
  Assert.IsFalse(LResult, 'Validate deveria retornar False para uma instância inválida');
  Assert.AreEqual(1, Length(FReader.GetErrors), 'Deveria haver um erro');
  Assert.Contains(FReader.GetErrors[0].Message, 'Invalid type', 'Erro de tipo esperado');
end;

procedure TJSONSchemaReaderTests.TestDetectVersion_Draft7;
var
  LSchema: String;
begin
  LSchema := '{"$schema": "http://json-schema.org/draft-07/schema#", "type": "string"}';
  FReader.LoadFromString(LSchema);
  Assert.AreEqual(jsvDraft7, FReader.GetVersion, 'Deveria detectar Draft 7');
end;

procedure TJSONSchemaReaderTests.TestDetectVersion_Draft201909;
var
  LSchema: String;
begin
  LSchema := '{"$schema": "https://json-schema.org/draft/2019-09/schema", "type": "string"}';
  FReader.LoadFromString(LSchema);
  Assert.AreEqual(jsvDraft201909, FReader.GetVersion, 'Deveria detectar Draft 2019-09');
end;

procedure TJSONSchemaReaderTests.TestDetectVersion_Unknown;
var
  LSchema: String;
begin
  LSchema := '{"$schema": "http://json-schema.org/draft-99/schema#", "type": "string"}';
  FReader.LoadFromString(LSchema);
  Assert.AreEqual(jsvDraft7, FReader.GetVersion, 'Deveria defaultar pra Draft 7 pra versão desconhecida');
  Assert.AreEqual(1, Length(FReader.GetErrors), 'Deveria registrar um erro pra versão desconhecida');
end;

procedure TJSONSchemaReaderTests.TestValidateWithSchemaString;
var
  LSchema: String;
  LJson: String;
  LResult: Boolean;
begin
  LSchema := '{"type": "object", "properties": {"nome": {"type": "string"}}}';
  LJson := '{"nome": "Isaque"}';
  LResult := FReader.Validate(LJson, LSchema);
  Assert.IsTrue(LResult, 'Validate com schema string deveria retornar True para instância válida');
  Assert.AreEqual(0, Length(FReader.GetErrors), 'Não deveria haver erros');
end;

procedure TJSONSchemaReaderTests.TestGetErrors;
var
  LSchema: String;
  LJson: String;
begin
  LSchema := '{"type": "object", "properties": {"nome": {"type": "string"}}, "required": ["nome"]}';
  LJson := '{"nome": 123}';
  FReader.LoadFromString(LSchema);
  FReader.Validate(LJson);
  Assert.AreEqual(1, Length(FReader.GetErrors), 'Deveria haver um erro de tipo');
  Assert.Contains(FReader.GetErrors[0].Message, 'Invalid type', 'Mensagem de erro esperada');
end;

initialization
  TDUnitX.RegisterTestFixture(TJSONSchemaReaderTests);

end.
