unit JsonFlow.TestsTraitsAnchors;

interface

uses
  DUnitX.TestFramework,
  JsonFlow.SchemaReader,
  JsonFlow.SchemaValidator;

type
  [TestFixture]
  TAnchorsConstraintsTests = class
  private
    FReader: TJSONSchemaReader;
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;
    [Test]
    procedure TestParse_Anchors;
  end;

implementation

procedure TAnchorsConstraintsTests.Setup;
begin
  FReader := TJSONSchemaReader.Create;
end;

procedure TAnchorsConstraintsTests.TearDown;
begin
  FReader.Free;
end;

procedure TAnchorsConstraintsTests.TestParse_Anchors;
var
  LSchema: String;
begin
  LSchema := '{"definitions": {"test": {"$anchor": "test", "type": "string"}}, "$ref": "#test"}';
  FReader.LoadFromString(LSchema);
  Assert.IsTrue(FReader.Validate('"hello"'), 'Deveria validar usando a âncora referenciada');
  Assert.IsFalse(FReader.Validate('123'), 'Deveria falhar com tipo errado na âncora referenciada');
end;

initialization
  TDUnitX.RegisterTestFixture(TAnchorsConstraintsTests);

end.
