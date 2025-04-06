unit JsonFlow.TraitMaxContains;

interface

uses
  SysUtils,
  Generics.Collections,
  JsonFlow.Value,
  JsonFlow.Interfaces,
  JsonFlow.SchemaValidator;

type
  TMaxContainsTrait = class(TJsonSchemaTrait)
  private
    FMaxContains: Integer;
    FHasMaxContains: Boolean;
  public
    constructor Create(const AValidator: TJSONSchemaValidator); override;
    destructor Destroy; override;
    procedure Parse(const ANode: IJSONObject); override;
    function Validate(const ANode: IJSONElement; const APath: String;
      const AErrors: TList<TValidationError>): Boolean; override;
  end;

implementation

constructor TMaxContainsTrait.Create(const AValidator: TJSONSchemaValidator);
begin
  inherited Create(AValidator);

end;

destructor TMaxContainsTrait.Destroy;
begin

  inherited;
end;

procedure TMaxContainsTrait.Parse(const ANode: IJSONObject);
begin
  FHasMaxContains := ANode.ContainsKey('maxContains');
  if FHasMaxContains then
    FMaxContains := (ANode.GetValue('maxContains') as IJSONValue).AsInteger;
end;

function TMaxContainsTrait.Validate(const ANode: IJSONElement; const APath: String;
  const AErrors: TList<TValidationError>): Boolean;
var
  LArray: IJSONArray;
  LError: TValidationError;
  LContainsSchema: TSchemaNode;
  LCount: Integer;
  LFor: Integer;
  LChild: TSchemaNode;
  LTempErrors: TList<TValidationError>;
begin
  Result := True;
  if not FHasMaxContains then
    Exit;

  if not Supports(ANode, IJSONArray, LArray) then
    Exit;

  LContainsSchema := nil;
  if FValidator.GetRootNode <> nil then
  begin
    for LChild in FValidator.GetRootNode.Children do
    begin
      if LChild.Keyword = 'contains' then
      begin
        LContainsSchema := LChild;
        Break;
      end;
    end;
  end;
  if not Assigned(LContainsSchema) then
    Exit;

  LCount := 0;
  LTempErrors := TList<TValidationError>.Create;
  try
    for LFor := 0 to LArray.Count - 1 do
    begin
      LTempErrors.Clear;
      if LContainsSchema.Trait.Validate(LArray.Items[LFor], APath + '/' + LFor.ToString, LTempErrors) then
        Inc(LCount);
    end;

    if LCount > FMaxContains then
    begin
      LError.Path := APath;
      LError.Message := Format('Array must contain at most %d items matching the contains schema, found %d', [FMaxContains, LCount]);
      LError.FoundValue := IntToStr(LCount);
      LError.ExpectedValue := Format('<= %d', [FMaxContains]);
      LError.Keyword := 'maxContains';
      LError.LineNumber := -1;
      LError.ColumnNumber := -1;
      LError.Context := Format('Schema: {"maxContains": %d}', [FMaxContains]);
      AErrors.Add(LError);
      Result := False;
    end;
  finally
    LTempErrors.Free;
  end;
end;

end.
