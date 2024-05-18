unit View.Frame.RelatorioCartao;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  View.Frame.Base, FMX.Objects, FMX.Layouts, FMX.Controls.Presentation,
  FMX.DateTimeCtrls, Model.DAO.Lancamentos, View.Frame.RelatorioCartao.Item,
  Helper.Scroll;

type
  TViewFrameRelaorioCartao = class(TViewFrameBase)
    VertScrollBox1: TVertScrollBox;
    Layout1: TLayout;
    Layout2: TLayout;
    edtDtInicial: TDateEdit;
    edtDtFinal: TDateEdit;
    Button1: TButton;
    Button2: TButton;
    Label1: TLabel;
    lblValorTotal: TLabel;
    CheckBoxCasal: TCheckBox;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    procedure BuscarLancamento(const AField:string);
   protected
    procedure Loaded; override;
   public

  end;

var
  ViewFrameRelaorioCartao: TViewFrameRelaorioCartao;

implementation

{$R *.fmx}

procedure TViewFrameRelaorioCartao.BuscarLancamento(const AField: string);
begin
  VertScrollBox1.ClearItems;
  var LModelDAOLancamento := TModelDAOLancamentos.Create;
  try
    LModelDAOLancamento.Filter.Between
                       .FieldDataBase(AField)
                       .FirstFilter(edtDtInicial.Date)
                       .SecondFilter(edtDtFinal.Date);

    LModelDAOLancamento.Filter.Equals
                       .FieldDataBase('conta_casal')
                       .Value(CheckBoxCasal.IsChecked);

    LModelDAOLancamento.Filter.Sort
                       .FieldDataBase('data_vencimento');

    LModelDAOLancamento.Get(LModelDAOLancamento.Filter);
    LModelDAOLancamento.ListDataSet.First;
    var LValorTotal:Currency := 0;
    while not (LModelDAOLancamento.ListDataSet.Eof) do
    begin
      var LItem := TViewFrameRelatorioCartaoItem.Create(nil);
      LItem.Parent := VertScrollBox1;
      LItem.Align := TAlignLayout.Bottom;
      LItem.Align := TAlignLayout.MostTop;
      LItem.SetData(LModelDAOLancamento.ListDataSet);
      LValorTotal := LValorTotal + LModelDAOLancamento.ListDataSet.FieldByName('valor').AsCurrency;
      LModelDAOLancamento.ListDataSet.Next;
    end;
    lblValorTotal.Text := LValorTotal.ToString();
  finally
    LModelDAOLancamento.Free;
  end;
end;

procedure TViewFrameRelaorioCartao.Button1Click(Sender: TObject);
begin
  BuscarLancamento('data_lancamento');
end;

procedure TViewFrameRelaorioCartao.Button2Click(Sender: TObject);
begin
  BuscarLancamento('data_vencimento');
end;

procedure TViewFrameRelaorioCartao.Loaded;
begin
  inherited;
  edtDtInicial.Date := Now;
  edtDtFinal.Date := Now;
end;

end.
