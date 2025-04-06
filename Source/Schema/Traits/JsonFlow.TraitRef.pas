unit JsonFlow.TraitRef;

interface

uses
  SysUtils,
  Generics.Collections,
  JsonFlow.Value,
  JsonFlow.Interfaces,
  JsonFlow.SchemaValidator,
  JsonFlow.SchemaNavigator;

type
  TRefTrait = class(TJsonSchemaTrait)
  private
    FRef: String;
    FRefNode: TSchemaNode;
  public
    constructor Create(const AValidator: TJSONSchemaValidator); override;
    destructor Destroy; override;
    procedure Parse(const ANode: IJSONObject); override;
    function Validate(const ANode: IJSONElement; const APath: String;
      const AErrors: TList<TValidationError>): Boolean; override;
  end;

implementation

constructor TRefTrait.Create(const AValidator: TJSONSchemaValidator);
begin
  inherited Create(AValidator);
  FValidator.AddLog('TRefTrait.Create called');
end;

destructor TRefTrait.Destroy;
begin
  FValidator.AddLog('TRefTrait.Destroy called');
  FRefNode := nil;
  inherited;
end;

procedure TRefTrait.Parse(const ANode: IJSONObject);
var
  LNavigator: TJSONSchemaNavigator;
  LRefElement: IJSONElement;
  LPath: String;
begin
  FValidator.AddLog('TRefTrait.Parse started for node: ' + ANode.AsJSON);
  if Assigned(FNode.Parent) then
    FValidator.AddLog('Parent keyword: ' + FNode.Parent.Keyword)
  else
    FValidator.AddLog('No parent found');

  if Assigned(FNode) and Supports(FNode.Value, IJSONValue) then
    FRef := (FNode.Value as IJSONValue).AsString
  else if ANode.ContainsKey('$ref') then
    FRef := (ANode.GetValue('$ref') as IJSONValue).AsString
  else
    FRef := '';

  if FRef = '' then
  begin
    FValidator.AddLog('No $ref found in node');
    Exit;
  end;
  FValidator.AddLog('Parsed $ref value: ' + FRef);

  if Assigned(FRefNode) then
  begin
    FRefNode.Free;
    FRefNode := nil;
  end;

  LNavigator := TJSONSchemaNavigator.Create(FValidator.Schema);
  try
    LRefElement := LNavigator.ResolveReference(FRef);
    if Assigned(LRefElement) then
    begin
      if Assigned(FNode.Parent) then
        LPath := FNode.Parent.Keyword
      else
        LPath := '';
      if (FValidator as TJSONSchemaValidator).GetDefsNodes.ContainsKey(FRef) then
      begin
        FRefNode := (FValidator as TJSONSchemaValidator).GetDefsNodes[FRef];
        FValidator.AddLog('Reusing pre-parsed node for $ref: ' + FRef);
        FNode.Children.Add(FRefNode); // Adiciona como filho do nó $ref atual
      end
      else
      begin
        FRefNode := (FValidator as TJSONSchemaValidator).ParseNode(LRefElement, LPath);
        if Assigned(FRefNode) then
        begin
          FValidator.AddLog('Resolved $ref to node: ' + FRefNode.Keyword);
          FNode.Children.Add(FRefNode); // Adiciona como filho do nó $ref atual
        end;
      end;
    end
    else
    begin
      FValidator.AddLog('Failed to resolve $ref: ' + FRef);
      FRefNode := nil;
    end;
  finally
    LNavigator.Free;
  end;
  FValidator.AddLog('TRefTrait.Parse finished');
end;

function TRefTrait.Validate(const ANode: IJSONElement; const APath: String;
  const AErrors: TList<TValidationError>): Boolean;
var
  LError: TValidationError;
  LSubElement: IJSONElement;
  LErrors: TList<TValidationError>;
begin
  FValidator.AddLog('TRefTrait.Validate started for ' + ANode.AsJSON + ' with $ref: ' + FRef + ' at path: ' + APath);
  Result := True;

  if (not Assigned(FRefNode)) or (FRef = '') then
  begin
    LError.Path := APath;
    LError.Message := Format('Unable to resolve $ref "%s"', [FRef]);
    LError.FoundValue := ANode.AsJSON;
    LError.ExpectedValue := 'valid reference';
    LError.Keyword := '$ref';
    AErrors.Add(LError);
    FValidator.AddLog('Reference resolution failed');
    Result := False;
    Exit;
  end;

  LSubElement := ANode;
  FValidator.AddLog('Using subelement: ' + LSubElement.AsJSON);

  // Valida o nó referenciado diretamente
  LErrors := AErrors;
  if not FRefNode.IsValidated then
    Result := FValidator.ValidateNode(FRefNode, LSubElement, APath, LErrors)
  else
    FValidator.AddLog('Skipping already validated $ref node at ' + APath);

  FValidator.AddLog('TRefTrait.Validate finished: ' + BoolToStr(Result, True));
end;

end.
