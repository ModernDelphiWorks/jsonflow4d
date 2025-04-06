unit JsonFlow.TestsTraitsPatternProperties;

interface

uses
  DUnitX.TestFramework,
  JsonFlow.SchemaReader,
  JsonFlow.SchemaValidator;

type
  [TestFixture]
  TPatternPropertiesConstraintsTests = class
  private
    FReader: TJSONSchemaReader;
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;
    [Test]
    procedure TestValidate_PatternPropertiesConstraints;
  end;

implementation

procedure TPatternPropertiesConstraintsTests.Setup;
begin
  FReader := TJSONSchemaReader.Create;
end;

procedure TPatternPropertiesConstraintsTests.TearDown;
begin
  FReader.Free;
end;

procedure TPatternPropertiesConstraintsTests.TestValidate_PatternPropertiesConstraints;
var
  LSchema: String;
  LJson: String;
begin
  // Schema com patternProperties: propriedades começando com "S_" devem ser strings
  LSchema := '{"type": "object", "patternProperties": {"^S_": {"type": "string"}}}';
  FReader.LoadFromString(LSchema);

  // Caso válido: propriedades "S_" são strings
  LJson := '{"S_name": "Isaque", "S_age": "30", "other": 42}';
  Assert.IsTrue(FReader.Validate(LJson), 'Deveria validar objeto com S_ como strings');

  // Caso inválido: "S_age" não é string
  LJson := '{"S_name": "Isaque", "S_age": 30}';
  Assert.IsFalse(FReader.Validate(LJson), 'Deveria falhar com S_age não-string');

  // Caso válido: sem propriedades "S_"
  LJson := '{"name": "Isaque", "age": 30}';
  Assert.IsTrue(FReader.Validate(LJson), 'Deveria validar objeto sem S_');
end;

initialization
  TDUnitX.RegisterTestFixture(TPatternPropertiesConstraintsTests);

end.

