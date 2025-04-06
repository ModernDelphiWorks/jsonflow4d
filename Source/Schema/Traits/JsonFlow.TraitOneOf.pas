unit JsonFlow.TraitOneOf;

interface

uses
  SysUtils,
  Generics.Collections,
  JsonFlow.Value,
  JsonFlow.Interfaces,
  JsonFlow.SchemaValidator;

type
  TOneOfTrait = class(TJsonSchemaTrait)
  private
    FOptions: TObjectList<TSchemaNode>;
  public
    constructor Create(const AValidator: TJSONSchemaValidator); override;
    destructor Destroy; override;
    procedure Parse(const ANode: IJSONObject); override;
    function Validate(const ANode: IJSONElement; const APath: String;
      const AErrors: TList<TValidationError>): Boolean; override;
  end;

implementation

constructor TOneOfTrait.Create(const AValidator: TJSONSchemaValidator);
begin
  inherited Create(AValidator);
  FOptions := TObjectList<TSchemaNode>.Create;
end;

destructor TOneOfTrait.Destroy;
begin
  FOptions.Free;
  inherited;
end;

procedure TOneOfTrait.Parse(const ANode: IJSONObject);
var
  LArray: IJSONArray;
  LFor: Integer;
  LOptionNode: TSchemaNode;
begin
  FOptions.Clear;
  if ANode.ContainsKey('oneOf') and Supports(ANode.GetValue('oneOf'), IJSONArray, LArray) then
  begin
    FValidator.AddLog('Parsing oneOf with ' + IntToStr(LArray.Count) + ' options');
    for LFor := 0 to LArray.Count - 1 do
    begin
      LOptionNode := FValidator.ParseNode(LArray.Items[LFor], '/oneOf/' + LFor.ToString);
      FOptions.Add(LOptionNode);
      if Assigned(LOptionNode.Trait) then
        FValidator.AddLog('Parsed oneOf option ' + LFor.ToString + ' with trait: ' + LOptionNode.Keyword)
      else
        FValidator.AddLog('Parsed oneOf option ' + LFor.ToString + ' without trait: ' + LArray.Items[LFor].AsJSON);
    end;
  end
  else
    FValidator.AddLog('No oneOf array found in node: ' + ANode.AsJSON);
end;

function TOneOfTrait.Validate(const ANode: IJSONElement; const APath: String;
  const AErrors: TList<TValidationError>): Boolean;
var
  LOption: TSchemaNode;
  LTempErrors: TList<TValidationError>;
  LError: TValidationError;
  LValidCount: Integer;
begin
  Result := False;
  Writeln('TOneOfTrait.Validate started for ' + ANode.AsJSON + ' at ' + APath);
  FValidator.AddLog('TOneOfTrait.Validate started for ' + ANode.AsJSON + ' at ' + APath);

  if FOptions.Count = 0 then
  begin
    FValidator.AddError(APath, 'No options defined for oneOf', ANode.AsJSON, 'at least one option', 'oneOf');
    Exit(False);
  end;

  LValidCount := 0;
  LTempErrors := TList<TValidationError>.Create;
  try
    for LOption in FOptions do
    begin
      if not Assigned(LOption) then
      begin
        FValidator.AddLog('Skipping null option in oneOf at ' + APath);
        Continue;
      end;

      LTempErrors.Clear;
      if Assigned(LOption.Trait) then
      begin
        FValidator.AddLog('Validating oneOf option with trait at ' + APath + ': ' + LOption.Keyword);
        try
          if LOption.Trait.Validate(ANode, APath, LTempErrors) then
          begin
            Inc(LValidCount);
            FValidator.AddLog('Option validated successfully, valid count: ' + IntToStr(LValidCount));
          end;
        except
          on E: Exception do
          begin
            FValidator.AddLog('Exception in Validate for oneOf option at ' + APath + ': ' + E.Message);
            Continue;
          end;
        end;
      end
      else
      begin
        FValidator.AddLog('No trait assigned to oneOf option at ' + APath + ': ' + LOption.Keyword);
        Continue;
      end;
    end;

    if LValidCount = 1 then
    begin
      Result := True;
      FValidator.AddLog('OneOf validated successfully with exactly one match');
    end
    else
    begin
      LError.Path := APath;
      LError.Message := Format('Value must match exactly one schema in oneOf, found %d matches', [LValidCount]);
      LError.FoundValue := ANode.AsJSON;
      LError.ExpectedValue := 'exactly one match';
      LError.Keyword := 'oneOf';
      LError.LineNumber := -1;
      LError.ColumnNumber := -1;
      LError.Context := 'Schema: {"oneOf": [...]}';
      AErrors.Add(LError);
      Result := False;
      FValidator.AddLog('OneOf validation failed: ' + LError.Message);
    end;

    if not Result then
      AErrors.AddRange(LTempErrors);
  finally
    LTempErrors.Free;
  end;
end;

end.
