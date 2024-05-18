using FrontendWebAspMVC.Models.Entities;
using FrontendWebAspMVC.Repositories.Interfaces;
using FrontendWebAspMVC.ViewModels;
using Microsoft.AspNetCore.Mvc;
using System.Diagnostics.CodeAnalysis;

namespace FrontendWebAspMVC.Controllers
{
    public class LancamentoController : Controller
    {
        private readonly ILancamentosRepository _lancamentosRepository;
        private readonly ICartoesRepository _cartoesRepository;
        private readonly IOperacoesRepository _operacaoRepository;
        private readonly IDependentesRepository _dependentesRepository;
        public LancamentoController(ILancamentosRepository lancamentosRepository, ICartoesRepository cartoesRepository, IOperacoesRepository operacaoRepository, IDependentesRepository dependentesRepository)
        {
            _lancamentosRepository = lancamentosRepository;
            _cartoesRepository = cartoesRepository;
            _operacaoRepository = operacaoRepository;
            _dependentesRepository = dependentesRepository;
        }
        public IActionResult Index()
        {

            var lancamentoViewModel = new LancamentosViewModel();
            lancamentoViewModel.Lancamentos = _lancamentosRepository.Lancamentos;
            lancamentoViewModel.Cartoes = _cartoesRepository.Cartoes;
            lancamentoViewModel.Operacoes= _operacaoRepository.Operacoes;
            lancamentoViewModel.Dependentes = _dependentesRepository.Dependentes;
            return View(lancamentoViewModel);
        }
        [HttpPost]
        public IActionResult CadastrarLancamentos(Lancamento model)
        {            
            model.ContaCasal = false;
            //model.OperacaoId = "C1F82DF6-F460-46CF-A2B3-E3AE80D641D1";            
            _lancamentosRepository.Save(model);
            return RedirectToAction("List");
        }
        public IActionResult List()
        {

            var lancamento = _lancamentosRepository.Lancamentos;            
            return View(lancamento);
        }
    }
}
