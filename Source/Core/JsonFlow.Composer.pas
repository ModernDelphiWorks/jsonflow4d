unit JsonFlow.Composer;

interface

uses
  Rtti,
  SysUtils,
  Classes,
  Variants,
  Generics.Collections,
  JsonFlow.Utils,
  JsonFlow.Value,
  JsonFlow.Interfaces,
  JsonFlow.Navigator;

type
  TJSONComposer = class
  private
    function _FindElement(const APath: String): IJSONElement;
    function _FindParentAndKey(const APath: String; out AKey: String): IJSONElement;
    function _CloneElement(const AElement: IJSONElement): IJSONElement;
    function _ExtractArrayIndex(const APart: String; out AIndex: Integer): Boolean;
  protected
    FRoot: IJSONElement;
    FCurrent: IJSONElement;
    FLogProc: TProc<String>;
    FStack: TStack<IJSONElement>;
    FNameStack: TStack<String>;
    procedure _Pop;
    procedure _Push(const AElement: IJSONElement; const AName: String);
  public
    constructor Create;
    destructor Destroy; override;
    function BeginObject(const AName: String = ''): TJSONComposer;
    function BeginArray(const AName: String = ''): TJSONComposer;
    function EndObject: TJSONComposer;
    function EndArray: TJSONComposer;
    function Add(const AName: String; const AValue: String): TJSONComposer; overload;
    function Add(const AName: String; const AValue: Integer): TJSONComposer; overload;
    function Add(const AName: String; const AValue: Double): TJSONComposer; overload;
    function Add(const AName: String; const AValue: Boolean): TJSONComposer; overload;
    function Add(const AName: String; const AValue: TDateTime): TJSONComposer; overload;
    function Add(const AName: String; const AValue: IJSONElement): TJSONComposer; overload;
    function Add(const AName: String; const AValue: Char): TJSONComposer; overload;
    function Add(const AName: String; const AValue: Variant): TJSONComposer; overload;
    function AddNull(const AName: String): TJSONComposer;
    function AddArray(const AName: String; const AValues: array of TValue): TJSONComposer;
    function AddJSON(const AName: String; const AJson: String): TJSONComposer;
    function Add(const AName: String; const AValues: TArray<Integer>): TJSONComposer; overload;
    function Add(const AName: String; const AValues: TArray<String>): TJSONComposer; overload;
    function Add(const AName: String; const AValues: TArray<Double>): TJSONComposer; overload;
    function Add(const AName: String; const AValues: TArray<Boolean>): TJSONComposer; overload;
    function Add(const AName: String; const AValues: TArray<TDateTime>): TJSONComposer; overload;
    function Add(const AName: String; const AValues: TArray<Char>): TJSONComposer; overload;
    function Add(const AName: String; const AValues: TArray<Variant>): TJSONComposer; overload;
    function Merge(const AElement: IJSONElement): TJSONComposer;
    function LoadJSON(const AJson: String): TJSONComposer;
    function AddToArray(const APath: String; const AValue: Variant): TJSONComposer; overload;
    function AddToArray(const APath: String; const AElement: IJSONElement): TJSONComposer; overload;
    function AddToArray(const APath: String; const AValues: TArray<Variant>): TJSONComposer; overload;
    function MergeArray(const APath: String; const AValues: TArray<Variant>): TJSONComposer;
    function RemoveFromArray(const APath: String; const AIndex: Integer): TJSONComposer;
    function ReplaceArray(const APath: String; const AValues: TArray<Variant>): TJSONComposer;
    function AddObject(const APath: String; const AName: String): TJSONComposer;
    function SetValue(const APath: String; const AValue: Variant): TJSONComposer;
    function RemoveKey(const APath: String): TJSONComposer;
    function Clone: IJSONElement;
    function ToJSON(const AIdent: Boolean = False): String; overload; virtual;
    function ToElement: IJSONElement;
    function ForEach(const ACallback: TProc<String, IJSONElement>): TJSONComposer;
    function Clear: TJSONComposer;
    procedure OnLog(const ALogProc: TProc<String>);
    procedure AddLog(const AMessage: String);
  end;

implementation

uses
  JsonFlow.Objects,
  JsonFlow.Arrays,
  JsonFlow.Writer,
  JsonFlow.Reader;

{ TJSONComposer }

constructor TJSONComposer.Create;
begin
  FStack := TStack<IJSONElement>.Create;
  FNameStack := TStack<String>.Create;
end;

destructor TJSONComposer.Destroy;
begin
  Clear;
  FNameStack.Free;
  FStack.Free;
  inherited;
