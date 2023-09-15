unit Model.Client;

interface

uses
  System.JSON,
  REST.Types,
  REST.Client,
  System.SysUtils,
  System.Net.HttpClient,
  System.Net.Mime,
  REST.HttpClient,
  System.Generics.Collections,
  System.Classes, System.Net.URLClient, Model.Connection.Net;

type
  TResultRequest = record
    Code:Integer;
    MessageResult:string;
    ListError:TList<String>;
    ArrayError:String;
  end;

  TModelClient = class
  protected
    FClient: TRestClient;
    FRequest: TRestRequest;
    FResponse: TRestResponse;
    FURLBase: string;
    FResource: string;
    FBody: String;
    FMethod: TRESTRequestMethod;
    FId: string;
    FListQueryParams: TDictionary<string, string>;
    FlistHeaderParams: TDictionary<string, string>;
    FListFile: TDictionary<string, string>;
    FCode:Integer;
    FMessage:string;
    FListErrors:TList<String>;
    function GetResult(AContent: string):TResultRequest;
    function Execute(): TJSONValue;
    function AddQueryParams: string;overload;
  public
    constructor Create();
    destructor Destroy(); override;
    function AddHeaderParams(AField: string; AValue: string): TModelClient;
    function ClearHeaderParams: TModelClient;
    function AddQueryParams(AField: string; AValue: string): TModelClient;overload;
    function ClearQueryParams:TModelClient;
    function AddFile(AField: string; AValue: string): TModelClient;
    function URLBase(AValue: String): TModelClient; overload;
    function Resource(AValue: String): TModelClient;
    function Get(): TJSONValue;
    function Post(ABory: String): TJSONObject;
    function Put(ABory: String): TJSONObject;
    function Delete(ABory: String): TJSONObject;
    function StatusCode:Integer;
    function Messege:string;
  private
    function URLBase: String; overload;
  end;

implementation

{ TModelClient }

function TModelClient.AddQueryParams: string;
var
  LKey: string;
  LCount: Integer;
  LSeparador: string;
begin
  LCount := 0;
  Result := '';
  for LKey in FListQueryParams.Keys do
  begin
    LSeparador := '?';
    if LCount > 0 then
      LSeparador := '&';
    Result := Result + LSeparador + LKey + '=' + FListQueryParams.Items[LKey];
    Inc(LCount);
  end;
  FListQueryParams.Clear;
end;

function TModelClient.AddFile(AField, AValue: string): TModelClient;
begin
  Result := Self;
  FListFile.Add(AField,AValue);
end;

function TModelClient.AddHeaderParams(AField, AValue: string): TModelClient;
begin
  Result := Self;
  FListHeaderParams.Add(AField, AValue);
end;

function TModelClient.AddQueryParams(AField, AValue: string): TModelClient;
begin
  Result := Self;
  FListQueryParams.Add(AField,AValue);
end;

function TModelClient.ClearHeaderParams: TModelClient;
begin
  Result := Self;
  FlistHeaderParams.Clear;
end;

function TModelClient.ClearQueryParams: TModelClient;
begin
  Result := Self;
  FListQueryParams.Clear;
end;

constructor TModelClient.Create;
begin
  FListQueryParams := TDictionary<string, string>.Create;
  FListHeaderParams := TDictionary<string, string>.Create;
  FListFile := TDictionary<string, string>.Create;
  FClient := TRestClient.Create(nil);
  FRequest := TRestRequest.Create(nil);
  FResponse := TRestResponse.Create(nil);

  FRequest.Client := FClient;
  FRequest.Response := FResponse;

  URLBase('http://127.0.0.1:8081/v1/');
  //URLBase('http://192.168.10.139:8081/v1/');
  //URLBase('http://192.168.1.15:8081/v1/') //Jeferson
  //URLBase('http://192.168.1.36:8081/v1/'); // Tester
  //URLBase('http://192.168.237.70:8081/v1/'); // PC MESA
  //URLBase('http://192.168.237.64:8081/v1/'); // Notebook
end;

function TModelClient.Delete(ABory: String): TJSONObject;
begin
  FMethod := TRESTRequestMethod.rmDELETE;
  FBody := ABory;
  Result := TJSONObject(Execute);
end;

destructor TModelClient.Destroy;
begin
  FreeAndNil(FListQueryParams);
  FreeAndNil(FListHeaderParams);
  FreeAndNil(FListFile);
  FreeAndNil(FClient);
  FreeAndNil(FRequest);
  FreeAndNil(FResponse);
  inherited;
end;

