unit Model.Static.Dependentes;

interface

uses
  System.Generics.Collections,
  Entity.Dependentes,
  Model.DAO.Dependentes;

type
  TModelStaticDependentes = class
  private
    class var FInstance: TModelStaticDependentes;
  var
    FModelDaoDependentes: TModelDAODependentes;
  public
    class function GetInstance: TModelStaticDependentes;
    constructor Create();
    destructor Destroy(); override;
    procedure Refresh;
    function Find(const AID: string): TEntityDependentes;
    function List:TList<TEntityDependentes>;
  end;

implementation

{ TModelStaticDependentes }

constructor TModelStaticDependentes.Create;
begin
  FModelDaoDependentes := TModelDAODependentes.Create;
  Refresh;
end;

destructor TModelStaticDependentes.Destroy;
begin
  FModelDaoDependentes.Free;
  inherited;
end;

function TModelStaticDependentes.Find(const AID: string): TEntityDependentes;
begin
  Result := nil;
  for var Indice := 0 to Pred(FModelDaoDependentes.List.Count) do
  begin
    if FModelDaoDependentes.List[Indice].Id = AID then
    begin
      Result := FModelDaoDependentes.List[Indice];
      Break;
    end;
  end;
end;

class function TModelStaticDependentes.GetInstance: TModelStaticDependentes;
begin
  if not Assigned(FInstance) then
    FInstance := TModelStaticDependentes.Create;
  Result := FInstance;
end;

function TModelStaticDependentes.List: TList<TEntityDependentes>;
begin
  Result := FModelDaoDependentes.List;
end;

procedure TModelStaticDependentes.Refresh;
begin
  FModelDaoDependentes.Get(True);
end;

end.
