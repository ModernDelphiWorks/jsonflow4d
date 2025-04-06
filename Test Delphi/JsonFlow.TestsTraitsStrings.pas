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
  // Schema com restri��es de string
  LSchema := '{"type": "string", "minLength": 3, "maxLength": 10, "pattern": "^[a-z]+$"}';
  FReader.LoadFromString(LSchema);

  // Caso v�lido
  LJson := '"hello"';
  Assert.IsTrue(FReader.Validate(LJson), 'Deveria validar string v�lida (hello: length=5, a-z)');

  // Casos inv�lidos
  LJson := '"hi"';
  Assert.IsFalse(FReader.Validate(LJson), 'Deveria falhar com string curta (hi: length=2 < 3)');

  LJson := '"verylongstring"';
  Assert.IsFalse(FReader.Validate(LJson), 'Deveria falhar com string longa (verylongstring: length=14 > 10)');

  LJson := '"Hello123"';
  Assert.IsFalse(FReader.Validate(LJson), 'Deveria falhar com padr�o inv�lido (Hello123: tem n�meros, esperado s� a-z)');
end;

initialization
  TDUnitX.RegisterTestFixture(TStringConstraintsTests);

end.

