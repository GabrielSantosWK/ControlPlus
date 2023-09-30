unit View.Frame.Lancamentos;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,System.DateUtils,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  View.Frame.Base, FMX.Controls.Presentation, FMX.Layouts, FMX.Memo.Types,
  FMX.ScrollBox, FMX.Memo, Model.DAO.Lancamentos, Helper.Scroll,
  View.Frame.Lancamentos.Item, FMX.Edit, FMX.Objects, FMX.ListBox,
  Model.DAO.Cartoes, System.Generics.Collections, Model.DAO.Dependentes,
  FMX.DateTimeCtrls, Model.Utils, Helper.Edit, Model.Static.Cartoes,
  Model.Static.Dependentes, Model.Static.Operacoes, FMX.Effects;

type
  TViewFrameLancamento = class(TViewFrameBase)
    VertScrollBox: TVertScrollBox;
    layControls: TLayout;
    Layout1: TLayout;
    ComboBox1: TComboBox;
    cbCartao: TComboBox;
    cbDependente: TComboBox;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Rectangle1: TRectangle;
    Label7: TLabel;
    Layout2: TLayout;
    Rectangle2: TRectangle;
    Label1: TLabel;
    edtDescricao: TEdit;
    ShadowEffect1: TShadowEffect;
    Layout3: TLayout;
    Rectangle3: TRectangle;
    edtValor: TEdit;
    ShadowEffect2: TShadowEffect;
    Label8: TLabel;
    Rectangle4: TRectangle;
    Label5: TLabel;
    chbGerarPeriodo: TCheckBox;
    Label9: TLabel;
    edtDataVencimento: TDateEdit;
    Layout4: TLayout;
    Rectangle5: TRectangle;
    edtQuantidadeMeses: TEdit;
    ShadowEffect3: TShadowEffect;
    Label6: TLabel;
    procedure edtValorKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char;
      Shift: TShiftState);
    procedure Rectangle1Click(Sender: TObject);
    procedure Rectangle4Click(Sender: TObject);
  private
    FDicCombo: TDictionary<Integer, string>;
    FDicComboDependente: TDictionary<Integer, string>;
    FStaticCartoes:TModelStaticCartoes;
    FStaticDependentes:TModelStaticDependentes;
    FStaticOperacoes:TModelStaticOperacoes;
    procedure Gravar;
    procedure Buscar;
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

procedure TViewFrameLancamento.Buscar;
begin
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

procedure TViewFrameLancamento.Gravar;
begin
  if chbGerarPeriodo.IsChecked then
  begin
    var LQuantidadeMesses := StrToIntDef(edtQuantidadeMeses.Text,0);
    var LMes := MonthOf(Now);
    var LAno := YearOf(Now);
    for var i := 1 to LQuantidadeMesses do
    begin
      var LModelDAOLancamentos := TModelDAOLancamentos.Create;
      try
        LModelDAOLancamentos.Entity.Descricao := edtDescricao.Text;
        LModelDAOLancamentos.Entity.IdCartao := FDicCombo.Items[cbCartao.ItemIndex];
        LModelDAOLancamentos.Entity.IdDependente := FDicComboDependente.Items[cbDependente.ItemIndex];
        LModelDAOLancamentos.Entity.DataLancamento := Now;
        LModelDAOLancamentos.Entity.DataVencimento := StrToDate(DayOf(edtDataVencimento.Date).ToString+'/'+LMes.ToString+'/'+LAno.ToString);
        LModelDAOLancamentos.Entity.Valor := edtValor.ToCurrency;
        LModelDAOLancamentos.Entity.IdOperacao := 'C1F82DF6-F460-46CF-A2B3-E3AE80D641D1';
        LModelDAOLancamentos.Insert;
      finally
        LModelDAOLancamentos.Free;
      end;
      Inc(LMes);
      if LMes > 12 then
      begin
        LMes := 1;
        Inc(LAno);
      end;
    end;
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

procedure TViewFrameLancamento.Rectangle1Click(Sender: TObject);
begin
  inherited;
  Buscar;
end;

procedure TViewFrameLancamento.Rectangle4Click(Sender: TObject);
begin
  Gravar;
end;

end.
