object ModelConnection: TModelConnection
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  Height = 480
  Width = 640
  object FDPhysPgDriverLink: TFDPhysPgDriverLink
    VendorHome = 'C:\Projetos\ControlPlusBackend\Src\Bin\Exe'
    Left = 392
    Top = 160
  end
  object FDManager: TFDManager
    FormatOptions.AssignedValues = [fvMapRules]
    FormatOptions.OwnMapRules = True
    FormatOptions.MapRules = <>
    Active = True
    Left = 224
    Top = 320
  end
  object FDConnection: TFDConnection
    Left = 168
    Top = 224
  end
end
