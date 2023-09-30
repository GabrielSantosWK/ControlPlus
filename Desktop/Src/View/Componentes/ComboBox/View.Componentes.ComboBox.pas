unit View.Componentes.ComboBox;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Objects, FMX.Controls.Presentation, FMX.Effects, FMX.Layouts,
  System.Generics.Collections,
  View.Componentes.ComboBox.List.Items, View.Componentes.ComboBox.Items;

type

  TViewComponenteComboBox = class(TFrame)
    Layout3: TLayout;
    Rectangle3: TRectangle;
    ShadowEffect2: TShadowEffect;
    Label8: TLabel;
    Image1: TImage;
    lblDescricao: TLabel;
    procedure Image1Click(Sender: TObject);
  private
    FKey:string;
    FValue:string;
    FListItem: TViewComponentesComboBoxListItems;
    FItem:TDictionary<string,string>;
    procedure SetListItem(const Value: TViewComponentesComboBoxListItems);
    procedure OnChangeListItem(Sender:TObject);
    function GetItem: TDictionary<string, string>;
  public
    procedure AfterConstruction; override;
    procedure BeforeDestruction; override;
    property ListItem:TViewComponentesComboBoxListItems read FListItem write SetListItem;
    property Item:TDictionary<string,string> read GetItem;
    procedure AddItem(const AKey,AValue:string);
    function Key:string;
    function Value:string;
  end;

implementation

{$R *.fmx}

{ TViewComponenteComboBox }

procedure TViewComponenteComboBox.AddItem(const AKey, AValue: string);
begin

end;

procedure TViewComponenteComboBox.AfterConstruction;
begin
  inherited;
  FItem := TDictionary<string,string>.Create;
end;

procedure TViewComponenteComboBox.BeforeDestruction;
begin
  inherited;
  FItem.Free;
end;

function TViewComponenteComboBox.GetItem: TDictionary<string, string>;
begin
  var LItem := FItem;
  Result  := LItem;
end;

procedure TViewComponenteComboBox.Image1Click(Sender: TObject);
begin
  if Assigned(FListItem) then
  begin
    FListItem.SetList(FItem);
    FListItem.OpenList;
  end;
end;

function TViewComponenteComboBox.Key: string;
begin
  Result := FKey;
end;

procedure TViewComponenteComboBox.OnChangeListItem(Sender: TObject);
begin
  FListItem.CloseList;
  lblDescricao.Text := TViewComponentesComboBoxItems(Sender).Descricao;
  FValue := TViewComponentesComboBoxItems(Sender).Descricao;
  FKey := TViewComponentesComboBoxItems(Sender).Key;
end;

procedure TViewComponenteComboBox.SetListItem(
  const Value: TViewComponentesComboBoxListItems);
begin
  FListItem := Value;
  FListItem.OnChange := OnChangeListItem;
end;

function TViewComponenteComboBox.Value: string;
begin
  Result := FValue;
end;

end.