end;

procedure TJSONComposer._Push(const AElement: IJSONElement; const AName: String);
begin
  if Assigned(FCurrent) then
  begin
    FStack.Push(FCurrent);
    FNameStack.Push(AName);
  end;
  FCurrent := AElement;
  if not Assigned(FRoot) then
  begin
    FRoot := AElement;
    if AName <> '' then
      FNameStack.Push(AName);
  end;
end;

procedure TJSONComposer._Pop;
var
  LParent: IJSONElement;
  LObject: IJSONObject;
  LArray: IJSONArray;
  LName: String;
begin
  if FStack.Count > 0 then
  begin
    LParent := FStack.Pop;
    LName := FNameStack.Pop;
    if Supports(LParent, IJSONObject, LObject) then
      LObject.Add(LName, FCurrent)
    else if Supports(LParent, IJSONArray, LArray) then
      LArray.Add(FCurrent);
    FCurrent := LParent;
  end
  else
  begin
    if FNameStack.Count > 0 then
      FNameStack.Pop;
    FCurrent := nil;
  end;
end;

function TJSONComposer._FindElement(const APath: String): IJSONElement;
var
  LNavigator: TJSONNavigator;
begin
  if not Assigned(FRoot) then
    raise EInvalidOperation.Create('No JSON loaded');

  LNavigator := TJSONNavigator.Create(FRoot);
  try
    Result := LNavigator.GetValue(APath);
    if not Assigned(Result) then
      raise EInvalidOperation.Create('Path not found: ' + APath);
  finally
    LNavigator.Free;
  end;
end;

function TJSONComposer._FindParentAndKey(const APath: String; out AKey: String): IJSONElement;
var
  LNavigator: TJSONNavigator;
  LParts: TArray<String>;
  LParentPath: String;
begin
  if not Assigned(FRoot) then
    raise EInvalidOperation.Create('No JSON loaded');

  LParts := APath.Split(['.']);
  AKey := LParts[Length(LParts) - 1];
  LParentPath := Copy(APath, 1, Length(APath) - Length(AKey) - 1);

  LNavigator := TJSONNavigator.Create(FRoot);
  try
    if LParentPath = '' then
      Result := FRoot
    else
    begin
      Result := LNavigator.GetValue(LParentPath);
      if not Assigned(Result) then
        raise EInvalidOperation.Create('Parent path not found: ' + LParentPath);
    end;
  finally
    LNavigator.Free;
  end;
end;

function TJSONComposer._ExtractArrayIndex(const APart: String; out AIndex: Integer): Boolean;
var
  LStart, LEnd: Integer;
  LIndexStr: String;
begin
  Result := False;
  LStart := Pos('[', APart);
  LEnd := Pos(']', APart);
  if (LStart > 0) and (LEnd > LStart) then
  begin
    LIndexStr := Copy(APart, LStart + 1, LEnd - LStart - 1);
    Result := TryStrToInt(LIndexStr, AIndex) and (AIndex >= 0);
  end;
end;

function TJSONComposer._CloneElement(const AElement: IJSONElement): IJSONElement;
var
  LObject: IJSONObject;
  LArray: IJSONArray;
  LValue: IJSONValue;
  LPairs: TArray<IJSONPair>;
  LItems: TArray<IJSONElement>;
  LNewObj: TJSONObject;
  LNewArr: TJSONArray;
  LFor: Integer;
begin
  if not Assigned(AElement) then
    Exit(nil);

  if Supports(AElement, IJSONObject, LObject) then
  begin
    LNewObj := TJSONObject.Create;
    LPairs := LObject.Pairs;
    for LFor := 0 to Length(LPairs) - 1 do
      LNewObj.Add(LPairs[LFor].Key, _CloneElement(LPairs[LFor].Value));
    Result := LNewObj;
  end
  else if Supports(AElement, IJSONArray, LArray) then
  begin
    LNewArr := TJSONArray.Create;
    LItems := LArray.Items;
    for LFor := 0 to Length(LItems) - 1 do
      LNewArr.Add(_CloneElement(LItems[LFor]));
    Result := LNewArr;
  end
  else if Supports(AElement, IJSONValue, LValue) then
  begin
    if LValue is TJSONValueString then
      Result := TJSONValueString.Create(LValue.AsString)
    else if LValue is TJSONValueInteger then
      Result := TJSONValueInteger.Create(LValue.AsInteger)
    else if LValue is TJSONValueFloat then
      Result := TJSONValueFloat.Create(LValue.AsFloat)
    else if LValue is TJSONValueBoolean then
      Result := TJSONValueBoolean.Create(LValue.AsBoolean)
    else if LValue is TJSONValueDateTime then
      Result := TJSONValueDateTime.Create(LValue.AsString, True)
    else if LValue is TJSONValueNull then
      Result := TJSONValueNull.Create
    else
      raise EInvalidOperation.Create('Unknown JSON value type');
  end
  else
    raise EInvalidOperation.Create('Unsupported JSON element type');
