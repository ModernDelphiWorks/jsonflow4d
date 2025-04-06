unit JsonFlow.TraitMultipleOf;

interface

uses
  SysUtils,
  Generics.Collections,
  JsonFlow.Value,
  JsonFlow.Interfaces,
  JsonFlow.SchemaValidator;

type
  TMultipleOfTrait = class(TJsonSchemaTrait)
  private
    FMultipleOf: Double;
    FHasMultipleOf: Boolean;
  public
    constructor Create(const AValidator: TJSONSchemaValidator); override;
    destructor Destroy; override;
    procedure Parse(const ANode: IJSONObject); override;
    function Validate(const ANode: IJSONElement; const APath: String;
      const AErrors: TList<TValidationError>): Boolean; override;
  end;

implementation

constructor TMultipleOfTrait.Create(const AValidator: TJSONSchemaValidator);
begin
  inherited Create(AValidator);

end;

destructor TMultipleOfTrait.Destroy;
begin

  inherited;
end;

procedure TMultipleOfTrait.Parse(const ANode: IJSONObject);
begin
  FHasMultipleOf := ANode.ContainsKey('multipleOf');
  if FHasMultipleOf then
    FMultipleOf := (ANode.GetValue('multipleOf') as IJSONValue).AsFloat;
end;

function TMultipleOfTrait.Validate(const ANode: IJSONElement; const APath: String;
  const AErrors: TList<TValidationError>): Boolean;
var
  LError: TValidationError;
  LValue: Double;
begin
  Result := True;
  if not FHasMultipleOf then Exit;

  if not Supports(ANode, IJSONValue) or not ((ANode as IJSONValue).IsFloat or (ANode as IJSONValue).IsInteger) then
  begin
    LError.Path := APath;
    LError.Message := 'Expected number for multipleOf validation, found non-numeric value';
    LError.FoundValue := (ANode as IJSONvalue).TypeName;
    LError.ExpectedValue := 'number';
    LError.Keyword := 'multipleOf';
    LError.LineNumber := -1;
    LError.ColumnNumber := -1;
    LError.Context := Format('Schema: {"multipleOf": %f}', [FMultipleOf]);
    AErrors.Add(LError);
    Exit(False);
  end;

  LValue := (ANode as IJSONValue).AsFloat;
  if (FMultipleOf > 0) and (Frac(LValue / FMultipleOf) <> 0) then
  begin
    LError.Path := APath;
    LError.Message := Format('Value must be a multiple of %f, found %f', [FMultipleOf, LValue]);
    LError.FoundValue := FloatToStr(LValue);
    LError.ExpectedValue := Format('multiple of %f', [FMultipleOf]);
    LError.Keyword := 'multipleOf';
    LError.LineNumber := -1;
    LError.ColumnNumber := -1;
    LError.Context := Format('Schema: {"multipleOf": %f}', [FMultipleOf]);
    AErrors.Add(LError);
    Result := False;
  end;
end;

end.
