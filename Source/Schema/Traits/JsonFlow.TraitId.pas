unit JsonFlow.TraitId;

interface

uses
  SysUtils,
  Generics.Collections,
  JsonFlow.Value,
  JsonFlow.Interfaces,
  JsonFlow.SchemaValidator;

type
  TIdTrait = class(TJsonSchemaTrait)
  private
    FId: String;
  public
    constructor Create(const AValidator: TJSONSchemaValidator); override;
    destructor Destroy; override;
    procedure Parse(const ANode: IJSONObject); override;
    function Validate(const ANode: IJSONElement; const APath: String;
      const AErrors: TList<TValidationError>): Boolean; override;
  end;

implementation

constructor TIdTrait.Create(const AValidator: TJSONSchemaValidator);
begin
  inherited Create(AValidator);
end;

destructor TIdTrait.Destroy;
begin

  inherited;
end;

procedure TIdTrait.Parse(const ANode: IJSONObject);
begin
  if ANode.ContainsKey('$id') then
    FId := (ANode.GetValue('$id') as IJSONvalue).AsString
  else
    FId := '';
end;

function TIdTrait.Validate(const ANode: IJSONElement; const APath: String;
  const AErrors: TList<TValidationError>): Boolean;
begin
  Result := True;
end;

end.
