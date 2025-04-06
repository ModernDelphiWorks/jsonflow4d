unit JsonFlow.TraitAdditionalItems;

interface

uses
  SysUtils,
  Generics.Collections,
  JsonFlow.Value,
  JsonFlow.Interfaces,
  JsonFlow.SchemaValidator;

type
  TAdditionalItemsTrait = class(TJsonSchemaTrait)
  private
    FAdditionalItemsSchema: TSchemaNode;
    FAllowAdditional: Boolean;
  public
    constructor Create(const AValidator: TJSONSchemaValidator); override;
    destructor Destroy; override;
    procedure Parse(const ANode: IJSONObject); override;
    function Validate(const ANode: IJSONElement; const APath: String;
      const AErrors: TList<TValidationError>): Boolean; override;
  end;

implementation

constructor TAdditionalItemsTrait.Create(const AValidator: TJSONSchemaValidator);
begin
  inherited Create(AValidator);

end;

destructor TAdditionalItemsTrait.Destroy;
begin
  FAdditionalItemsSchema.Free;
  inherited;
end;

procedure TAdditionalItemsTrait.Parse(const ANode: IJSONObject);
begin
  if ANode.ContainsKey('additionalItems') then
  begin
    if Supports(ANode.GetValue('additionalItems'), IJSONValue) and (ANode.GetValue('additionalItems') as IJSONValue).IsBoolean then
      FAllowAdditional := (ANode.GetValue('additionalItems') as IJSONValue).AsBoolean
    else
      FAdditionalItemsSchema := FValidator.ParseNode(ANode.GetValue('additionalItems'), '/additionalItems');
  end
  else
    FAllowAdditional := True;
end;

function TAdditionalItemsTrait.Validate(const ANode: IJSONElement; const APath: String;
  const AErrors: TList<TValidationError>): Boolean;
var
  LArray: IJSONArray;
  LItemsCount: Integer;
  LFor: Integer;
  LChild: TSchemaNode;
  LError: TValidationError;
begin
  Result := True;
  if not Supports(ANode, IJSONArray, LArray) then
    Exit;

  LItemsCount := 0;
  if FValidator.GetRootNode <> nil then
  begin
    for LChild in FValidator.GetRootNode.Children do
    begin
      if (LChild.Keyword = 'items') and Supports(LChild.Value, IJSONArray) then
        LItemsCount := (LChild.Value as IJSONArray).Count;
    end;
  end;

  for LFor := LItemsCount to LArray.Count - 1 do
  begin
    if Assigned(FAdditionalItemsSchema) then
    begin
      if not FAdditionalItemsSchema.Trait.Validate(LArray.Items[LFor], APath + '/' + LFor.ToString, AErrors) then
        Result := False;
    end
    else if not FAllowAdditional then
    begin
      LError.Path := APath + '/' + LFor.ToString;
      LError.Message := Format('Additional item at index %d is not allowed', [LFor]);
      LError.FoundValue := LArray.Items[LFor].AsJSON;
      LError.ExpectedValue := 'not present';
      LError.Keyword := 'additionalItems';
      LError.LineNumber := -1;
      LError.ColumnNumber := -1;
      LError.Context := 'Schema: {"additionalItems": false}';
      AErrors.Add(LError);
      Result := False;
    end;
  end;
end;

end.
