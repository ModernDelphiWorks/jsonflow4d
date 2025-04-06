unit JsonFlow.TraitMaxProperties;

interface

uses
  SysUtils,
  Generics.Collections,
  JsonFlow.Value,
  JsonFlow.Interfaces,
  JsonFlow.SchemaValidator;

type
  TMaxPropertiesTrait = class(TJsonSchemaTrait)
  private
    FMaxProperties: Integer;
    FHasMaxProperties: Boolean;
  public
    constructor Create(const AValidator: TJSONSchemaValidator); override;
    destructor Destroy; override;
    procedure Parse(const ANode: IJSONObject); override;
    function Validate(const ANode: IJSONElement; const APath: String;
      const AErrors: TList<TValidationError>): Boolean; override;
  end;

implementation

constructor TMaxPropertiesTrait.Create(const AValidator: TJSONSchemaValidator);
begin
  inherited Create(AValidator);

end;

destructor TMaxPropertiesTrait.Destroy;
begin

  inherited;
end;

procedure TMaxPropertiesTrait.Parse(const ANode: IJSONObject);
begin
  FHasMaxProperties := ANode.ContainsKey('maxProperties');
  if FHasMaxProperties then
    FMaxProperties := (ANode.GetValue('maxProperties') as IJSONValue).AsInteger;
end;

function TMaxPropertiesTrait.Validate(const ANode: IJSONElement; const APath: String;
  const AErrors: TList<TValidationError>): Boolean;
var
  LError: TValidationError;
  LObj: IJSONObject;
begin
  Result := True;
  if not FHasMaxProperties then
    Exit;

  if not Supports(ANode, IJSONObject, LObj) then
  begin
    LError.Path := APath;
    LError.Message := 'Expected object for maxProperties validation, found non-object';
    LError.FoundValue := (ANode as IJSONValue).TypeName;
    LError.ExpectedValue := 'object';
    LError.Keyword := 'maxProperties';
    LError.LineNumber := -1;
    LError.ColumnNumber := -1;
    LError.Context := Format('Schema: {"maxProperties": %d}', [FMaxProperties]);
    AErrors.Add(LError);
    Exit(False);
  end;

  if LObj.Count > FMaxProperties then
  begin
    LError.Path := APath;
    LError.Message := Format('Object must have at most %d properties, found %d', [FMaxProperties, LObj.Count]);
    LError.FoundValue := IntToStr(LObj.Count);
    LError.ExpectedValue := Format('<= %d', [FMaxProperties]);
    LError.Keyword := 'maxProperties';
    LError.LineNumber := -1;
    LError.ColumnNumber := -1;
    LError.Context := Format('Schema: {"maxProperties": %d}', [FMaxProperties]);
    AErrors.Add(LError);
    Result := False;
  end;
end;

end.
