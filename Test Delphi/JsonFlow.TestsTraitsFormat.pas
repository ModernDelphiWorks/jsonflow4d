unit JsonFlow.TestsTraitsFormat;

interface

uses
  DUnitX.TestFramework,
  JsonFlow.SchemaReader,
  JsonFlow.SchemaValidator;

type
  [TestFixture]
  TFormatConstraintsTests = class
  private
    FReader: TJSONSchemaReader;
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;
    [Test]
    procedure TestValidate_FormatConstraints;
  end;

implementation

procedure TFormatConstraintsTests.Setup;
begin
  FReader := TJSONSchemaReader.Create;
end;

procedure TFormatConstraintsTests.TearDown;
begin
  FReader.Free;
end;

procedure TFormatConstraintsTests.TestValidate_FormatConstraints;
var
  LSchema: String;
  LJson: String;
begin
  LSchema := '{"type": "string", "format": "date-time"}';
  FReader.LoadFromString(LSchema);

  LJson := '"2025-03-11T10:00:00Z"';
  Assert.IsTrue(FReader.Validate(LJson), 'Deveria validar date-time ISO 8601');

  LJson := '"2025-13-11T10:00:00Z"';
  Assert.IsFalse(FReader.Validate(LJson), 'Deveria falhar com mês inválido');

  LJson := '"not-a-date"';
  Assert.IsFalse(FReader.Validate(LJson), 'Deveria falhar com formato inválido');
end;

initialization
  TDUnitX.RegisterTestFixture(TFormatConstraintsTests);

end.