end;

function TJSONComposer.BeginObject(const AName: String): TJSONComposer;
begin
  _Push(TJSONObject.Create, AName);
  Result := Self;
end;

function TJSONComposer.BeginArray(const AName: String): TJSONComposer;
begin
  _Push(TJSONArray.Create, AName);
  Result := Self;
end;

function TJSONComposer.EndObject: TJSONComposer;
begin
  _Pop;
  Result := Self;
end;

function TJSONComposer.EndArray: TJSONComposer;
begin
  _Pop;
  Result := Self;
end;

function TJSONComposer.Add(const AName: String; const AValue: String): TJSONComposer;
var
  LObject: IJSONObject;
  LArray: IJSONArray;
begin
  if Supports(FCurrent, IJSONObject, LObject) then
    LObject.Add(AName, TJSONValueString.Create(AValue))
  else if Supports(FCurrent, IJSONArray, LArray) then
    LArray.Add(TJSONValueString.Create(AValue));
  Result := Self;
end;

function TJSONComposer.Add(const AName: String; const AValue: Integer): TJSONComposer;
var
  LObject: IJSONObject;
  LArray: IJSONArray;
begin
  if Supports(FCurrent, IJSONObject, LObject) then
    LObject.Add(AName, TJSONValueInteger.Create(AValue))
  else if Supports(FCurrent, IJSONArray, LArray) then
    LArray.Add(TJSONValueInteger.Create(AValue));
  Result := Self;
end;

function TJSONComposer.Add(const AName: String; const AValue: Double): TJSONComposer;
var
  LObject: IJSONObject;
  LArray: IJSONArray;
begin
  if Supports(FCurrent, IJSONObject, LObject) then
    LObject.Add(AName, TJSONValueFloat.Create(AValue))
  else if Supports(FCurrent, IJSONArray, LArray) then
    LArray.Add(TJSONValueFloat.Create(AValue));
  Result := Self;
end;

function TJSONComposer.Add(const AName: String; const AValue: Boolean): TJSONComposer;
var
  LObject: IJSONObject;
  LArray: IJSONArray;
begin
  if Supports(FCurrent, IJSONObject, LObject) then
    LObject.Add(AName, TJSONValueBoolean.Create(AValue))
  else if Supports(FCurrent, IJSONArray, LArray) then
    LArray.Add(TJSONValueBoolean.Create(AValue));
  Result := Self;
end;

function TJSONComposer.Add(const AName: String; const AValue: TDateTime): TJSONComposer;
var
  LObject: IJSONObject;
  LArray: IJSONArray;
begin
  if Supports(FCurrent, IJSONObject, LObject) then
    LObject.Add(AName, TJSONValueDateTime.Create(AValue))
  else if Supports(FCurrent, IJSONArray, LArray) then
    LArray.Add(TJSONValueDateTime.Create(AValue));
  Result := Self;
end;

function TJSONComposer.Add(const AName: String; const AValue: IJSONElement): TJSONComposer;
var
  LObject: IJSONObject;
  LArray: IJSONArray;
begin
  if Supports(FCurrent, IJSONObject, LObject) then
    LObject.Add(AName, AValue)
  else if Supports(FCurrent, IJSONArray, LArray) then
    LArray.Add(AValue);
  Result := Self;
end;

function TJSONComposer.Add(const AName: String; const AValue: Char): TJSONComposer;
var
  LObject: IJSONObject;
  LArray: IJSONArray;
begin
  if Supports(FCurrent, IJSONObject, LObject) then
    LObject.Add(AName, TJSONValueString.Create(AValue))
  else if Supports(FCurrent, IJSONArray, LArray) then
    LArray.Add(TJSONValueString.Create(AValue));
  Result := Self;
end;

function TJSONComposer.Add(const AName: String; const AValue: Variant): TJSONComposer;
var
  LObject: IJSONObject;
  LArray: IJSONArray;
