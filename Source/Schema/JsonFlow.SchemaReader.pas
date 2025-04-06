unit JsonFlow.SchemaReader;

interface

uses
  SysUtils,
  Classes,
  IOUtils,
  StrUtils,
  JsonFlow.Interfaces,
  JsonFlow.Reader,
  JsonFlow.SchemaValidator;

type
  TJSONSchemaReader = class(TInterfacedObject, IJSONSchemaReader)
  private
    FLogProc: TProc<String>;
    FSchema: IJSONElement;
    FValidator: IJSONSchemaValidator;
    FReader: TJSONReader;
    function _DetectVersion(const AElement: IJSONElement): TJsonSchemaVersion;
    procedure _CreateValidator(const AVersion: TJsonSchemaVersion);
    function _LoadSchema(const AJson: string): Boolean;
  protected
    procedure _Log(const AMessage: string);
  public
    constructor Create;
    destructor Destroy; override;
    function LoadFromFile(const AFileName: string): Boolean;
    function LoadFromString(const AJsonString: string): Boolean;
    function Validate(const AJson: string): Boolean; overload;
    function Validate(const AElement: IJSONElement): Boolean; overload;
    function Validate(const AJson, AJsonSchema: String): Boolean; overload;
    function GetErrors: TArray<TValidationError>;
    function GetVersion: TJsonSchemaVersion;
    function GetSchema: IJSONElement;
  end;

implementation

constructor TJSONSchemaReader.Create;
begin
  FReader := TJSONReader.Create;
  FValidator := TJSONSchemaValidator.Create(jsvDraft7);
end;

destructor TJSONSchemaReader.Destroy;
begin
  FValidator := nil;
  FReader.Free;
  inherited;
end;

function TJSONSchemaReader._DetectVersion(const AElement: IJSONElement): TJsonSchemaVersion;
var
  LObj: IJSONObject;
  LSchemaValue: IJSONValue;
  LSchema: string;
begin
  Result := jsvDraft7;
  if not Supports(AElement, IJSONObject, LObj) then
    Exit;
  LSchemaValue := LObj.GetValue('$schema') as IJSONValue;
  if Assigned(LSchemaValue) then
  begin
    LSchema := LSchemaValue.AsString.ToLower;
    if ContainsText(LSchema, 'draft-03/schema') then
      Result := jsvDraft3
    else if ContainsText(LSchema, 'draft-04/schema') then
      Result := jsvDraft4
    else if ContainsText(LSchema, 'draft-06/schema') then
      Result := jsvDraft6
    else if ContainsText(LSchema, 'draft-07/schema') then
      Result := jsvDraft7
    else if ContainsText(LSchema, '2019-09/schema') then
      Result := jsvDraft201909
    else if ContainsText(LSchema, '2020-12/schema') then
      Result := jsvDraft202012
    else
      FValidator.AddError('', 'Unknown schema version, defaulting to Draft 7', LSchema, 'recognized version', '$schema');
  end;
end;

procedure TJSONSchemaReader._CreateValidator(const AVersion: TJsonSchemaVersion);
begin
  FValidator := nil;
  FValidator := TJSONSchemaValidator.Create(AVersion);
end;

function TJSONSchemaReader._LoadSchema(const AJson: string): Boolean;
var
  LVersion: TJsonSchemaVersion;
  LOldErrors: TArray<TValidationError>;
  LFor: Integer;
begin
  Writeln('TJSONSchemaReader._LoadSchema called with: "', AJson, '"');
  Result := True;
  try
    FSchema := FReader.Read(AJson);
    Writeln('FSchema after Read: ', IfThen(Assigned(FSchema), FSchema.AsJSON, 'nil'));
    _CreateValidator(jsvDraft7);
    Writeln('Validator created with Draft7');
    LVersion := _DetectVersion(FSchema);
    Writeln('Detected version: ', Integer(LVersion));
    if LVersion <> FValidator.GetVersion then
    begin
      LOldErrors := FValidator.GetErrors;
      FValidator := nil;
      FValidator := TJSONSchemaValidator.Create(LVersion);
      for LFor := 0 to Length(LOldErrors) - 1 do
        FValidator.AddError(LOldErrors[LFor].Path, LOldErrors[LFor].Message,
          LOldErrors[LFor].FoundValue, LOldErrors[LFor].ExpectedValue,
          LOldErrors[LFor].Keyword, LOldErrors[LFor].LineNumber,
          LOldErrors[LFor].ColumnNumber, LOldErrors[LFor].Context);
      Writeln('Validator recreated with version: ', Integer(LVersion));
    end;
    FValidator.ParseSchema(FSchema);
    Writeln('Schema parsed successfully');
  except
    on E: Exception do
    begin
      Writeln('Exception in _LoadSchema: ', E.Message, ' at ', E.StackTrace);
      _CreateValidator(jsvDraft7);
      FValidator.AddError('', 'Failed to load schema', '', 'valid JSON', 'load', -1, -1, E.Message);
      Result := False;
    end;
  end;
end;

procedure TJSONSchemaReader._Log(const AMessage: string);
begin
  if Assigned(FLogProc) then
    FLogProc(Amessage);
end;

function TJSONSchemaReader.LoadFromFile(const AFileName: string): Boolean;
begin
  Result := _LoadSchema(TFile.ReadAllText(AFileName));
end;

function TJSONSchemaReader.LoadFromString(const AJsonString: string): Boolean;
begin
  Result := _LoadSchema(AJsonString);
end;

function TJSONSchemaReader.Validate(const AJson: string): Boolean;
var
  LElement: IJSONElement;
begin
  LElement := FReader.Read(AJson);
  Result := Validate(LElement);
end;

function TJSONSchemaReader.Validate(const AElement: IJSONElement): Boolean;
begin
  if not Assigned(FSchema) then
    raise Exception.Create('No schema loaded');
  Result := FValidator.Validate(AElement, '');
end;

function TJSONSchemaReader.Validate(const AJson, AJsonSchema: String): Boolean;
begin
  Result := FValidator.Validate(AJson, AJsonSchema);
end;

function TJSONSchemaReader.GetErrors: TArray<TValidationError>;
begin
  Result := FValidator.GetErrors;
end;

function TJSONSchemaReader.GetVersion: TJsonSchemaVersion;
begin
  Result := FValidator.GetVersion;
end;

function TJSONSchemaReader.GetSchema: IJSONElement;
begin
  Result := FSchema;
end;

end.
