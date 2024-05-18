unit Model.DAO.Filter;

interface
  uses Model.DAO.Filter.Between, Model.DAO.Filter.Equals, Model.DAO.Filter.Sort;
type
  TModelDAOFilter = class
  private
  FBetween:TBetween;
  FEquals:TEquals;
  FSort:TSort;
  public
    constructor Create;
    destructor Destroy;override;
    function Between:TBetween;
    function Equals: TEquals;
    function Sort:TSort;
    function ResultFilter:string;
  end;
implementation

{ TModelDAOFilter }

function TModelDAOFilter.Between:TBetween ;
begin
  Result := FBetween
end;

constructor TModelDAOFilter.Create;
begin
  FBetween := TBetween.Create;
  FEquals := TEquals.Create;
  FSort := TSort.Create;
end;

destructor TModelDAOFilter.Destroy;
begin
  FBetween.Free;
  FEquals.Free;
  FSort.Free;
  inherited;
end;

function TModelDAOFilter.Equals: TEquals;
begin
  Result := FEquals;
end;

function TModelDAOFilter.ResultFilter: string;
begin
  Result := 'Where 1=1 '+FBetween.GetResult+FEquals.GetResult+FSort.GetResult;
end;

function TModelDAOFilter.Sort: TSort;
begin
  Result := FSort;
end;

end.
