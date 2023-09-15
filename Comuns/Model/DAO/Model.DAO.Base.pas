unit Model.DAO.Base;

interface

uses
  Model.RTTI.Bind,
  Model.Connection,
  System.JSON,
  DataSet.Serialize,
  System.SysUtils,
  System.Generics.Collections,
  FireDAC.Stan.Intf,
  FireDAC.Stan.Option,
  FireDAC.Stan.Param,
  FireDAC.Stan.Error,
  FireDAC.DatS,
  FireDAC.Phys.Intf,
  FireDAC.DApt.Intf,
  FireDAC.Stan.Async,
  FireDAC.DApt, Data.DB,
  FireDAC.Comp.DataSet,
  FireDAC.Comp.Client;

type
  TModelDAOBase<T: Class> = class
  private
    FRecordCountItemsQuery:Integer;
    FEntity: T;
    FList: TList<T>;
    FModelConnection:TModelConnection;
    FLastID:string;
    procedure SetEntity(const Value: T);
  public
  var
    FQuery: TFDQuery;
    constructor Create(); virtual;
    destructor Destroy(); override;
    property Entity: T read FEntity write SetEntity;
    function Insert():Boolean; virtual;
    function Update():Boolean;
    procedure Delete();overload;
    procedure Delete(AFilter:string);overload;
    function Get(): TModelDAOBase<T>;overload;
    function Get(AFilter:string): TModelDAOBase<T>;overload;
    function Get(AFirst,ASkip:Integer;AFilter:string): TModelDAOBase<T>;overload;
    function Get(AFirst,ASkip:Integer): TModelDAOBase<T>;overload;
    function List: TObjectList<T>;
    function ToJsonData:TJSONObject;
    function ListDataSet:TDataSet;
    function RecordCountItemsQuery:Integer;
  protected
    function GetID: String;
  protected

  end;

implementation

{ TModelDAOBase }

constructor TModelDAOBase<T>.Create;
begin
  FModelConnection := TModelConnection.Create(nil);
  FQuery := TFDQuery.Create(nil);
  FQuery.Connection := FModelConnection.FDConnection;
  FList := TObjectList<T>.Create;
end;

procedure TModelDAOBase<T>.Delete;
begin
  FQuery.SQL.Clear;
  FQuery.SQL.Add(TModelRTTIBind.GetInstance.ClassToDeleteSQL(Entity));
  FQuery.ExecSQL;
end;

procedure TModelDAOBase<T>.Delete(AFilter: string);
begin
  FQuery.SQL.Clear;
  FQuery.SQL.Add(TModelRTTIBind.GetInstance.ClassToDeleteSQL(Entity,AFilter));
  FQuery.ExecSQL;
end;

destructor TModelDAOBase<T>.Destroy;
begin
  FQuery.Free;
  FList.Free;
  FModelConnection.Free;
  inherited;
end;

function TModelDAOBase<T>.Get: TModelDAOBase<T>;
begin
  Result := Self;
  FQuery.SQL.Clear;
  FQuery.SQL.Add(TModelRTTIBind.GetInstance.ClassToSelectAllSQL(Entity));
  FQuery.Open();
end;

function TModelDAOBase<T>.List: TObjectList<T>;
var
  LClass: TModelDAOBase<T>;
begin
  LClass := TModelDAOBase<T>.Create;
end;

function TModelDAOBase<T>.ListDataSet: TDataSet;
begin
  Result := FQuery;
end;

function TModelDAOBase<T>.RecordCountItemsQuery: Integer;
begin
  Result := FRecordCountItemsQuery;
end;

function TModelDAOBase<T>.Get(AFirst, ASkip: Integer): TModelDAOBase<T>;
begin
  Result := Self;
  FQuery.SQL.Clear;
  FQuery.SQL.Add(TModelRTTIBind.GetInstance.ClassToSelectALLSQLCount(Entity));
  FQuery.Open();
  FRecordCountItemsQuery := FQuery.FieldByName('Count').AsInteger;
  FQuery.SQL.Clear;
  FQuery.SQL.Add(TModelRTTIBind.GetInstance.ClassToSelectPaginationSQL(Entity,AFirst,ASkip));
  FQuery.Open();
end;

function TModelDAOBase<T>.Get(AFilter: string): TModelDAOBase<T>;
begin
  Result := Self;
  FQuery.SQL.Clear;
  FQuery.SQL.Add(TModelRTTIBind.GetInstance.ClassToSelectAllSQL(Entity,AFilter));
  FQuery.Open();
end;

function TModelDAOBase<T>.Get(AFirst,ASkip:Integer;AFilter: string): TModelDAOBase<T>;
begin
  Result := Self;
  FQuery.SQL.Clear;
  FQuery.SQL.Add(TModelRTTIBind.GetInstance.ClassToSelectALLSQLCount(Entity,AFilter));
  FQuery.Open();
  FRecordCountItemsQuery := FQuery.FieldByName('Count').AsInteger;

  FQuery.SQL.Clear;
  FQuery.SQL.Add(TModelRTTIBind.GetInstance.ClassToSelectPaginationSQL(Entity,AFirst,ASkip,AFilter));
  FQuery.Open();
end;

function TModelDAOBase<T>.GetID: String;
begin
 FLastID := TGUID.NewGuid.ToString.Replace('{','',[rfReplaceAll]).Replace('}','',[rfReplaceAll]);
 Result := FLastID;
end;

function TModelDAOBase<T>.Insert():Boolean;
var
  LValueSQL:string;
begin
  LValueSQL := TModelRTTIBind.GetInstance.ClassToPostSQL(Entity);
  Result := not LValueSQL.IsEmpty;
  if LValueSQL.IsEmpty then Exit;

  FQuery.SQL.Clear;
  FQuery.SQL.Add(LValueSQL);
  FQuery.ExecSQL;
end;

procedure TModelDAOBase<T>.SetEntity(const Value: T);
begin
  FEntity := Value;
end;

function TModelDAOBase<T>.ToJsonData: TJSONObject;
begin
  Result := TJSONObject.Create;
  Result.AddPair('data',FQuery.ToJSONArray());
end;

function TModelDAOBase<T>.Update:Boolean;
var
  LValueSQL:string;
begin
  LValueSQL := TModelRTTIBind.GetInstance.ClassToPutSQL(Entity);
  Result := not LValueSQL.IsEmpty;
  if LValueSQL.IsEmpty then Exit;

  FQuery.SQL.Clear;
  FQuery.SQL.Add(LValueSQL);
  FQuery.ExecSQL;
end;

end.
