unit JsonFlow.SchemaValidator;

interface

uses
  SysUtils,
  StrUtils,
  Generics.Collections,
  JsonFlow.Value,
  JsonFlow.Interfaces;

type
  TJSONSchemaParser = class;
  TJSONSchemaValidator = class;

  TJsonSchemaTrait = class(TInterfacedObject, IJSONSchemaTrait)
  protected
    FValidator: TJSONSchemaValidator;
    FNode: TSchemaNode;
  public
    constructor Create(const AValidator: TJSONSchemaValidator); virtual;
    destructor Destroy; override;
    procedure Parse(const ANode: IJSONObject); virtual; abstract;
    procedure SetNode(const ANode: TSchemaNode); virtual;
    function Validate(const ANode: IJSONElement; const APath: String;
      const AErrors: TList<TValidationError>): Boolean; virtual; abstract;
  end;

  TJsonSchemaTraitClass = class of TJsonSchemaTrait;

  TJSONSchemaValidator = class(TInterfacedObject, IJSONSchemaValidator)
  private
    FLogProc: TProc<String>;
    FVersion: TJsonSchemaVersion;
    FErrors: TList<TValidationError>;
    FParser: TJSONSchemaParser;
    FRootNode: TSchemaNode;
    FSchema: IJSONElement;
    FTraitStats: TDictionary<String, Integer>;
    function _GetSchema: IJSONElement;
    procedure _SetSchema(const AValue: IJSONElement);
    procedure _InitializeTraits;
    procedure _LogTraitValidation(const ATraitClass: String);
  public
    function GetErrors: TArray<TValidationError>;
    function GetVersion: TJsonSchemaVersion;
    function GetLastError: string;
    function Validate(const AElement: IJSONElement; const APath: String): Boolean; overload;
    function Validate(const AJson, AJsonSchema: String): Boolean; overload;
    procedure ParseSchema(const ASchema: IJSONElement);
    procedure AddLog(const AMessage: String);
    procedure AddError(const APath, AMessage, AFound, AExpected, AKeyword: String;
      ALineNumber: Integer = -1; AColumnNumber: Integer = -1; AContext: String = '');
    procedure OnLog(const ALogProc: TProc<String>);
  public
    constructor Create(const AVersion: TJsonSchemaVersion = jsvDraft7;
      const ARootSchema: IJSONElement = nil);
    destructor Destroy; override;
    function ValidateNode(const ANode: TSchemaNode; const AElement: IJSONElement;
      const ACurrentPath: String; var AErrors: TList<TValidationError>): Boolean;
    function ParseNode(ANode: IJSONElement; APath: String): TSchemaNode;
    function GetDefsNodes: TDictionary<String, TSchemaNode>;
    function GetRootNode: TSchemaNode;
    procedure ReportStats;
    property Schema: IJSONElement read _GetSchema write _SetSchema;
  end;

  TJSONSchemaParser = class
  private
    FValidator: TJSONSchemaValidator;
    FRegisters: TDictionary<String, TJsonSchemaTraitClass>;
    FDefsNodes: TDictionary<String, TSchemaNode>;
    FRecursive: Integer;
    function _GetTrait(AKeyword: String): IJSONSchemaTrait;
    function _ResolveRef(const ARef: String; const APath: String): IJSONElement;
    function _ContainsRef(const ANode: IJSONElement): Boolean;
  protected
    function _ParseNode(const ANode: IJSONElement; const APath: String): TSchemaNode;
  public
    constructor Create(const AValidator: TJSONSchemaValidator);
    destructor Destroy; override;
    function Parse(ASchema: IJSONElement): TSchemaNode;
    procedure RegisterTrait(AKeyword: String; ATraitClass: TJsonSchemaTraitClass);
  end;

implementation

