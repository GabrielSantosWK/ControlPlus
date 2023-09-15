unit Model.DAO.Cartoes;

interface

uses Model.DAO.Base,
     Entity.Cartoes,
     System.Generics.Collections, Model.RTTI.Bind;

type
  TModelDAOCartoes = class(TModelDAOBase<TEntityCartoes>)
  private
  public
    constructor Create(); override;
    destructor Destroy(); override;
    function Insert:Boolean;override;
  end;

implementation

{ TModelDAOCartoes }

constructor TModelDAOCartoes.Create;
begin
  inherited;
  Entity := TEntityCartoes.Create;
end;

destructor TModelDAOCartoes.Destroy;
begin
  Entity.Free;
  inherited;
end;

function TModelDAOCartoes.Insert;
begin
  Entity.Id := GetID;
  Result := inherited;
end;

end.
