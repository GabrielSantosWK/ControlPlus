unit Model.Static.Cartoes;

interface

uses Entity.Cartoes, Model.DAO.Cartoes;

type
  TModelStaticCartoes = class
  private
    class var FInstance: TModelStaticCartoes;
    var
    FModelDaoCartoes:TModelDAOCartoes;
  public
    class function GetInstance: TModelStaticCartoes;
    constructor Create();
    destructor Destroy();override;
    procedure Refresh;
    function Find(const AID:string):TEntityCartoes;
  end;

implementation

{ TModelStaticCartoes }

constructor TModelStaticCartoes.Create;
begin
  FModelDaoCartoes := TModelDAOCartoes.Create;
  Refresh;
end;

destructor TModelStaticCartoes.Destroy;
begin
  FModelDaoCartoes.Free;
  inherited;
end;

function TModelStaticCartoes.Find(const AID: string): TEntityCartoes;
begin
  Result := nil;
  for var Indice := 0 to Pred(FModelDaoCartoes.List.Count) do
  begin
    if FModelDaoCartoes.List[Indice].Id = AID then
    begin
      Result := FModelDaoCartoes.List[Indice];
      Break;
    end;
  end;
end;

class function TModelStaticCartoes.GetInstance: TModelStaticCartoes;
begin
  if not Assigned(FInstance) then
    FInstance := TModelStaticCartoes.Create;
  Result := FInstance;
end;

procedure TModelStaticCartoes.Refresh;
begin
  FModelDaoCartoes.Get(True);
end;

end.
