unit JsonFlowTestsShemaComposer;

interface

uses
  Classes, SysUtils, IOUtils, DUnitX.TestFramework,
  JsonFlow.SchemaComposer,
  JsonFlow.SchemaValidator,
  JsonFlow.Interfaces,
  JsonFlow.Objects;

type
  [TestFixture]
  TJSONSmartSchemaComposerTests = class
  private
    FComposer: TJSONSchemaComposer;
    FValidator: TJSONSchemaValidator;
    procedure LoadMetaSchema;
    procedure LogJSONHierarchy(const AElement: IJSONElement; const APath: String);
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;
//    [Test]
    procedure TestBasicSchemaCreationWithClass;
//    [Test]
    procedure TestBasicSchemaCreation;
//    [Test]
    procedure TestInvalidSchemaGeneration;
//    [Test]
    procedure TestSchemaWithMinimum;
//    [Test]
    procedure TestEnum;
//    [Test]
    procedure TestConst;
//    [Test]
    procedure TestDefault;
//    [Test]
    procedure TestTitleAndDescription;
//    [Test]
    procedure TestStringValidations;
//    [Test]
    procedure TestNumberValidations;
//    [Test]
    procedure TestArrayValidations;
//    [Test]
    procedure TestObjectValidations;
//    [Test]
    procedure TestConditionalIfThenElse;
//    [Test]
    procedure TestCombinationsAllOf;
//    [Test]
    procedure TestCombinationsAnyOf;
//    [Test]
    procedure TestCombinationsOneOf;
//    [Test]
    procedure TestCombinationsNot;
//    [Test]
    procedure TestDefinitionsAndRef;
//    [Test]
    procedure TestValidateGeneratedSchemaAgainstMetaSchema;
//    [Test]
    procedure TestValidateJSONAgainstGeneratedSchema;
//    [Test]
    procedure TestValidateJSONAgainstGeneratedSchemaString;
//    [Test]
    procedure TestValidateTypeString;
//    [Test]
    procedure TestValidateRequiredString;
//    [Test]
    procedure TestValidateMinLengthString;
//    [Test]
    procedure TestValidateMaxLengthString;
//    [Test]
    procedure TestValidatePatternString;
//    [Test]
    procedure TestValidateEnumString;
//    [Test]
    procedure TestValidateFormatEmail;
//    [Test]
    procedure TestValidateMinimumNumber;
//    [Test]
    procedure TestValidateMaximumNumber;
//    [Test]
    procedure TestValidateMultipleOfNumber;
//    [Test]
    procedure TestValidateExclusiveMaximumNumber;
//    [Test]
    procedure TestValidateExclusiveMinimumNumber;
//    [Test]
    procedure TestValidateMinItems;
//    [Test]
    procedure TestValidateMaxItems;
//    [Test]
    procedure TestValidateJSONAgainstGeneratedSchemaIsolated;
//    [Test]
    procedure TestValidateSimpleRefWithDefinitions;
//    [Test]
    procedure TestCommentInSchema;
//    [Test]
    procedure TestExamplesInSchema;
//    [Test]
    procedure TestSintaxSimple;
//    [Test]
    procedure TestValidateGeneratedSchemaAgainstMetaSchemaFluido;
//    [Test]
    procedure TestTypeConstraintsOnly;
//    [Test]
    procedure TestRefConstraintsOnly;
//    [Test]
    procedure TestRefTypePropertiesConstraints;
//    [Test]
    procedure TestRefTypePropertiesObjectConstraints;
//    [Test]
    procedure TestRefTypePropertiesObjectRequiredConstraints;
//    [Test]
    procedure TestRefTypePropertiesObjectRequiredEnumConstraints;
//    [Test]
    procedure TestRefTypePropertiesObjectRequiredEnumDefinitionsConstraints;
//    [Test]
    procedure TestRefTypePropertiesObjectRequiredEnumDefinitionsStringConstraints;
//    [Test]
    procedure TestRefTypePropertiesObjectRequiredEnumDefinitionsStringNumberConstraints;
//    [Test]
    procedure TestRefTypePropertiesObjectRequiredEnumDefinitionsStringNumberArrayConstraints;
//    [Test]
    procedure TestRefTypePropertiesObjectRequiredEnumDefinitionsStringNumberArrayMetadataConstraints;
//    [Test]
    procedure TestRefTypePropertiesObjectRequiredEnumDefinitionsStringNumberArrayMetadataFormatConstraints;
//    [Test]
    procedure TestRefTypePropertiesObjectRequiredEnumDefinitionsStringNumberArrayMetadataFormatUniqueConstraints;
//    [Test]
    procedure TestRefTypePropertiesObjectRequiredEnumDefinitionsStringNumberArrayMetadataFormatUniquePatternConstraints;
//    [Test]
    procedure TestRefTypePropertiesObjectRequiredEnumDefinitionsStringNumberArrayMetadataFormatUniquePatternDependenciesConstraints;
//    [Test]
    procedure TestRefTypePropertiesObjectRequiredEnumDefinitionsStringNumberArrayMetadataFormatUniquePatternDependenciesConstConstraints;
//    [Test]
    procedure TestRefTypePropertiesObjectRequiredEnumDefinitionsStringNumberArrayMetadataFormatUniquePatternDependenciesConstAnchorsConstraints;
//    [Test]
    procedure TestRefTypePropertiesObjectRequiredEnumDefinitionsStringNumberArrayMetadataFormatUniquePatternDependenciesConstAnchorsCombinatorConstraints;
//    [Test]
    procedure TestRefTypePropertiesObjectRequiredEnumDefinitionsStringNumberArrayMetadataFormatUniquePatternDependenciesConstAnchorsCombinatorConditionalConstraints;
//    [Test]
    procedure TestRefTypePropertiesObjectRequiredEnumDefinitionsStringNumberArrayMetadataFormatUniquePatternDependenciesConstAnchorsCombinatorConditionalContentConstraints;
    [Test]
    procedure TestGradualMetaSchemaBuildStep1;
    [Test]
    procedure TestGradualMetaSchemaBuildStep2;
    [Test]
    procedure TestGradualMetaSchemaBuildStep3;
    [Test]
    procedure TestGradualMetaSchemaBuildStep4;
    [Test]
    procedure TestGradualMetaSchemaBuildStep5;
    [Test]
    procedure TestGradualMetaSchemaBuildStep6;
//    [Test]
    procedure TestGradualMetaSchemaBuildStep7;
//    [Test]
    procedure TestGradualMetaSchemaBuildStep8;
//    [Test]
    procedure TestGradualMetaSchemaBuildStep9;
//    [Test]
    procedure TestGradualMetaSchemaBuildStep10;
//    [Test]
    procedure TestGradualMetaSchemaBuildStep11;
//    [Test]
    procedure TestGradualMetaSchemaBuildStep12;
//    [Test]
    procedure TestGradualMetaSchemaBuildStep13;
  end;

implementation

uses
  JsonFlow.Reader,
  JsonFlow.Value,
  Generics.Collections, System.Math, System.StrUtils;


procedure TJSONSmartSchemaComposerTests.Setup;
begin
  Writeln('Setup iniciado');
  FComposer := TJSONSchemaComposer.Create;
  FComposer.EnableSmartMode(True);
  FValidator := TJSONSchemaValidator.Create(jsvDraft7);
//  LoadMetaSchema;
  Writeln('Setup concluído');
end;

procedure TJSONSmartSchemaComposerTests.TearDown;
begin
  Writeln('TearDown iniciado');
  FValidator.Free;
  FComposer.Free;
  Writeln('TearDown concluído');
end;

procedure TJSONSmartSchemaComposerTests.LoadMetaSchema;
var
  LReader: TJsonReader;
begin
  Writeln('Carregando meta-schema');
  LReader := TJsonReader.Create;
  try
    FValidator.ParseSchema(LReader.Read(TFile.ReadAllText('json-schema.json')));
    Writeln('Meta-schema carregado');
  finally
    LReader.Free;
  end;
end;

procedure TJSONSmartSchemaComposerTests.TestBasicSchemaCreationWithClass;
var
  LJSONSchema: String;
begin
  Writeln('TestBasicSchemaCreationWithClass');
  FComposer.Obj
    .Typ('object')
    .PropType('name', 'string', True)
    .PropType('age', 'integer')
    .EndObj;

  LJSONSchema := FComposer.ToJSON;
  Writeln('Schema: ' + LJSONSchema);
  Assert.IsNotEmpty(LJSONSchema);
  Assert.Contains(LJSONSchema, '"type":"object"');
  Assert.Contains(LJSONSchema, '"name":{"type":"string"}');
  Assert.Contains(LJSONSchema, '"age":{"type":"integer"}');
  Assert.Contains(LJSONSchema, '"required":["name"]');
end;

procedure TJSONSmartSchemaComposerTests.TestBasicSchemaCreation;
var
  LJSONSchema: String;
begin
  Writeln('TestBasicSchemaCreation');
  FComposer.Obj
    .Typ('object')
    .PropType('name', 'string', True)
    .PropType('age', 'integer')
    .EndObj;

  LJSONSchema := FComposer.ToJSON;
  Writeln('Schema: ' + LJSONSchema);
  Assert.IsNotEmpty(LJSONSchema);
  Assert.Contains(LJSONSchema, '"type":"object"');
  Assert.Contains(LJSONSchema, '"name":{"type":"string"}');
  Assert.Contains(LJSONSchema, '"age":{"type":"integer"}');
  Assert.Contains(LJSONSchema, '"required":["name"]');
end;

procedure TJSONSmartSchemaComposerTests.TestInvalidSchemaGeneration;
var
  LJSONSchema: String;
begin
  Writeln('TestInvalidSchemaGeneration');
  FComposer.Obj
    .Typ('object')
    .PropType('name', 'string', True)
    .EndObj;

  LJSONSchema := FComposer.ToJSON;
  Writeln('Schema: ' + LJSONSchema);
  Assert.IsNotEmpty(LJSONSchema);
  Assert.Contains(LJSONSchema, '"type":"object"');
  Assert.Contains(LJSONSchema, '"name":{"type":"string"}');
  Assert.Contains(LJSONSchema, '"required":["name"]');
end;

procedure TJSONSmartSchemaComposerTests.TestSchemaWithMinimum;
var
  LJSONSchema: String;
begin
  Writeln('TestSchemaWithMinimum');
  FComposer.Obj
    .Typ('object')
    .Prop('age', procedure(P: TJSONSchemaComposer) begin P.Typ('integer').Min(0); end)
    .EndObj;

  LJSONSchema := FComposer.ToJSON;
  Writeln('Schema: ' + LJSONSchema);
  Assert.IsNotEmpty(LJSONSchema);
  Assert.Contains(LJSONSchema, '"type":"object"');
  Assert.Contains(LJSONSchema, '"age":{"type":"integer","minimum":0}');
end;

procedure TJSONSmartSchemaComposerTests.TestEnum;
var
  LJSONSchema: String;
begin
  Writeln('TestEnum');
  FComposer.Typ('string')
    .Enum(['red', 'blue', 'green']);

  LJSONSchema := FComposer.ToJSON;
  Writeln('Schema: ' + LJSONSchema);
  Assert.IsNotEmpty(LJSONSchema);
  Assert.Contains(LJSONSchema, '"type":"string"');
  Assert.Contains(LJSONSchema, '"enum":["red","blue","green"]');
end;

procedure TJSONSmartSchemaComposerTests.TestConst;
var
  LJSONSchema: String;
begin
  Writeln('TestConst');
  FComposer.Typ('integer')
    .Cst(42);

  LJSONSchema := FComposer.ToJSON;
  Writeln('Schema: ' + LJSONSchema);
  Assert.IsNotEmpty(LJSONSchema);
  Assert.Contains(LJSONSchema, '"type":"integer"');
  Assert.Contains(LJSONSchema, '"const":42');
end;

procedure TJSONSmartSchemaComposerTests.TestDefault;
var
  LJSONSchema: String;
begin
  Writeln('TestDefault');
  FComposer.Typ('string')
    .Default('unknown');

  LJSONSchema := FComposer.ToJSON;
  Writeln('Schema: ' + LJSONSchema);
  Assert.IsNotEmpty(LJSONSchema);
  Assert.Contains(LJSONSchema, '"type":"string"');
  Assert.Contains(LJSONSchema, '"default":"unknown"');
end;

procedure TJSONSmartSchemaComposerTests.TestTitleAndDescription;
var
  LJSONSchema: String;
begin
  Writeln('TestTitleAndDescription');
  FComposer.Obj
    .Title('Person')
    .Desc('Person schema')
    .Typ('object')
    .PropType('name', 'string')
    .EndObj;

  LJSONSchema := FComposer.ToJSON;
  Writeln('Schema: ' + LJSONSchema);
  Assert.IsNotEmpty(LJSONSchema);
  Assert.Contains(LJSONSchema, '"type":"object"');
  Assert.Contains(LJSONSchema, '"title":"Person"');
  Assert.Contains(LJSONSchema, '"description":"Person schema"');
  Assert.Contains(LJSONSchema, '"name":{"type":"string"}');
end;

procedure TJSONSmartSchemaComposerTests.TestStringValidations;
var
  LJSONSchema: String;
begin
  Writeln('TestStringValidations');
  FComposer.Typ('string')
    .MinLen(3)
    .MaxLen(10)
    .Pattern('^[A-Za-z]+$');

  LJSONSchema := FComposer.ToJSON;
  Writeln('Schema: ' + LJSONSchema);
  Assert.IsNotEmpty(LJSONSchema);
  Assert.Contains(LJSONSchema, '"type":"string"');
  Assert.Contains(LJSONSchema, '"minLength":3');
  Assert.Contains(LJSONSchema, '"maxLength":10');
  Assert.Contains(LJSONSchema, '"pattern":"^[A-Za-z]+$"');
end;

procedure TJSONSmartSchemaComposerTests.TestNumberValidations;
var
  LJSONSchema: String;
begin
  Writeln('TestNumberValidations');
  FComposer.Typ('number')
    .Min(0)
    .Max(100)
    .ExclMin(1)
    .ExclMax(99)
    .MultOf(5);

  LJSONSchema := FComposer.ToJSON;
  Writeln('Schema: ' + LJSONSchema);
  Assert.IsNotEmpty(LJSONSchema);
  Assert.Contains(LJSONSchema, '"type":"number"');
  Assert.Contains(LJSONSchema, '"minimum":0');
  Assert.Contains(LJSONSchema, '"maximum":100');
  Assert.Contains(LJSONSchema, '"exclusiveMinimum":1');
  Assert.Contains(LJSONSchema, '"exclusiveMaximum":99');
  Assert.Contains(LJSONSchema, '"multipleOf":5');
end;

procedure TJSONSmartSchemaComposerTests.TestArrayValidations;
var
  LJSONSchema: String;
begin
  Writeln('TestArrayValidations');
  FComposer.Obj
    .Typ('array')
    .Items(FComposer.SubSchema(procedure(I: TJSONSchemaComposer) begin I.Typ('string').MinLen(2); end))
    .MinItems(1)
    .MaxItems(5)
    .Unique(True)
    .EndObj;

  LJSONSchema := FComposer.ToJSON;
  Writeln('Schema: ' + LJSONSchema);
  Assert.IsNotEmpty(LJSONSchema);
  Assert.Contains(LJSONSchema, '"type":"array"');
  Assert.Contains(LJSONSchema, '"items":{"type":"string","minLength":2}');
  Assert.Contains(LJSONSchema, '"minItems":1');
  Assert.Contains(LJSONSchema, '"maxItems":5');
  Assert.Contains(LJSONSchema, '"uniqueItems":true');
end;

procedure TJSONSmartSchemaComposerTests.TestObjectValidations;
var
  LJSONSchema: String;
begin
  Writeln('TestObjectValidations');
  FComposer.Obj
    .Typ('object')
    .PropType('name', 'string')
    .MinProps(1)
    .MaxProps(3)
    .AddProps(True, FComposer.SubSchema(procedure(S: TJSONSchemaComposer) begin S.Typ('string').MaxLen(20); end))
    .EndObj;

  LJSONSchema := FComposer.ToJSON;
  Writeln('Schema: ' + LJSONSchema);
  Assert.IsNotEmpty(LJSONSchema);
  Assert.Contains(LJSONSchema, '"type":"object"');
  Assert.Contains(LJSONSchema, '"minProperties":1');
  Assert.Contains(LJSONSchema, '"maxProperties":3');
  Assert.Contains(LJSONSchema, '"additionalProperties":{"type":"string","maxLength":20}');
end;

procedure TJSONSmartSchemaComposerTests.TestConditionalIfThenElse;
var
  LJSONSchema: String;
begin
  Writeln('TestConditionalIfThenElse');
  FComposer.Obj
    .Typ('object')
    .PropType('type', 'string')
    .PropType('name', 'string')
    .PropType('id', 'integer')
    .IfThen(FComposer.SubSchema(procedure(I: TJSONSchemaComposer)
      begin
        I.Typ('object')
         .Prop('type', procedure(P: TJSONSchemaComposer)
           begin
             P.Typ('string');
             P.Cst('person');
           end);
      end))
    .Thn(FComposer.SubSchema(procedure(T: TJSONSchemaComposer)
      begin
        T.Typ('object').PropType('name', 'string', True);
      end))
    .Els(FComposer.SubSchema(procedure(E: TJSONSchemaComposer)
      begin
        E.Typ('object').PropType('id', 'integer', True);
      end))
    .EndObj;

  LJSONSchema := FComposer.ToJSON;
  Writeln('Schema: ' + LJSONSchema);
  Assert.IsNotEmpty(LJSONSchema);
  Assert.Contains(LJSONSchema, '"if":{"type":"object","properties":{"type":{"type":"string","const":"person"}}}');
  Assert.Contains(LJSONSchema, '"then":{"type":"object","properties":{"name":{"type":"string"}},"required":["name"]}');
  Assert.Contains(LJSONSchema, '"else":{"type":"object","properties":{"id":{"type":"integer"}},"required":["id"]}');
end;

procedure TJSONSmartSchemaComposerTests.TestCombinationsAllOf;
var
  LJSONSchema: String;
begin
  Writeln('TestCombinationsAllOf');
  FComposer.Obj
    .Typ('object')
    .AllOf([FComposer.SubSchema(procedure(S: TJSONSchemaComposer) begin S.Typ('string').MinLen(3); end),
            FComposer.SubSchema(procedure(S: TJSONSchemaComposer) begin S.Typ('string').MaxLen(10); end)])
    .EndObj;

  LJSONSchema := FComposer.ToJSON;
  Writeln('Schema: ' + LJSONSchema);
  Assert.IsNotEmpty(LJSONSchema);
  Assert.Contains(LJSONSchema, '"allOf":[{"type":"string","minLength":3},{"type":"string","maxLength":10}]');
end;

procedure TJSONSmartSchemaComposerTests.TestCombinationsAnyOf;
var
  LJSONSchema: String;
begin
  Writeln('TestCombinationsAnyOf');
  FComposer.Obj
    .Typ('object')
    .AnyOf([FComposer.SubSchema(procedure(S: TJSONSchemaComposer) begin S.Typ('string'); end),
            FComposer.SubSchema(procedure(S: TJSONSchemaComposer) begin S.Typ('number'); end)])
    .EndObj;

  LJSONSchema := FComposer.ToJSON;
  Writeln('Schema: ' + LJSONSchema);
  Assert.IsNotEmpty(LJSONSchema);
  Assert.Contains(LJSONSchema, '"anyOf":[{"type":"string"},{"type":"number"}]');
end;

procedure TJSONSmartSchemaComposerTests.TestCombinationsOneOf;
var
  LJSONSchema: String;
begin
  Writeln('TestCombinationsOneOf');
  FComposer.Obj
    .Typ('object')
    .OneOf([FComposer.SubSchema(procedure(S: TJSONSchemaComposer) begin S.Typ('string').MinLen(5); end),
            FComposer.SubSchema(procedure(S: TJSONSchemaComposer) begin S.Typ('string').MaxLen(3); end)])
    .EndObj;

  LJSONSchema := FComposer.ToJSON;
  Writeln('Schema: ' + LJSONSchema);
  Assert.IsNotEmpty(LJSONSchema);
  Assert.Contains(LJSONSchema, '"oneOf":[{"type":"string","minLength":5},{"type":"string","maxLength":3}]');
end;

procedure TJSONSmartSchemaComposerTests.TestCombinationsNot;
var
  LJSONSchema: String;
begin
  Writeln('TestCombinationsNot');
  FComposer.Obj
    .Typ('object')
    .Prop('value', procedure(P: TJSONSchemaComposer)
      begin
        P.Typ('string')
         .Neg(FComposer.SubSchema(procedure(N: TJSONSchemaComposer) begin N.Typ('string').Pattern('^admin'); end));
      end)
    .EndObj;

  LJSONSchema := FComposer.ToJSON;
  Writeln('Schema: ' + LJSONSchema);
  Assert.IsNotEmpty(LJSONSchema);
  Assert.Contains(LJSONSchema, '"type":"object"');
  Assert.Contains(LJSONSchema, '"value":{"type":"string","not":{"type":"string","pattern":"^admin"}}');
end;

procedure TJSONSmartSchemaComposerTests.TestDefinitionsAndRef;
var
  LJSONSchema: String;
begin
  Writeln('TestDefinitionsAndRef');
  FComposer.Obj
    .Def('address', procedure(D: TJSONSchemaComposer) begin D.Typ('object').PropType('street', 'string').PropType('city', 'string'); end)
    .Typ('object')
    .Prop('homeAddress', procedure(P: TJSONSchemaComposer) begin P.Add('$ref', '#/$defs/address'); end)
    .EndObj;

  LJSONSchema := FComposer.ToJSON;
  Writeln('Schema: ' + LJSONSchema);
  Assert.IsNotEmpty(LJSONSchema);
  Assert.Contains(LJSONSchema, '"$defs":{"address":{"type":"object"');
  Assert.Contains(LJSONSchema, '"homeAddress":{"$ref":"#/$defs/address"}');
end;

procedure TJSONSmartSchemaComposerTests.TestValidateGeneratedSchemaAgainstMetaSchema;
var
  LGeneratedSchema: IJSONElement;
  LResult: Boolean;
  LErrors: TArray<TValidationError>;
  LError: TValidationError;
  LReader: TJSONReader;
  LMetaSchema: IJSONElement;
begin
  Writeln('TestValidateGeneratedSchemaAgainstMetaSchema');

  // Carrega o meta-schema Draft-07
  LReader := TJSONReader.Create;
  try
    LMetaSchema := LReader.Read(
      '{'+ // O JSON Draft-07 do log
      '    "$schema": "http://json-schema.org/draft-07/schema#",'+
      '    "$id": "http://json-schema.org/draft-07/schema#",'+
      '    "title": "Core schema meta-schema",'+
      '    "definitions": {'+
      '        "schemaArray": {"type": "array", "minItems": 1, "items": {"$ref": "#"}},'+
      '        "nonNegativeInteger": {"type": "integer", "minimum": 0},'+
      '        "nonNegativeIntegerDefault0": {"allOf": [{"$ref": "#/definitions/nonNegativeInteger"}, {"default": 0}]},'+
      '        "simpleTypes": {"enum": ["array", "boolean", "integer", "null", "number", "object", "string"]},'+
      '        "stringArray": {"type": "array", "items": {"type": "string"}, "uniqueItems": true, "default": []}'+
      '    },'+
      '    "type": ["object", "boolean"],'+
      '    "properties": {'+
      '        "$id": {"type": "string", "format": "uri-reference"},'+
      '        "$schema": {"type": "string", "format": "uri"},'+
      '        "$ref": {"type": "string", "format": "uri-reference"},'+
      '        "$comment": {"type": "string"},'+
      '        "title": {"type": "string"},'+
      '        "description": {"type": "string"},'+
      '        "default": true,'+
      '        "readOnly": {"type": "boolean", "default": false},'+
      '        "examples": {"type": "array", "items": true},'+
      '        "multipleOf": {"type": "number", "exclusiveMinimum": 0},'+
      '        "maximum": {"type": "number"},'+
      '        "exclusiveMaximum": {"type": "number"},'+
      '        "minimum": {"type": "number"},'+
      '        "exclusiveMinimum": {"type": "number"},'+
      '        "maxLength": {"$ref": "#/definitions/nonNegativeInteger"},'+
      '        "minLength": {"$ref": "#/definitions/nonNegativeIntegerDefault0"},'+
      '        "pattern": {"type": "string", "format": "regex"},'+
      '        "additionalItems": {"$ref": "#"},'+
      '        "items": {"anyOf": [{"$ref": "#"}, {"$ref": "#/definitions/schemaArray"}], "default": true},'+
      '        "maxItems": {"$ref": "#/definitions/nonNegativeInteger"},'+
      '        "minItems": {"$ref": "#/definitions/nonNegativeIntegerDefault0"},'+
      '        "uniqueItems": {"type": "boolean", "default": false},'+
      '        "contains": {"$ref": "#"},'+
      '        "maxProperties": {"$ref": "#/definitions/nonNegativeInteger"},'+
      '        "minProperties": {"$ref": "#/definitions/nonNegativeIntegerDefault0"},'+
      '        "required": {"$ref": "#/definitions/stringArray"},'+
      '        "additionalProperties": {"$ref": "#"},'+
      '        "definitions": {"type": "object", "additionalProperties": {"$ref": "#"}, "default": {}},'+
      '        "properties": {"type": "object", "additionalProperties": {"$ref": "#"}, "default": {}},'+
      '        "patternProperties": {"type": "object", "additionalProperties": {"$ref": "#"}, "propertyNames": {"format": "regex"}, "default": {}},'+
      '        "dependencies": {"type": "object", "additionalProperties": {"anyOf": [{"$ref": "#"}, {"$ref": "#/definitions/stringArray"}]}},'+
      '        "propertyNames": {"$ref": "#"},'+
      '        "const": true,'+
      '        "enum": {"type": "array", "items": true, "minItems": 1, "uniqueItems": true},'+
      '        "type": {"anyOf": [{"$ref": "#/definitions/simpleTypes"}, {"type": "array", "items": {"$ref": "#/definitions/simpleTypes"}, "minItems": 1, "uniqueItems": true}]},'+
      '        "format": {"type": "string"},'+
      '        "contentMediaType": {"type": "string"},'+
      '        "contentEncoding": {"type": "string"},'+
      '        "if": {"$ref": "#"},'+
      '        "then": {"$ref": "#"},'+
      '        "else": {"$ref": "#"},'+
      '        "allOf": {"$ref": "#/definitions/schemaArray"},'+
      '        "anyOf": {"$ref": "#/definitions/schemaArray"},'+
      '        "oneOf": {"$ref": "#/definitions/schemaArray"},'+
      '        "not": {"$ref": "#"}'+
      '    },'+
      '    "default": true'+
      '}'
    );
  finally
    LReader.Free;
  end;

  // Configura o FValidator com o meta-schema
  if Assigned(FValidator) then
    FValidator.Free; // Libera o FValidator criado no SetUp, se existir
  FValidator := TJSONSchemaValidator.Create(jsvDraft7, LMetaSchema);
  FValidator.ParseSchema(LMetaSchema);

  // Gera o schema com o composer
  FComposer.Obj
    .Typ('object')
    .PropType('type', 'string')
    .PropType('name', 'string')
    .PropType('id', 'integer')
    .Prop('status', procedure(P: TJSONSchemaComposer) begin P.Typ('string').Enum(['active', 'inactive']); end)
    .Prop('score', procedure(P: TJSONSchemaComposer) begin P.Typ('number').Min(0).Max(100).MultOf(5); end)
    .Prop('tags', procedure(P: TJSONSchemaComposer) begin P.Typ('array').Items(FComposer.SubSchema(procedure(I: TJSONSchemaComposer) begin I.Typ('string').MinLen(3); end)).MinItems(1).MaxItems(5).Unique(True); end)
    .MinProps(1)
    .MaxProps(20)
    .AddProps(True, FComposer.SubSchema(procedure(S: TJSONSchemaComposer) begin S.Typ('string'); end))
    .EndObj;

  LGeneratedSchema := FComposer.ToElement;
  Writeln('Schema: ' + LGeneratedSchema.AsJSON);

  // Valida o schema gerado contra o meta-schema
  LResult := FValidator.Validate(LGeneratedSchema, '');
  if not LResult then
  begin
    LErrors := FValidator.GetErrors;
    Writeln('Validation errors (' + Length(LErrors).ToString + '):');
    for LError in LErrors do
      Writeln(' - Path: ' + LError.Path +
              ', Message: ' + LError.Message +
              ', Keyword: ' + LError.Keyword +
              ', Found: ' + LError.FoundValue +
              ', Expected: ' + LError.ExpectedValue);
  end;
  Assert.IsTrue(LResult, 'Generated schema should be valid against meta schema');
  Assert.AreEqual(0, Length(FValidator.GetErrors), 'No validation errors expected');
