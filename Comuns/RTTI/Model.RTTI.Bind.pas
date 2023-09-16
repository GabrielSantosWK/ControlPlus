unit Model.RTTI.Bind;

interface
  uses Model.RTTI.Attributes,System.SysUtils,System.Rtti,REST.Json,
  System.Generics.Collections,System.Json,System.Classes, Data.DB;

  type TJSONData = record
    Name:string;
    Value:string;
    IsUnique:Boolean;
    IsPK:Boolean;
    IsFK:Boolean;
    TypeField:EnumField;
    ValueIsEmpty:Boolean;
  end;

  type TFieldValue = record
    Name:string;
    Value:Variant;
    TypeField:EnumField;
    IsUnique:Boolean;
    IsPK:Boolean;
  end;

  type TModelRTTIBind = class
  private
    class var FInstance:TModelRTTIBind;
    function ObjectToList(AValue:TValue):TJSONArray;
    function ObjectToListString(AValue:TValue):String;
    function ObjectToObjectString(AValue:TValue):String;
    function ObjectToArrayStrring(AValue:TValue):String;
    function ClassToListJSONData(AClass:TObject):TList<TJSONData>;
    function ClassToFieldValue(AClass:TObject;AValidateRequired:Boolean = True):TList<TFieldValue>;
    function ValidateFildValue(AClass:TObject):Boolean;
    function ValidateJSON(AClass:TObject):Boolean;
    function PrepareValues(AFieldValue:TFieldValue):string;
    function GetTable(AClass:TObject):String;
    function GetPK(AClass:TObject):String;
    function DateBRToDateEng(const ADate:TDateTime):string;
    function GetWhereAndFK(AClass:TObject):string;
  public
    class function GetInstance:TModelRTTIBind;
    function ClassToJSON(AClass:TObject):TJSONObject;overload;
    function ClassToJSONString(AClass:TObject):String;overload;
    function JSONToClass(AClass:TObject;AJSON: TJSONObject;InDestructionJSON:Boolean = True): TClass;overload;
    function JSONToClass(AClass:TObject;AJSON: String): TClass;overload;
    {ListBase}
    function ClassToListFields(AClass:TClass):TDictionary<String,Integer>;
    {SQL}
    procedure DataSetToClass(ADataSet:TDataSet; AClass:TObject);
    function ClassToSelectAllSQL(AClass:TObject):String;overload;
    function ClassToSelectAllSQL(AClass:TObject;AFilter:string):String;overload;
    function ClassToSelectPaginationSQL(AClass: TObject;AFirst,ASkip:Integer): String;overload;
    function ClassToSelectPaginationSQL(AClass: TObject;AFirst,ASkip:Integer;AFilter:String): String;overload;
    function ClassToSelectALLSQLCount(AClass: TObject): String;overload;
    function ClassToSelectALLSQLCount(AClass: TObject;AFilter:string): String;overload;
    function ClassToPostSQL(AClass:TObject):String;
    function ClassToPutSQL(AClass:TObject):String;
    function ClassToDeleteSQL(AClass:TObject):String;overload;
    function ClassToDeleteSQL(AClass:TObject;AFilter:string):String;overload;
    function GetSelectMax(AClass:TObject):String;

  end;
implementation

{ TModelRTTIBind }

function TModelRTTIBind.ClassToListJSONData(AClass: TObject): TList<TJSONData>;
var
  LContext:TRttiContext;
  LType:TRttiType;
  LAttributes:TCustomAttribute;
  LProperties:TRttiProperty;
  LJsonData:TJSONData;
  LInJsonData:Boolean;
  FIsRequirid:Boolean;
  LCurrentValue:string;
begin
  Result := TList<TJSONData>.Create;
  if not (AClass is TClass) then Exit;
  LContext := TRttiContext.Create;
  try
    LType := LContext.GetType(AClass.ClassType);
    for LProperties in LType.GetProperties do
    begin
      LInJsonData := False;
      FIsRequirid := False;
      LJsonData.ValueIsEmpty := False;
      LJsonData.IsUnique := False;
      LJsonData.IsPK := False;
      LJsonData.IsFK := False;
      LJsonData.Name := LProperties.Name;
      for LAttributes in LProperties.GetAttributes do
      begin
        if LAttributes is FieldJSON then
        begin
          if not FieldJSON(LAttributes).FieldJSON.Trim.IsEmpty then
            LJsonData.Name := FieldJSON(LAttributes).FieldJSON;
         LInJsonData := True;
        end;

        if LAttributes is Required then
          FIsRequirid := True;

        if LAttributes is PK then
          LJsonData.IsPK := True;

        if LAttributes is FK then
          LJsonData.IsFK := True;
      end;

      if not LInJsonData then
        Continue;



      for LAttributes in LProperties.GetAttributes do
      begin
        if LAttributes is TypeField then
        begin
          case TypeField(LAttributes).TypeField of
            tpFieldInteger:
            begin
              LJsonData.ValueIsEmpty := True;
              if IntToStr(LProperties.GetValue(AClass).AsInteger) <> '0'  then
                LJsonData.ValueIsEmpty := False;
              LJsonData.Value := IntToStr(LProperties.GetValue(AClass).AsInteger);
            end;
            tpFieldString:LJsonData.Value := LProperties.GetValue(AClass).AsString;
            tpFieldDate:LJsonData.Value := FormatDateTime('YYYY/MM/DD',LProperties.GetValue(AClass).AsType<TDate>).Replace('/','-',[rfReplaceAll]);
            tpFieldDateTime:LJsonData.Value := FormatDateTime('YYYY/MM/DD',LProperties.GetValue(AClass).AsType<TDateTime>).Replace('/','-',[rfReplaceAll]);
            tpFieldTime:LJsonData.Value := FormatDateTime('HH:MM:SS',LProperties.GetValue(AClass).AsType<TTime>);
            tpFieldCurrency:
            begin
              LJsonData.ValueIsEmpty := True;
              LCurrentValue := LProperties.GetValue(AClass).AsVariant;
              if (LProperties.GetValue(AClass).AsCurrency > 0) then
                LJsonData.ValueIsEmpty := False;
              LCurrentValue := CurrToStr(LProperties.GetValue(AClass).AsCurrency);
              LCurrentValue := LCurrentValue.Replace('.','',[rfReplaceAll]).Replace(',','.',[rfReplaceAll]);
              LJsonData.Value := LCurrentValue;
            end;
            tpFieldList: LJsonData.Value := ObjectToListString(LProperties.GetValue(AClass));
            tpFieldObject:LJsonData.Value := ObjectToObjectString(LProperties.GetValue(AClass));
            tpFieldTag:LJsonData.Value := ObjectToArrayStrring(LProperties.GetValue(AClass));
            else
            LJsonData.Value := LProperties.GetValue(AClass).AsString;
          end;
          Break;
        end;
      end;

      if (FIsRequirid = False) and (LJsonData.ValueIsEmpty) Then
        Continue;
      Result.Add(LJsonData);
    end;
  finally
    LContext.Free;
  end;
