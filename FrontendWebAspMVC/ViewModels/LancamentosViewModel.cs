using FrontendWebAspMVC.Models.Entities;

namespace FrontendWebAspMVC.ViewModels
{
    public class LancamentosViewModel
    {
        public IEnumerable<Lancamento> Lancamentos {get; set;}
        public IEnumerable<Cartoes> Cartoes {get; set;}
        public  IEnumerable<Bancos> Bancos { get; set;}        
        public IEnumerable<Operacoes> Operacoes { get; set; }
        public IEnumerable<Dependentes> Dependentes { get; set;}
    }
}
