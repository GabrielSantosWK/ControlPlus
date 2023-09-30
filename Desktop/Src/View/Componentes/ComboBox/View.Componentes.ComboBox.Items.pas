unit View.Componentes.ComboBox.Items;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants, FMX.Layouts,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Effects, FMX.Objects, FMX.Controls.Presentation;

type
  TViewComponentesComboBoxItems = class(TFrame)
    Rectangle3: TRectangle;
    Circle1: TCircle;
    lblDescricao: TLabel;
    procedure FrameClick(Sender: TObject);
  private
  var
    FIndice: Integer;
    FDescricao: string;
    FKey:string;
    FOnChange: TProc<TObject>;
    procedure SetDescricao(const Value: string);
    procedure SetOnChange(const Value: TProc<TObject>);
  protected
    procedure Loaded; override;
  public
    procedure AfterConstruction; override;
    property Indice: Integer read FIndice;
    property Key:string read FKey;
    property Descricao:string read FDescricao write SetDescricao;
    property OnChange:TProc<TObject> read FOnChange write SetOnChange;
  end;

implementation

{$R *.fmx}
{ TViewComponentesComboBoxItems }

procedure TViewComponentesComboBoxItems.AfterConstruction;
begin
  inherited;
end;

procedure TViewComponentesComboBoxItems.FrameClick(Sender: TObject);
begin
  if Assigned(FOnChange) then
    FOnChange(Self);
end;

procedure TViewComponentesComboBoxItems.Loaded;
begin
  inherited;
end;

procedure TViewComponentesComboBoxItems.SetDescricao(const Value: string);
begin
  FDescricao := Value;
  lblDescricao.Text := FDescricao;
end;

procedure TViewComponentesComboBoxItems.SetOnChange(
  const Value: TProc<TObject>);
begin
  FOnChange := Value;
end;

end.
