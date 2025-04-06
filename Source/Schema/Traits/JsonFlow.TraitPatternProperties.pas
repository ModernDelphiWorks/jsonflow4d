unit JsonFlow.TraitPatternProperties;

interface

uses
  SysUtils,
  Generics.Collections,
  JsonFlow.Value,
  JsonFlow.Interfaces,
  JsonFlow.SchemaValidator;

type
  TPatternPropertiesTrait = class(TJsonSchemaTrait)
  private
    FPatternSchemas: TObjectDictionary<String, TSchemaNode>;
  public
    constructor Create(const AValidator: TJSONSchemaValidator); override;
    destructor Destroy; override;
    procedure Parse(const ANode: IJSONObject); override;
    function Validate(const ANode: IJSONElement; const APath: String;
      const AErrors: TList<TValidationError>): Boolean; override;
  end;

implementation

uses
  RegularExpressions;

constructor TPatternPropertiesTrait.Create(const AValidator: TJSONSchemaValidator);
begin
  inherited Create(AValidator);
  FPatternSchemas := TObjectDictionary<String, TSchemaNode>.Create([doOwnsValues]);
end;

destructor TPatternPropertiesTrait.Destroy;
begin
  FPatternSchemas.Free;
  inherited;
end;

procedure TPatternPropertiesTrait.Parse(const ANode: IJSONObject);
var
  LPatterns: IJSONObject;
  LPair: IJSONPair;
begin
  if ANode.ContainsKey('patternProperties') and Supports(ANode.GetValue('patternProperties'), IJSONObject, LPatterns) then
    for LPair in LPatterns.Pairs do
    begin
      if not FPatternSchemas.ContainsKey(LPair.Key) then
        FPatternSchemas.Add(LPair.Key, FValidator.ParseNode(LPair.Value, '/patternProperties/' + LPair.Key));
    end;
end;

function TPatternPropertiesTrait.Validate(const ANode: IJSONElement; const APath: String;
  const AErrors: TList<TValidationError>): Boolean;
var
  LObj: IJSONObject;
  LPair: IJSONPair;
  LPatternPair: TPair<String, TSchemaNode>;
begin
  Result := True;
  if FPatternSchemas.Count = 0 then
    Exit;

  if not Supports(ANode, IJSONObject, LObj) then
    Exit;

  for LPair in LObj.Pairs do
  begin
    for LPatternPair in FPatternSchemas do
    begin
      if TRegEx.IsMatch(LPatternPair.Key, LPair.Key) then
        if not LPatternPair.Value.Trait.Validate(LPair.Value, APath + '/' + LPair.Key, AErrors) then
          Result := False;
    end;
  end;
end;

end.