begin
  if Supports(FCurrent, IJSONObject, LObject) then
  begin
    case VarType(AValue) and varTypeMask of
      varInteger, varShortInt, varByte, varWord, varLongWord: LObject.Add(AName, TJSONValueInteger.Create(AValue));
      varSingle, varDouble, varCurrency: LObject.Add(AName, TJSONValueFloat.Create(AValue));
      varBoolean: LObject.Add(AName, TJSONValueBoolean.Create(AValue));
      varDate: LObject.Add(AName, TJSONValueDateTime.Create(VarToStr(AValue), True));
      varEmpty, varNull: LObject.Add(AName, TJSONValueNull.Create);
    else
      LObject.Add(AName, TJSONValueString.Create(VarToStr(AValue)));
    end;
  end
  else if Supports(FCurrent, IJSONArray, LArray) then
  begin
    case VarType(AValue) and varTypeMask of
      varInteger, varShortInt, varByte, varWord, varLongWord: LArray.Add(TJSONValueInteger.Create(AValue));
      varSingle, varDouble, varCurrency: LArray.Add(TJSONValueFloat.Create(AValue));
      varBoolean: LArray.Add(TJSONValueBoolean.Create(AValue));
      varDate: LArray.Add(TJSONValueDateTime.Create(VarToStr(AValue), True));
      varEmpty, varNull: LArray.Add(TJSONValueNull.Create);
    else
      LArray.Add(TJSONValueString.Create(VarToStr(AValue)));
    end;
  end;
  Result := Self;
end;

function TJSONComposer.AddNull(const AName: String): TJSONComposer;
var
  LObject: IJSONObject;
  LArray: IJSONArray;
begin
  if Supports(FCurrent, IJSONObject, LObject) then
    LObject.Add(AName, TJSONValueNull.Create)
  else if Supports(FCurrent, IJSONArray, LArray) then
    LArray.Add(TJSONValueNull.Create);
  Result := Self;
end;

function TJSONComposer.AddArray(const AName: String; const AValues: array of TValue): TJSONComposer;
var
  LArray: TJSONArray;
  LFor: Integer;
begin
  LArray := TJSONArray.Create;
  for LFor := Low(AValues) to High(AValues) do
    case AValues[LFor].Kind of
      tkInteger: LArray.Add(TJSONValueInteger.Create(AValues[LFor].AsInteger));
      tkFloat: LArray.Add(TJSONValueFloat.Create(AValues[LFor].AsExtended));
      tkString, tkLString, tkWString, tkUString: LArray.Add(TJSONValueString.Create(AValues[LFor].AsString));
      tkEnumeration: if AValues[LFor].TypeInfo = TypeInfo(Boolean) then
                       LArray.Add(TJSONValueBoolean.Create(AValues[LFor].AsBoolean))
                     else
                       LArray.Add(TJSONValueInteger.Create(AValues[LFor].AsInteger));
      else
        LArray.Add(TJSONValueNull.Create);
    end;
  Add(AName, LArray);
  Result := Self;
end;

function TJSONComposer.AddJSON(const AName: String; const AJson: String): TJSONComposer;
var
  LReader: TJSONReader;
  LObject: IJSONObject;
  LArray: IJSONArray;
begin
  LReader := TJSONReader.Create;
  try
    if Supports(FCurrent, IJSONObject, LObject) then
      LObject.Add(AName, LReader.Read(AJson))
    else if Supports(FCurrent, IJSONArray, LArray) then
      LArray.Add(LReader.Read(AJson));
  finally
    LReader.Free;
  end;
  Result := Self;
end;

procedure TJSONComposer.AddLog(const AMessage: String);
begin
  if Assigned(FLogProc) then
    FLogProc(AMessage);
end;

function TJSONComposer.Add(const AName: String; const AValues: TArray<Integer>): TJSONComposer;
var
  LArray: TJSONArray;
  LFor: Integer;
begin
  LArray := TJSONArray.Create;
  for LFor := 0 to Length(AValues) - 1 do
    LArray.Add(TJSONValueInteger.Create(AValues[LFor]));
  Add(AName, LArray);
  Result := Self;
end;

function TJSONComposer.Add(const AName: String; const AValues: TArray<String>): TJSONComposer;
var
  LArray: TJSONArray;
  LFor: Integer;
begin
  LArray := TJSONArray.Create;
  for LFor := 0 to Length(AValues) - 1 do
    LArray.Add(TJSONValueString.Create(AValues[LFor]));
  Add(AName, LArray);
  Result := Self;
end;

function TJSONComposer.Add(const AName: String; const AValues: TArray<Double>): TJSONComposer;
var
  LArray: TJSONArray;
  LFor: Integer;