end;

class function TModelRTTIBind.GetInstance: TModelRTTIBind;
begin
  if not Assigned(FInstance) then
    FInstance := TModelRTTIBind.Create;
  Result := FInstance;
end;

function TModelRTTIBind.GetPK(AClass: TObject): String;
var
  LContext:TRttiContext;
  LType:TRttiType;
  LAttributes:TCustomAttribute;
  LProperties:TRttiProperty;
  LFileValue:TFieldValue;
  LIsFieldDB: Boolean;
begin
  if not (AClass is TClass) then Exit;
  LContext := TRttiContext.Create;
  try
    LType := LContext.GetType(AClass.ClassType);
    for LProperties in LType.GetProperties do
    begin

      LFileValue.IsPK := False;
      LFileValue.IsUnique := False;

      LIsFieldDB := False;
      LFileValue.Name := LProperties.Name;
      for LAttributes in LProperties.GetAttributes do
      begin
        if LAttributes is FieldDB then
        begin
          LIsFieldDB := True;
          if not FieldDB(LAttributes).FieldDB.Trim.IsEmpty then
            LFileValue.Name := FieldDB(LAttributes).FieldDB;
          Break;
        end;
      end;
      if not LIsFieldDB then
        Continue;

      for LAttributes in LProperties.GetAttributes do
      begin
        if LAttributes is PK then
        begin
          LFileValue.IsPK := True;
          Break;
        end;
      end;
      if LFileValue.IsPK then
      begin
        Result := LFileValue.Name;
        Break;
      end;
    end;
  finally
    LContext.Free;
  end;
end;

function TModelRTTIBind.GetSelectMax(AClass: TObject): String;
const SQL = 'SELECT MAX(TB.%S) AS ID FROM %S TB';
var
  LListFieldValue:TList<TFieldValue>;
  I: Integer;
  LTable:string;
  LField:string;
  LCount:Integer;
begin
  LCount := 0;
  LField := EmptyStr;
  LTable := GetTable(AClass);
  Result := EmptyStr;
  LListFieldValue := ClassToFieldValue(AClass,False);
  try
    for I := 0 to Pred(LListFieldValue.Count) do
    begin
      if LListFieldValue[i].TypeField = tpFieldList then
        Continue;
      if (LListFieldValue[i].IsUnique) then
        Continue;

      if (LListFieldValue[i].IsPK) then
      begin
        LField := LListFieldValue[i].Name;
        Inc(LCount);
        if LCount > 1 then
          raise Exception.Create('Duas chaves PK não foi implementado no SELECT MAX');
        Continue;
      end;
    end;
    if LListFieldValue.Count > 0 then
      Result := Format(SQL,[LField,LTable]);
  finally
    LListFieldValue.Free;
  end;
end;

function TModelRTTIBind.GetTable(AClass: TObject): String;
var
  LContext:TRttiContext;
  LType:TRttiType;
  LAttributes:TCustomAttribute;
begin
  if not (AClass is TClass) then
    raise Exception.Create('Object is not TClass');
  if not Assigned(AClass) then
    raise Exception.Create('Object is not Assigned');

  LContext := TRttiContext.Create;
  try
    LType := LContext.GetType(AClass.ClassType);
    for LAttributes in LType.GetAttributes do
    begin
      if LAttributes is Table then
      begin
        Result := Table(LAttributes).Table;
        Break;
      end;
    end;
  finally
    LContext.Free;
  end;
  if Result.IsEmpty then
    raise Exception.Create('Table '+LType.Name+' not found');
end;

function TModelRTTIBind.GetWhereAndFK(AClass: TObject): string;
var
  LJsonData:TJSONData;
begin
  Result := EmptyStr;
  if not (AClass is TClass) then
    raise Exception.Create('Object is not TClass');
  if not Assigned(AClass) then
    raise Exception.Create('Object is not Assigned');
  var LContext:TRttiContext := TRttiContext.Create;
  try
    var LTable:string;
    var LField:string;

    var LType:TRttiType := LContext.GetType(AClass.ClassType);
    for var LProperties in LType.GetProperties do
    begin

      var LIsFieldFK:Boolean := False;
      var NamePkPai:string;
      var ValuePkPai:string;
      for var LAttributes in LProperties.GetAttributes do
      begin
        if LAttributes is FK then
        begin
          LTable := FK(LAttributes).TableName;
          LField := FK(LAttributes).Field;
          LIsFieldFK := True;
          Break;
        end;

        if LAttributes is PK then
        begin
          NamePkPai := LProperties.Name;
          ValuePkPai := LProperties.GetValue(AClass).AsString
        end;


      end;

      if not LIsFieldFK then
        Continue;

      for var LAttributes in LProperties.GetAttributes do
      begin
        if LAttributes is TypeField then
        begin
          case TypeField(LAttributes).TypeField of
            tpFieldObject:
            begin
              var LListJsonData := ClassToListJSONData(LProperties.GetValue(AClass).AsObject);
              for var Item:TJSONData in LListJsonData do
              begin
                if Item.IsPK then
                begin
                  Result := 'left join '+LTable+' on cartoes.'+Item.Name+'='+LField;
                end;
              end;
            end;
            tpFieldList: LJsonData.Value := ObjectToListString(LProperties.GetValue(AClass));
            else
            LJsonData.Value := LProperties.GetValue(AClass).AsString;
          end;
          LJsonData.TypeField := TypeField(LAttributes).TypeField;
          Break;
        end;
      end;
    end;
  finally
    LContext.Free;
  end;
