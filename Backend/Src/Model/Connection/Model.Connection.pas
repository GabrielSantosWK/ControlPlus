unit Model.Connection;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.PG,
  FireDAC.Phys.PGDef, FireDAC.ConsoleUI.Wait, Data.DB, FireDAC.Comp.Client;

type
  TModelConnection = class(TDataModule)
    FDPhysPgDriverLink: TFDPhysPgDriverLink;
    FDManager: TFDManager;
    FDConnection: TFDConnection;
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
  private
    FParams:TStringList;
  public
    { Public declarations }
  end;

implementation

{%CLASSGROUP 'System.Classes.TPersistent'}

{$R *.dfm}

procedure TModelConnection.DataModuleCreate(Sender: TObject);
begin
  FDPhysPgDriverLink.VendorHome := '.\';
  FParams := TStringList.Create;
  FParams.AddPair('DriverID', 'PG');
  FParams.AddPair('Server', '127.0.0.1');
  FParams.AddPair('Database', 'CONTROL_PLUS');
  FParams.AddPair('User_Name', 'postgres');
  FParams.AddPair('Password', 'masterkey');
  FParams.AddPair('Port', '5432');
  FParams.AddPair('CharacterSet','UTF-8');
  FParams.AddPair('Pooled', 'True');
  FDManager.AddConnectionDef('Control_plus','PG',FParams);
  FDManager.SilentMode := True;

  FDConnection.ConnectionDefName := 'Control_plus';
  FDConnection.Connected := True;
end;

procedure TModelConnection.DataModuleDestroy(Sender: TObject);
begin
  FParams.Free;
end;

end.
