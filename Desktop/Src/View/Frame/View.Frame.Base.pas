unit View.Frame.Base;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Objects, View.Componentes.ComboBox.List.Items, View.Componentes.ComboBox;

type
  TViewFrameBase = class(TFrame)
    recFrameBase: TRectangle;
  private
    FComboBoxListItems:TViewComponentesComboBoxListItems;
  public
    procedure AfterConstruction; override;
    procedure SetComboBoxListItem(const AComboBoxListItems:TViewComponentesComboBoxListItems);
  end;

implementation

{$R *.fmx}

{ TViewFrameBase }

procedure TViewFrameBase.AfterConstruction;
begin
  inherited;
  recFrameBase.SendToBack;
end;

procedure TViewFrameBase.SetComboBoxListItem(
  const AComboBoxListItems: TViewComponentesComboBoxListItems);
begin
  FComboBoxListItems := AComboBoxListItems;
  TThread.CreateAnonymousThread(
  procedure
  begin
    if Assigned(FComboBoxListItems) then
    begin
      for var I := 0 to Pred(ComponentCount) do
      begin
        if Components[i] is TViewComponenteComboBox then
        begin
          TThread.Synchronize(nil,
          procedure
          begin
            TViewComponenteComboBox(Components[i]).ListItem := FComboBoxListItems;
          end);
        end;
      end;
    end;
  end).Start;
end;

end.