end;

function TModelRTTIBind.JSONToClass(AClass: TObject; AJSON: String): TClass;
var
  LJson:TJSONObject;
begin
  LJson := TJSONObject.ParseJSONValue(AJSON) as TJSONObject;
  Result := JSONToClass(AClass,LJson);
end;

function TModelRTTIBind.JSONToClass(AClass:TObject;AJSON: TJSONObject;InDestructionJSON:Boolean = True): TClass;
var
  LContext:TRttiContext;
  LType:TRttiType;
  LAttributes:TCustomAttribute;
  LProperties:TRttiProperty;
  LJsonData:TJSONData;
  LIsFindFieldJSON:Boolean;
  LCountForJson:Integer;
begin
  if not (AClass is TClass) then
    raise Exception.Create('Object is not TClass');
  if not Assigned(AClass) then
    raise Exception.Create('Object is not Assigned');
  if not Assigned(AJSON) then
    raise Exception.Create('AJSON is not Assigned');

  LContext := TRttiContext.Create;
  try
    LType := LContext.GetType(AClass.ClassType);
    for LProperties in LType.GetProperties do
    begin
      LIsFindFieldJSON := False;

      for LAttributes in LProperties.GetAttributes do
      begin
        if LAttributes is FieldJSON then
        begin
          LIsFindFieldJSON := True;
          if not FieldJSON(LAttributes).FieldJSON.Trim.IsEmpty then
            LJsonData.Name := FieldJSON(LAttributes).FieldJSON
          else
            LJsonData.Name := LProperties.Name;
          Break;
        end;
      end;


      if not LIsFindFieldJSON then
        Continue;

      for LAttributes in LProperties.GetAttributes do
      begin
        if LAttributes is TypeField then
        begin
          case TypeField(LAttributes).TypeField of
            tpFieldInteger:LJsonData.Value := IntToStr(LProperties.GetValue(AClass).AsInteger);
            tpFieldString:LJsonData.Value := LProperties.GetValue(AClass).AsString;
            tpFieldDate:LJsonData.Value := DateToStr(LProperties.GetValue(AClass).AsType<TDate>);
            tpFieldDateTime:LJsonData.Value := DateTimeToStr(LProperties.GetValue(AClass).AsType<TDateTime>);
            tpFieldCurrency:LJsonData.Value := CurrToStr(LProperties.GetValue(AClass).AsCurrency);
            tpFieldList: LJsonData.Value := ObjectToListString(LProperties.GetValue(AClass));
            else
            LJsonData.Value := LProperties.GetValue(AClass).AsString;
          end;
          LJsonData.TypeField := TypeField(LAttributes).TypeField;
          Break;
        end;
      end;

      for LCountForJson := 0 to Pred(AJSON.Count) do
      begin
        if AJSON.Pairs[LCountForJson].JsonString.Value.ToLower = LJsonData.Name.ToLower then
        begin
          case LJsonData.TypeField of
            tpFieldInteger:LProperties.SetValue(AClass,StrToInt(AJSON.Pairs[LCountForJson].JsonValue.Value));
            tpFieldString:LProperties.SetValue(AClass,AJSON.Pairs[LCountForJson].JsonValue.Value);
            tpFieldDate:LProperties.SetValue(AClass,StrToDate(AJSON.Pairs[LCountForJson].JsonValue.Value));
            tpFieldDateTime:LProperties.SetValue(AClass,StrToDateTime(AJSON.Pairs[LCountForJson].JsonValue.Value));
            tpFieldCurrency:LProperties.SetValue(AClass, StrToCurr(AJSON.Pairs[LCountForJson].JsonValue.Value));
            tpFieldList:
            begin
            end;
            else
              raise Exception.Create('TpField não informado');
          end;
          Break;
        end;
      end;
    end;
  finally
    if InDestructionJSON then
      AJSON.Free;
    LContext.Free;
  end;
end;

function TModelRTTIBind.ObjectToArrayStrring(AValue: TValue): String;
var
  I: Integer;
  LList:TList<string>;
  LJsonArray:TJSONArray;
begin
  LJsonArray := TJSONArray.Create;
  try
    if AValue.IsObject then
    begin
      LList := TList<string>(AValue.AsObject);
      for I := 0 to Pred(LList.Count) do
      begin
        LJsonArray.Add(LList[i]);
      end;
    end;
    Result := LJsonArray.ToString;
  finally
    LJsonArray.Free;
  end;
end;

function TModelRTTIBind.ObjectToList(AValue: TValue): TJSONArray;
var
  I: Integer;
  LList:TList<TClass>;
  LJSONObject:TJSONObject;
begin
  Result := TJSONArray.Create;
  if AValue.IsObject then
  begin
    LList := TList<TClass>(AValue.AsObject);
    for I := 0 to Pred(LList.Count) do
    begin
      LJSONObject := ClassToJSON(TObject(LList[i]));
      Result.Add(LJSONObject);
    end;
  end;
end;

function TModelRTTIBind.ObjectToListString(AValue: TValue): String;
var
  LJsonArray:TJSONArray;
begin
  LJsonArray := ObjectToList(AValue);
  try
    Result := LJsonArray.ToJSON();
  finally
    LJsonArray.Free;
  end;
end;

function TModelRTTIBind.ObjectToObjectString(AValue: TValue): String;
var
  LJsonObject:TJSONObject;
