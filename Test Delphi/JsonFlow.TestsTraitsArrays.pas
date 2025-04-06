unit JsonFlow.TestsTraitsArrays;

interface

uses
  DUnitX.TestFramework,
  JsonFlow.SchemaReader,
  JsonFlow.SchemaValidator;

type
  [TestFixture]
  TArrayConstraintsTests = class
  private
    FReader: TJSONSchemaReader;
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;
    [Test]
    procedure TestValidate_ArrayConstraints;
  end;

implementation

procedure TArrayConstraintsTests.Setup;
begin
  FReader := TJSONSchemaReader.Create;
end;

procedure TArrayConstraintsTests.TearDown;
begin
  FReader.Free;
end;

procedure TArrayConstraintsTests.TestValidate_ArrayConstraints;
var
  LSchema: String;
  LJson: String;
begin
  // Schema com restri��es de array
  LSchema := '{"type": "array", "items": {"type": "string"}, "minItems": 2, "maxItems": 5}';
  FReader.LoadFromString(LSchema);

  // Caso v�lido
  LJson := '["apple", "banana"]';
  Assert.IsTrue(FReader.Validate(LJson), 'Deveria validar array v�lido ([apple, banana]: length=2, s� strings)');

  // Casos inv�lidos
  LJson := '["apple"]';
  Assert.IsFalse(FReader.Validate(LJson), 'Deveria falhar com array curto ([apple]: length=1 < 2)');

  LJson := '["apple", "banana", "cherry", "date", "elderberry", "fig"]';
  Assert.IsFalse(FReader.Validate(LJson), 'Deveria falhar com array longo ([...]: length=6 > 5)');

  LJson := '["apple", 123]';
  Assert.IsFalse(FReader.Validate(LJson), 'Deveria falhar com item n�o-string ([apple, 123]: 123 n�o � string)');
end;

initialization
  TDUnitX.RegisterTestFixture(TArrayConstraintsTests);

end.
