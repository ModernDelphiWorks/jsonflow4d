unit JsonFlow.TraitDescription;

interface

uses
  SysUtils,
  Generics.Collections,
  JsonFlow.Value,
  JsonFlow.Interfaces,
  JsonFlow.SchemaValidator;

type
  TDescriptionTrait = class(TJsonSchemaTrait)
  private
    FDescription: String;
  public
    constructor Create(const AValidator: TJSONSchemaValidator); override;
    destructor Destroy; override;
    procedure Parse(const ANode: IJSONObject); override;
    function Validate(const ANode: IJSONElement; const APath: String;
      const AErrors: TList<TValidationError>): Boolean; override;
  end;

implementation

constructor TDescriptionTrait.Create(const AValidator: TJSONSchemaValidator);
begin
  inherited Create(AValidator);

end;

destructor TDescriptionTrait.Destroy;
begin

  inherited;
end;

procedure TDescriptionTrait.Parse(const ANode: IJSONObject);
begin
  if ANode.ContainsKey('description') then
    FDescription := (ANode.GetValue('description') as IJSONValue).AsString
  else
    FDescription := '';
end;

function TDescriptionTrait.Validate(const ANode: IJSONElement; const APath: String;
  const AErrors: TList<TValidationError>): Boolean;
begin
  Result := True;
end;

end.