begin
  if AValue.IsObject then
  begin
    LJsonObject := ClassToJSON(AValue.AsObject);
    try
      Result := LJsonObject.ToJSON();
    finally
      LJsonObject.Free;
    end;
  end;
end;

function TModelRTTIBind.PrepareValues(AFieldValue: TFieldValue): string;
var
  LDate:string;
begin
  case AFieldValue.TypeField of
    tpFieldInteger: Result := AFieldValue.Value;
    tpFieldString: Result := QuotedStr(AFieldValue.Value);
    tpFieldDate:
    begin
      LDate := FormatDateTime('YYYY/MM/DD',StrtoDate(AFieldValue.Value));
      Result := QuotedStr(LDate.Replace('/','-',[rfReplaceAll]));
    end;
    tpFieldDateTime:
    begin
     LDate := DateBRToDateEng(StrToDateTime(AFieldValue.Value));
     Result := QuotedStr(LDate.Replace('/','-',[rfReplaceAll]));
    end;
    tpFieldCurrency: Result := AFieldValue.Value;
    tpFieldList: raise Exception.Create('List not implemented Prepare Vlaue');
  end;
end;

function TModelRTTIBind.ValidateFildValue(AClass: TObject): Boolean;
var
  LContext:TRttiContext;
  LType:TRttiType;
  LAttributes:TCustomAttribute;
  LProperties:TRttiProperty;
  LFileValue:TFieldValue;
  LIsFieldDB: Boolean;
begin
  Result := False;
  if not (AClass is TClass) then Exit;
  Result := True;
  LContext := TRttiContext.Create;
  try
    try
      LType := LContext.GetType(AClass.ClassType);
      for LProperties in LType.GetProperties do
      begin

        LFileValue.IsPK := False;
        LFileValue.IsUnique := False;

        LIsFieldDB := False;
        LFileValue.Name := LProperties.Name;
        for LAttributes in LProperties.GetAttributes do
        begin
          if LAttributes is FieldDB then
          begin
            LIsFieldDB := True;
            if not FieldDB(LAttributes).FieldDB.Trim.IsEmpty then
              LFileValue.Name := FieldDB(LAttributes).FieldDB;
            Break;
          end;
        end;
        if not LIsFieldDB then
          Continue;

        for LAttributes in LProperties.GetAttributes do
        begin
          if LAttributes is TypeField then
          begin
            case TypeField(LAttributes).TypeField of
              tpFieldInteger:LFileValue.Value := IntToStr(LProperties.GetValue(AClass).AsInteger);
              tpFieldString:LFileValue.Value := LProperties.GetValue(AClass).AsString;
              tpFieldDate:LFileValue.Value := DateToStr(LProperties.GetValue(AClass).AsType<TDate>);
              tpFieldDateTime:LFileValue.Value := DateTimeToStr(LProperties.GetValue(AClass).AsType<TDateTime>);
              tpFieldCurrency:LFileValue.Value := CurrToStr(LProperties.GetValue(AClass).AsCurrency);
              tpFieldList:
              begin

              end;
              else
              LFileValue.Value := LProperties.GetValue(AClass).AsString;
            end;
            LFileValue.TypeField := TypeField(LAttributes).TypeField;
          end;

          if LAttributes is PK then
            LFileValue.IsPK := True;
          if LAttributes is Unique then
            LFileValue.IsUnique := True;
        end;

        for LAttributes in LProperties.GetAttributes do
        begin
          if LAttributes is NotNull then
          begin
            case LFileValue.TypeField of
              tpFieldInteger:
              begin
                if LProperties.GetValue(AClass).AsInteger <= 0 then
                  raise Exception.Create(NotNull(LAttributes).Messege);
              end;
              tpFieldString:
              begin
                if LProperties.GetValue(AClass).AsString.IsEmpty then
                  raise Exception.Create(NotNull(LAttributes).Messege);
              end;
              tpFieldDate:
              begin
                if DateToStr(LProperties.GetValue(AClass).AsType<TDate>).Contains('30/12/1899') then
                  raise Exception.Create(NotNull(LAttributes).Messege);
              end;
              tpFieldDateTime:
              begin
                if DateTimeToStr(LProperties.GetValue(AClass).AsType<TDateTime>).Contains('30/12/1899') then
                  raise Exception.Create(NotNull(LAttributes).Messege);
              end;
              tpFieldCurrency:
              begin
                if LProperties.GetValue(AClass).AsCurrency <= 0 then
                  raise Exception.Create(NotNull(LAttributes).Messege);
              end;
              tpFieldList:
              begin

              end;
              else
              begin
                if LProperties.GetValue(AClass).AsString.IsEmpty then
                  raise Exception.Create(NotNull(LAttributes).Messege);
              end;
            end;

          end;

          if LAttributes is MinLength then
          begin
            case LFileValue.TypeField of
              tpFieldInteger:
              begin
                if LProperties.GetValue(AClass).AsInteger <= 0 then
                  raise Exception.Create(NotNull(LAttributes).Messege);
              end;
              tpFieldString:
              begin
                if LProperties.GetValue(AClass).AsString.Length < MinLength(LAttributes).MinLength then
                  raise Exception.Create(MinLength(LAttributes).Messege);
              end;
              tpFieldDate:
              begin
                if DateToStr(LProperties.GetValue(AClass).AsType<TDate>).Contains('30/12/1899') then
                  raise Exception.Create(NotNull(LAttributes).Messege);
              end;
              tpFieldDateTime:
              begin
                if DateTimeToStr(LProperties.GetValue(AClass).AsType<TDateTime>).Contains('30/12/1899') then
                  raise Exception.Create(NotNull(LAttributes).Messege);
              end;
              tpFieldCurrency:
              begin
                if LProperties.GetValue(AClass).AsCurrency <= 0 then
                  raise Exception.Create(NotNull(LAttributes).Messege);
              end;
              tpFieldList:
              begin

              end;
              else
              begin
                if LProperties.GetValue(AClass).AsString.IsEmpty then
                  raise Exception.Create(NotNull(LAttributes).Messege);
              end;
            end;
          end;

          if LAttributes is MaxLength then
          begin
            case LFileValue.TypeField of
              tpFieldInteger:
              begin
                if LProperties.GetValue(AClass).AsInteger <= 0 then
                  raise Exception.Create(NotNull(LAttributes).Messege);
              end;
              tpFieldString:
              begin
                if LProperties.GetValue(AClass).AsString.Length > MaxLength(LAttributes).MaxLength then
                  raise Exception.Create(MinLength(LAttributes).Messege);
              end;
              tpFieldDate:
              begin
                if DateToStr(LProperties.GetValue(AClass).AsType<TDate>).Contains('30/12/1899') then
                  raise Exception.Create(NotNull(LAttributes).Messege);
              end;
              tpFieldDateTime:
              begin
                if DateTimeToStr(LProperties.GetValue(AClass).AsType<TDateTime>).Contains('30/12/1899') then
                  raise Exception.Create(NotNull(LAttributes).Messege);
              end;
              tpFieldCurrency:
              begin
                if LProperties.GetValue(AClass).AsCurrency <= 0 then
                  raise Exception.Create(NotNull(LAttributes).Messege);
              end;
              tpFieldList:
              begin

              end;
              else
              begin
                if LProperties.GetValue(AClass).AsString.IsEmpty then
                  raise Exception.Create(NotNull(LAttributes).Messege);
              end;
            end;
          end;
        end;
      end;
    except on E: Exception do
      begin
        raise Exception.Create(e.Message);
      end;
    end;
  finally
    LContext.Free;
  end;
