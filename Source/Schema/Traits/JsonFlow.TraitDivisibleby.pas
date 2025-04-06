unit JsonFlow.TraitDivisibleby;

interface

uses
  SysUtils,
  Generics.Collections,
  JsonFlow.Value,
  JsonFlow.Interfaces,
  JsonFlow.SchemaValidator;

type
  TDivisibleByTrait = class(TJsonSchemaTrait)
  private
    FDivisibleBy: Double;
    FHasDivisibleBy: Boolean;
  public
    constructor Create(const AValidator: TJSONSchemaValidator); override;
    destructor Destroy; override;
    procedure Parse(const ANode: IJSONObject); override;
    function Validate(const ANode: IJSONElement; const APath: String;
      const AErrors: TList<TValidationError>): Boolean; override;
  end;

implementation

constructor TDivisibleByTrait.Create(const AValidator: TJSONSchemaValidator);
begin
  inherited Create(AValidator);

end;

destructor TDivisibleByTrait.Destroy;
begin

  inherited;
end;

procedure TDivisibleByTrait.Parse(const ANode: IJSONObject);
begin
  FHasDivisibleBy := ANode.ContainsKey('divisibleBy');
  if FHasDivisibleBy then
    FDivisibleBy := (ANode.GetValue('divisibleBy') as IJSONValue).AsFloat;
end;

function TDivisibleByTrait.Validate(const ANode: IJSONElement; const APath: String;
  const AErrors: TList<TValidationError>): Boolean;
var
  LError: TValidationError;
  LValue: Double;
begin
  Result := True;
  if not FHasDivisibleBy then
    Exit;

  if not Supports(ANode, IJSONValue) or not ((ANode as IJSONValue).IsFloat or (ANode as IJSONValue).IsInteger) then
  begin
    LError.Path := APath;
    LError.Message := 'Expected number for divisibleBy validation, found non-numeric value';
    LError.FoundValue := (ANode as IJSONValue).TypeName;
    LError.ExpectedValue := 'number';
    LError.Keyword := 'divisibleBy';
    LError.LineNumber := -1;
    LError.ColumnNumber := -1;
    LError.Context := Format('Schema: {"divisibleBy": %f}', [FDivisibleBy]);
    AErrors.Add(LError);
    Exit(False);
  end;

  LValue := (ANode as IJSONValue).AsFloat;
  if (FDivisibleBy > 0) and (Frac(LValue / FDivisibleBy) <> 0) then
  begin
    LError.Path := APath;
    LError.Message := Format('Value must be divisible by %f, found %f', [FDivisibleBy, LValue]);
    LError.FoundValue := FloatToStr(LValue);
    LError.ExpectedValue := Format('divisible by %f', [FDivisibleBy]);
    LError.Keyword := 'divisibleBy';
    LError.LineNumber := -1;
    LError.ColumnNumber := -1;
    LError.Context := Format('Schema: {"divisibleBy": %f}', [FDivisibleBy]);
    AErrors.Add(LError);
    Result := False;
  end;
end;

end.
