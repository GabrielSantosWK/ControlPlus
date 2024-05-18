namespace FrontendWebAspMVC.Models.Entities
{
    public class Cartoes
    {
        public string Id { get; set; }
        public string Descricao { get; set; }
        public Decimal Limite { get; set; }
        public string BancoId { get; set; }
       
        public int DiaVencimento { get; set; }
    }
}
