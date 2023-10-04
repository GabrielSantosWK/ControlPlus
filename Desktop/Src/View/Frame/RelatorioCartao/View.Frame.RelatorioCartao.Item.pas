unit View.Frame.RelatorioCartao.Item;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Effects, FMX.Controls.Presentation, FMX.Objects, FMX.Layouts,Data.DB;

type
  TViewFrameRelatorioCartaoItem = class(TFrame)
    recBase: TRectangle;
    Layout1: TLayout;
    Circle1: TCircle;
    lblValor: TLabel;
    lblDescricao: TLabel;
    ShadowEffect1: TShadowEffect;
    Layout2: TLayout;
    lblCartao: TLabel;
    Layout3: TLayout;
    lblDtLancamento: TLabel;
    Layout4: TLayout;
    Label1: TLabel;
    lblDtVencimento: TLabel;
  private
    { Private declarations }
  public
    procedure SetData(ADataSet:TDataSet);
  end;

implementation

{$R *.fmx}

{ TViewFrameRelatorioCartaoItem }

procedure TViewFrameRelatorioCartaoItem.SetData(ADataSet: TDataSet);
begin
  lblDescricao.Text := ADataSet.FieldByName('descricao').AsString;
  lblValor.Text := CurrToStr(ADataSet.FieldByName('valor').AsCurrency);
  lblDtLancamento.Text := ADataSet.FieldByName('data_lancamento').AsString;
  lblDtVencimento.Text := ADataSet.FieldByName('data_vencimento').AsString;
end;

end.
