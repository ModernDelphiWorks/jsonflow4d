unit JsonFlow.TraitExclusiveMinimum;

interface

uses
  SysUtils,
  Generics.Collections,
  JsonFlow.Value,
  JsonFlow.Interfaces,
  JsonFlow.SchemaValidator;

type
  TExclusiveMinimumTrait = class(TJsonSchemaTrait)
  private
    FExclusiveMinimum: Double;
    FHasExclusiveMinimum: Boolean;
  public
    constructor Create(const AValidator: TJSONSchemaValidator); override;
    destructor Destroy; override;
    procedure Parse(const ANode: IJSONObject); override;
    function Validate(const ANode: IJSONElement; const APath: String;
      const AErrors: TList<TValidationError>): Boolean; override;
  end;

implementation

constructor TExclusiveMinimumTrait.Create(const AValidator: TJSONSchemaValidator);
begin
  inherited Create(AValidator);

end;

destructor TExclusiveMinimumTrait.Destroy;
begin

  inherited;
end;

procedure TExclusiveMinimumTrait.Parse(const ANode: IJSONObject);
begin
  FHasExclusiveMinimum := ANode.ContainsKey('exclusiveMinimum');
  if FHasExclusiveMinimum then
    FExclusiveMinimum := (ANode.GetValue('exclusiveMinimum') as IJSONValue).AsFloat;
end;

function TExclusiveMinimumTrait.Validate(const ANode: IJSONElement; const APath: String;
  const AErrors: TList<TValidationError>): Boolean;
var
  LError: TValidationError;
  LValue: Double;
begin
  Result := True;
  if not FHasExclusiveMinimum then
    Exit;

  if not Supports(ANode, IJSONValue) or not ((ANode as IJSONValue).IsFloat or (ANode as IJSONValue).IsInteger) then
  begin
    LError.Path := APath;
    LError.Message := 'Expected number for exclusiveMinimum validation, found non-numeric value';
    LError.FoundValue := (ANode as IJSONValue).TypeName;
    LError.ExpectedValue := 'number';
    LError.Keyword := 'exclusiveMinimum';
    LError.LineNumber := -1;
    LError.ColumnNumber := -1;
    LError.Context := Format('Schema: {"exclusiveMinimum": %f}', [FExclusiveMinimum]);
    AErrors.Add(LError);
    Exit(False);
  end;

  LValue := (ANode as IJSONValue).AsFloat;
  if LValue <= FExclusiveMinimum then
  begin
    LError.Path := APath;
    LError.Message := Format('Value must be greater than %f, found %f', [FExclusiveMinimum, LValue]);
    LError.FoundValue := FloatToStr(LValue);
    LError.ExpectedValue := Format('> %f', [FExclusiveMinimum]);
    LError.Keyword := 'exclusiveMinimum';
    LError.LineNumber := -1;
    LError.ColumnNumber := -1;
    LError.Context := Format('Schema: {"exclusiveMinimum": %f}', [FExclusiveMinimum]);
    AErrors.Add(LError);
    Result := False;
  end;
end;

end.
