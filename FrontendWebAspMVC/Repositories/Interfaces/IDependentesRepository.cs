using FrontendWebAspMVC.Models.Entities;

namespace FrontendWebAspMVC.Repositories.Interfaces
{
    public interface IDependentesRepository
    {
        public IEnumerable<Dependentes> Dependentes { get; }
    }
}
