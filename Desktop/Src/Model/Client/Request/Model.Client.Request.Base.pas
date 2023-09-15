unit Model.Client.Request.Base;

interface

uses Model.Client,
  System.JSON,
  System.Classes,
  Entity.Base,
  System.SyncObjs,
  System.SysUtils, System.Generics.Collections;
  type
  TModelClientRequestBase<T:Class> = class
    protected
    FClient:TModelClient;
    FEntity: T;
    FCritical:TCriticalSection;
    procedure SetEntity(const Value: T);
    public
    constructor Create();virtual;
    destructor Destroy();override;
    function AddQueryParams(AField: string; AValue: string): TModelClientRequestBase<T>;
    function AddHeaderParams(AField: string; AValue: string): TModelClientRequestBase<T>; overload;
    function ClearHeaderParams: TModelClientRequestBase<T>;
    function ClearQueryParams: TModelClientRequestBase<T>;
    function Get(AResource:string):string;
    procedure Post(AResource:string;AProc:TProc<String,Integer,string>);overload;virtual;
    procedure Put(AResource:string;AProc:TProc<String,Integer,string>);overload;
    procedure Delete(AResource:string;AProc:TProc<TJSONObject>);overload;
    procedure Delete(AResource:string;AJSONResponse:TJSONObject;AProc:TProc<Integer,String>);overload;
    property Entity:T read FEntity write SetEntity;
  end;
implementation

{ TModelClientRequestBase }

function TModelClientRequestBase<T>.AddHeaderParams(AField,AValue: string): TModelClientRequestBase<T>;
begin
  Result := Self;
  FClient.AddHeaderParams(AField,AValue);
end;

function TModelClientRequestBase<T>.AddQueryParams(AField, AValue: string): TModelClientRequestBase<T>;
begin
  Result := Self;
  FClient.AddQueryParams(AField,AValue);
end;

function TModelClientRequestBase<T>.ClearHeaderParams: TModelClientRequestBase<T>;
begin
  Result := Self;
  FClient.ClearHeaderParams;
end;

function TModelClientRequestBase<T>.ClearQueryParams: TModelClientRequestBase<T>;
begin
  Result := Self;
  FClient.ClearQueryParams;
end;

constructor TModelClientRequestBase<T>.Create;
begin
  FClient := TModelClient.Create;
  FCritical := TCriticalSection.Create;
end;

procedure TModelClientRequestBase<T>.Delete(AResource: string; AJSONResponse: TJSONObject; AProc: TProc<Integer,string>);
var
  LJonObject:TJSONObject;
begin
  LJonObject := FClient.Resource(AResource).Delete(AJSONResponse.ToJson);
  try
    if Assigned(AProc) then
      AProc(FClient.StatusCode,LJonObject.ToJSON());
  finally
    LJonObject.Free;
  end;
end;

procedure TModelClientRequestBase<T>.Delete(AResource: string; AProc: TProc<TJSONObject>);
begin

end;

destructor TModelClientRequestBase<T>.Destroy;
begin
  FClient.Free;
  FCritical.Free;
  inherited;
end;

function TModelClientRequestBase<T>.Get(AResource: string):string;
var
  LJsonValue:TJSONValue;
begin
  LJsonValue := FClient.Resource(AResource).Get;
  try
    Result := LJsonValue.ToString;
  finally
    LJsonValue.Free;
  end;
end;

procedure TModelClientRequestBase<T>.Put(AResource: string;AProc: TProc<String, Integer,string>);
var
  LSJonObject:TJSONObject;
begin
  LSJonObject := FClient.Resource(AResource).Put(TEntityBase(Entity).ClassToJSONString);
  try
    if Assigned(AProc) then
      AProc(LSJonObject.ToJSON(),FClient.StatusCode,FClient.Messege);
  finally
    LSJonObject.Free;
  end;
end;

procedure TModelClientRequestBase<T>.Post(AResource: string;AProc:TProc<String,Integer,string>);
var
  LJonObject:TJSONValue;
begin
  LJonObject := TEntityBase(Entity).ClassToJSON;
  LJonObject := FClient.Resource(AResource).Post(LJonObject.ToJson);
  try
    if Assigned(AProc) then
      AProc(LJonObject.ToJSON(),FClient.StatusCode,FClient.Messege);
  finally
    LJonObject.Free;
  end;
end;

procedure TModelClientRequestBase<T>.SetEntity(const Value: T);
begin
  FEntity := Value;
end;

end.
