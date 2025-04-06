unit JsonFlow.TraitPattern;

interface

uses
  SysUtils,
  Generics.Collections,
  JsonFlow.Value,
  JsonFlow.Interfaces,
  JsonFlow.SchemaValidator;

type
  TPatternTrait = class(TJsonSchemaTrait)
  private
    FPattern: String;
    FHasPattern: Boolean;
  public
    constructor Create(const AValidator: TJSONSchemaValidator); override;
    destructor Destroy; override;
    procedure Parse(const ANode: IJSONObject); override;
    function Validate(const ANode: IJSONElement; const APath: String;
      const AErrors: TList<TValidationError>): Boolean; override;
  end;

implementation

uses
  RegularExpressions;

constructor TPatternTrait.Create(const AValidator: TJSONSchemaValidator);
begin
  inherited Create(AValidator);

end;

destructor TPatternTrait.Destroy;
begin

  inherited;
end;

procedure TPatternTrait.Parse(const ANode: IJSONObject);
begin
  FHasPattern := ANode.ContainsKey('pattern');
  if FHasPattern then
    FPattern := (ANode.GetValue('pattern') as IJSONValue).AsString;
end;

function TPatternTrait.Validate(const ANode: IJSONElement; const APath: String;
  const AErrors: TList<TValidationError>): Boolean;
var
  LError: TValidationError;
  LValue: String;
  LJsonValue: IJSONValue;
begin
  Result := True;
  if not FHasPattern then
    Exit;

  if not Supports(ANode, IJSONValue, LJsonValue) then
  begin
    LError.Path := APath;
    LError.Message := 'Expected a value for pattern validation, found non-value type';
    LError.FoundValue := ANode.AsJSON;
    LError.ExpectedValue := 'string';
    LError.Keyword := 'pattern';
    LError.LineNumber := -1;
    LError.ColumnNumber := -1;
    LError.Context := Format('Schema: {"pattern": "%s"}', [FPattern]);
    AErrors.Add(LError);
    Exit(False);
  end;

  if not LJsonValue.IsString then
  begin
    LError.Path := APath;
    LError.Message := 'Expected string for pattern validation, found non-string value';
    LError.FoundValue := LJsonValue.TypeName;
    LError.ExpectedValue := 'string';
    LError.Keyword := 'pattern';
    LError.LineNumber := -1;
    LError.ColumnNumber := -1;
    LError.Context := Format('Schema: {"pattern": "%s"}', [FPattern]);
    AErrors.Add(LError);
    Exit(False);
  end;

  LValue := LJsonValue.AsString;
  if not TRegEx.IsMatch(FPattern, LValue) then
  begin
    LError.Path := APath;
    LError.Message := Format('String must match pattern "%s", found "%s"', [FPattern, LValue]);
    LError.FoundValue := LValue;
    LError.ExpectedValue := Format('matches "%s"', [FPattern]);
    LError.Keyword := 'pattern';
    LError.LineNumber := -1;
    LError.ColumnNumber := -1;
    LError.Context := Format('Schema: {"pattern": "%s"}', [FPattern]);
    AErrors.Add(LError);
    Result := False;
  end;
end;

end.