begin
  LArray := TJSONArray.Create;
  for LFor := 0 to Length(AValues) - 1 do
    LArray.Add(TJSONValueFloat.Create(AValues[LFor]));
  Add(AName, LArray);
  Result := Self;
end;

function TJSONComposer.Add(const AName: String; const AValues: TArray<Boolean>): TJSONComposer;
var
  LArray: TJSONArray;
  LFor: Integer;
begin
  LArray := TJSONArray.Create;
  for LFor := 0 to Length(AValues) - 1 do
    LArray.Add(TJSONValueBoolean.Create(AValues[LFor]));
  Add(AName, LArray);
  Result := Self;
end;

function TJSONComposer.Add(const AName: String; const AValues: TArray<TDateTime>): TJSONComposer;
var
  LArray: TJSONArray;
  LFor: Integer;
begin
  LArray := TJSONArray.Create;
  for LFor := 0 to Length(AValues) - 1 do
    LArray.Add(TJSONValueDateTime.Create(AValues[LFor]));
  Add(AName, LArray);
  Result := Self;
end;

function TJSONComposer.Add(const AName: String; const AValues: TArray<Char>): TJSONComposer;
var
  LArray: TJSONArray;
  LFor: Integer;
begin
  LArray := TJSONArray.Create;
  for LFor := 0 to Length(AValues) - 1 do
    LArray.Add(TJSONValueString.Create(AValues[LFor]));
  Add(AName, LArray);
  Result := Self;
end;

function TJSONComposer.Add(const AName: String; const AValues: TArray<Variant>): TJSONComposer;
var
  LArray: TJSONArray;
  LFor: Integer;
begin
  LArray := TJSONArray.Create;
  for LFor := 0 to Length(AValues) - 1 do
  begin
    case VarType(AValues[LFor]) and varTypeMask of
      varInteger, varShortInt, varByte, varWord, varLongWord: LArray.Add(TJSONValueInteger.Create(AValues[LFor]));
      varSingle, varDouble, varCurrency: LArray.Add(TJSONValueFloat.Create(AValues[LFor]));
      varBoolean: LArray.Add(TJSONValueBoolean.Create(AValues[LFor]));
      varDate: LArray.Add(TJSONValueDateTime.Create(VarToStr(AValues[LFor]), True));
      varEmpty, varNull: LArray.Add(TJSONValueNull.Create);
      else LArray.Add(TJSONValueString.Create(VarToStr(AValues[LFor])));
    end;
  end;
  Add(AName, LArray);
  Result := Self;
end;

function TJSONComposer.Merge(const AElement: IJSONElement): TJSONComposer;
var
  LObject: IJSONObject;
  LArray: IJSONArray;
  LPairs: TArray<IJSONPair>;
  LItems: TArray<IJSONElement>;
  LFor: Integer;
begin
  if not Assigned(AElement) then
    Exit(Self);
  if Supports(FCurrent, IJSONObject, LObject) then
  begin
    if Supports(AElement, IJSONObject) then
    begin
      LPairs := (AElement as IJSONObject).Pairs;
      for LFor := 0 to Length(LPairs) - 1 do
        LObject.Add(LPairs[LFor].Key, LPairs[LFor].Value);
    end;
  end
  else if Supports(FCurrent, IJSONArray, LArray) then
  begin
    if Supports(AElement, IJSONArray) then
    begin
      LItems := (AElement as IJSONArray).Items;
      for LFor := 0 to Length(LItems) - 1 do
        LArray.Add(LItems[LFor]);
    end
    else
      LArray.Add(AElement);
  end;
  Result := Self;
end;

function TJSONComposer.LoadJSON(const AJson: String): TJSONComposer;
var
  LReader: TJSONReader;
begin
  LReader := TJSONReader.Create;
  try
    Clear;
    FRoot := LReader.Read(AJson);
    FCurrent := FRoot;
  finally
    LReader.Free;
  end;
  Result := Self;
end;

function TJSONComposer.AddToArray(const APath: String; const AValue: Variant): TJSONComposer;
var
  LArray: IJSONArray;
  LParts: TArray<String>;
  LLastPart: String;
  LIndex: Integer;
  LItems: TArray<IJSONElement>;
  LNewArray: IJSONArray;
  LFor: Integer;
  LArrayPath: String;
  LElement: IJSONElement;
