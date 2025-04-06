unit JsonFlow.TraitMaximum;

interface

uses
  SysUtils,
  Generics.Collections,
  JsonFlow.Value,
  JsonFlow.Interfaces,
  JsonFlow.SchemaValidator;

type
  TMaximumTrait = class(TJsonSchemaTrait)
  private
    FMaximum: Double;
    FHasMaximum: Boolean;
  public
    constructor Create(const AValidator: TJSONSchemaValidator); override;
    destructor Destroy; override;
    procedure Parse(const ANode: IJSONObject); override;
    function Validate(const ANode: IJSONElement; const APath: String;
      const AErrors: TList<TValidationError>): Boolean; override;
  end;

implementation

constructor TMaximumTrait.Create(const AValidator: TJSONSchemaValidator);
begin
  inherited Create(AValidator);

end;

destructor TMaximumTrait.Destroy;
begin

  inherited;
end;

procedure TMaximumTrait.Parse(const ANode: IJSONObject);
begin
  FHasMaximum := ANode.ContainsKey('maximum');
  if FHasMaximum then
    FMaximum := (ANode.GetValue('maximum') as IJSONvalue).AsFloat;
end;

function TMaximumTrait.Validate(const ANode: IJSONElement; const APath: String;
  const AErrors: TList<TValidationError>): Boolean;
var
  LError: TValidationError;
  LValue: Double;
begin
  Result := True;
  if not FHasMaximum then
    Exit;

  if not Supports(ANode, IJSONValue) or not ((ANode as IJSONValue).IsFloat or (ANode as IJSONValue).IsInteger) then
  begin
    LError.Path := APath;
    LError.Message := 'Expected number for maximum validation, found non-numeric value';
    LError.FoundValue := (ANode as IJSONValue).TypeName;
    LError.ExpectedValue := 'number';
    LError.Keyword := 'maximum';
    LError.LineNumber := -1;
    LError.ColumnNumber := -1;
    LError.Context := Format('Schema: {"maximum": %f}', [FMaximum]);
    AErrors.Add(LError);
    Exit(False);
  end;

  LValue := (ANode as IJSONValue).AsFloat;
  if LValue > FMaximum then
  begin
    LError.Path := APath;
    LError.Message := Format('Value must be less than or equal to %f, found %f', [FMaximum, LValue]);
    LError.FoundValue := FloatToStr(LValue);
    LError.ExpectedValue := Format('<= %f', [FMaximum]);
    LError.Keyword := 'maximum';
    LError.LineNumber := -1;
    LError.ColumnNumber := -1;
    LError.Context := Format('Schema: {"maximum": %f}', [FMaximum]);
    AErrors.Add(LError);
    Result := False;
  end;
end;

end.
