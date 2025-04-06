unit JsonFlow.TraitSchema;

interface

uses
  SysUtils,
  Generics.Collections,
  JsonFlow.Value,
  JsonFlow.Interfaces,
  JsonFlow.SchemaValidator;

type
  TSchemaTrait = class(TJsonSchemaTrait)
  private
    FSchema: String;
  public
    constructor Create(const AValidator: TJSONSchemaValidator); override;
    destructor Destroy; override;
    procedure Parse(const ANode: IJSONObject); override;
    function Validate(const ANode: IJSONElement; const APath: String;
      const AErrors: TList<TValidationError>): Boolean; override;
  end;

implementation

constructor TSchemaTrait.Create(const AValidator: TJSONSchemaValidator);
begin
  inherited Create(AValidator);
end;

destructor TSchemaTrait.Destroy;
begin

  inherited;
end;

procedure TSchemaTrait.Parse(const ANode: IJSONObject);
begin
  if ANode.ContainsKey('$schema') then
    FSchema := (ANode.GetValue('$schema') as IJSONValue).AsString
  else
    FSchema := '';
end;

function TSchemaTrait.Validate(const ANode: IJSONElement; const APath: String;
  const AErrors: TList<TValidationError>): Boolean;
begin
  Result := True;
end;

end.
