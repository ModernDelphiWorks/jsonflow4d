unit JsonFlow.TestsTraitsDependencies;

interface

uses
  DUnitX.TestFramework,
  JsonFlow.SchemaReader,
  JsonFlow.SchemaValidator;

type
  [TestFixture]
  TDependenciesConstraintsTests = class
  private
    FReader: TJSONSchemaReader;
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;
    [Test]
    procedure TestValidate_DependenciesConstraints;
  end;

implementation

procedure TDependenciesConstraintsTests.Setup;
begin
  FReader := TJSONSchemaReader.Create;
end;

procedure TDependenciesConstraintsTests.TearDown;
begin
  FReader.Free;
end;

procedure TDependenciesConstraintsTests.TestValidate_DependenciesConstraints;
var
  LSchema: String;
  LJson: String;
begin
  LSchema := '{"type": "object", "dependencies": {"credit_card": ["billing_address"], "payment": {"properties": {"method": {"type": "string"}}}}}';
  FReader.LoadFromString(LSchema);

  LJson := '{"credit_card": "1234", "billing_address": "Rua X", "payment": "online", "method": "card"}';
  Assert.IsTrue(FReader.Validate(LJson), 'Deveria validar com dependências satisfeitas');

  LJson := '{"credit_card": "1234"}';
  Assert.IsFalse(FReader.Validate(LJson), 'Deveria falhar sem billing_address');

  LJson := '{"payment": "online", "method": 42}';
  Assert.IsFalse(FReader.Validate(LJson), 'Deveria falhar com method não-string');

  LJson := '{"other": "data"}';
  Assert.IsTrue(FReader.Validate(LJson), 'Deveria validar sem propriedades dependentes');
end;

initialization
  TDUnitX.RegisterTestFixture(TDependenciesConstraintsTests);

end.

