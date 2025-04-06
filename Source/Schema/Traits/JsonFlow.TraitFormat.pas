unit JsonFlow.TraitFormat;

interface

uses
  SysUtils,
  Generics.Collections,
  JsonFlow.Value,
  JsonFlow.Interfaces,
  JsonFlow.SchemaValidator;

type
  TFormatTrait = class(TJsonSchemaTrait)
  private
    FFormat: String;
    FHasFormat: Boolean;
  public
    constructor Create(const AValidator: TJSONSchemaValidator); override;
    destructor Destroy; override;
    procedure Parse(const ANode: IJSONObject); override;
    function Validate(const ANode: IJSONElement; const APath: String;
      const AErrors: TList<TValidationError>): Boolean; override;
  end;

implementation

constructor TFormatTrait.Create(const AValidator: TJSONSchemaValidator);
begin
  inherited Create(AValidator);

end;

destructor TFormatTrait.Destroy;
begin

  inherited;
end;

procedure TFormatTrait.Parse(const ANode: IJSONObject);
begin
  FHasFormat := ANode.ContainsKey('format');
  if FHasFormat then
    FFormat := (ANode.GetValue('format') as IJSONValue).AsString;
end;

function TFormatTrait.Validate(const ANode: IJSONElement; const APath: String;
  const AErrors: TList<TValidationError>): Boolean;
var
  LError: TValidationError;
  LValue: String;
begin
  Result := True;
  if not FHasFormat then
    Exit;

  if not Supports(ANode, IJSONValue) or not (ANode as IJSONValue).IsString then
  begin
    LError.Path := APath;
    LError.Message := 'Expected string for format validation, found non-string value';
    LError.FoundValue := (ANode as IJSONValue).TypeName;
    LError.ExpectedValue := 'string';
    LError.Keyword := 'format';
    LError.LineNumber := -1;
    LError.ColumnNumber := -1;
    LError.Context := Format('Schema: {"format": "%s"}', [FFormat]);
    AErrors.Add(LError);
    Exit(False);
  end;

  LValue := (ANode as IJSONValue).AsString;
  // Placeholder: Add specific format validation (e.g., email, date) in production
  if FFormat = 'email' then
  begin
    if Pos('@', LValue) = 0 then
    begin
      LError.Path := APath;
      LError.Message := Format('String must match format "%s", found invalid value "%s"', [FFormat, LValue]);
      LError.FoundValue := LValue;
      LError.ExpectedValue := 'valid email';
      LError.Keyword := 'format';
      LError.LineNumber := -1;
      LError.ColumnNumber := -1;
      LError.Context := Format('Schema: {"format": "%s"}', [FFormat]);
      AErrors.Add(LError);
      Result := False;
    end;
  end;
end;

end.
