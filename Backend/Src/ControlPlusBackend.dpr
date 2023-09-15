program ControlPlusBackend;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  Horse,
  Horse.Jhonson,
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
  Model.RTTI.Bind in '..\..\Comuns\RTTI\Model.RTTI.Bind.pas';

begin
  THorse.Use(Jhonson());

  Controller.Lancamento.Registry;
  Controller.Cartoes.Registry;

  THorse.Listen(9000);
end.
