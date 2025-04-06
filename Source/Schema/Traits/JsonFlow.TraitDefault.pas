unit JsonFlow.TraitDefault;

interface

uses
  SysUtils,
  Generics.Collections,
  JsonFlow.Value,
  JsonFlow.Interfaces,
  JsonFlow.SchemaValidator;

type
  TDefaultTrait = class(TJsonSchemaTrait)
  private
    FDefaultValue: IJSONElement;
  public
    constructor Create(const AValidator: TJSONSchemaValidator); override;
    destructor Destroy; override;
    procedure Parse(const ANode: IJSONObject); override;
    function Validate(const ANode: IJSONElement; const APath: String;
      const AErrors: TList<TValidationError>): Boolean; override;
  end;

implementation

constructor TDefaultTrait.Create(const AValidator: TJSONSchemaValidator);
begin
  inherited Create(AValidator);

end;

destructor TDefaultTrait.Destroy;
begin
  FDefaultValue := nil;
  inherited;
end;

procedure TDefaultTrait.Parse(const ANode: IJSONObject);
begin
  if ANode.ContainsKey('default') then
    FDefaultValue := ANode.GetValue('default');
end;

function TDefaultTrait.Validate(const ANode: IJSONElement; const APath: String;
  const AErrors: TList<TValidationError>): Boolean;
begin
  Result := True;
end;

end.
