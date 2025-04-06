unit JsonFlow.TraitThen;

interface

uses
  SysUtils,
  Generics.Collections,
  JsonFlow.Value,
  JsonFlow.Interfaces,
  JsonFlow.SchemaValidator;

type
  TThenTrait = class(TJsonSchemaTrait)
  private
    FThenSchema: TSchemaNode;
  public
    constructor Create(const AValidator: TJSONSchemaValidator); override;
    destructor Destroy; override;
    procedure Parse(const ANode: IJSONObject); override;
    function Validate(const ANode: IJSONElement; const APath: String;
      const AErrors: TList<TValidationError>): Boolean; override;
  end;

implementation

constructor TThenTrait.Create(const AValidator: TJSONSchemaValidator);
begin
  inherited Create(AValidator);

end;

destructor TThenTrait.Destroy;
begin
  FThenSchema.Free;
  inherited;
end;

procedure TThenTrait.Parse(const ANode: IJSONObject);
begin
  if ANode.ContainsKey('then') then
    FThenSchema := FValidator.ParseNode(ANode.GetValue('then'), '/then');
end;

function TThenTrait.Validate(const ANode: IJSONElement; const APath: String;
  const AErrors: TList<TValidationError>): Boolean;
begin
  Result := True;
  if Assigned(FThenSchema) then
    Result := FThenSchema.Trait.Validate(ANode, APath, AErrors);
end;

end.
