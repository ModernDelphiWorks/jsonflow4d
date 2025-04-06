unit JsonFlow.TraitMinLength;

interface

uses
  SysUtils,
  Generics.Collections,
  JsonFlow.Value,
  JsonFlow.Interfaces,
  JsonFlow.SchemaValidator;

type
  TMinLengthTrait = class(TJsonSchemaTrait)
  private
    FMinLength: Integer;
    FHasMinLength: Boolean;
  public
    constructor Create(const AValidator: TJSONSchemaValidator); override;
    destructor Destroy; override;
    procedure Parse(const ANode: IJSONObject); override;
    function Validate(const ANode: IJSONElement; const APath: String;
      const AErrors: TList<TValidationError>): Boolean; override;
  end;

implementation

constructor TMinLengthTrait.Create(const AValidator: TJSONSchemaValidator);
begin
  inherited Create(AValidator);

end;

destructor TMinLengthTrait.Destroy;
begin

  inherited;
end;

procedure TMinLengthTrait.Parse(const ANode: IJSONObject);
begin
  FHasMinLength := ANode.ContainsKey('minLength');
  if FHasMinLength then
    FMinLength := (ANode.GetValue('minLength') as IJSONValue).AsInteger;
end;

function TMinLengthTrait.Validate(const ANode: IJSONElement; const APath: String;
  const AErrors: TList<TValidationError>): Boolean;
var
  LError: TValidationError;
  LValue: String;
begin
  Result := True;
  if not FHasMinLength then
    Exit;

  if not Supports(ANode, IJSONValue) or not (ANode as IJSONValue).IsString then
  begin
    LError.Path := APath;
    LError.Message := 'Expected string for minLength validation, found non-string value';
    LError.FoundValue := (ANode as IJSONValue).TypeName;
    LError.ExpectedValue := 'string';
    LError.Keyword := 'minLength';
    LError.LineNumber := -1;
    LError.ColumnNumber := -1;
    LError.Context := Format('Schema: {"minLength": %d}', [FMinLength]);
    AErrors.Add(LError);
    Exit(False);
  end;

  LValue := (ANode as IJSONValue).AsString;
  if Length(LValue) < FMinLength then
  begin
    LError.Path := APath;
    LError.Message := Format('String length must be at least %d, found %d', [FMinLength, Length(LValue)]);
    LError.FoundValue := IntToStr(Length(LValue));
    LError.ExpectedValue := Format('>= %d', [FMinLength]);
    LError.Keyword := 'minLength';
    LError.LineNumber := -1;
    LError.ColumnNumber := -1;
    LError.Context := Format('Schema: {"minLength": %d}', [FMinLength]);
    AErrors.Add(LError);
    Result := False;
  end;
end;

end.
