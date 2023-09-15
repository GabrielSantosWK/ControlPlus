unit View.Principal;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.Edit, FMX.Layouts, FMX.Objects,FMX.Ani,
  Model.DAO.Lancamentos;

type
  TForm1 = class(TForm)
    Edit1: TEdit;
    Button1: TButton;
    recNav: TRectangle;
    recTop: TRectangle;
    Rectangle3: TRectangle;
    Layout1: TLayout;
    Label1: TLabel;
    Button2: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Label1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.fmx}

procedure TForm1.Button1Click(Sender: TObject);
begin
  Edit1.Text := TGUID.NewGuid.ToString.Replace('{','',[rfReplaceAll]).Replace('}','',[rfReplaceAll]);
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  var  LModelDAOLancamentos := TModelDAOLancamentos.Create;
  try
    LModelDAOLancamentos.Entity.IdCartao := '17FFD4D7-2C06-4731-98BF-050F5E71AA6C';
    LModelDAOLancamentos.Entity.IdDependente := 'D113473A-3AF4-4A54-96BC-402F841978C6';
    LModelDAOLancamentos.Entity.DataLancamento := Now;
    LModelDAOLancamentos.Entity.DataVencimento := Now;
    LModelDAOLancamentos.Entity.Valor := 12152.02;
    LModelDAOLancamentos.Entity.IdOperacao := 'C1F82DF6-F460-46CF-A2B3-E3AE80D641D1';
    LModelDAOLancamentos.Insert;

  finally
    LModelDAOLancamentos.Free;
  end;
end;

procedure TForm1.Label1Click(Sender: TObject);
begin
  if recNav.Margins.Left = 0 then
    TAnimator.AnimateFloat(recNav,'Margins.Left',-130,0.2)
  else
    TAnimator.AnimateFloat(recNav,'Margins.Left',0,0.2)
end;

end.
