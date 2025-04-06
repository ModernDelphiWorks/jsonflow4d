                                                     unit JsonFlow.TraitMaxItems;

interface

uses
  SysUtils,
  Generics.Collections,
  JsonFlow.Value,
  JsonFlow.Interfaces,
  JsonFlow.SchemaValidator;

type
  TMaxItemsTrait = class(TJsonSchemaTrait)
  private
    FMaxItems: Integer;
    FHasMaxItems: Boolean;
  public
    constructor Create(const AValidator: TJSONSchemaValidator); override;
    destructor Destroy; override;
    procedure Parse(const ANode: IJSONObject); override;
    function Validate(const ANode: IJSONElement; const APath: String;
      const AErrors: TList<TValidationError>): Boolean; override;
  end;

implementation

constructor TMaxItemsTrait.Create(const AValidator: TJSONSchemaValidator);
begin
  inherited Create(AValidator);
end;

destructor TMaxItemsTrait.Destroy;
begin
  inherited;
end;

procedure TMaxItemsTrait.Parse(const ANode: IJSONObject);
begin
  FHasMaxItems := ANode.ContainsKey('maxItems');
  if FHasMaxItems then
    FMaxItems := (ANode.GetValue('maxItems') as IJSONValue).AsInteger;
end;

function TMaxItemsTrait.Validate(const ANode: IJSONElement; const APath: String; const AErrors: TList<TValidationError>): Boolean;
var
  LError: TValidationError;
  LArray: IJSONArray;
begin
  Result := True;
  FValidator.AddLog('TMaxItemsTrait.Validate started for ' + ANode.AsJSON + ' at ' + APath);

  if not FHasMaxItems then Exit;

  // Se não for um array, sai silenciosamente
  if not Supports(ANode, IJSONArray, LArray) then
  begin
    FValidator.AddLog('Skipping maxItems validation - not an array: ' + ANode.AsJSON);
    Exit;
  end;

  if LArray.Count > FMaxItems then
  begin
    LError.Path := APath;
    LError.Message := Format('Array must have at most %d items, found %d', [FMaxItems, LArray.Count]);
    LError.FoundValue := IntToStr(LArray.Count);
    LError.ExpectedValue := Format('<= %d', [FMaxItems]);
    LError.Keyword := 'maxItems';
    LError.LineNumber := -1;
    LError.ColumnNumber := -1;
    LError.Context := Format('Schema: {"maxItems": %d}', [FMaxItems]);
    AErrors.Add(LError);
    Result := False;
  end;
end;

end.
