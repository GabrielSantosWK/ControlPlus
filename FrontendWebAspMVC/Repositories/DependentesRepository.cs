using FrontendWebAspMVC.Context;
using FrontendWebAspMVC.Models.Entities;
using FrontendWebAspMVC.Repositories.Interfaces;

namespace FrontendWebAspMVC.Repositories
{
    public class DependentesRepository:IDependentesRepository
    {
        private readonly ControlPlusContext _context;
        public DependentesRepository(ControlPlusContext context)
        {
            _context = context;
        }

        public IEnumerable<Dependentes> Dependentes => _context.Dependentes;
    }
}
