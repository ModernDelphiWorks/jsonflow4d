unit JsonFlow.TraitComment;

interface

uses
  SysUtils,
  Generics.Collections,
  JsonFlow.Value,
  JsonFlow.Interfaces,
  JsonFlow.SchemaValidator;

type
  TCommentTrait = class(TJsonSchemaTrait)
  private
    FComment: String;
  public
    constructor Create(const AValidator: TJSONSchemaValidator); override;
    destructor Destroy; override;
    procedure Parse(const ANode: IJSONObject); override;
    function Validate(const ANode: IJSONElement; const APath: String;
      const AErrors: TList<TValidationError>): Boolean; override;
  end;

implementation

constructor TCommentTrait.Create(const AValidator: TJSONSchemaValidator);
begin
  inherited Create(AValidator);

end;

destructor TCommentTrait.Destroy;
begin

  inherited;
end;

procedure TCommentTrait.Parse(const ANode: IJSONObject);
begin
  if ANode.ContainsKey('$comment') then
    FComment := (ANode.GetValue('$comment') as IJSONvalue).AsString
  else
    FComment := '';
end;

function TCommentTrait.Validate(const ANode: IJSONElement; const APath: String;
  const AErrors: TList<TValidationError>): Boolean;
begin
  Result := True;
end;

end.
