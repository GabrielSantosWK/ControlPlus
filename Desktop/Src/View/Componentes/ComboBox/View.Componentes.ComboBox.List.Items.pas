unit View.Componentes.ComboBox.List.Items;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Layouts, FMX.Effects, FMX.Objects, FMX.Ani, Helper.Scroll,
  View.Componentes.ComboBox.Items,Generics.Collections;

type
  TViewComponentesComboBoxListItems = class(TFrame)
    Rectangle3: TRectangle;
    ShadowEffect2: TShadowEffect;
    VertScrollBox1: TVertScrollBox;
    Rectangle1: TRectangle;
    procedure Rectangle1Click(Sender: TObject);
  private
    FOnChange: TProc<TObject>;
    FList:TDictionary<string,string>;
    procedure SetOnChange(const Value: TProc<TObject>);
  protected
     procedure Loaded; override;
  public
    procedure SetList(AList:TDictionary<string,string>);
    procedure OpenList();
    procedure CloseList();
    property OnChange:TProc<TObject> read FOnChange write SetOnChange;
  end;

implementation

{$R *.fmx}

{ TViewComponentesComboBoxListItems }

procedure TViewComponentesComboBoxListItems.CloseList;
begin
  TAnimator.AnimateFloat(Self,'Opacity',0,0.2);
  TThread.CreateAnonymousThread(
  procedure
  begin
    TThread.Sleep(200);
    TThread.Synchronize(nil,
    procedure
    begin
      Self.Visible := False;
    end);
  end).Start;
end;

procedure TViewComponentesComboBoxListItems.Loaded;
begin
  inherited;
  Visible := False;
  Self.Opacity := 0;
end;

procedure TViewComponentesComboBoxListItems.OpenList;
begin
  VertScrollBox1.ClearItems;
  var LCountName := 0;
  for var Key in FList.Keys do
  begin
    var LValueItemList := FList.Items[Key];
    var LItem := TViewComponentesComboBoxItems.Create(nil);
    LItem.Align := TAlignLayout.Top;
    LItem.Parent := VertScrollBox1;
    LItem.Descricao := LValueItemList;
    LItem.OnChange := Self.OnChange;
    Inc(LCountName);
  end;
  Visible := True;
  TAnimator.AnimateFloat(Self,'Opacity',1,0.2);
end;

procedure TViewComponentesComboBoxListItems.Rectangle1Click(Sender: TObject);
begin
  CloseList;
end;

procedure TViewComponentesComboBoxListItems.SetList(
  AList: TDictionary<string, string>);
begin
  FList := AList;
end;

procedure TViewComponentesComboBoxListItems.SetOnChange(const Value: TProc<TObject>);
begin
  FOnChange := Value;
end;

end.