end;

procedure TJSONSmartSchemaComposerTests.TestValidateJSONAgainstGeneratedSchema;
var
  LJSONSchema, LValidJSON, LInvalidJSON: String;
  LValidator: TJSONSchemaValidator;
  LResult: Boolean;
begin
  Writeln('TestValidateJSONAgainstGeneratedSchema');
  FComposer.Obj
    .Def('address', procedure(D: TJSONSchemaComposer) begin D.Typ('object').PropType('street', 'string', True).PropType('city', 'string', True); end)
    .Typ('object')
    .Prop('homeAddress', procedure(P: TJSONSchemaComposer) begin P.Add('$ref', '#/$defs/address'); end)
    .PropType('type', 'string', True)
    .PropType('name', 'string')
    .PropType('status', 'string')
    .Prop('score', procedure(P: TJSONSchemaComposer) begin P.Typ('number').Min(0).Max(100); end)
    .PropType('tags', 'array')
    .AddProps(False)
    .EndObj;

  LJSONSchema := FComposer.ToJSON;
  Writeln('Schema: ' + LJSONSchema);

  LValidJSON := '{"homeAddress": {"street": "Main St", "city": "New York"}, "type": "person", "name": "João", "status": "active", "score": 50, "tags": ["abc", "def"]}';
  Writeln('Valid JSON: ' + LValidJSON);
  LValidator := TJSONSchemaValidator.Create(jsvDraft7);
  try
    LResult := LValidator.Validate(LValidJSON, LJSONSchema);
    if not LResult then
      Writeln('Validation errors (valid): ' + TArray.ToString<TValidationError>(LValidator.GetErrors));
    Assert.IsTrue(LResult, 'Valid JSON should pass validation');
    Assert.AreEqual(0, Length(LValidator.GetErrors), 'No validation errors expected for valid JSON');
  finally
    LValidator.Free;
  end;

  LInvalidJSON := '{"homeAddress": {"street": 123}, "type": "person", "status": "invalid", "score": 150, "tags": ["ab", "ab"], "extra": "field"}';
  Writeln('Invalid JSON: ' + LInvalidJSON);
  LValidator := TJSONSchemaValidator.Create(jsvDraft7);
  try
    LResult := LValidator.Validate(LInvalidJSON, LJSONSchema);
    if not LResult then
      Writeln('Validation errors (invalid): ' + TArray.ToString<TValidationError>(LValidator.GetErrors));
    Assert.IsFalse(LResult, 'Invalid JSON should fail validation');
    Assert.IsTrue(Length(LValidator.GetErrors) > 0, 'Validation errors expected for invalid JSON');
  finally
    LValidator.Free;
  end;
end;

procedure TJSONSmartSchemaComposerTests.TestValidateJSONAgainstGeneratedSchemaString;
var
  LSchema, LValidJSON, LInvalidJSON: String;
  LValidator: TJSONSchemaValidator;
  LResult: Boolean;
begin
  Writeln('TestValidateJSONAgainstGeneratedSchemaString');
  LSchema := '{"type": "object", "properties": {"homeAddress": {"type": "object", "properties": {"street": {"type": "string"}, "city": {"type": "string"}}, "required": ["street", "city"]}, "type": {"type": "string"}, "name": {"type": "string"}, "status": {"type": "string"}, "score": {"type": "number", "minimum": 0, "maximum": 100}, "tags": {"type": "array"}}, "required": ["homeAddress", "type"], "additionalProperties": false}';
  Writeln('Schema: ' + LSchema);

  LValidJSON := '{"homeAddress": {"street": "Main St", "city": "New York"}, "type": "person", "name": "João", "status": "active", "score": 50, "tags": ["abc", "def"]}';
  Writeln('Valid JSON: ' + LValidJSON);
  LValidator := TJSONSchemaValidator.Create(jsvDraft7);
  try
    LResult := LValidator.Validate(LValidJSON, LSchema);
    if not LResult then
      Writeln('Validation errors (valid): ' + TArray.ToString<TValidationError>(LValidator.GetErrors));
    Assert.IsTrue(LResult, 'Valid JSON should pass validation');
    Assert.AreEqual(0, Length(LValidator.GetErrors), 'No validation errors expected for valid JSON');
  finally
    LValidator.Free;
  end;

  LInvalidJSON := '{"homeAddress": {"street": 123}, "type": "person", "status": "invalid", "score": 150, "tags": ["ab", "ab"], "extra": "field"}';
  Writeln('Invalid JSON: ' + LInvalidJSON);
  LValidator := TJSONSchemaValidator.Create(jsvDraft7);
  try
    LResult := LValidator.Validate(LInvalidJSON, LSchema);
    if not LResult then
      Writeln('Validation errors (invalid): ' + TArray.ToString<TValidationError>(LValidator.GetErrors));
    Assert.IsFalse(LResult, 'Invalid JSON should fail validation');
    Assert.IsTrue(Length(LValidator.GetErrors) > 0, 'Validation errors expected for invalid JSON');
  finally
    LValidator.Free;
  end;
end;

procedure TJSONSmartSchemaComposerTests.TestValidateTypeString;
var
  LJSONSchema, LJSON: String;
  LValidator: TJSONSchemaValidator;
  LResult: Boolean;
begin
  Writeln('TestValidateTypeString');
  FComposer.Obj
    .Typ('object')
    .PropType('value', 'string')
    .EndObj;

  LJSONSchema := FComposer.ToJSON;
  Writeln('Schema: ' + LJSONSchema);

  LJSON := '{"value": "hello"}';
  Writeln('JSON: ' + LJSON);
  LValidator := TJSONSchemaValidator.Create(jsvDraft7);
  try
    LResult := LValidator.Validate(LJSON, LJSONSchema);
    if not LResult then
      Writeln('Validation errors: ' + TArray.ToString<TValidationError>(LValidator.GetErrors));
    Assert.IsTrue(LResult, 'String should validate');
    Assert.AreEqual(0, Length(LValidator.GetErrors), 'No validation errors expected');
  finally
    LValidator.Free;
  end;
end;

procedure TJSONSmartSchemaComposerTests.TestValidateRequiredString;
var
  LJSONSchema, LValidJSON, LInvalidJSON: String;
  LValidator: TJSONSchemaValidator;
  LResult: Boolean;
begin
  Writeln('TestValidateRequiredString');
  FComposer.Obj
    .Typ('object')
    .PropType('value', 'string', True)
    .EndObj;

  LJSONSchema := FComposer.ToJSON;
  Writeln('Schema: ' + LJSONSchema);

  LValidJSON := '{"value": "hello"}';
  Writeln('Valid JSON: ' + LValidJSON);
  LValidator := TJSONSchemaValidator.Create(jsvDraft7);
  try
    LResult := LValidator.Validate(LValidJSON, LJSONSchema);
    if not LResult then
      Writeln('Validation errors (valid): ' + TArray.ToString<TValidationError>(LValidator.GetErrors));
    Assert.IsTrue(LResult, 'String should validate with required');
    Assert.AreEqual(0, Length(LValidator.GetErrors), 'No validation errors expected for valid JSON');
  finally
    LValidator.Free;
  end;

  LInvalidJSON := '{"mainContact": {}}';
  Writeln('Invalid JSON: ' + LInvalidJSON);
  LValidator := TJSONSchemaValidator.Create(jsvDraft7);
  try
    LResult := LValidator.Validate(LInvalidJSON, LJSONSchema);
    if not LResult then
      Writeln('Validation errors (invalid): ' + TArray.ToString<TValidationError>(LValidator.GetErrors));
    Assert.IsFalse(LResult, 'Missing required value should fail');
    Assert.IsTrue(Length(LValidator.GetErrors) > 0, 'Validation errors expected for invalid JSON');
  finally
    LValidator.Free;
  end;
end;

procedure TJSONSmartSchemaComposerTests.TestValidateMinLengthString;
var
  LJSONSchema, LValidJSON, LInvalidJSON: String;
  LValidator: TJSONSchemaValidator;
  LResult: Boolean;
begin
  Writeln('TestValidateMinLengthString');
  FComposer.Obj
    .Typ('object')
    .Prop('value', procedure(P: TJSONSchemaComposer) begin P.Typ('string').MinLen(3); end)
    .EndObj;

  LJSONSchema := FComposer.ToJSON;
  Writeln('Schema: ' + LJSONSchema);

  LValidJSON := '{"value": "hello"}';
  Writeln('Valid JSON: ' + LValidJSON);
  LValidator := TJSONSchemaValidator.Create(jsvDraft7);
  try
    LResult := LValidator.Validate(LValidJSON, LJSONSchema);
    if not LResult then
      Writeln('Validation errors (valid): ' + TArray.ToString<TValidationError>(LValidator.GetErrors));
    Assert.IsTrue(LResult, 'String should validate with minLength');
    Assert.AreEqual(0, Length(LValidator.GetErrors), 'No validation errors expected for valid JSON');
  finally
    LValidator.Free;
  end;

  LInvalidJSON := '{"value": "hi"}';
  Writeln('Invalid JSON: ' + LInvalidJSON);
  LValidator := TJSONSchemaValidator.Create(jsvDraft7);
  try
    LResult := LValidator.Validate(LInvalidJSON, LJSONSchema);
    if not LResult then
      Writeln('Validation errors (invalid): ' + TArray.ToString<TValidationError>(LValidator.GetErrors));
    Assert.IsFalse(LResult, 'Short string should fail minLength');
    Assert.IsTrue(Length(LValidator.GetErrors) > 0, 'Validation errors expected for invalid JSON');
  finally
    LValidator.Free;
  end;
end;

procedure TJSONSmartSchemaComposerTests.TestValidateMaxLengthString;
var
  LJSONSchema, LValidJSON, LInvalidJSON: String;
  LValidator: TJSONSchemaValidator;
  LResult: Boolean;
begin
  Writeln('TestValidateMaxLengthString');
  FComposer.Obj
    .Typ('object')
    .Prop('value', procedure(P: TJSONSchemaComposer) begin P.Typ('string').MaxLen(5); end)
    .EndObj;

  LJSONSchema := FComposer.ToJSON;
  Writeln('Schema: ' + LJSONSchema);

  LValidJSON := '{"value": "hello"}';
  Writeln('Valid JSON: ' + LValidJSON);
  LValidator := TJSONSchemaValidator.Create(jsvDraft7);
  try
    LResult := LValidator.Validate(LValidJSON, LJSONSchema);
    if not LResult then
      Writeln('Validation errors (valid): ' + TArray.ToString<TValidationError>(LValidator.GetErrors));
    Assert.IsTrue(LResult, 'String within maxLength should validate');
    Assert.AreEqual(0, Length(LValidator.GetErrors), 'No validation errors expected for valid JSON');
  finally
    LValidator.Free;
  end;

  LInvalidJSON := '{"value": "hello!"}';
  Writeln('Invalid JSON: ' + LInvalidJSON);
  LValidator := TJSONSchemaValidator.Create(jsvDraft7);
  try
    LResult := LValidator.Validate(LInvalidJSON, LJSONSchema);
    if not LResult then
      Writeln('Validation errors (invalid): ' + TArray.ToString<TValidationError>(LValidator.GetErrors));
    Assert.IsFalse(LResult, 'String exceeding maxLength should fail');
    Assert.IsTrue(Length(LValidator.GetErrors) > 0, 'Validation errors expected for invalid JSON');
  finally
    LValidator.Free;
  end;
end;

procedure TJSONSmartSchemaComposerTests.TestValidatePatternString;
var
  LJSONSchema, LValidJSON, LInvalidJSON: String;
  LValidator: TJSONSchemaValidator;
  LResult: Boolean;
begin
  Writeln('TestValidatePatternString');
  FComposer.Obj
    .Typ('object')
    .Prop('value', procedure(P: TJSONSchemaComposer) begin P.Typ('string').Pattern('^[A-Za-z]+$'); end)
    .EndObj;

  LJSONSchema := FComposer.ToJSON;
  Writeln('Schema: ' + LJSONSchema);

  LValidJSON := '{"value": "hello"}';
  Writeln('Valid JSON: ' + LValidJSON);
  LValidator := TJSONSchemaValidator.Create(jsvDraft7);
  try
    LResult := LValidator.Validate(LValidJSON, LJSONSchema);
    if not LResult then
      Writeln('Validation errors (valid): ' + TArray.ToString<TValidationError>(LValidator.GetErrors));
    Assert.IsTrue(LResult, 'String matching pattern should validate');
    Assert.AreEqual(0, Length(LValidator.GetErrors), 'No validation errors expected for valid JSON');
  finally
    LValidator.Free;
  end;

  LInvalidJSON := '{"value": "hello123"}';
  Writeln('Invalid JSON: ' + LInvalidJSON);
  LValidator := TJSONSchemaValidator.Create(jsvDraft7);
  try
    LResult := LValidator.Validate(LInvalidJSON, LJSONSchema);
    if not LResult then
      Writeln('Validation errors (invalid): ' + TArray.ToString<TValidationError>(LValidator.GetErrors));
    Assert.IsFalse(LResult, 'String not matching pattern should fail');
    Assert.IsTrue(Length(LValidator.GetErrors) > 0, 'Validation errors expected for invalid JSON');
  finally
    LValidator.Free;
  end;
end;

procedure TJSONSmartSchemaComposerTests.TestValidateEnumString;
var
  LJSONSchema, LValidJSON, LInvalidJSON: String;
  LValidator: TJSONSchemaValidator;
  LResult: Boolean;
begin
  Writeln('TestValidateEnumString');
  FComposer.Obj
    .Typ('object')
    .Prop('value', procedure(P: TJSONSchemaComposer) begin P.Typ('string').Enum(['red', 'green', 'blue']); end)
    .EndObj;

  LJSONSchema := FComposer.ToJSON;
  Writeln('Schema: ' + LJSONSchema);

  LValidJSON := '{"value": "red"}';
  Writeln('Valid JSON: ' + LValidJSON);
  LValidator := TJSONSchemaValidator.Create(jsvDraft7);
  try
    LResult := LValidator.Validate(LValidJSON, LJSONSchema);
    if not LResult then
      Writeln('Validation errors (valid): ' + TArray.ToString<TValidationError>(LValidator.GetErrors));
    Assert.IsTrue(LResult, 'String in enum should validate');
    Assert.AreEqual(0, Length(LValidator.GetErrors), 'No validation errors expected for valid JSON');
  finally
    LValidator.Free;
  end;

  LInvalidJSON := '{"value": "yellow"}';
  Writeln('Invalid JSON: ' + LInvalidJSON);
  LValidator := TJSONSchemaValidator.Create(jsvDraft7);
  try
    LResult := LValidator.Validate(LInvalidJSON, LJSONSchema);
    if not LResult then
      Writeln('Validation errors (invalid): ' + TArray.ToString<TValidationError>(LValidator.GetErrors));
    Assert.IsFalse(LResult, 'String not in enum should fail');
    Assert.IsTrue(Length(LValidator.GetErrors) > 0, 'Validation errors expected for invalid JSON');
  finally
    LValidator.Free;
  end;
end;

procedure TJSONSmartSchemaComposerTests.TestValidateFormatEmail;
var
  LJSONSchema, LValidJSON, LInvalidJSON: String;
  LValidator: TJSONSchemaValidator;
  LResult: Boolean;
begin
  Writeln('TestValidateFormatEmail');
  FComposer.Obj
    .Typ('object')
    .Prop('value', procedure(P: TJSONSchemaComposer) begin P.Typ('string').Format('email'); end)
    .EndObj;

  LJSONSchema := FComposer.ToJSON;
  Writeln('Schema: ' + LJSONSchema);

  LValidJSON := '{"value": "user@example.com"}';
  Writeln('Valid JSON: ' + LValidJSON);
  LValidator := TJSONSchemaValidator.Create(jsvDraft7);
  try
    LResult := LValidator.Validate(LValidJSON, LJSONSchema);
    if not LResult then
      Writeln('Validation errors (valid): ' + TArray.ToString<TValidationError>(LValidator.GetErrors));
    Assert.IsTrue(LResult, 'Valid email should validate');
    Assert.AreEqual(0, Length(LValidator.GetErrors), 'No validation errors expected for valid JSON');
  finally
    LValidator.Free;
  end;

  LInvalidJSON := '{"value": "invalid-email"}';
  Writeln('Invalid JSON: ' + LInvalidJSON);
  LValidator := TJSONSchemaValidator.Create(jsvDraft7);
  try
    LResult := LValidator.Validate(LInvalidJSON, LJSONSchema);
    if not LResult then
      Writeln('Validation errors (invalid): ' + TArray.ToString<TValidationError>(LValidator.GetErrors));
    Assert.IsFalse(LResult, 'Invalid email should fail');
    Assert.IsTrue(Length(LValidator.GetErrors) > 0, 'Validation errors expected for invalid JSON');
  finally
    LValidator.Free;
  end;
end;

procedure TJSONSmartSchemaComposerTests.TestValidateMinimumNumber;
var
  LJSONSchema, LValidJSON, LInvalidJSON: String;
  LValidator: TJSONSchemaValidator;
  LResult: Boolean;
begin
  Writeln('TestValidateMinimumNumber');
  FComposer.Obj
    .Typ('object')
    .Prop('value', procedure(P: TJSONSchemaComposer) begin P.Typ('number').Min(10); end)
    .EndObj;

  LJSONSchema := FComposer.ToJSON;
  Writeln('Schema: ' + LJSONSchema);

  LValidJSON := '{"value": 15}';
  Writeln('Valid JSON: ' + LValidJSON);
  LValidator := TJSONSchemaValidator.Create(jsvDraft7);
  try
    LResult := LValidator.Validate(LValidJSON, LJSONSchema);
    if not LResult then
      Writeln('Validation errors (valid): ' + TArray.ToString<TValidationError>(LValidator.GetErrors));
    Assert.IsTrue(LResult, 'Number above minimum should validate');
    Assert.AreEqual(0, Length(LValidator.GetErrors), 'No validation errors expected for valid JSON');
  finally
    LValidator.Free;
  end;

  LInvalidJSON := '{"value": 5}';
  Writeln('Invalid JSON: ' + LInvalidJSON);
  LValidator := TJSONSchemaValidator.Create(jsvDraft7);
  try
    LResult := LValidator.Validate(LInvalidJSON, LJSONSchema);
    if not LResult then
      Writeln('Validation errors (invalid): ' + TArray.ToString<TValidationError>(LValidator.GetErrors));
    Assert.IsFalse(LResult, 'Number below minimum should fail');
    Assert.IsTrue(Length(LValidator.GetErrors) > 0, 'Validation errors expected for invalid JSON');
  finally
    LValidator.Free;
  end;
end;

procedure TJSONSmartSchemaComposerTests.TestValidateMaximumNumber;
var
  LJSONSchema, LValidJSON, LInvalidJSON: String;
  LValidator: TJSONSchemaValidator;
  LResult: Boolean;
begin
  Writeln('TestValidateMaximumNumber');
  FComposer.Obj
    .Typ('object')
    .Prop('value', procedure(P: TJSONSchemaComposer) begin P.Typ('number').Max(20); end)
    .EndObj;

  LJSONSchema := FComposer.ToJSON;
  Writeln('Schema: ' + LJSONSchema);

  LValidJSON := '{"value": 15}';
  Writeln('Valid JSON: ' + LValidJSON);
  LValidator := TJSONSchemaValidator.Create(jsvDraft7);
  try
    LResult := LValidator.Validate(LValidJSON, LJSONSchema);
    if not LResult then
      Writeln('Validation errors (valid): ' + TArray.ToString<TValidationError>(LValidator.GetErrors));
    Assert.IsTrue(LResult, 'Number below maximum should validate');
    Assert.AreEqual(0, Length(LValidator.GetErrors), 'No validation errors expected for valid JSON');
  finally
    LValidator.Free;
  end;

  LInvalidJSON := '{"value": 25}';
  Writeln('Invalid JSON: ' + LInvalidJSON);
  LValidator := TJSONSchemaValidator.Create(jsvDraft7);
  try
    LResult := LValidator.Validate(LInvalidJSON, LJSONSchema);
    if not LResult then
      Writeln('Validation errors (invalid): ' + TArray.ToString<TValidationError>(LValidator.GetErrors));
    Assert.IsFalse(LResult, 'Number above maximum should fail');
    Assert.IsTrue(Length(LValidator.GetErrors) > 0, 'Validation errors expected for invalid JSON');
  finally
    LValidator.Free;
  end;
end;

procedure TJSONSmartSchemaComposerTests.TestValidateMultipleOfNumber;
var
  LJSONSchema, LValidJSON, LInvalidJSON: String;
  LValidator: TJSONSchemaValidator;
  LResult: Boolean;
begin
  Writeln('TestValidateMultipleOfNumber');
  FComposer.Obj
    .Typ('object')
    .Prop('value', procedure(P: TJSONSchemaComposer) begin P.Typ('number').MultOf(5); end)
    .EndObj;

  LJSONSchema := FComposer.ToJSON;
  Writeln('Schema: ' + LJSONSchema);

  LValidJSON := '{"value": 15}';
  Writeln('Valid JSON: ' + LValidJSON);
  LValidator := TJSONSchemaValidator.Create(jsvDraft7);
  try
    LResult := LValidator.Validate(LValidJSON, LJSONSchema);
    if not LResult then
      Writeln('Validation errors (valid): ' + TArray.ToString<TValidationError>(LValidator.GetErrors));
    Assert.IsTrue(LResult, 'Number multiple of 5 should validate');
    Assert.AreEqual(0, Length(LValidator.GetErrors), 'No validation errors expected for valid JSON');
  finally
    LValidator.Free;
  end;

  LInvalidJSON := '{"value": 17}';
  Writeln('Invalid JSON: ' + LInvalidJSON);
  LValidator := TJSONSchemaValidator.Create(jsvDraft7);
  try
    LResult := LValidator.Validate(LInvalidJSON, LJSONSchema);
    if not LResult then
      Writeln('Validation errors (invalid): ' + TArray.ToString<TValidationError>(LValidator.GetErrors));
    Assert.IsFalse(LResult, 'Number not multiple of 5 should fail');
    Assert.IsTrue(Length(LValidator.GetErrors) > 0, 'Validation errors expected for invalid JSON');
  finally
    LValidator.Free;
  end;
end;

procedure TJSONSmartSchemaComposerTests.TestValidateExclusiveMaximumNumber;
var
  LJSONSchema, LValidJSON, LInvalidJSON: String;
  LValidator: TJSONSchemaValidator;
  LResult: Boolean;
begin
  Writeln('TestValidateExclusiveMaximumNumber');
  FComposer.Obj
    .Typ('object')
    .Prop('value', procedure(P: TJSONSchemaComposer) begin P.Typ('number').ExclMax(20); end)
    .EndObj;

  LJSONSchema := FComposer.ToJSON;
  Writeln('Schema: ' + LJSONSchema);

  LValidJSON := '{"value": 19}';
  Writeln('Valid JSON: ' + LValidJSON);
  LValidator := TJSONSchemaValidator.Create(jsvDraft7);
  try
    LResult := LValidator.Validate(LValidJSON, LJSONSchema);
    if not LResult then
      Writeln('Validation errors (valid): ' + TArray.ToString<TValidationError>(LValidator.GetErrors));
    Assert.IsTrue(LResult, 'Number below exclusive maximum should validate');
    Assert.AreEqual(0, Length(LValidator.GetErrors), 'No validation errors expected for valid JSON');
  finally
    LValidator.Free;
  end;

  LInvalidJSON := '{"value": 20}';
  Writeln('Invalid JSON: ' + LInvalidJSON);
  LValidator := TJSONSchemaValidator.Create(jsvDraft7);
  try
    LResult := LValidator.Validate(LInvalidJSON, LJSONSchema);
    if not LResult then
      Writeln('Validation errors (invalid): ' + TArray.ToString<TValidationError>(LValidator.GetErrors));
    Assert.IsFalse(LResult, 'Number equal to exclusive maximum should fail');
    Assert.IsTrue(Length(LValidator.GetErrors) > 0, 'Validation errors expected for invalid JSON');
  finally
    LValidator.Free;
  end;
end;

procedure TJSONSmartSchemaComposerTests.TestValidateExclusiveMinimumNumber;
var
  LJSONSchema, LValidJSON, LInvalidJSON: String;
  LValidator: TJSONSchemaValidator;
  LResult: Boolean;
begin
  Writeln('TestValidateExclusiveMinimumNumber');
  FComposer.Obj
    .Typ('object')
    .Prop('value', procedure(P: TJSONSchemaComposer) begin P.Typ('number').ExclMin(10); end)
    .EndObj;

  LJSONSchema := FComposer.ToJSON;
  Writeln('Schema: ' + LJSONSchema);

  LValidJSON := '{"value": 11}';
  Writeln('Valid JSON: ' + LValidJSON);
  LValidator := TJSONSchemaValidator.Create(jsvDraft7);
  try
    LResult := LValidator.Validate(LValidJSON, LJSONSchema);
    if not LResult then
      Writeln('Validation errors (valid): ' + TArray.ToString<TValidationError>(LValidator.GetErrors));
    Assert.IsTrue(LResult, 'Number above exclusive minimum should validate');
    Assert.AreEqual(0, Length(LValidator.GetErrors), 'No validation errors expected for valid JSON');
  finally
    LValidator.Free;
  end;

  LInvalidJSON := '{"value": 10}';
  Writeln('Invalid JSON: ' + LInvalidJSON);
  LValidator := TJSONSchemaValidator.Create(jsvDraft7);
  try
    LResult := LValidator.Validate(LInvalidJSON, LJSONSchema);
    if not LResult then
      Writeln('Validation errors (invalid): ' + TArray.ToString<TValidationError>(LValidator.GetErrors));
    Assert.IsFalse(LResult, 'Number equal to exclusive minimum should fail');
    Assert.IsTrue(Length(LValidator.GetErrors) > 0, 'Validation errors expected for invalid JSON');
  finally
    LValidator.Free;
  end;
end;

procedure TJSONSmartSchemaComposerTests.TestValidateMinItems;
var
  LJSONSchema, LValidJSON, LInvalidJSON: String;
  LValidator: TJSONSchemaValidator;
  LResult: Boolean;
begin
  Writeln('TestValidateMinItems');
  FComposer.Obj
    .Typ('object')
    .Prop('value', procedure(P: TJSONSchemaComposer) begin P.Typ('array').MinItems(2); end)
    .EndObj;

  LJSONSchema := FComposer.ToJSON;
  Writeln('Schema: ' + LJSONSchema);

  LValidJSON := '{"value": [1, 2]}';
  Writeln('Valid JSON: ' + LValidJSON);
  LValidator := TJSONSchemaValidator.Create(jsvDraft7);
  try
    LResult := LValidator.Validate(LValidJSON, LJSONSchema);
    if not LResult then
      Writeln('Validation errors (valid): ' + TArray.ToString<TValidationError>(LValidator.GetErrors));
    Assert.IsTrue(LResult, 'Array with at least minItems should validate');
    Assert.AreEqual(0, Length(LValidator.GetErrors), 'No validation errors expected for valid JSON');
  finally
    LValidator.Free;
  end;

  LInvalidJSON := '{"value": [1]}';
  Writeln('Invalid JSON: ' + LInvalidJSON);
  LValidator := TJSONSchemaValidator.Create(jsvDraft7);
  try
    LResult := LValidator.Validate(LInvalidJSON, LJSONSchema);
    if not LResult then
      Writeln('Validation errors (invalid): ' + TArray.ToString<TValidationError>(LValidator.GetErrors));
    Assert.IsFalse(LResult, 'Array with fewer than minItems should fail');
    Assert.IsTrue(Length(LValidator.GetErrors) > 0, 'Validation errors expected for invalid JSON');
  finally
    LValidator.Free;
  end;
