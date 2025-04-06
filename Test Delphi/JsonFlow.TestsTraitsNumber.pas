unit JsonFlow.TestsTraitsNumber;

interface

uses
  DUnitX.TestFramework,
  JsonFlow.SchemaReader,
  JsonFlow.SchemaValidator;

type
  [TestFixture]
  TNumberConstraintsTests = class
  private
    FReader: TJSONSchemaReader;
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;
    [Test]
    procedure TestValidate_NumberConstraints;
  end;

implementation

procedure TNumberConstraintsTests.Setup;
begin
  FReader := TJSONSchemaReader.Create;
end;

procedure TNumberConstraintsTests.TearDown;
begin
  FReader.Free;
end;

procedure TNumberConstraintsTests.TestValidate_NumberConstraints;
var
  LSchema: String;
  LJson: String;
begin
  // Schema com restrições de número
  LSchema := '{"type": "number", "minimum": 10, "maximum": 100, "multipleOf": 5}';
  FReader.LoadFromString(LSchema);

  // Caso válido
  LJson := '15';
  Assert.IsTrue(FReader.Validate(LJson), 'Deveria validar número válido (15: >=10, <=100, múltiplo de 5)');

  // Casos inválidos
  LJson := '8';
  Assert.IsFalse(FReader.Validate(LJson), 'Deveria falhar com número abaixo do mínimo (8 < 10)');

  LJson := '150';
  Assert.IsFalse(FReader.Validate(LJson), 'Deveria falhar com número acima do máximo (150 > 100)');

  LJson := '17';
  Assert.IsFalse(FReader.Validate(LJson), 'Deveria falhar com número não múltiplo de 5 (17 % 5 ? 0)');
end;

initialization
  TDUnitX.RegisterTestFixture(TNumberConstraintsTests);

end.

