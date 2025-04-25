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
  @abstract(JsonFlow4D Framework - Advanced JSON Handling for Delphi)
  @description(A versatile and powerful library for JSON serialization, deserialization, and manipulation in Delphi. It offers navigation via pointers, the ability to edit and update JSON, and supports middleware for custom type handling and JSON schema validation.)
  @created(03 Abr 2025)
  @author(Isaque Pinheiro <isaquepsp@gmail.com>)
  @Discord(https://discord.gg/T2zJC8zX)
}

{$include ./jsonflow4d.inc}

unit JsonFlow.Interfaces;

interface

uses
  Rtti,
  TypInfo,
  SysUtils,
  Classes,
  Generics.Collections;

const
  JSON_TRUE = 'true';
  JSON_FALSE = 'false';
  JSON_NULL = 'null';

type
  IJSONElement = interface
    ['{0056FF41-A87A-4C99-87E0-81A850C7160C}']
    function AsJSON(const AIdent: Boolean = False): String;
    procedure SaveToStream(AStream: TStream; const AIdent: Boolean = False);
    function Clone: IJSONElement;
    function TypeName: string;
  end;

  IJSONValue = interface(IJSONElement)
    ['{116CEFDB-D0C4-434D-B67D-1FA2960D925D}']
    function _GetAsBoolean: Boolean;
    procedure _SetAsBoolean(const AValue: Boolean);
    function _GetAsInteger: Int64;
    procedure _SetAsInteger(const AValue: Int64);
    function _GetAsFloat: Double;
    procedure _SetAsFloat(const AValue: Double);
    function _GetAsString: String;
    procedure _SetAsString(const AValue: String);
    function IsString: Boolean;
    function IsInteger: Boolean;
    function IsFloat: Boolean;
    function IsBoolean: Boolean;
    function IsNull: Boolean;
    function IsDate: Boolean;
    property AsBoolean: Boolean read _GetAsBoolean write _SetAsBoolean;
    property AsInteger: Int64 read _GetAsInteger write _SetAsInteger;
    property AsFloat: Double read _GetAsFloat write _SetAsFloat;
    property AsString: String read _GetAsString write _SetAsString;
  end;

  IJSONPair = interface
    ['{6ECC9DEE-0ED3-4549-8BB6-E9661D196819}']
    function _GetKey: String;
    procedure _SetKey(const AValue: String);
    function _GetValue: IJSONElement;
    procedure _SetValue(const AValue: IJSONElement);
    function AsJSON(const AIdent: Boolean = False): String;
    property Key: String read _GetKey write _SetKey;
    property Value: IJSONElement read _GetValue write _SetValue;
  end;

  IJSONObject = interface(IJSONElement)
    ['{E34C8F5A-CB24-4773-A7BB-97EC2FF27E5C}']
    function Add(const AKey: String; const AValue: IJSONElement): IJSONPair;
    function GetValue(const AKey: String): IJSONElement;
    function ContainsKey(const AKey: String): Boolean;
    function Count: Integer;
    procedure Remove(const AKey: String);
    procedure Clear;
    procedure ForEach(const ACallback: TProc<String, IJSONElement>);
    function Filter(const APredicate: TFunc<String, IJSONElement, Boolean>): IJSONObject;
    function Map(const ATransform: TFunc<String, IJSONElement, IJSONPair>): IJSONObject;
    function Pairs: TArray<IJSONPair>;
  end;

  IJSONArray = interface(IJSONElement)
    ['{39099A2A-817C-4A28-8CF6-33FA1B9993E4}']
    procedure Add(const AValue: IJSONElement);
    function GetItem(const AIndex: Integer): IJSONElement;
    function Count: Integer;
    procedure Remove(const AIndex: Integer);
    procedure Clear;
    procedure ForEach(const ACallback: TProc<IJSONElement>);
    function Filter(const APredicate: TFunc<IJSONElement, Boolean>): IJSONArray;
    function Map(const ATransform: TFunc<IJSONElement, IJSONElement>): IJSONArray;
    function Items: TArray<IJSONElement>;
    function Value(AIndex: Integer): IJSONElement;
  end;

  IJSONWriter = interface
    ['{89F0EE05-38B8-44EA-BA7D-81623545D5E4}']
    function Write(const AElement: IJSONElement; const AIdent: Boolean = False): String;
    procedure WriteToStream(const AElement: IJSONElement; AStream: TStream; const AIdent: Boolean = False);
    procedure OnLog(const ALogProc: TProc<String>);
  end;


  IEventMiddleware = interface
    ['{96402F5C-2C57-45AA-AD31-36900C5EA7DA}']
  end;

  IGetValueMiddleware = interface(IEventMiddleware)
    ['{C109A7D0-72BA-42F3-9596-F12556746B6E}']
    procedure GetValue(const AInstance: TObject; const AProperty: TRttiProperty;
      var AValue: Variant; var ABreak: Boolean);
  end;

  ISetValueMiddleware = interface(IEventMiddleware)
    ['{CE2F0793-959A-4747-861E-EC111DDBF01B}']
    procedure SetValue(const AInstance: TObject; const AProperty: TRttiProperty;
      var AValue: Variant; var ABreak: Boolean);
  end;

  TJsonSchemaVersion = (
    jsvUnknown,          // Versão não especificada ou desconhecida
    jsvDraft3,           // Draft 3
    jsvDraft4,           // Draft 4
    jsvDraft6,           // Draft 6
    jsvDraft7,           // Draft 7
    jsvDraft201909,      // Draft 2019-09
    jsvDraft202012       // Draft 2020-12
  );

  TValidationError = record
    Path: string;
    Message: string;
    FoundValue: string;
    ExpectedValue: string;
    Keyword: string;
    LineNumber: Integer;
    ColumnNumber: Integer;
    Context: string;
    function ToString: string;
  end;

  IJSONSchemaReader = interface
    function LoadFromFile(const AFileName: string): Boolean;
    function LoadFromString(const AJsonString: string): Boolean;
    function Validate(const AJson: string): Boolean; overload;
    function Validate(const AElement: IJSONElement): Boolean; overload;
    function GetErrors: TArray<TValidationError>;
    function GetVersion: TJsonSchemaVersion;
    function GetSchema: IJSONElement;
  end;

  IJSONSchemaValidator = interface
    function GetErrors: TArray<TValidationError>;
    function GetVersion: TJsonSchemaVersion;
    function GetLastError: string;
    function Validate(const AElement: IJSONElement; const APath: String): Boolean; overload;
    function Validate(const AJson, AJsonSchema: String): Boolean; overload;
    procedure ParseSchema(const ASchema: IJSONElement);
    procedure AddLog(const AMessage: string);
    procedure AddError(const APath, AMessage, AFound, AExpected, AKeyword: string;
      ALineNumber: Integer = -1; AColumnNumber: Integer = -1; AContext: string = '');
    procedure OnLog(const ALogProc: TProc<String>);
  end;

  IJSONSchemaRef = interface
    ['{EF18A1DD-689B-497C-B905-87DB59802057}']
    function FetchReference(const ARef: string): IJSONElement;
  end;

  TSchemaNode = class;

  IJSONSchemaTrait = interface
    ['{6B53069A-4519-49A7-8718-5B859ACBD66E}']
    procedure Parse(const ANode: IJSONObject);
    procedure SetNode(const ANode: TSchemaNode);
    function Validate(const ANode: IJSONElement; const APath: String;
      const AErrors: TList<TValidationError>): Boolean;
  end;

  TSchemaNode = class
  private
    FKeyword: String;
    FValue: IJSONElement;
    FChildren: TList<TSchemaNode>;
    FTrait: IJsonSchemaTrait;
    FDefs: TObjectDictionary<String, TSchemaNode>;
    FParent: TSchemaNode;
    FIsValidated: Boolean;
  public
    constructor Create;
    destructor Destroy; override;
    procedure ResetValidationState;
    property Keyword: String read FKeyword write FKeyword;
    property Value: IJSONElement read FValue write FValue;
    property Children: TList<TSchemaNode> read FChildren write FChildren;
    property Trait: IJsonSchemaTrait read FTrait write FTrait;
    property Defs: TObjectDictionary<String, TSchemaNode> read FDefs write FDefs;
    property Parent: TSchemaNode read FParent write FParent;
    property IsValidated: Boolean read FIsValidated write FIsValidated;
  end;

  TArrayHelper = class helper for TArray
    class function ToString<T>(const AArray: TArray<T>; const ASeparator: string = ', '): string; static;
  end;

