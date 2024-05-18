using FrontendWebAspMVC.Models.Entities;
using FrontendWebAspMVC.Repositories.Interfaces;
using FrontendWebAspMVC.ViewModels;
using Microsoft.AspNetCore.Mvc;

namespace FrontendWebAspMVC.Controllers
{
    public class CartaoController : Controller
    {
        private readonly ICartoesRepository _cartoesRepository;
        private readonly IBancosRepository _bancosRepository;

        public CartaoController(ICartoesRepository cartoesRepository, IBancosRepository bancosRepository)
        {
            _cartoesRepository = cartoesRepository;
            _bancosRepository = bancosRepository;
        }

        public IActionResult Index(string id)
        {
            CartaoViewModel cartaoViewModel = new CartaoViewModel();
            cartaoViewModel.Bancos = _bancosRepository.Bancos;
            if (! string.IsNullOrEmpty(id)) {
                
                cartaoViewModel.Cartao = _cartoesRepository.Cartoes.FirstOrDefault(x => x.Id == id);
            }
            return View(cartaoViewModel);
        }
        public IActionResult List()
        {
            var cartoes = _cartoesRepository.Cartoes;
            return View(cartoes); 
        }

        [HttpPost]
        public IActionResult CadastrarCartao(Cartoes cartao) 
        {
            if (cartao.Id == null)
            {
                _cartoesRepository.Cadastrar(cartao);
            }
            else {
                _cartoesRepository.Alterar(cartao);
            }
            
            return RedirectToAction("List");
        }
        
        public IActionResult DeletarCartao(string id)
        {
            _cartoesRepository.Deletar(id);

            return RedirectToAction("List");
        }
    }
}
