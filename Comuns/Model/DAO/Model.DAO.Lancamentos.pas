unit Model.DAO.Lancamentos;

interface

uses Model.DAO.Base,
     Entity.Lancamentos,
     System.Generics.Collections, Model.RTTI.Bind;

type
  TModelDAOLancamentos = class(TModelDAOBase<TEntityLancamentos>)
  private
  public
    constructor Create(); override;
    destructor Destroy(); override;
    function Insert:Boolean;override;
  end;

implementation

{ TModelDAOLancamentos }

constructor TModelDAOLancamentos.Create;
begin
  inherited;
  Entity := TEntityLancamentos.Create;
end;

destructor TModelDAOLancamentos.Destroy;
begin
  Entity.Free;
  inherited;
end;

function TModelDAOLancamentos.Insert;
begin
  Entity.Id := GetID;
  Result := inherited;
end;
end.
