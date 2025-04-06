unit JsonFlow.TraitAllof;

interface

uses
  SysUtils,
  Generics.Collections,
  JsonFlow.Value,
  JsonFlow.Interfaces,
  JsonFlow.SchemaValidator;

type
  TAllOfTrait = class(TJsonSchemaTrait)
  private
    FConditions: TObjectList<TSchemaNode>;
  public
    constructor Create(const AValidator: TJSONSchemaValidator); override;
    destructor Destroy; override;
    procedure Parse(const ANode: IJSONObject); override;
    function Validate(const ANode: IJSONElement; const APath: String;
      const AErrors: TList<TValidationError>): Boolean; override;
  end;

implementation

constructor TAllOfTrait.Create(const AValidator: TJSONSchemaValidator);
begin
  inherited Create(AValidator);
  FConditions := TObjectList<TSchemaNode>.Create;
end;

destructor TAllOfTrait.Destroy;
begin
  FConditions.Free;
  inherited;
end;

procedure TAllOfTrait.Parse(const ANode: IJSONObject);
var
  LArray: IJSONArray;
  LFor: Integer;
begin
  FConditions.Clear;
  if ANode.ContainsKey('allOf') and Supports(ANode.GetValue('allOf'), IJSONArray, LArray) then
    for LFor := 0 to LArray.Count - 1 do
      FConditions.Add(FValidator.ParseNode(LArray.Items[LFor], '/allOf/' + LFor.ToString));
end;

function TAllOfTrait.Validate(const ANode: IJSONElement; const APath: String;
  const AErrors: TList<TValidationError>): Boolean;
var
  LCondition: TSchemaNode;
begin
  Result := True;
  FValidator.AddLog('TAllOfTrait.Validate started for ' + ANode.AsJSON);
  for LCondition in FConditions do
  begin
    if Assigned(LCondition) and Assigned(LCondition.Trait) then
    begin
      FValidator.AddLog('Validating condition: ' + LCondition.Keyword);
      if not LCondition.Trait.Validate(ANode, APath, AErrors) then
        Result := False;
    end
    else
    begin
      FValidator.AddLog('Warning: Invalid condition in allOf');
      Result := False;
    end;
  end;
  FValidator.AddLog('TAllOfTrait.Validate finished: ' + BoolToStr(Result, True));
end;

end.