uses
  JsonFlow.Reader,
  JsonFlow.Objects,
  JsonFlow.SchemaNavigator,
  JsonFlow.TraitSchema,
  JsonFlow.TraitId,
  JsonFlow.TraitRef,
  JsonFlow.TraitDefs,
  JsonFlow.TraitAnchor,
  JsonFlow.TraitVocabulary,
  JsonFlow.TraitComment,
  JsonFlow.TraitType,
  JsonFlow.TraitConst,
  JsonFlow.TraitEnum,
  JsonFlow.TraitMinimum,
  JsonFlow.TraitMaximum,
  JsonFlow.TraitExclusiveMinimum,
  JsonFlow.TraitExclusiveMaximum,
  JsonFlow.TraitMultipleOf,
  JsonFlow.TraitDivisibleBy,
  JsonFlow.TraitMinLength,
  JsonFlow.TraitMaxLength,
  JsonFlow.TraitPattern,
  JsonFlow.TraitFormat,
  JsonFlow.TraitContentEncoding,
  JsonFlow.TraitContentMediaType,
  JsonFlow.TraitContentSchema,
  JsonFlow.TraitProperties,
  JsonFlow.TraitAdditionalProperties,
  JsonFlow.TraitPatternProperties,
  JsonFlow.TraitRequired,
  JsonFlow.TraitPropertyNames,
  JsonFlow.TraitMinProperties,
  JsonFlow.TraitMaxProperties,
  JsonFlow.TraitDependentRequired,
  JsonFlow.TraitDependentSchemas,
  JsonFlow.TraitDependencies,
  JsonFlow.TraitItems,
  JsonFlow.TraitAdditionalItems,
  JsonFlow.TraitMinItems,
  JsonFlow.TraitMaxItems,
  JsonFlow.TraitUniqueItems,
  JsonFlow.TraitContains,
  JsonFlow.TraitMinContains,
  JsonFlow.TraitMaxContains,
  JsonFlow.TraitAllOf,
  JsonFlow.TraitAnyOf,
  JsonFlow.TraitOneof,
  JsonFlow.TraitNot,
  JsonFlow.TraitIf,
  JsonFlow.TraitThen,
  JsonFlow.TraitElse,
  JsonFlow.TraitTitle,
  JsonFlow.TraitDescription,
  JsonFlow.TraitDefault,
  JsonFlow.TraitExamples,
  JsonFlow.TraitReadonly,
  JsonFlow.TraitWriteonly,
  JsonFlow.TraitDeprecated;

{ TJSONSchemaParser }

constructor TJSONSchemaParser.Create(const AValidator: TJSONSchemaValidator);
begin
  FValidator := AValidator;
  FRegisters := TDictionary<String, TJsonSchemaTraitClass>.Create;
  FDefsNodes := TDictionary<String, TSchemaNode>.Create;
  FRecursive := 0;
end;

destructor TJSONSchemaParser.Destroy;
begin
  FRegisters.Free;
  FDefsNodes.Free;
  FValidator := nil;
  inherited;
end;

function TJSONSchemaParser._ContainsRef(const ANode: IJSONElement): Boolean;
var
  LObj: IJSONObject;
  LPair: IJSONPair;
begin
  Result := False;
  if not Supports(ANode, IJSONObject, LObj) then
    Exit;
  if LObj.ContainsKey('$ref') then
    Exit(True);
  for LPair in LObj.Pairs do
  begin
    if _ContainsRef(LPair.Value) then
      Exit(True);
  end;
end;

function TJSONSchemaParser._GetTrait(AKeyword: String): IJSONSchemaTrait;
var
  LClass: TJsonSchemaTraitClass;
begin
  if not FRegisters.TryGetValue(AKeyword, LClass) then
    raise Exception.Create('Trait not registered for keyword: ' + AKeyword);

  Result := LClass.Create(FValidator);
  FValidator.AddLog('Created new trait for keyword: ' + AKeyword + ' - Instance: ' + IntToStr(Integer(Result)));
end;

function TJSONSchemaParser.Parse(ASchema: IJSONElement): TSchemaNode;
var
  LObj: IJSONObject;
  LPair: IJSONPair;
  LSubObj: IJSONObject;
  LSubPair: IJSONPair;
  LDefsNode: TSchemaNode;
  LContainsRef: Boolean;
