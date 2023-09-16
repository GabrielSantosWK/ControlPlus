program ControlPlus;

uses
  System.StartUpCopy,
  FMX.Forms,
  View.Principal in 'View\View.Principal.pas' {ViewPrincipal},
  Model.Connection in 'Model\Connection\Model.Connection.pas' {ModelConnection: TDataModule},
  Model.Client in 'Model\Client\Client\Model.Client.pas',
  Model.Client.Request.Base in 'Model\Client\Request\Model.Client.Request.Base.pas',
  Model.Connection.Net in 'Model\Connection\Model.Connection.Net.pas',
  View.Frame.Base in 'View\Frame\View.Frame.Base.pas' {ViewFrameBase: TFrame},
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
  Model.DAO.Dependentes in '..\..\Comuns\Model\DAO\Model.DAO.Dependentes.pas',
  View.Frame.Lancamentos in 'View\Frame\Lancamentos\View.Frame.Lancamentos.pas' {ViewFrameLancamento: TFrame},
  Model.Utils in 'Model\Utils\Model.Utils.pas',
  Helper.Edit in 'Model\Helper\Helper.Edit.pas',
  Model.Static.Cartoes in 'Model\Static\Model.Static.Cartoes.pas',
  Model.Static.Dependentes in 'Model\Static\Model.Static.Dependentes.pas',
  Model.Static.Operacoes in 'Model\Static\Model.Static.Operacoes.pas',
  Entity.Operacoes in '..\..\Comuns\Entity\Entity.Operacoes.pas',
  Model.DAO.Operacoes in '..\..\Comuns\Model\DAO\Model.DAO.Operacoes.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TViewPrincipal, ViewPrincipal);
  Application.CreateForm(TModelConnection, ModelConnection);
  Application.CreateForm(TForm2, Form2);
  Application.Run;
end.
