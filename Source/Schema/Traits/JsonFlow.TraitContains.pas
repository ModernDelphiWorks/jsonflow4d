unit JsonFlow.TraitContains;

interface

uses
  SysUtils,
  Generics.Collections,
  JsonFlow.Value,
  JsonFlow.Interfaces,
  JsonFlow.SchemaValidator;

type
  TContainsTrait = class(TJsonSchemaTrait)
  private
    FContainsSchema: TSchemaNode;
  public
    constructor Create(const AValidator: TJSONSchemaValidator); override;
    destructor Destroy; override;
    procedure Parse(const ANode: IJSONObject); override;
    function Validate(const ANode: IJSONElement; const APath: String;
      const AErrors: TList<TValidationError>): Boolean; override;
  end;

implementation

constructor TContainsTrait.Create(const AValidator: TJSONSchemaValidator);
begin
  inherited Create(AValidator);

end;

destructor TContainsTrait.Destroy;
begin
  FContainsSchema.Free;
  inherited;
end;

procedure TContainsTrait.Parse(const ANode: IJSONObject);
begin
  if ANode.ContainsKey('contains') then
    FContainsSchema := FValidator.ParseNode(ANode.GetValue('contains'), '/contains');
end;

function TContainsTrait.Validate(const ANode: IJSONElement; const APath: String;
  const AErrors: TList<TValidationError>): Boolean;
var
  LArray: IJSONArray;
  LError: TValidationError;
  LFor: Integer;
  LFound: Boolean;
  LTempErrors: TList<TValidationError>;
begin
  Result := True;
  if not Assigned(FContainsSchema) then
    Exit;

  if not Supports(ANode, IJSONArray, LArray) then
  begin
    LError.Path := APath;
    LError.Message := 'Expected array for contains validation, found non-array';
    LError.FoundValue := (ANode as IJSONValue).TypeName;
    LError.ExpectedValue := 'array';
    LError.Keyword := 'contains';
    LError.LineNumber := -1;
    LError.ColumnNumber := -1;
    LError.Context := 'Schema: {"contains": ...}';
    AErrors.Add(LError);
    Exit(False);
  end;

  LFound := False;
  LTempErrors := TList<TValidationError>.Create;
  try
    for LFor := 0 to LArray.Count - 1 do
    begin
      LTempErrors.Clear;
      if FContainsSchema.Trait.Validate(LArray.Items[LFor], APath + '/' + LFor.ToString, LTempErrors) then
      begin
        LFound := True;
        Break;
      end;
    end;

    if not LFound then
    begin
      LError.Path := APath;
      LError.Message := 'Array must contain at least one item matching the schema';
      LError.FoundValue := LArray.AsJSON;
      LError.ExpectedValue := 'at least one match';
      LError.Keyword := 'contains';
      LError.LineNumber := -1;
      LError.ColumnNumber := -1;
      LError.Context := 'Schema: {"contains": ...}';
      AErrors.Add(LError);
      Result := False;
    end;
  finally
    LTempErrors.Free;
  end;
end;

end.
