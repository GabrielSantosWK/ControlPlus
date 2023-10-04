unit View.Principal;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.Edit, FMX.Layouts, FMX.Objects,FMX.Ani,
  Model.DAO.Lancamentos, View.Frame.Lancamentos, View.Frame.Compra.Cartao,
  View.Frame.RelatorioCartao;

type
  TViewPrincipal = class(TForm)
    recNav: TRectangle;
    recTop: TRectangle;
    Rectangle3: TRectangle;
    Layout1: TLayout;
    Label1: TLabel;
    Button3: TButton;
    layContent: TLayout;
    Button1: TButton;
    Button2: TButton;
    procedure Label1Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Button2Click(Sender: TObject);
  private
    procedure ClearMainPage;
  public
    { Public declarations }
  end;

var
  ViewPrincipal: TViewPrincipal;

implementation

{$R *.fmx}

procedure TViewPrincipal.Button1Click(Sender: TObject);
begin
  ClearMainPage;
  var LViewFramento := TViewFrameLancamento.Create(layContent);
  LViewFramento.Parent := layContent;
end;

procedure TViewPrincipal.Button2Click(Sender: TObject);
begin
  ClearMainPage;
  var LViewFrameRelatorioCartao := TViewFrameRelaorioCartao.Create(layContent);
  LViewFrameRelatorioCartao.Parent := layContent;
end;

procedure TViewPrincipal.Button3Click(Sender: TObject);
begin
  ClearMainPage;
  var LViewFrameCartao := TViewFrameCompraCartao.Create(layContent);
  LViewFrameCartao.Parent := layContent;
end;

procedure TViewPrincipal.ClearMainPage;
begin
  for var i := 0 to Pred(layContent.ControlsCount) do
  begin
    if layContent.Controls[i] is TFrame then
      TFrame(layContent.Controls[i]).Free;
  end;
end;

procedure TViewPrincipal.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  ClearMainPage;
end;

procedure TViewPrincipal.Label1Click(Sender: TObject);
begin
  if recNav.Margins.Left = 0 then
    TAnimator.AnimateFloat(recNav,'Margins.Left',-130,0.2)
  else
    TAnimator.AnimateFloat(recNav,'Margins.Left',0,0.2)
end;

end.