end;

function TModelRTTIBind.ValidateJSON(AClass: TObject): Boolean;
var
  LContext:TRttiContext;
  LType:TRttiType;
  LAttributes:TCustomAttribute;
  LProperties:TRttiProperty;
  LFileValue:TFieldValue;
  LIsFieldJSON: Boolean;
begin
  Result := False;
  if not (AClass is TClass) then Exit;
  Result := True;
  LContext := TRttiContext.Create;
  try
    try
      LType := LContext.GetType(AClass.ClassType);
      for LProperties in LType.GetProperties do
      begin

        LIsFieldJSON := False;
        LFileValue.Name := LProperties.Name;
        for LAttributes in LProperties.GetAttributes do
        begin
          if LAttributes is FieldJSON then
          begin
            LIsFieldJSON := True;
            if not FieldJSON(LAttributes).FieldJSON.Trim.IsEmpty then
              LFileValue.Name := FieldJSON(LAttributes).FieldJSON;
            Break;
          end;
        end;
        if not LIsFieldJSON then
          Continue;

        for LAttributes in LProperties.GetAttributes do
        begin
          if LAttributes is TypeField then
          begin
            case TypeField(LAttributes).TypeField of
              tpFieldInteger:LFileValue.Value := IntToStr(LProperties.GetValue(AClass).AsInteger);
              tpFieldString:LFileValue.Value := LProperties.GetValue(AClass).AsString;
              tpFieldDate:LFileValue.Value := DateToStr(LProperties.GetValue(AClass).AsType<TDate>);
              tpFieldDateTime:LFileValue.Value := DateTimeToStr(LProperties.GetValue(AClass).AsType<TDateTime>);
              tpFieldTime:LFileValue.Value := TimeToStr(LProperties.GetValue(AClass).AsType<TTime>);
              tpFieldCurrency:LFileValue.Value := CurrToStr(LProperties.GetValue(AClass).AsCurrency);
              tpFieldObject:LFileValue.Value := '{}';
              tpFieldTag:LFileValue.Value := '[]';
              tpFieldList:
              begin

              end;
              else
              LFileValue.Value := LProperties.GetValue(AClass).AsString;
            end;
            LFileValue.TypeField := TypeField(LAttributes).TypeField;
          end;

        end;

        for LAttributes in LProperties.GetAttributes do
        begin
          if LAttributes is NotNull then
          begin
            case LFileValue.TypeField of
              tpFieldInteger:
              begin
                if LProperties.GetValue(AClass).AsInteger <= 0 then
                  raise Exception.Create(NotNull(LAttributes).Messege);
              end;
              tpFieldString:
              begin
                if LProperties.GetValue(AClass).AsString.IsEmpty then
                  raise Exception.Create(NotNull(LAttributes).Messege);
              end;
              tpFieldDate:
              begin
                if DateToStr(LProperties.GetValue(AClass).AsType<TDate>).Contains('30/12/1899') then
                  raise Exception.Create(NotNull(LAttributes).Messege);
              end;
              tpFieldDateTime:
              begin
                if DateTimeToStr(LProperties.GetValue(AClass).AsType<TDateTime>).Contains('30/12/1899') then
                  raise Exception.Create(NotNull(LAttributes).Messege);
              end;
              tpFieldCurrency:
              begin
                if LProperties.GetValue(AClass).AsCurrency <= 0 then
                  raise Exception.Create(NotNull(LAttributes).Messege);
              end;
              tpFieldList:
              begin

              end;
              else
              begin
                if LProperties.GetValue(AClass).AsString.IsEmpty then
                  raise Exception.Create(NotNull(LAttributes).Messege);
              end;
            end;

          end;

          if LAttributes is MinLength then
          begin
            case LFileValue.TypeField of
              tpFieldInteger:
              begin
                if LProperties.GetValue(AClass).AsInteger < MinLength(LAttributes).MinLength then
                  raise Exception.Create(MinLength(LAttributes).Messege);
              end;
              tpFieldString:
              begin
                if LProperties.GetValue(AClass).AsString.Length < MinLength(LAttributes).MinLength then
                  raise Exception.Create(MinLength(LAttributes).Messege);
              end;
              tpFieldDate:
              begin
                if DateToStr(LProperties.GetValue(AClass).AsType<TDate>).Contains('30/12/1899') then
                  raise Exception.Create(NotNull(LAttributes).Messege);
              end;
              tpFieldDateTime:
              begin
                if DateTimeToStr(LProperties.GetValue(AClass).AsType<TDateTime>).Contains('30/12/1899') then
                  raise Exception.Create(NotNull(LAttributes).Messege);
              end;
              tpFieldCurrency:
              begin
                if LProperties.GetValue(AClass).AsCurrency <= 0 then
                  raise Exception.Create(NotNull(LAttributes).Messege);
              end;
              tpFieldList:
              begin

              end;
              else
              begin
                if LProperties.GetValue(AClass).AsString.IsEmpty then
                  raise Exception.Create(NotNull(LAttributes).Messege);
              end;
            end;
          end;

          if LAttributes is MaxLength then
          begin
            case LFileValue.TypeField of
              tpFieldInteger:
              begin
                if LProperties.GetValue(AClass).AsInteger > MaxLength(LAttributes).MaxLength then
                  raise Exception.Create(MaxLength(LAttributes).Messege);
              end;
              tpFieldString:
              begin
                if LProperties.GetValue(AClass).AsString.Length > MaxLength(LAttributes).MaxLength then
                  raise Exception.Create(MaxLength(LAttributes).Messege);
              end;
              tpFieldDate:
              begin
                if DateToStr(LProperties.GetValue(AClass).AsType<TDate>).Contains('30/12/1899') then
                  raise Exception.Create(NotNull(LAttributes).Messege);
              end;
              tpFieldDateTime:
              begin
                if DateTimeToStr(LProperties.GetValue(AClass).AsType<TDateTime>).Contains('30/12/1899') then
                  raise Exception.Create(NotNull(LAttributes).Messege);
              end;
              tpFieldCurrency:
              begin
                if LProperties.GetValue(AClass).AsCurrency <= 0 then
                  raise Exception.Create(NotNull(LAttributes).Messege);
              end;
              tpFieldList:
              begin

              end;
              else
              begin
                if LProperties.GetValue(AClass).AsString.IsEmpty then
                  raise Exception.Create(NotNull(LAttributes).Messege);
              end;
            end;
          end;
        end;
      end;
    except on E: Exception do
      begin
        raise Exception.Create(e.Message);
      end;
    end;
  finally
    LContext.Free;
  end;
