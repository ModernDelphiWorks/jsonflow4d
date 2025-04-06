unit JsonFlow.TraitContentenCoding;

interface

uses
  SysUtils,
  Generics.Collections,
  JsonFlow.Value,
  JsonFlow.Interfaces,
  JsonFlow.SchemaValidator;

type
  TContentEncodingTrait = class(TJsonSchemaTrait)
  private
    FContentEncoding: String;
    FHasContentEncoding: Boolean;
  public
    constructor Create(const AValidator: TJSONSchemaValidator); override;
    destructor Destroy; override;
    procedure Parse(const ANode: IJSONObject); override;
    function Validate(const ANode: IJSONElement; const APath: String;
      const AErrors: TList<TValidationError>): Boolean; override;
  end;

implementation

constructor TContentEncodingTrait.Create(const AValidator: TJSONSchemaValidator);
begin
  inherited Create(AValidator);

end;

destructor TContentEncodingTrait.Destroy;
begin

  inherited;
end;

procedure TContentEncodingTrait.Parse(const ANode: IJSONObject);
begin
  FHasContentEncoding := ANode.ContainsKey('contentEncoding');
  if FHasContentEncoding then
    FContentEncoding := (ANode.GetValue('contentEncoding') as IJSONValue).AsString;
end;

function TContentEncodingTrait.Validate(const ANode: IJSONElement; const APath: String;
  const AErrors: TList<TValidationError>): Boolean;
begin
  Result := True;
end;

end.
