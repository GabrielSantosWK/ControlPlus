unit View.Frame.Lancamentos;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  View.Frame.Base, FMX.Controls.Presentation, FMX.Layouts, FMX.Memo.Types,
  FMX.ScrollBox, FMX.Memo, Model.DAO.Lancamentos, Helper.Scroll,
  View.Frame.Lancamentos.Item, FMX.Edit, FMX.Objects, FMX.ListBox,
  Model.DAO.Cartoes, System.Generics.Collections, Model.DAO.Dependentes,
  FMX.DateTimeCtrls, Model.Utils, Helper.Edit, Model.Static.Cartoes,
  Model.Static.Dependentes, Model.Static.Operacoes;

type
  TViewFrameLancamento = class(TViewFrameBase)
    VertScrollBox: TVertScrollBox;
    Button1: TButton;
    Button2: TButton;
    layControls: TLayout;
    Layout1: TLayout;
    edtDescricao: TEdit;
    ComboBox1: TComboBox;
    cbCartao: TComboBox;
    cbDependente: TComboBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    edtValor: TEdit;
    Label5: TLabel;
    Label6: TLabel;
    edtDataVencimento: TDateEdit;
    Button3: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure edtValorKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char;
      Shift: TShiftState);
  private
    FDicCombo: TDictionary<Integer, string>;
    FDicComboDependente: TDictionary<Integer, string>;
    FStaticCartoes:TModelStaticCartoes;
    FStaticDependentes:TModelStaticDependentes;
    FStaticOperacoes:TModelStaticOperacoes;
  protected
    procedure Loaded; override;
  public
    procedure AfterConstruction; override;
    procedure BeforeDestruction; override;

  end;

var
  ViewFrameLancamento: TViewFrameLancamento;

implementation

{$R *.fmx}

procedure TViewFrameLancamento.AfterConstruction;
begin
  inherited;
end;

procedure TViewFrameLancamento.BeforeDestruction;
begin
  inherited;
  FDicCombo.Free;
end;

procedure TViewFrameLancamento.Button1Click(Sender: TObject);
begin
  var
  LModelDAOLancamentos := TModelDAOLancamentos.Create;
  try
    LModelDAOLancamentos.Entity.Descricao := edtDescricao.Text;
    LModelDAOLancamentos.Entity.IdCartao := FDicCombo.Items[cbCartao.ItemIndex];
    LModelDAOLancamentos.Entity.IdDependente := FDicComboDependente.Items[cbDependente.ItemIndex];
    LModelDAOLancamentos.Entity.DataLancamento := Now;
    LModelDAOLancamentos.Entity.DataVencimento := edtDataVencimento.Date;
    LModelDAOLancamentos.Entity.Valor := edtValor.ToCurrency;
    LModelDAOLancamentos.Entity.IdOperacao := 'C1F82DF6-F460-46CF-A2B3-E3AE80D641D1';
    LModelDAOLancamentos.Insert;

  finally
    LModelDAOLancamentos.Free;
  end;
end;

procedure TViewFrameLancamento.Button2Click(Sender: TObject);
begin
  inherited;
  VertScrollBox.ClearItems;
  var
  LModelDAOLancamentos := TModelDAOLancamentos.Create;
  try
    LModelDAOLancamentos.Get;
    LModelDAOLancamentos.ListDataSet.First;
    while not(LModelDAOLancamentos.ListDataSet.Eof) do
    begin
      var Litem := TViewFrameLancamentosItem.Create(nil);
      Litem.Parent := VertScrollBox;
      Litem.Valor := LModelDAOLancamentos.ListDataSet.FieldByName('valor').AsCurrency;
      Litem.Descricao := LModelDAOLancamentos.ListDataSet.FieldByName('descricao').AsString;
      Litem.Cartao := FStaticCartoes.Find(LModelDAOLancamentos.ListDataSet.FieldByName('id_cartao').AsString).Descricao;
      Litem.operacao := FStaticOperacoes.Find(LModelDAOLancamentos.ListDataSet.FieldByName('id_operacao').AsString).Descricao;
      LModelDAOLancamentos.ListDataSet.Next;
    end;

  finally
    LModelDAOLancamentos.Free;
  end;
end;

procedure TViewFrameLancamento.edtValorKeyUp(Sender: TObject; var Key: Word;
  var KeyChar: Char; Shift: TShiftState);
begin
  inherited;
  if Ord(Key) in [0..9] then
  begin
    edtValor.Text :=  TModelUtils.FormatCurrencyValue(edtValor.Text);
    edtValor.SelStart := 1000;
    Key := 0;
  end;
end;

procedure TViewFrameLancamento.Loaded;
begin
  inherited;
  var LModelDaoCartoes := TModelDAOCartoes.Create;
  try
    FDicCombo := TDictionary<Integer,string>.Create;
    FDicCombo.Clear;
    LModelDaoCartoes.Get;
    LModelDaoCartoes.ListDataSet.First;
    cbCartao.Clear;
    while not(LModelDaoCartoes.ListDataSet.Eof) do
    begin
      cbCartao.Items.Add(LModelDaoCartoes.ListDataSet.FieldByName('descricao').AsString);
      FDicCombo.Add(cbCartao.Items.Count-1,LModelDaoCartoes.ListDataSet.FieldByName('id').AsString);
      LModelDaoCartoes.ListDataSet.Next;
    end;
  finally
    LModelDaoCartoes.Free;
  end;

  var LModelDaoDependentes := TModelDAODependentes.Create;
  try
    FDicComboDependente := TDictionary<Integer,string>.Create;
    FDicComboDependente.Clear;
    LModelDaoDependentes.Get;
    LModelDaoDependentes.ListDataSet.First;
    cbDependente.Clear;
    while not(LModelDaoDependentes.ListDataSet.Eof) do
    begin
      cbDependente.Items.Add(LModelDaoDependentes.ListDataSet.FieldByName('nome').AsString);
      FDicComboDependente.Add(cbDependente.Items.Count-1,LModelDaoDependentes.ListDataSet.FieldByName('id').AsString);
      LModelDaoDependentes.ListDataSet.Next;
    end;
  finally
    LModelDaoCartoes.Free;
  end;

  FStaticCartoes := TModelStaticCartoes.GetInstance;
  FStaticOperacoes := TModelStaticOperacoes.GetInstance;
  FStaticDependentes := TModelStaticDependentes.GetInstance;

end;

end.