end;

function TModelRTTIBind.ClassToDeleteSQL(AClass: TObject): String;
const
  SQL = 'DELETE FROM %s WHERE %S ;';
var
  LListFieldValue:TList<TFieldValue>;
  I: Integer;
  LTable:string;
  LWhere:string;
begin
  LWhere := EmptyStr;
  LTable := GetTable(AClass);
  LListFieldValue := ClassToFieldValue(AClass);
  try

    for I := 0 to Pred(LListFieldValue.Count) do
    begin
      if LListFieldValue[i].TypeField = tpFieldList then
        Continue;
      if (LListFieldValue[i].IsUnique) then
        Continue;
      if (LListFieldValue[i].IsPK) then
      begin
        if LWhere.IsEmpty then
          LWhere := LListFieldValue[i].Name+' = '+PrepareValues(LListFieldValue[i])
        else
          LWhere := LWhere + ' AND '+LListFieldValue[i].Name+' = '+PrepareValues(LListFieldValue[i]);
        Continue;
      end;
    end;
  finally
    LListFieldValue.Free;
  end;
  Result := Format(SQL,[LTable,LWhere]);
end;

function TModelRTTIBind.ClassToDeleteSQL(AClass: TObject;
  AFilter: string): String;
const
  SQL = 'DELETE FROM %s %S ;';
var
  LListFieldValue:TList<TFieldValue>;
  I: Integer;
  LTable:string;
  LWhere:string;
begin
  LWhere := EmptyStr;
  LTable := GetTable(AClass);
  LListFieldValue := ClassToFieldValue(AClass);
  try
    for I := 0 to Pred(LListFieldValue.Count) do
    begin
      if LListFieldValue[i].TypeField = tpFieldList then
        Continue;
      if (LListFieldValue[i].IsUnique) then
        Continue;
      if (LListFieldValue[i].IsPK) then
      begin
//        if LWhere.IsEmpty then
//          LWhere := LListFieldValue[i].Name+' = '+PrepareValues(LListFieldValue[i])
//        else
//          LWhere := LWhere + ' AND '+LListFieldValue[i].Name+' = '+PrepareValues(LListFieldValue[i]);
        Continue;
      end;
    end;
  finally
    LListFieldValue.Free;
  end;
  Result := Format(SQL,[LTable,AFilter]);
end;

function TModelRTTIBind.ClassToFieldValue(AClass:TObject;AValidateRequired:Boolean): TList<TFieldValue>;
var
  LContext:TRttiContext;
  LType:TRttiType;
  LAttributes:TCustomAttribute;
  LProperties:TRttiProperty;
  LFileValue:TFieldValue;
  LIsFieldDB: Boolean;
  FIsRequired:Boolean;
