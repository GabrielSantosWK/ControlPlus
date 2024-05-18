program ControlPlusBackend;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  Horse,
  Horse.Jhonson,
  Horse.Cors,
  System.SysUtils,
  Model.Connection in 'Model\Connection\Model.Connection.pas' {ModelConnection: TDataModule},
  Controller.Lancamento in 'Controller\Controller.Lancamento.pas',
  Controller.Cartoes in 'Controller\Controller.Cartoes.pas',
  Entity.Base in '..\..\Comuns\Entity\Entity.Base.pas',
  Entity.Cartoes in '..\..\Comuns\Entity\Entity.Cartoes.pas',
  Entity.Lancamentos in '..\..\Comuns\Entity\Entity.Lancamentos.pas',
  Model.DAO.Base in '..\..\Comuns\Model\DAO\Model.DAO.Base.pas',
  Model.DAO.Cartoes in '..\..\Comuns\Model\DAO\Model.DAO.Cartoes.pas',
  Model.DAO.Lancamentos in '..\..\Comuns\Model\DAO\Model.DAO.Lancamentos.pas',
  Model.RTTI.Attributes in '..\..\Comuns\RTTI\Model.RTTI.Attributes.pas',
  Model.RTTI.Bind in '..\..\Comuns\RTTI\Model.RTTI.Bind.pas',
  Model.DAO.Filter in '..\..\Comuns\Model\DAO\Model.DAO.Filter.pas',
  Model.DAO.Filter.Between in '..\..\Comuns\Model\DAO\Model.DAO.Filter.Between.pas',
  Model.DAO.Filter.Factory in '..\..\Comuns\Model\DAO\Model.DAO.Filter.Factory.pas',
  Model.DAO.Filter.Equals in '..\..\Comuns\Model\DAO\Model.DAO.Filter.Equals.pas',
  Model.DAO.Filter.Sort in '..\..\Comuns\Model\DAO\Model.DAO.Filter.Sort.pas';

begin
  THorse.Use(Jhonson());
  THorse.Use(Cors);

  Controller.Lancamento.Registry;
  Controller.Cartoes.Registry;

  THorse.Listen(9000);
end.
