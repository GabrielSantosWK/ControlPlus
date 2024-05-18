using FrontendWebAspMVC.Models.Entities;

namespace FrontendWebAspMVC.Repositories.Interfaces
{
    public interface IBancosRepository
    {
        public IEnumerable<Bancos> Bancos { get; }
    }
}
