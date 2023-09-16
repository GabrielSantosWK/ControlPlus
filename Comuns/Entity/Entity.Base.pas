unit Entity.Base;

interface
  uses Model.RTTI.Bind,System.JSON,Data.DB;
  type
  TEntityBase = class
    private
    public
    procedure DataSetToClass(const ADataSet:TDataSet);
    procedure JSONToClass(AJSONObject:TJSONObject;InDestructionJSON:Boolean = True);overload;
    procedure JSONToClass(AJSONObject:String);overload;
    function ClassToJSONString:String;
    function ClassToJSON:TJSONObject;
  end;
implementation

{ TEntityBase }

function TEntityBase.ClassToJSON: TJSONObject;
begin
  Result := TModelRTTIBind.GetInstance.ClassToJSON(Self);
end;

function TEntityBase.ClassToJSONString: String;
begin
  Result := TModelRTTIBind.GetInstance.ClassToJSONString(Self);
end;

procedure TEntityBase.DataSetToClass(const ADataSet: TDataSet);
begin
  TModelRTTIBind.GetInstance.DataSetToClass(ADataSet,Self);
end;

procedure TEntityBase.JSONToClass(AJSONObject: String);
begin
  TModelRTTIBind.GetInstance.JSONToClass(Self,AJSONObject);
end;

procedure TEntityBase.JSONToClass(AJSONObject: TJSONObject;InDestructionJSON:Boolean);
begin
  TModelRTTIBind.GetInstance.JSONToClass(Self,AJSONObject,InDestructionJSON);
end;

end.
