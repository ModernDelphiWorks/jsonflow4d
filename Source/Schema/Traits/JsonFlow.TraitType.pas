unit JsonFlow.TraitType;

interface

uses
  SysUtils,
  StrUtils,
  Generics.Collections,
  JsonFlow.Value,
  JsonFlow.Interfaces,
  JsonFlow.SchemaValidator;

type
  TTypeTrait = class(TJsonSchemaTrait)
  private
    FType: String;
  public
    constructor Create(const AValidator: TJSONSchemaValidator); override;
    destructor Destroy; override;
    procedure Parse(const ANode: IJSONObject); override;
    function Validate(const ANode: IJSONElement; const APath: String;
      const AErrors: TList<TValidationError>): Boolean; override;
  end;

implementation

constructor TTypeTrait.Create(const AValidator: TJSONSchemaValidator);
begin
  inherited Create(AValidator);
  FType := '';
end;

destructor TTypeTrait.Destroy;
begin
  inherited;
end;

procedure TTypeTrait.Parse(const ANode: IJSONObject);
var
  LArray: IJSONArray;
  I: Integer;
begin
  FValidator.AddLog('TTypeTrait.Parse called for instance ' + IntToStr(Integer(Self)) + ' with node ' + ANode.AsJSON);
  if ANode.ContainsKey('type') then
  begin
    FValidator.AddLog('TTypeTrait.Parse: Found "type" key in node ' + ANode.AsJSON);
    if Supports(ANode.GetValue('type'), IJSONArray, LArray) then
    begin
      FType := '[';
      for I := 0 to LArray.Count - 1 do
      begin
        if I > 0 then
          FType := FType + ',';
        FType := FType + '"' + (LArray.Items[I] as IJSONValue).AsString + '"';
      end;
      FType := FType + ']';
    end
    else
      FType := (ANode.GetValue('type') as IJSONValue).AsString;
  end
  else
  begin
    FType := 'object';
    FValidator.AddLog('TTypeTrait.Parse: No "type" key found, assuming object for node ' + ANode.AsJSON);
  end;
  FValidator.AddLog('TTypeTrait.Parse: FType set to ' + FType + ' for instance ' + IntToStr(Integer(Self)));
end;

function TTypeTrait.Validate(const ANode: IJSONElement; const APath: String; const AErrors: TList<TValidationError>): Boolean;
var
  LError: TValidationError;
  LChild: TSchemaNode;
  LChildCount: Integer;
  LValue: IJSONElement;
  LFoundType: String;
  LTypes: TArray<String>;
  LFor: Integer;
begin
  Result := False;
  FValidator.AddLog('TTypeTrait.Validate started for ' + ANode.AsJSON + ' at ' + APath + ' with instance ' + IntToStr(Integer(Self)));
  if FType = '' then
    FValidator.AddLog('TTypeTrait.Validate: FType is empty - Parse not called yet!');
  FValidator.AddLog('FType value: ' + FType);

  try
    LFoundType := ANode.TypeName;
    FValidator.AddLog('Found type from IJSONElement: ' + LFoundType);

    if FType.StartsWith('[') then
    begin
      LTypes := FType.Trim(['[', ']']).Split([',']);
      for LFor := 0 to Length(LTypes) - 1 do
        LTypes[LFor] := Trim(LTypes[LFor]).Trim(['"']);
      for LFor := 0 to Length(LTypes) - 1 do
      begin
        if LTypes[LFor] = LFoundType then
        begin
          Result := True;
          Break;
        end;
      end;
      if not Result then
        FValidator.AddLog('Multiple types checked: ' + FType + ', found: ' + LFoundType);
    end
    else
    begin
      Result := (UpperCase(FType) = UpperCase(LFoundType));
      if not Result then
        FValidator.AddLog('Single type checked: ' + FType + ', found: ' + LFoundType);
    end;

    if not Result then
    begin
      LError.Path := APath;
      LError.Message := Format('Expected type %s, found %s', [FType, LFoundType]);
      LError.FoundValue := LFoundType;
      LError.ExpectedValue := FType;
      LError.Keyword := 'type';
      AErrors.Add(LError);
    end;

    if Result then
    begin
      LChildCount := FNode.Children.Count;
      FValidator.AddLog('Number of children in FNode: ' + IntToStr(LChildCount));
      for LChild in FNode.Children do
      begin
        if Assigned(LChild.Trait) then
        begin
          FValidator.AddLog('Validating child: ' + LChild.Keyword);
          if Supports(ANode, IJSONObject) and (LChild.Keyword = 'properties') then
          begin
            for var LSubChild in LChild.Children do
              if Assigned(LSubChild.Trait) then
              begin
                FValidator.AddLog('Validating sub-child: ' + LSubChild.Keyword);
                LValue := (ANode as IJSONObject).GetValue(LSubChild.Keyword);
                if not Assigned(LValue) then
                  LValue := TJSONValueNull.Create; // Substituído por uma classe concreta
                try
                  if not LSubChild.Trait.Validate(LValue, APath + '/' + LSubChild.Keyword, AErrors) then
                    Result := False;
                finally
                  // Não precisa liberar LValue aqui, pois é uma interface gerenciada por referência
                end;
              end;
          end
          else
          begin
            try
              if not LChild.Trait.Validate(ANode, APath + '/' + LChild.Keyword, AErrors) then
                Result := False;
            except
              on E: Exception do
              begin
                FValidator.AddLog('Exception in child validation: ' + E.Message);
                LError.Path := APath + '/' + LChild.Keyword;
                LError.Message := 'Validation error: ' + E.Message;
                LError.FoundValue := ANode.AsJSON;
                LError.ExpectedValue := 'valid value';
                LError.Keyword := LChild.Keyword;
                AErrors.Add(LError);
                Result := False;
              end;
            end;
          end;
        end;
      end;
    end;
  except
    on E: Exception do
    begin
      FValidator.AddLog('Exception in TTypeTrait.Validate: ' + E.Message);
      LError.Path := APath;
      LError.Message := 'Validation error: ' + E.Message;
      LError.FoundValue := ANode.AsJSON;
      LError.ExpectedValue := FType;
      LError.Keyword := 'type';
      AErrors.Add(LError);
      Result := False;
    end;
  end;
  FValidator.AddLog('TTypeTrait.Validate finished: ' + BoolToStr(Result, True));
end;

end.
