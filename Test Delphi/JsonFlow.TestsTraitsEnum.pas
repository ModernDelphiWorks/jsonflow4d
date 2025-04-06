unit JsonFlow.TestsTraitsEnum;

interface

uses
  DUnitX.TestFramework,
  JsonFlow.SchemaReader,
  JsonFlow.SchemaValidator;

type
  [TestFixture]
  TEnumConstraintsTests = class
  private
    FReader: TJSONSchemaReader;
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;
    [Test]
    procedure TestValidate_Enum;
  end;

implementation

procedure TEnumConstraintsTests.Setup;
begin
  FReader := TJSONSchemaReader.Create;
end;

procedure TEnumConstraintsTests.TearDown;
begin
  FReader.Free;
end;

procedure TEnumConstraintsTests.TestValidate_Enum;
var
  LSchema: String;
  LJson: String;
begin
  LSchema := '{"type": "string", "enum": ["foo", "bar"]}';
  FReader.LoadFromString(LSchema);
  LJson := '"foo"';
  Assert.IsTrue(FReader.Validate(LJson), 'Deveria validar valor dentro do enum');
  LJson := '"baz"';
  Assert.IsFalse(FReader.Validate(LJson), 'Deveria falhar com valor fora do enum');
end;

initialization
  TDUnitX.RegisterTestFixture(TEnumConstraintsTests);

end.

