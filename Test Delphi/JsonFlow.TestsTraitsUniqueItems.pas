unit JsonFlow.TestsTraitsUniqueItems;

interface

uses
  DUnitX.TestFramework,
  JsonFlow.SchemaReader,
  JsonFlow.SchemaValidator;

type
  [TestFixture]
  TUniqueItemsConstraintsTests = class
  private
    FReader: TJSONSchemaReader;
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;
    [Test]
    procedure TestValidate_UniqueItemsConstraints;
  end;

implementation

procedure TUniqueItemsConstraintsTests.Setup;
begin
  FReader := TJSONSchemaReader.Create;
end;

procedure TUniqueItemsConstraintsTests.TearDown;
begin
  FReader.Free;
end;

procedure TUniqueItemsConstraintsTests.TestValidate_UniqueItemsConstraints;
var
  LSchema: String;
  LJson: String;
begin
  // Schema com uniqueItems: true
  LSchema := '{"type": "array", "uniqueItems": true}';
  FReader.LoadFromString(LSchema);

  // Caso válido: itens únicos
  LJson := '[1, 2, 3]';
  Assert.IsTrue(FReader.Validate(LJson), 'Deveria validar array com itens únicos');

  // Caso inválido: duplicatas
  LJson := '[1, 2, 2]';
  Assert.IsFalse(FReader.Validate(LJson), 'Deveria falhar com itens duplicados');

  // Caso válido: array vazio
  LJson := '[]';
  Assert.IsTrue(FReader.Validate(LJson), 'Deveria validar array vazio');
end;

initialization
  TDUnitX.RegisterTestFixture(TUniqueItemsConstraintsTests);

end.