begin
  Result := TList<TFieldValue>.Create;
  if not (AClass is TClass) then Exit;
  LContext := TRttiContext.Create;
  try
    try
      LType := LContext.GetType(AClass.ClassType);
      for LProperties in LType.GetProperties do
      begin
        FIsRequired := False;
        LFileValue.IsPK := False;
        LFileValue.IsUnique := False;

        LIsFieldDB := False;
        LFileValue.Name := LProperties.Name;
        for LAttributes in LProperties.GetAttributes do
        begin
          if LAttributes is FieldDB then
          begin
            LIsFieldDB := True;
            if not FieldDB(LAttributes).FieldDB.Trim.IsEmpty then
              LFileValue.Name := FieldDB(LAttributes).FieldDB;
          end;

          if LAttributes is Required then
          begin
            FIsRequired := True;
          end;
        end;
        if not LIsFieldDB then
          Continue;

        for LAttributes in LProperties.GetAttributes do
        begin
          if LAttributes is TypeField then
          begin
            case TypeField(LAttributes).TypeField of
              tpFieldInteger:
              begin
                LFileValue.Value := EmptyStr;
                if LProperties.GetValue(AClass).AsInteger > 0 then
                  LFileValue.Value := IntToStr(LProperties.GetValue(AClass).AsInteger);
              end;
              tpFieldString:LFileValue.Value := LProperties.GetValue(AClass).AsString;
              tpFieldDate:LFileValue.Value := DateToStr(LProperties.GetValue(AClass).AsType<TDate>);
              tpFieldDateTime:LFileValue.Value := DateTimeToStr(LProperties.GetValue(AClass).AsType<TDateTime>);
              tpFieldCurrency:
              begin
                LFileValue.Value := EmptyStr;
                if LProperties.GetValue(AClass).AsCurrency > 0 then
                  LFileValue.Value := CurrToStr(LProperties.GetValue(AClass).AsCurrency).Replace('.','',[rfReplaceAll])
                                                                                        .Replace(',','.',[rfReplaceAll]);
              end;
              tpFieldList:
              begin

              end;
              else
              LFileValue.Value := LProperties.GetValue(AClass).AsString;
            end;
            LFileValue.TypeField := TypeField(LAttributes).TypeField;
          end;

          if LAttributes is PK then
            LFileValue.IsPK := True;
          if LAttributes is Unique then
            LFileValue.IsUnique := True;
        end;
        if (AValidateRequired) then
          if not FIsRequired and String(LFileValue.Value).IsEmpty then
            continue;
        Result.Add(LFileValue);
      end;
    except on E: Exception do
      begin
        Result.Clear;
        raise Exception.Create(e.Message);
      end;
    end;
  finally
    LContext.Free;
  end;
end;

function TModelRTTIBind.ClassToJSON(AClass: TObject): TJSONObject;
var
  LListData:TList<TJSONData>;
  I: Integer;
begin
  Result := nil;
  if not (AClass is TClass) then Exit;
  if not ValidateJSON(AClass) then Exit;
  Result := TJSONObject.Create;
  LListData := ClassToListJSONData(AClass);
  try
    for I := 0 to Pred(LListData.Count) do
    begin
      if LListData[i].Value.StartsWith('[') then
        Result.AddPair(LListData[i].Name,TJSONObject.ParseJSONValue(LListData[i].Value) AS TJSONArray)
      else if LListData[i].Value.StartsWith('{') then
        Result.AddPair(LListData[i].Name,TJSONObject.ParseJSONValue(LListData[i].Value) AS TJSONObject)
      else
        Result.AddPair(LListData[i].Name,LListData[i].Value);
    end;
  finally
    LListData.Free;
  end;
end;

function TModelRTTIBind.ClassToJSONString(AClass: TObject): String;
var
  Ljson:TJSONObject;
begin
  Ljson := ClassToJSON(AClass);
  try
    Result :=  TJson.Format(Ljson);
  finally
    Ljson.Free;
  end;
end;
function TModelRTTIBind.ClassToListFields(AClass:TClass): TDictionary<String,Integer>;
var
  LContext:TRttiContext;
  LType:TRttiType;
  LAttributes:TCustomAttribute;
  LProperties:TRttiProperty;
begin
  if not Assigned(AClass) then
    raise Exception.Create('Object is not Assigned');

  Result := TDictionary<String,Integer>.Create;
  LContext := TRttiContext.Create;
  try
    LType := LContext.GetType(TObject(AClass).ClassType);
    for LProperties in LType.GetProperties do
    begin
      for LAttributes in LProperties.GetAttributes do
      begin
        if LAttributes is ListCrud then
        begin
          Result.Add(ListCrud(LAttributes).Name,ListCrud(LAttributes).PorcentWidth);
          Break;
        end;
      end;
    end;
  finally
    LContext.Free;
  end;
end;

function TModelRTTIBind.ClassToPostSQL(AClass: TObject): String;
const
  SQL = 'INSERT INTO %s (%s) VALUES (%s);';
var
  LListFieldValue:TList<TFieldValue>;
  I: Integer;
  LTable:string;
  LField:string;
  LValue:string;
begin
  LField := EmptyStr;
  LValue := EmptyStr;
  LTable := EmptyStr;
  LTable := GetTable(AClass);
  Result := EmptyStr;
  if not ValidateFildValue(AClass) then Exit;
  LListFieldValue := ClassToFieldValue(AClass);
  try
    for I := 0 to Pred(LListFieldValue.Count) do
    begin
      if LListFieldValue[i].TypeField = tpFieldList then
        Continue;
      LField := LField + LListFieldValue[i].Name+', ';
      LValue := LValue + PrepareValues(LListFieldValue[i])+', ';
    end;
    LField := Copy(LField,1,LField.Length-2);
    LValue := Copy(LValue,1,LValue.Length-2);
    if LListFieldValue.Count > 0 then
      Result := Format(SQL,[LTable,LField,LValue]);
  finally
    LListFieldValue.Free;
  end;
end;

function TModelRTTIBind.ClassToPutSQL(AClass: TObject): String;
const
  SQL = 'UPDATE %s SET %s WHERE %S ;';
var
  LListFieldValue:TList<TFieldValue>;
  I: Integer;
  LTable:string;
  LFields:string;
  LWhere:string;
begin
  LFields := EmptyStr;
  LTable := EmptyStr;
  LWhere := EmptyStr;
  LTable := GetTable(AClass);
  Result := EmptyStr;
  if not ValidateFildValue(AClass) then Exit;
  LListFieldValue := ClassToFieldValue(AClass);
  try
    for I := 0 to Pred(LListFieldValue.Count) do
    begin
      if LListFieldValue[i].TypeField = tpFieldList then
        Continue;
      if (LListFieldValue[i].IsUnique) then
        Continue;
      if (LListFieldValue[i].IsPK) then
      begin
        if LWhere.IsEmpty then
          LWhere := LListFieldValue[i].Name+' = '+PrepareValues(LListFieldValue[i])
        else
          LWhere := LWhere + ' AND '+LListFieldValue[i].Name+' = '+PrepareValues(LListFieldValue[i]);
        Continue;
      end;
      LFields := LFields + LListFieldValue[i].Name+' = '+PrepareValues(LListFieldValue[i])+', ';
    end;

    LFields := Copy(LFields,1,LFields.Length-2);
    if LListFieldValue.Count > 0 then
      Result := Format(SQL,[LTable,LFields,LWhere]);
  finally
    LListFieldValue.Free;
  end;
