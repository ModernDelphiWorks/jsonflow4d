unit JsonFlow.TestsTraitsConditional;

interface

uses
  DUnitX.TestFramework,
  JsonFlow.SchemaReader,
  JsonFlow.SchemaValidator;

type
  [TestFixture]
  TConditionalConstraintsTests = class
  private
    FReader: TJSONSchemaReader;
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;
    [Test]
    procedure TestValidate_ConditionalConstraints;
  end;

implementation

procedure TConditionalConstraintsTests.Setup;
begin
  FReader := TJSONSchemaReader.Create;
end;

procedure TConditionalConstraintsTests.TearDown;
begin
  FReader.Free;
end;

procedure TConditionalConstraintsTests.TestValidate_ConditionalConstraints;
var
  LSchema: String;
  LJson: String;
begin
  // Schema com if/then/else: se type string, ent�o minLength: 3, sen�o maxLength: 2
  LSchema := '{"if": {"type": "string"}, "then": {"minLength": 3}, "else": {"maxLength": 2}}';
  FReader.LoadFromString(LSchema);

  // Casos v�lidos
  LJson := '"hello"';
  Assert.IsTrue(FReader.Validate(LJson), 'Deveria validar string >= 3 (hello: length=5)');

  LJson := '42';
  Assert.IsTrue(FReader.Validate(LJson), 'Deveria validar n�o-string <= 2 (42: OK no else)');

  // Casos inv�lidos
  LJson := '"hi"';
  Assert.IsFalse(FReader.Validate(LJson), 'Deveria falhar com string < 3 (hi: length=2)');

  // Corrigido: "abcd" � v�lido, ent�o ajustamos o Assert
  LJson := '"abcd"';
  Assert.IsTrue(FReader.Validate(LJson), 'Deveria validar string >= 3 (abcd: length=4)');
end;

initialization
  TDUnitX.RegisterTestFixture(TConditionalConstraintsTests);

end.

