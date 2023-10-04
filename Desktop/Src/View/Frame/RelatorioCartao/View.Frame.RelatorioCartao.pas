unit View.Frame.RelatorioCartao;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  View.Frame.Base, FMX.Objects, FMX.Layouts, FMX.Controls.Presentation,
  FMX.DateTimeCtrls, Model.DAO.Lancamentos, View.Frame.RelatorioCartao.Item;

type
  TViewFrameRelaorioCartao = class(TViewFrameBase)
    VertScrollBox1: TVertScrollBox;
    Layout1: TLayout;
    Layout2: TLayout;
    edtDtInicial: TDateEdit;
    edtDtFinal: TDateEdit;
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ViewFrameRelaorioCartao: TViewFrameRelaorioCartao;

implementation

{$R *.fmx}

procedure TViewFrameRelaorioCartao.Button1Click(Sender: TObject);
begin
  var LModelDAOLancamento := TModelDAOLancamentos.Create;
  try
    LModelDAOLancamento.Get();
    LModelDAOLancamento.ListDataSet.First;
    while not (LModelDAOLancamento.ListDataSet.Eof) do
    begin
      var LItem := TViewFrameRelatorioCartaoItem.Create(nil);
      LItem.Parent := VertScrollBox1;
      LModelDAOLancamento.ListDataSet.Next;
    end;
  finally
    LModelDAOLancamento.Free;
  end;
end;

end.
