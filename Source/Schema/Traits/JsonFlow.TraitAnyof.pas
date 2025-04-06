unit JsonFlow.TraitAnyof;

interface

uses
  SysUtils,
  Generics.Collections,
  JsonFlow.Value,
  JsonFlow.Interfaces,
  JsonFlow.SchemaValidator;

type
  TAnyOfTrait = class(TJsonSchemaTrait)
  private
    FOptions: TList<TSchemaNode>;
  public
    constructor Create(const AValidator: TJSONSchemaValidator); override;
    destructor Destroy; override;
    procedure Parse(const ANode: IJSONObject); override;
    function Validate(const ANode: IJSONElement; const APath: String;
      const AErrors: TList<TValidationError>): Boolean; override;
  end;

implementation

constructor TAnyOfTrait.Create(const AValidator: TJSONSchemaValidator);
begin
  inherited Create(AValidator);
  FOptions := TList<TSchemaNode>.Create;
end;

destructor TAnyOfTrait.Destroy;
var
  LOption: TSchemaNode;
begin
  for LOption in FOptions do
    LOption.Free;
  FOptions.Free;
  inherited;
end;

procedure TAnyOfTrait.Parse(const ANode: IJSONObject);
var
  LArray: IJSONArray;
  I: Integer;
begin
  FOptions.Clear;
  if ANode.ContainsKey('anyOf') and Supports(ANode.GetValue('anyOf'), IJSONArray, LArray) then
    for I := 0 to LArray.Count - 1 do
      FOptions.Add(FValidator.ParseNode(LArray.Items[I], '/anyOf/' + I.ToString));
end;

function TAnyOfTrait.Validate(const ANode: IJSONElement; const APath: String;
  const AErrors: TList<TValidationError>): Boolean;
var
  LOption: TSchemaNode;
  LTempErrors: TList<TValidationError>;
  LError: TValidationError;
begin
  Result := False;
  if FOptions.Count = 0 then
    Exit(True);

  LTempErrors := TList<TValidationError>.Create;
  try
    for LOption in FOptions do
    begin
      LTempErrors.Clear;
      if LOption.Trait.Validate(ANode, APath, LTempErrors) then
      begin
        Result := True;
        Break;
      end;
    end;

    if not Result then
    begin
      LError.Path := APath;
      LError.Message := 'Value must match at least one schema in anyOf';
      LError.FoundValue := ANode.AsJSON;
      LError.ExpectedValue := 'at least one match';
      LError.Keyword := 'anyOf';
      LError.LineNumber := -1;
      LError.ColumnNumber := -1;
      LError.Context := 'Schema: {"anyOf": [...]}';
      AErrors.Add(LError);
    end;
  finally
    LTempErrors.Free;
  end;
end;

end.
