import { Component,OnInit } from '@angular/core';
import { LancamentoService } from './lancamento.service';
import { lancamento } from 'src/app/lancamentos/lancamento';
import { LancamentoItem } from 'src/app/lancamentos/lancamentoItem';

@Component({
  selector: 'app-lancamento',
  templateUrl: './lancamento.component.html',
  styleUrls: ['./lancamento.component.css']
})
export class LancamentoComponent implements OnInit {
  listaLancamento:LancamentoItem[] = [];
  
  
  constructor(private service:LancamentoService){}
  ngOnInit(): void {
    this.service.listar().subscribe((lista)=>
    {
      
      //this.listaLancamento = lista.data;     
      this.listaLancamento = lista.data;
      console.log('item');
      console.log(lista.data);
    }
    ); 
  }
}
