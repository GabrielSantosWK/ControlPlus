unit Model.DAO.Filter.Between;

interface

uses Model.DAO.Filter;
  type
  TBetween = class
    FParent:TModelDAOFilter;
    constructor Create(const AParent:TModelDAOFilter);
    function Value(AValue:string):TBetween;
    function FirstFilter(const AValue:string):TBetween;
    function SecondFilter(const AValue:string):TModelDAOFilter;
  end;
implementation

{ TBetween }

constructor TBetween.Create(const AParent: TModelDAOFilter);
begin
  FParent := AParent;
end;

function TBetween.FirstFilter(const AValue: string): TBetween;
begin

end;

function TBetween.SecondFilter(const AValue: string): TModelDAOFilter;
begin
  Result := FParent;
end;

function TBetween.Value(AValue: string): TBetween;
begin

end;

end.
