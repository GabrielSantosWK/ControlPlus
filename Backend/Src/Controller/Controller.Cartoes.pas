unit Controller.Cartoes;

interface
uses
  Horse,
  SYStem.JSON,
  Model.DAO.Cartoes;

procedure Listar(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure Obter(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure Deletar(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure Incluir(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure Alterar(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure Registry;

implementation

procedure Listar(Req: THorseRequest; Res: THorseResponse; Next: TProc);
begin
  var LModelDaoCartao := TModelDAOCartoes.Create;
  try
    LModelDaoCartao.Get;
    Res.Send(LModelDaoCartao.ToJsonData);
  finally
    LModelDaoCartao.Free;
  end;
end;

procedure Obter(Req: THorseRequest; Res: THorseResponse; Next: TProc);
begin
  var LModelDaoCartao := TModelDAOCartoes.Create;
  try
    LModelDaoCartao.Get(Req.Params.Items['id']);
    Res.Send(LModelDaoCartao.ToJsonData);
  finally
    LModelDaoCartao.Free;
  end;
end;

procedure Deletar(Req: THorseRequest; Res: THorseResponse; Next: TProc);
begin
  var LModelDaoCartao := TModelDAOCartoes.Create;
  try
    LModelDaoCartao.Entity.Id := Req.Params.Items['id'];
    LModelDaoCartao.Delete;
    Res.Send(LModelDaoCartao.ToJsonData);
  finally
    LModelDaoCartao.Free;
  end;
end;

procedure Incluir(Req: THorseRequest; Res: THorseResponse; Next: TProc);
begin
  var LModelDaoCartao := TModelDAOCartoes.Create;
  try
    LModelDaoCartao.Entity.JSONToClass(Req.Body<TJSONObject>,False);
    LModelDaoCartao.Insert;
    Res.Send(LModelDaoCartao.Entity.ClassToJSON).Status(THTTPStatus.Created);
  finally
    LModelDaoCartao.Free;
  end;
end;

procedure Alterar(Req: THorseRequest; Res: THorseResponse; Next: TProc);
begin
  var LModelDaoCartao := TModelDAOCartoes.Create;
  try
    LModelDaoCartao.Entity.JSONToClass(Req.Body<TJSONObject>,False);
    LModelDaoCartao.Update;
    Res.Send(LModelDaoCartao.Entity.ClassToJSON).Status(THTTPStatus.Ok);
  finally
    LModelDaoCartao.Free;
  end;
end;

procedure Registry;
begin
  THorse.Get('cartoes', Listar);
  THorse.Delete('cartoes/:id', Deletar);
  THorse.Post('cartoes', Incluir);
  THorse.Put('cartoes/:id', Alterar);
end;
end.
