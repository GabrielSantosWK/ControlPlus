unit Model.DAO.Operacoes;

interface

uses Model.DAO.Base,
     Entity.Operacoes,
     System.Generics.Collections, Model.RTTI.Bind;

type
  TModelDAOOperacoes = class(TModelDAOBase<TEntityOperacoes>)
  private
  public
    constructor Create(); override;
    destructor Destroy(); override;
    function Insert:Boolean;override;
  end;

implementation

{ TModelDAOOperacoes }

constructor TModelDAOOperacoes.Create;
begin
  inherited;
  Entity := TEntityOperacoes.Create;
end;

destructor TModelDAOOperacoes.Destroy;
begin
  Entity.Free;
  inherited;
end;

function TModelDAOOperacoes.Insert;
begin
  Entity.Id := GetID;
  Result := inherited;
end;
end.
