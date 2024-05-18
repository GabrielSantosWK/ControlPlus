using FrontendWebAspMVC.Context;
using FrontendWebAspMVC.Models.Entities;
using FrontendWebAspMVC.Repositories.Interfaces;

namespace FrontendWebAspMVC.Repositories
{
    public class OperacoesRepository:IOperacoesRepository
    {
        private readonly ControlPlusContext _context;
        public OperacoesRepository(ControlPlusContext context)
        {
            _context = context;
        }
        public IEnumerable<Operacoes> Operacoes => _context.Operacoes;
    }
}
