unit JsonFlow.TraitDependencies;

interface

uses
  SysUtils,
  Generics.Collections,
  JsonFlow.Value,
  JsonFlow.Interfaces,
  JsonFlow.SchemaValidator;

type
  TDependenciesTrait = class(TJsonSchemaTrait)
  private
    FDependencies: TDictionary<String, TList<String>>;
    FSchemaDependencies: TDictionary<String, TSchemaNode>;
  public
    constructor Create(const AValidator: TJSONSchemaValidator); override;
    destructor Destroy; override;
    procedure Parse(const ANode: IJSONObject); override;
    function Validate(const ANode: IJSONElement; const APath: String;
      const AErrors: TList<TValidationError>): Boolean; override;
  end;

implementation

constructor TDependenciesTrait.Create(const AValidator: TJSONSchemaValidator);
begin
  inherited Create(AValidator);
  FDependencies := TDictionary<String, TList<String>>.Create;
  FSchemaDependencies := TDictionary<String, TSchemaNode>.Create;
end;

destructor TDependenciesTrait.Destroy;
var
  LPair1: TPair<String, TList<String>>;
  LPair2: TPair<String, TSchemaNode>;
begin
  for LPair1 in FDependencies do
    LPair1.Value.Free;
  FreeAndNil(FDependencies);
  for LPair2 in FSchemaDependencies do
    LPair2.Value.Free;
  FSchemaDependencies.Free;
  inherited;
end;

procedure TDependenciesTrait.Parse(const ANode: IJSONObject);
var
  LDeps: IJSONObject;
  LPair: IJSONPair;
  LArray: IJSONArray;
  LValue: IJSONValue;
  LList: TList<String>;
  LFor: Integer;
begin
  FDependencies.Clear;
  FSchemaDependencies.Clear;
  if ANode.ContainsKey('dependencies') and Supports(ANode.GetValue('dependencies'), IJSONObject, LDeps) then
    for LPair in LDeps.Pairs do
    begin
      if Supports(LPair.Value, IJSONArray, LArray) then
      begin
        LList := TList<String>.Create;
        for LFor := 0 to LArray.Count - 1 do
          if Supports(LArray.Items[LFor], IJSONValue, LValue) then
            LList.Add(LValue.AsString);
        FDependencies.Add(LPair.Key, LList);
      end
      else
        FSchemaDependencies.Add(LPair.Key, FValidator.ParseNode(LPair.Value, '/dependencies/' + LPair.Key));
    end;
end;

function TDependenciesTrait.Validate(const ANode: IJSONElement; const APath: String;
  const AErrors: TList<TValidationError>): Boolean;
var
  LObj: IJSONObject;
  LKey: String;
  LRequired: TList<String>;
  LField: String;
  LSchema: TSchemaNode;
  LError: TValidationError;
begin
  Result := True;
  if (FDependencies.Count = 0) and (FSchemaDependencies.Count = 0) then
    Exit;

  if not Supports(ANode, IJSONObject, LObj) then
    Exit;

  for LKey in FDependencies.Keys do
  begin
    if LObj.ContainsKey(LKey) then
    begin
      LRequired := FDependencies[LKey];
      for LField in LRequired do
        if not LObj.ContainsKey(LField) then
        begin
          LError.Path := APath + '/' + LField;
          LError.Message := Format('Field "%s" is required when "%s" is present', [LField, LKey]);
          LError.FoundValue := 'not present';
          LError.ExpectedValue := 'present';
          LError.Keyword := 'dependencies';
          LError.LineNumber := -1;
          LError.ColumnNumber := -1;
          LError.Context := Format('Schema: {"dependencies": {"%s": [%s]}}', [LKey, TArray.ToString<String>(LRequired.ToArray)]);
          AErrors.Add(LError);
          Result := False;
        end;
    end;
  end;

  for LKey in FSchemaDependencies.Keys do
    if LObj.ContainsKey(LKey) then
    begin
      LSchema := FSchemaDependencies[LKey];
      if not LSchema.Trait.Validate(ANode, APath, AErrors) then
        Result := False;
    end;
end;

end.
