unit View.Frame.Lancamentos.Item;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Objects, FMX.Controls.Presentation, FMX.Layouts, FMX.Effects;

type
  TViewFrameLancamentosItem = class(TFrame)
    recBase: TRectangle;
    Circle1: TCircle;
    Layout1: TLayout;
    lblValor: TLabel;
    lblDescricao: TLabel;
    ShadowEffect1: TShadowEffect;
    lblCartao: TLabel;
    Layout2: TLayout;
    lblOperacao: TLabel;
  private
    FValor: Currency;
    FDescricao: string;
    FCartao: string;
    FOperacao: string;
    procedure SetValor(const Value: Currency);
    procedure SetDescricao(const Value: string);
    procedure SetCartao(const Value: string);
    procedure SetOperacao(const Value: string);
    { Private declarations }
  public
    property Valor:Currency read FValor write SetValor;
    property Descricao:string read FDescricao write SetDescricao;
    property Cartao:string read FCartao write SetCartao;
    property Operacao:string read FOperacao write SetOperacao;
  end;

implementation

{$R *.fmx}

{ TViewFrameLancamentosItem }

procedure TViewFrameLancamentosItem.SetCartao(const Value: string);
begin
  FCartao := Value;
  lblCartao.Text := FCartao;
end;

procedure TViewFrameLancamentosItem.SetDescricao(const Value: string);
begin
  FDescricao := Value;
  lblDescricao.Text := FDescricao;
end;

procedure TViewFrameLancamentosItem.SetOperacao(const Value: string);
begin
  FOperacao := Value;
  lblOperacao.Text := FOperacao;
end;

procedure TViewFrameLancamentosItem.SetValor(const Value: Currency);
begin
  FValor := Value;
  lblValor.Text := FValor.ToString();
end;

end.
