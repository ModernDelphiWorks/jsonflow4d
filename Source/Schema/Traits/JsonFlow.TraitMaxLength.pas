unit JsonFlow.TraitMaxLength;

interface

uses
  SysUtils,
  Generics.Collections,
  JsonFlow.Value,
  JsonFlow.Interfaces,
  JsonFlow.SchemaValidator;

type
  TMaxLengthTrait = class(TJsonSchemaTrait)
  private
    FMaxLength: Integer;
    FHasMaxLength: Boolean;
  public
    constructor Create(const AValidator: TJSONSchemaValidator); override;
    destructor Destroy; override;
    procedure Parse(const ANode: IJSONObject); override;
    function Validate(const ANode: IJSONElement; const APath: String;
      const AErrors: TList<TValidationError>): Boolean; override;
  end;

implementation

constructor TMaxLengthTrait.Create(const AValidator: TJSONSchemaValidator);
begin
  inherited Create(AValidator);

end;

destructor TMaxLengthTrait.Destroy;
begin

  inherited;
end;

procedure TMaxLengthTrait.Parse(const ANode: IJSONObject);
begin
  FHasMaxLength := ANode.ContainsKey('maxLength');
  if FHasMaxLength then
    FMaxLength := (ANode.GetValue('maxLength') as IJSONValue).AsInteger;
end;

function TMaxLengthTrait.Validate(const ANode: IJSONElement; const APath: String;
  const AErrors: TList<TValidationError>): Boolean;
var
  LError: TValidationError;
  LValue: String;
begin
  Result := True;
  if not FHasMaxLength then
    Exit;

  if not Supports(ANode, IJSONValue) or not (ANode as IJSONValue).IsString then
  begin
    LError.Path := APath;
    LError.Message := 'Expected string for maxLength validation, found non-string value';
    LError.FoundValue := (ANode as IJSONValue).TypeName;
    LError.ExpectedValue := 'string';
    LError.Keyword := 'maxLength';
    LError.LineNumber := -1;
    LError.ColumnNumber := -1;
    LError.Context := Format('Schema: {"maxLength": %d}', [FMaxLength]);
    AErrors.Add(LError);
    Exit(False);
  end;

  LValue := (ANode as IJSONValue).AsString;
  if Length(LValue) > FMaxLength then
  begin
    LError.Path := APath;
    LError.Message := Format('String length must be at most %d, found %d', [FMaxLength, Length(LValue)]);
    LError.FoundValue := IntToStr(Length(LValue));
    LError.ExpectedValue := Format('<= %d', [FMaxLength]);
    LError.Keyword := 'maxLength';
    LError.LineNumber := -1;
    LError.ColumnNumber := -1;
    LError.Context := Format('Schema: {"maxLength": %d}', [FMaxLength]);
    AErrors.Add(LError);
    Result := False;
  end;
end;

end.
