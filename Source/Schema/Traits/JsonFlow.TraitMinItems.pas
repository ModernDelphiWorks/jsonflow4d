unit JsonFlow.TraitMinItems;

interface

uses
  SysUtils,
  Generics.Collections,
  JsonFlow.Value,
  JsonFlow.Interfaces,
  JsonFlow.SchemaValidator;

type
  TMinItemsTrait = class(TJsonSchemaTrait)
  private
    FMinItems: Integer;
    FHasMinItems: Boolean;
  public
    constructor Create(const AValidator: TJSONSchemaValidator); override;
    destructor Destroy; override;
    procedure Parse(const ANode: IJSONObject); override;
    function Validate(const ANode: IJSONElement; const APath: String;
      const AErrors: TList<TValidationError>): Boolean; override;
  end;

implementation

constructor TMinItemsTrait.Create(const AValidator: TJSONSchemaValidator);
begin
  inherited Create(AValidator);
end;

destructor TMinItemsTrait.Destroy;
begin
  inherited;
end;

procedure TMinItemsTrait.Parse(const ANode: IJSONObject);
begin
  FHasMinItems := ANode.ContainsKey('minItems');
  if FHasMinItems then
    FMinItems := (ANode.GetValue('minItems') as IJSONValue).AsInteger;
end;

function TMinItemsTrait.Validate(const ANode: IJSONElement; const APath: String; const AErrors: TList<TValidationError>): Boolean;
var
  LError: TValidationError;
  LArray: IJSONArray;
begin
  Result := True;
  FValidator.AddLog('TMinItemsTrait.Validate started for ' + ANode.AsJSON + ' at ' + APath);

  if not FHasMinItems then Exit;

  // Se não for um array, sai silenciosamente
  if not Supports(ANode, IJSONArray, LArray) then
  begin
    FValidator.AddLog('Skipping minItems validation - not an array: ' + ANode.AsJSON);
    Exit;
  end;

  if LArray.Count < FMinItems then
  begin
    LError.Path := APath;
    LError.Message := Format('Array must have at least %d items, found %d', [FMinItems, LArray.Count]);
    LError.FoundValue := IntToStr(LArray.Count);
    LError.ExpectedValue := Format('>= %d', [FMinItems]);
    LError.Keyword := 'minItems';
    LError.LineNumber := -1;
    LError.ColumnNumber := -1;
    LError.Context := Format('Schema: {"minItems": %d}', [FMinItems]);
    AErrors.Add(LError);
    Result := False;
  end;
end;

end.