begin
  LParts := APath.Split(['.']);
  LLastPart := LParts[High(LParts)];
  if _ExtractArrayIndex(LLastPart, LIndex) then
  begin
    LArrayPath := Copy(APath, 1, Length(APath) - (Length(LLastPart) - Pos('[', LLastPart) + 1));
    if LArrayPath = '' then LArrayPath := Copy(LLastPart, 1, Pos('[', LLastPart) - 1);
    LElement := _FindElement(LArrayPath);
    if not Assigned(LElement) then
      raise EInvalidOperation.Create('Path not found: ' + LArrayPath);
    if not Supports(LElement, IJSONArray, LArray) then
      raise EInvalidOperation.Create('Path does not point to an array: ' + LArrayPath);
    if (LIndex < 0) or (LIndex > LArray.Count) then
      raise EInvalidOperation.Create('Index out of bounds: ' + IntToStr(LIndex));
    LItems := LArray.Items;
    LNewArray := TJSONArray.Create;
    for LFor := 0 to Length(LItems) - 1 do
    begin
      if LFor = LIndex then
      begin
        case VarType(AValue) and varTypeMask of
          varInteger, varShortInt, varByte, varWord, varLongWord: LNewArray.Add(TJSONValueInteger.Create(AValue));
          varSingle, varDouble, varCurrency: LNewArray.Add(TJSONValueFloat.Create(AValue));
          varBoolean: LNewArray.Add(TJSONValueBoolean.Create(AValue));
          varDate: LNewArray.Add(TJSONValueDateTime.Create(VarToStr(AValue), True));
          varEmpty, varNull: LNewArray.Add(TJSONValueNull.Create);
          else LNewArray.Add(TJSONValueString.Create(VarToStr(AValue)));
        end;
      end;
      LNewArray.Add(LItems[LFor]);
    end;
    if LIndex = LArray.Count then
    begin
      case VarType(AValue) and varTypeMask of
        varInteger, varShortInt, varByte, varWord, varLongWord: LNewArray.Add(TJSONValueInteger.Create(AValue));
        varSingle, varDouble, varCurrency: LNewArray.Add(TJSONValueFloat.Create(AValue));
        varBoolean: LNewArray.Add(TJSONValueBoolean.Create(AValue));
        varDate: LNewArray.Add(TJSONValueDateTime.Create(VarToStr(AValue), True));
        varEmpty, varNull: LNewArray.Add(TJSONValueNull.Create);
        else LNewArray.Add(TJSONValueString.Create(VarToStr(AValue)));
      end;
    end;
    LArray.Clear;
    for LFor := 0 to LNewArray.Count - 1 do
      LArray.Add(LNewArray.Value(LFor));
  end
  else
  begin
    LElement := _FindElement(APath);
    if not Assigned(LElement) then
      raise EInvalidOperation.Create('Path not found: ' + APath);
    if not Supports(LElement, IJSONArray, LArray) then
      raise EInvalidOperation.Create('Path does not point to an array: ' + APath);
    case VarType(AValue) and varTypeMask of
      varInteger, varShortInt, varByte, varWord, varLongWord: LArray.Add(TJSONValueInteger.Create(AValue));
      varSingle, varDouble, varCurrency: LArray.Add(TJSONValueFloat.Create(AValue));
      varBoolean: LArray.Add(TJSONValueBoolean.Create(AValue));
      varDate: LArray.Add(TJSONValueDateTime.Create(VarToStr(AValue), True));
      varEmpty, varNull: LArray.Add(TJSONValueNull.Create);
      else LArray.Add(TJSONValueString.Create(VarToStr(AValue)));
    end;
  end;
  Result := Self;
end;

function TJSONComposer.AddToArray(const APath: String; const AElement: IJSONElement): TJSONComposer;
var
  LArray: IJSONArray;
begin
  if not Supports(_FindElement(APath), IJSONArray, LArray) then
    raise EInvalidOperation.Create('Path does not point to an array: ' + APath);

  LArray.Add(AElement);
  Result := Self;
end;

function TJSONComposer.AddToArray(const APath: String; const AValues: TArray<Variant>): TJSONComposer;
var
  LArray: IJSONArray;
  LNewArray: TJSONArray;
  LFor: Integer;
