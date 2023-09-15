unit Controller.Lancamento;

interface
uses
  Horse,
  SYStem.JSON,
  Model.DAO.Lancamentos;

procedure Listar(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure Obter(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure Deletar(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure Incluir(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure Alterar(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure Registry;

implementation

procedure Listar(Req: THorseRequest; Res: THorseResponse; Next: TProc);
begin
  var LModelDaoLancamento := TModelDAOLancamentos.Create;
  try
    LModelDaoLancamento.Get;
    Res.Send(LModelDaoLancamento.ToJsonData);
  finally
    LModelDaoLancamento.Free;
  end;
end;

procedure Obter(Req: THorseRequest; Res: THorseResponse; Next: TProc);
begin
  var LModelDaoLancamento := TModelDAOLancamentos.Create;
  try
    LModelDaoLancamento.Get(Req.Params.Items['id']);
    Res.Send(LModelDaoLancamento.ToJsonData);
  finally
    LModelDaoLancamento.Free;
  end;
end;

procedure Deletar(Req: THorseRequest; Res: THorseResponse; Next: TProc);
begin
  var LModelDaoLancamento := TModelDAOLancamentos.Create;
  try
    LModelDaoLancamento.Entity.Id := Req.Params.Items['id'];
    LModelDaoLancamento.Delete;
    Res.Send(LModelDaoLancamento.ToJsonData);
  finally
    LModelDaoLancamento.Free;
  end;
end;

procedure Incluir(Req: THorseRequest; Res: THorseResponse; Next: TProc);
begin
  var LModelDaoLancamento := TModelDAOLancamentos.Create;
  try
    LModelDaoLancamento.Entity.JSONToClass(Req.Body<TJSONObject>,False);
    LModelDaoLancamento.Insert;
    Res.Send(LModelDaoLancamento.Entity.ClassToJSON).Status(THTTPStatus.Created);
  finally
    LModelDaoLancamento.Free;
  end;
end;

procedure Alterar(Req: THorseRequest; Res: THorseResponse; Next: TProc);
begin
  var LModelDaoLancamento := TModelDAOLancamentos.Create;
  try
    LModelDaoLancamento.Entity.JSONToClass(Req.Body<TJSONObject>,False);
    LModelDaoLancamento.Update;
    Res.Send(LModelDaoLancamento.Entity.ClassToJSON).Status(THTTPStatus.Ok);
  finally
    LModelDaoLancamento.Free;
  end;
end;

procedure Registry;
begin
  THorse.Get('lancamentos', Listar);
  THorse.Delete('lancamentos/:id', Deletar);
  THorse.Post('lancamentos', Incluir);
  THorse.Put('lancamentos/:id', Alterar);
end;

end.
