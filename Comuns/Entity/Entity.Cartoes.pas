unit Entity.Cartoes;

interface
uses
  Entity.Base,
  System.SysUtils,
  Model.RTTI.Attributes;
  type
  [Table('cartoes')]
  TEntityCartoes = class(TEntityBase)
  private
    FDescricao: string;
    FId: string;
    FVencimento: Integer;
    procedure SetDescricao(const Value: string);
    procedure SetId(const Value: string);
    procedure SetVencimento(const Value: Integer);

  public
  [FieldDB('id')]
  [FieldJSON('id')]
  [TypeField(tpFieldString)]
  [Pk]
  property Id:string read FId write SetId;

  [FieldDB]
  [FieldJSON]
  [TypeField(tpFieldString)]
  property Descricao:string read FDescricao write SetDescricao;

  [FieldDB('dia_vencimento')]
  [FieldJSON]
  [TypeField(tpFieldInteger)]
  property Vencimento: Integer read FVencimento write SetVencimento;

  end;
implementation

{ TEntityCartoes }

procedure TEntityCartoes.SetDescricao(const Value: string);
begin
  FDescricao := Value;
end;

procedure TEntityCartoes.SetId(const Value: string);
begin
  FId := Value;
end;

procedure TEntityCartoes.SetVencimento(const Value: Integer);
begin
  if Length(Value.ToString) > 2  then
    raise Exception.Create('Dia do vencimento inválido');
  if (Value <= 0) or (Value > 31) then
    raise Exception.Create('Dia do vencimento inválido');
  FVencimento := Value;
end;

end.
