using FrontendWebAspMVC.Models.Entities;

namespace FrontendWebAspMVC.Repositories.Interfaces
{
    public interface ICartoesRepository
    {
        public IEnumerable<Cartoes> Cartoes { get; }
        public void Cadastrar(Cartoes cartao);
        public void Alterar(Cartoes cartao);
        public void Deletar(string Id);
    }
}
