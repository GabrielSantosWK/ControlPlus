unit View.Principal;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.Edit, FMX.Layouts, FMX.Objects,FMX.Ani,
  Model.DAO.Lancamentos, View.Frame.Lancamentos;

type
  TViewPrincipal = class(TForm)
    recNav: TRectangle;
    recTop: TRectangle;
    Rectangle3: TRectangle;
    Layout1: TLayout;
    Label1: TLabel;
    Button3: TButton;
    layContent: TLayout;
    procedure Label1Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ViewPrincipal: TViewPrincipal;

implementation

{$R *.fmx}

procedure TViewPrincipal.Button3Click(Sender: TObject);
begin
  var LViewFramento := TViewFrameLancamento.Create(layContent);
  LViewFramento.Parent := layContent;
  //LViewFramento.Align := TAlignLayout.Contents;
end;

procedure TViewPrincipal.Label1Click(Sender: TObject);
begin
  if recNav.Margins.Left = 0 then
    TAnimator.AnimateFloat(recNav,'Margins.Left',-130,0.2)
  else
    TAnimator.AnimateFloat(recNav,'Margins.Left',0,0.2)
end;

end.
