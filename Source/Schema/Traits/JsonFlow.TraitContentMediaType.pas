unit JsonFlow.TraitContentMediaType;

interface

uses
  SysUtils,
  Generics.Collections,
  JsonFlow.Value,
  JsonFlow.Interfaces,
  JsonFlow.SchemaValidator;

type
  TContentMediaTypeTrait = class(TJsonSchemaTrait)
  private
    FContentMediaType: String;
    FHasContentMediaType: Boolean;
  public
    constructor Create(const AValidator: TJSONSchemaValidator); override;
    destructor Destroy; override;
    procedure Parse(const ANode: IJSONObject); override;
    function Validate(const ANode: IJSONElement; const APath: String;
      const AErrors: TList<TValidationError>): Boolean; override;
  end;

implementation

constructor TContentMediaTypeTrait.Create(const AValidator: TJSONSchemaValidator);
begin
  inherited Create(AValidator);

end;

destructor TContentMediaTypeTrait.Destroy;
begin

  inherited;
end;

procedure TContentMediaTypeTrait.Parse(const ANode: IJSONObject);
begin
  FHasContentMediaType := ANode.ContainsKey('contentMediaType');
  if FHasContentMediaType then
    FContentMediaType := (ANode.GetValue('contentMediaType') as IJSONValue).AsString;
end;

function TContentMediaTypeTrait.Validate(const ANode: IJSONElement; const APath: String;
  const AErrors: TList<TValidationError>): Boolean;
begin
  Result := True;
end;

end.
