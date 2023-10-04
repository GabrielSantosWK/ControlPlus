import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { lancamento } from 'src/app/lancamentos/lancamento';
@Injectable({
  providedIn: 'root'
})
export class LancamentoService {

  private readonly API = 'http://192.168.237.64:9000/lancamentos'; 
  constructor(private http:HttpClient) { }
  listar():Observable<lancamento>{   
    let returnObject = this.http.get<lancamento>(this.API);
    return returnObject;
  }
}
