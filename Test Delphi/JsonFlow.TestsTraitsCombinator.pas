unit JsonFlow.TestsTraitsCombinator;

interface

uses
  DUnitX.TestFramework,
  JsonFlow.SchemaReader,
  JsonFlow.SchemaValidator;

type
  [TestFixture]
  TCombinatorConstraintsTests = class
  private
    FReader: TJSONSchemaReader;
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;
    [Test]
    procedure TestValidate_CombinatorConstraints;
  end;

implementation

procedure TCombinatorConstraintsTests.Setup;
begin
  FReader := TJSONSchemaReader.Create;
end;

procedure TCombinatorConstraintsTests.TearDown;
begin
  FReader.Free;
end;

procedure TCombinatorConstraintsTests.TestValidate_CombinatorConstraints;
var
  LSchema: String;
  LJson: String;
begin
  // Schema com allOf: deve satisfazer todos os subschemas
  LSchema := '{"type": "string", "allOf": [{"minLength": 3}, {"pattern": "^[a-z]+$"}]}';
  FReader.LoadFromString(LSchema);

  // Caso v�lido
  LJson := '"hello"';
  Assert.IsTrue(FReader.Validate(LJson), 'Deveria validar string v�lida (hello: length=5, s� letras min�sculas)');

  // Casos inv�lidos
  LJson := '"hi"';
  Assert.IsFalse(FReader.Validate(LJson), 'Deveria falhar com string curta (hi: length=2 < 3)');

  LJson := '"Hello"';
  Assert.IsFalse(FReader.Validate(LJson), 'Deveria falhar com padr�o inv�lido (Hello: tem mai�scula)');

  // Schema com anyOf: deve satisfazer pelo menos um subschema
  LSchema := '{"anyOf": [{"type": "string", "minLength": 5}, {"type": "integer"}]}';
  FReader.LoadFromString(LSchema);

  LJson := '"hello"';
  Assert.IsTrue(FReader.Validate(LJson), 'Deveria validar string >= 5 (hello: length=5)');

  LJson := '42';
  Assert.IsTrue(FReader.Validate(LJson), 'Deveria validar integer (42)');

  LJson := '"hi"';
  Assert.IsFalse(FReader.Validate(LJson), 'Deveria falhar (hi: length=2 < 5 e n�o � integer)');

  // Schema com oneOf: deve satisfazer exatamente um subschema
  LSchema := '{"oneOf": [{"type": "string", "minLength": 5}, {"type": "integer"}]}';
  FReader.LoadFromString(LSchema);

  LJson := '"hello"';
  Assert.IsTrue(FReader.Validate(LJson), 'Deveria validar string >= 5 (hello: length=5)');

  LJson := '42';
  Assert.IsTrue(FReader.Validate(LJson), 'Deveria validar integer (42)');

  LJson := '"hi"';
  Assert.IsFalse(FReader.Validate(LJson), 'Deveria falhar (hi: length=2 < 5 e n�o � integer)');
end;

initialization
  TDUnitX.RegisterTestFixture(TCombinatorConstraintsTests);

end.

