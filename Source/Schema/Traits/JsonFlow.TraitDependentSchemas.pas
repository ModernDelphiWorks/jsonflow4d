unit JsonFlow.TraitDependentSchemas;

interface

uses
  SysUtils,
  Generics.Collections,
  JsonFlow.Value,
  JsonFlow.Interfaces,
  JsonFlow.SchemaValidator;

type
  TDependentSchemasTrait = class(TJsonSchemaTrait)
  private
    FDependencies: TDictionary<String, TSchemaNode>;
  public
    constructor Create(const AValidator: TJSONSchemaValidator); override;
    destructor Destroy; override;
    procedure Parse(const ANode: IJSONObject); override;
    function Validate(const ANode: IJSONElement; const APath: String;
      const AErrors: TList<TValidationError>): Boolean; override;
  end;

implementation

constructor TDependentSchemasTrait.Create(const AValidator: TJSONSchemaValidator);
begin
  inherited Create(AValidator);
  FDependencies := TDictionary<String, TSchemaNode>.Create;
end;

destructor TDependentSchemasTrait.Destroy;
var
  LPair: TPair<String, TSchemaNode>;
begin
  for LPair in FDependencies do
    LPair.Value.Free;
  FDependencies.Free;
  inherited;
end;

procedure TDependentSchemasTrait.Parse(const ANode: IJSONObject);
var
  LDeps: IJSONObject;
  LPair: IJSONPair;
begin
  FDependencies.Clear;
  if ANode.ContainsKey('dependentSchemas') and Supports(ANode.GetValue('dependentSchemas'), IJSONObject, LDeps) then
    for LPair in LDeps.Pairs do
      FDependencies.Add(LPair.Key, FValidator.ParseNode(LPair.Value, '/dependentSchemas/' + LPair.Key));
end;

function TDependentSchemasTrait.Validate(const ANode: IJSONElement; const APath: String;
  const AErrors: TList<TValidationError>): Boolean;
var
  LObj: IJSONObject;
  LKey: String;
  LSchema: TSchemaNode;
begin
  Result := True;
  if FDependencies.Count = 0 then
    Exit;

  if not Supports(ANode, IJSONObject, LObj) then
    Exit;

  for LKey in FDependencies.Keys do
  begin
    if LObj.ContainsKey(LKey) then
    begin
      LSchema := FDependencies[LKey];
      if not LSchema.Trait.Validate(ANode, APath, AErrors) then
        Result := False;
    end;
  end;
end;

end.
