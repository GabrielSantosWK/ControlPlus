using FrontendWebAspMVC.Context;
using FrontendWebAspMVC.Models.Entities;
using FrontendWebAspMVC.Repositories.Interfaces;

namespace FrontendWebAspMVC.Repositories
{
    public class BancosRepository : IBancosRepository
    {
        private readonly ControlPlusContext _context;
        public BancosRepository(ControlPlusContext context)
        {
            _context = context;
        }
        public IEnumerable<Bancos> Bancos => _context.Bancos; 
    }
}
