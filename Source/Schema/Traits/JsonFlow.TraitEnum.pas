unit JsonFlow.TraitEnum;

interface

uses
  SysUtils,
  StrUtils,
  Generics.Collections,
  JsonFlow.Value,
  JsonFlow.Interfaces,
  JsonFlow.SchemaValidator;

type
  TEnumTrait = class(TJsonSchemaTrait)
  private
    FEnumValues: TList<IJSONElement>;
  public
    constructor Create(const AValidator: TJSONSchemaValidator); override;
    destructor Destroy; override;
    procedure Parse(const ANode: IJSONObject); override;
    function Validate(const ANode: IJSONElement; const APath: String;
      const AErrors: TList<TValidationError>): Boolean; override;
  end;

implementation

constructor TEnumTrait.Create(const AValidator: TJSONSchemaValidator);
begin
  inherited Create(AValidator);
  FEnumValues := TList<IJSONElement>.Create;
end;

destructor TEnumTrait.Destroy;
begin
  FEnumValues.Free;
  inherited;
end;

procedure TEnumTrait.Parse(const ANode: IJSONObject);
var
  LArray: IJSONArray;
  LFor: Integer;
  LItem: IJSONElement;
begin
  FValidator.AddLog('TEnumTrait.Parse started');
  FEnumValues.Clear;
  if ANode.ContainsKey('enum') and Supports(ANode.GetValue('enum'), IJSONArray, LArray) then
  begin
    FValidator.AddLog('Enum array found with ' + IntToStr(LArray.Count) + ' items');
    for LFor := 0 to LArray.Count - 1 do
    begin
      LItem := LArray.Items[LFor];
      if Assigned(LItem) then
      begin
        FValidator.AddLog('Adding enum value: ' + LItem.AsJSON);
        FEnumValues.Add(LItem);
      end
      else
        FValidator.AddLog('Warning: Enum item at index ' + IntToStr(LFor) + ' is nil');
    end;
  end;
  FValidator.AddLog('TEnumTrait.Parse finished with ' + IntToStr(FEnumValues.Count) + ' values');
end;

function TEnumTrait.Validate(const ANode: IJSONElement; const APath: String;
  const AErrors: TList<TValidationError>): Boolean;
var
  LEnumValue: IJSONElement;
  LFound: Boolean;
  LError: TValidationError;
  LExpected: String;
  LJsonValue: IJSONValue;
begin
  Result := True;
  if FEnumValues.Count = 0 then
    Exit;

  FValidator.AddLog('TEnumTrait.Validate started for ' + ANode.AsJSON);
  if not Supports(ANode, IJSONValue, LJsonValue) then
  begin
    LError.Path := APath;
    LError.Message := 'Expected a value for enum validation, found non-value type';
    LError.FoundValue := ANode.AsJSON;
    LError.ExpectedValue := 'one of [' + TArray.ToString<IJSONElement>(FEnumValues.ToArray) + ']';
    LError.Keyword := 'enum';
    LError.LineNumber := -1;
    LError.ColumnNumber := -1;
    LError.Context := 'Schema: {"enum": [' + TArray.ToString<IJSONElement>(FEnumValues.ToArray) + ']}';
    AErrors.Add(LError);
    Exit(False);
  end;

  LFound := False;
  for LEnumValue in FEnumValues do
    if Assigned(LEnumValue) and (LJsonValue.AsJSON = LEnumValue.AsJSON) then
    begin
      LFound := True;
      Break;
    end;

  if not LFound then
  begin
    LExpected := '';
    for LEnumValue in FEnumValues do
      if Assigned(LEnumValue) then
        LExpected := LExpected + IfThen(LExpected = '', '', ', ') + LEnumValue.AsJSON;
    LError.Path := APath;
    LError.Message := Format('Value must be one of [%s], found %s', [LExpected, LJsonValue.AsJSON]);
    LError.FoundValue := LJsonValue.AsJSON;
    LError.ExpectedValue := '[' + LExpected + ']';
    LError.Keyword := 'enum';
    LError.LineNumber := -1;
    LError.ColumnNumber := -1;
    LError.Context := Format('Schema: {"enum": [%s]}', [LExpected]);
    AErrors.Add(LError);
    Result := False;
  end;
  FValidator.AddLog('TEnumTrait.Validate finished: ' + BoolToStr(Result, True));
end;

end.
