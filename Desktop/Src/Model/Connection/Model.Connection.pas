unit Model.Connection;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.FMXUI.Wait,
  Data.DB, FireDAC.Comp.Client, FireDAC.Phys.PG, FireDAC.Phys.PGDef;

type
  TModelConnection = class(TDataModule)
    FDConnection: TFDConnection;
    FDPhysPgDriverLink: TFDPhysPgDriverLink;
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ModelConnection: TModelConnection;

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}

{$R *.dfm}

procedure TModelConnection.DataModuleCreate(Sender: TObject);
begin
  FDPhysPgDriverLink.VendorHome := '.\';
end;

end.