begin
  FDefsNodes.Clear;
  // Pré-parseia $defs antes do nó raiz
  if Supports(ASchema, IJSONObject, LObj) and LObj.ContainsKey('$defs') then
  begin
    if Supports(LObj.GetValue('$defs'), IJSONObject, LSubObj) then
    begin
      for LSubPair in LSubObj.Pairs do
        FDefsNodes.Add('#/$defs/' + LSubPair.Key, _ParseNode(LSubPair.Value, '/$defs/' + LSubPair.Key));
    end;
  end;
  Result := _ParseNode(ASchema, '');
  // Verifica se o schema contém $ref
  LContainsRef := _ContainsRef(ASchema);
  if not LContainsRef then
  begin
    FValidator.AddLog('Schema does not contain $ref, transferring all $defs nodes to FRootNode');
    for LDefsNode in FDefsNodes.Values do
    begin
      LDefsNode.Parent := Result;
      Result.Children.Add(LDefsNode);
    end;
  end;
end;

function TJSONSchemaParser._ParseNode(const ANode: IJSONElement; const APath: String): TSchemaNode;
var
  LObj: IJSONObject;
  LPair: IJSONPair;
  LChildNode: TSchemaNode;
  LSubObj: IJSONObject;
  LSubPair: IJSONPair;
  LSubNode: TSchemaNode;
  LRef: String;
begin
  FRecursive := FRecursive + 1;
  Result := TSchemaNode.Create;
  FValidator.AddLog('Created TSchemaNode at ' + APath + ' - Recursive Number: ' + IntToStr(FRecursive));
  Result.Keyword := '';

  if not Supports(ANode, IJSONObject, LObj) then
  begin
    FValidator.AddLog('Node is not a JSONObject at ' + APath + ', exiting');
    Exit;
  end;
  FValidator.AddLog('Node is a JSONObject at ' + APath + '. ANode.AsJSON: ' + ANode.AsJSON);

  if LObj.ContainsKey('$ref') then
  begin
    LRef := (LObj.GetValue('$ref') as IJSONValue).AsString;
    Result.Keyword := '$ref';
    Result.Value := LObj.GetValue('$ref');
    Result.Trait := _GetTrait('$ref');
    Result.Trait.SetNode(Result);
    Result.Trait.Parse(LObj);
    FRecursive := FRecursive - 1;
    Exit;
  end;

  for LPair in LObj.Pairs do
  begin
    FValidator.AddLog('Found keyword: ' + LPair.Key + ' at ' + APath + '. Value: ' + LPair.Value.AsJSON);

    // Processar keywords registrados (exceto $ref e $defs)
    if FRegisters.ContainsKey(LPair.Key) and (LPair.Key <> '$ref') and (LPair.Key <> '$defs') then
    begin
      LChildNode := TSchemaNode.Create;
      try
        LChildNode.Keyword := LPair.Key;
        LChildNode.Value := LPair.Value;
        LChildNode.Trait := _GetTrait(LPair.Key);
        LChildNode.Trait.SetNode(LChildNode);
        LChildNode.Trait.Parse(LObj);
        LChildNode.Parent := Result;
        Result.Children.Add(LChildNode);

        // Processar propriedades apenas se for 'properties'
        if (LPair.Key = 'properties') and Supports(LPair.Value, IJSONObject, LSubObj) then
        begin
          FValidator.AddLog('Processing properties at ' + APath);
          for LSubPair in LSubObj.Pairs do
          begin
            FValidator.AddLog('Processing property: ' + LSubPair.Key);
            LSubNode := _ParseNode(LSubPair.Value, APath + '/properties/' + LSubPair.Key);
            if Assigned(LSubNode) then
            begin
              LSubNode.Keyword := LSubPair.Key;
              LSubNode.Parent := LChildNode;
              LChildNode.Children.Add(LSubNode);
            end;
          end;
        end;
      except
        LChildNode.Free;
        raise;
      end;
    end
    // Processar sub-objetos que não são keywords registrados
    else if Supports(LPair.Value, IJSONObject, LSubObj) and (LPair.Key <> '$ref') and (LPair.Key <> '$defs') then
    begin
      FValidator.AddLog('Processing sub-object: ' + LPair.Key);
      LSubNode := _ParseNode(LPair.Value, APath + '/' + LPair.Key);
      if Assigned(LSubNode) then
      begin
        LSubNode.Keyword := LPair.Key;
        LSubNode.Parent := Result;
        Result.Children.Add(LSubNode);
      end;
    end;
  end;

  FValidator.AddLog('Finished parsing node at ' + APath + ' with ' + IntToStr(Result.Children.Count) + ' children');
  FRecursive := FRecursive - 1;