begin
  if not Supports(_FindElement(APath), IJSONArray, LArray) then
    raise EInvalidOperation.Create('Path does not point to an array: ' + APath);

  LNewArray := TJSONArray.Create;
  for LFor := 0 to Length(AValues) - 1 do
  begin
    case VarType(AValues[LFor]) and varTypeMask of
      varInteger, varShortInt, varByte, varWord, varLongWord: LNewArray.Add(TJSONValueInteger.Create(AValues[LFor]));
      varSingle, varDouble, varCurrency: LNewArray.Add(TJSONValueFloat.Create(AValues[LFor]));
      varBoolean: LNewArray.Add(TJSONValueBoolean.Create(AValues[LFor]));
      varDate: LNewArray.Add(TJSONValueDateTime.Create(VarToStr(AValues[LFor]), True));
      varEmpty, varNull: LNewArray.Add(TJSONValueNull.Create);
    else
      LNewArray.Add(TJSONValueString.Create(VarToStr(AValues[LFor])));
    end;
  end;
  LArray.Add(LNewArray);
  Result := Self;
end;

function TJSONComposer.MergeArray(const APath: String; const AValues: TArray<Variant>): TJSONComposer;
var
  LArray: IJSONArray;
  LFor: Integer;
begin
  if not Supports(_FindElement(APath), IJSONArray, LArray) then
    raise EInvalidOperation.Create('Path does not point to an array: ' + APath);

  for LFor := 0 to Length(AValues) - 1 do
  begin
    case VarType(AValues[LFor]) and varTypeMask of
      varInteger, varShortInt, varByte, varWord, varLongWord: LArray.Add(TJSONValueInteger.Create(AValues[LFor]));
      varSingle, varDouble, varCurrency: LArray.Add(TJSONValueFloat.Create(AValues[LFor]));
      varBoolean: LArray.Add(TJSONValueBoolean.Create(AValues[LFor]));
      varDate: LArray.Add(TJSONValueDateTime.Create(VarToStr(AValues[LFor]), True));
      varEmpty, varNull: LArray.Add(TJSONValueNull.Create);
    else
      LArray.Add(TJSONValueString.Create(VarToStr(AValues[LFor])));
    end;
  end;
  Result := Self;
end;

procedure TJSONComposer.OnLog(const ALogProc: TProc<String>);
begin
  FLogProc := ALogProc;
end;

function TJSONComposer.RemoveFromArray(const APath: String; const AIndex: Integer): TJSONComposer;
var
  LArray: IJSONArray;
begin
  if not Supports(_FindElement(APath), IJSONArray, LArray) then
    raise EInvalidOperation.Create('Path does not point to an array: ' + APath);
  if (AIndex < 0) or (AIndex >= LArray.Count) then
    raise EInvalidOperation.Create('Index out of bounds: ' + IntToStr(AIndex));

  LArray.Remove(AIndex);
  Result := Self;
end;

function TJSONComposer.ReplaceArray(const APath: String; const AValues: TArray<Variant>): TJSONComposer;
var
  LParent: IJSONElement;
  LKey: String;
  LNewArray: TJSONArray;
  LFor: Integer;
  LObject: IJSONObject;
begin
  LParent := _FindParentAndKey(APath, LKey);
  if not Supports(LParent, IJSONObject, LObject) then
    raise EInvalidOperation.Create('Parent path is not an object: ' + APath);

  LNewArray := TJSONArray.Create;
  for LFor := 0 to Length(AValues) - 1 do
  begin
    case VarType(AValues[LFor]) and varTypeMask of
      varInteger, varShortInt, varByte, varWord, varLongWord: LNewArray.Add(TJSONValueInteger.Create(AValues[LFor]));
      varSingle, varDouble, varCurrency: LNewArray.Add(TJSONValueFloat.Create(AValues[LFor]));
      varBoolean: LNewArray.Add(TJSONValueBoolean.Create(AValues[LFor]));
      varDate: LNewArray.Add(TJSONValueDateTime.Create(VarToStr(AValues[LFor]), True));
      varEmpty, varNull: LNewArray.Add(TJSONValueNull.Create);
    else
      LNewArray.Add(TJSONValueString.Create(VarToStr(AValues[LFor])));
    end;
  end;

  LObject.Add(LKey, LNewArray);
  Result := Self;
end;

function TJSONComposer.AddObject(const APath: String; const AName: String): TJSONComposer;
var
  LParent: IJSONElement;
  LNewObject: TJSONObject;
  LObject: IJSONObject;
  LArray: IJSONArray;
begin
  LParent := _FindElement(APath);
  LNewObject := TJSONObject.Create;

  if Supports(LParent, IJSONObject, LObject) then
    LObject.Add(AName, LNewObject)
  else if Supports(LParent, IJSONArray, LArray) then
    LArray.Add(LNewObject)
  else
    raise EInvalidOperation.Create('Path does not point to an object or array: ' + APath);

  FCurrent := LNewObject;
  Result := Self;
