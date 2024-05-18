using FrontendWebAspMVC.Context;
using FrontendWebAspMVC.Models.Entities;
using FrontendWebAspMVC.Repositories.Interfaces;

namespace FrontendWebAspMVC.Repositories
{
    public class CartoesRepository:ICartoesRepository
    {
        private readonly ControlPlusContext _context;
        public CartoesRepository(ControlPlusContext context)
        {
            _context = context;
        }

        IEnumerable<Cartoes> ICartoesRepository.Cartoes => _context.Cartoes;

        void ICartoesRepository.Alterar(Cartoes cartao)
        {            
            _context.Cartoes.Update(cartao);
            _context.SaveChanges();
        }

        void ICartoesRepository.Cadastrar(Cartoes cartao)
        {
            cartao.Id = Guid.NewGuid().ToString();
            _context.Cartoes.Add(cartao);
            _context.SaveChanges();
        }

        void ICartoesRepository.Deletar(string id)
        {
            var _cartao = _context.Cartoes.FirstOrDefault(x => x.Id == id);
            if (_cartao != null)
            {
                _context.Remove(_cartao);
                _context.SaveChanges();

            }            
            
        }
    }
}
