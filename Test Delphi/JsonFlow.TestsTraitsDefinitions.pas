unit JsonFlow.TestsTraitsDefinitions;

interface

uses
  DUnitX.TestFramework,
  JsonFlow.SchemaReader,
  JsonFlow.SchemaValidator;

type
  [TestFixture]
  TDefinitionsConstraintsTests = class
  private
    FReader: TJSONSchemaReader;
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;
    [Test]
    procedure TestParse_Definitions;
  end;

implementation

procedure TDefinitionsConstraintsTests.Setup;
begin
  FReader := TJSONSchemaReader.Create;
end;

procedure TDefinitionsConstraintsTests.TearDown;
begin
  FReader.Free;
end;

procedure TDefinitionsConstraintsTests.TestParse_Definitions;
var
  LSchema: String;
begin
  LSchema := '{"definitions": {"test": {"type": "string"}}, "$ref": "#/definitions/test"}';
  FReader.LoadFromString(LSchema);
  Assert.IsTrue(FReader.Validate('"hello"'), 'Deveria validar usando a definição referenciada');
end;

initialization
  TDUnitX.RegisterTestFixture(TDefinitionsConstraintsTests);

end.

