unit Model.DAO.Filter.Between;

interface
  uses System.SysUtils;
  type
  TBetween = class
  private
    FFieldDataBase:string;
    FFirstFilter:string;
    FSecondFilter:string;
  public
    constructor Create();
    function FieldDataBase(AValue:string):TBetween;
    function FirstFilter(const AValue:string):TBetween;overload;
    function FirstFilter(const AValue:TDate):TBetween;overload;
    procedure SecondFilter(const AValue:string);overload;
    procedure SecondFilter(const AValue:TDate);overload;
    function GetResult:string;
  end;
implementation

{ TBetween }

constructor TBetween.Create();
begin

end;

function TBetween.FirstFilter(const AValue: string): TBetween;
begin
  Result := Self;
  FFirstFilter := AValue;
end;

procedure TBetween.SecondFilter(const AValue: TDate);
begin
  FSecondFilter := DateToStr(AValue);
end;

procedure TBetween.SecondFilter(const AValue: string);
begin
  FSecondFilter := AValue;
end;

function TBetween.FieldDataBase(AValue: string): TBetween;
begin
  Result := Self;
  FFieldDataBase := AValue;
end;

function TBetween.FirstFilter(const AValue: TDate): TBetween;
begin
  Result := Self;
  FFirstFilter := DateToStr(AValue);
end;

function TBetween.GetResult: string;
begin
  Result :=  Format(' %s BETWEEN %s and %s ',[FFieldDataBase,QuotedStr(FFirstFilter),QuotedStr(FSecondFilter)]);
end;

end.
