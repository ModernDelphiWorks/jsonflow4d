unit JsonFlow.TraitMinimum;

interface

uses
  SysUtils,
  Generics.Collections,
  JsonFlow.Value,
  JsonFlow.Interfaces,
  JsonFlow.SchemaValidator;

type
  TMinimumTrait = class(TJsonSchemaTrait)
  private
    FMinimum: Double;
    FHasMinimum: Boolean;
  public
    constructor Create(const AValidator: TJSONSchemaValidator); override;
    destructor Destroy; override;
    procedure Parse(const ANode: IJSONObject); override;
    function Validate(const ANode: IJSONElement; const APath: String;
      const AErrors: TList<TValidationError>): Boolean; override;
  end;

implementation

constructor TMinimumTrait.Create(const AValidator: TJSONSchemaValidator);
begin
  inherited Create(AValidator);
  FHasMinimum := False;
  FMinimum := 0;
end;

destructor TMinimumTrait.Destroy;
begin
  inherited;
end;

procedure TMinimumTrait.Parse(const ANode: IJSONObject);
var
  LValue: IJSONValue;
begin
  FValidator.AddLog('TMinimumTrait.Parse started with node: ' + ANode.AsJSON);
  FHasMinimum := False;

  // Usa FNode.Value, que é o valor do "minimum" (ex.: 0)
  if Assigned(FNode) and Supports(FNode.Value, IJSONValue, LValue) and (LValue.IsFloat or LValue.IsInteger) then
  begin
    FMinimum := LValue.AsFloat;
    FHasMinimum := True;
    FValidator.AddLog('TMinimumTrait.Parse: FMinimum set to: ' + FloatToStr(FMinimum));
  end
  else
    FValidator.AddLog('TMinimumTrait.Parse: No valid "minimum" value found in FNode.Value');
end;

function TMinimumTrait.Validate(const ANode: IJSONElement; const APath: String;
  const AErrors: TList<TValidationError>): Boolean;
var
  LError: TValidationError;
  LValue: Double;
begin
  FValidator.AddLog('-TMinimumTrait.Validate-');

  FValidator.AddLog('TMinimumTrait.Validate started for ' + ANode.AsJSON + ' at ' + APath);
  Result := True;

  if not FHasMinimum then
  begin
    FValidator.AddLog('TMinimumTrait.Validate: No minimum defined, skipping validation');
    Exit;
  end;

  if (not Supports(ANode, IJSONValue)) or (not (ANode as IJSONValue).IsFloat) and (not (ANode as IJSONValue).IsInteger) then
  begin
    LError.Path := APath;
    LError.Message := 'Expected number for minimum validation, found non-numeric value';
    LError.FoundValue := ANode.AsJSON;
    LError.ExpectedValue := 'number';
    LError.Keyword := 'minimum';
    LError.LineNumber := -1;
    LError.ColumnNumber := -1;
    LError.Context := Format('Schema: {"minimum": %f}', [FMinimum]);
    AErrors.Add(LError);
    FValidator.AddLog('TMinimumTrait.Validate: Non-numeric value found');
    Result := False;
  end
  else
  begin
    LValue := (ANode as IJSONValue).AsFloat;
    if LValue < FMinimum then
    begin
      LError.Path := APath;
      LError.Message := Format('Value %f is less than minimum %f', [LValue, FMinimum]);
      LError.FoundValue := FloatToStr(LValue);
      LError.ExpectedValue := Format('>= %f', [FMinimum]);
      LError.Keyword := 'minimum';
      LError.LineNumber := -1;
      LError.ColumnNumber := -1;
      LError.Context := Format('Schema: {"minimum": %f}', [FMinimum]);
      AErrors.Add(LError);
      FValidator.AddLog('TMinimumTrait.Validate: Value ' + FloatToStr(LValue) + ' < minimum ' + FloatToStr(FMinimum));
      Result := False;
    end
    else
      FValidator.AddLog('TMinimumTrait.Validate: Value ' + FloatToStr(LValue) + ' >= minimum ' + FloatToStr(FMinimum));
  end;

  FValidator.AddLog('TMinimumTrait.Validate finished: ' + BoolToStr(Result, True));
end;

end.
