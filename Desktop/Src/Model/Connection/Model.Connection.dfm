object ModelConnection: TModelConnection
  OnCreate = DataModuleCreate
  Height = 480
  Width = 640
  PixelsPerInch = 96
  object FDConnection: TFDConnection
    Params.Strings = (
      'Database=CONTROL_PLUS'
      'User_Name=postgres'
      'Password=masterkey'
      'Server=127.0.0.1'
      'DriverID=PG')
    LoginPrompt = False
    Left = 280
    Top = 232
  end
  object FDPhysPgDriverLink: TFDPhysPgDriverLink
    VendorHome = 'C:\Projetos\ControlPlus\Desktop\Src\Bin\Exe'
    Left = 392
    Top = 160
  end
end
