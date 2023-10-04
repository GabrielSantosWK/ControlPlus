unit Model.DAO.Filter.Factory;

interface

uses Model.DAO.Filter.Between;
  type
  TModelDAOFilterFactory = class
    private
    public
    constructor Create();
    destructor Destroy;override;
    function Between(AParent:TClass):TBetween;
  end;
implementation

{ TModelDAOFilterFactory }

function TModelDAOFilterFactory.Between(AParent:TClass): TBetween;
begin
  //Result := TBetween.Create(AParent);

end;

constructor TModelDAOFilterFactory.Create();
begin

end;

destructor TModelDAOFilterFactory.Destroy;
begin

  inherited;
end;

end.
