{
                          Apache License

       Licensed under the Apache License, Version 2.0 (the "License");
       you may not use this file except in compliance with the License.
       You may obtain a copy of the License at

             http://www.apache.org/licenses/LICENSE-2.0

       Unless required by applicable law or agreed to in writing, software
       distributed under the License is distributed on an "AS IS" BASIS,
       WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
       See the License for the specific language governing permissions and
       limitations under the License.
}

{
  @abstract(JsonFlow4D: Advanced JSON Handling Framework for Delphi)
  @description(A versatile and powerful library for JSON serialization, deserialization, and manipulation in Delphi. It offers navigation via pointers, the ability to edit and update JSON, and supports middleware for custom type handling and JSON schema validation.)
  @created(03 Abr 2025)
  @author(Isaque Pinheiro <isaquepsp@gmail.com>)
  @Discord(https://discord.gg/T2zJC8zX)
}

{$include ./jsonflow4d.inc}

unit JsonFlow;

interface

uses
  Rtti,
  SysUtils,
  Classes,
  Generics.Collections,
  JsonFlow.Interfaces,
  JsonFlow.Reader,
  JsonFlow.Writer,
  JsonFlow.Serializer;

type
  TJsonFlow = class
  private
    class var FReader: TJSONReader;
    class var FWriter: TJSONWriter;
    class var FSerializer: TJSONSerializer;
    class var FFormatSettings: TFormatSettings;
    class procedure _Initialization; static; inline;
    class procedure _SetFormatSettings(const Value: TFormatSettings); static; inline;
  public
    class constructor Create;
    class destructor Destroy;
    class function ObjectToJsonString(AObject: TObject; AStoreClassName: Boolean = False): String; static; inline;
    class function ObjectListToJsonString(AObjectList: TObjectList<TObject>; AStoreClassName: Boolean = False): String; overload; static; inline;
    class function ObjectListToJsonString<T: class, constructor>(AObjectList: TObjectList<T>; AStoreClassName: Boolean = False): String; overload; static; inline;
    class function JsonToObject<T: class, constructor>(const AJson: String): T; overload; static; inline;
    class function JsonToObject<T: class>(const AObject: T; const AJson: String): Boolean; overload; static; inline;
    class function JsonToObjectList<T: class, constructor>(const AJson: String): TObjectList<T>; overload; static; inline;
    class function JsonToObjectList(const AJson: String; const AType: TClass): TObjectList<TObject>; overload; static; inline;
    class function Parse(const AJson: String): IJSONElement; static; inline;
    class function ToJson(const AElement: IJSONElement; const AIdent: Boolean = False): String; static; inline;
    class function FromObject(AObject: TObject; AStoreClassName: Boolean = False): IJSONElement; static; inline;
    class function ToObject(const AElement: IJSONElement; AObject: TObject): Boolean; static; inline;
    class procedure JsonToObject(const AJson: String; AObject: TObject); overload; static; inline;
    class procedure AddMiddleware(const AMiddleware: IEventMiddleware); static; inline;
    class procedure ClearMiddlewares; static; inline;
    class procedure OnLog(const ALogProc: TProc<String>); static; inline;
    //
    class property FormatSettings: TFormatSettings read FFormatSettings write _SetFormatSettings;
  end;

implementation

{ TJSONBr }

class procedure TJsonFlow._Initialization;
begin
  FSerializer := TJSONSerializer.Create(FFormatSettings);
  FReader := TJSONReader.Create(FFormatSettings);
  FWriter := TJSONWriter.Create(FFormatSettings);
end;

class procedure TJsonFlow.ClearMiddlewares;
begin
  FSerializer.Middlewares.Clear;
end;

class constructor TJsonFlow.Create;
begin
  FFormatSettings := TFormatSettings.Create('en-US');
  FFormatSettings.ShortDateFormat := 'yyyy-mm-dd';
  FFormatSettings.DateSeparator := '-';
  FFormatSettings.TimeSeparator := ':';
  FFormatSettings.DecimalSeparator := '.';
  _Initialization;
end;

class destructor TJsonFlow.Destroy;
begin
  FSerializer.Free;
  FWriter.Free;
  FReader.Free;
end;

class procedure TJsonFlow.AddMiddleware(const AMiddleware: IEventMiddleware);
begin
  FSerializer.Middlewares.Add(AMiddleware);
end;

class function TJsonFlow.ObjectToJsonString(AObject: TObject; AStoreClassName: Boolean): String;
begin
  Result := FSerializer.FromObject(AObject, AStoreClassName).AsJSON;
end;

class function TJsonFlow.ObjectListToJsonString(AObjectList: TObjectList<TObject>; AStoreClassName: Boolean): String;
var
  LFor: Integer;
  LBuilder: TStringBuilder;
begin
  LBuilder := TStringBuilder.Create;
  try
    LBuilder.Append('[');
    for LFor := 0 to AObjectList.Count - 1 do
    begin
      LBuilder.Append(ObjectToJsonString(AObjectList[LFor], AStoreClassName));
      if LFor < AObjectList.Count - 1 then
        LBuilder.Append(',');
    end;
    LBuilder.Append(']');
    Result := LBuilder.ToString;
  finally
    LBuilder.Free;
  end;
end;

class function TJsonFlow.ObjectListToJsonString<T>(AObjectList: TObjectList<T>; AStoreClassName: Boolean): String;
var
  LFor: Integer;
  LBuilder: TStringBuilder;
begin
  LBuilder := TStringBuilder.Create;
  try
    LBuilder.Append('[');
    for LFor := 0 to AObjectList.Count - 1 do
    begin
      LBuilder.Append(ObjectToJsonString(AObjectList[LFor], AStoreClassName));
      if LFor < AObjectList.Count - 1 then
        LBuilder.Append(',');
    end;
    LBuilder.Append(']');
    Result := LBuilder.ToString;
  finally
    LBuilder.Free;
  end;
end;

class function TJsonFlow.JsonToObject<T>(const AJson: String): T;
var
  LElement: IJSONElement;
begin
  LElement := FReader.Read(AJson);
  Result := T.Create;
  try
    if not FSerializer.ToObject(LElement, Result) then
      raise Exception.Create('Failed to deserialize JSON to object');
  except
    Result.Free;
    raise;
  end;
end;

class function TJsonFlow.JsonToObject<T>(const AObject: T; const AJson: String): Boolean;
begin
  Result := FSerializer.ToObject(FReader.Read(AJson), AObject);
end;

class function TJsonFlow.JsonToObjectList<T>(const AJson: String): TObjectList<T>;
var
  LElement: IJSONElement;
  LArray: IJSONArray;
  LFor: Integer;
  LObj: T;
begin
  Result := TObjectList<T>.Create(True);
  try
    LElement := FReader.Read(AJson);
    if not Supports(LElement, IJSONArray, LArray) then
      raise Exception.Create('JSON must be an array for object list');
    for LFor := 0 to LArray.Count - 1 do
    begin
      LObj := T.Create;
      try
        if FSerializer.ToObject(LArray.GetItem(LFor), LObj) then
          Result.Add(LObj)
        else
          LObj.Free;
      except
        LObj.Free;
        raise;
      end;
    end;
  except
    Result.Free;
    raise;
  end;
end;

class function TJsonFlow.JsonToObjectList(const AJson: String; const AType: TClass): TObjectList<TObject>;
var
  LElement: IJSONElement;
  LArray: IJSONArray;
  LFor: Integer;
  LObj: TObject;
begin
  Result := TObjectList<TObject>.Create(True);
  try
    LElement := FReader.Read(AJson);
    if not Supports(LElement, IJSONArray, LArray) then
      raise Exception.Create('JSON must be an array for object list');
    for LFor := 0 to LArray.Count - 1 do
    begin
      LObj := AType.Create;
      try
        if FSerializer.ToObject(LArray.GetItem(LFor), LObj) then
          Result.Add(LObj)
        else
          LObj.Free;
      except
        LObj.Free;
        raise;
      end;
    end;
  except
    Result.Free;
    raise;
  end;
end;

class procedure TJsonFlow.JsonToObject(const AJson: String; AObject: TObject);
begin
  if not FSerializer.ToObject(FReader.Read(AJson), AObject) then
    raise Exception.Create('Failed to deserialize JSON to object');
end;

class procedure TJsonFlow._SetFormatSettings(const Value: TFormatSettings);
begin
  if Assigned(FSerializer) then
    FSerializer.Free;
  if Assigned(FReader) then
    FReader.Free;
  if Assigned(FWriter) then
    FWriter.Free;

  FFormatSettings := Value;
  _Initialization;
end;

class function TJsonFlow.Parse(const AJson: String): IJSONElement;
begin
  Result := FReader.Read(AJson);
end;

class function TJsonFlow.ToJson(const AElement: IJSONElement; const AIdent: Boolean): String;
begin
  Result := FWriter.Write(AElement, AIdent);
end;

class function TJsonFlow.FromObject(AObject: TObject; AStoreClassName: Boolean): IJSONElement;
begin
  Result := FSerializer.FromObject(AObject, AStoreClassName);
end;

class function TJsonFlow.ToObject(const AElement: IJSONElement; AObject: TObject): Boolean;
begin
  Result := FSerializer.ToObject(AElement, AObject);
end;

class procedure TJsonFlow.OnLog(const ALogProc: TProc<String>);
begin
  if Assigned(ALogProc) then
  begin
    FSerializer.OnLog(ALogProc);
    FReader.OnLog(ALogProc);
    FWriter.OnLog(ALogProc);
  end;
end;

end.


