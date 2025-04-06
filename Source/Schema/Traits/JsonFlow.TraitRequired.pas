unit JsonFlow.TraitRequired;

interface

uses
  SysUtils,
  Generics.Collections,
  JsonFlow.Value,
  JsonFlow.Interfaces,
  JsonFlow.SchemaValidator;

type
  TRequiredTrait = class(TJsonSchemaTrait)
  private
    FRequiredFields: TList<String>;
  public
    constructor Create(const AValidator: TJSONSchemaValidator); override;
    destructor Destroy; override;
    procedure Parse(const ANode: IJSONObject); override;
    function Validate(const ANode: IJSONElement; const APath: String;
      const AErrors: TList<TValidationError>): Boolean; override;
  end;

implementation

constructor TRequiredTrait.Create(const AValidator: TJSONSchemaValidator);
begin
  inherited Create(AValidator);
  FRequiredFields := TList<String>.Create;
end;

destructor TRequiredTrait.Destroy;
begin
  FRequiredFields.Free;
  inherited;
end;

procedure TRequiredTrait.Parse(const ANode: IJSONObject);
var
  LArray: IJSONArray;
  LValue: IJSONValue;
  LFor: Integer;
begin
  FValidator.AddLog('TRequiredTrait.Parse started with node: ' + ANode.AsJSON);
  FRequiredFields.Clear;

  // Usa o FNode.Value, que é o valor do "required" (["mainContact"])
  if Assigned(FNode) and Supports(FNode.Value, IJSONArray, LArray) then
  begin
    FValidator.AddLog('TRequiredTrait.Parse: Processing "required" value: ' + FNode.Value.AsJSON);
    for LFor := 0 to LArray.Count - 1 do
    begin
      if Supports(LArray.Items[LFor], IJSONValue, LValue) then
      begin
        FRequiredFields.Add(LValue.AsString);
        FValidator.AddLog('TRequiredTrait.Parse: Added required field: ' + LValue.AsString);
      end;
    end;
    FValidator.AddLog('TRequiredTrait.Parse: Required fields set to: ' + TArray.ToString<String>(FRequiredFields.ToArray));
  end
  else
    FValidator.AddLog('TRequiredTrait.Parse: No valid "required" array found in FNode.Value');
end;

function TRequiredTrait.Validate(const ANode: IJSONElement; const APath: String;
  const AErrors: TList<TValidationError>): Boolean;
var
  LObj: IJSONObject;
  LField: String;
  LError: TValidationError;
begin
  FValidator.AddLog('TRequiredTrait.Validate started for ' + ANode.AsJSON + ' at ' + APath);
  Result := True;
  if FRequiredFields.Count = 0 then
  begin
    FValidator.AddLog('TRequiredTrait.Validate: No required fields defined');
    Exit;
  end;

  if not Supports(ANode, IJSONObject, LObj) then
  begin
    LError.Path := APath;
    LError.Message := 'Expected object for required validation, found non-object';
    LError.FoundValue := (ANode as IJSONValue).TypeName;
    LError.ExpectedValue := 'object';
    LError.Keyword := 'required';
    LError.LineNumber := -1;
    LError.ColumnNumber := -1;
    LError.Context := Format('Schema: {"required": [%s]}', [TArray.ToString<String>(FRequiredFields.ToArray)]);
    AErrors.Add(LError);
    FValidator.AddLog('TRequiredTrait.Validate: Element is not an object, failing');
    Exit(False);
  end;

  for LField in FRequiredFields do
  begin
    if not LObj.ContainsKey(LField) then
    begin
      LError.Path := APath + '/' + LField;
      LError.Message := Format('Required field "%s" is missing', [LField]);
      LError.FoundValue := 'not present';
      LError.ExpectedValue := 'present';
      LError.Keyword := 'required';
      LError.LineNumber := -1;
      LError.ColumnNumber := -1;
      LError.Context := Format('Schema: {"required": [%s]}', [TArray.ToString<String>(FRequiredFields.ToArray)]);
      AErrors.Add(LError);
      FValidator.AddLog('TRequiredTrait.Validate: Missing required field: ' + LField);
      Result := False;
    end
    else
      FValidator.AddLog('TRequiredTrait.Validate: Found required field: ' + LField);
  end;

  FValidator.AddLog('TRequiredTrait.Validate finished: ' + BoolToStr(Result, True));
end;

end.
