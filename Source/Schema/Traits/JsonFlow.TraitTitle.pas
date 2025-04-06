unit JsonFlow.TraitTitle;

interface

uses
  SysUtils,
  Generics.Collections,
  JsonFlow.Value,
  JsonFlow.Interfaces,
  JsonFlow.SchemaValidator;

type
  TTitleTrait = class(TJsonSchemaTrait)
  private
    FTitle: String;
  public
    constructor Create(const AValidator: TJSONSchemaValidator); override;
    destructor Destroy; override;
    procedure Parse(const ANode: IJSONObject); override;
    function Validate(const ANode: IJSONElement; const APath: String;
      const AErrors: TList<TValidationError>): Boolean; override;
  end;

implementation

constructor TTitleTrait.Create(const AValidator: TJSONSchemaValidator);
begin
  inherited Create(AValidator);

end;

destructor TTitleTrait.Destroy;
begin

  inherited;
end;

procedure TTitleTrait.Parse(const ANode: IJSONObject);
begin
  if ANode.ContainsKey('title') then
    FTitle := (ANode.GetValue('title') as IJSONValue).AsString
  else
    FTitle := '';
end;

function TTitleTrait.Validate(const ANode: IJSONElement; const APath: String;
  const AErrors: TList<TValidationError>): Boolean;
begin
  Result := True;
end;

end.