end;

function TJSONSchemaParser._ResolveRef(const ARef, APath: String): IJSONElement;
var
  LRoot: IJSONObject;
  LParts: TArray<String>;
  LCurrent: IJSONElement;
  LFor: Integer;
begin
  Result := nil;
  if not Supports(FValidator.Schema, IJSONObject, LRoot) then
  begin
    FValidator.AddLog('Root schema is not a JSONObject, cannot resolve $ref: ' + ARef);
    Exit;
  end;

  // Suporta referências locais como "#/$defs/nonNegativeInteger"
  if ARef.StartsWith('#/') then
  begin
    LParts := ARef.Substring(2).Split(['/']); // Remove "#" e separa por "/"
    LCurrent := LRoot;
    for LFor := 0 to Length(LParts) - 1 do
    begin
      if Supports(LCurrent, IJSONObject) then
      begin
        LCurrent := (LCurrent as IJSONObject).GetValue(LParts[LFor]);
        if not Assigned(LCurrent) then
        begin
          FValidator.AddLog('Failed to resolve $ref part "' + LParts[LFor] + '" in ' + ARef);
          Exit;
        end;
      end
      else
      begin
        FValidator.AddLog('Cannot navigate $ref "' + ARef + '", current node is not an object');
        Exit;
      end;
    end;
    Result := LCurrent;
  end
  else
  begin
    FValidator.AddLog('Unsupported $ref format: ' + ARef + '. Only local references (#/...) are supported.');
  end;
end;

procedure TJSONSchemaParser.RegisterTrait(AKeyword: String; ATraitClass: TJsonSchemaTraitClass);
begin
  FRegisters.AddOrSetValue(AKeyword, ATraitClass);
end;

{ TJSONSchemaValidator }

procedure TJSONSchemaValidator.AddLog(const AMessage: String);
begin
  {$IFDEF DEBUG}
  Writeln(AMessage);
  {$ENDIF}
  if Assigned(FLogProc) then
    FLogProc(AMessage);
end;

constructor TJSONSchemaValidator.Create(const AVersion: TJsonSchemaVersion; const ARootSchema: IJSONElement);
begin
  FVersion := AVersion;
  FErrors := TList<TValidationError>.Create;
  FParser := TJSONSchemaParser.Create(Self);
  FTraitStats := TDictionary<String, Integer>.Create;
  FSchema := nil;
  _InitializeTraits;
end;

destructor TJSONSchemaValidator.Destroy;
begin
  FRootNode.Free;
  FParser.Free;
  FErrors.Free;
  FTraitStats.Free;
  FSchema := nil;
  inherited;
end;

procedure TJSONSchemaValidator._LogTraitValidation(const ATraitClass: String);
var
  LCount: Integer;
begin
  if FTraitStats.TryGetValue(ATraitClass, LCount) then
    FTraitStats[ATraitClass] := LCount + 1
  else
    FTraitStats.Add(ATraitClass, 1);
end;

procedure TJSONSchemaValidator.ReportStats;
var
  LPair: TPair<String, Integer>;
begin
  AddLog('Trait Validation Stats:');
  for LPair in FTraitStats do
    AddLog('Trait ' + LPair.Key + ': ' + IntToStr(LPair.Value) + ' validations');
end;

procedure TJSONSchemaValidator.AddError(const APath, AMessage, AFound, AExpected, AKeyword: String;
  ALineNumber: Integer; AColumnNumber: Integer; AContext: String);
var
  LError: TValidationError;
begin
  LError.Path := APath;
  LError.Message := AMessage;
  LError.FoundValue := AFound;
  LError.ExpectedValue := AExpected;
  LError.Keyword := AKeyword;
  LError.LineNumber := ALineNumber;
  LError.ColumnNumber := AColumnNumber;
  LError.Context := AContext;
  FErrors.Add(LError);
end;

