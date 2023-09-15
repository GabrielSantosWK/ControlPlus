unit Entity.Dependentes;

interface

uses
  Entity.Base,
  System.SysUtils,
  Model.RTTI.Attributes;

type

  [Table('dependentes')]
  TEntityDependentes = class(TEntityBase)
  private
    FNome: string;
    FId: string;
    procedure SetNome(const Value: string);
    procedure SetId(const Value: string);

  public
    [FieldDB('id')]
    [FieldJSON('id')]
    [TypeField(tpFieldString)]
    [Pk]
    property Id: string read FId write SetId;

    [FieldDB]
    [FieldJSON]
    [TypeField(tpFieldString)]
    property Nome: string read FNome write SetNome;
  end;

implementation

{ TEntityDependentes }

procedure TEntityDependentes.SetNome(const Value: string);
begin
  FNome := Value;
end;

procedure TEntityDependentes.SetId(const Value: string);
begin
  FId := Value;
end;

end.