end;

function TJSONComposer.SetValue(const APath: String; const AValue: Variant): TJSONComposer;
var
  LElement: IJSONElement;
  LValue: IJSONValue;
  LParts: TArray<String>;
  LLastPart: String;
  LArray: IJSONArray;
  LIndex: Integer;
  LArrayPath: String;
begin
  LParts := APath.Split(['.']);
  LLastPart := LParts[High(LParts)];
  if _ExtractArrayIndex(LLastPart, LIndex) then
  begin
    LArrayPath := Copy(APath, 1, Length(APath) - (Length(LLastPart) - Pos('[', LLastPart) + 1));
    if LArrayPath = '' then LArrayPath := Copy(LLastPart, 1, Pos('[', LLastPart) - 1);
    LElement := _FindElement(LArrayPath);
    if not Assigned(LElement) then
      raise EInvalidOperation.Create('Path not found: ' + LArrayPath);
    if not Supports(LElement, IJSONArray, LArray) then
      raise EInvalidOperation.Create('Path does not point to an array: ' + LArrayPath);
    if (LIndex < 0) or (LIndex >= LArray.Count) then
      raise EInvalidOperation.Create('Index out of bounds: ' + IntToStr(LIndex));
    LElement := LArray.Value(LIndex);
    if not Supports(LElement, IJSONValue, LValue) then
      raise EInvalidOperation.Create('Path does not point to a value: ' + APath);
  end
  else
  begin
    LElement := _FindElement(APath);
    if not Assigned(LElement) then
      raise EInvalidOperation.Create('Path not found: ' + APath);
    if not Supports(LElement, IJSONValue, LValue) then
      raise EInvalidOperation.Create('Path does not point to a value: ' + APath);
  end;
  case VarType(AValue) and varTypeMask of
    varInteger, varShortInt, varByte, varWord, varLongWord: LValue.AsInteger := AValue;
    varSingle, varDouble, varCurrency: LValue.AsFloat := AValue;
    varBoolean: LValue.AsBoolean := AValue;
    varDate: LValue.AsString := VarToStr(AValue); // Assume ISO 8601
    varEmpty, varNull: raise EInvalidOperation.Create('Cannot set value to null');
    else LValue.AsString := VarToStr(AValue);
  end;
  Result := Self;
end;

function TJSONComposer.RemoveKey(const APath: String): TJSONComposer;
var
  LParent: IJSONElement;
  LKey: String;
  LObject: IJSONObject;
begin
  LParent := _FindParentAndKey(APath, LKey);
  if not Supports(LParent, IJSONObject, LObject) then
    raise EInvalidOperation.Create('Parent path is not an object: ' + APath);

  LObject.Remove(LKey);
  Result := Self;
end;

function TJSONComposer.Clone: IJSONElement;
begin
  Result := _CloneElement(FRoot);
end;

function TJSONComposer.ToJSON(const AIdent: Boolean): String;
var
  LWriter: IJSONWriter;
begin
  if Assigned(FCurrent) and (FStack.Count > 0) then
    raise EInvalidOperation.Create('JSON incomplete: unclosed object or array');
  LWriter := TJSONWriter.Create;
  Result := LWriter.Write(FRoot, AIdent);
end;

function TJSONComposer.ToElement: IJSONElement;
begin
  if Assigned(FCurrent) and (FStack.Count > 0) then
    raise EInvalidOperation.Create('JSON incomplete: unclosed object or array');
  Result := FRoot;
end;

function TJSONComposer.ForEach(const ACallback: TProc<String, IJSONElement>): TJSONComposer;
var
  LObject: IJSONObject;
  LArray: IJSONArray;
  LPairs: TArray<IJSONPair>;
  LItems: TArray<IJSONElement>;
  LFor: Integer;
begin
  if Assigned(ACallback) then
  begin
    if Supports(FCurrent, IJSONObject, LObject) then
    begin
      LPairs := LObject.Pairs;
      for LFor := 0 to Length(LPairs) - 1 do
        ACallback(LPairs[LFor].Key, LPairs[LFor].Value);
    end
    else if Supports(FCurrent, IJSONArray, LArray) then
    begin
      LItems := LArray.Items;
      for LFor := 0 to Length(LItems) - 1 do
        ACallback('', LItems[LFor]);
    end;
  end;
  Result := Self;
end;

function TJSONComposer.Clear: TJSONComposer;
begin
  FRoot := nil;
  FCurrent := nil;
  FStack.Clear;
  FNameStack.Clear;
  Result := Self;
end;

end.
