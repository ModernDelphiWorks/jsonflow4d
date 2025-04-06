unit JsonFlow.TestsTraitsObjects;

interface

uses
  DUnitX.TestFramework,
  JsonFlow.SchemaReader,
  JsonFlow.SchemaValidator;

type
  [TestFixture]
  TObjectConstraintsTests = class
  private
    FReader: TJSONSchemaReader;
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;
    [Test]
    procedure TestValidate_ObjectConstraints;
  end;

implementation

procedure TObjectConstraintsTests.Setup;
begin
  FReader := TJSONSchemaReader.Create;
end;

procedure TObjectConstraintsTests.TearDown;
begin
  FReader.Free;
end;

procedure TObjectConstraintsTests.TestValidate_ObjectConstraints;
var
  LSchema: String;
  LJson: String;
begin
  // Schema com restri��es de objeto, incluindo propriedades definidas
  LSchema := '{"type": "object", "properties": {"name": {"type": "string"}, "age": {"type": "integer"}}, "additionalProperties": false, "minProperties": 2, "maxProperties": 4}';
  FReader.LoadFromString(LSchema);

  // Caso v�lido: 2 propriedades, dentro do limite, s� as definidas
  LJson := '{"name": "Isaque", "age": 30}';
  Assert.IsTrue(FReader.Validate(LJson), 'Deveria validar objeto v�lido ({name, age}: 2 props, s� definidas)');

  // Caso inv�lido: poucas propriedades (menos que minProperties)
  LJson := '{"name": "Isaque"}';
  Assert.IsFalse(FReader.Validate(LJson), 'Deveria falhar com poucas propriedades ({name}: 1 < 2)');

  // Caso inv�lido: muitas propriedades (mais que maxProperties)
  LJson := '{"name": "Isaque", "age": 30, "city": "SP", "job": "Dev", "hobby": "Code"}';
  Assert.IsFalse(FReader.Validate(LJson), 'Deveria falhar com muitas propriedades ({name, age, city, job, hobby}: 5 > 4)');

  // Caso inv�lido: propriedades adicionais n�o permitidas
  LJson := '{"name": "Isaque", "age": 30, "extra": "test"}';
  Assert.IsFalse(FReader.Validate(LJson), 'Deveria falhar com propriedade extra n�o permitida ({name, age, extra}: additionalProperties=false)');
end;

initialization
  TDUnitX.RegisterTestFixture(TObjectConstraintsTests);

end.