implementation

function TValidationError.ToString: string;
begin
  Result := Format('Erro em "%s" (linha %d, coluna %d): %s. Encontrado: "%s", Esperado: "%s", Keyword: "%s". Contexto: "%s"',
    [Path, LineNumber, ColumnNumber, Message, FoundValue, ExpectedValue, Keyword, Context]);
end;

{ TArrayHelper }

class function TArrayHelper.ToString<T>(const AArray: TArray<T>; const ASeparator: string): string;
var
  LFor: Integer;
  LValue: TValue;
begin
  Result := '';
  for LFor := 0 to High(AArray) do
  begin
    if LFor > 0 then
      Result := Result + ASeparator;
    LValue := TValue.From<T>(AArray[LFor]);
    if LValue.TypeInfo = TypeInfo(TValue) then
      Result := Result + LValue.AsType<TValue>.AsString
    else
      Result := Result + LValue.ToString;
  end;
end;

{ TSchemaNode }

constructor TSchemaNode.Create;
begin
  FIsValidated := False;
  FChildren := TList<TSchemaNode>.Create;
  FDefs := TObjectDictionary<String, TSchemaNode>.Create([doOwnsValues]);
  FParent := nil;
end;

destructor TSchemaNode.Destroy;
var
  LChild: TSchemaNode;
begin
  for LChild in FChildren do
    LChild.Free;
  FChildren.Free;
  FDefs.Free;
  FParent := nil;
  inherited;
end;

procedure TSchemaNode.ResetValidationState;
begin
  FIsValidated := False;
  for var LChild in Children do
    LChild.ResetValidationState;
end;

end.