end;

procedure TJSONSmartSchemaComposerTests.TestValidateMaxItems;
var
  LJSONSchema, LValidJSON, LInvalidJSON: String;
  LValidator: TJSONSchemaValidator;
  LResult: Boolean;
begin
  Writeln('TestValidateMaxItems');
  FComposer.Obj
    .Typ('object')
    .Prop('value', procedure(P: TJSONSchemaComposer) begin P.Typ('array').MaxItems(2); end)
    .EndObj;

  LJSONSchema := FComposer.ToJSON;
  Writeln('Schema: ' + LJSONSchema);

  LValidJSON := '{"value": [1, 2]}';
  Writeln('Valid JSON: ' + LValidJSON);
  LValidator := TJSONSchemaValidator.Create(jsvDraft7);
  try
    LResult := LValidator.Validate(LValidJSON, LJSONSchema);
    if not LResult then
      Writeln('Validation errors (valid): ' + TArray.ToString<TValidationError>(LValidator.GetErrors));
    Assert.IsTrue(LResult, 'Array with at most maxItems should validate');
    Assert.AreEqual(0, Length(LValidator.GetErrors), 'No validation errors expected for valid JSON');
  finally
    LValidator.Free;
  end;

  LInvalidJSON := '{"value": [1, 2, 3]}';
  Writeln('Invalid JSON: ' + LInvalidJSON);
  LValidator := TJSONSchemaValidator.Create(jsvDraft7);
  try
    LResult := LValidator.Validate(LInvalidJSON, LJSONSchema);
    if not LResult then
      Writeln('Validation errors (invalid): ' + TArray.ToString<TValidationError>(LValidator.GetErrors));
    Assert.IsFalse(LResult, 'Array with more than maxItems should fail');
    Assert.IsTrue(Length(LValidator.GetErrors) > 0, 'Validation errors expected for invalid JSON');
  finally
    LValidator.Free;
  end;
end;

procedure TJSONSmartSchemaComposerTests.TestValidateJSONAgainstGeneratedSchemaIsolated;
var
  LJSONSchema, LValidJSON, LInvalidJSON: String;
  LValidator: TJSONSchemaValidator;
  LResult: Boolean;
begin
  Writeln('TestValidateJSONAgainstGeneratedSchemaIsolated');
  FComposer.Obj
    .Typ('object')
    .PropType('name', 'string', True)
    .PropType('age', 'integer')
    .EndObj;

  LJSONSchema := FComposer.ToJSON;
  Writeln('Schema: ' + LJSONSchema);

  LValidJSON := '{"name": "Isaque", "age": 30}';
  Writeln('Valid JSON: ' + LValidJSON);
  LValidator := TJSONSchemaValidator.Create(jsvDraft7);
  try
    LResult := LValidator.Validate(LValidJSON, LJSONSchema);
    if not LResult then
      Writeln('Validation errors (valid): ' + TArray.ToString<TValidationError>(LValidator.GetErrors));
    Assert.IsTrue(LResult, 'Valid JSON should pass validation');
    Assert.AreEqual(0, Length(LValidator.GetErrors), 'No validation errors expected for valid JSON');
  finally
    LValidator.Free;
  end;

  LInvalidJSON := '{"age": 30}';
  Writeln('Invalid JSON: ' + LInvalidJSON);
  LValidator := TJSONSchemaValidator.Create(jsvDraft7);
  try
    LResult := LValidator.Validate(LInvalidJSON, LJSONSchema);
    if not LResult then
      Writeln('Validation errors (invalid): ' + TArray.ToString<TValidationError>(LValidator.GetErrors));
    Assert.IsFalse(LResult, 'JSON missing required field should fail');
    Assert.IsTrue(Length(LValidator.GetErrors) > 0, 'Validation errors expected for invalid JSON');
  finally
    LValidator.Free;
  end;
end;

procedure TJSONSmartSchemaComposerTests.TestValidateSimpleRefWithDefinitions;
var
  LJSONSchema, LInvalidJSON: String;
  LValidator: TJSONSchemaValidator;
  LResult: Boolean;
begin
  Writeln('TestValidateSimpleRefWithDefinitions');
  FComposer.Obj
    .Def('contact', procedure(D: TJSONSchemaComposer)
    begin
      D.Typ('object')
       .PropType('phone', 'string', False); // Cria $defs/contact com "required": ["phone"]
    end)
    .Typ('object')
    .Prop('mainContact', procedure(P: TJSONSchemaComposer)
    begin
      P.Add('$ref', '#/$defs/contact'); // Propriedade com $ref
    end)
    .EndObj;

  LJSONSchema := FComposer.ToJSON(False, False);
  Writeln('Schema: ' + LJSONSchema);

  LInvalidJSON := '{"mainContact": {}}'; // JSON inválido pra testar o required
  Writeln('Invalid JSON: ' + LInvalidJSON);
  LValidator := TJSONSchemaValidator.Create(jsvDraft7); // Deixa a lista padrão de traits como está
  try
    LResult := LValidator.Validate(LInvalidJSON, LJSONSchema);
    if not LResult then
      Writeln('Validation errors (invalid): ' + TArray.ToString<TValidationError>(LValidator.GetErrors));
    Assert.IsFalse(LResult, 'Invalid JSON should fail validation');
    Assert.IsTrue(Length(LValidator.GetErrors) > 0, 'Validation errors expected for invalid JSON');
  finally
    LValidator.Free;
  end;
end;

procedure TJSONSmartSchemaComposerTests.TestTypeConstraintsOnly;
var
  LJSONSchema, LJSON: String;
  LValidator: TJSONSchemaValidator;
  LResult: Boolean;
begin
  Writeln('TestTypeConstraintsOnly');
  LJSONSchema := '{"$defs":{"contact":{"type":"object","properties":{"phone":{"type":"string"}}}},"type":"object","properties":{"mainContact":{"$ref":"#/$defs/contact"}}}';
  Writeln('Schema: ' + LJSONSchema);

  LJSON := '{"mainContact":{}}';
  Writeln('JSON: ' + LJSON);
  LValidator := TJSONSchemaValidator.Create(jsvDraft7);
  try
    // Você controla os traits
    LResult := LValidator.Validate(LJSON, LJSONSchema);
    if not LResult then
      Writeln('Validation errors: ' + TArray.ToString<TValidationError>(LValidator.GetErrors));
    Writeln('Result: ' + BoolToStr(LResult, True));
  finally
    LValidator.Free;
  end;
end;

procedure TJSONSmartSchemaComposerTests.TestRefConstraintsOnly;
var
  LJSONSchema, LJSON: String;
  LValidator: TJSONSchemaValidator;
  LResult: Boolean;
begin
  Writeln('TestRefConstraintsOnly');
  LJSONSchema := '{"$defs":{"contact":{"type":"object","properties":{"phone":{"type":"string"}}}},"type":"object","properties":{"mainContact":{"$ref":"#/$defs/contact"}}}';
  Writeln('Schema: ' + LJSONSchema);

  LJSON := '{"mainContact":{}}';
  Writeln('JSON: ' + LJSON);
  LValidator := TJSONSchemaValidator.Create(jsvDraft7);
  try
    // Você habilita/desabilita os traits no _InitializeTraits ou aqui
    // Exemplo: LValidator.FTraits.Clear; LValidator.FTraits.Add(TRefConstraints.Create(LValidator));
    LResult := LValidator.Validate(LJSON, LJSONSchema);
    if not LResult then
      Writeln('Validation errors: ' + TArray.ToString<TValidationError>(LValidator.GetErrors));
    Writeln('Result: ' + BoolToStr(LResult, True));
  finally
    LValidator.Free;
  end;
end;

procedure TJSONSmartSchemaComposerTests.TestRefTypePropertiesConstraints;
var
  LJSONSchema, LJSON: String;
  LValidator: TJSONSchemaValidator;
  LResult: Boolean;
begin
  Writeln('TestRefTypePropertiesConstraints');
  LJSONSchema := '{"$defs":{"contact":{"type":"object","properties":{"phone":{"type":"string"}}}},"type":"object","properties":{"mainContact":{"$ref":"#/$defs/contact"}}}';
  Writeln('Schema: ' + LJSONSchema);

  LJSON := '{"mainContact":{}}';
  Writeln('JSON: ' + LJSON);
  LValidator := TJSONSchemaValidator.Create(jsvDraft7);
  try
    // Traits já estão controlados no _InitializeTraits
    LResult := LValidator.Validate(LJSON, LJSONSchema);
    if not LResult then
      Writeln('Validation errors: ' + TArray.ToString<TValidationError>(LValidator.GetErrors));
    Writeln('Result: ' + BoolToStr(LResult, True));
  finally
    LValidator.Free;
  end;
end;

procedure TJSONSmartSchemaComposerTests.TestRefTypePropertiesObjectConstraints;
var
  LJSONSchema, LJSON: String;
  LValidator: TJSONSchemaValidator;
  LResult: Boolean;
begin
  Writeln('TestRefTypePropertiesObjectConstraints');
  LJSONSchema := '{"$defs":{"contact":{"type":"object","properties":{"phone":{"type":"string"}}}},"type":"object","properties":{"mainContact":{"$ref":"#/$defs/contact"}}}';
  Writeln('Schema: ' + LJSONSchema);

  LJSON := '{"mainContact":{}}';
  Writeln('JSON: ' + LJSON);
  LValidator := TJSONSchemaValidator.Create(jsvDraft7);
  try
    // Traits controlados no _InitializeTraits
    LResult := LValidator.Validate(LJSON, LJSONSchema);
    if not LResult then
      Writeln('Validation errors: ' + TArray.ToString<TValidationError>(LValidator.GetErrors));
    Writeln('Result: ' + BoolToStr(LResult, True));
  finally
    LValidator.Free;
  end;
end;

procedure TJSONSmartSchemaComposerTests.TestRefTypePropertiesObjectRequiredConstraints;
var
  LJSONSchema, LJSON: String;
  LValidator: TJSONSchemaValidator;
  LResult: Boolean;
begin
  Writeln('TestRefTypePropertiesObjectRequiredConstraints');
  LJSONSchema := '{"$defs":{"contact":{"type":"object","properties":{"phone":{"type":"string"}}}},"type":"object","properties":{"mainContact":{"$ref":"#/$defs/contact"}}}';
  Writeln('Schema: ' + LJSONSchema);

  LJSON := '{"mainContact":{}}';
  Writeln('JSON: ' + LJSON);
  LValidator := TJSONSchemaValidator.Create(jsvDraft7);
  try
    // Traits controlados no _InitializeTraits
    LResult := LValidator.Validate(LJSON, LJSONSchema);
    if not LResult then
      Writeln('Validation errors: ' + TArray.ToString<TValidationError>(LValidator.GetErrors));
    Writeln('Result: ' + BoolToStr(LResult, True));
  finally
    LValidator.Free;
  end;
end;

procedure TJSONSmartSchemaComposerTests.TestRefTypePropertiesObjectRequiredEnumConstraints;
var
  LJSONSchema, LJSON: String;
  LValidator: TJSONSchemaValidator;
  LResult: Boolean;
begin
  Writeln('TestRefTypePropertiesObjectRequiredEnumConstraints');
  LJSONSchema := '{"$defs":{"contact":{"type":"object","properties":{"phone":{"type":"string"}}}},"type":"object","properties":{"mainContact":{"$ref":"#/$defs/contact"}}}';
  Writeln('Schema: ' + LJSONSchema);

  LJSON := '{"mainContact":{}}';
  Writeln('JSON: ' + LJSON);
  LValidator := TJSONSchemaValidator.Create(jsvDraft7);
  try
    // Traits controlados no _InitializeTraits
    LResult := LValidator.Validate(LJSON, LJSONSchema);
    if not LResult then
      Writeln('Validation errors: ' + TArray.ToString<TValidationError>(LValidator.GetErrors));
    Writeln('Result: ' + BoolToStr(LResult, True));
  finally
    LValidator.Free;
  end;
end;

procedure TJSONSmartSchemaComposerTests.TestRefTypePropertiesObjectRequiredEnumDefinitionsConstraints;
var
  LJSONSchema, LJSON: String;
  LValidator: TJSONSchemaValidator;
  LResult: Boolean;
begin
  Writeln('TestRefTypePropertiesObjectRequiredEnumDefinitionsConstraints');
  LJSONSchema := '{"$defs":{"contact":{"type":"object","properties":{"phone":{"type":"string"}}}},"type":"object","properties":{"mainContact":{"$ref":"#/$defs/contact"}}}';
  Writeln('Schema: ' + LJSONSchema);

  LJSON := '{"mainContact":{}}';
  Writeln('JSON: ' + LJSON);
  LValidator := TJSONSchemaValidator.Create(jsvDraft7);
  try
    // Traits controlados no _InitializeTraits
    LResult := LValidator.Validate(LJSON, LJSONSchema);
    if not LResult then
      Writeln('Validation errors: ' + TArray.ToString<TValidationError>(LValidator.GetErrors));
    Writeln('Result: ' + BoolToStr(LResult, True));
  finally
    LValidator.Free;
  end;
end;

procedure TJSONSmartSchemaComposerTests.TestRefTypePropertiesObjectRequiredEnumDefinitionsStringConstraints;
var
  LJSONSchema, LJSON: String;
  LValidator: TJSONSchemaValidator;
  LResult: Boolean;
begin
  Writeln('TestRefTypePropertiesObjectRequiredEnumDefinitionsStringConstraints');
  LJSONSchema := '{"$defs":{"contact":{"type":"object","properties":{"phone":{"type":"string"}}}},"type":"object","properties":{"mainContact":{"$ref":"#/$defs/contact"}}}';
  Writeln('Schema: ' + LJSONSchema);

  LJSON := '{"mainContact":{}}';
  Writeln('JSON: ' + LJSON);
  LValidator := TJSONSchemaValidator.Create(jsvDraft7);
  try
    // Traits controlados no _InitializeTraits
    LResult := LValidator.Validate(LJSON, LJSONSchema);
    if not LResult then
      Writeln('Validation errors: ' + TArray.ToString<TValidationError>(LValidator.GetErrors));
    Writeln('Result: ' + BoolToStr(LResult, True));
  finally
    LValidator.Free;
  end;
end;

procedure TJSONSmartSchemaComposerTests.TestRefTypePropertiesObjectRequiredEnumDefinitionsStringNumberConstraints;
var
  LJSONSchema, LJSON: String;
  LValidator: TJSONSchemaValidator;
  LResult: Boolean;
begin
  Writeln('TestRefTypePropertiesObjectRequiredEnumDefinitionsStringNumberConstraints');
  LJSONSchema := '{"$defs":{"contact":{"type":"object","properties":{"phone":{"type":"string"}}}},"type":"object","properties":{"mainContact":{"$ref":"#/$defs/contact"}}}';
  Writeln('Schema: ' + LJSONSchema);

  LJSON := '{"mainContact":{}}';
  Writeln('JSON: ' + LJSON);
  LValidator := TJSONSchemaValidator.Create(jsvDraft7);
  try
    // Traits controlados no _InitializeTraits
    LResult := LValidator.Validate(LJSON, LJSONSchema);
    if not LResult then
      Writeln('Validation errors: ' + TArray.ToString<TValidationError>(LValidator.GetErrors));
    Writeln('Result: ' + BoolToStr(LResult, True));
  finally
    LValidator.Free;
  end;
end;

procedure TJSONSmartSchemaComposerTests.TestRefTypePropertiesObjectRequiredEnumDefinitionsStringNumberArrayConstraints;
var
  LJSONSchema, LJSON: String;
  LValidator: TJSONSchemaValidator;
  LResult: Boolean;
begin
  Writeln('TestRefTypePropertiesObjectRequiredEnumDefinitionsStringNumberArrayConstraints');
  LJSONSchema := '{"$defs":{"contact":{"type":"object","properties":{"phone":{"type":"string"}}}},"type":"object","properties":{"mainContact":{"$ref":"#/$defs/contact"}}}';
  Writeln('Schema: ' + LJSONSchema);

  LJSON := '{"mainContact":{}}';
  Writeln('JSON: ' + LJSON);
  LValidator := TJSONSchemaValidator.Create(jsvDraft7);
  try
    // Traits controlados no _InitializeTraits
    LResult := LValidator.Validate(LJSON, LJSONSchema);
    if not LResult then
      Writeln('Validation errors: ' + TArray.ToString<TValidationError>(LValidator.GetErrors));
    Writeln('Result: ' + BoolToStr(LResult, True));
  finally
    LValidator.Free;
  end;
end;

procedure TJSONSmartSchemaComposerTests.TestRefTypePropertiesObjectRequiredEnumDefinitionsStringNumberArrayMetadataConstraints;
var
  LJSONSchema, LJSON: String;
  LValidator: TJSONSchemaValidator;
  LResult: Boolean;
begin
  Writeln('TestRefTypePropertiesObjectRequiredEnumDefinitionsStringNumberArrayMetadataConstraints');
  LJSONSchema := '{"$defs":{"contact":{"type":"object","properties":{"phone":{"type":"string"}}}},"type":"object","properties":{"mainContact":{"$ref":"#/$defs/contact"}}}';
  Writeln('Schema: ' + LJSONSchema);

  LJSON := '{"mainContact":{}}';
  Writeln('JSON: ' + LJSON);
  LValidator := TJSONSchemaValidator.Create(jsvDraft7);
  try
    // Traits controlados no _InitializeTraits
    LResult := LValidator.Validate(LJSON, LJSONSchema);
    if not LResult then
      Writeln('Validation errors: ' + TArray.ToString<TValidationError>(LValidator.GetErrors));
    Writeln('Result: ' + BoolToStr(LResult, True));
  finally
    LValidator.Free;
  end;
end;

procedure TJSONSmartSchemaComposerTests.TestRefTypePropertiesObjectRequiredEnumDefinitionsStringNumberArrayMetadataFormatConstraints;
var
  LJSONSchema, LJSON: String;
  LValidator: TJSONSchemaValidator;
  LResult: Boolean;
begin
  Writeln('TestRefTypePropertiesObjectRequiredEnumDefinitionsStringNumberArrayMetadataFormatConstraints');
  LJSONSchema := '{"$defs":{"contact":{"type":"object","properties":{"phone":{"type":"string"}}}},"type":"object","properties":{"mainContact":{"$ref":"#/$defs/contact"}}}';
  Writeln('Schema: ' + LJSONSchema);

  LJSON := '{"mainContact":{}}';
  Writeln('JSON: ' + LJSON);
  LValidator := TJSONSchemaValidator.Create(jsvDraft7);
  try
    // Traits controlados no _InitializeTraits
    LResult := LValidator.Validate(LJSON, LJSONSchema);
    if not LResult then
      Writeln('Validation errors: ' + TArray.ToString<TValidationError>(LValidator.GetErrors));
    Writeln('Result: ' + BoolToStr(LResult, True));
  finally
    LValidator.Free;
  end;
end;

procedure TJSONSmartSchemaComposerTests.TestRefTypePropertiesObjectRequiredEnumDefinitionsStringNumberArrayMetadataFormatUniqueConstraints;
var
  LJSONSchema, LJSON: String;
  LValidator: TJSONSchemaValidator;
  LResult: Boolean;
begin
  Writeln('TestRefTypePropertiesObjectRequiredEnumDefinitionsStringNumberArrayMetadataFormatUniqueConstraints');
  LJSONSchema := '{"$defs":{"contact":{"type":"object","properties":{"phone":{"type":"string"}}}},"type":"object","properties":{"mainContact":{"$ref":"#/$defs/contact"}}}';
  Writeln('Schema: ' + LJSONSchema);

  LJSON := '{"mainContact":{}}';
  Writeln('JSON: ' + LJSON);
  LValidator := TJSONSchemaValidator.Create(jsvDraft7);
  try
    // Traits controlados no _InitializeTraits
    LResult := LValidator.Validate(LJSON, LJSONSchema);
    if not LResult then
      Writeln('Validation errors: ' + TArray.ToString<TValidationError>(LValidator.GetErrors));
    Writeln('Result: ' + BoolToStr(LResult, True));
  finally
    LValidator.Free;
  end;
end;

procedure TJSONSmartSchemaComposerTests.TestRefTypePropertiesObjectRequiredEnumDefinitionsStringNumberArrayMetadataFormatUniquePatternConstraints;
var
  LJSONSchema, LJSON: String;
  LValidator: TJSONSchemaValidator;
  LResult: Boolean;
begin
  Writeln('TestRefTypePropertiesObjectRequiredEnumDefinitionsStringNumberArrayMetadataFormatUniquePatternConstraints');
  LJSONSchema := '{"$defs":{"contact":{"type":"object","properties":{"phone":{"type":"string"}}}},"type":"object","properties":{"mainContact":{"$ref":"#/$defs/contact"}}}';
  Writeln('Schema: ' + LJSONSchema);

  LJSON := '{"mainContact":{}}';
  Writeln('JSON: ' + LJSON);
  LValidator := TJSONSchemaValidator.Create(jsvDraft7);
  try
    // Traits controlados no _InitializeTraits
    LResult := LValidator.Validate(LJSON, LJSONSchema);
    if not LResult then
      Writeln('Validation errors: ' + TArray.ToString<TValidationError>(LValidator.GetErrors));
    Writeln('Result: ' + BoolToStr(LResult, True));
  finally
    LValidator.Free;
  end;
end;

procedure TJSONSmartSchemaComposerTests.TestRefTypePropertiesObjectRequiredEnumDefinitionsStringNumberArrayMetadataFormatUniquePatternDependenciesConstraints;
var
  LJSONSchema, LJSON: String;
  LValidator: TJSONSchemaValidator;
  LResult: Boolean;
begin
  Writeln('TestRefTypePropertiesObjectRequiredEnumDefinitionsStringNumberArrayMetadataFormatUniquePatternDependenciesConstraints');
  LJSONSchema := '{"$defs":{"contact":{"type":"object","properties":{"phone":{"type":"string"}}}},"type":"object","properties":{"mainContact":{"$ref":"#/$defs/contact"}}}';
  Writeln('Schema: ' + LJSONSchema);

  LJSON := '{"mainContact":{}}';
  Writeln('JSON: ' + LJSON);
  LValidator := TJSONSchemaValidator.Create(jsvDraft7);
  try
    // Traits controlados no _InitializeTraits
    LResult := LValidator.Validate(LJSON, LJSONSchema);
    if not LResult then
      Writeln('Validation errors: ' + TArray.ToString<TValidationError>(LValidator.GetErrors));
    Writeln('Result: ' + BoolToStr(LResult, True));
  finally
    LValidator.Free;
  end;
end;

procedure TJSONSmartSchemaComposerTests.TestRefTypePropertiesObjectRequiredEnumDefinitionsStringNumberArrayMetadataFormatUniquePatternDependenciesConstConstraints;
var
  LJSONSchema, LJSON: String;
  LValidator: TJSONSchemaValidator;
  LResult: Boolean;
begin
  Writeln('TestRefTypePropertiesObjectRequiredEnumDefinitionsStringNumberArrayMetadataFormatUniquePatternDependenciesConstConstraints');
  LJSONSchema := '{"$defs":{"contact":{"type":"object","properties":{"phone":{"type":"string"}}}},"type":"object","properties":{"mainContact":{"$ref":"#/$defs/contact"}}}';
  Writeln('Schema: ' + LJSONSchema);

  LJSON := '{"mainContact":{}}';
  Writeln('JSON: ' + LJSON);
  LValidator := TJSONSchemaValidator.Create(jsvDraft7);
  try
    // Traits controlados no _InitializeTraits
    LResult := LValidator.Validate(LJSON, LJSONSchema);
    if not LResult then
      Writeln('Validation errors: ' + TArray.ToString<TValidationError>(LValidator.GetErrors));
    Writeln('Result: ' + BoolToStr(LResult, True));
  finally
    LValidator.Free;
  end;
end;

procedure TJSONSmartSchemaComposerTests.TestRefTypePropertiesObjectRequiredEnumDefinitionsStringNumberArrayMetadataFormatUniquePatternDependenciesConstAnchorsConstraints;
var
  LJSONSchema, LJSON: String;
  LValidator: TJSONSchemaValidator;
  LResult: Boolean;
begin
  Writeln('TestRefTypePropertiesObjectRequiredEnumDefinitionsStringNumberArrayMetadataFormatUniquePatternDependenciesConstAnchorsConstraints');
  LJSONSchema := '{"$defs":{"contact":{"type":"object","properties":{"phone":{"type":"string"}}}},"type":"object","properties":{"mainContact":{"$ref":"#/$defs/contact"}}}';
  Writeln('Schema: ' + LJSONSchema);

  LJSON := '{"mainContact":{}}';
  Writeln('JSON: ' + LJSON);
  LValidator := TJSONSchemaValidator.Create(jsvDraft7);
  try
    // Traits controlados no _InitializeTraits
    LResult := LValidator.Validate(LJSON, LJSONSchema);
    if not LResult then
      Writeln('Validation errors: ' + TArray.ToString<TValidationError>(LValidator.GetErrors));
    Writeln('Result: ' + BoolToStr(LResult, True));
  finally
    LValidator.Free;
  end;
end;

procedure TJSONSmartSchemaComposerTests.TestRefTypePropertiesObjectRequiredEnumDefinitionsStringNumberArrayMetadataFormatUniquePatternDependenciesConstAnchorsCombinatorConstraints;
var
  LJSONSchema, LJSON: String;
  LValidator: TJSONSchemaValidator;
  LResult: Boolean;
begin
  Writeln('TestRefTypePropertiesObjectRequiredEnumDefinitionsStringNumberArrayMetadataFormatUniquePatternDependenciesConstAnchorsCombinatorConstraints');
  LJSONSchema := '{"$defs":{"contact":{"type":"object","properties":{"phone":{"type":"string"}}}},"type":"object","properties":{"mainContact":{"$ref":"#/$defs/contact"}}}';
  Writeln('Schema: ' + LJSONSchema);

  LJSON := '{"mainContact":{}}';
  Writeln('JSON: ' + LJSON);
  LValidator := TJSONSchemaValidator.Create(jsvDraft7);
  try
    // Traits controlados no _InitializeTraits
    LResult := LValidator.Validate(LJSON, LJSONSchema);
    if not LResult then
      Writeln('Validation errors: ' + TArray.ToString<TValidationError>(LValidator.GetErrors));
    Writeln('Result: ' + BoolToStr(LResult, True));
  finally
    LValidator.Free;
  end;
end;

procedure TJSONSmartSchemaComposerTests.TestRefTypePropertiesObjectRequiredEnumDefinitionsStringNumberArrayMetadataFormatUniquePatternDependenciesConstAnchorsCombinatorConditionalConstraints;
var
  LJSONSchema, LJSON: String;
  LValidator: TJSONSchemaValidator;
  LResult: Boolean;
begin
  Writeln('TestRefTypePropertiesObjectRequiredEnumDefinitionsStringNumberArrayMetadataFormatUniquePatternDependenciesConstAnchorsCombinatorConditionalConstraints');
  LJSONSchema := '{"$defs":{"contact":{"type":"object","properties":{"phone":{"type":"string"}}}},"type":"object","properties":{"mainContact":{"$ref":"#/$defs/contact"}}}';
  Writeln('Schema: ' + LJSONSchema);

  LJSON := '{"mainContact":{}}';
  Writeln('JSON: ' + LJSON);
  LValidator := TJSONSchemaValidator.Create(jsvDraft7);
  try
    // Traits controlados no _InitializeTraits
    LResult := LValidator.Validate(LJSON, LJSONSchema);
    if not LResult then
      Writeln('Validation errors: ' + TArray.ToString<TValidationError>(LValidator.GetErrors));
    Writeln('Result: ' + BoolToStr(LResult, True));
  finally
    LValidator.Free;
  end;
end;

procedure TJSONSmartSchemaComposerTests.TestRefTypePropertiesObjectRequiredEnumDefinitionsStringNumberArrayMetadataFormatUniquePatternDependenciesConstAnchorsCombinatorConditionalContentConstraints;
var
  LJSONSchema, LJSON: String;
  LValidator: TJSONSchemaValidator;
  LResult: Boolean;
