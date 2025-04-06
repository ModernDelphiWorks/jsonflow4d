unit JsonFlow.TestsTraitsStrings;

interface

uses
  DUnitX.TestFramework,
  JsonFlow.SchemaReader,
  JsonFlow.SchemaValidator;

type
  [TestFixture]
  TStringConstraintsTests = class
  private
    FReader: TJSONSchemaReader;
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;
    [Test]
    procedure TestValidate_StringConstraints;
  end;

implementation

procedure TStringConstraintsTests.Setup;
begin
  FReader := TJSONSchemaReader.Create;
end;

procedure TStringConstraintsTests.TearDown;
begin
  FReader.Free;
end;

procedure TStringConstraintsTests.TestValidate_StringConstraints;
var
  LSchema: String;
  LJson: String;
begin
  // Schema com restrições de string
  LSchema := '{"type": "string", "minLength": 3, "maxLength": 10, "pattern": "^[a-z]+$"}';
  FReader.LoadFromString(LSchema);

  // Caso válido
  LJson := '"hello"';
  Assert.IsTrue(FReader.Validate(LJson), 'Deveria validar string válida (hello: length=5, a-z)');

  // Casos inválidos
  LJson := '"hi"';
  Assert.IsFalse(FReader.Validate(LJson), 'Deveria falhar com string curta (hi: length=2 < 3)');

  LJson := '"verylongstring"';
  Assert.IsFalse(FReader.Validate(LJson), 'Deveria falhar com string longa (verylongstring: length=14 > 10)');

  LJson := '"Hello123"';
  Assert.IsFalse(FReader.Validate(LJson), 'Deveria falhar com padrão inválido (Hello123: tem números, esperado só a-z)');
end;

initialization
  TDUnitX.RegisterTestFixture(TStringConstraintsTests);

end.

