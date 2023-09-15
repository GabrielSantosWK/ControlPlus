unit Entity.Lancamentos;

interface
uses
  Entity.Base,
  System.SysUtils,
  Model.RTTI.Attributes, Entity.Cartoes;
  type
  [Table('lancamentos')]
  TEntityLancamentos = class(TEntityBase)
  private
    FIdCartao: string;
    FValor: Currency;
    FDataVencimento: TDate;
    FId: string;
    FIdOperacao: string;
    FDataLancamento: TDate;
    FIdDependente: string;
    FCartao: TEntityCartoes;
    procedure SetDataLancamento(const Value: TDate);
    procedure SetDataVencimento(const Value: TDate);
    procedure SetId(const Value: string);
    procedure SetIdCartao(const Value: string);
    procedure SetIdDependente(const Value: string);
    procedure SetIdOperacao(const Value: string);
    procedure SetValor(const Value: Currency);
    procedure SetCartao(const Value: TEntityCartoes);
  public

  constructor Create();
  destructor Destroy;override;

  [FieldDB('id')]
  [FieldJSON('id')]
  [TypeField(tpFieldString)]
  [Pk]
  property Id:string read FId write SetId;

  [FieldDB('Id_Cartao')]
  [FieldJSON('IdCartao')]
  [TypeField(tpFieldString)]
  property IdCartao:string read FIdCartao write SetIdCartao;

  [TypeField(tpFieldObject)]
  [FK('cartoes','Id_Cartao')]
  property Cartao:TEntityCartoes read FCartao write SetCartao;


  [FieldDB('Id_Dependente')]
  [FieldJSON('IdDependente')]
  [TypeField(tpFieldString)]
  property IdDependente:string read FIdDependente write SetIdDependente;

  [FieldDB('Data_Lancamento')]
  [FieldJSON('DataLancamento')]
  [TypeField(tpFieldDate)]
  property DataLancamento:TDate read FDataLancamento write SetDataLancamento;

  [FieldDB('Data_Vencimento')]
  [FieldJSON('DataVencimento')]
  [TypeField(tpFieldDate)]
  property DataVencimento:TDate read FDataVencimento write SetDataVencimento;

  [FieldDB('Valor')]
  [FieldJSON('Valor')]
  [TypeField(tpFieldCurrency)]
  property Valor:Currency read FValor write SetValor;

  [FieldDB('Id_Operacao')]
  [FieldJSON('IdOperacao')]
  [TypeField(tpFieldString)]
  property IdOperacao:string read FIdOperacao write SetIdOperacao;


  end;
implementation

{ TEntityLancamentos }

constructor TEntityLancamentos.Create;
begin
  FCartao := TEntityCartoes.Create;
end;

destructor TEntityLancamentos.Destroy;
begin
  FCartao.Free;
  inherited;
end;

procedure TEntityLancamentos.SetCartao(const Value: TEntityCartoes);
begin
  FCartao := Value;
end;

procedure TEntityLancamentos.SetDataLancamento(const Value: TDate);
begin
  FDataLancamento := Value;
end;

procedure TEntityLancamentos.SetDataVencimento(const Value: TDate);
begin
  FDataVencimento := Value;
end;

procedure TEntityLancamentos.SetId(const Value: string);
begin
  FId := Value;
end;

procedure TEntityLancamentos.SetIdCartao(const Value: string);
begin
  FIdCartao := Value;
end;

procedure TEntityLancamentos.SetIdDependente(const Value: string);
begin
  FIdDependente := Value;
end;

procedure TEntityLancamentos.SetIdOperacao(const Value: string);
begin
  FIdOperacao := Value;
end;

procedure TEntityLancamentos.SetValor(const Value: Currency);
begin
  FValor := Value;
end;

end.
