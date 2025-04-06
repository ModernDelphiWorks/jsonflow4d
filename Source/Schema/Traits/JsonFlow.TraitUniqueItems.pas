unit JsonFlow.TraitUniqueItems;

interface

uses
  SysUtils,
  Classes,
  Generics.Collections,
  JsonFlow.Value,
  JsonFlow.Interfaces,
  JsonFlow.SchemaValidator;

type
  TUniqueItemsTrait = class(TJsonSchemaTrait)
  private
    FUniqueItems: Boolean;
    FHasUniqueItems: Boolean;
  public
    constructor Create(const AValidator: TJSONSchemaValidator); override;
    destructor Destroy; override;
    procedure Parse(const ANode: IJSONObject); override;
    function Validate(const ANode: IJSONElement; const APath: String;
      const AErrors: TList<TValidationError>): Boolean; override;
  end;

implementation

constructor TUniqueItemsTrait.Create(const AValidator: TJSONSchemaValidator);
begin
  inherited Create(AValidator);

end;

destructor TUniqueItemsTrait.Destroy;
begin

  inherited;
end;

procedure TUniqueItemsTrait.Parse(const ANode: IJSONObject);
begin
  FHasUniqueItems := ANode.ContainsKey('uniqueItems');
  if FHasUniqueItems then
    FUniqueItems := (ANode.GetValue('uniqueItems') as IJSONValue).AsBoolean;
end;

function TUniqueItemsTrait.Validate(const ANode: IJSONElement; const APath: String;
  const AErrors: TList<TValidationError>): Boolean;
var
  LError: TValidationError;
  LArray: IJSONArray;
  LSeen: TStringList;
  LFor: Integer;
begin
  Result := True;
  if not FHasUniqueItems or not FUniqueItems then
    Exit;

  if not Supports(ANode, IJSONArray, LArray) then
  begin
    LError.Path := APath;
    LError.Message := 'Expected array for uniqueItems validation, found non-array';
    LError.FoundValue := (ANode as IJSONValue).TypeName;
    LError.ExpectedValue := 'array';
    LError.Keyword := 'uniqueItems';
    LError.LineNumber := -1;
    LError.ColumnNumber := -1;
    LError.Context := 'Schema: {"uniqueItems": true}';
    AErrors.Add(LError);
    Exit(False);
  end;

  LSeen := TStringList.Create;
  try
    LSeen.Sorted := True;
    LSeen.Duplicates := dupError;
    for LFor := 0 to LArray.Count - 1 do
    begin
      try
        LSeen.Add(LArray.Items[LFor].AsJSON);
      except
        on E: EStringListError do
        begin
          LError.Path := APath;
          LError.Message := Format('Array must contain unique items, duplicate found at index %d', [LFor]);
          LError.FoundValue := LArray.Items[LFor].AsJSON;
          LError.ExpectedValue := 'unique';
          LError.Keyword := 'uniqueItems';
          LError.LineNumber := -1;
          LError.ColumnNumber := -1;
          LError.Context := 'Schema: {"uniqueItems": true}';
          AErrors.Add(LError);
          Result := False;
          Break;
        end;
      end;
    end;
  finally
    LSeen.Free;
  end;
end;

end.
