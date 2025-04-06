unit JsonFlow.TestsTraitsPropertys;

interface

uses
  DUnitX.TestFramework,
  JsonFlow.SchemaReader,
  JsonFlow.SchemaValidator;

type
  [TestFixture]
  TPropertiesConstraintsTests = class
  private
    FReader: TJSONSchemaReader;
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;
    [Test]
    procedure TestValidate_Properties;
  end;

implementation

procedure TPropertiesConstraintsTests.Setup;
begin
  FReader := TJSONSchemaReader.Create;
end;

procedure TPropertiesConstraintsTests.TearDown;
begin
  FReader.Free;
end;

procedure TPropertiesConstraintsTests.TestValidate_Properties;
var
  LSchema: String;
  LJson: String;
begin
  LSchema := '{"type": "object", "properties": {"name": {"type": "string"}, "age": {"type": "integer"}}}';
  FReader.LoadFromString(LSchema);
  LJson := '{"name": "Isaque", "age": 30}';
  Assert.IsTrue(FReader.Validate(LJson), 'Deveria validar objeto com propriedades corretas');
  LJson := '{"name": 123, "age": "30"}';
  Assert.IsFalse(FReader.Validate(LJson), 'Deveria falhar com tipos errados nas propriedades');
end;

initialization
  TDUnitX.RegisterTestFixture(TPropertiesConstraintsTests);

end.

