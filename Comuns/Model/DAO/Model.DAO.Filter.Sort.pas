unit Model.DAO.Filter.Sort;

interface
  uses System.SysUtils;
  type
  TSort = class
   private
    FFieldDataBase:string;
    FValue:string;
   public
    constructor Create();
    function FieldDataBase(AValue:string):TSort;
    function Value(const AValue:string):TSort;overload;
    function Value(const AValue:Integer):TSort;overload;
    function Value(const AValue:TDate):TSort;overload;
    function Value(const AValue:Boolean):TSort;overload;
    function GetResult:string;
  end;
implementation

{ TSort }

constructor TSort.Create;
begin

end;

function TSort.FieldDataBase(AValue: string): TSort;
begin
  Result := Self;
  FFieldDataBase := AValue;
end;

function TSort.GetResult: string;
begin
  if FFieldDataBase.IsEmpty then
    Result := EmptyStr
  else
    Result := Format('order by %s',[FFieldDataBase]);
  FFieldDataBase := EmptyStr;
end;

function TSort.Value(const AValue: string): TSort;
begin

end;

function TSort.Value(const AValue: Integer): TSort;
begin

end;

function TSort.Value(const AValue: TDate): TSort;
begin

end;

function TSort.Value(const AValue: Boolean): TSort;
begin

end;

end.
