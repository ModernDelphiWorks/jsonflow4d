unit JsonFlow.TraitItems;

interface

uses
  SysUtils,
  Generics.Collections,
  JsonFlow.Value,
  JsonFlow.Interfaces,
  JsonFlow.SchemaValidator;

type
  TItemsTrait = class(TJsonSchemaTrait)
  private
    FItemsSchema: TSchemaNode;
    FItemsSchemas: TList<TSchemaNode>;
    FIsSingleSchema: Boolean;
  public
    constructor Create(const AValidator: TJSONSchemaValidator); override;
    destructor Destroy; override;
    procedure Parse(const ANode: IJSONObject); override;
    function Validate(const ANode: IJSONElement; const APath: String;
      const AErrors: TList<TValidationError>): Boolean; override;
  end;

implementation

constructor TItemsTrait.Create(const AValidator: TJSONSchemaValidator);
begin
  inherited Create(AValidator);
  FItemsSchemas := TList<TSchemaNode>.Create;
end;

destructor TItemsTrait.Destroy;
begin
  FItemsSchema := nil;
  FItemsSchemas.Free;
  inherited;
end;

procedure TItemsTrait.Parse(const ANode: IJSONObject);
var
  LArray: IJSONArray;
  LFor: Integer;
  LItemsObj: IJSONObject;
begin
  FItemsSchemas.Clear;
  if ANode.ContainsKey('items') then
  begin
    if Supports(ANode.GetValue('items'), IJSONArray, LArray) then
    begin
      FIsSingleSchema := False;
      for LFor := 0 to LArray.Count - 1 do
        FItemsSchemas.Add(FValidator.ParseNode(LArray.Items[LFor], '/items/' + LFor.ToString));
    end
    else if Supports(ANode.GetValue('items'), IJSONObject, LItemsObj) and LItemsObj.ContainsKey('$ref') then
    begin
      FIsSingleSchema := True;
      FItemsSchema := FValidator.GetDefsNodes[(LItemsObj.GetValue('$ref') as IJSONValue).AsString];
      FValidator.AddLog('Parsed items with $ref: ' + (LItemsObj.GetValue('$ref') as IJSONValue).AsString);
    end
    else
    begin
      FIsSingleSchema := True;
      FItemsSchema := FValidator.ParseNode(ANode.GetValue('items'), '/items');
    end;
  end;
end;

function TItemsTrait.Validate(const ANode: IJSONElement; const APath: String;
  const AErrors: TList<TValidationError>): Boolean;
var
  LArray: IJSONArray;
  LFor: Integer;
  LError: TValidationError;
  LErrors: TList<TValidationError>;
begin
  Result := True;
  LErrors := TList<TValidationError>.Create;
  try
    FValidator.AddLog('TItemsTrait.Validate started for ' + ANode.AsJSON + ' at ' + APath);

    if not Supports(ANode, IJSONArray, LArray) then
    begin
      FValidator.AddLog('Skipping items validation - not an array: ' + ANode.AsJSON);
      Exit;
    end;

    try
      if FIsSingleSchema and Assigned(FItemsSchema) then
      begin
        FValidator.AddLog('Validating single schema for items: ' + FItemsSchema.Children.ToString);
        for LFor := 0 to LArray.Count - 1 do
        begin
          FValidator.AddLog('Validating item[' + LFor.ToString + ']: ' + LArray.Items[LFor].AsJSON);
          // Resetar o estado de validação para garantir que cada item seja validado independentemente
          FItemsSchema.ResetValidationState;
          if not FValidator.ValidateNode(FItemsSchema, LArray.Items[LFor], APath + '/' + LFor.ToString, LErrors) then
          begin
            FValidator.AddLog('Item[' + LFor.ToString + '] failed validation');
            Result := False;
          end
          else
            FValidator.AddLog('Item[' + LFor.ToString + '] passed validation');
        end;
      end
      else if FItemsSchemas.Count > 0 then
      begin
        FValidator.AddLog('Validating multiple schemas for items');
        for LFor := 0 to LArray.Count - 1 do
        begin
          if LFor < FItemsSchemas.Count then
          begin
            FValidator.AddLog('Validating item[' + LFor.ToString + '] with schema: ' + FItemsSchemas[LFor].Value.AsJSON);
            FItemsSchemas[LFor].ResetValidationState;
            if not FValidator.ValidateNode(FItemsSchemas[LFor], LArray.Items[LFor], APath + '/' + LFor.ToString, LErrors) then
            begin
              FValidator.AddLog('Item[' + LFor.ToString + '] failed validation');
              Result := False;
            end
            else
              FValidator.AddLog('Item[' + LFor.ToString + '] passed validation');
          end;
        end;
      end;
    except
      on E: Exception do
      begin
        FValidator.AddLog('Exception in TItemsTrait.Validate: ' + E.Message);
        LError.Path := APath;
        LError.Message := 'Validation error: ' + E.Message;
        LError.FoundValue := ANode.AsJSON;
        LError.ExpectedValue := 'array';
        LError.Keyword := 'items';
        LErrors.Add(LError);
        Result := False;
      end;
    end;
  finally
    AErrors.AddRange(LErrors.ToArray);
    LErrors.Free;
  end;
  FValidator.AddLog('TItemsTrait.Validate finished: ' + BoolToStr(Result, True));
end;

end.
