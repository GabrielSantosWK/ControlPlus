unit Model.DAO.Filter;

interface
  uses Model.DAO.Filter.Between;
type
  TModelDAOFilter = class
  private
  FBetween:TBetween;
  public
    constructor Create;
    destructor Destroy;override;
    function Between:TBetween;
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
end;

destructor TModelDAOFilter.Destroy;
begin
  FBetween.Free;
  inherited;
end;

function TModelDAOFilter.ResultFilter: string;
begin
  Result := 'Where '+FBetween.GetResult;
end;

end.
