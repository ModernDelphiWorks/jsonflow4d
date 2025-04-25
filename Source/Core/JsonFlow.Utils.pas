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

unit JsonFlow.Utils;

interface

uses
  StrUtils,
  DateUtils,
  SysUtils;

function DateTimeToIso8601(const AValue: TDateTime; const AUseISO8601DateFormat: Boolean): String;
function Iso8601ToDateTime(const AValue: String; const AUseISO8601DateFormat: Boolean): TDateTime;

var
  JsonFormatSettings: TFormatSettings;

implementation

function DateTimeToIso8601(const AValue: TDateTime; const AUseISO8601DateFormat: Boolean): String;
var
  LDatePart: String;
  LTimePart: String;
begin
  Result := '';
  if AValue = 0 then
    Exit;

  if AUseISO8601DateFormat then
    LDatePart := FormatDateTime('yyyy-mm-dd', AValue)
  else
    LDatePart := DateToStr(AValue, JsonFormatSettings);

  if Frac(AValue) = 0 then
    Result := IfThen(AUseISO8601DateFormat, LDatePart, DateToStr(AValue, JsonFormatSettings))
  else
  begin
    LTimePart := FormatDateTime('hh:nn:ss', AValue);
    Result := IfThen(AUseISO8601DateFormat, LDatePart + 'T' + LTimePart, LDatePart + ' ' + LTimePart);
  end;
end;

function Iso8601ToDateTime(const AValue: String; const AUseISO8601DateFormat: Boolean): TDateTime;
begin
  if not AUseISO8601DateFormat then
  begin
    Result := StrToDateTimeDef(AValue, 0, JsonFormatSettings);
  end
  else
  begin
    try
      Result := ISO8601ToDate(AValue, True);
    except
      on E: EConvertError do
        Result := 0;
    end;
  end;
end;

initialization
  JsonFormatSettings := TFormatSettings.Create('en-US');
  JsonFormatSettings.ShortDateFormat := 'yyyy-mm-dd';
  JsonFormatSettings.DateSeparator := '-';
  JsonFormatSettings.TimeSeparator := ':';
  JsonFormatSettings.DecimalSeparator := '.';

end.
