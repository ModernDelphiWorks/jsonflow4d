unit JsonFlow.TraitReadOnly;

interface

uses
  SysUtils,
  Generics.Collections,
  JsonFlow.Value,
  JsonFlow.Interfaces,
  JsonFlow.SchemaValidator;

type
  TReadOnlyTrait = class(TJsonSchemaTrait)
  private
    FReadOnly: Boolean;
    FHasReadOnly: Boolean;
  public
    constructor Create(const AValidator: TJSONSchemaValidator); override;
    destructor Destroy; override;
    procedure Parse(const ANode: IJSONObject); override;
    function Validate(const ANode: IJSONElement; const APath: String; const AErrors: TList<TValidationError>): Boolean; override;
  end;

implementation

constructor TReadOnlyTrait.Create(const AValidator: TJSONSchemaValidator);
begin
  inherited Create(AValidator);

end;

destructor TReadOnlyTrait.Destroy;
begin

  inherited;
end;

procedure TReadOnlyTrait.Parse(const ANode: IJSONObject);
begin
  FHasReadOnly := ANode.ContainsKey('readOnly');
  if FHasReadOnly then
    FReadOnly := (ANode.GetValue('readOnly') as IJSONValue).AsBoolean;
end;

function TReadOnlyTrait.Validate(const ANode: IJSONElement; const APath: String;
  const AErrors: TList<TValidationError>): Boolean;
begin
  Result := True;
end;

end.