begin
  Writeln('TestRefTypePropertiesObjectRequiredEnumDefinitionsStringNumberArrayMetadataFormatUniquePatternDependenciesConstAnchorsCombinatorConditionalContentConstraints');
  LJSONSchema := '{"$defs":{"contact":{"type":"object","properties":{"phone":{"type":"string"}}}},"type":"object","properties":{"mainContact":{"$ref":"#/$defs/contact"}}}';
  Writeln('Schema: ' + LJSONSchema);

  LJSON := '{"mainContact":{}}';
  Writeln('JSON: ' + LJSON);
  LValidator := TJSONSchemaValidator.Create(jsvDraft7);
  try
    // Traits controlados no _InitializeTraits
    LResult := LValidator.Validate(LJSON, LJSONSchema);
    if not LResult then
      Writeln('Validation errors: ' + TArray.ToString<TValidationError>(LValidator.GetErrors));
    Writeln('Result: ' + BoolToStr(LResult, True));
  finally
    LValidator.Free;
  end;
end;

procedure TJSONSmartSchemaComposerTests.TestGradualMetaSchemaBuildStep1;
var
  LJSON: String;
  LJSONElement: IJSONElement;
  LValidator: TJSONSchemaValidator;
  LResult: Boolean;
  LReader: TJsonReader;
begin
  Writeln('TestGradualMetaSchemaBuildStep1');
  // Construção gradual do meta-schema: só type
  FComposer.Clear; // Limpa estado anterior
  FComposer.Obj
    .Typ('object')
    .EndObj;

  // JSON a validar
  LJSON := '{"mainContact": {}}';
  Writeln('JSON: ' + LJSON);

  // Parse do JSON para IJSONElement
  LReader := TJsonReader.Create;
  try
    LJSONElement := LReader.Read(LJSON);
    Assert.IsNotNull(LJSONElement, 'Falha ao parsear o JSON de teste');
    Writeln('Parsed JSON: ' + LJSONElement.AsJSON);
  finally
    LReader.Free;
  end;

  LValidator := TJSONSchemaValidator.Create(jsvDraft7);
  try
    LValidator.OnLog(procedure(AMessage: String) begin Writeln(AMessage); end);
    LValidator.ParseSchema(FComposer.ToElement);
    LResult := LValidator.Validate(LJSONElement, '');
    if not LResult then
      Writeln('Validation errors: ' + TArray.ToString<TValidationError>(LValidator.GetErrors));
    Assert.IsTrue(LResult, 'Caso válido 1 deveria passar');
    Writeln('Result: ' + BoolToStr(LResult, True));
    Writeln('Generated Schema: ' + FComposer.ToJSON(False, False));
  finally
    LValidator.Free;
  end;
end;

procedure TJSONSmartSchemaComposerTests.TestGradualMetaSchemaBuildStep2;
var
  LJSON: String;
  LJSONElement: IJSONElement;
  LValidator: TJSONSchemaValidator;
  LResult: Boolean;
  LReader: TJsonReader;
begin
  Writeln('TestGradualMetaSchemaBuildStep2');
  FComposer.Clear;
  FComposer.Obj
    .Typ('object')
    .Def('contact', procedure(D: TJSONSchemaComposer) begin D.Typ('object'); end)
    .EndObj;

  LJSON := '{"mainContact": {}}';
  Writeln('JSON: ' + LJSON);

  LReader := TJsonReader.Create;
  try
    LJSONElement := LReader.Read(LJSON);
    Assert.IsNotNull(LJSONElement, 'Falha ao parsear o JSON de teste');
    Writeln('Parsed JSON: ' + LJSONElement.AsJSON);
  finally
    LReader.Free;
  end;

  LValidator := TJSONSchemaValidator.Create(jsvDraft7);
  try
    LValidator.OnLog(procedure(AMessage: String) begin Writeln(AMessage); end);
    LValidator.ParseSchema(FComposer.ToElement);
    LResult := LValidator.Validate(LJSONElement, '');
    if not LResult then
      Writeln('Validation errors: ' + TArray.ToString<TValidationError>(LValidator.GetErrors));
    Assert.IsTrue(LResult, 'Caso válido 1 deveria passar');
    Writeln('Result: ' + BoolToStr(LResult, True));
    Writeln('Generated Schema: ' + FComposer.ToJSON(False, False));
  finally
    LValidator.Free;
  end;
end;

procedure TJSONSmartSchemaComposerTests.TestGradualMetaSchemaBuildStep3;
var
  LJSON: String;
  LJSONElement: IJSONElement;
  LValidator: TJSONSchemaValidator;
  LResult: Boolean;
  LReader: TJsonReader;
begin
  Writeln('TestGradualMetaSchemaBuildStep3');
  // Construção gradual do meta-schema: type + $defs + $ref básico
  FComposer.Clear; // Limpa estado anterior
  FComposer.Obj
    .Typ('object')
    .Def('contact', procedure(D: TJSONSchemaComposer) begin D.Typ('object'); end)
    .Prop('mainContact', procedure(P: TJSONSchemaComposer) begin P.Add('$ref', '#/$defs/contact'); end)
    .EndObj;

  // JSON a validar
  LJSON := '{"mainContact": {}}';
  Writeln('JSON: ' + LJSON);

  // Parse do JSON para IJSONElement
  LReader := TJsonReader.Create;
  try
    LJSONElement := LReader.Read(LJSON);
    Assert.IsNotNull(LJSONElement, 'Falha ao parsear o JSON de teste');
    Writeln('Parsed JSON: ' + LJSONElement.AsJSON);
  finally
    LReader.Free;
  end;

  LValidator := TJSONSchemaValidator.Create(jsvDraft7);
  try
    LValidator.OnLog(procedure(AMessage: String) begin Writeln(AMessage); end);
    LValidator.ParseSchema(FComposer.ToElement);
    LResult := LValidator.Validate(LJSONElement, '');
    if not LResult then
      Writeln('Validation errors: ' + TArray.ToString<TValidationError>(LValidator.GetErrors));
    Assert.IsTrue(LResult, 'Caso válido 1 deveria passar');
    Writeln('Result: ' + BoolToStr(LResult, True));
    Writeln('Generated Schema: ' + FComposer.ToJSON(False, False));
  finally
    LValidator.Free;
  end;
end;

procedure TJSONSmartSchemaComposerTests.TestGradualMetaSchemaBuildStep4;
var
  LJSONValid, LJSONInvalid: String;
  LJSONValidElement, LJSONInvalidElement: IJSONElement;
  LValidator: TJSONSchemaValidator;
  LResult: Boolean;
  LReader: TJsonReader;
begin
  Writeln('TestGradualMetaSchemaBuildStep4');
  // Construção gradual do meta-schema: type + $defs + $ref + required
  FComposer.Clear; // Limpa estado anterior
  FComposer.Obj
    .Typ('object')
    .Def('contact', procedure(D: TJSONSchemaComposer) begin D.Typ('object'); end)
    .Prop('mainContact', procedure(P: TJSONSchemaComposer) begin P.Add('$ref', '#/$defs/contact'); end)
    .RequiredFields(['mainContact']) // Adiciona a propriedade como obrigatória
    .EndObj;

  // JSON válido (com mainContact)
  LJSONValid := '{"mainContact": {}}';
  Writeln('JSON válido: ' + LJSONValid);

  // JSON inválido (sem mainContact)
  LJSONInvalid := '{}';
  Writeln('JSON inválido: ' + LJSONInvalid);

  // Parse dos JSONs para IJSONElement
  LReader := TJsonReader.Create;
  try
    LJSONValidElement := LReader.Read(LJSONValid);
    Assert.IsNotNull(LJSONValidElement, 'Falha ao parsear o JSON válido');
    Writeln('Parsed JSON válido: ' + LJSONValidElement.AsJSON);

    LJSONInvalidElement := LReader.Read(LJSONInvalid);
    Assert.IsNotNull(LJSONInvalidElement, 'Falha ao parsear o JSON inválido');
    Writeln('Parsed JSON inválido: ' + LJSONInvalidElement.AsJSON);
  finally
    LReader.Free;
  end;

  LValidator := TJSONSchemaValidator.Create(jsvDraft7);
  try
    LValidator.OnLog(procedure(AMessage: String) begin Writeln(AMessage); end);
    LValidator.ParseSchema(FComposer.ToElement);

    // Teste com JSON válido
    Writeln('Validando JSON válido...');
    LResult := LValidator.Validate(LJSONValidElement, '');
    if not LResult then
      Writeln('Validation errors (válido): ' + TArray.ToString<TValidationError>(LValidator.GetErrors));
    Assert.IsTrue(LResult, 'Caso válido 1 deveria passar');
    Writeln('Result (válido): ' + BoolToStr(LResult, True));

    // Teste com JSON inválido
    Writeln('Validando JSON inválido...');
    LResult := LValidator.Validate(LJSONInvalidElement, '');
    if not LResult then
      Writeln('Validation errors (inválido): ' + TArray.ToString<TValidationError>(LValidator.GetErrors));
    Assert.IsFalse(LResult, 'Caso inválido 1 deveria falhar');
    Writeln('Result (inválido): ' + BoolToStr(LResult, True));

    Writeln('Generated Schema: ' + FComposer.ToJSON(False, False));
  finally
    LValidator.Free;
  end;
end;

procedure TJSONSmartSchemaComposerTests.TestGradualMetaSchemaBuildStep5;
var
  LJSONValid, LJSONInvalid1, LJSONInvalid2: IJSONElement;
  LValidator: TJSONSchemaValidator;
  LResult: Boolean;
  LReader: TJsonReader;
begin
  Writeln('TestGradualMetaSchemaBuildStep5');
  FComposer.Clear; // Garante que o composer comece limpo
  FComposer.Obj
    .Typ('object')
    .Def('nonNegativeInteger', procedure(D: TJSONSchemaComposer)
      begin
        D.Typ('integer').Min(0);
      end)
    .Def('contact', procedure(D: TJSONSchemaComposer)
      begin
        D.Typ('object')
         .Prop('age', procedure(P: TJSONSchemaComposer)
           begin
             P.Add('$ref', '#/$defs/nonNegativeInteger');
           end)
         .RequiredFields(['age']);
      end)
    .Prop('mainContact', procedure(P: TJSONSchemaComposer)
      begin
        P.Add('$ref', '#/$defs/contact');
      end)
    .RequiredFields(['mainContact'])
    .EndObj;

  LReader := TJsonReader.Create;
  try
    LJSONValid := LReader.Read('{"mainContact": {"age": 25}}');
    LJSONInvalid1 := LReader.Read('{"mainContact": {}}');
    LJSONInvalid2 := LReader.Read('{"mainContact": {"age": -5}}');
    Assert.IsNotNull(LJSONValid, 'Falha ao parsear JSON válido');
    Assert.IsNotNull(LJSONInvalid1, 'Falha ao parsear JSON inválido 1');
    Assert.IsNotNull(LJSONInvalid2, 'Falha ao parsear JSON inválido 2');
    Writeln('JSON válido: ' + LJSONValid.AsJSON);
    Writeln('JSON inválido 1 (sem age): ' + LJSONInvalid1.AsJSON);
    Writeln('JSON inválido 2 (age negativo): ' + LJSONInvalid2.AsJSON);

    LValidator := TJSONSchemaValidator.Create(jsvDraft7);
    try
      LValidator.OnLog(procedure(AMessage: String) begin Writeln(AMessage); end);
      LValidator.ParseSchema(FComposer.ToElement); // Parseia o schema uma vez

      Writeln('Validando JSON válido...');
      LResult := LValidator.Validate('{"mainContact": {"age": 25}}', FComposer.ToJSON(False, False));
      if not LResult then
        Writeln('Validation errors (válido): ' + TArray.ToString<TValidationError>(LValidator.GetErrors));
      Assert.IsTrue(LResult, 'Caso válido 1 deveria passar');
      Writeln('Result (válido): ' + BoolToStr(LResult, True));

      Writeln('Validando JSON inválido 1...');
      LResult := LValidator.Validate(LJSONInvalid1, ''); // Reutiliza o schema
      if not LResult then
        Writeln('Validation errors (inválido 1): ' + TArray.ToString<TValidationError>(LValidator.GetErrors));
      Assert.IsFalse(LResult, 'Caso inválido 1 deveria falhar');
      Writeln('Result (inválido 1): ' + BoolToStr(LResult, True));

      Writeln('Validando JSON inválido 2...');
      LResult := LValidator.Validate(LJSONInvalid2, ''); // Reutiliza o schema
      if not LResult then
        Writeln('Validation errors (inválido 2): ' + TArray.ToString<TValidationError>(LValidator.GetErrors));
      Assert.IsFalse(LResult, 'Caso inválido 2 deveria falhar');
      Writeln('Result (inválido 2): ' + BoolToStr(LResult, True));

      Writeln('Generated Schema: ' + FComposer.ToJSON(False, False));
    finally
      LValidator.Free;
    end;
  finally
    LReader.Free;
  end;
end;

procedure TJSONSmartSchemaComposerTests.TestGradualMetaSchemaBuildStep6;
var
  LJSONValid, LJSONInvalid1, LJSONInvalid2: IJSONElement;
  LValidator: TJSONSchemaValidator;
  LResult: Boolean;
  LReader: TJsonReader;
begin
  Writeln('TestGradualMetaSchemaBuildStep6');
  FComposer.Clear;
  FComposer.Obj
    .Typ('object')
    .Def('nonNegativeInteger', procedure(D: TJSONSchemaComposer)
      begin
        D.Typ('integer').Min(0);
      end)
    .Def('contact', procedure(D: TJSONSchemaComposer)
      begin
        D.Typ('object')
         .Prop('age', procedure(P: TJSONSchemaComposer)
           begin
             P.Add('$ref', '#/$defs/nonNegativeInteger');
           end)
         .RequiredFields(['age']);
      end)
    .Prop('mainContact', procedure(P: TJSONSchemaComposer)
      begin
        P.Add('$ref', '#/$defs/contact');
      end)
    .Prop('contacts', procedure(P: TJSONSchemaComposer)
      begin
        P.Typ('array')
         .Items(FComposer.SubSchema(procedure(Sub: TJSONSchemaComposer)
           begin
             Sub.Add('$ref', '#/$defs/contact');
           end));
      end)
    .RequiredFields(['mainContact'])
    .EndObj;


  Writeln('Start Hierarquia: ');
  LogJSONHierarchy(FComposer.ToElement, '');
  Writeln('End Hierarquia: ');


  LReader := TJsonReader.Create;
  try
//    LJSONValid := LReader.Read('{"mainContact": {"age": 25}, "contacts": [{"age": 30}, {"age": 40}]}');
//    LJSONInvalid1 := LReader.Read('{"mainContact": {"age": 25}, "contacts": [{"age": -5}]}');
//    LJSONInvalid2 := LReader.Read('{"mainContact": {"age": 25}, "contacts": [{}]}');
//    Assert.IsNotNull(LJSONValid, 'Falha ao parsear JSON válido');
//    Assert.IsNotNull(LJSONInvalid1, 'Falha ao parsear JSON inválido 1');
//    Assert.IsNotNull(LJSONInvalid2, 'Falha ao parsear JSON inválido 2');
//    Writeln('JSON válido: ' + LJSONValid.AsJSON);
//    Writeln('JSON inválido 1 (age negativo no array): ' + LJSONInvalid1.AsJSON);
//    Writeln('JSON inválido 2 (sem age no array): ' + LJSONInvalid2.AsJSON);

    LValidator := TJSONSchemaValidator.Create(jsvDraft7);
    try
      LValidator.OnLog(procedure(AMessage: String) begin Writeln(AMessage); end);
      LValidator.ParseSchema(FComposer.ToElement);
      Writeln('Generated Schema: ' + FComposer.ToJSON(True, False));

//      Writeln('Validando JSON válido...');
//      LResult := LValidator.Validate(LJSONValid, '');
//      if not LResult then
//        Writeln('Validation errors (válido): ' + TArray.ToString<TValidationError>(LValidator.GetErrors));
//      Assert.IsTrue(LResult, 'Caso válido 1 deveria passar');
//      Writeln('Result (válido): ' + BoolToStr(LResult, True));

//      Writeln('Validando JSON inválido 1...');
//      LResult := LValidator.Validate(LJSONInvalid1, '');
//      if not LResult then
//        Writeln('Validation errors (inválido 1): ' + TArray.ToString<TValidationError>(LValidator.GetErrors));
//      Assert.IsFalse(LResult, 'Caso inválido 1 deveria falhar');
//      Writeln('Result (inválido 1): ' + BoolToStr(LResult, True));

//      Writeln('Validando JSON inválido 2...');
//      LResult := LValidator.Validate(LJSONInvalid2, '');
//      if not LResult then
//        Writeln('Validation errors (inválido 2): ' + TArray.ToString<TValidationError>(LValidator.GetErrors));
//      Assert.IsFalse(LResult, 'Caso inválido 2 deveria falhar');
//      Writeln('Result (inválido 2): ' + BoolToStr(LResult, True));
    finally
      LValidator.Free;
    end;
  finally
    LReader.Free;
  end;
end;

procedure TJSONSmartSchemaComposerTests.LogJSONHierarchy(const AElement: IJSONElement; const APath: String);
var
  LObj: IJSONObject;
  LArray: IJSONArray;
  LPair: IJSONPair;
  LIndex: Integer;
  LNewPath: String;
begin
  if not Assigned(AElement) then
  begin
    Writeln('Path: ' + APath + ' - Value: null');
    Exit;
  end;

  if Supports(AElement, IJSONObject, LObj) then
  begin
    Writeln('Path: ' + APath + ' - Object Start');
    for LPair in LObj.Pairs do
    begin
      LNewPath := IfThen(APath = '', LPair.Key, APath + '/' + LPair.Key);
      LogJSONHierarchy(LPair.Value, LNewPath);
    end;
    Writeln('Path: ' + APath + ' - Object End');
  end
  else if Supports(AElement, IJSONArray, LArray) then
  begin
    Writeln('Path: ' + APath + ' - Array Start');
    for LIndex := 0 to LArray.Count - 1 do
    begin
      LNewPath := APath + '/' + IntToStr(LIndex);
      LogJSONHierarchy(LArray.GetItem(LIndex), LNewPath);
    end;
    Writeln('Path: ' + APath + ' - Array End');
  end
  else
  begin
    Writeln('Path: ' + APath + ' - Value: ' + AElement.AsJSON);
  end;
end;

procedure TJSONSmartSchemaComposerTests.TestGradualMetaSchemaBuildStep7;
var
  LJSONValid, LJSONInvalid1, LJSONInvalid2, LJSONInvalid3: IJSONElement;
  LValidator: TJSONSchemaValidator;
  LResult: Boolean;
  LReader: TJsonReader;
begin
  Writeln('TestGradualMetaSchemaBuildStep7');
  // Construção gradual do schema
  FComposer.Obj
    .Typ('object')
    .Def('nonNegativeInteger', procedure(D: TJSONSchemaComposer)
      begin
        D.Typ('integer').Min(0);
      end)
    .Def('contact', procedure(D: TJSONSchemaComposer)
      begin
        D.Typ('object')
         .Prop('age', procedure(P: TJSONSchemaComposer)
           begin
             P.Add('$ref', '#/$defs/nonNegativeInteger');
           end)
         .Prop('role', procedure(P: TJSONSchemaComposer)
           begin
             P.Typ('string').Enum(['admin', 'user', 'guest']);
           end)
         .RequiredFields(['age', 'role']);
      end)
    .Prop('mainContact', procedure(P: TJSONSchemaComposer)
      begin
        P.Add('$ref', '#/$defs/contact');
      end)
    .Prop('contacts', procedure(P: TJSONSchemaComposer)
      begin
        P.Typ('array')
         .Items(FComposer.SubSchema(procedure(Sub: TJSONSchemaComposer)
           begin
             Sub.Add('$ref', '#/$defs/contact');
           end))
         .MinItems(1)
         .MaxItems(3);
      end)
    .RequiredFields(['mainContact'])
    .EndObj;

  LReader := TJsonReader.Create;
  try
    LJSONValid := LReader.Read('{"mainContact": {"age": 25, "role": "admin"}, "contacts": [{"age": 30, "role": "user"}, {"age": 40, "role": "guest"}]}');
    LJSONInvalid1 := LReader.Read('{"mainContact": {"age": 25, "role": "admin"}, "contacts": []}');
    LJSONInvalid2 := LReader.Read('{"mainContact": {"age": 25, "role": "admin"}, "contacts": [{"age": 30, "role": "manager"}]}');
    LJSONInvalid3 := LReader.Read('{"mainContact": {"age": 25, "role": "admin"}, "contacts": [{"age": 30, "role": "user"}, {"age": 40, "role": "guest"}, {"age": 50, "role": "admin"}, {"age": 60, "role": "user"}]}');
    Writeln('JSON válido: ' + LJSONValid.AsJSON);
    Writeln('JSON inválido 1 (array vazio): ' + LJSONInvalid1.AsJSON);
    Writeln('JSON inválido 2 (role fora do enum): ' + LJSONInvalid2.AsJSON);
    Writeln('JSON inválido 3 (array longo): ' + LJSONInvalid3.AsJSON);

    LValidator := TJSONSchemaValidator.Create(jsvDraft7);
    try
      LValidator.OnLog(procedure(AMessage: String) begin Writeln(AMessage); end);
      LValidator.ParseSchema(FComposer.ToElement);

      Writeln('Validando JSON válido...');
      LResult := LValidator.Validate(LJSONValid, '');
      if not LResult then
        Writeln('Validation errors (válido): ' + TArray.ToString<TValidationError>(LValidator.GetErrors));
      Assert.IsTrue(LResult, 'Caso válido 1 deveria passar');
      Writeln('Result (válido): ' + BoolToStr(LResult, True));

      Writeln('Validando JSON inválido 1...');
      LResult := LValidator.Validate(LJSONInvalid1, '');
      if not LResult then
        Writeln('Validation errors (inválido 1): ' + TArray.ToString<TValidationError>(LValidator.GetErrors));
      Assert.IsFalse(LResult, 'Caso inválido 1 deveria falhar');
      Writeln('Result (inválido 1): ' + BoolToStr(LResult, True));

      Writeln('Validando JSON inválido 2...');
      LResult := LValidator.Validate(LJSONInvalid2, '');
      if not LResult then
        Writeln('Validation errors (inválido 2): ' + TArray.ToString<TValidationError>(LValidator.GetErrors));
      Assert.IsFalse(LResult, 'Caso inválido 2 deveria falhar');
      Writeln('Result (inválido 2): ' + BoolToStr(LResult, True));

      Writeln('Validando JSON inválido 3...');
      LResult := LValidator.Validate(LJSONInvalid3, '');
      if not LResult then
        Writeln('Validation errors (inválido 3): ' + TArray.ToString<TValidationError>(LValidator.GetErrors));
      Assert.IsFalse(LResult, 'Caso inválido 3 deveria falhar');
      Writeln('Result (inválido 3): ' + BoolToStr(LResult, True));

      Writeln('Generated Schema: ' + FComposer.ToJSON(True, False));
    finally
      LValidator.Free;
    end;
  finally
    LReader.Free;
  end;
end;

procedure TJSONSmartSchemaComposerTests.TestGradualMetaSchemaBuildStep8;
var
  LJSONValid, LJSONInvalid1, LJSONInvalid2: IJSONElement;
  LValidator: TJSONSchemaValidator;
  LResult: Boolean;
  LReader: TJsonReader;
