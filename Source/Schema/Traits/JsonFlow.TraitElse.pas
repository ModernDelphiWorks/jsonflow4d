unit JsonFlow.TraitElse;

interface

uses
  SysUtils,
  Generics.Collections,
  JsonFlow.Value,
  JsonFlow.Interfaces,
  JsonFlow.SchemaValidator;

type
  TElseTrait = class(TJsonSchemaTrait)
  private
    FElseSchema: TSchemaNode;
  public
    constructor Create(const AValidator: TJSONSchemaValidator); override;
    destructor Destroy; override;
    procedure Parse(const ANode: IJSONObject); override;
    function Validate(const ANode: IJSONElement; const APath: String;
      const AErrors: TList<TValidationError>): Boolean; override;
  end;

implementation

constructor TElseTrait.Create(const AValidator: TJSONSchemaValidator);
begin
  inherited Create(AValidator);

end;

destructor TElseTrait.Destroy;
begin
  FElseSchema.Free;
  inherited;
end;

procedure TElseTrait.Parse(const ANode: IJSONObject);
begin
  if ANode.ContainsKey('else') then
    FElseSchema := FValidator.ParseNode(ANode.GetValue('else'), '/else');
end;

function TElseTrait.Validate(const ANode: IJSONElement; const APath: String;
  const AErrors: TList<TValidationError>): Boolean;
begin
  Result := True;
  if Assigned(FElseSchema) then
    Result := FElseSchema.Trait.Validate(ANode, APath, AErrors);
end;

end.
