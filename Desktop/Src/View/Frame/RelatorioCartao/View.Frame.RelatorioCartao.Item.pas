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

end;

end.
