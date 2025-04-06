unit JsonFlow.TraitVocabulary;

interface

uses
  SysUtils,
  Generics.Collections,
  JsonFlow.Value,
  JsonFlow.Interfaces,
  JsonFlow.SchemaValidator;

type
  TVocabularyTrait = class(TJsonSchemaTrait)
  private
    FVocabulary: IJSONObject;
  public
    constructor Create(const AValidator: TJSONSchemaValidator); override;
    destructor Destroy; override;
    procedure Parse(const ANode: IJSONObject); override;
    function Validate(const ANode: IJSONElement; const APath: String;
      const AErrors: TList<TValidationError>): Boolean; override;
  end;

implementation

constructor TVocabularyTrait.Create(const AValidator: TJSONSchemaValidator);
begin
  inherited Create(AValidator);

end;

destructor TVocabularyTrait.Destroy;
begin

  inherited;
end;

procedure TVocabularyTrait.Parse(const ANode: IJSONObject);
begin
  if ANode.ContainsKey('$vocabulary') then
    Supports(ANode.GetValue('$vocabulary'), IJSONObject, FVocabulary)
  else
    FVocabulary := nil;
end;

function TVocabularyTrait.Validate(const ANode: IJSONElement; const APath: String;
  const AErrors: TList<TValidationError>): Boolean;
begin
  Result := True;
end;

end.
