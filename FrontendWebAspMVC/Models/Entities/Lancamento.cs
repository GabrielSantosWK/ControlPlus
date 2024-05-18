namespace FrontendWebAspMVC.Models.Entities
{
    public class Lancamento
    {
        public string Id { get; set; }
        public string CartaoId { get; set; }
        public string DependenteId { get; set; }
        public DateTime DataLancamento { get; set; }
        public DateTime DataVencimento { get; set; }
        public Decimal Valor { get; set; }
        public string OperacaoId { get; set; }
        public string Descricao { get; set; }
        public bool ContaCasal { get; set; }
    }
}
