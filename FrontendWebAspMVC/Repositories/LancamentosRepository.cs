using FrontendWebAspMVC.Context;
using FrontendWebAspMVC.Models.Entities;
using FrontendWebAspMVC.Repositories.Interfaces;

namespace FrontendWebAspMVC.Repositories
{
    public class LancamentosRepository : ILancamentosRepository
    {
        private readonly ControlPlusContext _context;
        public LancamentosRepository(ControlPlusContext context)
        {
            _context = context;
            
        }
        public IEnumerable<Lancamento> Lancamentos => _context.Lancamentos;

        void ILancamentosRepository.Save(Lancamento model)
        {
            model.Id = Guid.NewGuid().ToString();
            _context.Lancamentos.Add(model);
            _context.SaveChanges();
        }
    }
}
