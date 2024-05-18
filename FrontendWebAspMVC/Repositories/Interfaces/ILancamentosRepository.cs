using FrontendWebAspMVC.Models.Entities;
using Microsoft.EntityFrameworkCore.Diagnostics;

namespace FrontendWebAspMVC.Repositories.Interfaces
{
    public interface ILancamentosRepository
    {
        public IEnumerable<Lancamento> Lancamentos { get; }
        public void Save(Lancamento model);
    }
}
