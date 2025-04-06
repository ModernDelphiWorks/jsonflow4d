unit JsonFlow.TraitPropertyNames;

interface

uses
  SysUtils,
  Generics.Collections,
  JsonFlow.Value,
  JsonFlow.Interfaces, JsonFlow.SchemaValidator;

type
  TPropertyNamesTrait = class(TJsonSchemaTrait)
  private
    FPropertyNamesSchema: TSchemaNode;
  public
    constructor Create(const AValidator: TJSONSchemaValidator); override;
    destructor Destroy; override;
    procedure Parse(const ANode: IJSONObject); override;
    function Validate(const ANode: IJSONElement; const APath: String;
      const AErrors: TList<TValidationError>): Boolean; override;
  end;

implementation

constructor TPropertyNamesTrait.Create(const AValidator: TJSONSchemaValidator);
begin
  inherited Create(AValidator);

end;

destructor TPropertyNamesTrait.Destroy;
begin
  if Assigned(FPropertyNamesSchema) then
    FPropertyNamesSchema.Free;;
  inherited;
end;

procedure TPropertyNamesTrait.Parse(const ANode: IJSONObject);
begin
  if ANode.ContainsKey('propertyNames') then
    FPropertyNamesSchema := FValidator.ParseNode(ANode.GetValue('propertyNames'), '/propertyNames');
end;

function TPropertyNamesTrait.Validate(const ANode: IJSONElement; const APath: String;
  const AErrors: TList<TValidationError>): Boolean;
var
  LObj: IJSONObject;
  LPair: IJSONPair;
  LNameValue: IJSONValue;
begin
  Result := True;
  if not Assigned(FPropertyNamesSchema) then
    Exit;

  if not Supports(ANode, IJSONObject, LObj) then
    Exit;

  for LPair in LObj.Pairs do
  begin
    LNameValue := TJSONValueString.Create(LPair.Key);
    try
      if not FPropertyNamesSchema.Trait.Validate(LNameValue, APath + '/' + LPair.Key, AErrors) then
        Result := False;
    finally
      LNameValue := nil;
    end;
  end;
end;

end.
