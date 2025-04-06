unit JsonFlow.TraitDefs;

interface

uses
  SysUtils,
  Generics.Collections,
  JsonFlow.Value,
  JsonFlow.Interfaces,
  JsonFlow.SchemaValidator;

type
  TDefsTrait = class(TJsonSchemaTrait)
  public
    constructor Create(const AValidator: TJSONSchemaValidator); override;
    destructor Destroy; override;
    procedure Parse(const ANode: IJSONObject); override;
    function Validate(const ANode: IJSONElement; const APath: String;
      const AErrors: TList<TValidationError>): Boolean; override;
  end;

implementation

constructor TDefsTrait.Create(const AValidator: TJSONSchemaValidator);
begin
  inherited Create(AValidator);

end;

destructor TDefsTrait.Destroy;
begin

  inherited;
end;

procedure TDefsTrait.Parse(const ANode: IJSONObject);
begin
  // $defs is parsed into children, no additional action needed
end;

function TDefsTrait.Validate(const ANode: IJSONElement; const APath: String;
  const AErrors: TList<TValidationError>): Boolean;
begin
  Result := True; // $defs is for definitions, no direct validation
end;

end.