end;

function TModelRTTIBind.ClassToSelectAllSQL(AClass: TObject): String;
const
  SQL = 'SELECT * FROM %s tb ;';
var
  LTable:string;
begin
  LTable := GetTable(AClass);
  {TODO -oOwner -cGeneral : Left join}
  var LLeft := EmptyStr;//GetWhereAndFK(AClass);
  Result := Format(SQL,[LTable]);
end;

function TModelRTTIBind.ClassToSelectAllSQL(AClass: TObject;
  AFilter: string): String;
const
  SQL = 'SELECT * FROM  %s tb %s;';
var
  LTable:string;
begin
  LTable := GetTable(AClass);
  Result := Format(SQL,[LTable,AFilter]);
end;

function TModelRTTIBind.ClassToSelectALLSQLCount(AClass: TObject;
  AFilter: string): String;
const
  SQL = 'SELECT COUNT (tb.%s) FROM %s tb %s';
var
  LTable:string;
  LPK:string;
begin
  AFilter := AFilter.ToUpper;
  LTable := GetTable(AClass);
  LPK := GetPK(AClass);
  if AFilter.Contains('ORDER BY') then
    AFilter := Copy(AFilter,1,Pos('ORDER BY',AFilter)-1).Trim;
  Result := Format(SQL,[LPK,LTable,AFilter]);
end;

function TModelRTTIBind.ClassToSelectPaginationSQL(AClass: TObject; AFirst, ASkip: Integer; AFilter:string): String;
const
  SQL = 'SELECT FIRST %s SKIP %s * FROM %s tb %s;';
var
  LTable:string;
begin
  LTable := GetTable(AClass);
  Result := Format(SQL,[AFirst.ToString,ASkip.ToString,LTable,AFilter]);
end;

function TModelRTTIBind.ClassToSelectPaginationSQL(AClass: TObject;AFirst,ASkip:Integer): String;
const
  SQL = 'SELECT FIRST %s SKIP %s tb.* FROM %s tb ;';
var
  LTable:string;
begin
  LTable := GetTable(AClass);
  Result := Format(SQL,[AFirst.ToString,ASkip.ToString,LTable]);
end;

function TModelRTTIBind.ClassToSelectALLSQLCount(AClass: TObject): String;
const
  SQL = 'SELECT COUNT (%s) FROM %s tb ;';
var
  LTable:string;
  LPK:string;
begin
  LTable := GetTable(AClass);
  LPK := GetPK(AClass);
  Result := Format(SQL,[LPK,LTable]);
end;

procedure TModelRTTIBind.DataSetToClass(ADataSet:TDataSet; AClass:TObject);
var
  LContext:TRttiContext;
  LType:TRttiType;
  LAttributes:TCustomAttribute;
  LProperties:TRttiProperty;
  LFileValue:TFieldValue;
  LIsFieldDB: Boolean;
  I: Integer;
begin
  if not Assigned(ADataSet) then
    raise Exception.Create('DataSet not assigned');
  if not ADataSet.Active then
    raise Exception.Create('DataSet not active');
  if not Assigned(AClass) then
    raise Exception.Create('List not assigned');

  LContext := TRttiContext.Create;
  try
    LType := LContext.GetType(TObject(AClass).ClassType);
    for LProperties in LType.GetProperties do
    begin
      LFileValue.IsPK := False;
      LFileValue.IsUnique := False;
      LIsFieldDB := False;
      LFileValue.Name := LProperties.Name;
      for LAttributes in LProperties.GetAttributes do
      begin
        if LAttributes is FieldDB then
        begin
          if not FieldDB(LAttributes).FieldDB.IsEmpty then
            LFileValue.Name := FieldDB(LAttributes).FieldDB;
          LIsFieldDB := True;
          Break;
        end;
      end;

      if not (LIsFieldDB) then
        Continue;

      for I:= 0 to Pred(ADataSet.FieldCount) do
      begin
        if LFileValue.Name.ToLower = ADataSet.Fields[i].FieldName.ToLower then
        begin
          LFileValue.Value := ADataSet.Fields[i].Value;
          Break;
        end;
      end;

      if LIsFieldDB then
      begin
        for LAttributes in LProperties.GetAttributes do
        begin
         if LAttributes is TypeField then
          begin
            case TypeField(LAttributes).TypeField of
              tpFieldInteger:LProperties.SetValue(AClass,StrToInt(LFileValue.Value));
              tpFieldString:LProperties.SetValue(AClass,String(LFileValue.Value));
              tpFieldDate:LProperties.SetValue(AClass,StrToDate(LFileValue.Value));
              tpFieldDateTime:LProperties.SetValue(AClass,StrToDateTime(LFileValue.Value));
              tpFieldCurrency:LProperties.SetValue(AClass,Double(LFileValue.Value));
              tpFieldList:
              begin
              end;
              else
                raise Exception.Create('TpField não informado');
            end;
          end;
        end;
      end;
    end;
  finally
    LContext.Free;
  end;
end;

function TModelRTTIBind.DateBRToDateEng(const ADate: TDateTime): string;
begin
  // Essa função esta sendo usada em somente um lugar - Refatorar
  Result := FormatDateTime('YYYY/MM/DD hh:mm:ss',ADate);
end;

initialization
finalization
  if Assigned(TModelRTTIBind.FInstance) then
    TModelRTTIBind.FInstance.Free;
end.
