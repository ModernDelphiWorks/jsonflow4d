unit JsonFlow.TraitExclusiveMaximum;

interface

uses
  SysUtils,
  Generics.Collections,
  JsonFlow.Value,
  JsonFlow.Interfaces,
  JsonFlow.SchemaValidator;

type
  TExclusiveMaximumTrait = class(TJsonSchemaTrait)
  private
    FExclusiveMaximum: Double;
    FHasExclusiveMaximum: Boolean;
  public
    constructor Create(const AValidator: TJSONSchemaValidator); override;
    destructor Destroy; override;
    procedure Parse(const ANode: IJSONObject); override;
    function Validate(const ANode: IJSONElement; const APath: String;
      const AErrors: TList<TValidationError>): Boolean; override;
  end;

implementation

constructor TExclusiveMaximumTrait.Create(const AValidator: TJSONSchemaValidator);
begin
  inherited Create(AValidator);

end;

destructor TExclusiveMaximumTrait.Destroy;
begin

  inherited;
end;

procedure TExclusiveMaximumTrait.Parse(const ANode: IJSONObject);
begin
  FHasExclusiveMaximum := ANode.ContainsKey('exclusiveMaximum');
  if FHasExclusiveMaximum then
    FExclusiveMaximum := (ANode.GetValue('exclusiveMaximum') as IJSONValue).AsFloat;
end;

function TExclusiveMaximumTrait.Validate(const ANode: IJSONElement; const APath: String;
  const AErrors: TList<TValidationError>): Boolean;
var
  LError: TValidationError;
  LValue: Double;
begin
  Result := True;
  if not FHasExclusiveMaximum then
    Exit;

  if not Supports(ANode, IJSONValue) or not ((ANode as IJSONvalue).IsFloat or (ANode as IJSONValue).IsInteger) then
  begin
    LError.Path := APath;
    LError.Message := 'Expected number for exclusiveMaximum validation, found non-numeric value';
    LError.FoundValue := (ANode as IJSONValue).TypeName;
    LError.ExpectedValue := 'number';
    LError.Keyword := 'exclusiveMaximum';
    LError.LineNumber := -1;
    LError.ColumnNumber := -1;
    LError.Context := Format('Schema: {"exclusiveMaximum": %f}', [FExclusiveMaximum]);
    AErrors.Add(LError);
    Exit(False);
  end;

  LValue := (ANode as IJSONValue).AsFloat;
  if LValue >= FExclusiveMaximum then
  begin
    LError.Path := APath;
    LError.Message := Format('Value must be less than %f, found %f', [FExclusiveMaximum, LValue]);
    LError.FoundValue := FloatToStr(LValue);
    LError.ExpectedValue := Format('< %f', [FExclusiveMaximum]);
    LError.Keyword := 'exclusiveMaximum';
    LError.LineNumber := -1;
    LError.ColumnNumber := -1;
    LError.Context := Format('Schema: {"exclusiveMaximum": %f}', [FExclusiveMaximum]);
    AErrors.Add(LError);
    Result := False;
  end;
end;

end.
