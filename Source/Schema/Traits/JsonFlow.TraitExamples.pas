unit JsonFlow.TraitExamples;

interface

uses
  SysUtils,
  Generics.Collections,
  JsonFlow.Value,
  JsonFlow.Interfaces,
  JsonFlow.SchemaValidator;

type
  TExamplesTrait = class(TJsonSchemaTrait)
  private
    FExamples: TList<IJSONElement>;
  public
    constructor Create(const AValidator: TJSONSchemaValidator); override;
    destructor Destroy; override;
    procedure Parse(const ANode: IJSONObject); override;
    function Validate(const ANode: IJSONElement; const APath: String;
      const AErrors: TList<TValidationError>): Boolean; override;
  end;

implementation

constructor TExamplesTrait.Create(const AValidator: TJSONSchemaValidator);
begin
  inherited Create(AValidator);
  FExamples := TList<IJSONElement>.Create;
  FValidator := AValidator;
end;

destructor TExamplesTrait.Destroy;
begin
  FExamples.Free;
  inherited;
end;

procedure TExamplesTrait.Parse(const ANode: IJSONObject);
var
  LArray: IJSONArray;
  LFor: Integer;
begin
  FExamples.Clear;
  if ANode.ContainsKey('examples') and Supports(ANode.GetValue('examples'), IJSONArray, LArray) then
    for LFor := 0 to LArray.Count - 1 do
      FExamples.Add(LArray.Items[LFor]);
end;

function TExamplesTrait.Validate(const ANode: IJSONElement; const APath: String;
  const AErrors: TList<TValidationError>): Boolean;
begin
  Result := True;
end;

end.
