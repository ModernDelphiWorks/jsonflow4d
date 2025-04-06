unit JsonFlow.TraitDeprecated;

interface

uses
  SysUtils,
  Generics.Collections,
  JsonFlow.Value,
  JsonFlow.Interfaces,
  JsonFlow.SchemaValidator;

type
  TDeprecatedTrait = class(TJsonSchemaTrait)
  private
    FDeprecated: Boolean;
    FHasDeprecated: Boolean;
  public
    constructor Create(const AValidator: TJSONSchemaValidator); override;
    destructor Destroy; override;
    procedure Parse(const ANode: IJSONObject); override;
    function Validate(const ANode: IJSONElement; const APath: String;
      const AErrors: TList<TValidationError>): Boolean; override;
  end;

implementation

constructor TDeprecatedTrait.Create(const AValidator: TJSONSchemaValidator);
begin
  inherited Create(AValidator);

end;

destructor TDeprecatedTrait.Destroy;
begin

  inherited;
end;

procedure TDeprecatedTrait.Parse(const ANode: IJSONObject);
begin
  FHasDeprecated := ANode.ContainsKey('deprecated');
  if FHasDeprecated then
    FDeprecated := (ANode.GetValue('deprecated') as IJSONValue).AsBoolean;
end;

function TDeprecatedTrait.Validate(const ANode: IJSONElement; const APath: String;
  const AErrors: TList<TValidationError>): Boolean;
begin
  Result := True;
end;

end.