procedure TJSONSchemaValidator._InitializeTraits;
begin
  if FVersion >= jsvDraft3 then
  begin
    FParser.RegisterTrait('$schema', TSchemaTrait);
    FParser.RegisterTrait('$id', TIdTrait);
    FParser.RegisterTrait('$ref', TRefTrait);
    FParser.RegisterTrait('type', TTypeTrait);
    FParser.RegisterTrait('const', TConstTrait);
    FParser.RegisterTrait('enum', TEnumTrait);
    FParser.RegisterTrait('minimum', TMinimumTrait);
    FParser.RegisterTrait('maximum', TMaximumTrait);
    FParser.RegisterTrait('exclusiveMinimum', TExclusiveMinimumTrait);
    FParser.RegisterTrait('exclusiveMaximum', TExclusiveMaximumTrait);
    FParser.RegisterTrait('multipleOf', TMultipleOfTrait);
    FParser.RegisterTrait('divisibleBy', TDivisibleByTrait);
    FParser.RegisterTrait('minLength', TMinLengthTrait);
    FParser.RegisterTrait('maxLength', TMaxLengthTrait);
    FParser.RegisterTrait('pattern', TPatternTrait);
    FParser.RegisterTrait('format', TFormatTrait);
    FParser.RegisterTrait('properties', TPropertiesTrait);
    FParser.RegisterTrait('additionalProperties', TAdditionalPropertiesTrait);
    FParser.RegisterTrait('patternProperties', TPatternPropertiesTrait);
    FParser.RegisterTrait('required', TRequiredTrait);
    FParser.RegisterTrait('propertyNames', TPropertyNamesTrait);
    FParser.RegisterTrait('minProperties', TMinPropertiesTrait);
    FParser.RegisterTrait('maxProperties', TMaxPropertiesTrait);
    FParser.RegisterTrait('dependencies', TDependenciesTrait);
    FParser.RegisterTrait('items', TItemsTrait);
    FParser.RegisterTrait('additionalItems', TAdditionalItemsTrait);
    FParser.RegisterTrait('minItems', TMinItemsTrait);
    FParser.RegisterTrait('maxItems', TMaxItemsTrait);
    FParser.RegisterTrait('uniqueItems', TUniqueItemsTrait);
    FParser.RegisterTrait('title', TTitleTrait);
    FParser.RegisterTrait('description', TDescriptionTrait);
    FParser.RegisterTrait('default', TDefaultTrait);
  end;

  if FVersion >= jsvDraft6 then
  begin
    FParser.RegisterTrait('$anchor', TAnchorTrait);
    FParser.RegisterTrait('allOf', TAllOfTrait);
    FParser.RegisterTrait('anyOf', TAnyOfTrait);
    FParser.RegisterTrait('oneOf', TOneOfTrait);
    FParser.RegisterTrait('not', TNotTrait);
    FParser.RegisterTrait('contains', TContainsTrait);
    FParser.RegisterTrait('examples', TExamplesTrait);
  end;

  if FVersion >= jsvDraft7 then
  begin
    FParser.RegisterTrait('if', TIfTrait);
    FParser.RegisterTrait('then', TThenTrait);
    FParser.RegisterTrait('else', TElseTrait);
    FParser.RegisterTrait('readOnly', TReadOnlyTrait);
    FParser.RegisterTrait('writeOnly', TWriteOnlyTrait);
    FParser.RegisterTrait('contentEncoding', TContentEncodingTrait);
    FParser.RegisterTrait('contentMediaType', TContentMediaTypeTrait);
    FParser.RegisterTrait('contentSchema', TContentSchemaTrait);
  end;

  if FVersion >= jsvDraft201909 then
  begin
    FParser.RegisterTrait('$defs', TDefsTrait);
    FParser.RegisterTrait('$vocabulary', TVocabularyTrait);
    FParser.RegisterTrait('$comment', TCommentTrait);
    FParser.RegisterTrait('dependentRequired', TDependentRequiredTrait);
    FParser.RegisterTrait('dependentSchemas', TDependentSchemasTrait);
    FParser.RegisterTrait('minContains', TMinContainsTrait);
    FParser.RegisterTrait('maxContains', TMaxContainsTrait);
    FParser.RegisterTrait('deprecated', TDeprecatedTrait);
  end;
