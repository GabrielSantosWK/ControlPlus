unit View.Frame.Compra.Cartao;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  View.Frame.Base, View.Componentes.ComboBox, FMX.Controls.Presentation,
  FMX.Objects, FMX.Layouts, View.Componentes.ComboBox.List.Items,
  Model.Static.Cartoes, FMX.Effects, FMX.Edit,
  System.DateUtils,Model.DAO.Lancamentos, Model.Static.Dependentes, Helper.Edit,
  Model.Utils;

type
  TViewFrameCompraCartao = class(TViewFrameBase)
    layControls: TLayout;
    Layout1: TLayout;
    Rectangle1: TRectangle;
    Label7: TLabel;
    Rectangle4: TRectangle;
    Label5: TLabel;
    ComboBoxCartao: TViewComponenteComboBox;
    ComboBoxListItemsCartao: TViewComponentesComboBoxListItems;
    chbGerarPeriodo: TCheckBox;
    Layout3: TLayout;
    Rectangle3: TRectangle;
    edtValor: TEdit;
    ShadowEffect2: TShadowEffect;
    Label8: TLabel;
    Layout4: TLayout;
    Rectangle5: TRectangle;
    edtQuantidadeMeses: TEdit;
    ShadowEffect3: TShadowEffect;
    Label6: TLabel;
    Layout2: TLayout;
    Rectangle2: TRectangle;
    edtDescricao: TEdit;
    ShadowEffect1: TShadowEffect;
    Label1: TLabel;
    ComboBoxDependente: TViewComponenteComboBox;
    ComboBoxListItemsDependente: TViewComponentesComboBoxListItems;
    procedure chbGerarPeriodoClick(Sender: TObject);
    procedure Rectangle4Click(Sender: TObject);
    procedure edtValorKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char;
      Shift: TShiftState);
  private
    FStaticCartao:TModelStaticCartoes;
    FStaticDependente:TModelStaticDependentes;
    procedure GravarVariosRegistros;
    procedure SaveOneRegister;
    function GetDataDiaVencimento(const ADateVencCard:Integer):TDate;
  public
    procedure AfterConstruction; override;
    procedure BeforeDestruction; override;

  end;

var
  ViewFrameCompraCartao: TViewFrameCompraCartao;

implementation

{$R *.fmx}

{ TViewFrameCompraCartao }

procedure TViewFrameCompraCartao.AfterConstruction;
begin
  inherited;
  Layout4.Visible := False;

  FStaticCartao := TModelStaticCartoes.GetInstance;
  FStaticDependente := TModelStaticDependentes.GetInstance;

  ComboBoxCartao.ListItem := ComboBoxListItemsCartao;
  ComboBoxDependente.ListItem := ComboBoxListItemsDependente;

  ComboBoxCartao.Item.Clear;
  for var I := 0 to Pred(FStaticCartao.List.Count) do
    ComboBoxCartao.Item.Add(FStaticCartao.List[i].id,FStaticCartao.List[i].Descricao);

  ComboBoxDependente.Item.Clear;
  for var I := 0 to Pred(FStaticDependente.List.Count) do
    ComboBoxDependente.Item.Add(FStaticDependente.List[i].id,FStaticDependente.List[i].Nome);

end;

procedure TViewFrameCompraCartao.BeforeDestruction;
begin
  inherited;

end;

procedure TViewFrameCompraCartao.chbGerarPeriodoClick(Sender: TObject);
begin
  inherited;
  Layout4.Visible := not(chbGerarPeriodo.IsChecked);
end;

procedure TViewFrameCompraCartao.edtValorKeyUp(Sender: TObject; var Key: Word;
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

function TViewFrameCompraCartao.GetDataDiaVencimento(
  const ADateVencCard: Integer): TDate;
begin
  var LMes:Integer;
  var LAno:Integer;
  LMes := MonthOf(Now);
  LAno := YearOf(Now);
  Result := StrToDate(ADateVencCard.ToString+'/'+LMes.ToString+'/'+LAno.ToString);
end;

procedure TViewFrameCompraCartao.GravarVariosRegistros;
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
        LModelDAOLancamentos.Entity.IdCartao := ComboBoxCartao.Key;
        LModelDAOLancamentos.Entity.IdDependente := ComboBoxDependente.Key;
        LModelDAOLancamentos.Entity.DataLancamento := Now;
        var LDia := FStaticCartao.Find(LModelDAOLancamentos.Entity.IdCartao).Vencimento;
        LModelDAOLancamentos.Entity.DataVencimento := StrToDate(LDia.ToString+'/'+LMes.ToString+'/'+LAno.ToString);
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

procedure TViewFrameCompraCartao.Rectangle4Click(Sender: TObject);
begin
  inherited;
  if chbGerarPeriodo.IsChecked then
    GravarVariosRegistros
  else
    SaveOneRegister;
end;

procedure TViewFrameCompraCartao.SaveOneRegister;
begin
  var LModelDAOLancamentos := TModelDAOLancamentos.Create;
  try
    LModelDAOLancamentos.Entity.Descricao := edtDescricao.Text;
    LModelDAOLancamentos.Entity.IdCartao := ComboBoxCartao.Key;
    LModelDAOLancamentos.Entity.IdDependente := ComboBoxDependente.Key;
    LModelDAOLancamentos.Entity.DataLancamento := Now;
    var LDia := FStaticCartao.Find(LModelDAOLancamentos.Entity.IdCartao).Vencimento;
    LModelDAOLancamentos.Entity.DataVencimento := GetDataDiaVencimento(LDia);
    LModelDAOLancamentos.Entity.Valor := edtValor.ToCurrency;
    LModelDAOLancamentos.Entity.IdOperacao := 'C1F82DF6-F460-46CF-A2B3-E3AE80D641D1';
    LModelDAOLancamentos.Insert;
  finally
    LModelDAOLancamentos.Free;
  end;
end;

end.
