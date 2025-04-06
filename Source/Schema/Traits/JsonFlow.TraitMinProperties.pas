unit JsonFlow.TraitMinProperties;

interface

uses
  SysUtils,
  Generics.Collections,
  JsonFlow.Value,
  JsonFlow.Interfaces,
  JsonFlow.SchemaValidator;

type
  TMinPropertiesTrait = class(TJsonSchemaTrait)
  private
    FMinProperties: Integer;
    FHasMinProperties: Boolean;
  public
    constructor Create(const AValidator: TJSONSchemaValidator); override;
    destructor Destroy; override;
    procedure Parse(const ANode: IJSONObject); override;
    function Validate(const ANode: IJSONElement; const APath: String;
      const AErrors: TList<TValidationError>): Boolean; override;
  end;

implementation

constructor TMinPropertiesTrait.Create(const AValidator: TJSONSchemaValidator);
begin
  inherited Create(AValidator);

end;

destructor TMinPropertiesTrait.Destroy;
begin

  inherited;
end;

procedure TMinPropertiesTrait.Parse(const ANode: IJSONObject);
begin
  FHasMinProperties := ANode.ContainsKey('minProperties');
  if FHasMinProperties then
    FMinProperties := (ANode.GetValue('minProperties') as IJSONValue).AsInteger;
end;

function TMinPropertiesTrait.Validate(const ANode: IJSONElement; const APath: String;
  const AErrors: TList<TValidationError>): Boolean;
var
  LError: TValidationError;
  LObj: IJSONObject;
begin
  Result := True;
  if not FHasMinProperties then
    Exit;

  if not Supports(ANode, IJSONObject, LObj) then
  begin
    LError.Path := APath;
    LError.Message := 'Expected object for minProperties validation, found non-object';
    LError.FoundValue := (ANode as IJSONVAlue).TypeName;
    LError.ExpectedValue := 'object';
    LError.Keyword := 'minProperties';
    LError.LineNumber := -1;
    LError.ColumnNumber := -1;
    LError.Context := Format('Schema: {"minProperties": %d}', [FMinProperties]);
    AErrors.Add(LError);
    Exit(False);
  end;

  if LObj.Count < FMinProperties then
  begin
    LError.Path := APath;
    LError.Message := Format('Object must have at least %d properties, found %d', [FMinProperties, LObj.Count]);
    LError.FoundValue := IntToStr(LObj.Count);
    LError.ExpectedValue := Format('>= %d', [FMinProperties]);
    LError.Keyword := 'minProperties';
    LError.LineNumber := -1;
    LError.ColumnNumber := -1;
    LError.Context := Format('Schema: {"minProperties": %d}', [FMinProperties]);
    AErrors.Add(LError);
    Result := False;
  end;
end;

end.
