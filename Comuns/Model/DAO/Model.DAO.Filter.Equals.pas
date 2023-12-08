unit Model.DAO.Filter.Equals;

interface
  uses System.SysUtils;
  type
  TEquals = class
  private
    FFieldDataBase:string;
    FValue:string;
  public
    constructor Create();
    function FieldDataBase(AValue:string):TEquals;
    function Value(const AValue:string):TEquals;overload;
    function Value(const AValue:Integer):TEquals;overload;
    function Value(const AValue:TDate):TEquals;overload;
    function Value(const AValue:Boolean):TEquals;overload;
    function GetResult:string;
  end;
implementation

{ TEquals }

constructor TEquals.Create();
begin

end;

function TEquals.FieldDataBase(AValue: string): TEquals;
begin
  Result := Self;
  FFieldDataBase := AValue;
end;

function TEquals.GetResult: string;
begin
  Result :=  Format(' AND %s = %s  ',[FFieldDataBase,FValue]);
end;

function TEquals.Value(const AValue: TDate): TEquals;
begin
  raise Exception.Create('Not Implemented');
end;

function TEquals.Value(const AValue: Integer): TEquals;
begin
  raise Exception.Create('Not Implemented');
end;

function TEquals.Value(const AValue: string): TEquals;
begin
  Result := Self;
  FValue := QuotedStr(AValue);
end;

function TEquals.Value(const AValue: Boolean): TEquals;
begin
  Result := Self;
  FValue := QuotedStr(BoolToStr(AValue,True));
end;

end.
