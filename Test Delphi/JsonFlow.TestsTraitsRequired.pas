unit JsonFlow.TestsTraitsRequired;

interface

uses
  DUnitX.TestFramework,
  JsonFlow.SchemaReader,
  JsonFlow.SchemaValidator;

type
  [TestFixture]
  TRequiredConstraintsTests = class
  private
    FReader: TJSONSchemaReader;
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;
    [Test]
    procedure TestValidate_Required;
  end;

implementation

procedure TRequiredConstraintsTests.Setup;
begin
  FReader := TJSONSchemaReader.Create;
end;

procedure TRequiredConstraintsTests.TearDown;
begin
  FReader.Free;
end;

procedure TRequiredConstraintsTests.TestValidate_Required;
var
  LSchema: String;
  LJson: String;
begin
  LSchema := '{"type": "object", "required": ["name"]}';
  FReader.LoadFromString(LSchema);
  LJson := '{"name": "Isaque"}';
  Assert.IsTrue(FReader.Validate(LJson), 'Deveria validar objeto com campo requerido presente');

  LJson := '{"age": 30}';
  Assert.IsFalse(FReader.Validate(LJson), 'Deveria falhar sem campo requerido');
end;

initialization
  TDUnitX.RegisterTestFixture(TRequiredConstraintsTests);

end.

