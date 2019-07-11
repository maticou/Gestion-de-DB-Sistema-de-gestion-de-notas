import { Injectable } from '@angular/core';
import { HttpClient, HttpParams } from '@angular/common/http';
import { Observable } from 'rxjs';
import { environment as env } from '../../environments/environment';
import { map } from 'rxjs/operators';
import { Curso, VistaCurso } from '../clases/curso';

@Injectable({
  providedIn: 'root'
})
export class CursoService {

  constructor(private http: HttpClient) { }

  agregarCurso(data: Curso): Observable<boolean>{
    const body = new HttpParams()
    .set('codigo', data.codigo.toString())
    .set('nombre', data.nombre)
    .set('carrera', data.carrera)
    .set('ref_profesor', data.ref_profesor_ecargado)

    return this.http.put<{ msg: string}>(env.api.concat("/curso/agregar"), body)
    .pipe(
      map(result => {
        console.log(result.msg);
        return true;
      })
    );
  }

  obtenerDatosCurso(codigo: number): Observable<Curso>{
    return this.http.get<Curso>(env.api.concat("/curso/obtener/"+codigo))
    .pipe(
      map(result => {
        return result;
      })
    );
  }

  obtenerCursos(): Observable<Curso[]>{
    return this.http.get<Curso[]>(env.api.concat("/curso/obtener"))
    .pipe(
      map(result => {
        return result;
      })
    );
  }

  modificarCurso(data: Curso): Observable<boolean>{
    const body = new HttpParams()
    .set('codigo', data.codigo.toString())
    .set('nombre', data.nombre)
    .set('carrera', data.carrera)
    .set('ref_profesor_encargado', data.ref_profesor_ecargado)

    return this.http.post<{ msg: string}>(env.api.concat("/curso/modificar"), body)
    .pipe(
      map(result => {
        console.log(result);
        return true;
      })
    );
  }

  obtenerVistaCursos(): Observable<VistaCurso[]>{
    return this.http.get<VistaCurso[]>(env.api.concat("/curso/obtener/vista-alumno"))
    .pipe(
      map(result => {
        return result;
      })
    );
  }
}
