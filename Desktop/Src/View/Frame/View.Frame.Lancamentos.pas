unit View.Frame.Lancamentos;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  View.Frame.Base, FMX.Controls.Presentation, FMX.Layouts, FMX.Memo.Types,
  FMX.ScrollBox, FMX.Memo;

type
  TViewFrameLancamento = class(TViewFrameBase)
    VertScrollBox1: TVertScrollBox;
    Button1: TButton;
    Memo1: TMemo;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ViewFrameLancamento: TViewFrameLancamento;

implementation

{$R *.fmx}

end.
