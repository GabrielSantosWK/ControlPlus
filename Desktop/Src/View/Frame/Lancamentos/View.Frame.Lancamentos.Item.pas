unit View.Frame.Lancamentos.Item;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Objects, FMX.Controls.Presentation, FMX.Layouts;

type
  TViewFrameLancamentosItem = class(TFrame)
    Rectangle1: TRectangle;
    Circle1: TCircle;
    Layout1: TLayout;
    Label1: TLabel;
    Label2: TLabel;
  private
    FValor: Currency;
    FDescricao: string;
    procedure SetValor(const Value: Currency);
    procedure SetDescricao(const Value: string);
    { Private declarations }
  public
    property Valor:Currency read FValor write SetValor;
    property Descricao:string read FDescricao write SetDescricao;
  end;

implementation

{$R *.fmx}

{ TViewFrameLancamentosItem }

procedure TViewFrameLancamentosItem.SetDescricao(const Value: string);
begin
  FDescricao := Value;
  Label2.Text := FDescricao;
end;

procedure TViewFrameLancamentosItem.SetValor(const Value: Currency);
begin
  FValor := Value;
  Label1.Text := FValor.ToString();
end;

end.
