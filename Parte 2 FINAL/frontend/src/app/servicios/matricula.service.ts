import { Injectable } from '@angular/core';
import { HttpClient, HttpHeaders, HttpParams } from '@angular/common/http';
import { environment as env } from '../../environments/environment';
import { map } from 'rxjs/operators';
import { Observable } from "rxjs";
import { Matricula } from '../clases/matricula';

@Injectable({
  providedIn: 'root'
})
export class MatriculaService {
  constructor(private http: HttpClient) { 

  }

  agregarMatricula(data: Matricula): Observable<boolean>{
    const body = new HttpParams()
    .set('codigo_matricula', '0')
    .set('nota_final', '0')
    .set('ref_alumno', data.ref_alumno.toString())
    .set('ref_instancia_curso', data.ref_instancia_curso.toString())
    .set('situacion', 'CURSANDO')

    console.log(body);
    return this.http.put<{ msg: string}>(env.api.concat("/matricula/agregar"), body)
    .pipe(
      map(result => {
        console.log(result.msg);
        return true;
      })
    );
  }
}
