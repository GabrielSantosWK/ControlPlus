unit Model.DAO.Dependentes;

interface

uses Model.DAO.Base,
     Entity.Dependentes,
     System.Generics.Collections, Model.RTTI.Bind;

type
  TModelDAODependentes = class(TModelDAOBase<TEntityDependentes>)
  private
  public
    constructor Create(); override;
    destructor Destroy(); override;
    function Insert:Boolean;override;
  end;

implementation

{ TModelDAODependentes }

constructor TModelDAODependentes.Create;
begin
  inherited;
  Entity := TEntityDependentes.Create;
end;

destructor TModelDAODependentes.Destroy;
begin
  Entity.Free;
  inherited;
end;

function TModelDAODependentes.Insert;
begin
  Entity.Id := GetID;
  Result := inherited;
end;

end.
