unit Model.Utils;

interface
uses
  System.SysUtils, System.Classes;
  type
  TModelUtils = class
  private
   class function GetStrNumber(const S: string): string;
  public
    class function FormatCurrencyValue(AValue:string):string;
  end;
implementation

{ TModelUtils }

class function TModelUtils.FormatCurrencyValue(AValue: string): string;
var
  LValue, LValueFormat: string;
  I, LLengtnValue: integer;
begin
  if (aValue = '') then
  begin
    Result := '0,00';
    Exit;
  end;

  aValue := GetStrNumber(aValue);
  for I := 1 to Length(aValue) do
  begin
    if aValue[I] <> '0' then
    begin
      LValue := Copy(aValue, I);
      Break;
    end;
  end;
  LLengtnValue := Length(LValue);
  if LLengtnValue <= 3 then
  begin
    if LLengtnValue = 1 then
      LValue := '0,0' + LValue
    else if LLengtnValue = 2 then
      LValue := '0,' + LValue
    else if LLengtnValue = 3 then
      LValue := Copy(LValue, 1, 1) + ',' + Copy(LValue, 2);
  end
  else
  begin
    LValueFormat := LValue;
    LValueFormat := ',' + Copy(LValue, LValue.Length - 1);
    LValue := Copy(LValue, 1, LValue.Length - 2);
    if Length(LValue) <= 3 then
      LValue := LValue + LValueFormat
    else
    begin
      while Length(LValue) > 3 do
      begin
        LValueFormat := '.' + Copy(LValue, LValue.Length - 2) + LValueFormat;
        LValue := Copy(LValue, 1, Length(LValue) - 3);
      end;
      LValue := LValue + LValueFormat;
    end;
  end;
  Result := LValue;
end;

class function TModelUtils.GetStrNumber(const S: string): string;
var
  vText: PChar;
begin
  vText := PChar(S);
  Result := '';

  while (vText^ <> #0) do
  begin
{$IFDEF UNICODE}
    if CharInSet(vText^, ['0' .. '9']) then
{$ELSE}
    if vText^ in ['0' .. '9'] then
{$ENDIF}
      Result := Result + vText^;

    Inc(vText);
  end;
end;
end.