end;

function TJSONSchemaValidator._GetSchema: IJSONElement;
begin
  Result := FSchema;
end;

procedure TJSONSchemaValidator._SetSchema(const AValue: IJSONElement);
begin
  FSchema := AValue;
end;

function TJSONSchemaValidator.GetDefsNodes: TDictionary<String, TSchemaNode>;
begin
  Result := FParser.FDefsNodes;
end;

function TJSONSchemaValidator.GetErrors: TArray<TValidationError>;
begin
  Result := FErrors.ToArray;
end;

function TJSONSchemaValidator.GetVersion: TJsonSchemaVersion;
begin
  Result := FVersion;
end;

function TJSONSchemaValidator.GetLastError: string;
begin
  if FErrors.Count > 0 then
    Result := FErrors.Last.Message
  else
    Result := '';
end;

function TJSONSchemaValidator.GetRootNode: TSchemaNode;
begin
  Result := FRootNode;
end;

procedure TJSONSchemaValidator.OnLog(const ALogProc: TProc<String>);
begin
  FLogProc := ALogProc;
end;

function TJSONSchemaValidator.ParseNode(ANode: IJSONElement; APath: String): TSchemaNode;
begin
  Result := FParser._ParseNode(ANode, APath);
end;

procedure TJSONSchemaValidator.ParseSchema(const ASchema: IJSONElement);
begin
  AddLog('ParseSchema started with ASchema: ' + IfThen(Assigned(ASchema), ASchema.AsJSON, 'nil'));

  if not Assigned(ASchema) then
  begin
    AddLog('ASchema is nil, initializing FSchema as empty object');
    FSchema := TJSONObject.Create;
    Exit;
  end;

  if Assigned(FRootNode) then
  begin
    FRootNode.Free;
    FRootNode := nil;
  end;
  FSchema := nil;

  FSchema := ASchema;
  AddLog('Parsing schema into tree');
  FRootNode := FParser.Parse(FSchema);
end;

function TJSONSchemaValidator.Validate(const AElement: IJSONElement; const APath: String): Boolean;
var
  LErrors: TList<TValidationError>;
begin
  AddLog('TJSONSchemaValidator.Validate started for element: ' + AElement.AsJSON + ' at path: ' + APath);
  FErrors.Clear;
  FTraitStats.Clear;
  if Assigned(FRootNode) then
    FRootNode.ResetValidationState;
  LErrors := TList<TValidationError>.Create;
  try
    Result := True;
    if not Assigned(FRootNode) then
    begin
      AddLog('FRootNode is nil');
      Exit(False);
    end;
    AddLog('FRootNode is assigned, starting validation');

    if not ValidateNode(FRootNode, AElement, APath, LErrors) then
      Result := False;

    if not Result then
      FErrors.AddRange(LErrors);
    AddLog('TJSONSchemaValidator.Validate finished with result: ' + BoolToStr(Result, True));
    ReportStats;
  finally
    LErrors.Free;
  end;
end;

function TJSONSchemaValidator.ValidateNode(const ANode: TSchemaNode; const AElement: IJSONElement;
  const ACurrentPath: String; var AErrors: TList<TValidationError>): Boolean;
var
  LChildNode: TSchemaNode;
  LObj: IJSONObject;
  LElementToValidate: IJSONElement;
  LParentKeyword: String;
  LPropertyName: String;
  LChildPath: String;
