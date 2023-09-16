unit Entity.Operacoes;

interface
uses
  Entity.Base,
  System.SysUtils,
  Model.RTTI.Attributes;
  type
  [Table('lancamentos_operacoes')]
  TEntityoperacoes = class(TEntityBase)
  private
    FDescricao: string;
    FId: string;
    procedure SetDescricao(const Value: string);
    procedure SetId(const Value: string);

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
  end;
implementation

{ TEntityoperacoes }

procedure TEntityoperacoes.SetDescricao(const Value: string);
begin
  FDescricao := Value;
end;

procedure TEntityoperacoes.SetId(const Value: string);
begin
  FId := Value;
end;

end.
