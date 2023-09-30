unit View.Frame.Compra.Cartao.Item;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Effects, FMX.Controls.Presentation, FMX.Objects, FMX.Layouts;

type
  TViewFrameCompraCartaoItem = class(TFrame)
    recBase: TRectangle;
    Layout1: TLayout;
    Circle1: TCircle;
    lblValor: TLabel;
    lblDescricao: TLabel;
    ShadowEffect1: TShadowEffect;
    Layout2: TLayout;
    lblCartao: TLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.fmx}

end.
