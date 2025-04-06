unit JsonFlow.TraitAnchor;

interface

uses
  SysUtils,
  Generics.Collections,
  JsonFlow.Value,
  JsonFlow.Interfaces,
  JsonFlow.SchemaValidator;

type
  TAnchorTrait = class(TJsonSchemaTrait)
  private
    FAnchor: String;
  public
    constructor Create(const AValidator: TJSONSchemaValidator); override;
    destructor Destroy; override;
    procedure Parse(const ANode: IJSONObject); override;
    function Validate(const ANode: IJSONElement; const APath: String;
      const AErrors: TList<TValidationError>): Boolean; override;
  end;

implementation

constructor TAnchorTrait.Create(const AValidator: TJSONSchemaValidator);
begin
  inherited Create(AValidator);

end;

destructor TAnchorTrait.Destroy;
begin

  inherited;
end;

procedure TAnchorTrait.Parse(const ANode: IJSONObject);
begin
  if ANode.ContainsKey('$anchor') then
    FAnchor := (ANode.GetValue('$anchor') as IJSONValue).AsString
  else
    FAnchor := '';
end;

function TAnchorTrait.Validate(const ANode: IJSONElement; const APath: String;
  const AErrors: TList<TValidationError>): Boolean;
begin
  Result := True;
end;

end.
