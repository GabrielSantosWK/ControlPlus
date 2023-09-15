program ControlPlus;

uses
  System.StartUpCopy,
  FMX.Forms,
  View.Principal in 'View\View.Principal.pas' {Form1},
  Model.Connection in 'Model\Connection\Model.Connection.pas' {ModelConnection: TDataModule},
  Model.Client in 'Model\Client\Client\Model.Client.pas',
  Model.Client.Request.Base in 'Model\Client\Request\Model.Client.Request.Base.pas',
  Model.Connection.Net in 'Model\Connection\Model.Connection.Net.pas',
  View.Frame.Base in 'View\Frame\View.Frame.Base.pas' {ViewFrameBase: TFrame},
  View.Frame.Lancamentos in 'View\Frame\View.Frame.Lancamentos.pas' {ViewFrameLancamento: TFrame},
  Entity.Base in '..\..\Comuns\Entity\Entity.Base.pas',
  Entity.Cartoes in '..\..\Comuns\Entity\Entity.Cartoes.pas',
  Entity.Lancamentos in '..\..\Comuns\Entity\Entity.Lancamentos.pas',
  Model.DAO.Base in '..\..\Comuns\Model\DAO\Model.DAO.Base.pas',
  Model.DAO.Cartoes in '..\..\Comuns\Model\DAO\Model.DAO.Cartoes.pas',
  Model.DAO.Lancamentos in '..\..\Comuns\Model\DAO\Model.DAO.Lancamentos.pas',
  Model.RTTI.Attributes in '..\..\Comuns\RTTI\Model.RTTI.Attributes.pas',
  Model.RTTI.Bind in '..\..\Comuns\RTTI\Model.RTTI.Bind.pas',
  View.Frame.Lancamentos.Item in 'View\Frame\Lancamentos\View.Frame.Lancamentos.Item.pas' {ViewFrameLancamentosItem: TFrame},
  Helper.Scroll in 'Model\Helper\Helper.Scroll.pas',
  View.Teste.Layout in 'View\View.Teste.Layout.pas' {Form2},
  Entity.Dependentes in '..\..\Comuns\Entity\Entity.Dependentes.pas',
  Model.DAO.Dependentes in '..\..\Comuns\Model\DAO\Model.DAO.Dependentes.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TModelConnection, ModelConnection);
  Application.CreateForm(TForm2, Form2);
  Application.Run;
end.
