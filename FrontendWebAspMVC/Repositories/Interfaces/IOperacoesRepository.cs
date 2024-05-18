using FrontendWebAspMVC.Models.Entities;

namespace FrontendWebAspMVC.Repositories.Interfaces
{
    public interface IOperacoesRepository
    {
        public IEnumerable<Operacoes> Operacoes { get; }
    }
}
