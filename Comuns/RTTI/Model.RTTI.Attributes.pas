unit Model.RTTI.Attributes;

interface

uses System.RTTI;

type
  EnumField = (tpFieldInteger, tpFieldString, tpFieldDate, tpFieldDateTime,
    tpFieldTime,
    tpFieldCurrency, tpFieldList, tpFieldObject, tpFieldTag);

type
  ListCrud = class(TCustomAttribute)
  private
    FName: string;
    FPorcentWidth: Integer;
    procedure SetName(const Value: string);
    procedure SetPorcentWidth(const Value: Integer);
  public
    constructor Create(AName: String; APorcentWidth: Integer);
    property Name: string read FName write SetName;
    property PorcentWidth: Integer read FPorcentWidth write SetPorcentWidth;
  end;

type
  Required = class(TCustomAttribute)
    constructor Create();

  end;

type
  TypeField = class(TCustomAttribute)
  private
    FTypeField: EnumField;
    procedure SetTypeField(const Value: EnumField);
  public
    constructor Create(ATypeField: EnumField);
    property TypeField: EnumField read FTypeField write SetTypeField;
  end;

type
  Table = class(TCustomAttribute)
  private
    FTable: string;
    procedure SetTable(const Value: string);
  public
    constructor Create(ATable: string);
    property Table: string read FTable write SetTable;
  end;

type
  PK = class(TCustomAttribute)
  private
  public
    constructor Create();
  end;

  FK = class(TCustomAttribute)
  private
    FTableName:string;
    FField:string;
  public
    constructor Create(const ATableName,AField:string);
    property TableName:String read FTableName;
    property Field:string read FField;
  end;

type
  Unique = class(TCustomAttribute)
  private
  public
    constructor Create();
  end;

type
  FieldDB = class(TCustomAttribute)
  private
    FFieldDB: string;
    procedure SetFieldDB(const Value: string);
  public
    constructor Create(AFieldDB: String); overload;
    constructor Create(); overload;
    property FieldDB: string read FFieldDB write SetFieldDB;
  end;

type
  FieldName = class(TCustomAttribute)
  private
    FFieldName: string;
    procedure SetFieldName(const Value: string);
  public
    constructor Create(AFieldName: String);
    property FieldName: string read FFieldName write SetFieldName;
  end;

type
  FieldJSON = class(TCustomAttribute)
  private
    FFieldJSON: string;
    procedure SetNameField(const Value: string);
  public
    constructor Create(AFieldJSON: string); overload;
    constructor Create(); overload;
    property FieldJSON: string read FFieldJSON write SetNameField;
  end;

  { Validações }
type
  NotNull = class(TCustomAttribute)
  private
    FMessege: string;
    procedure SetMessege(const Value: string);
  public
    constructor Create(AMessege: string);
    property Messege: string read FMessege write SetMessege;
  end;

type
  MinLength = class(TCustomAttribute)
  private
    FMinLength: Integer;
    FMessege: string;
    procedure SetMinLength(const Value: Integer);
    procedure SetMessege(const Value: string);
  public
    property MinLength: Integer read FMinLength write SetMinLength;
    property Messege: string read FMessege write SetMessege;
    constructor Create(AValue: Integer; AMessege: string);
  end;

type
  MaxLength = class(TCustomAttribute)
  private
    FMaxLength: Integer;
    FMessege: string;
    procedure SetMaxLength(const Value: Integer);
    procedure SetMessege(const Value: string);
  public
    constructor Create(AValue: Integer; AMessege: string);
    property MaxLength: Integer read FMaxLength write SetMaxLength;
    property Messege: string read FMessege write SetMessege;
  end;

type
  MinValue = class(TCustomAttribute)
  private
    FMinValue: Double;
    procedure SetMinValue(const Value: Double);
  public
    constructor Create(AValue: Integer);
    property MinValue: Double read FMinValue write SetMinValue;
  end;

type
  MaxValue = class(TCustomAttribute)
  private
    FMaxValue: Double;
    procedure SetMaxValue(const Value: Double);
  public
    constructor Create(AValue: Integer);
    property MaxValue: Double read FMaxValue write SetMaxValue;
  end;

implementation

{ NotNull }

constructor NotNull.Create(AMessege: string);
begin
  Messege := AMessege;
end;

procedure NotNull.SetMessege(const Value: string);
begin
  FMessege := Value;
end;

{ FieldJSON }

constructor FieldJSON.Create(AFieldJSON: string);
begin
  FieldJSON := AFieldJSON;
end;

constructor FieldJSON.Create;
begin

end;

procedure FieldJSON.SetNameField(const Value: string);
begin
  FFieldJSON := Value;
end;

{ FieldName }

constructor FieldName.Create(AFieldName: String);
begin
  FieldName := AFieldName;
end;

procedure FieldName.SetFieldName(const Value: string);
begin
  FFieldName := Value;
end;

{ FieldDB }

constructor FieldDB.Create(AFieldDB: String);
begin
  FieldDB := AFieldDB
end;

constructor FieldDB.Create;
begin

end;

procedure FieldDB.SetFieldDB(const Value: string);
begin
  FFieldDB := Value;
end;

{ TypeField }

constructor TypeField.Create(ATypeField: EnumField);
begin
  TypeField := ATypeField;
end;

procedure TypeField.SetTypeField(const Value: EnumField);
begin
  FTypeField := Value;
end;

{ Table }

constructor Table.Create(ATable: string);
begin
  FTable := ATable;
end;

procedure Table.SetTable(const Value: string);
begin
  FTable := Value;
end;

{ PK }

constructor PK.Create;
begin

end;

{ Unique }

constructor Unique.Create;
begin

end;

{ ListCrud }

constructor ListCrud.Create(AName: String; APorcentWidth: Integer);
begin
  Name := AName;
  PorcentWidth := APorcentWidth;
end;

procedure ListCrud.SetName(const Value: string);
begin
  FName := Value;
end;

procedure ListCrud.SetPorcentWidth(const Value: Integer);
begin
  FPorcentWidth := Value;
end;

{ MinLength }

constructor MinLength.Create(AValue: Integer; AMessege: string);
begin
  MinLength := AValue;
  Self.Messege := AMessege;
end;

procedure MinLength.SetMessege(const Value: string);
begin
  FMessege := Value;
end;

procedure MinLength.SetMinLength(const Value: Integer);
begin
  FMinLength := Value;
end;

{ MaxLength }

constructor MaxLength.Create(AValue: Integer; AMessege: string);
begin
  MaxLength := AValue;
  Messege := AMessege;
end;

procedure MaxLength.SetMaxLength(const Value: Integer);
begin
  FMaxLength := Value;
end;

procedure MaxLength.SetMessege(const Value: string);
begin
  FMessege := Value;
end;

{ MinValue }

constructor MinValue.Create(AValue: Integer);
begin
  MinValue := AValue;
end;

procedure MinValue.SetMinValue(const Value: Double);
begin
  FMinValue := Value;
end;

{ MaxValue }

constructor MaxValue.Create(AValue: Integer);
begin
  MaxValue := AValue;
end;

procedure MaxValue.SetMaxValue(const Value: Double);
begin
  FMaxValue := Value;
end;

{ Required }

constructor Required.Create;
begin

end;

{ FK }

constructor FK.Create(const ATableName,AField:string);
begin
  FTableName := ATableName;
  FField := AField;
end;

end.
