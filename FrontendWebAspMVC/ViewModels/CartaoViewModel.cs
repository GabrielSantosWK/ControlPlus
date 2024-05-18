using FrontendWebAspMVC.Models.Entities;
namespace FrontendWebAspMVC.ViewModels
{
    public class CartaoViewModel
    {
        public Cartoes Cartao { get; set; }
        public IEnumerable<Bancos> Bancos { get; set; }
    }
}
