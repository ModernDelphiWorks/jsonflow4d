unit JsonFlow.TraitAdditionalProperties;

interface

uses
  SysUtils,
  Generics.Collections,
  JsonFlow.Value,
  JsonFlow.Interfaces,
  JsonFlow.SchemaValidator;

type
  TAdditionalPropertiesTrait = class(TJsonSchemaTrait)
  private
    FAdditionalProperties: TSchemaNode;
    FAllowAdditional: Boolean;
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

constructor TAdditionalPropertiesTrait.Create(const AValidator: TJSONSchemaValidator);
begin
  inherited Create(AValidator);
end;

destructor TAdditionalPropertiesTrait.Destroy;
begin
  FAdditionalProperties.Free;
  inherited;
end;

procedure TAdditionalPropertiesTrait.Parse(const ANode: IJSONObject);
begin
  if ANode.ContainsKey('additionalProperties') then
  begin
    if Supports(ANode.GetValue('additionalProperties'), IJSONValue) and (ANode.GetValue('additionalProperties') as IJSONValue).IsBoolean then
      FAllowAdditional := (ANode.GetValue('additionalProperties') as IJSONValue).AsBoolean
    else
      FAdditionalProperties := FValidator.ParseNode(ANode.GetValue('additionalProperties'), '/additionalProperties');
  end
  else
    FAllowAdditional := True;
end;

function TAdditionalPropertiesTrait.Validate(const ANode: IJSONElement; const APath: String;
  const AErrors: TList<TValidationError>): Boolean;
var
  LObj: IJSONObject;
  LKey: String;
  LError: TValidationError;
  LProperties: IJSONObject;
  LPatternProperties: IJSONObject;
  LHasProperties, LHasPatternProperties: Boolean;
  LChild: TSchemaNode;
  LPair: IJSONPair;
  LPatternMatch: Boolean;
begin
  Result := True;
  Writeln('TAdditionalPropertiesTrait.Validate started for ' + ANode.AsJSON + ' at ' + APath);
  if not Supports(ANode, IJSONObject, LObj) then
    Exit;

  LHasProperties := False;
  LHasPatternProperties := False;
  if FValidator.GetRootNode <> nil then
  begin
    for LChild in FValidator.GetRootNode.Children do
    begin
      if (LChild.Keyword = 'properties') and Supports(LChild.Value, IJSONObject, LProperties) then
        LHasProperties := True;
      if (LChild.Keyword = 'patternProperties') and Supports(LChild.Value, IJSONObject, LPatternProperties) then
        LHasPatternProperties := True;
    end;
  end;

  for LPair in LObj.Pairs do
  begin
    LKey := LPair.Key;
    if LHasProperties and LProperties.ContainsKey(LKey) then
      Continue;
    if LHasPatternProperties then
    begin
      LPatternMatch := False;
      for var LPatternPair in LPatternProperties.Pairs do
      begin
        if TRegEx.IsMatch(LPatternPair.Key, LKey) then
        begin
          LPatternMatch := True;
          Break;
        end;
      end;
      if LPatternMatch then
        Continue;
    end;

    if Assigned(FAdditionalProperties) then
    begin
      if not FAdditionalProperties.Trait.Validate(LPair.Value, APath + '/' + LKey, AErrors) then
        Result := False;
    end
    else if not FAllowAdditional then
    begin
      LError.Path := APath + '/' + LKey;
      LError.Message := Format('Additional property "%s" is not allowed', [LKey]);
      LError.FoundValue := LPair.Value.AsJSON;
      LError.ExpectedValue := 'not present';
      LError.Keyword := 'additionalProperties';
      LError.LineNumber := -1;
      LError.ColumnNumber := -1;
      LError.Context := 'Schema: {"additionalProperties": false}';
      AErrors.Add(LError);
      Result := False;
    end;
  end;
end;

end.



