unit Model.Static.Operacoes;

interface
  uses
  Entity.Operacoes,
  Model.DAO.Operacoes,
  System.Generics.Collections;
  type
  TModelStaticOperacoes = class
  private
    class var FInstance: TModelStaticOperacoes;
    var
    FModelDaoOperacoes:TModelDAOOperacoes;
  public
    class function GetInstance: TModelStaticOperacoes;
    constructor Create();
    destructor Destroy();override;
    procedure Refresh;
    function Find(const AID:string):TEntityOperacoes;
    function List:TList<TEntityoperacoes>;
  end;

implementation

{ TModelStaticOperacoes }

constructor TModelStaticOperacoes.Create;
begin
  FModelDaoOperacoes := TModelDAOOperacoes.Create;
  Refresh;
end;

destructor TModelStaticOperacoes.Destroy;
begin
  FModelDaoOperacoes.Free;
  inherited;
end;

function TModelStaticOperacoes.Find(const AID: string): TEntityOperacoes;
begin
  Result := nil;
  for var Indice := 0 to Pred(FModelDaoOperacoes.List.Count) do
  begin
    if FModelDaoOperacoes.List[Indice].Id = AID then
    begin
      Result := FModelDaoOperacoes.List[Indice];
      Break;
    end;
  end;
end;

class function TModelStaticOperacoes.GetInstance: TModelStaticOperacoes;
begin
  if not Assigned(FInstance) then
    FInstance := TModelStaticOperacoes.Create;
  Result := FInstance;
end;

function TModelStaticOperacoes.List: TList<TEntityoperacoes>;
begin
  Result := FModelDaoOperacoes.List;
end;

procedure TModelStaticOperacoes.Refresh;
begin
  FModelDaoOperacoes.Get(True);
end;
end.
