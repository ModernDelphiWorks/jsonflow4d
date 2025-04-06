unit JsonFlow.TraitDependentRequired;

interface

uses
  SysUtils,
  Generics.Collections,
  JsonFlow.Value,
  JsonFlow.Interfaces,
  JsonFlow.SchemaValidator;

type
  TDependentRequiredTrait = class(TJsonSchemaTrait)
  private
    FDependencies: TDictionary<String, TList<String>>;
  public
    constructor Create(const AValidator: TJSONSchemaValidator); override;
    destructor Destroy; override;
    procedure Parse(const ANode: IJSONObject); override;
    function Validate(const ANode: IJSONElement; const APath: String;
      const AErrors: TList<TValidationError>): Boolean; override;
  end;

implementation

constructor TDependentRequiredTrait.Create(const AValidator: TJSONSchemaValidator);
begin
  inherited Create(AValidator);
  FDependencies := TDictionary<String, TList<String>>.Create;
end;

destructor TDependentRequiredTrait.Destroy;
var
  LPair: TPair<String, TList<String>>;
begin
  for LPair in FDependencies do
    LPair.Value.Free;
  FDependencies.Free;
  inherited;
end;

procedure TDependentRequiredTrait.Parse(const ANode: IJSONObject);
var
  LDeps: IJSONObject;
  LPair: IJSONPair;
  LArray: IJSONArray;
  LValue: IJSONValue;
  LList: TList<String>;
  LFor: Integer;
begin
  FDependencies.Clear;
  if ANode.ContainsKey('dependentRequired') and Supports(ANode.GetValue('dependentRequired'), IJSONObject, LDeps) then
  begin
    for LPair in LDeps.Pairs do
    begin
      LList := TList<String>.Create;
      if Supports(LPair.Value, IJSONArray, LArray) then
        for LFor := 0 to LArray.Count - 1 do
          if Supports(LArray.Items[LFor], IJSONValue, LValue) then
            LList.Add(LValue.AsString);
      FDependencies.Add(LPair.Key, LList);
    end;
  end;
end;

function TDependentRequiredTrait.Validate(const ANode: IJSONElement; const APath: String;
  const AErrors: TList<TValidationError>): Boolean;
var
  LObj: IJSONObject;
  LKey: String;
  LRequired: TList<String>;
  LField: String;
  LError: TValidationError;
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
      LRequired := FDependencies[LKey];
      for LField in LRequired do
        if not LObj.ContainsKey(LField) then
        begin
          LError.Path := APath + '/' + LField;
          LError.Message := Format('Field "%s" is required when "%s" is present', [LField, LKey]);
          LError.FoundValue := 'not present';
          LError.ExpectedValue := 'present';
          LError.Keyword := 'dependentRequired';
          LError.LineNumber := -1;
          LError.ColumnNumber := -1;
          LError.Context := Format('Schema: {"dependentRequired": {"%s": [%s]}}', [LKey, TArray.ToString<String>(LRequired.ToArray)]);
          AErrors.Add(LError);
          Result := False;
        end;
    end;
  end;
end;

end.
