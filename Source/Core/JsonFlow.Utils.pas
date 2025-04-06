{
                   Copyright (c) 2020, Isaque Pinheiro
                          All rights reserved.

                    GNU Lesser General Public License
                      Versão 3, 29 de junho de 2007

       Copyright (C) 2007 Free Software Foundation, Inc. <http://fsf.org/>
       A todos é permitido copiar e distribuir cópias deste documento de
       licença, mas mudá-lo não é permitido.

       Esta versão da GNU Lesser General Public License incorpora
       os termos e condições da versão 3 da GNU General Public License
       Licença, complementado pelas permissões adicionais listadas no
       arquivo LICENSE na pasta principal.
}

{
  @abstract(JSONBr Framework)
  @created(23 Nov 2020)
  @author(Isaque Pinheiro <isaquepsp@gmail.com>)
  @author(Telegram : @IsaquePinheiro)
}

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
