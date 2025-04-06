unit JsonFlow.TraitContentSchema;

interface

uses
  SysUtils,
  Generics.Collections,
  JsonFlow.Value,
  JsonFlow.Interfaces,
  JsonFlow.SchemaValidator;

type
  TContentSchemaTrait = class(TJsonSchemaTrait)
  private
    FContentSchema: TSchemaNode;
  public
    constructor Create(const AValidator: TJSONSchemaValidator); override;
    destructor Destroy; override;
    procedure Parse(const ANode: IJSONObject); override;
    function Validate(const ANode: IJSONElement; const APath: String; const AErrors: TList<TValidationError>): Boolean; override;
  end;

implementation

constructor TContentSchemaTrait.Create(const AValidator: TJSONSchemaValidator);
begin
  inherited Create(AValidator);

end;

destructor TContentSchemaTrait.Destroy;
begin
  FContentSchema.Free;
  inherited;
end;

procedure TContentSchemaTrait.Parse(const ANode: IJSONObject);
begin
  if ANode.ContainsKey('contentSchema') then
    FContentSchema := FValidator.ParseNode(ANode.GetValue('contentSchema'), '/contentSchema');
end;

function TContentSchemaTrait.Validate(const ANode: IJSONElement; const APath: String;
  const AErrors: TList<TValidationError>): Boolean;
begin
  Result := True;
  if Assigned(FContentSchema) then
    Result := FContentSchema.Trait.Validate(ANode, APath, AErrors);
end;

end.