function TModelClient.Execute: TJSONValue;
var
  LBoryJSON: TJSONValue;
  LResultRequest:TResultRequest;
  LKey:string;
  LJSONArray:TJSONArray;
  I: Integer;
  LJSONRequest:string;
  LRequest: THTTPClient;
  LFormData: TMultipartFormData;
  LResponse: TStringStream;
begin
  if not TModelConnectionNet.CheckInternet then
    raise Exception.Create('Dispositivo sem acesso a internet');
  FRequest.Method := FMethod;
  FRequest.Params.Clear;
  FRequest.AddParameter('Content-Type', 'application/json', pkHTTPHEADER, []);

  for LKey in FListHeaderParams.Keys do
    FRequest.AddParameter(LKey, FListHeaderParams.Items[LKey], pkHTTPHEADER, [poDoNotEncode]);

  FListFile.Clear;
  FListHeaderParams.Clear;
  FClient.BaseURL := URLBase + FResource + FId + AddQueryParams;
  LBoryJSON := TJSONValue.ParseJSONValue(FBody) as TJSONObject;
  try
    FRequest.Body.ClearBody;
    if LBoryJSON <> nil then
      FRequest.Body.Add(LBoryJSON.ToJSON,TRESTContentType.ctAPPLICATION_JSON);

    try
      FRequest.Execute;
    except on E: Exception do
      begin
        FCode := 500;
        if not FResponse.Content.IsEmpty then
        begin
          var LJson := TJSONObject.ParseJSONValue(FResponse.Content) as TJSONObject;
          try
            if Assigned(LJson) then
            begin
              var LMensagem:string;
              LJson.TryGetValue<string>('mensagem',LMensagem);
              if LMensagem.IsEmpty then
                LMensagem := E.Message;
              FMessage := LMensagem;
            end;
          finally
            LJson.Free;
          end;
        end
        else
          FMessage := E.Message;
        Result := TJSONObject.Create;
        Exit;
      end;
    end;

    LResultRequest := GetResult(FResponse.Content);

    LJSONRequest := EmptyStr;
    if Assigned(LBoryJSON) then
      LJSONRequest := LBoryJSON.ToJSON();


    if not LResultRequest.ArrayError.IsEmpty then
    begin
      LJSONArray := TJSONArray.ParseJSONValue(LResultRequest.ArrayError) as TJSONArray;
      try
        for i := 0 to Pred(LJSONArray.Count) do
        begin
          //ViewComponentsMessege.ListError.Add((LJSONArray.Items[i] as TJSONObject).GetValue('message').Value);
        end;
      finally
        LJSONArray.Free;
      end;
    end;

    FCode := LResultRequest.Code;
    FMessage := LResultRequest.MessageResult;
    Result := TJSONObject.ParseJSONValue(FResponse.Content);
  finally
    FreeAndNil(LBoryJSON);
  end;
end;

function TModelClient.Get: TJSONValue;
begin
  FMethod := TRESTRequestMethod.rmGET;
  FId := EmptyStr;
  Result := Execute;
end;

function TModelClient.GetResult(AContent: string):TResultRequest;
var
  LJsonObject: TJSONValue;
  LResultRequest:TResultRequest;
  LJSONArray:TJSONArray;
begin
  LResultRequest.ArrayError := EmptyStr;
  LResultRequest.Code := FResponse.StatusCode;

  LJsonObject := TJSONObject.ParseJSONValue(AContent);
  try
    LJsonObject.TryGetValue<Integer>('code', LResultRequest.Code);
    LJsonObject.TryGetValue<string>('mensagem', LResultRequest.MessageResult);
    if LJsonObject.TryGetValue<TJSONArray>('errors', LJSONArray) then
      LResultRequest.ArrayError := LJSONArray.ToJSON();
    if LResultRequest.Code <= 0 then
      LResultRequest.Code := 200;
    Result := LResultRequest;
  finally
    LJsonObject.Free;
  end;
end;

function TModelClient.Messege: string;
begin
  Result := FMessage;
end;

function TModelClient.Post(ABory: String): TJSONObject;
begin
  FId := EmptyStr;
  FMethod := TRESTRequestMethod.rmPOST;
  FBody := ABory;
  Result := TJSONObject(Execute);
end;

function TModelClient.Put(ABory: String): TJSONObject;
begin
  FMethod := TRESTRequestMethod.rmPUT;
  FBody := ABory;
  Result := TJSONObject(Execute);
end;

function TModelClient.Resource(AValue: String): TModelClient;
begin
  Result := Self;
  FResource := AValue;
end;

function TModelClient.StatusCode: Integer;
begin
  Result := FCode;
end;

function TModelClient.URLBase: String;
begin
  Result := FURLBase;
end;

function TModelClient.URLBase(AValue: String): TModelClient;
begin
  Result := Self;
  FURLBase := AValue;
end;

end.

