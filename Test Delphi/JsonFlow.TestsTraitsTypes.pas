unit JsonFlow.TestsTraitsTypes;

interface

uses
  DUnitX.TestFramework,
  JsonFlow.SchemaReader,
  JsonFlow.SchemaValidator;

type
  [TestFixture]
  TTypeConstraintsTests = class
  private
    FReader: TJSONSchemaReader;
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;
    [Test]
    procedure TestValidate_Type;
    [Test]
    procedure TestValidate_NumberType;
  end;

implementation

procedure TTypeConstraintsTests.Setup;
begin
  FReader := TJSONSchemaReader.Create;
end;

procedure TTypeConstraintsTests.TearDown;
begin
  FReader.Free;
end;

procedure TTypeConstraintsTests.TestValidate_Type;
var
  LSchema: String;
  LJson: String;
begin
  LSchema := '{"type": "string"}';
  FReader.LoadFromString(LSchema);
  LJson := '"Isaque"';
  Assert.IsTrue(FReader.Validate(LJson), 'Deveria validar string correta');

  LJson := '123';
  Assert.IsFalse(FReader.Validate(LJson), 'Deveria falhar com tipo errado (integer ao invés de string)');
end;

procedure TTypeConstraintsTests.TestValidate_NumberType;
begin
  FReader.LoadFromString('{"type": "number"}');
  Assert.IsTrue(FReader.Validate('30'), 'Integer should be valid as number');
//  Assert.IsTrue(FReader.Validate('3.14'), 'Float should be valid as number');
//  Assert.IsFalse(FReader.Validate('"text"'), 'String should not be valid as number');
end;

initialization
  TDUnitX.RegisterTestFixture(TTypeConstraintsTests);

end.

