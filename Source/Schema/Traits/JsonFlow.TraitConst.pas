unit JsonFlow.TraitConst;

interface

uses
  SysUtils,
  Generics.Collections,
  JsonFlow.Value,
  JsonFlow.Interfaces,
  JsonFlow.SchemaValidator;

type
  TConstTrait = class(TJsonSchemaTrait)
  private
    FConstValue: IJSONElement;
  public
    constructor Create(const AValidator: TJSONSchemaValidator); override;
    destructor Destroy; override;
    procedure Parse(const ANode: IJSONObject); override;
    function Validate(const ANode: IJSONElement; const APath: String;
      const AErrors: TList<TValidationError>): Boolean; override;
  end;

implementation

constructor TConstTrait.Create(const AValidator: TJSONSchemaValidator);
begin
  inherited Create(AValidator);

end;

destructor TConstTrait.Destroy;
begin
  FConstValue := nil;
  inherited;
end;

procedure TConstTrait.Parse(const ANode: IJSONObject);
begin
  if ANode.ContainsKey('const') then
    FConstValue := ANode.GetValue('const');
end;

function TConstTrait.Validate(const ANode: IJSONElement; const APath: String;
  const AErrors: TList<TValidationError>): Boolean;
var
  LError: TValidationError;
begin
  Result := True;
  if not Assigned(FConstValue) then
    Exit;

  if ANode.AsJSON <> FConstValue.AsJSON then
  begin
    LError.Path := APath;
    LError.Message := Format('Value must be equal to constant %s, found %s', [FConstValue.AsJSON, ANode.AsJSON]);
    LError.FoundValue := ANode.AsJSON;
    LError.ExpectedValue := FConstValue.AsJSON;
    LError.Keyword := 'const';
    LError.LineNumber := -1;
    LError.ColumnNumber := -1;
    LError.Context := Format('Schema: {"const": %s}', [FConstValue.AsJSON]);
    AErrors.Add(LError);
    Result := False;
  end;
end;

end.
