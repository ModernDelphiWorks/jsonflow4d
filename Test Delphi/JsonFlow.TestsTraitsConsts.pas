unit JsonFlow.TestsTraitsConsts;

interface

uses
  DUnitX.TestFramework,
  JsonFlow.SchemaReader,
  JsonFlow.SchemaValidator;

type
  [TestFixture]
  TConstConstraintsTests = class
  private
    FReader: TJSONSchemaReader;
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;
    [Test]
    procedure TestValidate_Const;
  end;

implementation

procedure TConstConstraintsTests.Setup;
begin
  FReader := TJSONSchemaReader.Create;
end;

procedure TConstConstraintsTests.TearDown;
begin
  FReader.Free;
end;

procedure TConstConstraintsTests.TestValidate_Const;
var
  LSchema: String;
  LJson: String;
begin
  LSchema := '{"type": "string", "const": "hello"}';
  FReader.LoadFromString(LSchema);
  LJson := '"hello"';
  Assert.IsTrue(FReader.Validate(LJson), 'Deveria validar valor igual ao const');
  LJson := '"world"';
  Assert.IsFalse(FReader.Validate(LJson), 'Deveria falhar com valor diferente do const');
end;

initialization
  TDUnitX.RegisterTestFixture(TConstConstraintsTests);

end.