begin
  Result := True;
  if not Assigned(ANode) then
  begin
    AddLog('Node is nil at ' + ACurrentPath);
    Exit;
  end;

  AddLog('Processing node: ' + ANode.Keyword + ' at ' + ACurrentPath + ' with element: ' + AElement.AsJSON);

  if ANode.IsValidated then
  begin
    AddLog('Skipping already validated node at ' + ACurrentPath);
    Exit(True);
  end;

  if (ANode.Keyword = '$defs') and (ACurrentPath = '/$defs') then
  begin
    AddLog('Skipping direct validation of $defs at root level');
    Exit;
  end;

  if Assigned(ANode.Trait) then
  begin
    AddLog('Calling Validate for trait at ' + ACurrentPath + ' with keyword: ' + ANode.Keyword);
    try
      _LogTraitValidation(TObject(ANode.Trait).ClassName);
      Result := ANode.Trait.Validate(AElement, ACurrentPath, AErrors);
    except
      on E: Exception do
      begin
        AddLog('Exception in Validate for ' + ANode.Keyword + ' at ' + ACurrentPath + ': ' + E.Message);
        Result := False;
      end;
    end;
  end
  else
    AddLog('No trait assigned to node at ' + ACurrentPath + ' with keyword: ' + ANode.Keyword);

  for LChildNode in ANode.Children do
  begin
    LChildPath := ACurrentPath;
    if LChildPath <> '' then
      LChildPath := LChildPath + '/';
    LChildPath := LChildPath + LChildNode.Keyword;
    AddLog('Processing child node: ' + LChildNode.Keyword + ' at ' + LChildPath);
    LElementToValidate := AElement;

    if Assigned(ANode.Parent) then
      LParentKeyword := ANode.Parent.Keyword
    else
      LParentKeyword := '';

    if Supports(AElement, IJSONObject, LObj) then
    begin
      if ANode.Keyword = 'properties' then
      begin
        LPropertyName := LChildNode.Keyword;
        if LObj.ContainsKey(LPropertyName) then
        begin
          LElementToValidate := LObj.GetValue(LPropertyName);
          AddLog('Using property value ' + LElementToValidate.AsJSON + ' for ' + LPropertyName);
        end
        else
        begin
          AddLog('Property ' + LPropertyName + ' not found in element ' + AElement.AsJSON);
          LElementToValidate := TJSONObject.Create;
        end;
      end
      else if LParentKeyword = 'properties' then
      begin
        LElementToValidate := AElement;
        AddLog('Maintaining property value ' + LElementToValidate.AsJSON + ' for child node ' + LChildNode.Keyword);
      end
      else if LObj.ContainsKey(LChildNode.Keyword) then
      begin
        LElementToValidate := LObj.GetValue(LChildNode.Keyword);
        AddLog('Found child key ' + LChildNode.Keyword + ' in element, using ' + LElementToValidate.AsJSON);
      end;
    end;

    AddLog('Passing subelement ' + LElementToValidate.AsJSON + ' to child node ' + LChildNode.Keyword);
    if not ValidateNode(LChildNode, LElementToValidate, LChildPath, AErrors) then
      Result := False;
  end;
  ANode.IsValidated := True;
end;

function TJSONSchemaValidator.Validate(const AJson, AJsonSchema: String): Boolean;
var
  LSchemaReader: TJsonReader;
  LJsonReader: TJsonReader;
  LSchemaElement: IJSONElement;
  LJsonElement: IJSONElement;
begin
  FErrors.Clear;
  Result := False;

  LSchemaReader := TJsonReader.Create;
  try
    try
      LSchemaElement := LSchemaReader.Read(AJsonSchema);
      ParseSchema(LSchemaElement);
      AddLog('Schema parsed successfully');
    except
      on E: Exception do
      begin
        AddError('', 'Failed to parse schema', AJsonSchema, 'valid JSON schema', 'schema', -1, -1, E.Message);
        Result := False;
        Exit;
      end;
    end;
  finally
    LSchemaReader.Free;
  end;

  LJsonReader := TJsonReader.Create;
  try
    try
      LJsonElement := LJsonReader.Read(AJson);
      Result := Validate(LJsonElement, '');
    except
      on E: Exception do
      begin
        AddError('', 'Failed to parse JSON', AJson, 'valid JSON', 'json', -1, -1, E.Message);
        Result := False;
      end;
    end;
  finally
    LJsonReader.Free;
  end;
end;

{TJsonSchemaTrait}

constructor TJsonSchemaTrait.Create(const AValidator: TJSONSchemaValidator);
begin
  FValidator := AValidator;
end;

destructor TJsonSchemaTrait.Destroy;
begin
  if Assigned(FNode) then
    FNode := nil;
  FValidator := nil;
  inherited;
end;

procedure TJsonSchemaTrait.SetNode(const ANode: TSchemaNode);
begin
  FNode := ANode;
end;

end.