begin
  Writeln('TestGradualMetaSchemaBuildStep8');
  FComposer.Obj
    .Typ('object')
    .Def('nonNegativeInteger', procedure(D: TJSONSchemaComposer)
      begin
        D.Typ('integer').Min(0);
      end)
    .Def('contact', procedure(D: TJSONSchemaComposer)
      begin
        D.Typ('object')
         .Prop('age', procedure(P: TJSONSchemaComposer)
           begin
             P.Add('$ref', '#/$defs/nonNegativeInteger');
           end)
         .Prop('role', procedure(P: TJSONSchemaComposer)
           begin
             P.Typ('string').Enum(['admin', 'user', 'guest']);
           end)
         .Prop('email', procedure(P: TJSONSchemaComposer)
           begin
             P.Typ('string').Pattern('^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
           end)
         .RequiredFields(['age', 'role', 'email']);
      end)
    .Prop('mainContact', procedure(P: TJSONSchemaComposer)
      begin
        P.Add('$ref', '#/$defs/contact');
      end)
    .Prop('contacts', procedure(P: TJSONSchemaComposer)
      begin
        P.Typ('array')
         .Items(FComposer.SubSchema(procedure(Sub: TJSONSchemaComposer)
           begin
             Sub.Add('$ref', '#/$defs/contact');
           end))
         .MinItems(1)
         .MaxItems(3);
      end)
    .RequiredFields(['mainContact'])
    .EndObj;

  LReader := TJsonReader.Create;
  try
    LJSONValid := LReader.Read('{"mainContact": {"age": 25, "role": "admin", "email": "user@example.com"}, "contacts": [{"age": 30, "role": "user", "email": "test@domain.com"}]}');
    LJSONInvalid1 := LReader.Read('{"mainContact": {"age": 25, "role": "admin", "email": "invalid-email"}, "contacts": [{"age": 30, "role": "user", "email": "test@domain.com"}]}');
    LJSONInvalid2 := LReader.Read('{"mainContact": {"age": 25, "role": "admin", "email": "user@example.com"}, "contacts": []}');
    Writeln('JSON válido: ' + LJSONValid.AsJSON);
    Writeln('JSON inválido 1 (email inválido): ' + LJSONInvalid1.AsJSON);
    Writeln('JSON inválido 2 (array vazio): ' + LJSONInvalid2.AsJSON);

    LValidator := TJSONSchemaValidator.Create(jsvDraft7);
    try
      LValidator.OnLog(procedure(AMessage: String) begin Writeln(AMessage); end);
      LValidator.ParseSchema(FComposer.ToElement);

      Writeln('Validando JSON válido...');
      LResult := LValidator.Validate(LJSONValid, '');
      if not LResult then
        Writeln('Validation errors (válido): ' + TArray.ToString<TValidationError>(LValidator.GetErrors));
      Assert.IsTrue(LResult, 'Caso válido 1 deveria passar');
      Writeln('Result (válido): ' + BoolToStr(LResult, True));

      Writeln('Validando JSON inválido 1...');
      LResult := LValidator.Validate(LJSONInvalid1, '');
      if not LResult then
        Writeln('Validation errors (inválido 1): ' + TArray.ToString<TValidationError>(LValidator.GetErrors));
      Assert.IsFalse(LResult, 'Caso inválido 1 deveria falhar');
      Writeln('Result (inválido 1): ' + BoolToStr(LResult, True));

      Writeln('Validando JSON inválido 2...');
      LResult := LValidator.Validate(LJSONInvalid2, '');
      if not LResult then
        Writeln('Validation errors (inválido 2): ' + TArray.ToString<TValidationError>(LValidator.GetErrors));
      Assert.IsFalse(LResult, 'Caso inválido 2 deveria falhar');
      Writeln('Result (inválido 2): ' + BoolToStr(LResult, True));

      Writeln('Generated Schema: ' + FComposer.ToJSON(True, False));
    finally
      LValidator.Free;
    end;
  finally
    LReader.Free;
  end;
end;

procedure TJSONSmartSchemaComposerTests.TestGradualMetaSchemaBuildStep9;
var
  LJSONValid, LJSONInvalid1, LJSONInvalid2: IJSONElement;
  LValidator: TJSONSchemaValidator;
  LResult: Boolean;
  LReader: TJsonReader;
begin
  Writeln('TestGradualMetaSchemaBuildStep9');
  FComposer.Obj
    .Typ('object')
    .Def('nonNegativeInteger', procedure(D: TJSONSchemaComposer)
      begin
        D.Typ('integer').Min(0);
      end)
    .Def('contact', procedure(D: TJSONSchemaComposer)
      begin
        D.Typ('object')
         .Prop('age', procedure(P: TJSONSchemaComposer)
           begin
             P.Add('$ref', '#/$defs/nonNegativeInteger');
           end)
         .Prop('role', procedure(P: TJSONSchemaComposer)
           begin
             P.Typ('string').Enum(['admin', 'user', 'guest']);
           end)
         .Prop('email', procedure(P: TJSONSchemaComposer)
           begin
             P.Typ('string').Pattern('^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
           end)
         .RequiredFields(['age', 'role', 'email']);
      end)
    .Def('extendedContact', procedure(D: TJSONSchemaComposer)
      begin
        D.AllOf([
          FComposer.SubSchema(procedure(Sub: TJSONSchemaComposer)
            begin
              Sub.Add('$ref', '#/$defs/contact');
            end),
          FComposer.SubSchema(procedure(Sub: TJSONSchemaComposer)
            begin
              Sub.Typ('object')
                .Prop('phone', procedure(P: TJSONSchemaComposer)
                  begin
                    P.Typ('string').Pattern('^\+?[1-9]\d{1,14}$');
                  end)
                .RequiredFields(['phone']);
            end)
        ]);
      end)
    .Prop('mainContact', procedure(P: TJSONSchemaComposer)
      begin
        P.Add('$ref', '#/$defs/extendedContact');
      end)
    .Prop('contacts', procedure(P: TJSONSchemaComposer)
      begin
        P.Typ('array')
         .Items(FComposer.SubSchema(procedure(Sub: TJSONSchemaComposer)
           begin
             Sub.Add('$ref', '#/$defs/extendedContact');
           end))
         .MinItems(1)
         .MaxItems(3);
      end)
    .RequiredFields(['mainContact'])
    .EndObj;

  LReader := TJsonReader.Create;
  try
    LJSONValid := LReader.Read('{"mainContact": {"age": 25, "role": "admin", "email": "user@example.com", "phone": "+123456789"}, "contacts": [{"age": 30, "role": "user", "email": "test@domain.com", "phone": "+987654321"}]}');
    LJSONInvalid1 := LReader.Read('{"mainContact": {"age": 25, "role": "admin", "email": "user@example.com"}, "contacts": [{"age": 30, "role": "user", "email": "test@domain.com", "phone": "+987654321"}]}');
    LJSONInvalid2 := LReader.Read('{"mainContact": {"age": 25, "role": "admin", "email": "user@example.com", "phone": "invalid"}, "contacts": [{"age": 30, "role": "user", "email": "test@domain.com", "phone": "+987654321"}]}');
    Writeln('JSON válido: ' + LJSONValid.AsJSON);
    Writeln('JSON inválido 1 (sem phone): ' + LJSONInvalid1.AsJSON);
    Writeln('JSON inválido 2 (phone inválido): ' + LJSONInvalid2.AsJSON);

    LValidator := TJSONSchemaValidator.Create(jsvDraft7);
    try
      LValidator.OnLog(procedure(AMessage: String) begin Writeln(AMessage); end);
      LValidator.ParseSchema(FComposer.ToElement);

      Writeln('Validando JSON válido...');
      LResult := LValidator.Validate(LJSONValid, '');
      if not LResult then
        Writeln('Validation errors (válido): ' + TArray.ToString<TValidationError>(LValidator.GetErrors));
      Assert.IsTrue(LResult, 'Caso válido 1 deveria passar');
      Writeln('Result (válido): ' + BoolToStr(LResult, True));

      Writeln('Validando JSON inválido 1...');
      LResult := LValidator.Validate(LJSONInvalid1, '');
      if not LResult then
        Writeln('Validation errors (inválido 1): ' + TArray.ToString<TValidationError>(LValidator.GetErrors));
      Assert.IsFalse(LResult, 'Caso inválido 1 deveria falhar');
      Writeln('Result (inválido 1): ' + BoolToStr(LResult, True));

      Writeln('Validando JSON inválido 2...');
      LResult := LValidator.Validate(LJSONInvalid2, '');
      if not LResult then
        Writeln('Validation errors (inválido 2): ' + TArray.ToString<TValidationError>(LValidator.GetErrors));
      Assert.IsFalse(LResult, 'Caso inválido 2 deveria falhar');
      Writeln('Result (inválido 2): ' + BoolToStr(LResult, True));

      Writeln('Generated Schema: ' + FComposer.ToJSON(True, False));
    finally
      LValidator.Free;
    end;
  finally
    LReader.Free;
  end;
end;

procedure TJSONSmartSchemaComposerTests.TestGradualMetaSchemaBuildStep10;
var
  LJSONValid1, LJSONValid2, LJSONInvalid: IJSONElement;
  LValidator: TJSONSchemaValidator;
  LResult: Boolean;
  LReader: TJsonReader;
begin
  Writeln('TestGradualMetaSchemaBuildStep10');
  FComposer.Obj
    .Typ('object')
    .Def('nonNegativeInteger', procedure(D: TJSONSchemaComposer)
      begin
        D.Typ('integer').Min(0);
      end)
    .Def('contact', procedure(D: TJSONSchemaComposer)
      begin
        D.Typ('object')
         .Prop('age', procedure(P: TJSONSchemaComposer)
           begin
             P.Add('$ref', '#/$defs/nonNegativeInteger');
           end)
         .Prop('role', procedure(P: TJSONSchemaComposer)
           begin
             P.Typ('string').Enum(['admin', 'user', 'guest']);
           end)
         .Prop('email', procedure(P: TJSONSchemaComposer)
           begin
             P.Typ('string').Pattern('^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
           end)
         .RequiredFields(['age', 'role', 'email']);
      end)
    .Def('extendedContact', procedure(D: TJSONSchemaComposer)
      begin
        D.AllOf([
          FComposer.SubSchema(procedure(Sub: TJSONSchemaComposer)
            begin
              Sub.Add('$ref', '#/$defs/contact');
            end),
          FComposer.SubSchema(procedure(Sub: TJSONSchemaComposer)
            begin
              Sub.Typ('object')
                .Prop('phone', procedure(P: TJSONSchemaComposer)
                  begin
                    P.Typ('string').Pattern('^\+?[1-9]\d{1,14}$');
                  end)
                .RequiredFields(['phone']);
            end)
        ]);
      end)
    .Def('contactOrString', procedure(D: TJSONSchemaComposer)
      begin
        D.AnyOf([
          FComposer.SubSchema(procedure(Sub: TJSONSchemaComposer)
            begin
              Sub.Add('$ref', '#/$defs/extendedContact');
            end),
          FComposer.SubSchema(procedure(Sub: TJSONSchemaComposer)
            begin
              Sub.Typ('string');
            end)
        ]);
      end)
    .Prop('mainContact', procedure(P: TJSONSchemaComposer)
      begin
        P.Add('$ref', '#/$defs/contactOrString');
      end)
    .Prop('contacts', procedure(P: TJSONSchemaComposer)
      begin
        P.Typ('array')
         .Items(FComposer.SubSchema(procedure(Sub: TJSONSchemaComposer)
           begin
             Sub.Add('$ref', '#/$defs/contactOrString');
           end))
         .MinItems(1)
         .MaxItems(3);
      end)
    .RequiredFields(['mainContact'])
    .EndObj;

  LReader := TJsonReader.Create;
  try
    LJSONValid1 := LReader.Read('{"mainContact": {"age": 25, "role": "admin", "email": "user@example.com", "phone": "+123456789"}, "contacts": [{"age": 30, "role": "user", "email": "test@domain.com", "phone": "+987654321"}]}');
    LJSONValid2 := LReader.Read('{"mainContact": "simple string", "contacts": ["another string"]}');
    LJSONInvalid := LReader.Read('{"mainContact": {"age": 25}, "contacts": [{"role": "user"}]}');
    Writeln('JSON válido 1: ' + LJSONValid1.AsJSON);
    Writeln('JSON válido 2: ' + LJSONValid2.AsJSON);
    Writeln('JSON inválido (nenhum anyOf válido): ' + LJSONInvalid.AsJSON);

    LValidator := TJSONSchemaValidator.Create(jsvDraft7);
    try
      LValidator.OnLog(procedure(AMessage: String) begin Writeln(AMessage); end);
      LValidator.ParseSchema(FComposer.ToElement);

      Writeln('Validando JSON válido 1...');
      LResult := LValidator.Validate(LJSONValid1, '');
      if not LResult then
        Writeln('Validation errors (válido 1): ' + TArray.ToString<TValidationError>(LValidator.GetErrors));
      Assert.IsTrue(LResult, 'Caso válido 1 deveria passar');
      Writeln('Result (válido 1): ' + BoolToStr(LResult, True));

      Writeln('Validando JSON válido 2...');
      LResult := LValidator.Validate(LJSONValid2, '');
      if not LResult then
        Writeln('Validation errors (válido 2): ' + TArray.ToString<TValidationError>(LValidator.GetErrors));
      Assert.IsTrue(LResult, 'Caso válido 2 deveria passar');
      Writeln('Result (válido 2): ' + BoolToStr(LResult, True));

      Writeln('Validando JSON inválido...');
      LResult := LValidator.Validate(LJSONInvalid, '');
      if not LResult then
        Writeln('Validation errors (inválido): ' + TArray.ToString<TValidationError>(LValidator.GetErrors));
      Assert.IsFalse(LResult, 'Caso inválido 1 deveria falhar');
      Writeln('Result (inválido): ' + BoolToStr(LResult, True));

      Writeln('Generated Schema: ' + FComposer.ToJSON(True, False));
    finally
      LValidator.Free;
    end;
  finally
    LReader.Free;
  end;
end;

procedure TJSONSmartSchemaComposerTests.TestGradualMetaSchemaBuildStep11;
var
  LJSONValid1, LJSONValid2, LJSONInvalid1, LJSONInvalid2: IJSONElement;
  LValidator: TJSONSchemaValidator;
  LResult: Boolean;
  LReader: TJsonReader;
begin
  Writeln('TestGradualMetaSchemaBuildStep11');
  FComposer.Obj
    .Typ('object')
    .Def('nonNegativeInteger', procedure(D: TJSONSchemaComposer)
      begin
        D.Typ('integer').Min(0);
      end)
    .Def('contact', procedure(D: TJSONSchemaComposer)
      begin
        D.Typ('object')
         .Prop('age', procedure(P: TJSONSchemaComposer)
           begin
             P.Add('$ref', '#/$defs/nonNegativeInteger');
           end)
         .Prop('role', procedure(P: TJSONSchemaComposer)
           begin
             P.Typ('string').Enum(['admin', 'user', 'guest']);
           end)
         .Prop('email', procedure(P: TJSONSchemaComposer)
           begin
             P.Typ('string').Pattern('^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
           end)
         .RequiredFields(['age', 'role', 'email']);
      end)
    .Def('extendedContact', procedure(D: TJSONSchemaComposer)
      begin
        D.AllOf([
          FComposer.SubSchema(procedure(Sub: TJSONSchemaComposer)
            begin
              Sub.Add('$ref', '#/$defs/contact');
            end),
          FComposer.SubSchema(procedure(Sub: TJSONSchemaComposer)
            begin
              Sub.Typ('object')
                .Prop('phone', procedure(P: TJSONSchemaComposer)
                  begin
                    P.Typ('string').Pattern('^\+?[1-9]\d{1,14}$');
                  end)
                .RequiredFields(['phone']);
            end)
        ]);
      end)
    .Def('contactOrString', procedure(D: TJSONSchemaComposer)
      begin
        D.OneOf([
          FComposer.SubSchema(procedure(Sub: TJSONSchemaComposer)
            begin
              Sub.Add('$ref', '#/$defs/extendedContact');
            end),
          FComposer.SubSchema(procedure(Sub: TJSONSchemaComposer)
            begin
              Sub.Typ('string');
            end)
        ]);
      end)
    .Prop('mainContact', procedure(P: TJSONSchemaComposer)
      begin
        P.Add('$ref', '#/$defs/contactOrString');
      end)
    .Prop('contacts', procedure(P: TJSONSchemaComposer)
      begin
        P.Typ('array')
         .Items(FComposer.SubSchema(procedure(Sub: TJSONSchemaComposer)
           begin
             Sub.Add('$ref', '#/$defs/contactOrString');
           end))
         .MinItems(1)
         .MaxItems(3);
      end)
    .RequiredFields(['mainContact'])
    .EndObj;

  LReader := TJsonReader.Create;
  try
    LJSONValid1 := LReader.Read('{"mainContact": {"age": 25, "role": "admin", "email": "user@example.com", "phone": "+123456789"}, "contacts": [{"age": 30, "role": "user", "email": "test@domain.com", "phone": "+987654321"}]}');
    LJSONValid2 := LReader.Read('{"mainContact": "simple string", "contacts": ["another string"]}');
    LJSONInvalid1 := LReader.Read('{"mainContact": {"age": 25}, "contacts": [{"role": "user"}]}');
    LJSONInvalid2 := LReader.Read('{"mainContact": {"age": 25, "role": "admin", "email": "user@example.com", "phone": "+123456789", "extra": "string"}, "contacts": ["another string"]}');
    Writeln('JSON válido 1: ' + LJSONValid1.AsJSON);
    Writeln('JSON válido 2: ' + LJSONValid2.AsJSON);
    Writeln('JSON inválido 1 (nenhum valida): ' + LJSONInvalid1.AsJSON);
    Writeln('JSON inválido 2 (ambos validam): ' + LJSONInvalid2.AsJSON);

    LValidator := TJSONSchemaValidator.Create(jsvDraft7);
    try
      LValidator.OnLog(procedure(AMessage: String) begin Writeln(AMessage); end);
      LValidator.ParseSchema(FComposer.ToElement);

      Writeln('Validando JSON válido 1...');
      LResult := LValidator.Validate(LJSONValid1, '');
      if not LResult then
        Writeln('Validation errors (válido 1): ' + TArray.ToString<TValidationError>(LValidator.GetErrors));
      Writeln('Result (válido 1): ' + BoolToStr(LResult, True));
      Assert.IsTrue(LResult, 'Caso válido 1 deveria passar');

      Writeln('Validando JSON válido 2...');
      LResult := LValidator.Validate(LJSONValid2, '');
      if not LResult then
        Writeln('Validation errors (válido 2): ' + TArray.ToString<TValidationError>(LValidator.GetErrors));
      Writeln('Result (válido 2): ' + BoolToStr(LResult, True));
      Assert.IsTrue(LResult, 'Caso válido 2 deveria passar');

      Writeln('Validando JSON inválido 1...');
      LResult := LValidator.Validate(LJSONInvalid1, '');
      if not LResult then
        Writeln('Validation errors (inválido 1): ' + TArray.ToString<TValidationError>(LValidator.GetErrors));
      Writeln('Result (inválido 1): ' + BoolToStr(LResult, True));
      Assert.IsFalse(LResult, 'Caso inválido 1 deveria falhar');

      Writeln('Validando JSON inválido 2...');
      LResult := LValidator.Validate(LJSONInvalid2, '');
      if not LResult then
        Writeln('Validation errors (inválido 2): ' + TArray.ToString<TValidationError>(LValidator.GetErrors));
      Writeln('Result (inválido 2): ' + BoolToStr(LResult, True));
      Assert.IsFalse(LResult, 'Caso inválido 2 deveria falhar');

      Writeln('Generated Schema: ' + FComposer.ToJSON(True, False));
    finally
      LValidator.Free;
    end;
  finally
    LReader.Free;
  end;
end;

procedure TJSONSmartSchemaComposerTests.TestGradualMetaSchemaBuildStep12;
var
  LJSONValid1, LJSONValid2, LJSONValid3, LJSONInvalid1, LJSONInvalid2: IJSONElement;
  LValidator: TJSONSchemaValidator;
  LResult: Boolean;
  LReader: TJsonReader;
  I: Integer;
begin
  Writeln('TestGradualMetaSchemaBuildStep12');
  FComposer.Obj
    .Typ('object')
    .Def('nonNegativeInteger', procedure(D: TJSONSchemaComposer) begin D.Typ('integer').Min(0); end)
    .Def('contact', procedure(D: TJSONSchemaComposer)
      begin
        D.Typ('object')
         .Prop('age', procedure(P: TJSONSchemaComposer) begin P.Add('$ref', '#/$defs/nonNegativeInteger'); end)
         .Prop('role', procedure(P: TJSONSchemaComposer) begin P.Typ('string').Enum(['admin', 'user', 'guest']); end)
         .Prop('email', procedure(P: TJSONSchemaComposer) begin P.Typ('string').Pattern('^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$'); end)
         .RequiredFields(['age', 'role', 'email'])
         .AddProps(False);
      end)
    .Def('extendedContact', procedure(D: TJSONSchemaComposer)
      begin
        D.AllOf([
          FComposer.SubSchema(procedure(Sub: TJSONSchemaComposer) begin Sub.Add('$ref', '#/$defs/contact'); end),
          FComposer.SubSchema(procedure(Sub: TJSONSchemaComposer)
            begin
              Sub.Typ('object')
                .Prop('phone', procedure(P: TJSONSchemaComposer) begin P.Typ('string').Pattern('^\+?[1-9]\d{1,14}$'); end)
                .PatternProp('^custom-[a-z]+$', procedure(P: TJSONSchemaComposer) begin P.Typ('string'); end)
                .RequiredFields(['phone']);
            end)
        ]);
      end)
    .Def('contactOrString', procedure(D: TJSONSchemaComposer)
      begin
        D.OneOf([
          FComposer.SubSchema(procedure(Sub: TJSONSchemaComposer) begin Sub.Add('$ref', '#/$defs/extendedContact'); end),
          FComposer.SubSchema(procedure(Sub: TJSONSchemaComposer) begin Sub.Typ('string'); end)
        ]);
      end)
    .Prop('mainContact', procedure(P: TJSONSchemaComposer) begin P.Add('$ref', '#/$defs/contactOrString'); end)
    .Prop('contacts', procedure(P: TJSONSchemaComposer)
      begin
        P.Typ('array')
         .Items(FComposer.SubSchema(procedure(Sub: TJSONSchemaComposer) begin Sub.Add('$ref', '#/$defs/contactOrString'); end))
         .MinItems(1)
         .MaxItems(3);
      end)
    .RequiredFields(['mainContact'])
    .EndObj;

  LReader := TJsonReader.Create;
  try
    LJSONValid1 := LReader.Read('{"mainContact": {"age": 25, "role": "admin", "email": "user@example.com", "phone": "+123456789"}, "contacts": [{"age": 30, "role": "user", "email": "test@domain.com", "phone": "+987654321"}]}');
    LJSONValid2 := LReader.Read('{"mainContact": "simple string", "contacts": ["another string"]}');
    LJSONValid3 := LReader.Read('{"mainContact": {"age": 25, "role": "admin", "email": "user@example.com", "phone": "+123456789", "custom-note": "test"}, "contacts": ["another string"]}');
    LJSONInvalid1 := LReader.Read('{"mainContact": {"age": 25}, "contacts": [{"role": "user"}]}');
    LJSONInvalid2 := LReader.Read('{"mainContact": {"age": 25, "role": "admin", "email": "user@example.com", "phone": "+123456789", "extra": "string"}, "contacts": ["another string"]}');

    Writeln('JSON válido 1: ' + LJSONValid1.AsJSON);
    Writeln('JSON válido 2: ' + LJSONValid2.AsJSON);
    Writeln('JSON válido 3: ' + LJSONValid3.AsJSON);
    Writeln('JSON inválido 1: ' + LJSONInvalid1.AsJSON);
    Writeln('JSON inválido 2: ' + LJSONInvalid2.AsJSON);

    LValidator := TJSONSchemaValidator.Create(jsvDraft7);
    try
      LValidator.OnLog(procedure(AMessage: String)
      begin
        Writeln(AMessage);
      end);
      LValidator.ParseSchema(FComposer.ToElement);

      Writeln('Validando JSON válido 1...');
      LResult := LValidator.Validate(LJSONValid1, '');
      Writeln('Result (válido 1): ' + BoolToStr(LResult, True));
      if not LResult then
        for I := 0 to Length(LValidator.GetErrors) - 1 do
          Writeln('  Erro ' + IntToStr(I + 1) + ': ' + LValidator.GetErrors[I].Message);

      Writeln('Validando JSON válido 2...');
      LResult := LValidator.Validate(LJSONValid2, '');
      Writeln('Result (válido 2): ' + BoolToStr(LResult, True));
      if not LResult then
        for I := 0 to Length(LValidator.GetErrors) - 1 do
          Writeln('  Erro ' + IntToStr(I + 1) + ': ' + LValidator.GetErrors[I].Message);

      Writeln('Validando JSON válido 3...');
      LResult := LValidator.Validate(LJSONValid3, '');
      Writeln('Result (válido 3): ' + BoolToStr(LResult, True));
      if not LResult then
        for I := 0 to Length(LValidator.GetErrors) - 1 do
          Writeln('  Erro ' + IntToStr(I + 1) + ': ' + LValidator.GetErrors[I].Message);

      Writeln('Validando JSON inválido 1...');
      LResult := LValidator.Validate(LJSONInvalid1, '');
      Writeln('Result (inválido 1): ' + BoolToStr(LResult, True));
      if not LResult then
        for I := 0 to Length(LValidator.GetErrors) - 1 do
          Writeln('  Erro ' + IntToStr(I + 1) + ': ' + LValidator.GetErrors[I].Message);

      Writeln('Validando JSON inválido 2...');
      LResult := LValidator.Validate(LJSONInvalid2, '');
      Writeln('Result (inválido 2): ' + BoolToStr(LResult, True));
      if not LResult then
        for I := 0 to Length(LValidator.GetErrors) - 1 do
          Writeln('  Erro ' + IntToStr(I + 1) + ': ' + LValidator.GetErrors[I].Message);

      Writeln('Generated Schema: ' + FComposer.ToJSON(True, False));
    finally
      LValidator.Free;
    end;
  finally
    LReader.Free;
  end;
end;

procedure TJSONSmartSchemaComposerTests.TestGradualMetaSchemaBuildStep13;
var
  LJSONValid1, LJSONValid2, LJSONValid3, LJSONInvalid1: IJSONElement;
  LValidator: TJSONSchemaValidator;
  LResult: Boolean;
  LReader: TJsonReader;
  I: Integer;
begin
  Writeln('TestGradualMetaSchemaBuildStep13');
  FComposer.Obj
    .Typ('object')
    .Def('nonNegativeInteger', procedure(D: TJSONSchemaComposer)
      begin
        D.Typ('integer').Min(0);
      end)
    .Def('contact', procedure(D: TJSONSchemaComposer)
      begin
        D.Typ('object')
         .Prop('age', procedure(P: TJSONSchemaComposer)
           begin
             P.Add('$ref', '#/$defs/nonNegativeInteger');
           end)
         .Prop('role', procedure(P: TJSONSchemaComposer)
           begin
             P.Typ('string').Enum(['admin', 'user', 'guest']);
           end)
         .Prop('email', procedure(P: TJSONSchemaComposer)
           begin
             P.Typ('string').Pattern('^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
           end)
         .RequiredFields(['age', 'role', 'email']);
      end)
    .Def('extendedContact', procedure(D: TJSONSchemaComposer)
      begin
        D.AllOf([
          FComposer.SubSchema(procedure(Sub: TJSONSchemaComposer)
            begin
              Sub.Add('$ref', '#/$defs/contact');
            end),
          FComposer.SubSchema(procedure(Sub: TJSONSchemaComposer)
            begin
              Sub.Typ('object')
                .Prop('phone', procedure(P: TJSONSchemaComposer)
                  begin
                    P.Typ('string').Pattern('^\+?[1-9]\d{1,14}$');
                  end)
                .Prop('permissions', procedure(P: TJSONSchemaComposer)
                  begin
                    P.Typ('array').Items(FComposer.SubSchema(procedure(S: TJSONSchemaComposer)
                      begin
                        S.Typ('string');
                      end));
                  end)
                .RequiredFields(['phone'])
                .AddProps(True);
            end)
        ]);
      end)
    .Def('contactOrString', procedure(D: TJSONSchemaComposer)
      begin
        D.OneOf([
          FComposer.SubSchema(procedure(Sub: TJSONSchemaComposer)
            begin
              Sub.Add('$ref', '#/$defs/extendedContact');
            end),
          FComposer.SubSchema(procedure(Sub: TJSONSchemaComposer)
            begin
              Sub.Typ('string');
            end)
        ]);
      end)
    .Prop('mainContact', procedure(P: TJSONSchemaComposer)
      begin
        P.Add('$ref', '#/$defs/contactOrString');
      end)
    .Prop('contacts', procedure(P: TJSONSchemaComposer)
      begin
        P.Typ('array')
         .Items(FComposer.SubSchema(procedure(Sub: TJSONSchemaComposer)
           begin
             Sub.Add('$ref', '#/$defs/contactOrString');
           end))
         .MinItems(1)
         .MaxItems(3);
      end)
    .RequiredFields(['mainContact'])
    .EndObj;

  LReader := TJsonReader.Create;
  try
    LJSONValid1 := LReader.Read('{"mainContact":{"age":25,"role":"admin","email":"user@example.com","phone":"+123456789","permissions":["read","write"]},"contacts":[{"age":30,"role":"user","email":"test@domain.com","phone":"+987654321"}]}');
    LJSONValid2 := LReader.Read('{"mainContact":"simple string","contacts":["another string"]}');
    LJSONValid3 := LReader.Read('{"mainContact":{"age":25,"role":"user","email":"user@example.com","phone":"+123456789"},"contacts":["another string"]}');
    LJSONInvalid1 := LReader.Read('{"mainContact":{"age":25,"role":"admin","email":"user@example.com"},"contacts":["another string"]}');

    Writeln('JSON válido 1: ' + LJSONValid1.AsJSON);
    Writeln('JSON válido 2: ' + LJSONValid2.AsJSON);
    Writeln('JSON válido 3: ' + LJSONValid3.AsJSON);
    Writeln('JSON inválido 1: ' + LJSONInvalid1.AsJSON);

    LValidator := TJSONSchemaValidator.Create(jsvDraft7);
    try
      LValidator.OnLog(procedure(AMessage: String) begin Writeln(AMessage); end);
      LValidator.ParseSchema(FComposer.ToElement);

      Writeln('Validando JSON válido 1...');
      LResult := LValidator.Validate(LJSONValid1, '');
      Writeln('Result (válido 1): ' + BoolToStr(LResult, True));
      if not LResult then
        for I := 0 to Length(LValidator.GetErrors) - 1 do
          Writeln('  Erro ' + IntToStr(I + 1) + ': ' + LValidator.GetErrors[I].Message);

      Writeln('Validando JSON válido 2...');
      LResult := LValidator.Validate(LJSONValid2, '');
      Writeln('Result (válido 2): ' + BoolToStr(LResult, True));
      if not LResult then
        for I := 0 to Length(LValidator.GetErrors) - 1 do
          Writeln('  Erro ' + IntToStr(I + 1) + ': ' + LValidator.GetErrors[I].Message);

      Writeln('Validando JSON válido 3...');
      LResult := LValidator.Validate(LJSONValid3, '');
      Writeln('Result (válido 3): ' + BoolToStr(LResult, True));
      if not LResult then
        for I := 0 to Length(LValidator.GetErrors) - 1 do
          Writeln('  Erro ' + IntToStr(I + 1) + ': ' + LValidator.GetErrors[I].Message);

      Writeln('Validando JSON inválido 1...');
      LResult := LValidator.Validate(LJSONInvalid1, '');
      Writeln('Result (inválido 1): ' + BoolToStr(LResult, True));
      if not LResult then
        for I := 0 to Length(LValidator.GetErrors) - 1 do
          Writeln('  Erro ' + IntToStr(I + 1) + ': ' + LValidator.GetErrors[I].Message);

      Writeln('Generated Schema: ' + FComposer.ToJSON(True, False));
    finally
      LValidator.Free;
    end;
  finally
    LReader.Free;
  end;
end;

//procedure TJSONSmartSchemaComposerTests.TestValidateSimpleRefWithDefinitions;
//var
//  LJSONSchema, LValidJSON, LInvalidJSON: String;
//  LValidator: TJSONSchemaValidator;
//  LResult: Boolean;
//begin
//  Writeln('TestValidateSimpleRefWithDefinitions');
//  FComposer.Obj
//    .Def('contact', procedure(D: TJSONSchemaComposer) begin D.Typ('object').PropType('phone', 'string', True); end)
//    .Typ('object')
//    .Prop('mainContact', procedure(P: TJSONSchemaComposer) begin P.Add('$ref', '#/$defs/contact'); end)
//    .EndObj;
//
//  LJSONSchema := FComposer.ToJSON(False, False);
//  Writeln('Schema: ' + LJSONSchema);
//
////  LValidJSON := '{"mainContact": {"phone": "123-456"}}';
////  Writeln('Valid JSON: ' + LValidJSON);
////  LValidator := TJSONSchemaValidator.Create(jsvDraft7);
////  try
////    LResult := LValidator.Validate(LValidJSON, LJSONSchema);
////    if not LResult then
////      Writeln('Validation errors (valid): ' + TArray.ToString<TValidationError>(LValidator.GetErrors));
////    Assert.IsTrue(LResult, 'Valid JSON should pass validation');
////    Assert.AreEqual(0, Length(LValidator.GetErrors), 'No validation errors expected for valid JSON');
////  finally
////    LValidator.Free;
////  end;
//
//  LInvalidJSON := '{"mainContact": {}}';
//  Writeln('Invalid JSON: ' + LInvalidJSON);
//  LValidator := TJSONSchemaValidator.Create(jsvDraft7);
//  try
//    LResult := LValidator.Validate(LInvalidJSON, LJSONSchema);
//    if not LResult then
//      Writeln('Validation errors (invalid): ' + TArray.ToString<TValidationError>(LValidator.GetErrors));
//    Assert.IsFalse(LResult, 'Invalid JSON should fail validation');
//    Assert.IsTrue(Length(LValidator.GetErrors) > 0, 'Validation errors expected for invalid JSON');
//  finally
//    LValidator.Free;
//  end;
//end;

procedure TJSONSmartSchemaComposerTests.TestCommentInSchema;
var
  LJSONSchema: String;
begin
  Writeln('TestCommentInSchema');
  FComposer.Obj
    .Comment('Test comment')
    .Typ('string')
    .EndObj;

  LJSONSchema := FComposer.ToJSON;
  Writeln('Schema: ' + LJSONSchema);
  Assert.IsNotEmpty(LJSONSchema);
  Assert.Contains(LJSONSchema, '"$comment":"Test comment"');
end;

procedure TJSONSmartSchemaComposerTests.TestExamplesInSchema;
var
  LJSONSchema: String;
begin
  Writeln('TestExamplesInSchema');
  FComposer.Obj
    .Typ('string')
    .Add('examples', ['example1', 'example2']) // Garante array nativo
    .EndObj;

  LJSONSchema := FComposer.ToJSON;
  Writeln('Schema: ' + LJSONSchema);
  Assert.IsNotEmpty(LJSONSchema);
  Assert.Contains(LJSONSchema, '"examples":["example1","example2"]'); // Verifica array nativo
end;

procedure TJSONSmartSchemaComposerTests.TestSintaxSimple;
var
  LJSONSchema, LJSON: String;
  LValidator: TJSONSchemaValidator;
  LResult: Boolean;
begin
  Writeln('TestSintaxSimple');
  FComposer.Obj
    .Typ('object')
    .Prop('nome', procedure(P: TJSONSchemaComposer) begin P.Typ('string').Req('nome').MinLen(2).MaxLen(100); end)
    .Prop('idade', procedure(P: TJSONSchemaComposer) begin P.Typ('integer').Min(0).Max(150); end)
    .EndObj;

  LJSONSchema := FComposer.ToJSON;
  Writeln('Schema: ' + LJSONSchema);

  LJSON := '{"nome": "Isaque", "idade": 30}';
  Writeln('JSON: ' + LJSON);
  LValidator := TJSONSchemaValidator.Create(jsvDraft7);
  try
    LResult := LValidator.Validate(LJSON, LJSONSchema);
    if not LResult then
      Writeln('Validation errors: ' + TArray.ToString<TValidationError>(LValidator.GetErrors));
    Assert.IsTrue(LResult, 'Valid JSON should pass validation');
    Assert.AreEqual(0, Length(LValidator.GetErrors), 'No validation errors expected');
  finally
    LValidator.Free;
  end;
end;

procedure TJSONSmartSchemaComposerTests.TestValidateGeneratedSchemaAgainstMetaSchemaFluido;
var
  LGeneratedSchema: IJSONElement;
  LResult: Boolean;
begin
  Writeln('TestValidateGeneratedSchemaAgainstMetaSchemaFluido iniciado');
  Writeln('Construindo schema');
  FComposer.Obj
    .Typ('object')
    .PropType('type', 'string')
    .PropType('name', 'string')
    .PropType('id', 'integer')
    .Prop('status', procedure(P: TJSONSchemaComposer) begin P.Typ('string').Enum(['active', 'inactive']); end)
    .Prop('score', procedure(P: TJSONSchemaComposer) begin P.Typ('number').Min(0).Max(100).MultOf(5); end)
    .MinProps(1)
    .MaxProps(20)
    .AddProps(True, FComposer.SubSchema(procedure(S: TJSONSchemaComposer) begin S.Typ('string'); end)) // Ajustado pra schema
    .EndObj;

  Writeln('Schema construído, gerando JSON');
  LGeneratedSchema := FComposer.ToElement;
  Writeln('Schema: ' + LGeneratedSchema.AsJSON);
  Writeln('Validando schema');
  LResult := FValidator.Validate(LGeneratedSchema, '');
  if not LResult then
    Writeln('Validation errors: ' + TArray.ToString<TValidationError>(FValidator.GetErrors));
  Assert.IsTrue(LResult, 'Generated schema should be valid against meta-schema');
  Assert.AreEqual(0, Length(FValidator.GetErrors), 'No validation errors expected');
  Writeln('Teste concluído');
end;

end.

//unit jsonbr.tests.shema.composer;
//
//interface
//
//uses
//  Classes,
//  SysUtils,
//  IOUtils,
//  DUnitX.TestFramework,
//  jsonbr.schema.composer,
//  JsonFlow.SchemaValidator,
//  JsonFlow.Interfaces,
//  jsonbr.objects;
//
//type
//  [TestFixture]
//  TJSONSchemaComposerTests = class
//  private
//    FComposer: TJSONSchemaComposer;
//    FValidator: TJSONSchemaValidator;
//    FMetaSchema: IJSONElement;
//    FIsTearDown: Boolean;
//    procedure LoadMetaSchema;
//  public
//    [Setup]
//    procedure Setup;
//    [TearDown]
//    procedure TearDown;
//    [Test]
//    procedure TestBasicSchemaCreationWithClass;
//    [Test]
//    procedure TestBasicSchemaCreation;
//    [Test]
//    procedure TestInvalidSchemaGeneration;
//    [Test]
//    procedure TestSchemaWithMinimum;
//    [Test]
//    procedure TestEnum;
//    [Test]
//    procedure TestConst;
//    [Test]
//    procedure TestDefault;
//    [Test]
//    procedure TestTitleAndDescription;
//    [Test]
//    procedure TestStringValidations;
//    [Test]
//    procedure TestNumberValidations;
//    [Test]
//    procedure TestArrayValidations;
//    [Test]
//    procedure TestObjectValidations;
//    [Test]
//    procedure TestConditionalIfThenElse;
//    [Test]
//    procedure TestCombinationsAllOf;
//    [Test]
//    procedure TestCombinationsAnyOf;
//    [Test]
//    procedure TestCombinationsOneOf;
//    [Test]
//    procedure TestCombinationsNot;
//    [Test]
//    procedure TestDefinitionsAndRef;
//    [Test]
//    procedure TestValidateGeneratedSchemaAgainstMetaSchema;
//    [Test]
//    procedure TestValidateJSONAgainstGeneratedSchema;
//    [Test]
//    procedure TestValidateJSONAgainstGeneratedSchemaString;
//    [Test]
//    procedure TestValidateTypeString;
//    [Test]
//    procedure TestValidateRequiredString;
//    [Test]
//    procedure TestValidateMinLengthString;
//    [Test]
//    procedure TestValidateMaxLengthString;
//    [Test]
//    procedure TestValidatePatternString;
//    [Test]
//    procedure TestValidateEnumString;
//    [Test]
//    procedure TestValidateFormatEmail;
//    [Test]
//    procedure TestValidateMinimumNumber;
//    [Test]
//    procedure TestValidateMaximumNumber;
//    [Test]
//    procedure TestValidateMultipleOfNumber;
//    [Test]
//    procedure TestValidateExclusiveMaximumNumber;
//    [Test]
//    procedure TestValidateExclusiveMinimumNumber;
//    [Test]
//    procedure TestValidateMinItems;
//    [Test]
//    procedure TestValidateMaxItems;
//    [Test]
//    procedure TestValidateJSONAgainstGeneratedSchemaIsolated;
//    [Test]
//    procedure TestValidateSimpleRefWithDefinitions;
//    [Test]
//    procedure TestCommentInSchema;
//    [Test]
//    procedure TestExamplesInSchema;
//    [Test]
//    procedure TestSintaxSimple;
//    [Test]
//    procedure TestValidateGeneratedSchemaAgainstMetaSchemaFluido;
//  end;
//
//implementation
//
//uses
//  JsonFlow.Reader,
//  JsonFlow.Value;
//
//procedure TJSONSchemaComposerTests.Setup;
//var
//  LReader: TJsonReader;
//begin
//  FComposer := TJSONSchemaComposer.Create;
//  FValidator := TJSONSchemaValidator.Create(jsvDraft7);
//  FIsTearDown := False;
//  FComposer.OnLog(procedure(AMessage: String)
//  begin
//    Writeln(AMessage);
//    if FIsTearDown then
//      Writeln('Destroy called from TearDown');
//  end);
//  FValidator.OnLog(procedure(AMessage: String)
//  begin
//    Writeln(AMessage);
//    if FIsTearDown then
//      Writeln('Destroy called from TearDown');
//  end);
//  LoadMetaSchema;
//end;
//
//procedure TJSONSchemaComposerTests.TearDown;
//begin
//  FIsTearDown := True;
//  FComposer.Free;
//  FValidator.Free;
//end;
//
//procedure TJSONSchemaComposerTests.LoadMetaSchema;
//var
//  LReader: TJsonReader;
//  LSchemaText: String;
//begin
//  LReader := TJsonReader.Create;
//  try
//    LSchemaText := TFile.ReadAllText('json-schema.json');
//    FMetaSchema := LReader.Read(LSchemaText);
//    FValidator.ParseSchema(FMetaSchema);
//  finally
//    LReader.Free;
//  end;
//end;
//
//procedure TJSONSchemaComposerTests.TestBasicSchemaCreationWithClass;
//var
//  LJSONSchema: String;
//  LocalComposer: TJSONSchemaComposer;
//  TempComposer: TJSONSchemaComposer;
//begin
//  FComposer.Obj
//    .Typ('object')
//    .PropType('name', 'string', True)
//    .PropType('age', 'integer')
//    .EndObj;
//
//  LJSONSchema := FComposer.ToJSON(True, False); // Evitar limpar FComposer
//  Assert.IsNotEmpty(LJSONSchema, 'JSON Schema should not be empty');
//  Assert.Contains(LJSONSchema, '"type": "object"', 'Schema should have type "object"');
//  Assert.Contains(LJSONSchema, '"name":', 'Schema should have property "name"');
//  Assert.Contains(LJSONSchema, '"type": "string"', 'Schema should define name as string');
//  Assert.Contains(LJSONSchema, '"age":', 'Schema should have property "age"');
//  Assert.Contains(LJSONSchema, '"type": "integer"', 'Schema should define age as integer');
//  Assert.Contains(LJSONSchema, '"required":', 'Schema should have "required"');
//  Assert.Contains(LJSONSchema, '"name"', 'Schema should have "name" in required');
//
//  LocalComposer := TJSONSchemaComposer.Create;
//  try
//    LocalComposer.Obj
//      .Typ('object')
//      .PropType('name', 'string', True)
//      .PropType('age', 'integer')
//      .EndObj;
//
//    LJSONSchema := LocalComposer.ToJSON(True);
//    Assert.IsNotEmpty(LJSONSchema, 'JSON Schema should not be empty');
//    Assert.Contains(LJSONSchema, '"type": "object"', 'Schema should have type "object"');
//    Assert.Contains(LJSONSchema, '"name":', 'Schema should have property "name"');
//    Assert.Contains(LJSONSchema, '"type": "string"', 'Schema should define name as string');
//    Assert.Contains(LJSONSchema, '"age":', 'Schema should have property "age"');
//    Assert.Contains(LJSONSchema, '"type": "integer"', 'Schema should define age as integer');
//    Assert.Contains(LJSONSchema, '"required":', 'Schema should have "required"');
//    Assert.Contains(LJSONSchema, '"name"', 'Schema should have "name" in required');
//  finally
//    LocalComposer.Free;
//  end;
//
//  TempComposer := TJSONSchemaComposer.Create;
//  try
//    TempComposer.Obj
//      .Typ('object')
//      .PropType('test', 'string')
//      .EndObj;
//    TempComposer.ToJSON(True);
//  finally
//    TempComposer.Free;
//  end;
//end;
//
//procedure TJSONSchemaComposerTests.TestBasicSchemaCreation;
//var
//  LJSONSchema: String;
//  LBuilder: TJSONSchemaComposer;
//begin
//  LBuilder := TJSONSchemaComposer.Create;
//  LBuilder.Obj
//    .Typ('object')
//    .PropType('name', 'string', True)
//    .PropType('age', 'integer')
//    .EndObj;
//
//  LJSONSchema := LBuilder.ToJSON(True);
//  Assert.IsNotEmpty(LJSONSchema, 'JSON Schema should not be empty');
//  Assert.Contains(LJSONSchema, '"type": "object"', 'Schema should have type "object"');
//  Assert.Contains(LJSONSchema, '"name":', 'Schema should have property "name"');
//  Assert.Contains(LJSONSchema, '"type": "string"', 'Schema should define name as string');
//  Assert.Contains(LJSONSchema, '"age":', 'Schema should have property "age"');
//  Assert.Contains(LJSONSchema, '"type": "integer"', 'Schema should define age as integer');
//  Assert.Contains(LJSONSchema, '"required":', 'Schema should have "required"');
//  Assert.Contains(LJSONSchema, '"name"', 'Schema should have "name" in required');
//
//  LBuilder.Free;
//end;
//
//procedure TJSONSchemaComposerTests.TestInvalidSchemaGeneration;
//var
//  LJSONSchema: String;
//  LBuilder: TJSONSchemaComposer;
//begin
//  LBuilder := TJSONSchemaComposer.Create;
//  LBuilder.Obj
//    .PropType('name', 'string', True)
//    .EndObj;
//
//  LJSONSchema := LBuilder.ToJSON(True);
//  Assert.IsNotEmpty(LJSONSchema, 'JSON Schema should not be empty');
//  Assert.IsFalse(LJSONSchema.Contains('"type": "object"'), 'Schema should not have type "object" at root');
//  Assert.Contains(LJSONSchema, '"name":', 'Schema should have property "name"');
//  Assert.Contains(LJSONSchema, '"required":', 'Schema should have "required"');
//  Assert.Contains(LJSONSchema, '"name"', 'Schema should have "name" in required');
//
//  LBuilder.Free;
//end;
//
//procedure TJSONSchemaComposerTests.TestSchemaWithMinimum;
//var
//  LJSONSchema: String;
//  LBuilder: TJSONSchemaComposer;
//begin
//  LBuilder := TJSONSchemaComposer.Create;
//  LBuilder.Obj
//    .Typ('object')
//    .Prop('age', procedure(P: TJSONSchemaComposer)
//      begin
//        P.Typ('integer')
//         .Min(0);
//      end)
//    .EndObj;
//
//  LJSONSchema := LBuilder.ToJSON(True);
//  Assert.IsNotEmpty(LJSONSchema, 'JSON Schema should not be empty');
//  Assert.Contains(LJSONSchema, '"type": "object"', 'Schema should have type "object"');
//  Assert.Contains(LJSONSchema, '"age":', 'Schema should have property "age"');
//  Assert.Contains(LJSONSchema, '"type": "integer"', 'Schema should define age as integer');
//  Assert.Contains(LJSONSchema, '"minimum": 0', 'Schema should have minimum 0');
//
//  LBuilder.Free;
//end;
//
//procedure TJSONSchemaComposerTests.TestSintaxSimple;
//var
//  Schema: TJSONSchemaComposer;
//  EmailSchema: TJSONSchemaComposer;
//  JSONString: String;
//  Errors: TArray<String>;
//begin
//  Schema := TJSONSchemaComposer.Create;
//  try
//    Schema.Schema(procedure(S: TJSONSchemaComposer)
//    begin
//      S.Typ('object')
//       .Prop('nome', procedure(P: TJSONSchemaComposer)
//         begin
//           P.Typ('string')
//            .Req('nome')
//            .MinLen(2)
//            .MaxLen(100);
//         end)
//       .Prop('idade', procedure(P: TJSONSchemaComposer)
//         begin
//           P.Typ('integer')
//            .Min(0)
//            .Max(150);
//         end);
//    end)
//    .EndObj; // Fecha o objeto raiz aberto por Schema
//
//    JSONString := '{"nome": "Isaque", "idade": 30}';
//    WriteLn('Parsing JSON: "' + JSONString + '"');
//    WriteLn('Length of JSON: ' + Length(JSONString).ToString);
//    Assert.IsTrue(Schema.Validate(JSONString, Errors), 'JSON válido deve passar');
//    if Length(Errors) > 0 then
//      WriteLn('Erros: ' + string.Join(', ', Errors))
//    else
//      WriteLn('JSON Válido');
//  finally
//    Schema.Free;
//  end;
//
//  EmailSchema := TJSONSchemaComposer.Create;
//  try
//    EmailSchema.Obj
//      .PropType('email', 'string', True)
//      .Format('email')
//      .EndObj;
//
//    WriteLn('Schema gerado: ' + EmailSchema.ToJSON(True));
//  finally
//    EmailSchema.Free;
//  end;
//end;
//
//procedure TJSONSchemaComposerTests.TestEnum;
//var
//  LJSONSchema: String;
//  LBuilder: TJSONSchemaComposer;
//begin
//  LBuilder := TJSONSchemaComposer.Create;
//  LBuilder.Obj
//    .Typ('string')
//    .Enum(['red', 'blue', 'green'])
//    .EndObj;
//
//  LJSONSchema := LBuilder.ToJSON(False);
//  Assert.IsNotEmpty(LJSONSchema, 'JSON Schema should not be empty');
//  Assert.Contains(LJSONSchema, '"type":"string"', 'Schema should have type "string"');
//  Assert.Contains(LJSONSchema, '"enum":["red","blue","green"]', 'Schema should have enum');
//
//  LBuilder.Free;
//end;
//
//procedure TJSONSchemaComposerTests.TestConst;
//var
//  LJSONSchema: String;
//  LBuilder: TJSONSchemaComposer;
//begin
//  LBuilder := TJSONSchemaComposer.Create;
//  try
//    LBuilder.Obj
//      .Typ('integer')
//      .Cst(42)
//      .EndObj;
//
//    LJSONSchema := LBuilder.ToJSON(True);
//    Assert.IsNotEmpty(LJSONSchema, 'JSON Schema should not be empty');
//    Assert.Contains(LJSONSchema, '"type": "integer"', 'Schema should have type "integer"');
//    Assert.Contains(LJSONSchema, '"const": 42', 'Schema should have const as integer');
//    // Adicionar verificação mais robusta
//    Assert.IsTrue(Pos('"const": 42', LJSONSchema) > 0, 'Schema should have const as integer without quotes');
//  finally
//    LBuilder.Free;
//  end;
//end;
//
//procedure TJSONSchemaComposerTests.TestDefault;
//var
//  LJSONSchema: String;
//  LBuilder: TJSONSchemaComposer;
//begin
//  LBuilder := TJSONSchemaComposer.Create;
//  LBuilder.Obj
//    .Typ('string')
//    .Default('unknown')
//    .EndObj;
//
//  LJSONSchema := LBuilder.ToJSON(True);
//  Assert.IsNotEmpty(LJSONSchema, 'JSON Schema should not be empty');
//  Assert.Contains(LJSONSchema, '"type": "string"', 'Schema should have type "string"');
//  Assert.Contains(LJSONSchema, '"default": "unknown"', 'Schema should have default');
//
//  LBuilder.Free;
//end;
//
//procedure TJSONSchemaComposerTests.TestTitleAndDescription;
//var
//  LJSONSchema: String;
//  LBuilder: TJSONSchemaComposer;
//begin
//  LBuilder := TJSONSchemaComposer.Create;
//  LBuilder.Obj
//    .Typ('object')
//    .Title('Person Schema')
//    .Desc('A schema for representing a person')
//    .PropType('name', 'string')
//    .EndObj;
//
//  LJSONSchema := LBuilder.ToJSON(True);
//  Assert.IsNotEmpty(LJSONSchema, 'JSON Schema should not be empty');
//  Assert.Contains(LJSONSchema, '"type": "object"', 'Schema should have type "object"');
//  Assert.Contains(LJSONSchema, '"title": "Person Schema"', 'Schema should have title');
//  Assert.Contains(LJSONSchema, '"description": "A schema for representing a person"', 'Schema should have description');
//  Assert.Contains(LJSONSchema, '"name":', 'Schema should have property "name"');
//
//  LBuilder.Free;
//end;
//
//procedure TJSONSchemaComposerTests.TestStringValidations;
//var
//  LJSONSchema: String;
//  LBuilder: TJSONSchemaComposer;
//begin
//  LBuilder := TJSONSchemaComposer.Create;
//  LBuilder.Obj
//    .Typ('string')
//    .MinLen(3)
//    .MaxLen(10)
//    .Pattern('^[A-Za-z]+$')
//    .EndObj;
//
//  LJSONSchema := LBuilder.ToJSON(True);
//  Assert.IsNotEmpty(LJSONSchema, 'JSON Schema should not be empty');
//  Assert.Contains(LJSONSchema, '"type": "string"', 'Schema should have type "string"');
//  Assert.Contains(LJSONSchema, '"minLength": 3', 'Schema should have minLength');
//  Assert.Contains(LJSONSchema, '"maxLength": 10', 'Schema should have maxLength');
//  Assert.Contains(LJSONSchema, '"pattern": "^[A-Za-z]+$"', 'Schema should have pattern');
//
//  LBuilder.Free;
//end;
//
//procedure TJSONSchemaComposerTests.TestNumberValidations;
//var
//  LJSONSchema: String;
//  LBuilder: TJSONSchemaComposer;
//begin
//  LBuilder := TJSONSchemaComposer.Create;
//  LBuilder.Obj
//    .Typ('number')
//    .Min(0)
//    .Max(100)
//    .ExclMin(1)
//    .ExclMax(99)
//    .MultOf(5)
//    .EndObj;
//
//  LJSONSchema := LBuilder.ToJSON(True);
//  Assert.IsNotEmpty(LJSONSchema, 'JSON Schema should not be empty');
//  Assert.Contains(LJSONSchema, '"type": "number"', 'Schema should have type "number"');
//  Assert.Contains(LJSONSchema, '"minimum": 0', 'Schema should have minimum');
//  Assert.Contains(LJSONSchema, '"maximum": 100', 'Schema should have maximum');
//  Assert.Contains(LJSONSchema, '"exclusiveMinimum": 1', 'Schema should have exclusiveMinimum');
//  Assert.Contains(LJSONSchema, '"exclusiveMaximum": 99', 'Schema should have exclusiveMaximum');
//  Assert.Contains(LJSONSchema, '"multipleOf": 5', 'Schema should have multipleOf');
//
//  LBuilder.Free;
//end;
//
//procedure TJSONSchemaComposerTests.TestArrayValidations;
//var
//  LJSONSchema: String;
//  LBuilder: TJSONSchemaComposer;
//begin
//  LBuilder := TJSONSchemaComposer.Create;
//  try
//    LBuilder.Obj
//      .Typ('array')
//      .Items(LBuilder.SubSchema(procedure(I: TJSONSchemaComposer)
//        begin
//          I.Typ('string')
//           .MinLen(2);
//        end))
//      .MinItems(1)
//      .MaxItems(5)
//      .Unique(True)
//      .EndObj;
//
//    LJSONSchema := LBuilder.ToJSON(True);
//    Assert.IsNotEmpty(LJSONSchema, 'JSON Schema should not be empty');
//    Assert.Contains(LJSONSchema, '"type": "array"', 'Schema should have type "array"');
//    Assert.Contains(LJSONSchema, '"items": {', 'Schema should have items');
//    Assert.Contains(LJSONSchema, '"type": "string"', 'Items should have type "string"');
//    Assert.Contains(LJSONSchema, '"minLength": 2', 'Items should have minLength');
//    Assert.Contains(LJSONSchema, '"minItems": 1', 'Schema should have minItems');
//    Assert.Contains(LJSONSchema, '"maxItems": 5', 'Schema should have maxItems');
//    Assert.Contains(LJSONSchema, '"uniqueItems": true', 'Schema should have uniqueItems');
//  finally
//    LBuilder.Free;
//  end;
//end;
//
//procedure TJSONSchemaComposerTests.TestObjectValidations;
//var
//  LJSONSchema: String;
//  LBuilder: TJSONSchemaComposer;
//begin
//  LBuilder := TJSONSchemaComposer.Create;
//  try
//    LBuilder.Obj
//      .Typ('object')
//      .PropType('name', 'string')
//      .MinProps(1)
//      .MaxProps(3)
//      .AddProps(True, LBuilder.SubSchema(procedure(S: TJSONSchemaComposer)
//        begin
//          S.Typ('string')
//           .MaxLen(20);
//        end))
//      .EndObj;
//
//    LJSONSchema := LBuilder.ToJSON(True);
//    Assert.IsNotEmpty(LJSONSchema, 'JSON Schema should not be empty');
//    Assert.Contains(LJSONSchema, '"type": "object"', 'Schema should have type "object"');
//    Assert.Contains(LJSONSchema, '"minProperties": 1', 'Schema should have minProperties');
//    Assert.Contains(LJSONSchema, '"maxProperties": 3', 'Schema should have maxProperties');
//    Assert.Contains(LJSONSchema, '"additionalProperties": {', 'Schema should have additionalProperties');
//    Assert.Contains(LJSONSchema, '"type": "string"', 'AdditionalProperties should have type "string"');
//    Assert.Contains(LJSONSchema, '"maxLength": 20', 'AdditionalProperties should have maxLength');
//  finally
//    LBuilder.Free;
//  end;
//end;
//
//procedure TJSONSchemaComposerTests.TestConditionalIfThenElse;
//var
//  LJSONSchema: String;
//  LBuilder: TJSONSchemaComposer;
//begin
//  LBuilder := TJSONSchemaComposer.Create;
//  try
//    LBuilder.Obj
//      .Typ('object')
//      .PropType('type', 'string')
//      .PropType('name', 'string')
//      .PropType('id', 'integer')
//      .IfThen(LBuilder.SubSchema(procedure(I: TJSONSchemaComposer)
//        begin
//          I.PropType('type', 'string')
//           .Cst('person');
//        end))
//      .Thn(LBuilder.SubSchema(procedure(T: TJSONSchemaComposer)
//        begin
//          T.PropType('name', 'string', True);
//        end))
//      .Els(LBuilder.SubSchema(procedure(E: TJSONSchemaComposer)
//        begin
//          E.PropType('id', 'integer', True);
//        end))
//      .EndObj;
//
//    LJSONSchema := LBuilder.ToJSON(True);
//    Assert.IsNotEmpty(LJSONSchema, 'JSON Schema should not be empty');
//    Assert.Contains(LJSONSchema, '"type": "object"', 'Schema should have type "object"');
//    Assert.Contains(LJSONSchema, '"if": {', 'Schema should have if');
//    Assert.Contains(LJSONSchema, '"type": "string"', 'If schema should have type "string"');
//    Assert.Contains(LJSONSchema, '"const": "person"', 'If schema should have const');
//    Assert.Contains(LJSONSchema, '"then": {', 'Schema should have then');
//    Assert.Contains(LJSONSchema, '"name": {', 'Then schema should have name property');
//    Assert.Contains(LJSONSchema, '"else": {', 'Schema should have else');
//    Assert.Contains(LJSONSchema, '"id": {', 'Else schema should have id property');
//  finally
//    LBuilder.Free;
//  end;
//end;
//
//procedure TJSONSchemaComposerTests.TestCombinationsAllOf;
//var
//  LJSONSchema: String;
//  LBuilder: TJSONSchemaComposer;
//begin
//  LBuilder := TJSONSchemaComposer.Create;
//  try
//    LBuilder.Obj
//      .AllOf([LBuilder.SubSchema(procedure(S1: TJSONSchemaComposer)
//               begin
//                 S1.Typ('string')
//                   .MinLen(3);
//               end),
//              LBuilder.SubSchema(procedure(S2: TJSONSchemaComposer)
//               begin
//                 S2.MaxLen(10);
//               end)])
//      .EndObj;
//
//    LJSONSchema := LBuilder.ToJSON(True);
//    Assert.IsNotEmpty(LJSONSchema, 'JSON Schema should not be empty');
//    Assert.Contains(LJSONSchema, '"allOf": [', 'Schema should have allOf');
//    Assert.Contains(LJSONSchema, '"type": "string"', 'First schema should have type "string"');
//    Assert.Contains(LJSONSchema, '"minLength": 3', 'First schema should have minLength');
//    Assert.Contains(LJSONSchema, '"maxLength": 10', 'Second schema should have maxLength');
//  finally
//    LBuilder.Free;
//  end;
//end;
//
//procedure TJSONSchemaComposerTests.TestCombinationsAnyOf;
//var
//  LJSONSchema: String;
//  LBuilder: TJSONSchemaComposer;
//begin
//  LBuilder := TJSONSchemaComposer.Create;
//  try
//    LBuilder.Obj
//      .AnyOf([LBuilder.SubSchema(procedure(S1: TJSONSchemaComposer)
//               begin
//                 S1.Typ('string');
//               end),
//              LBuilder.SubSchema(procedure(S2: TJSONSchemaComposer)
//               begin
//                 S2.Typ('number');
//               end)])
//      .EndObj;
//
//    LJSONSchema := LBuilder.ToJSON(True);
//    Assert.IsNotEmpty(LJSONSchema, 'JSON Schema should not be empty');
//    Assert.Contains(LJSONSchema, '"anyOf": [', 'Schema should have anyOf');
//    Assert.Contains(LJSONSchema, '"type": "string"', 'First schema should have type "string"');
//    Assert.Contains(LJSONSchema, '"type": "number"', 'Second schema should have type "number"');
//  finally
//    LBuilder.Free;
//  end;
//end;
//
//procedure TJSONSchemaComposerTests.TestCombinationsOneOf;
//var
//  LJSONSchema: String;
//  LBuilder: TJSONSchemaComposer;
//begin
//  LBuilder := TJSONSchemaComposer.Create;
//  try
//    LBuilder.Obj
//      .OneOf([LBuilder.SubSchema(procedure(S1: TJSONSchemaComposer)
//               begin
//                 S1.Typ('string')
//                   .MinLen(5);
//               end),
//              LBuilder.SubSchema(procedure(S2: TJSONSchemaComposer)
//               begin
//                 S2.Typ('string')
//                   .MaxLen(3);
//               end)])
//      .EndObj;
//
//    LJSONSchema := LBuilder.ToJSON(True);
//    Assert.IsNotEmpty(LJSONSchema, 'JSON Schema should not be empty');
//    Assert.Contains(LJSONSchema, '"oneOf": [', 'Schema should have oneOf');
//    Assert.Contains(LJSONSchema, '"type": "string"', 'First schema should have type "string"');
//    Assert.Contains(LJSONSchema, '"minLength": 5', 'First schema should have minLength');
//    Assert.Contains(LJSONSchema, '"maxLength": 3', 'Second schema should have maxLength');
//  finally
//    LBuilder.Free;
//  end;
//end;
//
//procedure TJSONSchemaComposerTests.TestCombinationsNot;
//var
//  LJSONSchema: String;
//  LBuilder: TJSONSchemaComposer;
//begin
//  LBuilder := TJSONSchemaComposer.Create;
//  try
//    LBuilder.Obj
//      .Typ('string')
//      .Neg(LBuilder.SubSchema(procedure(N: TJSONSchemaComposer)
//        begin
//          N.Typ('string')
//           .Pattern('^admin');
//        end))
//      .EndObj;
//
//    LJSONSchema := LBuilder.ToJSON(True);
//    Assert.IsNotEmpty(LJSONSchema, 'JSON Schema should not be empty');
//    Assert.Contains(LJSONSchema, '"type": "string"', 'Schema should have type "string"');
//    Assert.Contains(LJSONSchema, '"not": {', 'Schema should have not');
//    Assert.Contains(LJSONSchema, '"type": "string"', 'Not schema should have type "string"');
//    Assert.Contains(LJSONSchema, '"pattern": "^admin"', 'Not schema should have pattern');
//  finally
//    LBuilder.Free;
//  end;
//end;
//
//procedure TJSONSchemaComposerTests.TestDefinitionsAndRef;
//var
//  LJSONSchema: String;
//  LBuilder: TJSONSchemaComposer;
//begin
//  LBuilder := TJSONSchemaComposer.Create;
//  try
//    LBuilder.Obj
//      .Def('address', procedure(D: TJSONSchemaComposer)
//        begin
//          D.Typ('object')
//           .PropType('street', 'string')
//           .PropType('city', 'string');
//        end)
//      .Typ('object')
//      .Prop('homeAddress', procedure(P: TJSONSchemaComposer)
//        begin
//          P.Ref('#/$defs/address');
//        end)
//      .EndObj;
//
//    LJSONSchema := LBuilder.ToJSON(True);
//    Assert.IsNotEmpty(LJSONSchema, 'JSON Schema should not be empty');
//    Assert.Contains(LJSONSchema, '"$defs": {', 'Schema should have $defs');
//    Assert.Contains(LJSONSchema, '"address": {', 'Schema should have address definition');
//    Assert.Contains(LJSONSchema, '"type": "object"', 'Address definition should have type "object"');
//    Assert.Contains(LJSONSchema, '"street": {', 'Address definition should have street property');
//    Assert.Contains(LJSONSchema, '"city": {', 'Address definition should have city property');
//    Assert.Contains(LJSONSchema, '"homeAddress": {', 'Schema should have homeAddress property');
//    Assert.Contains(LJSONSchema, '"$ref": "#/$defs/address"', 'homeAddress should reference address definition');
//  finally
//    LBuilder.Free;
//  end;
//end;
//
//procedure TJSONSchemaComposerTests.TestValidateGeneratedSchemaAgainstMetaSchema;
//var
//  LSchemaValidator: TJSONSchemaValidator;
//  LBuilder: TJSONSchemaComposer;
//  LGeneratedSchema: IJSONElement;
//  LResult: Boolean;
//begin
//  LBuilder := TJSONSchemaComposer.Create;
//  try
//    LBuilder.Obj
//      .Def('address', procedure(D: TJSONSchemaComposer)
//        begin
//          D.Typ('object')
//           .PropType('street', 'string')
//           .PropType('city', 'string');
//        end)
//      .Typ('object')
//      .Prop('homeAddress', procedure(P: TJSONSchemaComposer)
//        begin
//          P.Ref('#/$defs/address');
//        end)
//      .PropType('type', 'string')
//      .PropType('name', 'string')
//      .PropType('id', 'integer')
//      .IfThen(LBuilder.SubSchema(procedure(I: TJSONSchemaComposer)
//        begin
//          I.PropType('type', 'string')
//           .Cst('person');
//        end))
//      .Thn(LBuilder.SubSchema(procedure(T: TJSONSchemaComposer)
//        begin
//          T.PropType('name', 'string', True);
//        end))
//      .Els(LBuilder.SubSchema(procedure(E: TJSONSchemaComposer)
//        begin
//          E.PropType('id', 'integer', True);
//        end))
//      .Prop('status', procedure(P: TJSONSchemaComposer)
//        begin
//          P.Typ('string')
//           .Enum(['active', 'inactive']);
//        end)
//      .Prop('score', procedure(P: TJSONSchemaComposer)
//        begin
//          P.Typ('number')
//           .Min(0)
//           .Max(100)
//           .MultOf(5);
//        end)
//      .Prop('tags', procedure(P: TJSONSchemaComposer)
//        begin
//          P.Typ('array')
//           .Items(LBuilder.SubSchema(procedure(I: TJSONSchemaComposer)
//             begin
//               I.Typ('string')
//                .MinLen(3);
//             end))
//           .MinItems(1)
//           .MaxItems(5)
//           .Unique(True);
//        end)
//      .MinProps(1)
//      .MaxProps(10)
//      .AddProps(False)
//      .AllOf([LBuilder.SubSchema(procedure(A1: TJSONSchemaComposer)
//               begin
//                 A1.Typ('string')
//                   .MinLen(3);
//               end),
//              LBuilder.SubSchema(procedure(A2: TJSONSchemaComposer)
//               begin
//                 A2.MaxLen(10);
//               end)])
//      .AnyOf([LBuilder.SubSchema(procedure(A1: TJSONSchemaComposer)
//               begin
//                 A1.Typ('string')
//                   .MinLen(3);
//               end),
//              LBuilder.SubSchema(procedure(A2: TJSONSchemaComposer)
//               begin
//                 A2.MaxLen(10);
//               end)])
//      .OneOf([LBuilder.SubSchema(procedure(O1: TJSONSchemaComposer)
//               begin
//                 O1.Typ('string')
//                   .MinLen(3);
//               end),
//              LBuilder.SubSchema(procedure(O2: TJSONSchemaComposer)
//               begin
//                 O2.MaxLen(10);
//               end)])
//      .Neg(LBuilder.SubSchema(procedure(N: TJSONSchemaComposer)
//        begin
//          N.Typ('string')
//           .Pattern('^admin');
//        end))
//      .EndObj;
//
//    LGeneratedSchema := LBuilder.ToElement;
//
//    LSchemaValidator := TJSONSchemaValidator.Create(jsvDraft7);
//    try
//      if not Assigned(FMetaSchema) then
//        raise EAssertionFailed.Create('FMetaSchema não está atribuído');
//      Writeln('FMetaSchema: ' + FMetaSchema.AsJSON);
//      Writeln('Generated Schema: ' + LGeneratedSchema.AsJSON);
//      LSchemaValidator.ParseSchema(FMetaSchema);
//      LResult := LSchemaValidator.Validate(LGeneratedSchema, '');
//      Assert.IsTrue(LResult, 'O schema gerado deve ser válido contra o meta-schema');
//      Assert.AreEqual(0, Length(LSchemaValidator.GetErrors), 'Nenhum erro de validação esperado');
//    finally
//      LSchemaValidator.Free;
//    end;
//  finally
//    LBuilder.Free;
//  end;
//end;
//
//procedure TJSONSchemaComposerTests.TestValidateJSONAgainstGeneratedSchema;
//var
//  LSchemaValidator: TJSONSchemaValidator;
//  LBuilder: TJSONSchemaComposer;
//  LAddressSchema: TJSONSchemaComposer;
//  LGeneratedSchema: IJSONElement;
//  LValidJSON, LInvalidJSON: IJSONElement;
//  LReader: TJsonReader;
//  LResult: Boolean;
//  LErrors: TArray<TValidationError>;
//  I: Integer;
//begin
//  LBuilder := TJSONSchemaComposer.Create;
//  try
//    LAddressSchema := TJSONSchemaComposer.Create;
//    try
//      LAddressSchema.Obj
//        .Typ('object')
//        .PropType('street', 'string', True)
//        .PropType('city', 'string', True)
//        .EndObj;
//
//      LBuilder.Obj
//        .Typ('object')
//        .DefSchema('address', LAddressSchema.ToElement)  // Corrigido: Passa IJSONElement
//        .PropType('type', 'string', True)
//        .PropType('name', 'string')
//        .PropType('status', 'string')
//        .Prop('score', procedure(P: TJSONSchemaComposer)
//          begin
//            P.Typ('number')
//             .Min(0)
//             .Max(100);
//          end)
//        .PropType('tags', 'array')
//        .PropRef('homeAddress', '#/$defs/address')
//        .AddProps(False)
//        .EndObj;
//
//      LGeneratedSchema := LBuilder.ToElement;
//
//      LReader := TJsonReader.Create;
//      try
//        LValidJSON := LReader.Read(
//          '{"homeAddress": {"street": "Main St", "city": "New York"}, ' +
//          '"type": "person", "name": "João", "status": "active", ' +
//          '"score": 50, "tags": ["abc", "def"]}'
//        );
//
//        LInvalidJSON := LReader.Read(
//          '{"homeAddress": {"street": 123}, "type": "person", ' +
//          '"status": "invalid", "score": 150, "tags": ["ab", "ab"], "extra": "field"}'
//        );
//
//        LSchemaValidator := TJSONSchemaValidator.Create(jsvDraft7);
//        try
//          Writeln('Schema gerado: ' + LGeneratedSchema.AsJSON);
//          LSchemaValidator.ParseSchema(LGeneratedSchema);
//          LResult := LSchemaValidator.Validate(LValidJSON, '');
//          Assert.IsTrue(LResult, 'Valid JSON should pass validation');
//          Assert.AreEqual(0, Length(LSchemaValidator.GetErrors), 'No validation errors expected for valid JSON');
//        finally
//          LSchemaValidator.Free;
//        end;
//
//        LSchemaValidator := TJSONSchemaValidator.Create(jsvDraft7);
//        try
//          LSchemaValidator.ParseSchema(LGeneratedSchema);
//          LResult := LSchemaValidator.Validate(LInvalidJSON, '');
//          Assert.IsFalse(LResult, 'Invalid JSON should fail validation');
//          LErrors := LSchemaValidator.GetErrors;
//          Assert.IsTrue(Length(LErrors) > 0, 'Validation errors expected for invalid JSON');
//          for I := 0 to Length(LErrors) - 1 do
//            Writeln('Erro: ' + LErrors[I].Message + ' no caminho: ' + LErrors[I].Path);
//        finally
//          LSchemaValidator.Free;
//        end;
//      finally
//        LReader.Free;
//      end;
//    finally
//      LAddressSchema.Free;
//    end;
//  finally
//    LBuilder.Free;
//  end;
//end;
//
//procedure TJSONSchemaComposerTests.TestValidateJSONAgainstGeneratedSchemaString;
//var
//  LSchemaValidator: TJSONSchemaValidator;
//  LSchema: IJSONElement;
//  LValidJSON, LInvalidJSON: IJSONElement;
//  LReader: TJsonReader;
//  LResult: Boolean;
//  LErrors: TArray<TValidationError>;
//  I: Integer;
//begin
//  LReader := TJsonReader.Create;
//  try
//    LSchema := LReader.Read(
//      '{"$schema": "http://json-schema.org/draft-07/schema#",' +
//      '"type": "object",' +
//      '"properties": {' +
//      '  "homeAddress": {' +
//      '    "type": "object",' +
//      '    "properties": {' +
//      '      "street": {"type": "string"},' +
//      '      "city": {"type": "string"}' +
//      '    },' +
//      '    "required": ["street", "city"]' +
//      '  },' +
//      '  "type": {"type": "string"},' +
//      '  "name": {"type": "string"},' +
//      '  "status": {"type": "string"},' +
//      '  "score": {' +
//      '    "type": "number",' +
//      '    "minimum": 0,' +
//      '    "maximum": 100' +
//      '  },' +
//      '  "tags": {"type": "array"}' +
//      '},' +
//      '"required": ["homeAddress", "type"],' +
//      '"additionalProperties": false' +
//      '}'
//    );
//
//    LValidJSON := LReader.Read(
//      '{"homeAddress": {"street": "Main St", "city": "New York"}, ' +
//      '"type": "person", "name": "João", "status": "active", ' +
//      '"score": 50, "tags": ["abc", "def"]}'
//    );
//
//    LInvalidJSON := LReader.Read(
//      '{"homeAddress": {"street": 123}, "type": "person", ' +
//      '"status": "invalid", "score": 150, "tags": ["ab", "ab"], "extra": "field"}'
//    );
//
//    LSchemaValidator := TJSONSchemaValidator.Create(jsvDraft7);
//    try
//      Writeln('Schema gerado: ' + LSchema.AsJSON);
//      LSchemaValidator.ParseSchema(LSchema);
//      LResult := LSchemaValidator.Validate(LValidJSON, '');
//      Assert.IsTrue(LResult, 'Valid JSON should pass validation');
//      Assert.AreEqual(0, Length(LSchemaValidator.GetErrors), 'No validation errors expected for valid JSON');
//    finally
//      LSchemaValidator.Free;
//    end;
//
//    LSchemaValidator := TJSONSchemaValidator.Create(jsvDraft7);
//    try
//      LSchemaValidator.ParseSchema(LSchema);
//      LResult := LSchemaValidator.Validate(LInvalidJSON, '');
//      Assert.IsFalse(LResult, 'Invalid JSON should fail validation');
//      LErrors := LSchemaValidator.GetErrors;
//      Assert.IsTrue(Length(LErrors) > 0, 'Validation errors expected for invalid JSON');
//      for I := 0 to Length(LErrors) - 1 do
//        Writeln('Erro: ' + LErrors[I].Message + ' no caminho: ' + LErrors[I].Path);
//    finally
//      LSchemaValidator.Free;
//    end;
//  finally
//    LReader.Free;
//  end;
//end;
//
//procedure TJSONSchemaComposerTests.TestValidateTypeString;
//var
//  LBuilder: TJSONSchemaComposer;
//  LJSONSchema: String;
//  LJSON: String;
//  LValidator: TJSONSchemaValidator;
//  LSchemaElement: IJSONElement;
//  LReader: TJSONReader;
//  LJsonElement: IJSONElement;
//begin
//  LBuilder := TJSONSchemaComposer.Create;
//  try
//    LBuilder.Obj
//      .PropType('value', 'string')
//      .EndObj;
//
//    LSchemaElement := LBuilder.ToElement;
//    LJSONSchema := LBuilder.ToJSON(True, False);
//
//    LJSON := '{"value": "hello"}';
//    LValidator := TJSONSchemaValidator.Create(jsvDraft7);
//    try
//      Assert.IsNotNull(LSchemaElement, 'Schema element should not be nil');
//      LValidator.ParseSchema(LSchemaElement);
//
//      LReader := TJSONReader.Create;
//      try
//        LJsonElement := LReader.Read(LJSON);
//        Assert.IsTrue(LValidator.Validate(LJsonElement, ''), 'String should validate');
//      finally
//        LReader.Free;
//      end;
//    finally
//      LValidator.Free;
//    end;
//  finally
//    LBuilder.Free;
//  end;
//end;
//
//procedure TJSONSchemaComposerTests.TestValidateRequiredString;
//var
//  LBuilder: TJSONSchemaComposer;
//  LJSONSchema: String;
//  LJSON: String;
//  LValidator: TJSONSchemaValidator;
//  LSchemaElement: IJSONElement;
//  LReader: TJSONReader;
//  LJsonElement: IJSONElement;
//begin
//  LBuilder := TJSONSchemaComposer.Create;
//  try
//    LBuilder.Obj
//      .PropType('value', 'string', True)
//      .EndObj;
//
//    LSchemaElement := LBuilder.ToElement;
//    LJSONSchema := LBuilder.ToJSON(True, False);
//
//    LJSON := '{"value": "hello"}';
//    LValidator := TJSONSchemaValidator.Create(jsvDraft7);
//    try
//      Assert.IsNotNull(LSchemaElement, 'Schema element should not be nil');
//      LValidator.ParseSchema(LSchemaElement);
//
//      LReader := TJSONReader.Create;
//      try
//        LJsonElement := LReader.Read(LJSON);
//        Assert.IsTrue(LValidator.Validate(LJsonElement, ''), 'String should validate with required');
//      finally
//        LReader.Free;
//      end;
//
//      LJSON := '{}';
//      LReader := TJSONReader.Create;
//      try
//        LJsonElement := LReader.Read(LJSON);
//        Assert.IsFalse(LValidator.Validate(LJsonElement, ''), 'Missing required value should fail');
//      finally
//        LReader.Free;
//      end;
//    finally
//      LValidator.Free;
//    end;
//  finally
//    LBuilder.Free;
//  end;
//end;
//
//procedure TJSONSchemaComposerTests.TestValidateMinLengthString;
//var
//  LBuilder: TJSONSchemaComposer;
//  LValueSchema: TJSONSchemaComposer;
//  LJSONSchema: String;
//  LJSON: String;
//  LValidator: TJSONSchemaValidator;
//  LSchemaElement: IJSONElement;
//  LReader: TJSONReader;
//  LJsonElement: IJSONElement;
//begin
//  LBuilder := TJSONSchemaComposer.Create;
//  try
//    LValueSchema := TJSONSchemaComposer.Create;
//    try
//      LValueSchema.Obj
//        .Typ('string')
//        .MinLen(3)
//        .EndObj;
//
//      LBuilder.Obj
//        .Add('value', LValueSchema.ToElement)
//        .EndObj;
//
//      LSchemaElement := LBuilder.ToElement;
//      LJSONSchema := LBuilder.ToJSON(True, False);
//      Writeln('Generated Schema: ' + LJSONSchema);
//
//      LJSON := '{"value": "hello"}';
//      LValidator := TJSONSchemaValidator.Create(jsvDraft7);
//      try
//        Assert.IsNotNull(LSchemaElement, 'Schema element should not be nil');
//        LValidator.ParseSchema(LSchemaElement);
//
//        LReader := TJSONReader.Create;
//        try
//          LJsonElement := LReader.Read(LJSON);
//          Assert.IsTrue(LValidator.Validate(LJsonElement, ''), 'String should validate with minLength');
//        finally
//          LReader.Free;
//        end;
//
//        LJSON := '{"value": "hi"}';
//        LReader := TJSONReader.Create;
//        try
//          LJsonElement := LReader.Read(LJSON);
//          Writeln('Validating JSON: ' + LJSON);
//          Assert.IsFalse(LValidator.Validate(LJsonElement, ''), 'Short string should fail minLength');
//        finally
//          LReader.Free;
//        end;
//      finally
//        LValidator.Free;
//      end;
//    finally
//      LValueSchema.Free;
//    end;
//  finally
//    LBuilder.Free;
//  end;
//end;
//
//procedure TJSONSchemaComposerTests.TestValidateMaxLengthString;
//var
//  LBuilder: TJSONSchemaComposer;
//  LValueSchema: TJSONSchemaComposer;
//  LJSONSchema: String;
//  LJSON: String;
//  LValidator: TJSONSchemaValidator;
//  LSchemaElement: IJSONElement;
//  LReader: TJSONReader;
//  LJsonElement: IJSONElement;
//begin
//  LBuilder := TJSONSchemaComposer.Create;
//  try
//    LValueSchema := TJSONSchemaComposer.Create;
//    try
//      LValueSchema.Obj
//        .Typ('string')
//        .MaxLen(5)
//        .EndObj;
//
//      LBuilder.Obj
//        .Add('value', LValueSchema.ToElement)
//        .EndObj;
//
//      LSchemaElement := LBuilder.ToElement;
//      LJSONSchema := LBuilder.ToJSON(True, False);
//      Writeln('Generated Schema: ' + LJSONSchema);
//
//      LJSON := '{"value": "hello"}';
//      LValidator := TJSONSchemaValidator.Create(jsvDraft7);
//      try
//        Assert.IsNotNull(LSchemaElement, 'Schema element should not be nil');
//        LValidator.ParseSchema(LSchemaElement);
//
//        LReader := TJSONReader.Create;
//        try
//          LJsonElement := LReader.Read(LJSON);
//          Assert.IsTrue(LValidator.Validate(LJsonElement, ''), 'String within maxLength should validate');
//        finally
//          LReader.Free;
//        end;
//
//        LJSON := '{"value": "hello!"}';
//        LReader := TJSONReader.Create;
//        try
//          LJsonElement := LReader.Read(LJSON);
//          Writeln('Validating JSON: ' + LJSON);
//          Assert.IsFalse(LValidator.Validate(LJsonElement, ''), 'String exceeding maxLength should fail');
//        finally
//          LReader.Free;
//        end;
//      finally
//        LValidator.Free;
//      end;
//    finally
//      LValueSchema.Free;
//    end;
//  finally
//    LBuilder.Free;
//  end;
//end;
//
//procedure TJSONSchemaComposerTests.TestValidatePatternString;
//var
//  LBuilder: TJSONSchemaComposer;
//  LValueSchema: TJSONSchemaComposer;
//  LJSONSchema: String;
//  LJSON: String;
//  LValidator: TJSONSchemaValidator;
//  LSchemaElement: IJSONElement;
//  LReader: TJSONReader;
//  LJsonElement: IJSONElement;
//begin
//  LBuilder := TJSONSchemaComposer.Create;
//  try
//    LValueSchema := TJSONSchemaComposer.Create;
//    try
//      LValueSchema.Obj
//        .Typ('string')
//        .Pattern('^[A-Za-z]+$')
//        .EndObj;
//
//      LBuilder.Obj
//        .Add('value', LValueSchema.ToElement)
//        .EndObj;
//
//      LSchemaElement := LBuilder.ToElement;
//      LJSONSchema := LBuilder.ToJSON(True, False);
//      Writeln('Generated Schema: ' + LJSONSchema);
//
//      LJSON := '{"value": "hello"}';
//      LValidator := TJSONSchemaValidator.Create(jsvDraft7);
//      try
//        Assert.IsNotNull(LSchemaElement, 'Schema element should not be nil');
//        LValidator.ParseSchema(LSchemaElement);
//
//        LReader := TJSONReader.Create;
//        try
//          LJsonElement := LReader.Read(LJSON);
//          Assert.IsTrue(LValidator.Validate(LJsonElement, ''), 'String matching pattern should validate');
//        finally
//          LReader.Free;
//        end;
//
//        LJSON := '{"value": "hello123"}';
//        LReader := TJSONReader.Create;
//        try
//          LJsonElement := LReader.Read(LJSON);
//          Writeln('Validating JSON: ' + LJSON);
//          Assert.IsFalse(LValidator.Validate(LJsonElement, ''), 'String not matching pattern should fail');
//        finally
//          LReader.Free;
//        end;
//      finally
//        LValidator.Free;
//      end;
//    finally
//      LValueSchema.Free;
//    end;
//  finally
//    LBuilder.Free;
//  end;
//end;
//
//procedure TJSONSchemaComposerTests.TestValidateEnumString;
//var
//  LBuilder: TJSONSchemaComposer;
//  LValueSchema: TJSONSchemaComposer;
//  LJSONSchema: String;
//  LJSON: String;
//  LValidator: TJSONSchemaValidator;
//  LSchemaElement: IJSONElement;
//  LReader: TJSONReader;
//  LJsonElement: IJSONElement;
//begin
//  LBuilder := TJSONSchemaComposer.Create;
//  try
//    LValueSchema := TJSONSchemaComposer.Create;
//    try
//      LValueSchema.Obj
//        .Typ('string')
//        .Enum(['red', 'green', 'blue'])
//        .EndObj;
//
//      LBuilder.Obj
//        .Add('value', LValueSchema.ToElement)
//        .EndObj;
//
//      LSchemaElement := LBuilder.ToElement;
//      LJSONSchema := LBuilder.ToJSON(True, False);
//      Writeln('Generated Schema: ' + LJSONSchema);
//
//      LJSON := '{"value": "red"}';
//      LValidator := TJSONSchemaValidator.Create(jsvDraft7);
//      try
//        Assert.IsNotNull(LSchemaElement, 'Schema element should not be nil');
//        LValidator.ParseSchema(LSchemaElement);
//
//        LReader := TJSONReader.Create;
//        try
//          LJsonElement := LReader.Read(LJSON);
//          Assert.IsTrue(LValidator.Validate(LJsonElement, ''), 'String in enum should validate');
//        finally
//          LReader.Free;
//        end;
//
//        LJSON := '{"value": "yellow"}';
//        LReader := TJSONReader.Create;
//        try
//          LJsonElement := LReader.Read(LJSON);
//          Writeln('Validating JSON: ' + LJSON);
//          Assert.IsFalse(LValidator.Validate(LJsonElement, ''), 'String not in enum should fail');
//        finally
//          LReader.Free;
//        end;
//      finally
//        LValidator.Free;
//      end;
//    finally
//      LValueSchema.Free;
//    end;
//  finally
//    LBuilder.Free;
//  end;
//end;
//
//procedure TJSONSchemaComposerTests.TestValidateFormatEmail;
//var
//  LBuilder: TJSONSchemaComposer;
//  LValueSchema: TJSONSchemaComposer;
//  LJSONSchema: String;
//  LJSON: String;
//  LValidator: TJSONSchemaValidator;
//  LSchemaElement: IJSONElement;
//  LReader: TJSONReader;
//  LJsonElement: IJSONElement;
//begin
//  LBuilder := TJSONSchemaComposer.Create;
//  try
//    LValueSchema := TJSONSchemaComposer.Create;
//    try
//      LValueSchema.Obj
//        .Typ('string')
//        .Format('email')
//        .EndObj;
//
//      LBuilder.Obj
//        .Add('value', LValueSchema.ToElement)
//        .EndObj;
//
//      LSchemaElement := LBuilder.ToElement;
//      LJSONSchema := LBuilder.ToJSON(True, False);
//      Writeln('Generated Schema: ' + LJSONSchema);
//
//      LJSON := '{"value": "user@example.com"}';
//      LValidator := TJSONSchemaValidator.Create(jsvDraft7);
//      try
//        Assert.IsNotNull(LSchemaElement, 'Schema element should not be nil');
//        LValidator.ParseSchema(LSchemaElement);
//
//        LReader := TJSONReader.Create;
//        try
//          LJsonElement := LReader.Read(LJSON);
//          Assert.IsTrue(LValidator.Validate(LJsonElement, ''), 'Valid email should validate');
//        finally
//          LReader.Free;
//        end;
//
//        LJSON := '{"value": "invalid-email"}';
//        LReader := TJSONReader.Create;
//        try
//          LJsonElement := LReader.Read(LJSON);
//          Writeln('Validating JSON: ' + LJSON);
//          Assert.IsFalse(LValidator.Validate(LJsonElement, ''), 'Invalid email should fail');
//        finally
//          LReader.Free;
//        end;
//      finally
//        LValidator.Free;
//      end;
//    finally
//      LValueSchema.Free;
//    end;
//  finally
//    LBuilder.Free;
//  end;
//end;
//
//procedure TJSONSchemaComposerTests.TestValidateMinimumNumber;
//var
//  LBuilder: TJSONSchemaComposer;
//  LValueSchema: TJSONSchemaComposer;
//  LJSONSchema: String;
//  LJSON: String;
//  LValidator: TJSONSchemaValidator;
//  LSchemaElement: IJSONElement;
//  LReader: TJSONReader;
//  LJsonElement: IJSONElement;
//begin
//  LBuilder := TJSONSchemaComposer.Create;
//  try
//    LValueSchema := TJSONSchemaComposer.Create;
//    try
//      LValueSchema.Obj
//        .Typ('number')
//        .Min(10)
//        .EndObj;
//
//      LBuilder.Obj
//        .Add('value', LValueSchema.ToElement)
//        .EndObj;
//
//      LSchemaElement := LBuilder.ToElement;
//      LJSONSchema := LBuilder.ToJSON(True, False);
//      Writeln('Generated Schema: ' + LJSONSchema);
//
//      LJSON := '{"value": 15}';
//      LValidator := TJSONSchemaValidator.Create(jsvDraft7);
//      try
//        Assert.IsNotNull(LSchemaElement, 'Schema element should not be nil');
//        LValidator.ParseSchema(LSchemaElement);
//
//        LReader := TJSONReader.Create;
//        try
//          LJsonElement := LReader.Read(LJSON);
//          Assert.IsTrue(LValidator.Validate(LJsonElement, ''), 'Number above minimum should validate');
//        finally
//          LReader.Free;
//        end;
//
//        LJSON := '{"value": 5}';
//        LReader := TJSONReader.Create;
//        try
//          LJsonElement := LReader.Read(LJSON);
//          Writeln('Validating JSON: ' + LJSON);
//          Assert.IsFalse(LValidator.Validate(LJsonElement, ''), 'Number below minimum should fail');
//        finally
//          LReader.Free;
//        end;
//      finally
//        LValidator.Free;
//      end;
//    finally
//      LValueSchema.Free;
//    end;
//  finally
//    LBuilder.Free;
//  end;
//end;
//
//procedure TJSONSchemaComposerTests.TestValidateMaximumNumber;
//var
//  LBuilder: TJSONSchemaComposer;
//  LValueSchema: TJSONSchemaComposer;
//  LJSONSchema: String;
//  LJSON: String;
//  LValidator: TJSONSchemaValidator;
//  LSchemaElement: IJSONElement;
//  LReader: TJSONReader;
//  LJsonElement: IJSONElement;
//begin
//  LBuilder := TJSONSchemaComposer.Create;
//  try
//    LValueSchema := TJSONSchemaComposer.Create;
//    try
//      LValueSchema.Obj
//        .Typ('number')
//        .Max(20)
//        .EndObj;
//
//      LBuilder.Obj
//        .Add('value', LValueSchema.ToElement)
//        .EndObj;
//
//      LSchemaElement := LBuilder.ToElement;
//      LJSONSchema := LBuilder.ToJSON(True, False);
//      Writeln('Generated Schema: ' + LJSONSchema);
//
//      LJSON := '{"value": 15}';
//      LValidator := TJSONSchemaValidator.Create(jsvDraft7);
//      try
//        Assert.IsNotNull(LSchemaElement, 'Schema element should not be nil');
//        LValidator.ParseSchema(LSchemaElement);
//
//        LReader := TJSONReader.Create;
//        try
//          LJsonElement := LReader.Read(LJSON);
//          Assert.IsTrue(LValidator.Validate(LJsonElement, ''), 'Number below maximum should validate');
//        finally
//          LReader.Free;
//        end;
//
//        LJSON := '{"value": 25}';
//        LReader := TJSONReader.Create;
//        try
//          LJsonElement := LReader.Read(LJSON);
//          Writeln('Validating JSON: ' + LJSON);
//          Assert.IsFalse(LValidator.Validate(LJsonElement, ''), 'Number above maximum should fail');
//        finally
//          LReader.Free;
//        end;
//      finally
//        LValidator.Free;
//      end;
//    finally
//      LValueSchema.Free;
//    end;
//  finally
//    LBuilder.Free;
//  end;
//end;
//
//procedure TJSONSchemaComposerTests.TestValidateMultipleOfNumber;
//var
//  LBuilder: TJSONSchemaComposer;
//  LValueSchema: TJSONSchemaComposer;
//  LJSONSchema: String;
//  LJSON: String;
//  LValidator: TJSONSchemaValidator;
//  LSchemaElement: IJSONElement;
//  LReader: TJSONReader;
//  LJsonElement: IJSONElement;
//begin
//  LBuilder := TJSONSchemaComposer.Create;
//  try
//    LValueSchema := TJSONSchemaComposer.Create;
//    try
//      LValueSchema.Obj
//        .Typ('number')
//        .MultOf(5)
//        .EndObj;
//
//      LBuilder.Obj
//        .Add('value', LValueSchema.ToElement)
//        .EndObj;
//
//      LSchemaElement := LBuilder.ToElement;
//      LJSONSchema := LBuilder.ToJSON(True, False);
//      Writeln('Generated Schema: ' + LJSONSchema);
//
//      LJSON := '{"value": 15}';
//      LValidator := TJSONSchemaValidator.Create(jsvDraft7);
//      try
//        Assert.IsNotNull(LSchemaElement, 'Schema element should not be nil');
//        LValidator.ParseSchema(LSchemaElement);
//
//        LReader := TJSONReader.Create;
//        try
//          LJsonElement := LReader.Read(LJSON);
//          Assert.IsTrue(LValidator.Validate(LJsonElement, ''), 'Number multiple of 5 should validate');
//        finally
//          LReader.Free;
//        end;
//
//        LJSON := '{"value": 17}';
//        LReader := TJSONReader.Create;
//        try
//          LJsonElement := LReader.Read(LJSON);
//          Writeln('Validating JSON: ' + LJSON);
//          Assert.IsFalse(LValidator.Validate(LJsonElement, ''), 'Number not multiple of 5 should fail');
//        finally
//          LReader.Free;
//        end;
//      finally
//        LValidator.Free;
//      end;
//    finally
//      LValueSchema.Free;
//    end;
//  finally
//    LBuilder.Free;
//  end;
//end;
//
//procedure TJSONSchemaComposerTests.TestValidateExclusiveMaximumNumber;
//var
//  LBuilder: TJSONSchemaComposer;
//  LValueSchema: TJSONSchemaComposer;
//  LJSONSchema: String;
//  LJSON: String;
//  LValidator: TJSONSchemaValidator;
//  LSchemaElement: IJSONElement;
//  LReader: TJSONReader;
//  LJsonElement: IJSONElement;
//begin
//  LBuilder := TJSONSchemaComposer.Create;
//  try
//    LValueSchema := TJSONSchemaComposer.Create;
//    try
//      LValueSchema.Obj
//        .Typ('number')
//        .ExclMax(20)
//        .EndObj;
//
//      LBuilder.Obj
//        .Add('value', LValueSchema.ToElement)
//        .EndObj;
//
//      LSchemaElement := LBuilder.ToElement;
//      LJSONSchema := LBuilder.ToJSON(True, False);
//      Writeln('Generated Schema: ' + LJSONSchema);
//
//      LJSON := '{"value": 19}';
//      LValidator := TJSONSchemaValidator.Create(jsvDraft7);
//      try
//        Assert.IsNotNull(LSchemaElement, 'Schema element should not be nil');
//        LValidator.ParseSchema(LSchemaElement);
//
//        LReader := TJSONReader.Create;
//        try
//          LJsonElement := LReader.Read(LJSON);
//          Assert.IsTrue(LValidator.Validate(LJsonElement, ''), 'Number below exclusive maximum should validate');
//        finally
//          LReader.Free;
//        end;
//
//        LJSON := '{"value": 20}';
//        LReader := TJSONReader.Create;
//        try
//          LJsonElement := LReader.Read(LJSON);
//          Writeln('Validating JSON: ' + LJSON);
//          Assert.IsFalse(LValidator.Validate(LJsonElement, ''), 'Number equal to exclusive maximum should fail');
//        finally
//          LReader.Free;
//        end;
//      finally
//        LValidator.Free;
//      end;
//    finally
//      LValueSchema.Free;
//    end;
//  finally
//    LBuilder.Free;
//  end;
//end;
//
//procedure TJSONSchemaComposerTests.TestValidateExclusiveMinimumNumber;
//var
//  LBuilder: TJSONSchemaComposer;
//  LValueSchema: TJSONSchemaComposer;
//  LJSONSchema: String;
//  LJSON: String;
//  LValidator: TJSONSchemaValidator;
//  LSchemaElement: IJSONElement;
//  LReader: TJSONReader;
//  LJsonElement: IJSONElement;
//begin
//  LBuilder := TJSONSchemaComposer.Create;
//  try
//    LValueSchema := TJSONSchemaComposer.Create;
//    try
//      LValueSchema.Obj
//        .Typ('number')
//        .ExclMin(10)
//        .EndObj;
//
//      LBuilder.Obj
//        .Add('value', LValueSchema.ToElement)
//        .EndObj;
//
//      LSchemaElement := LBuilder.ToElement;
//      LJSONSchema := LBuilder.ToJSON(True, False);
//      Writeln('Generated Schema: ' + LJSONSchema);
//
//      LJSON := '{"value": 11}';
//      LValidator := TJSONSchemaValidator.Create(jsvDraft7);
//      try
//        Assert.IsNotNull(LSchemaElement, 'Schema element should not be nil');
//        LValidator.ParseSchema(LSchemaElement);
//
//        LReader := TJSONReader.Create;
//        try
//          LJsonElement := LReader.Read(LJSON);
//          Assert.IsTrue(LValidator.Validate(LJsonElement, ''), 'Number above exclusive minimum should validate');
//        finally
//          LReader.Free;
//        end;
//
//        LJSON := '{"value": 10}';
//        LReader := TJSONReader.Create;
//        try
//          LJsonElement := LReader.Read(LJSON);
//          Writeln('Validating JSON: ' + LJSON);
//          Assert.IsFalse(LValidator.Validate(LJsonElement, ''), 'Number equal to exclusive minimum should fail');
//        finally
//          LReader.Free;
//        end;
//      finally
//        LValidator.Free;
//      end;
//    finally
//      LValueSchema.Free;
//    end;
//  finally
//    LBuilder.Free;
//  end;
//end;
//
//procedure TJSONSchemaComposerTests.TestValidateMinItems;
//var
//  LBuilder: TJSONSchemaComposer;
//  LValueSchema: TJSONSchemaComposer;
//  LJSONSchema: String;
//  LJSON: String;
//  LValidator: TJSONSchemaValidator;
//  LSchemaElement: IJSONElement;
//  LReader: TJSONReader;
//  LJsonElement: IJSONElement;
//begin
//  LBuilder := TJSONSchemaComposer.Create;
//  try
//    LValueSchema := TJSONSchemaComposer.Create;
//    try
//      LValueSchema.Obj
//        .Typ('array')
//        .MinItems(2)
//        .EndObj;
//
//      LBuilder.Obj
//        .Add('value', LValueSchema.ToElement)
//        .EndObj;
//
//      LSchemaElement := LBuilder.ToElement;
//      LJSONSchema := LBuilder.ToJSON(True, False);
//      Writeln('Generated Schema: ' + LJSONSchema);
//
//      LJSON := '{"value": [1, 2]}';
//      LValidator := TJSONSchemaValidator.Create(jsvDraft7);
//      try
//        Assert.IsNotNull(LSchemaElement, 'Schema element should not be nil');
//        LValidator.ParseSchema(LSchemaElement);
//
//        LReader := TJSONReader.Create;
//        try
//          LJsonElement := LReader.Read(LJSON);
//          Assert.IsTrue(LValidator.Validate(LJsonElement, ''), 'Array with at least minItems should validate');
//        finally
//          LReader.Free;
//        end;
//
//        LJSON := '{"value": [1]}';
//        LReader := TJSONReader.Create;
//        try
//          LJsonElement := LReader.Read(LJSON);
//          Writeln('Validating JSON: ' + LJSON);
//          Assert.IsFalse(LValidator.Validate(LJsonElement, ''), 'Array with fewer than minItems should fail');
//        finally
//          LReader.Free;
//        end;
//      finally
//        LValidator.Free;
//      end;
//    finally
//      LValueSchema.Free;
//    end;
//  finally
//    LBuilder.Free;
//  end;
//end;
//
//procedure TJSONSchemaComposerTests.TestValidateMaxItems;
//var
//  LBuilder: TJSONSchemaComposer;
//  LValueSchema: TJSONSchemaComposer;
//  LJSONSchema: String;
//  LJSON: String;
//  LValidator: TJSONSchemaValidator;
//  LSchemaElement: IJSONElement;
//  LReader: TJSONReader;
//  LJsonElement: IJSONElement;
//begin
//  LBuilder := TJSONSchemaComposer.Create;
//  try
//    LValueSchema := TJSONSchemaComposer.Create;
//    try
//      LValueSchema.Obj
//        .Typ('array')
//        .MaxItems(2)
//        .EndObj;
//
//      LBuilder.Obj
//        .Add('value', LValueSchema.ToElement)
//        .EndObj;
//
//      LSchemaElement := LBuilder.ToElement;
//      LJSONSchema := LBuilder.ToJSON(True, False);
//      Writeln('Generated Schema: ' + LJSONSchema);
//
//      LJSON := '{"value": [1, 2]}';
//      LValidator := TJSONSchemaValidator.Create(jsvDraft7);
//      try
//        Assert.IsNotNull(LSchemaElement, 'Schema element should not be nil');
//        LValidator.ParseSchema(LSchemaElement);
//
//        LReader := TJSONReader.Create;
//        try
//          LJsonElement := LReader.Read(LJSON);
//          Assert.IsTrue(LValidator.Validate(LJsonElement, ''), 'Array with at most maxItems should validate');
//        finally
//          LReader.Free;
//        end;
//
//        LJSON := '{"value": [1, 2, 3]}';
//        LReader := TJSONReader.Create;
//        try
//          LJsonElement := LReader.Read(LJSON);
//          Writeln('Validating JSON: ' + LJSON);
//          Assert.IsFalse(LValidator.Validate(LJsonElement, ''), 'Array with more than maxItems should fail');
//        finally
//          LReader.Free;
//        end;
//      finally
//        LValidator.Free;
//      end;
//    finally
//      LValueSchema.Free;
//    end;
//  finally
//    LBuilder.Free;
//  end;
//end;
//
//procedure TJSONSchemaComposerTests.TestValidateJSONAgainstGeneratedSchemaIsolated;
//var
//  LBuilder: TJSONSchemaComposer;
//  LJSONSchema: String;
//  LJSON: String;
//  LValidator: TJSONSchemaValidator;
//  LSchemaElement: IJSONElement;
//  LReader: TJSONReader;
//  LJsonElement: IJSONElement;
//begin
//  LBuilder := TJSONSchemaComposer.Create;
//  try
//    LBuilder.Obj
//      .PropType('name', 'string', True)
//      .PropType('age', 'integer')
//      .EndObj;
//
//    LSchemaElement := LBuilder.ToElement;
//    LJSONSchema := LBuilder.ToJSON(True, False);
//    Writeln('Generated Schema: ' + LJSONSchema);
//
//    LJSON := '{"name": "Isaque", "age": 30}';
//    LValidator := TJSONSchemaValidator.Create(jsvDraft7);
//    try
//      Assert.IsNotNull(LSchemaElement, 'Schema element should not be nil');
//      LValidator.ParseSchema(LSchemaElement);
//
//      LReader := TJSONReader.Create;
//      try
//        Writeln('Validating JSON: ' + LJSON);
//        LJsonElement := LReader.Read(LJSON);
//        Assert.IsTrue(LValidator.Validate(LJsonElement, ''), 'Valid JSON should pass validation');
//      finally
//        LReader.Free;
//      end;
//
//      LJSON := '{"age": 30}';
//      LReader := TJSONReader.Create;
//      try
//        Writeln('Validating JSON: ' + LJSON);
//        LJsonElement := LReader.Read(LJSON);
//        Assert.IsFalse(LValidator.Validate(LJsonElement, ''), 'JSON missing required field should fail');
//      finally
//        LReader.Free;
//      end;
//    finally
//      LValidator.Free;
//    end;
//  finally
//    LBuilder.Free;
//  end;
//end;
//
//procedure TJSONSchemaComposerTests.TestValidateSimpleRefWithDefinitions;
//var
//  LBuilder: TJSONSchemaComposer;
//  LDefSchema: TJSONSchemaComposer;
//  LJSONSchema: String;
//  LValidator: TJSONSchemaValidator;
//  LSchemaElement: IJSONElement;
//  LReader: TJSONReader;
//  LJsonElement: IJSONElement;
//  LValidJSON: String;
//  LInvalidJSON: String;
//  LRoot: IJSONObject;
//  LDefs: IJSONObject;
//  LProps: IJSONObject;
//  LMainContact: IJSONObject;
//  LDefSchemaObj: IJSONObject;
//begin
//  LDefSchema := TJSONSchemaComposer.Create;
//  try
//    LDefSchema.Obj
//      .Typ('object')
//      .PropType('phone', 'string', True)
//      .EndObj;
//
//    LBuilder := TJSONSchemaComposer.Create;
//    try
//      LRoot := TJSONObject.Create;
//      LDefs := TJSONObject.Create;
//
//      LSchemaElement := LDefSchema.ToElement;
//      if Supports(LSchemaElement, IJSONObject, LDefSchemaObj) and LDefSchemaObj.ContainsKey('schema') then
//        LDefs.Add('contact', LDefSchemaObj.GetValue('schema'))
//      else
//        LDefs.Add('contact', LSchemaElement);
//
//      LRoot.Add('$defs', LDefs);
//
//      LProps := TJSONObject.Create;
//      LMainContact := TJSONObject.Create;
//      LMainContact.Add('$ref', TJSONValueString.Create('#/$defs/contact'));
//      LProps.Add('mainContact', LMainContact);
//      LRoot.Add('properties', LProps);
//
//      LBuilder.LoadJSON(LRoot.AsJSON(False));
//
//      LSchemaElement := LBuilder.ToElement;
//      LJSONSchema := LBuilder.ToJSON(True, False);
//      Writeln('Generated Schema: ' + LJSONSchema);
//
//      LValidJSON := '{"mainContact": {"phone": "123-456-7890"}}';
//      LInvalidJSON := '{"mainContact": {}}';
//
//      LValidator := TJSONSchemaValidator.Create(jsvDraft7);
//      try
//        Assert.IsNotNull(LSchemaElement, 'Schema element should not be nil');
//        Writeln('Parsing schema...');
//        LValidator.ParseSchema(LSchemaElement);
//        Writeln('Properties count in validator: ' + LValidator.GetProperties.Count.ToString);
//
//        LReader := TJSONReader.Create;
//        try
//          Writeln('Validating JSON: ' + LValidJSON);
//          LJsonElement := LReader.Read(LValidJSON);
//          Assert.IsTrue(LValidator.Validate(LJsonElement, ''), 'Valid JSON should pass validation');
//        finally
//          LReader.Free;
//        end;
//
//        LReader := TJSONReader.Create;
//        try
//          Writeln('Validating JSON: ' + LInvalidJSON);
//          LJsonElement := LReader.Read(LInvalidJSON);
//          Assert.IsFalse(LValidator.Validate(LJsonElement, ''), 'Invalid JSON should fail validation');
//        finally
//          LReader.Free;
//        end;
//      finally
//        LValidator.Free;
//      end;
//    finally
//      LBuilder.Free;
//    end;
//  finally
//    LDefSchema.Free;
//  end;
//end;
//
//procedure TJSONSchemaComposerTests.TestCommentInSchema;
//var
//  LJSONSchema: String;
//  LBuilder: TJSONSchemaComposer;
//  LValidator: TJSONSchemaValidator;
//  LSchemaElement: IJSONElement;
//  LReader: TJSONReader;
//  LJsonElement: IJSONElement;
//begin
//  LBuilder := TJSONSchemaComposer.Create;
//  try
//    LBuilder.Obj
//      .Typ('string')
//      .Comment('This is a descriptive comment about the schema')
//      .EndObj;
//
//    LSchemaElement := LBuilder.ToElement;
//    LJSONSchema := LBuilder.ToJSON(True);
//    Assert.IsNotEmpty(LJSONSchema, 'JSON Schema should not be empty');
//    Assert.Contains(LJSONSchema, '"$comment": "This is a descriptive comment about the schema"',
//      'Schema should contain the specified comment');  // Corrigido para "$comment"
//
//    LValidator := TJSONSchemaValidator.Create(jsvDraft7);
//    try
//      LValidator.ParseSchema(LSchemaElement);
//      LReader := TJSONReader.Create;
//      try
//        LJsonElement := LReader.Read('"hello"');
//        Assert.IsTrue(LValidator.Validate(LJsonElement, ''),
//          'JSON válido deve passar na validação com schema com comentário');
//      finally
//        LReader.Free;
//      end;
//    finally
//      LValidator.Free;
//    end;
//  finally
//    LBuilder.Free;
//  end;
//end;
//
//procedure TJSONSchemaComposerTests.TestExamplesInSchema;
//var
//  LJSONSchema: String;
//  LBuilder: TJSONSchemaComposer;
//begin
//  LBuilder := TJSONSchemaComposer.Create;
//  try
//    LBuilder.Obj
//      .Typ('string')
//      .Examples(['example1', 'example2'])
//      .EndObj;
//
//    LJSONSchema := LBuilder.ToJSON(True);
//    Assert.IsNotEmpty(LJSONSchema, 'JSON Schema should not be empty');
//    Assert.Contains(LJSONSchema, '"type": "string"', 'Schema should have type "string"');
//    Assert.Contains(LJSONSchema, '"examples":', 'Schema should have examples');
//    Assert.Contains(LJSONSchema, '"example1"', 'Schema should include example1');
//    Assert.Contains(LJSONSchema, '"example2"', 'Schema should include example2');
//  finally
//    LBuilder.Free;
//  end;
//end;
//
//procedure TJSONSchemaComposerTests.TestValidateGeneratedSchemaAgainstMetaSchemaFluido;
//var
//  LSchemaValidator: TJSONSchemaValidator;
//  LBuilder: TJSONSchemaComposer;
//  LGeneratedSchema: IJSONElement;
//  LResult: Boolean;
//begin
//  LBuilder := TJSONSchemaComposer.Create;
//  try
//    LBuilder.Obj
//      .Schema(procedure(S: TJSONSchemaComposer)
//      begin
//        S.Typ('object')
//         .Def('address', procedure(D: TJSONSchemaComposer)
//           begin
//             D.Typ('object')
//              .PropType('street', 'string')
//              .PropType('city', 'string');
//           end)
//         .Prop('homeAddress', procedure(P: TJSONSchemaComposer)
//           begin
//             P.Ref('#/$defs/address');
//           end)
//         .PropType('type', 'string')
//         .PropType('name', 'string')
//         .PropType('id', 'integer')
//         .IfThen(S.SubSchema(procedure(I: TJSONSchemaComposer)
//           begin
//             I.PropType('type', 'string')
//              .Cst('person');
//           end))
//         .Thn(S.SubSchema(procedure(T: TJSONSchemaComposer)
//           begin
//             T.PropType('name', 'string', True);
//           end))
//         .Els(S.SubSchema(procedure(E: TJSONSchemaComposer)
//           begin
//             E.PropType('id', 'integer', True);
//           end))
//         .Prop('status', procedure(P: TJSONSchemaComposer)
//           begin
//             P.Typ('string')
//              .Enum(['active', 'inactive']);
//           end)
//         .Prop('score', procedure(P: TJSONSchemaComposer)
//           begin
//             P.Typ('number')
//              .Min(0)
//              .Max(100)
//              .MultOf(5);
//           end)
//         .Prop('tags', procedure(P: TJSONSchemaComposer)
//           begin
//             P.Typ('array')
//              .Items(S.SubSchema(procedure(I: TJSONSchemaComposer)
//                begin
//                  I.Typ('string')
//                   .MinLen(3);
//                end))
//              .MinItems(1)
//              .MaxItems(5)
//              .Unique(True);
//           end)
//         .MinProps(1)
//         .MaxProps(10)
//         .AddProps(False)
//         .AllOf([S.SubSchema(procedure(A1: TJSONSchemaComposer)
//                 begin
//                   A1.Typ('string')
//                     .MinLen(3);
//                 end),
//                 S.SubSchema(procedure(A2: TJSONSchemaComposer)
//                 begin
//                   A2.MaxLen(10);
//                 end)])
//         .AnyOf([S.SubSchema(procedure(A1: TJSONSchemaComposer)
//                 begin
//                   A1.Typ('string')
//                     .MinLen(3);
//                 end),
//                 S.SubSchema(procedure(A2: TJSONSchemaComposer)
//                 begin
//                   A2.MaxLen(10);
//                 end)])
//         .OneOf([S.SubSchema(procedure(O1: TJSONSchemaComposer)
//                 begin
//                   O1.Typ('string')
//                     .MinLen(3);
//                 end),
//                 S.SubSchema(procedure(O2: TJSONSchemaComposer)
//                 begin
//                   O2.MaxLen(10);
//                 end)])
//         .Neg(S.SubSchema(procedure(N: TJSONSchemaComposer)
//           begin
//             N.Typ('string')
//              .Pattern('^admin');
//           end));
//      end)
//      .EndObj;
//
//    LGeneratedSchema := LBuilder.ToElement;
//
//    LSchemaValidator := TJSONSchemaValidator.Create(jsvDraft7);
//    try
//      if not Assigned(FMetaSchema) then
//        raise EAssertionFailed.Create('FMetaSchema não está atribuído');
//      WriteLn('FMetaSchema: ' + FMetaSchema.AsJSON);
//      WriteLn('Generated Schema: ' + LGeneratedSchema.AsJSON);
//      LSchemaValidator.ParseSchema(FMetaSchema);
//      LResult := LSchemaValidator.Validate(LGeneratedSchema, '');
//      Assert.IsTrue(LResult, 'O schema gerado deve ser válido contra o meta-schema');
//      Assert.AreEqual(0, Length(LSchemaValidator.GetErrors), 'Nenhum erro de validação esperado');
//    finally
//      LSchemaValidator.Free;
//    end;
//  finally
//    LBuilder.Free;
//  end;
//end;
//
//end.




