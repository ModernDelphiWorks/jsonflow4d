unit JsonFlow.TestsTraitsContent;

interface

uses
  DUnitX.TestFramework,
  JsonFlow.SchemaReader,
  JsonFlow.SchemaValidator;

type
  [TestFixture]
  TContentConstraintsTests = class
  private
    FReader: TJSONSchemaReader;
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;
    [Test]
    procedure TestValidate_ContentConstraints;
  end;

implementation

procedure TContentConstraintsTests.Setup;
begin
  FReader := TJSONSchemaReader.Create;
end;

procedure TContentConstraintsTests.TearDown;
begin
  FReader.Free;
end;

procedure TContentConstraintsTests.TestValidate_ContentConstraints;
var
  LSchema: String;
  LJson: String;
begin
  // Schema com contentMediaType e contentEncoding
  LSchema := '{"type": "string", "contentMediaType": "application/json", "contentEncoding": "base64"}';
  FReader.LoadFromString(LSchema);

  // Caso válido: JSON válido codificado em base64
  LJson := '"eyJuYW1lIjoiSXNhcXVlIn0="'; // {"name":"Isaque"} em base64
  Assert.IsTrue(FReader.Validate(LJson), 'Deveria validar JSON em base64');

  // Casos inválidos
  LJson := '"SGVsbG8gV29ybGQ="'; // "Hello World" em base64, não é JSON
  Assert.IsFalse(FReader.Validate(LJson), 'Deveria falhar com base64 não-JSON');

  LJson := '"plain text"'; // Texto sem codificação base64
  Assert.IsFalse(FReader.Validate(LJson), 'Deveria falhar com texto sem base64');
end;

initialization
  TDUnitX.RegisterTestFixture(TContentConstraintsTests);

end.

