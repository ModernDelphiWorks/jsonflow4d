unit JsonFlow.TraitWriteOnly;

interface

uses
  SysUtils,
  Generics.Collections,
  JsonFlow.Value,
  JsonFlow.Interfaces,
  JsonFlow.SchemaValidator;

type
  TWriteOnlyTrait = class(TJsonSchemaTrait)
  private
    FWriteOnly: Boolean;
    FHasWriteOnly: Boolean;
  public
    constructor Create(const AValidator: TJSONSchemaValidator); override;
    destructor Destroy; override;
    procedure Parse(const ANode: IJSONObject); override;
    function Validate(const ANode: IJSONElement; const APath: String;
      const AErrors: TList<TValidationError>): Boolean; override;
  end;

implementation

constructor TWriteOnlyTrait.Create(const AValidator: TJSONSchemaValidator);
begin
  inherited Create(AValidator);

end;

destructor TWriteOnlyTrait.Destroy;
begin

  inherited;
end;

procedure TWriteOnlyTrait.Parse(const ANode: IJSONObject);
begin
  FHasWriteOnly := ANode.ContainsKey('writeOnly');
  if FHasWriteOnly then
    FWriteOnly := (ANode.GetValue('writeOnly') as IJSONValue).AsBoolean;
end;

function TWriteOnlyTrait.Validate(const ANode: IJSONElement; const APath: String;
  const AErrors: TList<TValidationError>): Boolean;
begin
  Result := True;
end;

end.
