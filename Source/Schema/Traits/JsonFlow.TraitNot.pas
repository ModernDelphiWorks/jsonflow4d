unit JsonFlow.TraitNot;

interface

uses
  SysUtils,
  Generics.Collections,
  JsonFlow.Value,
  JsonFlow.Interfaces,
  JsonFlow.SchemaValidator;

type
  TNotTrait = class(TJsonSchemaTrait)
  private
    FNotSchema: TSchemaNode;
  public
    constructor Create(const AValidator: TJSONSchemaValidator); override;
    destructor Destroy; override;
    procedure Parse(const ANode: IJSONObject); override;
    function Validate(const ANode: IJSONElement; const APath: String;
      const AErrors: TList<TValidationError>): Boolean; override;
  end;

implementation

constructor TNotTrait.Create(const AValidator: TJSONSchemaValidator);
begin
  inherited Create(AValidator);

end;

destructor TNotTrait.Destroy;
begin
  FNotSchema.Free;
  inherited;
end;

procedure TNotTrait.Parse(const ANode: IJSONObject);
begin
  if ANode.ContainsKey('not') then
    FNotSchema := FValidator.ParseNode(ANode.GetValue('not'), '/not');
end;

function TNotTrait.Validate(const ANode: IJSONElement; const APath: String;
  const AErrors: TList<TValidationError>): Boolean;
var
  LTempErrors: TList<TValidationError>;
  LError: TValidationError;
begin
  Result := True;
  if not Assigned(FNotSchema) then
    Exit;

  LTempErrors := TList<TValidationError>.Create;
  try
    if FNotSchema.Trait.Validate(ANode, APath, LTempErrors) then
    begin
      LError.Path := APath;
      LError.Message := 'Value must not match the schema in "not"';
      LError.FoundValue := ANode.AsJSON;
      LError.ExpectedValue := 'not matching';
      LError.Keyword := 'not';
      LError.LineNumber := -1;
      LError.ColumnNumber := -1;
      LError.Context := 'Schema: {"not": ...}';
      AErrors.Add(LError);
      Result := False;
    end;
  finally
    LTempErrors.Free;
  end;
end;

end.
