unit JsonFlow.TraitProperties;

interface

uses
  SysUtils,
  Generics.Collections,
  JsonFlow.Value,
  JsonFlow.Interfaces,
  JsonFlow.SchemaValidator;

type
  TPropertiesTrait = class(TJsonSchemaTrait)
  public
    constructor Create(const AValidator: TJSONSchemaValidator); override;
    destructor Destroy; override;
    procedure Parse(const ANode: IJSONObject); override;
    function Validate(const ANode: IJSONElement; const APath: String;
      const AErrors: TList<TValidationError>): Boolean; override;
  end;

implementation

constructor TPropertiesTrait.Create(const AValidator: TJSONSchemaValidator);
begin
  inherited Create(AValidator);
  FValidator.AddLog('TPropertiesTrait.Create called');
end;

destructor TPropertiesTrait.Destroy;
begin
  FValidator.AddLog('TPropertiesTrait.Destroy called');
  inherited;
end;

procedure TPropertiesTrait.Parse(const ANode: IJSONObject);
begin
  FValidator.AddLog('TPropertiesTrait.Parse started for node: ' + ANode.AsJSON);
  // No additional parsing needed, children are set by the parser
  FValidator.AddLog('TPropertiesTrait.Parse finished');
end;

function TPropertiesTrait.Validate(const ANode: IJSONElement; const APath: String;
  const AErrors: TList<TValidationError>): Boolean;
var
  LObj: IJSONObject;
  LChild: TSchemaNode;
  LSubElement: IJSONElement;
begin
  FValidator.AddLog('TPropertiesTrait.Validate started for ' + ANode.AsJSON + ' at path: ' + APath);
  Result := True;

  if not Supports(ANode, IJSONObject, LObj) then
  begin
    FValidator.AddError(APath, 'Expected object for properties validation', ANode.AsJSON, 'object', 'properties');
    FValidator.AddLog('Element is not an object, validation failed');
    Exit(False);
  end;

  if not Assigned(FNode) then
  begin
    FValidator.AddError(APath, 'Trait node not set', '', 'TSchemaNode', 'properties', -1, -1, 'Internal error');
    FValidator.AddLog('FNode not assigned, validation failed');
    Exit(False);
  end;

  FValidator.AddLog('Found ' + FNode.Children.Count.ToString + ' properties to validate');
  for LChild in FNode.Children do
  begin
    FValidator.AddLog('Processing property: ' + LChild.Keyword + ' at ' + APath + '/' + LChild.Keyword);
    if Assigned(LChild) and LObj.ContainsKey(LChild.Keyword) then
    begin
      LSubElement := LObj.GetValue(LChild.Keyword);
      FValidator.AddLog('Found property ' + LChild.Keyword + ' with value: ' + LSubElement.AsJSON);
      if Assigned(LChild.Trait) then
      begin
        try
          if not LChild.Trait.Validate(LSubElement, APath + '/' + LChild.Keyword, AErrors) then
          begin
            Result := False;
            FValidator.AddLog('Validation failed for property ' + LChild.Keyword);
          end
          else
            FValidator.AddLog('Validation succeeded for property ' + LChild.Keyword);
        except
          on E: Exception do
          begin
            FValidator.AddLog('Exception in Validate for child ' + LChild.Keyword + ' at ' + APath + '/' + LChild.Keyword + ': ' + E.Message);
            Result := False;
          end;
        end;
      end
      else
        FValidator.AddLog('No trait assigned to property ' + LChild.Keyword + ' at ' + APath + '/' + LChild.Keyword);
    end
    else
      FValidator.AddLog('Property ' + LChild.Keyword + ' not found in object or LChild is nil');
  end;

  FValidator.AddLog('TPropertiesTrait.Validate finished: ' + BoolToStr(Result, True));
end;

end.
